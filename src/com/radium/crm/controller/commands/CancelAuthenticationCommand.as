package com.radium.crm.controller.commands{
	
	import com.radium.crm.ApplicationMediator;
	import com.radium.crm.remote.services.AuthenticationService;
	
	import mx.core.Application;
	
	import org.robotlegs.mvcs.SignalCommand;
	 	/**	 * Cancels the ongoing authentication process.	 */		public class CancelAuthenticationCommand extends SignalCommand	{				[Inject]		public var authenticationService:AuthenticationService ;		override public function execute( ):void		{			authenticationService.cancel( ) ;			Application.application.showSignupView( ) ;		}	}}