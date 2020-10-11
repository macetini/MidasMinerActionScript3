package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author mc
	 */
	
	[SWF(width = 755, height = 600, backgroundColor=0x5B789F)]
	 
	public class Preloader extends MovieClip 
	{
		public static const LINE_COLOR:uint = 0xFDC000;
		public static const FILL_COLOR:uint = 0xFB0201;  //fb0201
		
		protected var _progressBar:Shape;
		
		private var _px:int;
		private var _py:int;
		private var _w:int;
		private var _h:int;
		private var _sw:int;
		private var _sh:int;
		
		public function Preloader() 
		{
		
			if (stage != null)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				_sw = stage.stageWidth;
				_sh = stage.stageHeight;
				
				_w = stage.stageWidth * 0.8;
				_h = 20;
				
				_px = (_sw - _w) * 0.55;
				_py = (_sh - _h) * 0.90;
				
				this.graphics.beginFill(LINE_COLOR);
				this.graphics.drawRect(_px - 2, _py - 2, _w + 4, _h + 4);
				this.graphics.endFill();
				
				_progressBar = new Shape();
				
				this.addChild(_progressBar);
			}
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			var p:Number = (e.bytesLoaded / e.bytesTotal);
			
			_progressBar.graphics.clear();
			_progressBar.graphics.beginFill(FILL_COLOR);
			_progressBar.graphics.drawRect(_px, _py, p * _w, _h);
			_progressBar.graphics.endFill();
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			this.graphics.clear();
			this.removeChild(_progressBar);
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}