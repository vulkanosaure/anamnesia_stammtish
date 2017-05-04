package utils.virtualkeyboard 
{
	import GENDARMERIE.views.KBKeyBigImg;
	import GENDARMERIE.views.KBKeyImg;
	import flash.ui.Keyboard;
	import GENDARMERIE.views.KBKeyBig;
	import virgile.app.AppLocale;
	import virgile.geom.XPoint;
	import virgile.geom.XRect;
	
	/**
	 * ...
	 * @author Ludovic INIAL
	 */
	public class NumericKeyboardType implements IKeyboardType 
	{
		[Embed(source = "suppr.png")]
		public static const suppr:Class;
		
		private var _cell:XPoint;
		private var _padding:Number;
		private var _keyClass:Class;
		
		/**
		 *	Constructor
		 * @param	cell
		 * @param	padding
		 */
		public function NumericKeyboardType(cell:XPoint, padding:Number, keyClass:Class){
			_cell = cell;
			_padding = padding;
			_keyClass = keyClass;
		}
		
		protected function inGrid(x:Number, y:Number, w:Number = 1, h:Number = 1):XRect{
			return new XRect(
				x * (_cell.x + _padding),
				y * (_cell.y + _padding),
				w * _cell.x + (w - 1) * _padding,
				h * _cell.y + (h - 1) * _padding
				);
		}
		
		protected function inGridOther(x:Number, y:Number, w:Number = 1, h:Number = 1):XRect{
			return new XRect(
				x * (_cell.x + _padding),
				y * (_cell.y + _padding),
				w,
				h
				);
		}
		
		protected function inGridExat(x:Number, y:Number, w:Number = 1, h:Number = 1):XRect{
			return new XRect(
				x,
				y,
				w,
				h
				);
		}
		
		/** @inheritDoc */
		public function keysDeclaration():Vector.<IKeyView>{
			var keys:Vector.<IKeyView>;
			var key:IKeyView;
			var locale:Function;
			
			keys = new Vector.<IKeyView>(),
			locale = AppLocale.$.locale;
			
			//	---------------------------- NUMBER THIRD LINE
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_7, false, true, true);
			inGrid(0, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_8, false, true, true);
			inGrid(1, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_9, false, true, true);
			inGrid(2, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_4, false, true, true);
			inGrid(0, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_5, false, true, true);
			inGrid(1, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_6, false, true, true);
			inGrid(2, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_1, false, true, true);
			inGrid(0, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_2, false, true, true);
			inGrid(1, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_3, false, true, true);
			inGrid(2, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_0, false, true, true);
			inGrid(0, 3).apply(key);
			keys.push(key);
			
			key = new KBKeyBigImg(new suppr());
			key.reset(Keyboard.BACKSPACE, false, true, true);
			inGridOther(1, 3, 105, 48).apply(key);
			keys.push(key);
			
			return keys;
		}
	}
}