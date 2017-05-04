package data2.net.imageloader 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	/**
	 * ...
	 * @author 
	 */
	public class ImageLoaderObject 
	{
		public var loader:Loader;
		public var src:String;
		public var group:String;
		public var loaded:Boolean;
		public var content:DisplayObject;
		
		public function ImageLoaderObject(_loader:Loader, _src:String, _group:String) 
		{
			loader = _loader;
			src = _src;
			group = _group;
			loaded = false;
		}
		
	}

}