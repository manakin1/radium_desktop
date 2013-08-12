package com.radium.crm.events
{
	
	import flash.events.Event;

	public class UpdateEvent extends Event
	{
		
		private var _id:String ;
		private var _value:* ;
		
		public static const UPDATE_SETTINGS:String			= "updateSettings" ;
		
		public function UpdateEvent( type:String, id:String, value:*, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			_id = id ;
			_value = value ;
			
			super( type, bubbles, cancelable ) ;
		}
		
		// ACCESSOR METHODS
		
		public function get id( ):String
		{
			return _id ;
		}
		
		public function get value( ):*
		{
			return _value ;
		}
		
	}
}