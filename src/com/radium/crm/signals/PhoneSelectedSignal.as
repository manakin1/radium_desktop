package com.radium.crm.signals{		import com.radium.crm.model.vo.DeviceInfoVO;
	
	import org.osflash.signals.Signal ;		public class PhoneSelectedSignal extends Signal 	{				public function PhoneSelectedSignal( )		{			super( DeviceInfoVO ) ;		}			}}