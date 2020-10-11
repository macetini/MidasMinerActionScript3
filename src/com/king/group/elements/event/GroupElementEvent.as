package com.king.group.elements.event 
{	
	import starling.events.Event;
	/**
	 * ...
	 * @author mc
	 */
	public class GroupElementEvent extends Event
	{
		public static const PARTICLE_CIRCLE_STOPED:String = "particleCircleStoped";
		
		public function GroupElementEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}