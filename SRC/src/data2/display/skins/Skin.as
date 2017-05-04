/*
TODO :
	
	mode with simple DisplayObject (no specific resize) servira juste pour que LayoutEngine le fasse marcher comme un Skin
	ASXML call Skin.init() after set properties
	LayoutEngine get target object and check paddings properties to set it's position / dimensions
	see if target object must be on the same level or if it can be usefull to have it somewhere else (later)

*/

package data2.display.skins 
{
	import data2.layoutengine.LayoutSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	
	public class Skin extends LayoutSprite
	{
		//_______________________________________________________________________________
		// properties
		
		
		private static const TYPE_BITMAP:String = "typeBitmap";
		private static const TYPE_SPRITE:String = "typeSprite";
		
		
		private var _template:String;
		private var _top:Number;
		private var _left:Number;
		private var _bottom:Number;
		private var _right:Number;
		
		private var _width:Number;
		private var _height:Number;
		
		
		private var _bmp:Bitmap;
		private var _dobj:DisplayObject;
		
		private var _bmp_tl:Bitmap;
		private var _bmp_t:Bitmap;
		private var _bmp_tr:Bitmap;
		private var _bmp_l:Bitmap;
		private var _bmp_m:Bitmap;
		private var _bmp_r:Bitmap;
		private var _bmp_bl:Bitmap;
		private var _bmp_b:Bitmap;
		private var _bmp_br:Bitmap;
		
		private var _type:String;
		
		
		
		
		public function Skin() 
		{
			
		}
		
		public function set template(value:String):void
		{
			_template = value;
		}
		
		
		
		public function set top(value:Number):void {_top = value;}
		
		public function set left(value:Number):void {_left = value;}
		
		public function set bottom(value:Number):void {_bottom = value;}
		
		public function set right(value:Number):void {_right = value;}
		
		
		
		
		
		
		
		
		
		
		
		public function init():void
		{
			if (_template == null) throw new Error("you must set Skin.template property");
			
			//get _bmp from class string
			var _templateClass:Class = Class(getDefinitionByName(_template));
			
			var _occurence:Object;
			try {
				_occurence = new _templateClass(0, 0);
			}
			catch (e:Error) {
				_occurence = new _templateClass();
			}
			
			
			if (_occurence is BitmapData) {
				
				_type = TYPE_BITMAP;
				
				_bmp = new Bitmap(BitmapData(_occurence));
				//trace("Skin _bmp : " + _bmp);
				_width = _bmp.width;
				_height = _bmp.height;
				
				
				if (isNaN(_left)) _left = 0;
				if (isNaN(_top)) _top = 0;
				if (isNaN(_right)) _right = 0;
				if (isNaN(_bottom)) _bottom = 0;
				
				_right = _width - _right;
				_bottom = _height - _bottom;
				
				
				//découpe les 9 pièces
				_bmp_tl = createBmp(0, 0, _left, _top);
				_bmp_t = createBmp(_left, 0, _right, _top);
				_bmp_tr = createBmp(_right, 0, _bmp.width, _top);
				_bmp_l = createBmp(0, _top, _left, _bottom);
				_bmp_m = createBmp(_left, _top, _right, _bottom);
				_bmp_r = createBmp(_right, _top, _bmp.width, _bottom);
				_bmp_bl = createBmp(0, _bottom, _left, _bmp.height);
				_bmp_b = createBmp(_left, _bottom, _right, _bmp.height);
				_bmp_br = createBmp(_right, _bottom, _bmp.width, _bmp.height);
				
				safeAddChild(_bmp_tl);
				safeAddChild(_bmp_t);
				safeAddChild(_bmp_tr);
				safeAddChild(_bmp_l);
				safeAddChild(_bmp_m);
				safeAddChild(_bmp_r);
				safeAddChild(_bmp_bl);
				safeAddChild(_bmp_b);
				safeAddChild(_bmp_br);
			}
			
			else if(_occurence is DisplayObject){
				
				_type = TYPE_SPRITE;
				_dobj = DisplayObject(_occurence);
				this.addChild(_dobj);
				
				
			}
			else throw new Error("wrong type for template (Bitmap or DisplayObject)");
			
		}
		
		
		
		
		override public function set width(value:Number):void 
		{
			_width = value;
			
			if (_type == TYPE_BITMAP) {
				resize(value, NaN);
			}
			else if (_type == TYPE_SPRITE) {
				_dobj.width = value;
			}
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
			
			if (_type == TYPE_BITMAP) {
				resize(NaN, value);
			}
			else if (_type == TYPE_SPRITE) {
				_dobj.height = value;
			}
		}
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		public function resize(_w:Number, _h:Number):void
		{
			//trace("ResizeableBitmap.resize(" + _w + ", " + _h + ")");
			if (isNaN(_w)) _w = _width;
			if (isNaN(_h)) _h = _height;
			
			var _dim_l:Number = (_bmp_l != null) ? _bmp_l.width : 0;
			var _dim_t:Number = (_bmp_t != null) ? _bmp_t.height : 0;
			var _dim_r:Number = (_bmp_r != null) ? _bmp_r.width : 0;
			var _dim_b:Number = (_bmp_b != null) ? _bmp_b.height : 0;
			
			
			//trace("before _widthcenter : " + (_w - _dim_r - _dim_l) + ", _heightcenter : " + (_h - _dim_t - _dim_b));
			
			var _widthcenter:Number = Math.round(_w - _dim_r - _dim_l);
			var _heightcenter:Number = Math.round(_h - _dim_t - _dim_b);
			if (_widthcenter < 0) _widthcenter = 0;
			if (_heightcenter < 0) _heightcenter = 0;
			
			//trace("after _widthcenter : " + _widthcenter + ", _heightcenter : " + _heightcenter);
			
			
			//redimensionne les pièces
			if (_bmp_l != null) _bmp_l.height = _heightcenter;
			if (_bmp_t != null) _bmp_t.width = _widthcenter;
			if (_bmp_r != null) _bmp_r.height = _heightcenter;
			if (_bmp_b != null) _bmp_b.width = _widthcenter;
			if (_bmp_m != null) _bmp_m.width = _widthcenter;
			if (_bmp_m != null) _bmp_m.height = _heightcenter;
			
			
			
			var _x0:Number, _x1:Number, _x2:Number, _y0:Number, _y1:Number, _y2:Number;
			_x0 = 0;
			_x1 = _left;
			_x2 = _left + _widthcenter;
			_y0 = 0;
			_y1 = _top;
			_y2 = _top + _heightcenter;
			
			//trace("_x0 : " + _x0 + ", _x1 : " + _x1 + ", _x2 : " + _x2 + ", _y0 : " + _y0 + ", _y1 : " + _y1 + ", _y2 : " + _y2);
			
			
			//repositionne les pièces
			setPosBMP(_bmp_tl, _x0, _y0);
			setPosBMP(_bmp_t, _x1, _y0);
			setPosBMP(_bmp_tr, _x2, _y0);
			setPosBMP(_bmp_l, _x0, _y1);
			setPosBMP(_bmp_m, _x1, _y1);
			setPosBMP(_bmp_r, _x2, _y1);
			setPosBMP(_bmp_bl, _x0, _y2);
			setPosBMP(_bmp_b, _x1, _y2);
			setPosBMP(_bmp_br, _x2, _y2);
			
		}
		
		
		private function setPosBMP(_bmp:Bitmap, _x:Number, _y:Number):void
		{
			if (_bmp == null) return;
			_bmp.x = _x;
			_bmp.y = _y;
		}
		
		
		private function createBmp(_x1:Number, _y1:Number, _x2:Number, _y2:Number):Bitmap
		{
			//trace("createBmp(" + _x1 + ", " + _y1 + ", " + _x2 + ", " + _y2 + ")");
			
			//si le bmp n'a pas de largeur ou de hauteur
			if (_x1 == _x2 || _y1 == _y2) return null;
			
			var _bmpddest:BitmapData = new BitmapData(_x2 - _x1, _y2 - _y1);
			var _bmpdsrc:BitmapData = _bmp.bitmapData;
			
			
			var _ydest:int = 0;
			
			for (var _ysrc:int = _y1; _ysrc < _y2; _ysrc++) {
				
				var _xdest:int = 0;
				for (var _xsrc:int = _x1; _xsrc < _x2; _xsrc++) {
					
					var _col:uint = _bmpdsrc.getPixel32(_xsrc, _ysrc);
					_bmpddest.setPixel32(_xdest, _ydest, _col);
					
					_xdest++;
				}
				_ydest++;
			}
			
			var _bmpdst:Bitmap = new Bitmap(_bmpddest);
			return _bmpdst;
			
		}
		
		
		private function safeAddChild(_child:DisplayObject):void
		{
			if (_child != null) this.addChild(_child);
		}
		
		
		
		
	}

}