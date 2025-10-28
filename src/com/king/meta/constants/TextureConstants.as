package com.king.meta.constants 
{
	import com.king.meta.constants.GraphicConstants;

	import starling.textures.Texture;
	
	/**
	 * Texture constants
	 * @author mc
	 */
	public final class TextureConstants 
	{
		public function TextureConstants():void
		{
			throw(new Error("TextureConstants class is static class and can not be instantiated."));
		}
		
		//Background
		
		public static const BACKGROUND_IMAGE_T:Texture = Texture.fromBitmap(new GraphicConstants.BACKGROUND_IMAGE);
		
		//Panel
		
		public static const HUD_PANEL_T:Texture = Texture.fromBitmap(new GraphicConstants.HUD_PANEL);
		
		//Hud
		
		//Button
			
		public static const HUD_BUTTON_UP_T:Texture = Texture.fromBitmap(new GraphicConstants.HUD_BUTTON_UP);
		public static const HUD_BUTTON_DOWN_T:Texture = Texture.fromBitmap(new GraphicConstants.HUD_BUTTON_DOWN);
		
		//Group
		
		//Selected 
		
		public static const BLUE_ELEM_N_T:Texture = Texture.fromBitmap(new GraphicConstants.BLUE_ELEM_N());
		public static const GREEN_ELEM_N_T:Texture = Texture.fromBitmap(new GraphicConstants.GREEN_ELEM_N);
		public static const PURPLE_ELEM_N_T:Texture = Texture.fromBitmap(new GraphicConstants.PURPLE_ELEM_N);
		public static const RED_ELEM_N_T:Texture = Texture.fromBitmap(new GraphicConstants.RED_ELEM_N);
		public static const YELLOW_ELEM_N_T:Texture = Texture.fromBitmap(new GraphicConstants.YELLOW_ELEM_N);
		
		//Un selected 
		
		public static const BLUE_ELEM_S_T:Texture = Texture.fromBitmap(new GraphicConstants.BLUE_ELEM_S);
		public static const GREEN_ELEM_S_T:Texture = Texture.fromBitmap(new GraphicConstants.GREEN_ELEM_S);
		public static const PURPLE_ELEM_S_T:Texture = Texture.fromBitmap(new GraphicConstants.PURPLE_ELEM_S);
		public static const RED_ELEM_S_T:Texture = Texture.fromBitmap(new GraphicConstants.RED_ELEM_S);
		public static const YELLOW_ELEM_S_T:Texture = Texture.fromBitmap(new GraphicConstants.YELLOW_ELEM_S);
	}

}