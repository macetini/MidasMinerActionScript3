package com.king.meta.constants 
{
	/**
	 * ...
	 * @author mc
	 */
	public final class GraphicConstants 
	{
		public function GraphicConstants():void
		{
			throw(new Error("GraphicConstants class is static class and can not be instantiated."));
		}
		
		//Background Image
		[Embed(source = "../../../../../assets/background/BackGround.jpg")]
		public static const BACKGROUND_IMAGE:Class;
		
		//HUD
		
		//Button
		
		[Embed(source="../../../../../assets/images/hud/button-up-skin.png")]
		public static const HUD_BUTTON_UP:Class;
		
		[Embed(source="../../../../../assets/images/hud/button-down-skin.png")]
		public static const HUD_BUTTON_DOWN:Class;
		
		//Grid elements
		
		//Selected
		
		[Embed(source = "../../../../../assets/grid/elements/notselected/Blue.png")]
		public static const BLUE_ELEM_N:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/notselected/Green.png")]
		public static const GREEN_ELEM_N:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/notselected/Purple.png")]
		public static const PURPLE_ELEM_N:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/notselected/Red.png")]
		public static const RED_ELEM_N:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/notselected/Yellow.png")]
		public static const YELLOW_ELEM_N:Class;
		
		//Un selected
		
		[Embed(source = "../../../../../assets/grid/elements/selected/BlueSelected.png")]
		public static const BLUE_ELEM_S:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/selected/GreenSelected.png")]
		public static const GREEN_ELEM_S:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/selected/PurpleSelected.png")]
		public static const PURPLE_ELEM_S:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/selected/RedSelected.png")]
		public static const RED_ELEM_S:Class;
		
		[Embed(source = "../../../../../assets/grid/elements/selected/YellowSelected.png")]
		public static const YELLOW_ELEM_S:Class;
		
		//HUD
		
		[Embed(source = "../../../../../assets/images/panel.png")]
		public static const HUD_PANEL:Class;
		
		//Frames
		
		//Flame
		[Embed(source="../../../../../assets/images/framemap/flame_frames.xml", mimeType="application/octet-stream")]
		public static const FLAME_ATLAS_XML:Class;
		
		[Embed(source = "../../../../../assets/images/framemap/flame_frames.png")]
		public static const FLAME_FRAMES:Class;
		
		//Particels
		
		//Circle
		
		[Embed(source = "../../../../../assets/particles/particle.pex", mimeType = "application/octet-stream")]
		public static const PARTICLE_CIRCLE_XML:Class;
		
		[Embed(source = "../../../../../assets/particles/texture.png")]
		public static const PARTICLE_CIRCLE_TEXTURE:Class;
	}

}