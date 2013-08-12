package com.radium.crm.controller.commands{		import com.radium.crm.model.Constants;	import com.radium.crm.model.ContentModel;	import com.radium.crm.model.vo.SettingsVO;	import com.radium.crm.signals.LoadCredentialsSignal;	import com.radium.crm.signals.SaveSettingsSignal;	import com.radium.crm.signals.SettingsLoadedSignal;	import com.radium.crm.utils.SyncMonitor;	import com.radium.crm.utils.VOParser;		import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.filesystem.*;	import flash.net.URLLoader;	import flash.net.URLRequest;		import org.robotlegs.mvcs.SignalCommand;		/**	 * Loads the locally stored settings file.	 */
	 	public class LoadSettingsCommand extends SignalCommand	{		[Inject]		public var loadCredentialsSignal:LoadCredentialsSignal ;				[Inject]		public var settingsLoadedSignal:SettingsLoadedSignal ;				[Inject]		public var saveSettingsSignal:SaveSettingsSignal ;				[Inject]		public var model:ContentModel ;		override public function execute( ):void		{			trace( "LoadSettingsCommand.execute" ) ;						var file:File = File.applicationStorageDirectory.resolvePath( model.settingsURL ) ; 						if( file.exists )			{				var fs:FileStream = new FileStream( ) ;				fs.open( file, FileMode.READ ) ;								var data:XML = XML( fs.readMultiByte( file.size, File.systemCharset ) ) ;								fs.close( ) ;				model.settings = VOParser.parseSettings( data )	;			}						// creates a new settings file if one does not exist (new user)						else createSettings( ) ;						settingsLoadedSignal.dispatch( ) ;			loadCredentialsSignal.dispatch( ) ;		}				private function createSettings( ):void		{				var settings:SettingsVO = new SettingsVO( ) ;			settings.autoSync = true ;			settings.autoUpdate = true ;			settings.rememberLogin = true ;			settings.runOnStartup = true ;			settings.syncCalls = true ;			settings.syncSMS = true ;						model.settings = settings ;			model.firstTimeUser = true ;						saveSettingsSignal.dispatch( "runOnStartup", true ) ;		}			}}