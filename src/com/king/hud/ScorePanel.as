package com.king.hud
{
	import com.king.group.events.GroupEvent;
	import com.king.hud.events.ScorePanelEvent;
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.Color;
	import com.king.meta.constants.GraphicConstants;
	import com.king.meta.variables.GameVariables;
	import com.king.meta.constants.TextureConstants;
	
	/**
	 * ...
	 * @author mc
	 */
	public class ScorePanel extends DisplayObjectContainer
	{
		public static const FONT:String = "Arial";
		public static const FONT_SIZE:int = 22;
		
		public static const TIME_OUT:int = 60;
		public static const INTERVAL:int = 1000;
		
		public static const SCORE_MULTYPLY:uint = 5;
		
		private var _panelImage:Image;
		
		private var _scoreInfo:TextField;
		private var _timeCounterInfo:TextField;
		
		private var _counter:int;
		private var _timer:Timer;
		
		public function ScorePanel()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onRemoved(e:Event):void
		{
			_scoreInfo.text = 'Score\n0\nTime Left\n';
			_timeCounterInfo.text = "01:00";
		}
		
		protected function onAdded(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this.addChild(new Image(TextureConstants.HUD_PANEL_T));
			
			var scoreInfoStr:String = 'Score\n' + GameVariables.Score.toString() + '\nTime Left\n';
			
			_scoreInfo = new TextField(this.width, 90, scoreInfoStr, FONT, FONT_SIZE, Color.WHITE, true);
			_scoreInfo.y = 16;
			_scoreInfo.hAlign = HAlign.CENTER; // horizontal alignment
			_scoreInfo.vAlign = VAlign.CENTER; // vertical alignment
			
			this.addChild(_scoreInfo);
			
			_timeCounterInfo = new TextField(this.width, 40, "01:00", FONT, FONT_SIZE, Color.WHITE, true);
			_timeCounterInfo.y = _scoreInfo.y + _scoreInfo.height - 7;
			_timeCounterInfo.hAlign = HAlign.CENTER;
			_timeCounterInfo.vAlign = VAlign.CENTER;
			
			this.addChild(_timeCounterInfo);
		}
		
		public function scoreChange(e:GroupEvent):void
		{
			_scoreInfo.text = 'Score\n' + (GameVariables.Score * SCORE_MULTYPLY).toString() + '\nTime Left\n';
		}
		
		protected function timerEventHandler(e:TimerEvent):void
		{
			if (_counter > 0)
				if (_counter > 10)
					_timeCounterInfo.text = "00:" + --this._counter;
				else
					_timeCounterInfo.text = "00:0" + --this._counter;
			else
				_timeCounterInfo.text = "00:00";
		}
		
		protected function timerCompleteEvent(e:TimerEvent):void
		{
			trace("\nTime up event");
			
			GameVariables.TimerRunning = false;
			
			this.dispatchEvent(new ScorePanelEvent(ScorePanelEvent.TIMER_OVER_EVENT));
			
			_timer.reset();
		}
		
		public function startTimer(e:GroupEvent=null):void
		{
			trace("\nStart timer");
			
			GameVariables.TimerRunning = true;
			
			_timeCounterInfo.text = "0" + TIME_OUT / 60 + ":00";
			
			_counter = TIME_OUT;
			
			if (_timer == null)
			{
				_timer = new Timer(INTERVAL, TIME_OUT);
				_timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteEvent);
			}
			
			this._timer.start();
		}
		
		public function stopTimer():void
		{
			trace("\nStop timer");
			
			GameVariables.TimerRunning = false;
			
			this.dispatchEvent(new ScorePanelEvent(ScorePanelEvent.TIMER_OVER_EVENT));
			
			_timeCounterInfo.text = "01:00";
			
			if (_timer != null && this._timer.running)
				_timer.reset();
		}
	}

}