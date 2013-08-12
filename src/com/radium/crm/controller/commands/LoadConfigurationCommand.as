package com.radium.crm.controller.commands{	
	import com.radium.crm.model.Constants;	import com.radium.crm.model.ContentModel;	import com.radium.crm.signals.ConfigurationLoadedSignal;	import com.radium.crm.signals.LoadSettingsSignal;		import flash.events.Event;	import flash.filesystem.* ;	import flash.net.URLLoader;	import flash.net.URLRequest;		import org.robotlegs.mvcs.SignalCommand;	 	/**	 * Loads the locally stored configuration XML file.	 */		public class LoadConfigurationCommand extends SignalCommand	{				[Inject]		public var configurationLoadedSignal:ConfigurationLoadedSignal ;				[Inject]		public var loadSettingsSignal:LoadSettingsSignal ;				[Inject]		public var model:ContentModel ;			override public function execute( ):void		{			var file:File = File.applicationDirectory.resolvePath( Constants.CONFIG_URL ) ; 			var fs:FileStream = new FileStream( ) ;			fs.open( file, FileMode.READ ) ;						var data:XML = XML( fs.readMultiByte( file.size, File.systemCharset ) ) ;						fs.close( ) ;			model.updateConfigurationData( data ) ;			configurationLoadedSignal.dispatch( data ) ;			loadSettingsSignal.dispatch( ) ;		}	}}