package data.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ResizeableBitmap extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var _bmp:Bitmap;
		
		private var _top:Number;
		private var _left:Number;
		private var _bottom:Number;
		private var _right:Number;
		
		private var _bmp_tl:Bitmap;
		private var _bmp_t:Bitmap;
		private var _bmp_tr:Bitmap;
		private var _bmp_l:Bitmap;
		private var _bmp_m:Bitmap;
		private var _bmp_r:Bitmap;
		private var _bmp_bl:Bitmap;
		private var _bmp_b:Bitmap;
		private var _bmp_br:Bitmap;
		
		
		
		public function ResizeableBitmap(__bmpdClass:Class, __left:Number, __top:Number, __right:Number, __bottom:Number) 
		{
			_bmp = new Bitmap(new __bmpdClass(0, 0));
			
			_left = __left;
			_top = __top;
			_right = __right;
			_bottom = __bottom;
			
			if (isNaN(_left)) _left = 0;
			if (isNaN(_top)) _top = 0;
			if (isNaN(_right)) _right = _bmp.width;
			if (isNaN(_bottom)) _bottom = _bmp.height;
			
			init();
			
		}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		public function resize(_width:Number, _height:Number):void
		{
			//trace("ResizeableBitmap.resize(" + _width + ", " + _height + ")");
			if (isNaN(_width)) _width = _bmp.width;
			if (isNaN(_height)) _height = _bmp.height;
			
			var _dim_l:Number = (_bmp_l != null) ? _bmp_l.width : 0;
			var _dim_t:Number = (_bmp_t != null) ? _bmp_t.height : 0;
			var _dim_r:Number = (_bmp_r != null) ? _bmp_r.width : 0;
			var _dim_b:Number = (_bmp_b != null) ? _bmp_b.height : 0;
			
			
			//trace("before _widthcenter : " + (_width - _dim_r - _dim_l) + ", _heightcenter : " + (_height - _dim_t - _dim_b));
			
			var _widthcenter:Number = Math.round(_width - _dim_r - _dim_l);
			var _heightcenter:Number = Math.round(_height - _dim_t - _dim_b);
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
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private function init():void
		{
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
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}


/*

UTILISATION :

var _bg:ResizeableBitmap = new ResizeableBitmap(ClassIMG, 45, NaN, 136, NaN);
addChild(_bg);
_bg.resize(150, 45);

//on peut spécifier NaN à la place des valeurs numériques (constructeur et resize)



TODO :

gestion dimension minimum									OK
doit pouvoir ne pas préciser un / +sieurs param				OK
simplifier le passage du bitmap (si possible)				OK
tout se passe ds le constructer (set et init)				OK

*/