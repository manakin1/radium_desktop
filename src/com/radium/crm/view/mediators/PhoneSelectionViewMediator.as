package com.radium.crm.view.mediators
{
	
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.PhoneSelectedSignal;
	import com.radium.crm.view.components.PhoneSelectionView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * The mediator for the phone selection view.
	 */

	public class PhoneSelectionViewMediator extends Mediator
	{
		
		[Inject]
		public var view:PhoneSelectionView ;
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var phoneSelectedSignal:PhoneSelectedSignal ;
		
		public function PhoneSelectionViewMediator( )
		{
			super( ) ;
		}
		
		// PUBLIC METHODS
		
		override public function onRegister( ):void
		{
			view.addEventListener( Event.SELECT, selectHandler ) ;
		}
		
		// EVENT HANDLERS
		
		/**
		 * Dispatches a phoneSelectedSignal with the selected device's info.
		 */
		
		private function selectHandler( e:Event ):void
		{
			phoneSelectedSignal.dispatch( view.serialCombo.selectedItem ) ;
		}

	}
}