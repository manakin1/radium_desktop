package com.radium.crm.view.mediators
{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.DispatchErrorMessageSignal;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.view.components.MessageTray;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.binding.utils.ChangeWatcher;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the message tray.
	 */

	public class MessageTrayMediator extends Mediator
	{
		
		[Inject]
		public var view:MessageTray ;
		
		[Inject]
		public var dispatchErrorMessageSignal:DispatchErrorMessageSignal ;
		
		[Inject]
		public var model:ContentModel ;
		
		private var _resetTimer:Timer ;
		private var _delay:Number							= 10000 ;
		
		public function MessageTrayMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			dispatchErrorMessageSignal.add( updateMessage ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Update the error message on the screen.
		 * @param str	The new message to be displayed
		 */
		
		private function updateMessage( str:String ):void
		{
			view.message.text = str ;
		}
		
	}
}