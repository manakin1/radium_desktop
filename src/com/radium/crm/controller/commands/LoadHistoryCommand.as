package com.radium.crm.controller.commands
	import com.radium.crm.model.Constants;
	import com.radium.crm.model.ContentModel;
	import com.radium.crm.remote.services.LogService;
	import com.radium.crm.signals.SyncLoggedSignal;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.SignalCommand;
	 