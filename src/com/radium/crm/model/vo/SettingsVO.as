package com.radium.crm.model.vo
{
	
	[Bindable]
	public class SettingsVO
	{
		
		public var syncCalls:Boolean ;
		public var syncSMS:Boolean ;
		public var rememberLogin:Boolean ;
		public var autoUpdate:Boolean ;
		public var autoSync:Boolean ;
		public var runOnStartup:Boolean ;
		
		public function SettingsVO( )
		{
		}

	}
}