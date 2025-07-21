package com.king.framework
{
	import com.king.framework.events.TweenMonitorEvent;

	import starling.animation.Tween;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class TweenMonitor extends EventDispatcher
	{		
		protected var _monitTweensVec:Vector.<Tween> = null;
		
		public function TweenMonitor()
		{
			super();
		}

		protected function removeFromJuggler(e:Event):void
		{
			var tween:Tween = e.target as Tween;
			
			if(tween.hasEventListener(Event.REMOVE_FROM_JUGGLER))
				tween.removeEventListener(Event.REMOVE_FROM_JUGGLER, removeFromJuggler);
			
			if (_monitTweensVec != null)
				_monitTweensVec.splice(_monitTweensVec.indexOf(tween), 1);
			else
				return;
			
			if (_monitTweensVec.length == 0)
				this.dispatchEvent(new TweenMonitorEvent(TweenMonitorEvent.TWEEN_ANIMATIONS_COMPLETE));
		}
		
		public function addTween(tween:Tween):void
		{
			if (_monitTweensVec == null)
				_monitTweensVec = new Vector.<Tween>;
			
			tween.addEventListener(Event.REMOVE_FROM_JUGGLER, removeFromJuggler);
			_monitTweensVec.push(tween);
		}
		
		public function purge():void
		{
			if (_monitTweensVec == null)
				return;
			
			for (var i:int = 0; i < _monitTweensVec.length; i++)
			{
				_monitTweensVec[i].removeEventListener(Event.REMOVE_FROM_JUGGLER, removeFromJuggler);
				_monitTweensVec.splice(_monitTweensVec.indexOf(_monitTweensVec[i]), 1)
			}
				
			_monitTweensVec = null;
		}
	}
}