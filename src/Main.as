package  
{
	import flash.display.Sprite;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import starling.core.Starling;
	import com.king.game.Game;
	
	/**
	 * ...
	 * @author mc
	 */
	[Frame(factoryClass="Preloader")]
	
	[SWF(width="755",height="600",frameRate="60",backgroundColor="#000000")]
	
	public class Main extends Sprite
	{
		private var mStarling:Starling;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			// create our Starling instance
			
			mStarling = new Starling(Game, stage, null, null, Context3DRenderMode.AUTO);
			
			// show the stats window (draw calls, memory)
			mStarling.showStats = true;
			// set anti-aliasing (higher the better quality but slower performance)
			mStarling.antiAliasing = 1;
			// start it!
			mStarling.start();
		}
	}

}