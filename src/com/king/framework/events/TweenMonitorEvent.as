package com.king.framework.events 
{	
	import starling.events.Event;
	/**
	 * ...
	 * @author mc
	 */
	public class TweenMonitorEvent extends Event
	{
		public static const TWEEN_ANIMATIONS_COMPLETE:String = "tweenAnimationsComplete";
		
		public function TweenMonitorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}