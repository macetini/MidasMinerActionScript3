package com.king.utils 
{
	import mx.resources.ResourceManager;
	
	/**
	 * Resource Util contains helper methods for resource bundles.
	 * 
	 * @author Marko Cetinic
	 */
	
	[ResourceBundle("resources")]
	
	public final class ResourcesUtil 
	{
		/**
		 * Resource Bundle name
		 */
		public static const BUNDLE_NAME:String = "resources";
		
		/**
		 *
		 * ResourcesUtil helper function
		 *
		 * @param resourceName resource key.
		 *
		 * @see ResourceUtil
		 *
		 * @return string from resource bundle
		 *
		 */
		
		public static function grs(resourceName:String, bundleName:String=BUNDLE_NAME):String
		{
			return ResourceManager.getInstance().getString(bundleName, resourceName);
		}
	}
}