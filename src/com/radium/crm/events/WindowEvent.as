package com.radium.crm.events
{
	
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		
		public static const MINIMIZE:String			= "minimize" ;
		
		public function WindowEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable ) ;
		}
		
		
	}
}