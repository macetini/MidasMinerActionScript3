package com.king.hud 
{
	import com.king.group.events.GroupEvent;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.meta.constants.TextureConstants;
	import com.king.hud.events.EndGamePanelEvent;
	import com.king.utils.ResourcesUtil;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author mc
	 */
	public class EndGamePanel extends DisplayObjectContainer
	{
		public static const FONT:String = "Arial";
		public static const FONT_SIZE:int = 15;
		
		private var _gameInfo:TextField;
		private var _endGameBtn:Button;
		
		public function EndGamePanel() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function tryAgainBtnTouchHandler(e:TouchEvent):void
		{
			if (!_endGameBtn.enabled)
				return;
			
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				this.dispatchEvent(new EndGamePanelEvent(EndGamePanelEvent.END_GAME));
				_endGameBtn.enabled = false;
			}
		}
		
		protected function onAdded(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_gameInfo = new TextField(160, 120, ResourcesUtil.grs("endGameInfo"), FONT, FONT_SIZE, Color.BLACK, true);
			_gameInfo.y = 20;
			_gameInfo.hAlign = HAlign.CENTER;
			_gameInfo.vAlign = VAlign.CENTER;
			
			this.addChild(_gameInfo);
			
			_endGameBtn = new Button(TextureConstants.HUD_BUTTON_UP_T, ResourcesUtil.grs("endGameBtn"), TextureConstants.HUD_BUTTON_DOWN_T);
			
			_endGameBtn.x = (this.width - _endGameBtn.width) / 2;
			_endGameBtn.y = _gameInfo.y + _gameInfo.height;
			
			_endGameBtn.enabled = false;
			
			_endGameBtn.addEventListener(TouchEvent.TOUCH, tryAgainBtnTouchHandler);
			
			this.addChild(_endGameBtn);
		}
		
		public function groupRestartedEventHandler(e:GroupEvent):void
		{
			_endGameBtn.enabled = true;
		}
		
		public function timeOverEventHandler(e:ScorePanelEvent):void
		{
			_endGameBtn.enabled = false;
		}
	}

}