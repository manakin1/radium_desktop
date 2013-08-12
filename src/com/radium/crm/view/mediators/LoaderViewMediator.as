package com.radium.crm.view.mediators
{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.CredentialsVO;
	import com.radium.crm.model.vo.UserVO;
	import com.radium.crm.signals.AuthenticateSignal;
	import com.radium.crm.signals.AuthenticationSuccessSignal;
	import com.radium.crm.signals.CancelAuthenticationSignal;
	import com.radium.crm.view.components.LoaderView;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the loader view.
	 */

	public class LoaderViewMediator extends Mediator
	{
		
		[Inject]
		public var view:LoaderView ;
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var authenticateSignal:AuthenticateSignal ;
		
		[Inject]
		public var authenticationSuccessSignal:AuthenticationSuccessSignal ;
		
		[Inject]
		public var cancelAuthenticationSignal:CancelAuthenticationSignal ;
		
		public function LoaderViewMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			authenticateSignal.add( authenticateStartHandler ) ;
			authenticationSuccessSignal.add( authenticationSuccessHandler ) ;
			view.addEventListener( Event.CANCEL, cancelHandler ) ;
			
			ChangeWatcher.watch( model, "debugString", debugHandler ) ;
			
			view.setDebugText( model.debugString ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Displays the loader animation
		 */
		
		private function authenticateStartHandler( credentials:CredentialsVO ):void
		{
			view.showLoader( ) ;
		}
		
		/**
		 * Hides the loader animation after a successful athentication.
		 */
		
		private function authenticationSuccessHandler( user:UserVO ):void
		{
			view.hideLoader( ) ;
		}
		
		/**
		 * Dispatches a cancel signal after the user has clicked the "Cancel" button.
		 */
		
		private function cancelHandler( e:Event ):void
		{
			cancelAuthenticationSignal.dispatch( ) ;
		}
		
		private function debugHandler( e:Event ):void
		{
			view.setDebugText( model.debugString ) ;
		}

	}
}