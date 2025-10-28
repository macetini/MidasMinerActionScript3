package com.king.game
{
	import com.king.graphics.FlameClip;
	import com.king.group.Group;
	import com.king.group.elements.GroupElement;
	import com.king.group.events.GroupEvent;
	import com.king.hud.EndGamePanel;
	import com.king.hud.ScorePanel;
	import com.king.hud.TryAgainPanel;
	import com.king.hud.events.EndGamePanelEvent;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.hud.events.TryAgainPanelEvent;
	import com.king.meta.constants.TextureConstants;
	import com.king.meta.variables.GameVariables;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Main game class that manages the core gameplay mechanics and UI components.
	 * 
	 * The Game class extends Starling's Sprite and serves as the central controller
	 * for the match-3 puzzle game. It handles the initialization and coordination
	 * of various game components including the game grid, score panel, flame effects,
	 * and end game screens.
	 * 
	 * Key responsibilities:
	 * - Managing the game grid and element matching logic
	 * - Handling timer-based gameplay mechanics
	 * - Coordinating UI panels (score, try again, end game)
	 * - Managing visual effects (flame animations)
	 * - Processing game state transitions
	 * 
	 * @author mc
	 */
	public class Game extends Sprite
	{
		/* Constants */

		/**
		 * Horizontal position of the game grid relative to the stage.
		 * Positions the group of game elements horizontally on screen.
		 */
		public static const GROUP_X_POSITION:int = 329;
		
		/**
		 * Vertical position of the game grid relative to the stage.
		 * Positions the group of game elements vertically on screen.
		 */
		public static const GROUP_Y_POSITION:int = 92;
		
		/* Members */
		
		/** The main game grid containing all interactive game elements */
		private var _group:Group;
		
		/** UI panel displaying current score and timer */
		private var _scorePanel:ScorePanel;
		
		/** UI panel shown when game time expires, allowing restart */
		private var _tryAgainPanel:TryAgainPanel;
		
		/** UI panel displayed at game end showing final results */
		private var _endGamePanel:EndGamePanel;
		
		/** Animated flame effect displayed during active gameplay */
		private var _flameClip:FlameClip;
		
		/* Constructor */
		
		/**
		 * Initializes the Game instance and sets up core event listeners.
		 * 
		 * Sets up listeners for:
		 * - ADDED_TO_STAGE: Triggers full game initialization
		 * - TIMER_OVER_EVENT: Handles game time expiration
		 * - END_GAME: Processes game completion
		 */
		public function Game()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this.addEventListener(ScorePanelEvent.TIMER_OVER_EVENT, timeOverEventHandler);
			this.addEventListener(EndGamePanelEvent.END_GAME, endGameHandler);
		}
		
		/**
		 * Adds the background image to the display list.
		 * Uses the background texture defined in TextureConstants.
		 */
		protected function addBackgroundImage():void
		{
			this.addChild(new Image(TextureConstants.BACKGROUND_IMAGE_T));
		}
		
		/**
		 * Creates and positions the main game grid.
		 * 
		 * Initializes the Group instance that contains all interactive game elements
		 * and positions it according to the defined constants, accounting for
		 * the grid dimensions and element spacing.
		 */
		protected function addGroup():void
		{
			_group = new Group();
			_group.x = GROUP_X_POSITION;
			_group.y = GROUP_Y_POSITION - (Group.ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP));
			
			this.addChild(_group);
		}
		
		/**
		 * Creates and positions the score panel UI.
		 * 
		 * Initializes the ScorePanel if it doesn't exist and positions it
		 * in the upper-left area of the screen. The score panel displays
		 * the current score and game timer.
		 */
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
		
		/**
		 * Creates and positions the try again panel UI.
		 * 
		 * Initializes the TryAgainPanel if it doesn't exist and positions it
		 * in the same location as the score panel. This panel is shown when
		 * the game timer expires, allowing the player to restart.
		 */
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
		
		/**
		 * Handles the timer expiration event.
		 * 
		 * Removes the score panel from display and shows the try again panel,
		 * allowing the player to restart the game.
		 * 
		 * @param e The ScorePanelEvent containing timer expiration data
		 */
		protected function timeOverEventHandler(e:ScorePanelEvent):void
		{
			this.removeChild(_scorePanel);
			
			addTryAgainPanel();
		}
		
		/**
		 * Handles the end game event.
		 * 
		 * Stops the score panel timer when the game ends.
		 * 
		 * @param e The EndGamePanelEvent containing end game data
		 */
		protected function endGameHandler(e:EndGamePanelEvent):void
		{
			_scorePanel.stopTimer();
		}
		
		/**
		 * Handles the try again button press event.
		 * 
		 * Resets the game state by:
		 * - Resetting the score to 0
		 * - Removing the try again panel
		 * - Resetting the game grid for a new attempt
		 * - Restoring the score panel
		 * 
		 * @param e The TryAgainPanelEvent containing button press data
		 */
		protected function tryAgainBtnHandler(e:TryAgainPanelEvent):void
		{
			GameVariables.Score = 0;
			
			this.removeChild(_tryAgainPanel);
			
			_group.resetGridForRetry();
			
			addScorePanel();
		}
		
		/**
		 * Creates and positions the end game panel UI.
		 * 
		 * Initializes the EndGamePanel and positions it in the lower area
		 * of the screen. This panel displays final game results and statistics.
		 */
		protected function addEndGamePanel():void
		{
			_endGamePanel = new EndGamePanel();
			_endGamePanel.x = 35;
			_endGamePanel.y = 370;
			
			this.addChild(_endGamePanel);
		}
		
		/**
		 * Creates and configures the flame animation effect.
		 * 
		 * Initializes the FlameClip animation, positions it near the bottom
		 * of the screen, and adds it to the Starling juggler for animation
		 * management. The flame starts invisible and is controlled by game events.
		 */
		protected function addFlameClip():void
		{
			_flameClip = new FlameClip;
			_flameClip.x = 200;
			_flameClip.y = 495;
			_flameClip.visible = false;
			
			this.addChild(_flameClip);
			
			Starling.juggler.add(_flameClip);
		}
		
		/**
		 * Main initialization method called when the Game is added to the stage.
		 * 
		 * This method orchestrates the complete game setup by:
		 * 1. Adding all visual components (background, panels, grid, effects)
		 * 2. Setting up the event listener network between components
		 * 3. Connecting game logic events to UI updates
		 * 
		 * Event connections established:
		 * - Score changes update the score panel
		 * - Animation completion triggers timer and flame effects
		 * - Timer expiration affects grid and flame states
		 * - UI button interactions trigger game state changes
		 * 
		 * @param e The Event.ADDED_TO_STAGE event
		 */
		protected function onAdded(e:Event):void
		{
			addBackgroundImage();
			addScorePanel();
			addGroup();
			addEndGamePanel();
			addFlameClip();
			addListeners();			
		}

	/*
	 * Adds event listeners for various game events.
	 * 
	 * This method connects UI components to their respective event handlers,
	 * ensuring that game logic is properly linked to user interactions and
	 * animations.
	 */
	private function addListeners():void
	{
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