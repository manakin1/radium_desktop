﻿package com.log2e.utils
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenLite;
	
	public class SpinningPreloader extends Sprite 
	{
		private var _target:DisplayObjectContainer;
		private var _container:Sprite;
		private var _centerX:uint;
		private var _centerY:uint;
		private var _radius:uint;
		private var _steps:uint;
		private var _rectWidth:uint;
		private var _rectHeight:uint;
		private var _color:uint;
		private var _count:uint;
		private var _timer:Timer;
		private var _timerInterval:uint;	
		private var _fadeOutDuration:Number;
				
		public function SpinningPreloader( 	target:DisplayObjectContainer, 
											centerX:uint = 0, 
											centerY:uint = 0, 
											radius:uint = 15, 
											steps:uint = 24, 
											rectWidth:uint = 4, 
											rectHeight:uint = 2, 
											color:uint = 0x0000FF, 
											timerInterval:uint = 20, 
											fadeOutDuration:Number = 1.5 ) 
		{
			_target = target;
			_centerX = centerX;
			_centerY = centerY;
			_radius = radius;
			_steps = steps;
			_rectWidth = rectWidth;
			_rectHeight = rectHeight;
			_color = color;
			_timerInterval = timerInterval;
			_fadeOutDuration = fadeOutDuration;
		}
		
		public function start():void
		{			
			_container = new Sprite();
			_container.x = _centerX;
			_container.y = _centerY;
			_target.addChild(_container);
			
			_count = 0;
			_timer = new Timer(_timerInterval, 0);
			_timer.addEventListener(TimerEvent.TIMER, drawRectangle);
			_timer.start();
		}
		
		public function stop():void
		{
			if (_container)
			{
				TweenLite.to( _container, .5, { alpha:0, onComplete:onContainerFadeOutComplete } );				
			}
		}
		
		private function onContainerFadeOutComplete():void
		{
			_timer.stop();
			
			if( _target.contains( _container ) ) 
			_target.removeChild(_container);
		}
		
		private function onRectFadeOutComplete(rect:Sprite):void
		{
			try
			{
				_container.removeChild(rect);
			}
			
			catch( e:Error ) { }
		}

		private function drawRectangle(e:TimerEvent):void
		{
			var rot:Number = _count * 360 / _steps;
			var rect:Sprite = filledRectangle(_rectWidth, _rectHeight, _color);
			rect.x = _radius * Math.cos(rot * Math.PI/180);
			rect.y = _radius * Math.sin(rot * Math.PI/180);
			rect.rotation = rot;
			_container.addChild(rect);
			
			TweenLite.to( rect, _fadeOutDuration, { alpha:0, onComplete:onRectFadeOutComplete, onCompleteParams:[rect] } );
			e.updateAfterEvent();
			
			_count++;
			if (_count == _steps)
			{
				_count = 0;
			}
		}
		
		private function filledRectangle(width:uint, height:uint, color:uint):Sprite 
		{
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(color);  
			rect.graphics.drawRect( -width/2, -height/2, width, height);
			rect.graphics.endFill();
			return rect;
        }
		
	}
	
}