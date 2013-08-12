package com.radium.crm.view.mediators
{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.AuthenticateSignal;
	import com.radium.crm.signals.AuthenticationSuccessSignal;
	import com.radium.crm.view.components.SignupView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the signup view.
	 */

	public class SignupViewMediator extends Mediator
	{
		
		[Inject]
		public var view:SignupView ;
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var authenticateSignal:AuthenticateSignal ;
		
		[Inject]
		public var authenticationSuccessSignal:AuthenticationSuccessSignal ;
		
		public function SignupViewMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			// add listeners
			view.addEventListener( "submit", submitHandler ) ;
			view.addEventListener( "serverUpdated", serverUpdatedHandler ) ;
			
			// set the default server URL on the screen
			view.defaultServerURL = model.strippedServerURL ;
			
			view.reset( ) ;
		}
		
		// EVENT HANDLERS
		
		private function submitHandler( e:Event ):void
		{
			authenticateSignal.dispatch( view.loginData ) ;
		}
		
		/**
		 * Updates the server ULR in the model after the user has manually changed it.
		 */
		
		private function serverUpdatedHandler( e:Event ):void
		{
			model.serverURL = view.serverField.text ;
		}

	}
}