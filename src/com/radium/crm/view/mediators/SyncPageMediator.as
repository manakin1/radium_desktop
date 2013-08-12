package com.radium.crm.view.mediators
{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.AuthenticateSignal;
	import com.radium.crm.signals.ShowPrivacyInfoSignal;
	import com.radium.crm.signals.SyncLoggedSignal;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.view.components.SyncPage;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the sync view.
	 */

	public class SyncPageMediator extends Mediator
	{
		
		[Inject]
		public var view:SyncPage ;
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var errorManager:ErrorManager ;
		
		[Inject]
		public var syncLoggedSignal:SyncLoggedSignal ;
		
		[Inject]
		public var showPrivacyInfoSignal:ShowPrivacyInfoSignal ;
		
		public function SyncPageMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			// add listeners
			syncLoggedSignal.add( syncLoggedHandler ) ;
			syncLoggedHandler( model.lastSyncStatus ) ;
			
			view.addEventListener( "showPrivacyInfo", showPrivacyInfoHandler ) ;
			view.addEventListener( "sync", startSyncHandler ) ;
			
			// check for new error messages
			errorManager.runCheck( model.callLogFile ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Displays the last sync status.
		 * @param status	The latest status message
		 */
		
		private function syncLoggedHandler( status:String ):void
		{
			view.stopLoaderAnimation( ) ;
			
			if( !model.lastSyncDate ) return ;
			
			var date:Date = model.lastSyncDate ;
			view.updateLastSyncDate( date.toLocaleDateString( ) + " " + date.toLocaleTimeString( ), status ) ;	
		}
		
		private function showPrivacyInfoHandler( e:Event ):void
		{
			showPrivacyInfoSignal.dispatch( ) ;
		}
		
		/**
		 * Displays the loader animation after the user has clicked on the Sync button.
		 */
		
		private function startSyncHandler( e:Event ):void
		{
			if( errorManager.runCheck( model.callLogFile ) ) view.showLoaderAnimation( ) ;
		}
	}
}