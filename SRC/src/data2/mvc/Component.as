package data2.mvc 
{
	import data2.InterfaceSprite;
	import data2.net.imageloader.ImageLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Component extends InterfaceSprite
	{
		private var _urlimg:String;
		
		private var _loader:Loader;
		private var _bmpd:BitmapData;
		protected var _bmp:Bitmap;
		protected var _group:String = "";
		public var debug:Boolean = false;
		
		
		public function Component() 
		{
			
		}
		
		
		
		public function initComponent():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		public function updateComponent():void
		{
			if (_loader == null) throw new Error("initComponent has not been called");
			var _img:DisplayObject = ImageLoader.getImage(_urlimg, _group);
			
			if (debug) {
				trace("updateComponent " + _img + ", " + _urlimg + ", " + _group);
			}
			_bmp.visible = false;
			
			if (_img != null) {
				
				var _bmp2:Bitmap = Bitmap(_img);
				_bmpd = _bmp2.bitmapData;
				updateImg();
			}
			else {
				ImageLoader.add(_loader, _urlimg, _group);
			}
		}
		
		
		
		public function resetComponent():void
		{
			if (_bmpd != null) _bmpd.dispose();
		}
		
		
		
		
		private function onLoaderComplete(e:Event):void 
		{
			var _loader:Loader = LoaderInfo(e.target).loader;
			/*
			if (_bmpd != null) {
				_bmpd.dispose();
			}
			*/
			
			_bmpd = (_loader.content as Bitmap).bitmapData;
			if (debug) trace("onloadercomplete " + _bmpd);
			
			
			//trace("onLoaderComplete " + _bmpd);
			updateImg();
		}
		
		protected function updateImg():void 
		{
			_bmp.bitmapData = _bmpd;
			_bmp.visible = true;
		}
		
		
		
		
		public function set urlimg(value:String):void { _urlimg = value; }
		
		public function set group(value:String):void { _group = value; }
		
		
		
	}

}