package com.radium.crm.remote.services
{
	
	import com.adobe.serialization.json.*;
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.CredentialsVO;
	import com.radium.crm.model.vo.UserVO;
	import com.radium.crm.signals.AuthenticationErrorSignal;
	import com.radium.crm.signals.AuthenticationSuccessSignal;
	import com.radium.crm.signals.LoggedOutSignal;
	import com.radium.crm.signals.SaveCredentialsSignal;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.utils.Logger;
	import com.radium.crm.utils.VOParser;
	
	import flash.filesystem.*;
	import flash.net.URLRequestMethod;
	
	import mx.core.Application;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Handles the user authentication process.
	 */
	
	public class AuthenticationService extends Actor
	{
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var logger:Logger ;
		
		[Inject]
		public var errorManager:ErrorManager ;
		
		[Inject]
		public var authenticationSuccessSignal:AuthenticationSuccessSignal ;
		
		[Inject]
		public var saveCredentialsSignal:SaveCredentialsSignal ;
		
		[Inject]
		public var loggedOutSignal:LoggedOutSignal ;
		
		[Inject]
		public var authenticationErrorSignal:AuthenticationErrorSignal ;
		
		private var _loginData:CredentialsVO ;
		private var _cancelled:Boolean ;
		
		public function AuthenticationService( )
		{
		}
		
		// PUBLIC METHODS
		
		/**
		 * Sends the user's credentials to the server for authentication.
		 * @param data	User credentials
		 */
		
		public function authenticate( data:CredentialsVO ):void
		{
			trace( "AuthenticationService.authenticate:", data.email, data.password ) ;
			
			logger.log( "Signing in as " + data.email ) ;
			
			_cancelled = false ;
			_loginData = data ;
			
			var service:HTTPService = new HTTPService( ) ;
			var responder:Responder = new Responder( signupResultHandler, statusHandler ) ;
			var token:AsyncToken ;
			service.resultFormat = "text" ;
			service.method = URLRequestMethod.POST ;
			service.url = model.serverURL + Constants.API_URL + Constants.LOGIN_CALL ;
			
			token = service.send( { developer_api_key: Constants.API_KEY,
									email: escape( data.email ),
									password: data.password } ) ;
			token.addResponder( responder ) ;
		}
		
		/**
		 * Logs the user out. Note that there is no logout method in the API and the state is only stored in the client.
		 * Being logged out means the user isn't permitted to make any calls and will be taken back to the signup screen.
		 */
		
		public function logout( ):void
		{
			model.loggedIn = false ;
			loggedOutSignal.dispatch( ) ;
		}
		
		/**
		 * Cancels the login process.
		 */
		
		public function cancel( ):void
		{
			_cancelled = true ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Parses the result into a UserVO value object and dispatch an authenticationSuccessSignal.
		 * @param info	The server response
		 */
		
		private function signupResultHandler( info:Object ):void
		{
			if( _cancelled )
			{
				_cancelled = false ;
				return ;
			}
			
			trace( "AuthenticationService.signupResultHandler:", info.result ) ;
			
			var success:Boolean = true ;
			
			try
			{
				var obj:Object = JSON.decode( info.result ) ;
			}
			
			catch( e:Error )
			{
				authenticationErrorSignal.dispatch( ) ;
				success = false ;
			}
				
			if( success )
			{
				logger.log( "Authentication successful" ) ;
				
				for( var i:String in obj )
				{
					var data_parent:String = i ;
					break ;
				}
				
				var user:UserVO = VOParser.parseUser( obj[ data_parent ] ) ;
				model.loggedInUser = user ;
				authenticationSuccessSignal.dispatch( user ) ;
				saveCredentialsSignal.dispatch( _loginData ) ;
				errorManager.resolveError( Constants.ERROR_NOT_LOGGED_IN ) ;
			}
			
			else
			{
				logger.log( "Error with authentication: " + info.result ) ;
			}
		}
		
		/**
		 * Authentication unsuccessful
		 */
		
		private function statusHandler( info:Object ):void
		{
			if( _cancelled )
			{
				_cancelled = false ;
				return ;
			}
			
			trace( "AuthenticationService.statusHandler:", info ) ;
			authenticationErrorSignal.dispatch( ) ;
		}

	}
}