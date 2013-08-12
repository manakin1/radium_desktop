package com.radium.crm.controller.commands{	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.remote.services.LogService;
	import com.radium.crm.signals.SyncLoggedSignal;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.SignalCommand;		/**	 * Loads the locally stored log history file. This file contains a complete history of the user's syncs along with	 * timestamps and success/failure status.	 */
	 	public class LoadHistoryCommand extends SignalCommand	{				[Inject]		public var logService:LogService ;				[Inject]		public var syncLoggedSignal:SyncLoggedSignal ;				[Inject]		public var model:ContentModel ;		override public function execute( ):void		{				var file:File = File.applicationStorageDirectory.resolvePath( model.historyURL ) ;						if( file.exists )			{				var fs:FileStream = new FileStream( ) ;				fs.open( file, FileMode.READ ) ;								// retrieves the timestamp and status of the last sync to be displayed in the Sync and About views							var data:XML = XML( fs.readMultiByte( file.size, File.systemCharset ) ) ;				var len:int = data.history..sync.length( ) - 1 ;				var date:String = data.history..sync[ len ].date ;				var status:String = data.history..sync[ len ].status ;				model.lastSyncStatus = status ;				fs.close( ) ;								if( Number( date ) > 0 ) model.lastSyncDate = new Date( Number( date ) * 1000 ) ;								syncLoggedSignal.dispatch( status ) ;			}		}	}}