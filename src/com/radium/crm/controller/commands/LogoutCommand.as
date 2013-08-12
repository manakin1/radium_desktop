package com.radium.crm.controller.commands{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.remote.services.AuthenticationService;
	
	import org.robotlegs.mvcs.SignalCommand;		 	/**	 * Logs the user out.	 */		public class LogoutCommand extends SignalCommand	{				[Inject]		public var authenticationService:AuthenticationService ;					[Inject]		public var model:ContentModel ;		override public function execute( ):void		{			trace( "LogoutCommand.execute" ) ;						model.backupDirectory = null ;			authenticationService.logout( ) ;		}	}}