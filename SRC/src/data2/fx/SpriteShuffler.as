package data2.fx 
{
	import data2.math.Math2;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class SpriteShuffler 
	{
		private var _items:Array;
		private var _indexes:Array;
		
		public function SpriteShuffler() 
		{
			_items = new Array();
			
		}
		
		
		
		
		public function add(_sprite:Sprite):void
		{
			var _obj:Object = new Object();
			_obj.dobj = _sprite;
			_obj.position = new Point(_sprite.x, _sprite.y);
			_items.push(_obj);
		}
		
		
		public function shuffle():void
		{
			var _len:int = _items.length;
			_indexes = new Array();
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _indrand:int = Math2.random(0, _len - 1);
				while (_indexes.indexOf(_indrand) != -1) _indrand = Math2.random(0, _len - 1);
				_indexes.push(_indrand);
			}
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _sp:Sprite = Sprite(_items[i].dobj);
				var _index:int = _indexes[i];
				var _positionmodel:Point = Point(_items[_index].position);
				_sp.x = _positionmodel.x;
				_sp.y = _positionmodel.y;
			}
		}
		
	}

}