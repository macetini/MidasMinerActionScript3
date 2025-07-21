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
	 * ...
	 * @author mc
	 */
	public class FlameClip extends MovieClip
	{
		public static const TEXTURE_PREFIX:String = "flame_frames_";
		public static const FPS:uint = 24;
		
		public static const X_INIT:int = 200;
		public static const Y_INIT:int = 495;
		
		public static const FRAME_COUNT:uint = 13;
		
		private var _x:Number = X_INIT;
		private var _y:Number = Y_INIT;
		
		private var _frameCounter:uint = FRAME_COUNT;
		
		public function FlameClip()
		{
			var texture:Texture = Texture.fromBitmap(new GraphicConstants.FLAME_FRAMES());
			var xml:XML = XML(new GraphicConstants.FLAME_ATLAS_XML());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			super(atlas.getTextures(TEXTURE_PREFIX), FPS);
		}
		
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
		
		public function startFlame(e:GroupEvent = null):void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
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