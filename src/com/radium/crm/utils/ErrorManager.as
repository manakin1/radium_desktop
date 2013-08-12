package com.radium.crm.utils
{
	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.signals.DispatchErrorMessageSignal;
	import com.radium.crm.signals.LogErrorSignal;
	
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Keeps track of the error messages.
	 */
	
	public class ErrorManager extends Actor
	{
		
		[Inject]
		public var model:ContentModel ;
		
		[Inject]
		public var dispatchErrorMessageSignal:DispatchErrorMessageSignal ;
		
		[Inject]
		public var logErrorSignal:LogErrorSignal ;
	
		private var _currentError:String 			= "" ;	
		private var _errorStack:Array 				= new Array( ) ;
		
		public function ErrorManager( )
		{
			super( ) ;
		}
		
		// ACCESSOR METHODS
		
		/**
		 * Returns the currently displayed error message.
		 */
		
		public function get currentError( ):String
		{
			return _currentError;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Checks for new/resolved errors.
		 * @param file	Reference to a file the application is trying to locate.
		 */
		
		public function runCheck( file:File ):Boolean
		{
			var ok:Boolean = true ;
			
			if( !model.loggedIn )
			{
				addError( Constants.ERROR_NOT_LOGGED_IN ) ;
				ok = false ;
			}
			
			if( !file || !model.backupDirectory ) 
			{
				addError( Constants.ERROR_SYNC_FILE_NOT_FOUND ) ;
				ok = false ;
			}
			
			if( !foundITunes( ) )
			{
				addError( Constants.ERROR_ITUNES_NOT_FOUND ) ;
				ok = false ;
			}
			
			resolve( file ) ;

			return ok ;
		}

		/**
		 * Adds an error message to the error stack after checking it's not already there.
		 * @param str	The new error message
		 */
		
		public function addError( str:String ):void
		{
			if( _errorStack.indexOf( str ) == -1 ) 
			{
				trace( "ErrorStack.addError:", str ) ;
				logError( str ) ;
				
				_errorStack.push( str ) ;
				_currentError = str ;
				dispatchErrorMessageSignal.dispatch( _currentError ) ;
			}
		}
		
		/**
		 * Removes an error message from the stack after the error has been resolved.
		 * @param str	The error message to be removed
		 */
		
		public function resolveError( str:String ):void
		{
			if( _errorStack.length == 0 ) return ;
			
			var index:int = _errorStack.indexOf( str ) ;
			if( index != -1 ) 
			{
				trace( "ErrorStack.removeError:", str ) ;
				
				_errorStack.splice( index, 1 ) ;
				var len:int = _errorStack.length - 1 ;
				_currentError = _errorStack[ len ] ;
				if( _errorStack.length == 0 ) _currentError = "" ;
				dispatchErrorMessageSignal.dispatch( _currentError ) ;
			}
		}
		
		/**
		 * Attempt to resolve current error messages.
		 * @param file	Reference to a file the application is trying to locate.
		 */
		
		public function resolve( file:File ):void
		{
			if( model.loggedIn ) resolveError( Constants.ERROR_NOT_LOGGED_IN ) ;
			if( file ) resolveError( Constants.ERROR_SYNC_FILE_NOT_FOUND ) ;
			if( foundITunes( ) ) resolveError( Constants.ERROR_ITUNES_NOT_FOUND ) ;
		}

		public function logError( str:String ):void
		{
			logErrorSignal.dispatch( { description: str } ) ;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Checks if iTunes is found on the user's system.
		 */
		
		private function foundITunes( ):Boolean
		{
			var dir:String ;
			var os:String = Capabilities.os.toLowerCase( ) ;
			
			if( os.indexOf( "xp" ) != -1 ) dir = Constants.ITUNES_DIRECTORY_XP ;
			else if( os.indexOf( "windows" ) != -1 ) dir = Constants.ITUNES_DIRECTORY_WIN ;
			else if( os.indexOf( "mac" ) != -1 ) dir = Constants.ITUNES_DIRECTORY_MAC ;
			
			var folder:File = new File( File.userDirectory.nativePath + dir ) ;
			
			return folder.exists ;
		}
	}
}