package com.king.utils
{
	import com.king.meta.constants.TextureConstants;

	import starling.textures.Texture;
	
	/**
	 * Utility class for getting textures
	 * @author mc
	 */
	public final class TextureUtil
	{
		public function TextureUtil()
		{
			throw new Error('Static class');
		}
		
		public static function elemUnselectedTexture(color:uint):Texture
		{
			var retVal:Texture;
			
			switch (color)
			{
				case 0: 
					retVal = TextureConstants.BLUE_ELEM_N_T;
					break;
				case 1: 
					retVal = TextureConstants.GREEN_ELEM_N_T;
					break;
				case 2: 
					retVal = TextureConstants.PURPLE_ELEM_N_T;
					break;
				case 3: 
					retVal = TextureConstants.RED_ELEM_N_T;
					break;
				case 4: 
					retVal = TextureConstants.YELLOW_ELEM_N_T;
					break;
			}
			
			return retVal;
		}
		
		public static function elemSelectedTexture(color:uint):Texture
		{
			var retVal:Texture;
			
			switch (color)
			{
				case 0: 
					retVal = TextureConstants.BLUE_ELEM_S_T;
					break;
				case 1: 
					retVal = TextureConstants.GREEN_ELEM_S_T;
					break;
				case 2: 
					retVal = TextureConstants.PURPLE_ELEM_S_T;
					break;
				case 3: 
					retVal = TextureConstants.RED_ELEM_S_T;
					break;
				case 4: 
					retVal = TextureConstants.YELLOW_ELEM_S_T;
					break;
			}
			
			return retVal;
		}
	}

}