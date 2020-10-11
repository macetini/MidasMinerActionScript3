package com.king.group.events 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author mc
	 */
	public class GroupEvent extends Event 
	{
		public static const SCORE_CHANGE:String = "scoreChange";
		public static const INTRO_ANIM_COMPLETE:String = "introAnimComplete";
			
		public function GroupEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}