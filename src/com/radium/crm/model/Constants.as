package com.radium.crm.model 
{
	
	public class Constants 
	{
		
		public static const APPLICATION_NAME:String				= "Radium Desktop" ;
		public static const SITE_URL:String						= "http://app.radiumcrm.com" ;
		
		// locally stored files
		
		public static const DATA_FOLDER:String					= "data/xml/" ;
		public static const CONFIG_URL:String					= "data/xml/config.xml" ;
		public static const SETTINGS_FILE:String				= "settings.xml" ;
		public static const HISTORY_FILE:String					= "history.xml" ;
		
		// version file URL
		
		public static const VERSION_FILE_URL:String				= "http://downloads.radiumcrm.com/radium_desktop/update.xml" ;
		
		// server URLs and API related constants
		
		public static const API_KEY:String						= "d88161e93705e35b0c9859d215d97944209281b7" ;
		public static const SERVER_URL:String					= "http://app.radiumcrm.com/" ;
		public static const API_URL:String						= "api/v2/" ;
		public static const TEST_URL:String						= "http://www.google.com/" ;
		
		// API calls
		
		public static const LOGIN_CALL:String					= "login" ;
		public static const CALLS_IMPORT_CALL:String			= "phone_calls/import.json" ;
		public static const SMS_IMPORT_CALL:String				= "sms_messages/import.json" ;
		public static const ERROR_LOG_CALL:String				= "mobile_error_logs" ;
		
		// Windows and OSX log directories
		
		public static const LOG_DIRECTORY_WIN:String			= "/AppData/Roaming/Apple Computer/MobileSync/Backup/" ;
		public static const LOG_DIRECTORY_XP:String				= "/Application Data/Apple Computer/MobileSync/Backup/" ;
		public static const LOG_DIRECTORY_MAC:String			= "/Library/Application Support/MobileSync/Backup/" ;
		public static const ITUNES_DIRECTORY_WIN:String			= "/AppData/Roaming/Apple Computer/iTunes/" ;
		public static const ITUNES_DIRECTORY_XP:String			= "/Application Data/Apple Computer/iTunes/" ;
		public static const ITUNES_DIRECTORY_MAC:String			= "/Library/iTunes/" ;
		
		// known names for iTunes log files
		
		public static const CALL_LOG_FILES:Array				= [ "ff1324e6b949111b2fb449ecddb50c89c3699a78", "2b2b0084a1bc3a5ac8c27afdf14afb42c61a19ca" ] ;
		public static const SMS_LOG_FILES:Array					= [ "3d0d7e5fb2ce288813306e4d4636395e047a3d28" ] ;
		public static const CONTACT_FILES:Array					= [ "31bb7ba8914766d4ba40d6dfb6113c8b614be442" ] ;
		public static const DEVICE_INFO_FILE:String 			= "Info.plist" ;
		
		// error messages
		
		public static const ERROR_SYNC_FILE_NOT_FOUND:String	= "Please sync your iPhone before trying to sync to Radium" ;
		public static const ERROR_IMPORT_FAILED:String			= "Synchronization failed" ;
		public static const ERROR_NOT_LOGGED_IN:String			= "You are not logged in" ;
		public static const ERROR_NO_INTERNET_CONNECTION:String	= "Check your Internet connection" ;
		public static const ERROR_ITUNES_NOT_FOUND:String		= "Please install iTunes to sync your iPhone with Radium" ;
		public static const ERROR_ITUNES_INCORRECT_VERSION:String = "Please upgrade to the latest version of iTunes" ;
		public static const ERROR_ENCRYPTED_DATA:String 		= "Encryption needs to be turned off in iTunes to sync your data" ;
		
		// sync status messages
		
		public static const STATUS_UP_TO_DATE:String			= "Up to date" ;
		public static const STATUS_SUCCESS:String				= "Sync successful" ;
		public static const STATUS_FAILED:String				= "Sync failed" ;
		
	}
	
}