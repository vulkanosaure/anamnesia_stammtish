package utils.virtualkeyboard {
	
	import flash.ui.Keyboard;
	import utils.virtualkeyboard.geom.XPoint;
	import utils.virtualkeyboard.geom.XRect;
	
	public class AzertyKeyboardType implements IKeyboardType {
		
		private const WIDTH_BASE:Number = 75;
		private const WIDTH_MEDIUM:Number = 119;
		private const WIDTH_MEDIUM2:Number = 172;
		private const WIDTH_SPACE:Number = 270;
		private const HEIGHT_SMALL:Number = 74;
		
		private var _cell:XPoint;
		private var _paddingw:Number;
		private var _paddingh:Number;
		private var _keyClass:Class;
		
		/**
		 *	Constructor
		 * @param	cell
		 * @param	padding
		 */
		public function AzertyKeyboardType(cell:XPoint, paddingw:Number, paddingh:Number, keyClass:Class){
			_cell = cell;
			_paddingw = paddingw;
			_paddingh = paddingh;
			_keyClass = keyClass;
		}
		
		protected function inGrid(x:Number, y:Number, w:Number = 1, h:Number = 1):XRect{
			return new XRect(
				x * (_cell.x + _paddingw),
				y * (_cell.y + _paddingh),
				w * _cell.x + (w - 1) * _paddingw,
				h * _cell.y + (h - 1) * _paddingh
				);
		}
		
		protected function inGridOther(x:Number, y:Number, w:Number = 1, h:Number = 1):XRect{
			return new XRect(
				x * (_cell.x + _paddingw),
				y * (_cell.y + _paddingh),
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
		public function keysDeclaration(_type:String):Vector.<IKeyView>{
			var keys:Vector.<IKeyView>;
			var key:IKeyView;
			
			keys = new Vector.<IKeyView>();
				
			//	---------------------------- LETTERS FIRST LINE

			//	---------------------------- LETTERS FIRST LINE

			key = new _keyClass;
			key.reset(Keyboard.A, true, false, true);
			inGrid(0, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.Z, true, false, true);
			inGrid(1, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.E, true, false, true);
			inGrid(2, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.R, true, false, true);
			inGrid(3, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.T, true, false, true);
			inGrid(4, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.Y, true, false, true);
			inGrid(5, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.U, true, false, true);
			inGrid(6, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.I, true, false, true);
			inGrid(7, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.O, true, false, true);
			inGrid(8, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.P, true, false, true);
			inGrid(9, 0).apply(key);
			keys.push(key);
			
			/*
			
			*/
			
			
			
			//	---------------------------- LETTERS SECOND LINE
			
			key = new _keyClass;
			key.reset(Keyboard.Q, true, false, true);
			inGrid(0, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.S, true, false, true);
			inGrid(1, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.D, true, false, true);
			inGrid(2, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.F, true, false, true);
			inGrid(3, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.G, true, false, true);
			inGrid(4, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.H, true, false, true);
			inGrid(5, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.J, true, false, true);
			inGrid(6, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.K, true, false, true);
			inGrid(7, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.L, true, false, true);
			inGrid(8, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.M, true, false, true);
			inGrid(9, 1).apply(key);
			keys.push(key);
			
			/*
			
			*/
			
			//	---------------------------- LETTERS THIRD LINE
			
			key = new _keyClass;
			key.reset(Keyboard.W, true, false, true);
			inGrid(1, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.X, true, false, true);
			inGrid(2, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.C, true, false, true);
			inGrid(3, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.V, true, false, true);
			inGrid(4, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.B, true, false, true);
			inGrid(5, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.N, true, false, true);
			inGrid(6, 2).apply(key);
			keys.push(key);
			
			//___________________________
			/*
			key = new KBKeyBigImg(new kb_icon_delete());
			key.reset(Keyboard.BACKSPACE, false, true, true);
			inGridOther(6, 2, WIDTH_MEDIUM2, 103).apply(key);
			keys.push(key);
			*/
			
			if (_type == "mail") {
				key = new KBKey(new kb_icon_delete());
				key.reset(Keyboard.BACKSPACE, false, true, true);
				inGridOther(7, 2, 268, 103).apply(key);
				keys.push(key);
			}
			else if (_type == "filter") {
				key = new KBKey(new kb_icon_enter());
				key.reset(Keyboard.ENTER, false, true, true);
				inGridOther(7, 2, 268, 103).apply(key);
				keys.push(key);
			}
			
			/*
			key = new KBKey(new kb_icon_enter());
			key.reset(Keyboard.ENTER, false, true, true);
			inGridOther(8, 2, WIDTH_MEDIUM2, 103).apply(key);
			keys.push(key);
			*/
			
			
			
			
			//	---------------------------- NUMBER THIRD LINE
			var _basey:Number = 0.07;
			
			if (_type == "mail") {
				key = new _keyClass;
				KBKey(key).fontsize = 44;
				key.reset(-3, false, true, true, String(".com"));
				//inGridExat(926, -111, 130, 48).apply(key);
				inGridOther(0, 3 + _basey, WIDTH_MEDIUM, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
				key = new _keyClass;
				KBKey(key).fontsize = 44;
				key.reset(-2, false, true, true, String(".fr"));
				//inGridExat(926, -111, 130, 48).apply(key);
				inGridOther(1.5, 3 + _basey, WIDTH_MEDIUM, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
				key = new _keyClass;
				KBKey(key).fontsize = 46;
				key.reset(String('@').charCodeAt(), true, false, true);
				inGridOther(3, 3 + _basey, WIDTH_BASE, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
				key = new _keyClass(null);
				key.reset(Keyboard.SPACE, false, true, true);
				inGridOther(4, 3 + _basey, WIDTH_SPACE, HEIGHT_SMALL).apply(key);
				keys.push(key);
			}
			
			else if (_type == "filter") {
				key = new _keyClass(null);
				key.reset(Keyboard.SPACE, false, true, true);
				inGridOther(1, 3 + _basey, WIDTH_SPACE * 2 + 19, HEIGHT_SMALL).apply(key);
				keys.push(key);
			}
			
			
			
			
			
			if (_type == "mail") {
				key = new _keyClass;
				key.reset(String('.').charCodeAt(), true, false, true);
				inGridOther(7, 3 + _basey, WIDTH_BASE, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
				key = new _keyClass;
				key.reset(String('_').charCodeAt(), true, false, true);
				inGridOther(8, 3 + _basey, WIDTH_BASE, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
				key = new _keyClass;
				key.reset(String('-').charCodeAt(), true, false, true);
				inGridOther(9, 3 + _basey, WIDTH_BASE, HEIGHT_SMALL).apply(key);
				keys.push(key);
				
			}
			else if (_type == "filter") {
				key = new KBKey(new kb_icon_delete());
				key.reset(Keyboard.BACKSPACE, false, true, true);
				inGridOther(7, 3 + _basey, 268, HEIGHT_SMALL).apply(key);
				keys.push(key);
			}
			
			
			
			
			
			
			
			
			
			
			//	---------------------------- NUMBER THIRD LINE
			
			var _basex:Number = 0.5;
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_7, false, true, true);
			inGrid(10 + _basex, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_8, false, true, true);
			inGrid(11 + _basex, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_9, false, true, true);
			inGrid(12 + _basex, 0).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_4, false, true, true);
			inGrid(10 + _basex, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_5, false, true, true);
			inGrid(11 + _basex, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_6, false, true, true);
			inGrid(12 + _basex, 1).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_1, false, true, true);
			inGrid(10 + _basex, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_2, false, true, true);
			inGrid(11 + _basex, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_3, false, true, true);
			inGrid(12 + _basex, 2).apply(key);
			keys.push(key);
			
			key = new _keyClass;
			key.reset(Keyboard.NUMBER_0, false, true, true);
			inGridOther(11 + _basex, 3 + _basey, WIDTH_BASE, HEIGHT_SMALL).apply(key);
			keys.push(key);
			
			/*key = new KBKeyBig;
			key.reset(-1, false, true, true, String("Löschen").toUpperCase());
			//inGridExat(926, -111, 130, 48).apply(key);
			inGridOther(11, -1.5, 130, 48).apply(key);
			keys.push(key);*/
			
			return keys;
		}
	}
}
