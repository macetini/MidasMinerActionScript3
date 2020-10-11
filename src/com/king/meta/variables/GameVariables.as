package com.king.meta.variables 
{
	/**
	 * ...
	 * @author mc
	 */
	public final class GameVariables 
	{
		public function GameVariables() 
		{
			throw(new Error("GameVariables class is static class and cant be instantiated."));
		}
		
		public static var Score:uint = 0;
		public static var TimerRunning:Boolean = false;
	}

}