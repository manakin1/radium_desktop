package com.radium.crm.utils
{
	
	import air.net.URLMonitor;
	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.AuthenticateSignal;
	
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Monitors the Internet connection and sends a notification when the connection is lost/restored.
	 */
	
	public class ConnectionMonitor extends Actor
	{
		
		[Inject]
		public var authenticateSignal:AuthenticateSignal ;
		
		[Inject]
		public var errorManager:ErrorManager ;
		
		[Inject]
		public var model:ContentModel ;
		
		private var _monitor:URLMonitor ;
		
		public function ConnectionMonitor( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		public function init( ):void
		{
			if( _monitor ) return ;
			
			var request:URLRequest = new URLRequest( Constants.TEST_URL ) ;
			request.method = "HEAD" ;
			_monitor = new URLMonitor( request ) ;
			_monitor.addEventListener( StatusEvent.STATUS, statusHandler ) ;
			_monitor.start( ) ;
		}
		
		// EVENT HANDLERS

		private function statusHandler( e:StatusEvent ):void
		{
			if( e.code == "Service.available" ) 
			{
				errorManager.resolveError( Constants.ERROR_NO_INTERNET_CONNECTION ) ;
				
				// attempts to log in again in case the connection is restored and the user has not yet been authenticated
				if( !model.loggedIn && model.settings.rememberLogin && model.credentials )
				{
					authenticateSignal.dispatch( model.credentials ) ;
				}
			}
			
			else if( e.code == "Service.unavailable" ) errorManager.addError( Constants.ERROR_NO_INTERNET_CONNECTION ) ;
		}
	}
}