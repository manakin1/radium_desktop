package com.radium.crm.controller.commands{	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.CallVO;
	import com.radium.crm.model.vo.ContactVO;
	import com.radium.crm.remote.services.LogService;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.utils.SyncMonitor;
	import com.radium.crm.utils.VOParser;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.SignalCommand;		/**	 * Logs the user's call data.	 */
	 	public class LogCallsCommand extends SignalCommand	{				[Inject]		public var logService:LogService ;				[Inject]		public var errorManager:ErrorManager ;				[Inject]		public var syncMonitor:SyncMonitor ;				[Inject]		public var model:ContentModel ;		override public function execute( ):void		{			trace( "LogCallsCommand.execute" ) ;						/**			 * The file may not be loaded yet if the user only synced iTunes after launching the applicaton - in this case			 * it will attempt to find the backup directory again.			 */						var file:File = model.callLogFile ;			if( !file ) syncMonitor.findBackupDirectory( ) ;						// return if the user has not selected automatic call syncing in the settings			if( !model.settings.syncCalls ) return ;			// return if there are any errors preventing the sync operation			if( !errorManager.runCheck( file ) ) return ;			if( file.exists ) readLog( file ) ;		}				// PRIVATE METHODS				/**		 * Parses the SQL query result into an array of CallVO value objects and sends them to LogService		 * @param file	Reference to the iTunes call log file		 */				private function readLog( file:File ):void		{			var conn:SQLConnection = new SQLConnection( ) ;			var statement:SQLStatement = new SQLStatement( ) ;						conn.open( file ) ;						try			{				statement.sqlConnection = conn ;				statement.text = "SELECT address, duration, date, flags, id FROM call" ;				statement.execute( ) ;			}						catch( e:Error )			{				errorManager.addError( Constants.ERROR_ENCRYPTED_DATA ) ;				return ;			}						var calls:Array = new Array( ) ;			var result:Array = statement.getResult( ).data ;						for each( var obj:Object in result )			{				var call:CallVO = VOParser.parseCall( obj ) ;				var contact:ContactVO ;								if( model.contacts )				{					for each( var con:ContactVO in model.contacts )					{						if( con.id == call.contactId )						{							contact = con ;						}												else contact = null ;						if( contact ) break ;					}				}								//else trace( "NO CONTACTS" ) ;				if( !contact ) calls.push( call ) ;								else				{					// do not log calls from users that have been marked as private					var note:String = contact.note ;					call.name = contact.firstName + " " + contact.lastName ;										//trace( "-----------", call.name, call.number ) ;									if( note )					{						if( note.toLowerCase( ).indexOf( "private" ) == -1 ) calls.push( call ) ;					}									else calls.push( call ) ;				}			}						calls = calls.reverse( ) ;			if( calls.length > 200 ) calls.length = 200 ;						logService.logCalls( calls ) ;		}	}}