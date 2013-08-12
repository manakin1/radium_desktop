package com.radium.crm.model.vo
{
	
	public class CredentialsVO
	{
		
		public var email:String ;
		public var password:String ;
		public var name:String ;
		
		public function CredentialsVO( email_str:String, password_str:String, name_str:String = null )
		{
			email = email_str ;
			password = password_str ;
			name = name_str ;
		}

	}
}