package com.radium.crm.view.mediators
{
	
	import com.radium.crm.events.ConnectionEvent;
	import com.radium.crm.events.UpdateEvent;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.LogCallsSignal;
	import com.radium.crm.signals.LoggedOutSignal;
	import com.radium.crm.signals.LogoutSignal;
	import com.radium.crm.signals.SaveSettingsSignal;
	import com.radium.crm.signals.SettingsLoadedSignal;
	import com.radium.crm.signals.SyncLoggedSignal;
	import com.radium.crm.view.components.AboutPage;
	import com.radium.crm.view.components.MainView;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.binding.utils.ChangeWatcher;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the About view.
	 */

	public class AboutPageMediator extends Mediator
	{
		
		[Inject]
		public var view:AboutPage ;
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var syncLoggedSignal:SyncLoggedSignal ;
		
		public function AboutPageMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			syncLoggedSignal.add( syncLoggedHandler ) ;
			syncLoggedHandler( model.lastSyncStatus ) ;
			
			view.setVersionText( model.getVersionNumber( ) ) ;
			view.setDebugText( model.debugString ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Updates the latest sync status.
		 * @param status	The last logged sync status
		 */
		
		private function syncLoggedHandler( status:String ):void
		{
			if( !model.lastSyncDate ) return ;
			
			var date:Date = model.lastSyncDate ;
			view.updateLastSyncDate( date.toLocaleDateString( ) + " " + date.toLocaleTimeString( ), status ||= model.lastSyncStatus ) ;
		}

	}
}