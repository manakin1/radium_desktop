package com.radium.crm.controller.commands{	
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.CallVO;
	import com.radium.crm.model.vo.ContactVO;
	import com.radium.crm.remote.services.LogService;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.utils.VOParser;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.SignalCommand ;		/**	 * Logs an error.	 */
	 	public class LogErrorCommand extends SignalCommand	{				[Inject]		public var logService:LogService ;				[Inject]		public var errorObject:Object ;		override public function execute( ):void		{			trace( "LogErrorCommand.execute" ) ;						logService.logError( errorObject ) ;		}			}}