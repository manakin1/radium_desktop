package com.radium.crm.model.vo
{
	
	[Bindable]
	public class CallVO extends Object
	{

		public var number:String ;
		public var direction:String ;
		public var kind:String ;
		public var dialed_at:String ;
		public var date:Number ;
		public var duration:Number ;
		public var contactId:String ;
		public var name:String ;
		
		public function CallVO( )
		{
		}
	
	}
}