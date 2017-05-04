package data2.display.parallax 
{
	import data2.InterfaceSprite;
	/**
	 * ...
	 * @author 
	 */
	public class ParallaxChild extends InterfaceSprite
	{
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _zindex:int = 0;
		
		public function ParallaxChild() 
		{
			
		}
		
		public function get offsetx():Number {return _offsetx;}
		
		public function set offsetx(value:Number):void
		{
			_offsetx = value;
			this.x = _offsetx;
		}
		
		public function get offsety():Number {return _offsety;}
		
		public function set offsety(value:Number):void 
		{
			_offsety = value;
			this.y = _offsety;
		}
		
		public function get zindex():int {return _zindex;}
		
		public function set zindex(value:int):void {_zindex = value;}
		
		
		
		
		
		
		
	}

}