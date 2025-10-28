package com.king.hud.events 
{	
	import starling.events.Event;
	/**
	 * Score panel event
	 * @author mc
	 */
	public class ScorePanelEvent extends Event 
	{
		public static const TIMER_OVER_EVENT:String = "timerOverEvent";
		
		public function ScorePanelEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}