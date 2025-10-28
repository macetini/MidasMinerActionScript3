package com.king.group.elements.event 
{	
	import starling.events.Event;
	/**
	 * Event class for group element related events.
	 * @author mc
	 */
	public class GroupElementEvent extends Event
	{
		/** Event type PARTICLE_CIRCLE_STOPPED circle effect has stopped */
		public static const PARTICLE_CIRCLE_STOPPED:String = "particleCircleStopped";
			
		/** Event type dispatched when the particle circle effect has completed its animation */
		public function GroupElementEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}