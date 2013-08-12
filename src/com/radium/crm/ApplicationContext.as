package com.radium.crm
{
	
	import com.radium.crm.controller.*;
	import com.radium.crm.controller.commands.*;
	import com.radium.crm.model.*;
	import com.radium.crm.remote.services.*;
	import com.radium.crm.signals.*;
	import com.radium.crm.utils.*;
	import com.radium.crm.view.components.*;
	import com.radium.crm.view.mediators.*;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	/**
	 * Initializes the application and maps the signals to the appropriate events.
	 */

	public class ApplicationContext extends SignalContext
	{
		
		public function ApplicationContext( contextView:DisplayObjectContainer = null, autoStartup:Boolean = true )
		{
			super( contextView, autoStartup ) ;
		}
		
		// PUBLIC METHODS
		
		override public function startup( ):void
		{
			mapInjector( ) ;
			mapCommands( ) ;
			mapMediators( ) ;
		}
		
		// PRIVATE METHODS
		
		private function mapInjector( ):void
		{
			injector.mapSingleton( StartupSignal ) ;
			injector.mapSingleton( LoadConfigurationSignal ) ;
			injector.mapSingleton( ConfigurationLoadedSignal ) ;
			injector.mapSingleton( LoadCredentialsSignal ) ;
			injector.mapSingleton( SaveCredentialsSignal ) ;
			injector.mapSingleton( CredentialsFailedSignal ) ;
			injector.mapSingleton( LoadSettingsSignal ) ;
			injector.mapSingleton( SettingsLoadedSignal ) ;
			injector.mapSingleton( SaveSettingsSignal ) ;
			injector.mapSingleton( AuthenticateSignal ) ;
			injector.mapSingleton( AuthenticationSuccessSignal ) ;
			injector.mapSingleton( LogoutSignal ) ;
			injector.mapSingleton( LoggedOutSignal ) ;
			injector.mapSingleton( AuthenticationErrorSignal ) ;
			injector.mapSingleton( VersionUpdateSignal ) ;
			injector.mapSingleton( SyncLoggedSignal ) ;
			injector.mapSingleton( DispatchErrorMessageSignal ) ;
			injector.mapSingleton( ShowPrivacyInfoSignal ) ;
			injector.mapSingleton( SelectPhoneSignal ) ;
			injector.mapSingleton( PhoneSelectedSignal ) ;
			injector.mapSingleton( ContentModel ) ;
			injector.mapSingleton( AuthenticationService ) ;
			injector.mapSingleton( LogService ) ;
			injector.mapSingleton( Logger ) ;
			injector.mapSingleton( SyncMonitor ) ;
			injector.mapSingleton( ConnectionMonitor ) ;
			injector.mapSingleton( ErrorManager ) ;
		}
		
		private function mapCommands( ):void
		{
			signalCommandMap.mapSignalClass( StartupSignal, StartupCommand ) ;
			signalCommandMap.mapSignalClass( LoadConfigurationSignal, LoadConfigurationCommand ) ;
			signalCommandMap.mapSignalClass( LoadCredentialsSignal, LoadCredentialsCommand ) ;
			signalCommandMap.mapSignalClass( LoadSettingsSignal, LoadSettingsCommand ) ;
			signalCommandMap.mapSignalClass( AuthenticateSignal, AuthenticateCommand ) ;
			signalCommandMap.mapSignalClass( CancelAuthenticationSignal, CancelAuthenticationCommand ) ;
			signalCommandMap.mapSignalClass( LogoutSignal, LogoutCommand ) ;
			signalCommandMap.mapSignalClass( SaveCredentialsSignal, SaveCredentialsCommand ) ;
			signalCommandMap.mapSignalClass( SaveSettingsSignal, SaveSettingsCommand ) ;
			signalCommandMap.mapSignalClass( LogCallsSignal, LogCallsCommand ) ;
			signalCommandMap.mapSignalClass( LogSMSSignal, LogSMSCommand ) ;
			signalCommandMap.mapSignalClass( LoadHistorySignal, LoadHistoryCommand ) ;
			signalCommandMap.mapSignalClass( LoadContactsSignal, LoadContactsCommand ) ;
			signalCommandMap.mapSignalClass( LogErrorSignal, LogErrorCommand ) ;
		}
		
		private function mapMediators( ):void
		{	
			mediatorMap.mapView( Main, ApplicationMediator ) ;
			mediatorMap.mapView( MainView, MainViewMediator ) ;
			mediatorMap.mapView( SignupView, SignupViewMediator ) ;
			mediatorMap.mapView( MessageTray, MessageTrayMediator ) ;
			mediatorMap.mapView( SyncPage, SyncPageMediator ) ;
			mediatorMap.mapView( AboutPage, AboutPageMediator ) ;
			mediatorMap.mapView( LoaderView, LoaderViewMediator ) ;
			mediatorMap.mapView( PhoneSelectionView, PhoneSelectionViewMediator ) ;
		}
		
	}
}