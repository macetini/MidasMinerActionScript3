package com.king.hud.events 
{	
	import starling.events.Event;
	/**
	 * End game panel event
	 * @author mc
	 */
	public class EndGamePanelEvent extends Event
	{
		public static const END_GAME:String = "endGame";
		
		public function EndGamePanelEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}