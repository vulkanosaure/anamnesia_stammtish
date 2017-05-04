package data.layout.dialog 
{
	import adobe.utils.ProductManager;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DialogDefinition
	{
		//_______________________________________________________________________________
		// properties
		
		private const DEFAULT_POSITION:Point = new Point(0.5, 0.5);
		
		
		
		private var _key:String;
		private var _dialogSprite:Sprite;
		private var _size:Point;
		private var _position:Point;
		private var _isVisible:Boolean;
		
		public function DialogDefinition(__key:String, __dialogSprite:Sprite, __size:Point, __position:Point) 
		{
			_key = __key;
			_dialogSprite = __dialogSprite;
			_size = __size;
			_position = __position;
			_isVisible = false;
		}
		
		public function get key():String { return _key; }
		
		public function get position():Point
		{ 
			if (_position == null) return new Point(DEFAULT_POSITION.x, DEFAULT_POSITION.y);
			return _position; 
		}
		
		public function get size():Point
		{
			if (_size == null) return new Point(_dialogSprite.width, _dialogSprite.height);
			else return _size;
		}
		
		public function get dialogSprite():Sprite { return _dialogSprite; }
		
		public function get isVisible():Boolean { return _isVisible; }
		
		public function set isVisible(value:Boolean):void 
		{
			_isVisible = value;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}