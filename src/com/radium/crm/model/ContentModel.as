package com.radium.crm.model
{
	
	import com.radium.crm.model.vo.CredentialsVO;
	import com.radium.crm.model.vo.SettingsVO;
	import com.radium.crm.model.vo.UserVO;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Main model file. Stores the state of the application.
	 */

	public class ContentModel extends Actor
	{
		
		private var _config:XML ;
		
		[Bindable]
		private var _settings:SettingsVO ;
		private var _credentials:CredentialsVO ;
		private var _loggedInUser:UserVO ;
		private var _loggedIn:Boolean ;
		private var _contactFile:File ;
		private var _callLogFile:File ;
		private var _SMSLogFile:File ;
		private var _contacts:Dictionary ;
		private var _lastSyncDate:Date ;
		private var _backupDirectory:String ;
		private var _serverURL:String ;
		private var _firstTimeUser:Boolean ;
		private var _lastSyncStatus:String ;
		
		[Bindable]
		public var debugString:String 					= "" ;
		
		public function ContentModel( )
		{
			super( ) ;
		}
		
		// ACCESSOR METHODS

		public function get lastSyncStatus( ):String
		{
			return _lastSyncStatus ;
		}

		public function set lastSyncStatus( value:String ):void
		{
			_lastSyncStatus = value ;
		}

		public function get firstTimeUser( ):Boolean
		{
			return _firstTimeUser ;
		}

		public function set firstTimeUser( value:Boolean ):void
		{
			_firstTimeUser = value ;
		}

		public function get serverURL( ):String
		{
			if( _serverURL ) return _serverURL ;
			else return Constants.SERVER_URL ;
		}

		public function set serverURL( value:String ):void
		{
			if( value.indexOf( "http://" ) != -1 ) _serverURL = value ;
			else _serverURL = "http://" + value ;
			if( value.lastIndexOf( "/" ) != value.length - 1 ) _serverURL += "/" ;
		}
		
		/**
		 * Returns the current server URL without the http://
		 */
		
		public function get strippedServerURL( ):String
		{
			var stripped_url:String = serverURL.split( "http://" ).join( "" ) ;
			var len:int = stripped_url.length ;
			if( stripped_url.lastIndexOf( "/" ) == stripped_url.length - 1 ) stripped_url = stripped_url.substr( 0, len - 1 ) ;
			
			return stripped_url ;
		}
		
		public function get userDirectory( ):String
		{
			var name:String = loggedInUser.name.split( " " ).join( "." ) ;
			return name.toLowerCase( ) + "/" ;
		}
		
		public function get settingsURL( ):String
		{
			return Constants.DATA_FOLDER + Constants.SETTINGS_FILE ;
		}
		
		public function get historyURL( ):String
		{
			return Constants.DATA_FOLDER + userDirectory + Constants.HISTORY_FILE ;
		}

		public function get backupDirectory( ):String
		{
			return _backupDirectory;
		}

		public function set backupDirectory( value:String ):void
		{
			_backupDirectory = value;
		}

		public function get lastSyncDate( ):Date
		{
			return _lastSyncDate ;
		}

		public function set lastSyncDate( value:Date ):void
		{
			_lastSyncDate = value ;
		}

		public function get config( ):XML
		{
			return _config ;
		}
		
		public function get credentials( ):CredentialsVO
		{
			return _credentials ;
		}
		
		public function set credentials( vo:CredentialsVO ):void
		{
			_credentials = vo ;
		}

		public function get settings( ):SettingsVO
		{
			return _settings ;
		}
		
		public function set settings( vo:SettingsVO ):void
		{
			_settings = vo ; 
		}
		
		public function get loggedIn( ):Boolean
		{
			return _loggedIn ;
		}
		
		public function set loggedIn( value:Boolean ):void
		{
			_loggedIn = value ;
			if( !_loggedIn ) loggedInUser = null ;
		}
		
		public function get loggedInUser( ):UserVO
		{
			return _loggedInUser ;
		}
		
		public function set loggedInUser( vo:UserVO ):void
		{
			if( vo ) _loggedIn = true ;
			_loggedInUser = vo ;
		}
		
		public function get contactFile( ):File
		{
			return _contactFile ;
		}
		
		public function set contactFile( file:File ):void
		{
			_contactFile = file ;
		}
		
		public function get callLogFile( ):File
		{
			return _callLogFile ;
		}
		
		public function set callLogFile( file:File ):void
		{
			_callLogFile = file ;
		}
		
		public function get SMSLogFile( ):File
		{
			return _SMSLogFile ;
		}
		
		public function set SMSLogFile( file:File ):void
		{
			_SMSLogFile = file ;
		}
		
		public function get contacts( ):Dictionary
		{
			return _contacts ;
		}
		
		public function set contacts( dict:Dictionary ):void
		{
			_contacts = dict ;
		}
		
		// PUBLIC METHODS
		
		public function getVersionNumber( ):String
		{
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor ;
			var ns:Namespace = descriptor.namespaceDeclarations( )[0] ;
			return descriptor.ns::version ;
		}
		
		public function updateConfigurationData( data:XML ):void
		{
			_config = data ;
		}
		
		public function appendLog( msg:String ):void
		{
			debugString += msg + " ---- " ;
		}
		
	}
}