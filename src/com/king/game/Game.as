package com.king.game
{
	import com.king.graphics.FlameClip;
	import com.king.group.Group;
	import com.king.group.elements.GroupElement;
	import com.king.hud.EndGamePanel;
	import com.king.hud.ScorePanel;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.hud.events.EndGamePanelEvent;
	import com.king.group.events.GroupEvent;
	import com.king.meta.constants.GraphicConstants;
	import com.king.meta.constants.TextureConstants;
	import com.king.hud.TryAgainPanel;
	import com.king.hud.events.TryAgainPanelEvent;
	import com.king.meta.variables.GameVariables;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author mc
	 */
	public class Game extends Sprite
	{
		public static const GROUP_X_POSITION:int = 329;
		public static const GROUP_Y_POSITION:int = 92;
		
		private var _group:Group;
		private var _scorePanel:ScorePanel;
		private var _tryAgainPanel:TryAgainPanel;
		private var _endGamePanel:EndGamePanel;
		private var _flameClip:FlameClip;
		
		public function Game()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this.addEventListener(ScorePanelEvent.TIMER_OVER_EVENT, timeOverEventHandler);
			this.addEventListener(EndGamePanelEvent.END_GAME, endGameHandler);
		}
		
		protected function addBackgroundImage():void
		{
			this.addChild(new Image(TextureConstants.BACKGROUND_IMAGE_T));
		}
		
		protected function addGroup():void
		{
			_group = new Group();
			_group.x = GROUP_X_POSITION;
			_group.y = GROUP_Y_POSITION - (Group.ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP));
			
			this.addChild(_group);
		}
		
		protected function addScorePanel():void
		{
			if (_scorePanel == null)
			{
				_scorePanel = new ScorePanel();
				_scorePanel.x = 20;
				_scorePanel.y = 80;
			}
			
			this.addChild(_scorePanel);
		}
		
		protected function addTryAgainPanel():void
		{
			if (_tryAgainPanel == null)
			{
				_tryAgainPanel = new TryAgainPanel();
				_tryAgainPanel.x = 20;
				_tryAgainPanel.y = 80;
			}
			
			this.addChild(_tryAgainPanel);
		}
		
		protected function timeOverEventHandler(e:ScorePanelEvent):void
		{
			this.removeChild(_scorePanel);
			
			addTryAgainPanel();
		}
		
		protected function endGameHandler(e:EndGamePanelEvent):void
		{
			_scorePanel.stopTimer();
		}
		
		protected function tryAgainBtnHandler(e:TryAgainPanelEvent):void
		{
			GameVariables.Score = 0;
			
			this.removeChild(_tryAgainPanel);
			
			_group.resetGridForRetry();
			
			addScorePanel();
		}
		
		protected function addEndGamePanel():void
		{
			_endGamePanel = new EndGamePanel();
			_endGamePanel.x = 35;
			_endGamePanel.y = 370;
			
			this.addChild(_endGamePanel);
		}
		
		protected function addFlameClip():void
		{
			_flameClip = new FlameClip;
			_flameClip.x = 200;
			_flameClip.y = 495;
			_flameClip.visible = false;
			
			this.addChild(_flameClip);
			
			Starling.juggler.add(_flameClip);
		}
		
		protected function onAdded(e:Event):void
		{
			addBackgroundImage();
			addScorePanel();
			addGroup();
			addEndGamePanel();
			addFlameClip();
			
			this.addEventListener(GroupEvent.SCORE_CHANGE, _scorePanel.scoreChange);
			
			this.addEventListener(GroupEvent.INTRO_ANIM_COMPLETE, _scorePanel.startTimer);
			this.addEventListener(GroupEvent.INTRO_ANIM_COMPLETE, _flameClip.startFlame);
			
			this.addEventListener(ScorePanelEvent.TIMER_OVER_EVENT, _group.timeOverEventHandler);
			this.addEventListener(ScorePanelEvent.TIMER_OVER_EVENT, _flameClip.stopFlame);
			
			this.addEventListener(TryAgainPanelEvent.TRY_AGAIN_BTN_TOUCH, tryAgainBtnHandler);
			
			this.addEventListener(GroupEvent.INTRO_ANIM_COMPLETE, _endGamePanel.groupRestartedEventHandler);
			this.addEventListener(ScorePanelEvent.TIMER_OVER_EVENT, _endGamePanel.timeOverEventHandler);
		}
	}
}