package com.king.framework.events 
{	
	import starling.events.Event;
	/**
	 * Tween monitor event
	 * @author mc
	 */
	public class TweenMonitorEvent extends Event
	{
		/**	 
		 * Dispatched when all monitored tween animations are complete.
		 */
		public static const TWEEN_ANIMATIONS_COMPLETE:String = "tweenAnimationsComplete";
		
		/**
		 * Constructor
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function TweenMonitorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}