package com.king.hud.events 
{
	import starling.events.Event;
	
	/**
	 * Try again panel event
	 * @author mc
	 */
	public class TryAgainPanelEvent extends Event 
	{
		public static const TRY_AGAIN_BTN_TOUCH:String = "tryAgainBtnTouch";
		
		public function TryAgainPanelEvent(type:String, bubbles:Boolean=true, data:Object=null) 
		{
			super(type, bubbles, data);
		}
		
	}

}