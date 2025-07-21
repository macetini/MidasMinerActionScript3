package com.king.utils
{
	import com.king.meta.constants.SoundConstants;

	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;

	public final class SoundUtil
	{
		public static const DEBUG:Boolean=false;

		public static var DEFAULT_VOLUMN:Number = 1.0;
		
		public function SoundUtil():void
		{
			throw(new Error("SoundUtil class is static class and can not be instantiated."));
		}

		public static function playSound(sound:Class, vol:Number=0):void
		{
			if (vol == 0)
				vol=DEFAULT_VOLUMN;

			var sfx:Sound=new sound() as Sound;

			if (sfx != null)
				sfx.play(0, 0, new SoundTransform(vol));
		}

		public static function playMetalClick():void
		{
			if (DEBUG)
				trace("\nPlay metal click");

			setTimeout(function():void
			{
				SoundUtil.playSound(SoundConstants.METAL_CLICK);
			}, 500);
		}

		public static function playMove():void
		{
			if (DEBUG)
				trace("\nPlay move");

			playSound(SoundConstants.MOVE_SOUND, 0.7);
		}

		public static function playPoint():void
		{
			if (DEBUG)
				trace("\nPlay point");

			playSound(SoundConstants.POINT);
		}

		public static function playReTry():void
		{
			if (DEBUG)
				trace("\nPlay re-try");

			playSound(SoundConstants.RETRY);
		}

		public static function playEndGame():void
		{
			if (DEBUG)
				trace("\nPlay end game");

			playSound(SoundConstants.END_GAME);
		}
	}
}

