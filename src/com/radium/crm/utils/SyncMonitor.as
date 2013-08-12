package com.radium.crm.utils
{
	
	import com.adobe.air.filesystem.*;
	import com.adobe.air.filesystem.events.FileMonitorEvent;
	import com.greensock.TimelineLite;
	import com.radium.crm.controller.commands.LoadContactsCommand;
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.DeviceInfoVO;
	import com.radium.crm.signals.LoadContactsSignal;
	import com.radium.crm.signals.LogCallsSignal;
	import com.radium.crm.signals.LogSMSSignal;
	import com.radium.crm.signals.PhoneSelectedSignal;
	import com.radium.crm.signals.SelectPhoneSignal;
	import com.radium.crm.view.components.AboutPage;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Monitors changes in the sync files and locates the relevant files and directories.
	 */
	
	public class SyncMonitor extends Actor
	{
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var errorManager:ErrorManager ;
		
		[Inject]
		public var logCallsSignal:LogCallsSignal ;
		
		[Inject]
		public var logSMSSignal:LogSMSSignal ;
		
		[Inject]
		public var selectPhoneSignal:SelectPhoneSignal ;
		
		[Inject]
		public var phoneSelectedSignal:PhoneSelectedSignal ;
		
		[Inject]
		public var loadContactsSignal:LoadContactsSignal ;
		
		[Inject]
		public var logger:Logger ;
		
		private var _callMonitor:FileMonitor ;
		private var _smsMonitor:FileMonitor ;
		private var _devices:ArrayCollection ;
		private var _pollTimer:Timer ;
		private var _pollDelay:Number					= 120000 ;
		
		private var _parentDirectory:File ;
		
		public static const CALL:String							= "call" ;
		public static const SMS:String							= "SMS" ;
		public static const CONTACT:String						= "contact" ;
		
		public function SyncMonitor( ) { }
		
		// PUBLIC METHODS
		
		public function init( ):void
		{
			phoneSelectedSignal.add( phoneSelectedHandler ) ;
			findBackupDirectory( ) ;
		}
		
		/**
		 * Attemps to locate the iTunes call/SMS log files.
		 */
		
		public function findBackupFiles( ):void
		{
			trace( "SyncMonitor.findBackupFiles" ) ;
			
			logger.log( "Locating backup files" ) ;
			
			var dir:File = new File( model.backupDirectory ) ;
			var folders:Array = dir.getDirectoryListing( ) ;
			
			// find call file
			
			for each( var file:File in folders )
			{
				if( Constants.CALL_LOG_FILES.indexOf( file.name ) != -1 )
				{
					if( isCall( file ) ) model.callLogFile = file ;
				}
			}
			
			if( !model.callLogFile )
			{
				for each( file in folders )
				{
					if( isCall( file ) ) model.callLogFile = file ;
				}
			}
			
			// find SMS file
			
			for each( file in folders )
			{
				if( Constants.SMS_LOG_FILES.indexOf( file.name ) != -1 )
				{
					if( isSMS( file ) ) model.SMSLogFile = file ;
				}
			}
			
			if( !model.SMSLogFile )
			{
				for each( file in folders )
				{
					if( isSMS( file ) ) model.SMSLogFile = file ;
				}
			}
			
			// find contact file
			
			for each( file in folders )
			{
				if( Constants.CONTACT_FILES.indexOf( file.name ) != -1 )
				{
					if( isContact( file ) ) model.contactFile = file ;
				}
			}
			
			if( !model.contactFile )
			{
				for each( file in folders )
				{
					if( isContact( file ) ) model.contactFile = file ;
				}
			}
			
			if( model.callLogFile ) 
			{
				trace( "---call file", model.callLogFile.name ) ;
				logger.log( "Call log file found" ) ;
			}
			
			else logger.log( "Call log file not found" ) ;
			
			if( model.SMSLogFile )
			{
				trace( "---SMS file", model.SMSLogFile.name ) ;	
				logger.log( "SMS log file found" ) ;
			}
			
			else logger.log( "SMS log file not found" ) ;
			
			if( model.contactFile ) 
			{
				trace( "---contact file", model.contactFile.name ) ;
				logger.log( "Contact file found" ) ;
				loadContactsSignal.dispatch( ) ;
			}
			
			else logger.log( "Contact file not found" ) ;
			
			
			
			// stop polling for the files if they all have been found, or start polling if they haven't
			
			if( model.callLogFile && model.SMSLogFile && model.contactFile ) stopPollTimer( ) ;
			else setPollTimer( ) ;
			
			if( model.settings.syncCalls && model.callLogFile ) errorManager.resolve( model.callLogFile ) ;
			else if( model.settings.syncSMS && model.SMSLogFile ) errorManager.resolve( model.SMSLogFile ) ;
		}

		/**
		 * Attempts to find the directory where the iTunes log files are located.
		 */
		
		public function findBackupDirectory( ):void
		{
			trace( "SyncMonitor.findBackupDirectory" ) ;
			
			logger.log( "Locating backup directory" ) ;
			
			var dir:String ;
			var os:String = Capabilities.os.toLowerCase( ) ;
			
			if( os.indexOf( "xp" ) != -1 ) dir = Constants.LOG_DIRECTORY_XP ;
			else if( os.indexOf( "windows" ) != -1 ) dir = Constants.LOG_DIRECTORY_WIN ;
			else if( os.indexOf( "mac" ) != -1 ) dir = Constants.LOG_DIRECTORY_MAC ;	
			
			_parentDirectory = new File( File.userDirectory.nativePath + dir ) ;
			_devices = new ArrayCollection( ) ;
			
			if( !_parentDirectory.exists ) 
			{ 
				// iTunes most likely hasn't been installed, ignore this and take the user to the main screen
				logger.log( "Backup directory not found" ) ;
				Application.application.showMainView( ) ;
				return ; 
			}
			
			else logger.log( "Backup directory found at " + _parentDirectory.url ) ;
			
			var folders:Array = _parentDirectory.getDirectoryListing( ) ;
			
			// go through the found folders and check them for iPhone data
			for( var i:int = 0 ; i < folders.length ; i++ ) checkForPhoneData( folders[i] ) ;
			
			logger.log( _devices.length + " device(s) found" ) ;
			
			// if there is only one device, make it the current selection
			if( _devices.length == 1 ) phoneSelectedSignal.dispatch( _devices[0] ) ;
			// if there is more than one device installed and the owner cannot be determined, take user to the selection screen
			else if( _devices.length > 1 && !phoneOwnerFound( ) ) selectPhoneSignal.dispatch( _devices ) ;
		
			else Application.application.showMainView( ) ;
			
			if( !model.backupDirectory ) setPollTimer( ) ;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Attempts to locate the backup directory at set intervals in case it hasn't been found yet.
		 * This is because the user may launch the application before installing iTunes or syncing their phone.
		 */
		
		private function setPollTimer( ):void
		{
			if( _pollTimer ) return ;
			
			_pollTimer = new Timer( _pollDelay ) ;
			_pollTimer.addEventListener( TimerEvent.TIMER, pollTimerHandler ) ;
			_pollTimer.start( ) ;
		}
		
		private function stopPollTimer( ):void
		{
			if( !_pollTimer ) return ;
			_pollTimer.removeEventListener( TimerEvent.TIMER, pollTimerHandler ) ;
			_pollTimer.stop( ) ;
			_pollTimer = null ;
		}
		
		/**
		 * Checks if a file contains call log information.
		 * @param file	The file to be checked
		 */
		
		private function isCall( file:File ):Boolean
		{
			var match:Boolean ;
			var conn:SQLConnection = new SQLConnection( ) ;
			var statement:SQLStatement = new SQLStatement( ) ;
			
			try { conn.open( file ) ; }
			catch( e:Error ) { return false ; }
			
			try
			{
				statement.sqlConnection = conn ;
				statement.text = "SELECT * FROM call" ;
				statement.execute( ) ;
				var result:Array = statement.getResult( ).data ;
				if( result.length > 0 ) match = true ;
			}
			
			catch( e:Error ) { }
			
			return match ;
		}
		
		/**
		 * Checks if a file contains SMS log information.
		 * @param file	The file to be checked
		 */
		
		private function isSMS( file:File ):Boolean
		{
			var match:Boolean ;
			var conn:SQLConnection = new SQLConnection( ) ;
			var statement:SQLStatement = new SQLStatement( ) ;
			
			try { conn.open( file ) ; }
			catch( e:Error ) { return false ; }
			
			try
			{
				statement.sqlConnection = conn ;
				statement.text = "SELECT * FROM message where ROWID < 10" ;
				statement.execute( ) ;
				match = true ;
			}
			
			catch( e:Error ) { }
			
			return match ;
		}
		
		/**
		 * Checks if a file contains contact information.
		 * @param file	The file to be checked
		 */
		
		private function isContact( file:File ):Boolean
		{
			var match:Boolean ;
			var conn:SQLConnection = new SQLConnection( ) ;
			var statement:SQLStatement = new SQLStatement( ) ;
			
			try { conn.open( file ) ; }
			catch( e:Error ) { return false ; }
			
			try
			{
				statement.sqlConnection = conn ;
				statement.text = "SELECT * FROM ABPerson where ROWID < 10" ;
				statement.execute( ) ;
				match = true ;
			}
			
			catch( e:Error ) { }
			
			return match ;
		}
		
		/**
		 * Checks if the owner of the synced device can be determined, ie. the name in the device info matches the user's
		 * Radium login credentials.
		 */
		
		private function phoneOwnerFound( ):Boolean
		{
			var found:Boolean = false ;
			
			for each( var device:DeviceInfoVO in _devices )
			{
				var owner:String = model.loggedInUser.name.toLowerCase( ) ;
				
				if( device.displayName.toLowerCase( ).indexOf( owner ) != -1 || 
					device.deviceName.toLowerCase( ).indexOf( owner ) != -1 )
				{
					found = true ;
					phoneSelectedSignal.dispatch( device ) ;
					break ;
				}
			}
			
			return found ;
		}
		
		/**
		 * Check if a folder contains an info.plist file associated with a synced device. If yes, the folder is added
		 * to the device list.
		 * @param folder	The folder to be checked
		 */
		
		private function checkForPhoneData( folder:File ):void
		{
			var info:File = new File( folder.nativePath + "/" + Constants.DEVICE_INFO_FILE ) ;
			
			if( info.exists ) 
			{
				var fs:FileStream = new FileStream( ) ;
				fs.open( info, FileMode.READ ) ;
				var data:XML = XML( fs.readMultiByte( info.size, File.systemCharset ) ) ;
				var device:DeviceInfoVO = VOParser.parseDeviceInfo( data ) ;
				device.directory = folder.name ;
				fs.close( ) ;
				
				//trace( "product type: " + device.productType ) ;
				
				if( device.productType )
				{
					if( device.productType.toLowerCase( ).indexOf( "iphone" ) != -1 ) 
					{
						_devices.addItem( device ) ;
					}
				}
			}	
		}
		
		/**
		 * Start monitoring the call log file for changes.
		 */
		
		private function setCallMonitor( ):void
		{
			if( _callMonitor || !model.callLogFile ) return ;
					
			var file:File = new File( model.callLogFile.url ) ;
			initMonitor( "_callMonitor", file ) ;
		}
		
		/**
		 * Start monitoring the SMS log file for changes.
		 */
		
		private function setSMSMonitor( ):void
		{
			if( _smsMonitor || !model.SMSLogFile ) return ;
			
			var file:File = new File( model.SMSLogFile.url ) ;
			initMonitor( "_smsMonitor", file ) ;
		}
		
		/**
		 * Set a monitor to watch a specific file.
		 * @param monitor	The monitor object
		 * @param file		The file associated with the monitor
		 */
		
		private function initMonitor( monitor:String, file:File ):void
		{
			this[ monitor ] = new FileMonitor( ) ;
			this[ monitor ].addEventListener( FileMonitorEvent.CREATE, fileChangeHandler ) ;
			this[ monitor ].addEventListener( FileMonitorEvent.MOVE, fileChangeHandler ) ;
			this[ monitor ].addEventListener( FileMonitorEvent.CHANGE, fileChangeHandler ) ;
			this[ monitor ].file = file ;
			
			this[ monitor ].watch( ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Launches a log signal whenever a change has been detected, ie. a device has been synced.
		 * This only happens if the user has set auto sync to true.
		 */
		
		private function fileChangeHandler( e:FileMonitorEvent ):void
		{
			trace( "FileMonitor.fileChangeHandler:", e.type, e.file.name ) ;
			
			if( e.type == FileMonitorEvent.CHANGE && model.settings.autoSync ) 
			{
				if( e.currentTarget == _callMonitor ) logCallsSignal.dispatch( ) ;
				else if( e.currentTarget == _smsMonitor ) logSMSSignal.dispatch( ) ;
			}
			
			else errorManager.runCheck( e.file ) ;
		}
		
		/**
		 * Attempts to find the correct backup files after a device has been selected.
		 * @param device	The selected device
		 */
		
		private function phoneSelectedHandler( device:DeviceInfoVO ):void
		{
			trace( "SyncMonitor.phoneSelectedHandler:", device.displayName, device.directory ) ;
			model.backupDirectory = _parentDirectory.nativePath + "/" + device.directory ;
			
			findBackupFiles( ) ;
			setCallMonitor( ) ;
			setSMSMonitor( ) ;
		}
		
		/**
		 * Checks if the backup directory has been found. If yes, find the relevant backup files.
		 */
		
		private function pollTimerHandler( e:TimerEvent ):void
		{
			if( !model.backupDirectory ) findBackupDirectory( ) ;
			else findBackupFiles( ) ;
		}
	}
}