package com.king.graphics
{
	import com.king.group.events.GroupEvent;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.meta.constants.GraphicConstants;

	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Animated flame effect that follows a predefined path across the screen.
	 * 
	 * FlameClip extends MovieClip to provide a complex animated flame effect that moves
	 * along a mathematical curve path. The animation combines sprite-based frame animation
	 * with procedural movement calculations to create a dynamic flame that travels from
	 * the bottom-right area of the screen towards the upper-left following multiple
	 * mathematical functions (tangent, cosine, and linear movements).
	 * 
	 * Key features:
	 * - Frame-based sprite animation using texture atlas
	 * - Mathematical path following with multiple movement phases
	 * - Event-driven start/stop control tied to game events
	 * - Automatic reset to initial position when stopped
	 * - Performance optimization through frame counting
	 * 
	 * Movement phases:
	 * 1. Tangential curve from starting position (y > 490)
	 * 2. Linear downward movement (490 > y > 452) 
	 * 3. Cosine wave movement (452 > y > 450)
	 * 4. Cosine oscillation while moving left (y <= 450, x > 150)
	 * 5. Diagonal movement upward-left (x <= 150, y > 312)
	 * 6. Final horizontal movement left (y <= 312, x > 110)
	 * 
	 * @author mc
	 */
	public class FlameClip extends MovieClip
	{
		/** Texture name prefix for flame animation frames in the texture atlas */
		public static const TEXTURE_PREFIX:String = "flame_frames_";
		
		/** Animation playback speed in frames per second */
		public static const FPS:uint = 24;
		
		/** Initial horizontal position of the flame when created or reset */
		public static const X_INIT:int = 200;
		
		/** Initial vertical position of the flame when created or reset */
		public static const Y_INIT:int = 495;
		
		/** Number of frames to wait between movement calculations for performance optimization */
		public static const FRAME_COUNT:uint = 13;
		
		/** Internal horizontal position used for mathematical calculations */
		private var _x:Number = X_INIT;
		
		/** Internal vertical position used for mathematical calculations */
		private var _y:Number = Y_INIT;
		
		/** Frame counter for movement timing - decrements each frame until reaching zero */
		private var _frameCounter:uint = FRAME_COUNT;
		
		/**
		 * Initializes the FlameClip with texture atlas animation.
		 * 
		 * Creates a MovieClip using flame animation frames from a texture atlas.
		 * The constructor loads the flame texture and XML atlas data from GraphicConstants,
		 * creates a TextureAtlas, extracts textures matching the TEXTURE_PREFIX,
		 * and initializes the parent MovieClip with the animation frames and FPS.
		 */
		public function FlameClip()
		{
			var texture:Texture = Texture.fromBitmap(new GraphicConstants.FLAME_FRAMES());
			var xml:XML = XML(new GraphicConstants.FLAME_ATLAS_XML());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			super(atlas.getTextures(TEXTURE_PREFIX), FPS);
		}
		
		/**
		 * Handles frame-by-frame movement calculations for the flame animation.
		 * 
		 * This method implements a complex multi-phase movement pattern using mathematical
		 * functions to create a realistic flame path. Movement is throttled by the frame
		 * counter for performance optimization.
		 * 
		 * Movement algorithm phases:
		 * 1. Phase 1 (y > 490): Tangential curve movement using -3*tan(x/5) + 495
		 * 2. Phase 2 (490 > y > 452): Simple linear downward movement
		 * 3. Phase 3 (452 > y > 450): Cosine wave using -3*cos(x/6) + 452
		 * 4. Phase 4 (y <= 450, x > 150): Cosine oscillation using cos(x/15) + 450
		 * 5. Phase 5 (x <= 150, y > 312): Diagonal upward-left movement
		 * 6. Phase 6 (y <= 312, x > 110): Final horizontal leftward movement
		 * 
		 * @param e The ENTER_FRAME event triggered each frame
		 */
		protected function enterFrameHandler(e:Event):void
		{
			if (_frameCounter > 0)
			{
				_frameCounter--;
				return;
			}
			else
				_frameCounter = FRAME_COUNT;
			
			if (this.y > 490)
			{
				this._x++;
				this._y = -3.0 * Math.tan(_x / 5.0) + 495;
				
				this.x--;
				this.y = _y;
			}
			
			if (this.y < 490 && this.y > 452)
			{
				this._y--;
				this.y = this._y;
			}
			
			if (this.y <= 452 && this.y > 450)
			{
				this._x++;
				this._y = -3 * Math.cos(_x / 6.0) + 452;
				
				this.x--;
				this.y = _y;
			}
			
			if (this.y <= 450 && this.x > 150)
			{
				this._x++;
				this._y = Math.cos(_x / 15) + 450;
				
				this.x--;
				this.y = _y;
			}
			
			if (this.x <= 150 && this.y > 312)
			{
				this.x -= 0.05;
				this.y--;
			}
			
			if (this.y <= 312 && this.x > 110)
			{
				this.x--;
			}
		}
		
		/**
		 * Starts the flame animation and movement.
		 * 
		 * Makes the flame visible and begins the frame-by-frame movement by adding
		 * the ENTER_FRAME event listener. This method is typically called in response
		 * to game events such as the completion of intro animations.
		 * 
		 * @param e Optional GroupEvent parameter, allows method to be used as event handler
		 */
		public function startFlame(e:GroupEvent = null):void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Stops the flame animation and resets to initial state.
		 * 
		 * Performs a complete reset of the flame effect by:
		 * - Removing the ENTER_FRAME event listener to stop movement
		 * - Making the flame invisible
		 * - Resetting the frame counter to its initial value
		 * - Restoring both internal and display positions to starting coordinates
		 * 
		 * This method is typically called when the game timer expires or when
		 * the game needs to reset the flame effect.
		 * 
		 * @param e Optional ScorePanelEvent parameter, allows method to be used as event handler
		 */
		public function stopFlame(e:ScorePanelEvent = null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			this.visible = false;
			
			_frameCounter = FRAME_COUNT;
			
			this.x = _x = X_INIT;
			this.y = _y = Y_INIT;
		}
	}

}