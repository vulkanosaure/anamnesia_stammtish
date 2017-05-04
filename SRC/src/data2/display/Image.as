/*
   load avant ou apres définition des params
 */

package data2.display
{
	import data2.layoutengine.LayoutSprite;
	import data2.net.imageloader.ImageLoader;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class Image extends LayoutSprite
	{
		//_______________________________________________________________________________
		// properties
		public static const HOMOTETHY_HEIGHT:String = "homotethyHeight";
		public static const HOMOTETHY_WIDTH:String = "homotethyWidth";
		public static const CROP_FIT:String = "cropFit";
		public static const CROP_BORDER:String = "cropBorder";
		public static const NONE:String = "none";
		
		//params
		private var _resizeType:String = NONE;
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var _bgcolor:int = -1;
		private var _animloading:String = "";
		
		private var _animloadingInstance:DisplayObject;
		private var _bg:Sprite;
		private var _loader:Loader;
		private var _mask:Sprite;
		
		private var _loaded:Boolean = false;
		private var _group:String;
		private var _src:String;
		
		
		
		
		public function Image()
		{
			_group = ImageLoader.GROUP_INIT;
			_loader = new Loader();
			this.addChild(_loader);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
		}
		
		public function set src(_url:String):void
		{
			_loaded = false;
			_src = _url;
			
			//_loader.load(new URLRequest(_url));
			
		}
		
		//_______________________________________________________________________________
		// public functions
		
		public function set animloading(_classname:String):void
		{
			_animloading = _classname;
			
			if (_animloading != "")
			{
				var _class:Class = getDefinitionByName(_animloading) as Class;
				//trace("_class : " + _class);
				_animloadingInstance = new _class() as DisplayObject;
				if (!(_animloadingInstance is DisplayObject))
					throw new Error("class " + _animloading + " must be a DisplayObject");
				this.addChild(_animloadingInstance);
			}
		}
		
		public function set bgcolor(value:int):void
		{
			_bgcolor = value;
			if (value != -1)
			{
				_bg = new Sprite();
				this.addChildAt(_bg, 0);
			}
		}
		
		public function set resizeType(value:String):void
		{
			if (value != HOMOTETHY_HEIGHT && value != HOMOTETHY_WIDTH && value != CROP_BORDER && value != CROP_FIT && value != NONE)
				throw new Error("wrong value for param _resizetype");
			_resizeType = value;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			this.layoutWidth = _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			this.layoutHeight = _height;
		}
		
		override public function get width():Number
		{
			if (_resizeType == CROP_FIT)
				return _width;
			else
				return super.width;
		}
		
		override public function get height():Number
		{
			if (_resizeType == CROP_FIT)
				return _height;
			else
				return super.height;
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		public function get group():String {return _group;}
		
		public function set group(value:String):void { _group = value; }
		
		public function get bitmap():Bitmap
		{
			return Bitmap(_loader.content);
		}
		
		
		
		
		public function init(_loadingqueue:Boolean = true):void
		{
			//bg
			if (_bgcolor != -1)
			{
				drawRect(_bg, _bgcolor, _width, _height);
			}
			
			//animloading
			if (_animloadingInstance != null)
			{
				_animloadingInstance.x = _width / 2;
				_animloadingInstance.y = _height / 2;
				_animloadingInstance.visible = !_loaded;
			}
			
			if (_src == null) throw new Error("param \"url\" must be set");
			if(_loadingqueue) ImageLoader.add(_loader, _src, _group);
			else _loader.load(new URLRequest(_src));
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		private function drawRect(_sp:Sprite, _col:int, _width:Number, _height:Number):void
		{
			var g:Graphics = _sp.graphics;
			g.clear();
			g.beginFill(_col);
			g.drawRect(0, 0, _width, _height);
		}
		
		//_______________________________________________________________________________
		// events
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace("Loader2.onIOError " + e.text);
		}
		
		private function onLoaded(e:Event):void
		{
			//trace("Loader2.onLoaded");
			_loaded = true;
			
			var _dobj:DisplayObject = LoaderInfo(e.target).loader.content;
			if (_dobj is Bitmap)
				Bitmap(_dobj).smoothing = true;
			
			if (_animloadingInstance != null)
			{
				_animloadingInstance.visible = false;
			}
			
			var _ptdims:Point = new Point(_width, _height);
			var _dimssrc:Point = new Point(_dobj.width, _dobj.height);
			var _dimdst:Point = new Point();
			
			if (_resizeType == HOMOTETHY_WIDTH)
			{
				_dimdst.x = _width;
				_dimdst.y = _dimssrc.y * _width / _dimssrc.x;
			}
			else if (_resizeType == HOMOTETHY_HEIGHT)
			{
				_dimdst.y = _height;
				_dimdst.x = _dimssrc.x * _height / _dimssrc.y;
			}
			else if (_resizeType == CROP_BORDER)
			{
				_dimdst = ResizeCalculation.getResize(ResizeCalculation.BORDER, _dimssrc, _ptdims);
				_dobj.x = _ptdims.x / 2 - _dimdst.x / 2;
				_dobj.y = _ptdims.y / 2 - _dimdst.y / 2;
			}
			else if (_resizeType == CROP_FIT)
			{
				_dimdst = ResizeCalculation.getResize(ResizeCalculation.FIT, _dimssrc, _ptdims);
				_dobj.x = _ptdims.x / 2 - _dimdst.x / 2;
				_dobj.y = _ptdims.y / 2 - _dimdst.y / 2;
			}
			else
			{
				_dimdst.x = _dobj.width;
				_dimdst.y = _dobj.height;
			}
			
			_dobj.width = _dimdst.x;
			_dobj.height = _dimdst.y;
			
			//build mask
			if (_resizeType == CROP_FIT)
			{
				
				_mask = new Sprite();
				this.addChild(_mask);
				drawRect(_mask, 0x00ff00, _width, _height);
				_dobj.mask = _mask;
				
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.dispatchEvent(new Event(Event.RESIZE));
		}
	
	}

}
import flash.geom.Point;

class ResizeCalculation
{
	//_______________________________________________________________________________
	// properties
	
	public static const FIT:String = "resizeCalculationFit";
	public static const BORDER:String = "resizeCalculationBorder";
	
	public function ResizeCalculation()
	{
		throw new Error("is static, can't instanciate");
	}
	
	//_______________________________________________________________________________
	// public functions
	
	public static function getResize(_mode:String, _dimSRC:Point, _dimDST:Point):Point
	{
		if (_mode != FIT && _mode != BORDER)
			throw new Error("wrong value for argument _mode (" + FIT + ", " + BORDER + ")");
		
		var _border:Boolean = (_mode == BORDER);
		var _ratioSRC:Number = _dimSRC.x / _dimSRC.y;
		var _ratioDST:Number = _dimDST.x / _dimDST.y;
		
		var w:Number = 0;
		var h:Number = 0;
		
		if (_ratioSRC > _ratioDST && _border)
			w = _dimDST.x;
		else if (_ratioSRC > _ratioDST && !_border)
			h = _dimDST.y;
		else if (_border)
			h = _dimDST.y;
		else
			w = _dimDST.x;
		
		if (h == 0)
			h = w * _dimSRC.y / _dimSRC.x;
		else
			w = h * _dimSRC.x / _dimSRC.y;
		
		return new Point(w, h);
	}

	//_______________________________________________________________________________
	// private functions

	//_______________________________________________________________________________
	// events

}