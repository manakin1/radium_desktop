package com.radium.crm.controller.commands{
	
	import com.radium.crm.model.vo.CredentialsVO;
	import com.radium.crm.remote.services.AuthenticationService;
	
	import org.robotlegs.mvcs.SignalCommand;		/**	 * Attempts to log in with the user's credentials.	 */		public class AuthenticateCommand extends SignalCommand	{				[Inject]		public var authenticationService:AuthenticationService ;					[Inject]		public var loginCredentials:CredentialsVO ;		override public function execute( ):void		{			authenticationService.authenticate( loginCredentials ) ;		}	}}