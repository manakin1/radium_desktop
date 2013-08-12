package com.radium.crm.remote.services
{
	
	import com.adobe.air.filesystem.FileMonitor;
	import com.adobe.air.filesystem.events.FileMonitorEvent;
	import com.adobe.serialization.json.JSON;
	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.CallVO;
	import com.radium.crm.model.vo.SMSVO;
	import com.radium.crm.signals.DispatchErrorMessageSignal;
	import com.radium.crm.signals.LoadHistorySignal;
	import com.radium.crm.signals.LogCallsSignal;
	import com.radium.crm.signals.SyncLoggedSignal;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.utils.VOParser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Handles sending the call and SMS logs to the server.
	 */
	
	public class LogService extends Actor
	{
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var errorManager:ErrorManager ;
		
		[Inject]
		public var logCallsSignal:LogCallsSignal ;
		
		[Inject]
		public var syncLoggedSignal:SyncLoggedSignal ;
		
		[Inject]
		public var loadHistorySignal:LoadHistorySignal ;

		private var _loader:URLLoader ;
		private var _logType:String ;
		private var _logDataCalls:Array ;
		private var _logDataSMS:Array ;
		private var _logFile:File ;
		private var _logXML:XML ;
		private var _fileStream:FileStream ;
		
		public static const CALL:String					= "call" ;
		public static const SMS:String					= "SMS" ;
		
		public function LogService( ) { }
		
		// PUBLIC METHODS
		
		/**
		 * Logs the call data.
		 * @param calls	An array containing CallVO value objects
		 */
		
		public function logCalls( calls:Array ):void
		{
			_logType = CALL ;
			_logDataCalls = getUnsyncedItems( calls ) ;
			
			// no new items to log
			if( _logDataCalls.length == 0 ) 
			{
				appendCallLogFile( _logDataSMS, Constants.STATUS_UP_TO_DATE ) ;
				return ;
			}
			
			var json_arr:Array = new Array( ) ;
			//var log_str:String = "User API Key " + model.loggedInUser.api_key + " Developer API Key " + Constants.API_KEY + "<br/>" ;
			
			
			for each( var call:CallVO in _logDataCalls )
			{
				var obj:Object = new Object( ) ;
				obj.number = call.number ;
				if( call.name ) obj.name = call.name.split( "null" ).join( "" ) ;
				else obj.name = "Unknown" ;
				obj.direction = call.direction ;
				obj.duration = call.duration ;
				obj.kind = call.kind ;
				obj.dialed_at = call.dialed_at ;
				
				if( obj.name.length <= 1 ) obj.name = "Unknown" ;
				
				json_arr.push( obj ) ;
				
				trace( "----- " + obj.number, obj.name, obj.duration, obj.dialed_at ) ;
				
				//log_str += obj.number + " " + obj.direction + " " + obj.duration + " " + obj.kind + " " + obj.dialed_at + "<br/>" ;
			}
			
			
			
			//model.debugString = log_str ;
			
			var params:Object = new Object( ) ;
			params[ "phone_calls" ] = json_arr ;
			var json_str:String = JSON.encode( { phone_calls: json_arr } ) ;
			var service:HTTPService = new HTTPService( ) ;
			var responder:Responder = new Responder( callLogResultHandler, callLogStatusHandler ) ;
			var token:AsyncToken ;
			
			service.method = URLRequestMethod.POST ;
			service.contentType = "application/json" ;
			service.resultFormat = "text" ;
			service.useProxy = false ;
			service.showBusyCursor = true ;
			
			service.url = model.serverURL + Constants.API_URL + Constants.CALLS_IMPORT_CALL + "?developer_api_key=" + Constants.API_KEY + "&user_api_key=" + 
					      model.loggedInUser.api_key ;
			
			token = service.send( json_str ) ;
			token.addResponder( responder ) ;
		}
		
		/**
		 * Logs the SMS data.
		 * @param messages	An array containing SMSVO value objects
		 */
		
		public function logSMS( messages:Array ):void
		{
			_logType = SMS ;
			_logDataSMS = getUnsyncedItems( messages ) ;
			
			// no new items to log
			if( _logDataSMS.length == 0 ) 
			{
				appendSMSLogFile( _logDataSMS, Constants.STATUS_UP_TO_DATE ) ;
				return ;
			}
			
			var json_arr:Array = new Array( ) ;
			//var log_str:String = "" ;
			
			for each( var sms:SMSVO in _logDataSMS )
			{	
				var obj:Object = new Object( ) ;
				obj.number = sms.number ;
				obj.direction = sms.direction ;
				obj.name = sms.name ;
				obj.message = sms.message ;
				obj.sent_on = sms.sent_on ;
				
				if( obj.message ) json_arr.push( obj ) ;
				
				//log_str += obj.number + " " + obj.direction + " " + obj.message + " " + obj.sent_on + "<br/>" ;
			}
			
			//model.debugString = log_str ;
			
			var params:Object = new Object( ) ;
			params[ "sms_messages" ] = json_arr ;
			var json_str:String = JSON.encode( { sms_messages: json_arr } ) ;
			var service:HTTPService = new HTTPService( ) ;
			service.contentType = "application/x-www-form-urlencoded" ;
			var responder:Responder = new Responder( SMSLogResultHandler, SMSLogStatusHandler ) ;
			var token:AsyncToken ;
			
			service.method = URLRequestMethod.POST ;
			service.contentType = "application/json" ;
			service.resultFormat = "text" ;
			service.useProxy = false ;
			service.showBusyCursor = true ;
			
			service.url = model.serverURL + Constants.API_URL + Constants.SMS_IMPORT_CALL + "?developer_api_key=" + Constants.API_KEY + "&user_api_key=" + 
					 	  model.loggedInUser.api_key ;
			
			token = service.send( json_str ) ;
			token.addResponder( responder ) ;
		}
		
		/**
		 * Logs error messages
		 * @param args	An object containing information about the error
		 */
		
		public function logError( args:Object ):void
		{
			var params:Object = new Object( ) ;
			params.description = args.description ;
			params.mobile_os_version = Capabilities.os ;
			params.mobile_app_version = model.getVersionNumber( ) ;
			
			var service:HTTPService = new HTTPService( ) ;
			var responder:Responder = new Responder( ErrorLogResultHandler, errorLogStatusHandler ) ;
			var token:AsyncToken ;
			
			service.method = URLRequestMethod.POST ;
			service.resultFormat = "text" ;
			service.useProxy = false ;
			
			service.url = model.serverURL + Constants.API_URL + Constants.ERROR_LOG_CALL + "?developer_api_key=" + Constants.API_KEY ;
			
			token = service.send( params ) ;
			token.addResponder( responder ) ;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Filters new items that have not yet been synced by comparing their dates to the timestamps in the history.xml file.
		 * @param arr	An array containing all the items found in the iTunes log file
		 */
		
		private function getUnsyncedItems( arr:Array ):Array 
		{
			loadLogFile( ) ;
			
			var items:Array = new Array( ) ;
			var len:int = _logXML..sync.length( ) ;
			var last_date:Number = 0 ;
			
			if( len == 0 ) return arr ;
			
			/**
			 * Checks if the timestamp on the item is newer than the last sync date in the history.xml file. If the 
			 * item is newer but the last log attempt was not successful, the item will be logged again.
			 */
			
			for( var i:int = 0 ; i < len ; i++ )
			{
				var type:String = _logXML..sync[i].type ;
				var status:String = _logXML..sync[i].status ;
				var last_sync:Number = Number( _logXML..sync[i].last_item ) ;
				if( type == _logType && status == Constants.STATUS_SUCCESS && last_sync > last_date ) last_date = last_sync ;
			}
			
			for each( var item:Object in arr )
			{
				if( item.date > last_date ) items.push( item ) ;
			}
			
			trace( "---Logging", items.length, "new items" ) ;
			
			return items ;
		}
		
		/**
		 * Loads the locally stored log history file.
		 */
		
		private function loadLogFile( ):void
		{
			_logFile = File.applicationStorageDirectory.resolvePath( model.historyURL ) ; 
			_fileStream = new FileStream( ) ;
			
			if( _logFile.exists )
			{
				_fileStream.open( _logFile, FileMode.READ ) ;
				_logXML = XML( _fileStream.readMultiByte( _logFile.size, File.systemCharset ) ) ;
			}
			
			// creates a new file if one doesn't exist (nothing has been logged yet)
			
			else
			{
				_fileStream.open( _logFile, FileMode.WRITE ) ;
				_logXML = new XML( "<data><history></history></data>" ) ;
				_fileStream.writeUTFBytes( _logXML ) ;
			}
			
			_fileStream.close( ) ;
		}
		
		/**
		 * Add the status of the last call sync to the local history file.
		 * @param data_arr	An array containing the local files
		 * @param status	The success status of the last sync
		 */
		
		private function appendCallLogFile( data_arr:Array, status:String ):void
		{
			trace( "LogService.appendCallLogFile" ) ;
			
			var data:XML = getCallSyncData( data_arr, status ) ;
			
			if( data.last_date != 0 ) 
			{
				_logXML.history.appendChild( data ) ;
				
				_fileStream.open( _logFile, FileMode.WRITE ) ;
				_fileStream.writeUTFBytes( _logXML ) ;
				_fileStream.close( ) ;
			}
			
			model.lastSyncDate = new Date( ) ;
			syncLoggedSignal.dispatch( status ) ;
			loadLogFile( ) ;
		}
		
		/**
		 * Add the status of the last SMS sync to the local history file.
		 * @param data_arr	An array containing the local files
		 * @param status	The success status of the last sync
		 */
		
		private function appendSMSLogFile( data_arr:Array, status:String ):void
		{
			trace( "LogService.appendSMSLogFile" ) ;
			
			var data:XML = getSMSSyncData( data_arr, status ) ;
			
			if( data.last_date != 0 ) 
			{
				_logXML.history.appendChild( data ) ;
				
				_fileStream.open( _logFile, FileMode.WRITE ) ;
				_fileStream.writeUTFBytes( _logXML ) ;
				_fileStream.close( ) ;
			}
			
			model.lastSyncDate = new Date( ) ;
			syncLoggedSignal.dispatch( status ) ;
			loadLogFile( ) ;
		}
		
		/**
		 * Returns the timestamp of the last logged item.
		 * @param arr	An array containing the logged items
		 */
		
		private function getLastLogDate( arr:Array ):Number
		{
			var date:Number = -1 ;
			
			for each( var call:Object in arr )
			{
				if( call.date > date ) date = call.date ;
			}
			
			return date ;
		}
		
		/**
		 * Parses the call sync information and returns it as an XML to be added to the sync history file.
		 * @param data		An array containing the newly synced calls
		 * @param status	The status of the last sync
		 */
		
		private function getCallSyncData( data:Array, status:String ):XML
		{
			var sync:XML = new XML( "<sync></sync>" ) ;
			sync.type = CALL ;
			sync.date = Number( Date.parse( new Date( ) ) ) / 1000 ;
			sync.last_item = Number( getLastLogDate( data ) ) ;
			sync.status = status ;
			
			return sync ;
		}
		
		/**
		 * Parses the SMS sync information and returns it as an XML to be added to the sync history file.
		 * @param data		An array containing the newly synced messages
		 * @param status	The status of the last sync
		 */
		
		private function getSMSSyncData( data:Array, status:String ):XML
		{
			var sync:XML = new XML( "<sync></sync>" ) ;
			sync.type = SMS ;
			sync.date = Number( Date.parse( new Date( ) ) ) / 1000 ;
			sync.last_item = Number( getLastLogDate( data ) ) ;
			sync.status = status ;
			
			return sync ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Adds the new call sync data to the local history file after receiving a successful server response.
		 * @param info	The server response
		 */
		
		private function callLogResultHandler( info:Object ):void
		{
			appendCallLogFile( _logDataCalls, Constants.STATUS_SUCCESS ) ;
		}
		
		/**
		 * Adds the new SMS sync data to the local history file after receiving a successful server response.
		 * @param info	The server response
		 */
		
		private function SMSLogResultHandler( info:Object ):void
		{
			appendSMSLogFile( _logDataSMS, Constants.STATUS_SUCCESS ) ;
		}
		
		private function ErrorLogResultHandler( info:Object ):void
		{
			trace( "LogService.ErrorLogResultHandler:", info.result ) ;
		}
		
		/**
		 * Registers an error after a failed sync attempt and marks the sync as failed in the local history file.
		 * @param info	The server response
		 */
		
		private function callLogStatusHandler( info:Object ):void
		{
			trace( "LogService.callLogStatusHandler:", info ) ;
			errorManager.addError( Constants.ERROR_IMPORT_FAILED ) ;
			appendCallLogFile( _logDataCalls, Constants.STATUS_FAILED ) ;
		}
		
		/**
		 * Registers an error after a failed sync attempt and marks the sync as failed in the local history file.
		 * @param info	The server response
		 */
		
		private function SMSLogStatusHandler( info:Object ):void
		{
			trace( "LogService.SMSLogStatusHandler:", info ) ;
			errorManager.addError( Constants.ERROR_IMPORT_FAILED ) ;
			appendSMSLogFile( _logDataSMS, Constants.STATUS_FAILED ) ;
		}
		
		private function errorLogStatusHandler( info:Object ):void
		{
			trace( "LogService.errorLogStatusHandler:", info ) ;
		}
		
	}

}