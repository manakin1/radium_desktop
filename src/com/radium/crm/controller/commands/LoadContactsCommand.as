package com.radium.crm.controller.commands
	import com.adobe.air.filesystem.events.FileMonitorEvent;
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.model.vo.ContactVO;
	import com.radium.crm.signals.LoadContactsSignal;
	import com.radium.crm.utils.ErrorManager;
	import com.radium.crm.utils.VOParser;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.SignalCommand;
	 