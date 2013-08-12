package com.radium.crm.utils
{

	import com.radium.crm.model.vo.CallVO;
	import com.radium.crm.model.vo.ContactVO;
	import com.radium.crm.model.vo.DeviceInfoVO;
	import com.radium.crm.model.vo.SMSVO;
	import com.radium.crm.model.vo.SettingsVO;
	import com.radium.crm.model.vo.UserVO;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Parses the server responses into the appropriate value objects.
	 */
	
	public class VOParser extends Actor
	{
		
		public function VOParser( ) { }
		
		// PUBLIC METHODS
		
		public static function parseSettings( data:XML ):SettingsVO
		{
			var vo:SettingsVO = new SettingsVO( ) ;
			
			for each( var item:XML in data.settings.children( ) )
			{
				vo[ item.name( ) ] = ( item == "true" ) ;
			}
			
			return vo ;
		}
		
		public static function parseUser( data:Object ):UserVO
		{
			var vo:UserVO = new UserVO( ) ;
			
			for( var key:String in data )
			{
				try	{ vo[ key ] = data[ key ] ; }
				catch( e:Error ) { trace( "No such field in UserVO:", key ) ; }
			}
			
			return vo ;
		}
		
		public static function parseCall( obj:Object ):CallVO
		{
			var call:CallVO = new CallVO( ) ;
			
			call.number = obj.address ;
			call.duration = obj.duration ;
			call.date = Number( obj.date ) ;
			call.dialed_at = parseDate( Number( obj.date ) ) ;
			call.direction = getCallDirection( obj.flags ) ;
			call.kind = getCallType( obj.flags, obj.duration ) ;
			call.contactId = obj.id ;
			
			if( String( call.number ).length < 2 ) call.number = "0000000" ;
				
			return call ;
		}
		
		public static function parseSMS( obj:Object ):SMSVO
		{
			var sms:SMSVO = new SMSVO( ) ;
			
			sms.number = obj.address ;
			sms.date = Number( obj.date ) ;
			sms.sent_on = parseDate( Number( obj.date ) ) ;
			sms.direction = getCallDirection( obj.flags ) ;
			sms.message = obj.text ;
			sms.contactId = obj.group_id ;
			
			if( String( sms.number ).length < 2 || 
				isNaN( Number( sms.number ) ) ||
				sms.number == null ) sms.number = "000000" ;
			
			return sms ;
		}
		
		public static function parseContact( obj:Object ):ContactVO
		{
			var contact:ContactVO = new ContactVO( ) ;
			
			contact.id = obj.ROWID ;
			contact.firstName = obj.First ;
			contact.lastName = obj.Last ;
			contact.note = obj.Note ||= obj.Notes ;
			
			return contact ;
		}
		
		public static function parseDeviceInfo( data:XML ):DeviceInfoVO
		{
			var device:DeviceInfoVO = new DeviceInfoVO( ) ;
			
			var keys:Array = new Array( ) ;
			var values:Array = new Array( ) ;
			
			for each( var string:XML in data.dict.children( ) )
			{
				if( string.name( ) == "key" ) keys.push( string ) ;
				else values.push( string ) ;
			}
			
			for( var i:int = 0 ; i < keys.length ; i++ )
			{
				var key:String = keys[i].toLowerCase( ) ;
				
				if( key == "device name" ) device.deviceName = values[i] ;
				else if( key == "display name" ) device.displayName = values[i] ;
				else if( key == "product type" ) device.productType = values[i] ;
				else if( key == "serial number" ) device.serialNumber = values[i] ;
				else if( key == "product version" ) device.productVersion = values[i] ;
			}
			
			return device ;
		}
		
		private static function parseDate( value:Number ):String
		{
			var date_str:String = "" ;
			var date:Date = new Date( value * 1000 ) ;
			
			var tz:Number = date.timezoneOffset ;
			
			var hours:Number = Math.abs( tz / 60 ) ;
			var hours_str:String = String( hours ) ;
			if( hours_str.length == 1 ) hours_str = "0" + hours_str ;
			var sign:String = ( tz < 0 ) ? "+" : "-" ;
			var timezone:String = sign + hours_str + ":00" ;
			
			date_str = date.getFullYear( ) + "-" + ( formatNumber( date.getMonth( ) + 1 ) ) + "-" + 
					   formatNumber( date.getDate( ) ) +
					   "T" + formatNumber( date.getHours( ) ) + ":" + formatNumber( date.getMinutes( ) ) + ":" + 
					   formatNumber( date.getSeconds( ) ) ;
			
			date_str += timezone ;
			
			return date_str ;
		}
		
		private static function formatNumber( num:Number ):String
		{
			var str:String = String( num ) ;
			if( str.length == 1 ) str = "0" + str ;
			
			return str ;
		}
		
		private static function getCallDirection( flag:Number ):String
		{
			// fix later
			
			var dir:String = ( flag == 4 ) ? "incoming" : "outgoing" ;
			if( flag == 8 ) dir = "incoming" ;
			return dir ;
		}
		
		private static function getCallType( flag:Number, duration:Number ):String
		{
			var type:String = "" ;
			
			switch( flag )
			{
				case 4 : case 5 :
					type = "accepted" ;
					break ;

				default :
					type = "missed" ;
					break ;
			}
			
			if( duration == 0 ) type = "missed" ;
			
			return type ;
		}
		
	}
}