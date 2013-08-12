package com.radium.crm.controller.commands{	
	import com.radium.crm.signals.LoadConfigurationSignal;
	
	import org.robotlegs.mvcs.SignalCommand;		 		/**	 * Starts up the application.	 */		public class StartupCommand extends SignalCommand	{				[Inject]		public var loadConfigurationSignal:LoadConfigurationSignal ;		override public function execute( ):void		{			trace( "StartupCommand.execute" ) ;			loadConfigurationSignal.dispatch( ) ;		}	}}