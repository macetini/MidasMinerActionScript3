package com.king.meta.constants
{
	public final class SoundConstants
	{
		public function SoundConstants():void
		{
			throw(new Error("SoundConstants class is static class and can not be instantiated."));
		}
		
		[Embed(source="../../../../../assets/sounds/metal_clicks.mp3")]
		public static const METAL_CLICK:Class;

		[Embed(source="../../../../../assets/sounds/blop.mp3")]
		public static const MOVE_SOUND:Class;

		[Embed(source="../../../../../assets/sounds/point.mp3")]
		public static const POINT:Class;

		[Embed(source="../../../../../assets/sounds/retry.mp3")]
		public static const RETRY:Class;

		[Embed(source="../../../../../assets/sounds/end_game.mp3")]
		public static const END_GAME:Class;
	}
}
