package com.radium.crm.view.mediators
{
	
	import com.radium.crm.controller.commands.LogSMSCommand;
	import com.radium.crm.events.ConnectionEvent;
	import com.radium.crm.events.UpdateEvent;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.UserVO;
	import com.radium.crm.signals.AuthenticationSuccessSignal;
	import com.radium.crm.signals.LogCallsSignal;
	import com.radium.crm.signals.LogSMSSignal;
	import com.radium.crm.signals.LoggedOutSignal;
	import com.radium.crm.signals.LogoutSignal;
	import com.radium.crm.signals.SaveSettingsSignal;
	import com.radium.crm.signals.SettingsLoadedSignal;
	import com.radium.crm.view.components.MainView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the main view.
	 */

	public class MainViewMediator extends Mediator
	{
		
		[Inject]
		public var view:MainView ;
		
		[Inject]
		public var settingsLoadedSignal:SettingsLoadedSignal ;
		
		[Inject]
		public var logoutSignal:LogoutSignal ;
		
		[Inject]
		public var loggedOutSignal:LoggedOutSignal ;
		
		[Inject]
		public var authenticationSuccessSignal:AuthenticationSuccessSignal ;
		
		[Inject]
		public var logCallsSignal:LogCallsSignal ;
		
		[Inject]
		public var logSMSSignal:LogSMSSignal ;
		
		[Inject]
		public var saveSettingsSignal:SaveSettingsSignal ;
		
		[Inject]
		public var model:ContentModel ;
		
		public function MainViewMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			// add listeners
			
			settingsUpdatedHandler( ) ;
			view.addEventListener( UpdateEvent.UPDATE_SETTINGS, updateSettingsHandler ) ;
			view.addEventListener( ConnectionEvent.LOGOUT, logoutHandler ) ;
			view.addEventListener( "sync", syncHandler ) ;
			settingsLoadedSignal.add( settingsUpdatedHandler ) ;
			loggedOutSignal.add( loggedOutHandler ) ;
			authenticationSuccessSignal.add( authenticationSuccessHandler ) ;
			
			// update the user's name in the upper right corner
			if( model.loggedInUser ) view.updateName( model.loggedInUser.name ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Dispatches an updateSettings signal with the id and value of the changed property.
		 */
		
		private function updateSettingsHandler( e:UpdateEvent ):void
		{
			saveSettingsSignal.dispatch( e.id, e.value ) ;
		}
		
		/**
		 * Update the settings in the model once they have been successfully changed.
		 */
		
		private function settingsUpdatedHandler( ):void
		{
			trace( "MainViewMediator.settingsUpdatedHandler" ) ;
			view.updateSettings( model.settings ) ;
		}
		
		private function logoutHandler( e:Event ):void
		{
			logoutSignal.dispatch( ) ;
		}
		
		/**
		 * Clears all user information from the view once the user has logged out.
		 */
		 
		private function loggedOutHandler( ):void
		{
			view.reset( ) ;
		}
		
		/**
		 * Dispatches log signals once the user has clicked the Sync button.
		 */
		
		private function syncHandler( e:Event ):void
		{
			logCallsSignal.dispatch( ) ;
			logSMSSignal.dispatch( ) ;
		}
		
		/**
		 * Updates the user's name on the screen after a successful authentication.
		 */
		
		private function authenticationSuccessHandler( user:UserVO ):void
		{
			if( model.loggedInUser ) view.updateName( model.loggedInUser.name ) ;
		}
		
	}
}