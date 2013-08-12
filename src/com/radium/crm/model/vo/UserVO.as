package com.radium.crm.model.vo
{
	
	[Bindable]
	public class UserVO
	{
		
		public var name:String ;
		public var last_request_at:String ;
		public var created_at:String ;
		public var updated_at:String ;
		public var crypted_password:String ;
		public var perishable_token:String ;
		public var manager_id:String ;
		public var api_key:String ;
		public var admin:String ;
		public var account_id:String ;
		public var password_changed:String ;
		public var id:String ;
		public var failed_login_count:String ;
		public var current_login_ip:String ;
		public var password_salt:String ;
		public var current_login_at:String ;
		public var phone:String ;
		public var persistence_token:String ;
		public var login_count:String ;
		public var time_zone:String ;
		public var locale:String ;
		public var last_login_ip:String ;
		public var last_login_at:String ;
		public var email:String ;
		public var attributes_updated_at:String ;
		
		public function UserVO( )
		{
		}
	
	}
}