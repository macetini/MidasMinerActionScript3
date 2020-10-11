package com.king.hud 
{
	import com.king.group.events.GroupEvent;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.hud.events.TryAgainPanelEvent;
	import com.king.utils.ResourcesUtil;
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
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
	 * @author Marko Cetinic
	 */
	public class TryAgainPanel extends DisplayObjectContainer
	{
		public static const FONT:String = "Arial";
		public static const FONT_SIZE:int = 22;
		
		private var _panelImage:Image;
		private var _tryAgainInfo:TextField;
		private var _tryAgainBtn:Button;
		

		public function TryAgainPanel() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function get tryAgainBtn():Button 
		{
			return _tryAgainBtn;
		}
		
		public function set tryAgainBtn(value:Button):void 
		{
			_tryAgainBtn = value;
		}
		
		protected function tryAgainBtnTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
				this.dispatchEvent(new TryAgainPanelEvent(TryAgainPanelEvent.TRY_AGAIN_BTN_TOUCH));
		}
		
		protected function onAdded(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this.addChild(new Image(TextureConstants.HUD_PANEL_T));
			
			var tryAgainInfoStr:String = ResourcesUtil.grs("tryAgainInfo") + GameVariables.Score * ScorePanel.SCORE_MULTYPLY;
			
			_tryAgainInfo =  new TextField(this.width, 90, tryAgainInfoStr, FONT, FONT_SIZE, Color.WHITE, true);
			_tryAgainInfo.y = 17;
			_tryAgainInfo.hAlign = HAlign.CENTER;  // horizontal alignment
			_tryAgainInfo.vAlign = VAlign.CENTER; // vertical alignment
			
			this.addChild(_tryAgainInfo);
			
			_tryAgainBtn = new Button(TextureConstants.HUD_BUTTON_UP_T, ResourcesUtil.grs("tryAgainBtn"), TextureConstants.HUD_BUTTON_DOWN_T);
			_tryAgainBtn.x = (this.width - _tryAgainBtn.width) / 2;
			_tryAgainBtn.y = _tryAgainInfo.y + _tryAgainInfo.height + 1;
			
			_tryAgainBtn.addEventListener(TouchEvent.TOUCH, tryAgainBtnTouchHandler);
			
			this.addChild(_tryAgainBtn);
		}
	}

}