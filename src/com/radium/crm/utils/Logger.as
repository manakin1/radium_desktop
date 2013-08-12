package com.radium.crm.utils
{
	
	import com.radium.crm.model.ContentModel;
	
	import org.robotlegs.mvcs.Actor;
	
	public class Logger extends Actor
	{

		[Inject]
		public var model:ContentModel ;
		
		public function Logger( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		public function log( msg:String ):void
		{
			trace( "Logger.log: ", msg ) ;
			model.appendLog( msg ) ;
		}
		
	}
}