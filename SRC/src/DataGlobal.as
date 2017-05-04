package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Vinc
	 */
	public class DataGlobal 
	{
		
		public function DataGlobal() 
		{
			
		}
		
		public static var LIST_LANG:Array = ["fr", "en", "de"];
		
		static public const DEBUG_PERFS:Boolean = false;
		static public const DEBUG_MODE:Boolean = false;
		static public const DEBUG_NAVIGATION:Boolean = false;
		static public const DEBUG_CLICKABLE:Boolean = false;
		
		
		static public const ENABLE_VIDEO:Boolean = false;
		static public var container:DisplayObjectContainer;
		
		static public const LIST_ICON_WEATHER:Array = ["01", "02", "03", "04", "09", "10", "11", "13", "50"];
		static public var id:String;
		static public var save_colors:Array;
		static public const NB_PAGE_EMBASSADEUR:int = 4;
		static public const NB_PAGE_TERRITOIRE:int = 3;
		
		
	}

}