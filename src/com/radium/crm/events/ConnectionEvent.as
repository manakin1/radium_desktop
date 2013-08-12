package com.radium.crm.events
{
	
	import flash.events.Event;

	public class ConnectionEvent extends Event
	{
		
		public static const LOGOUT:String			= "logout" ;
		
		public function ConnectionEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable ) ;
		}
		
		
	}
}