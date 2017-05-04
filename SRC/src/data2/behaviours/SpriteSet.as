package data2.behaviours 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class SpriteSet extends Sprite
	{
		
		public function SpriteSet() 
		{
			
		}
		
		public function check(_tabname:Array):void
		{
			var _len:int = _tabname.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _name:String = _tabname[i];
				var _child:DisplayObject = this.getChildByName(_name);
				if (_child == null) throw new Error("DisplayObject name " + _name);
			}
		}
		
		public function get(_name:String):DisplayObject
		{
			return this.getChildByName(_name);
		}
		
	}

}