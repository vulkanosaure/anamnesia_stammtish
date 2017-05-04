package data.display {
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	
	public class FilledRectangle extends MovieClip{
		
		//params
		private var _color:uint;
		
		//private vars
		
		//_______________________________________________________________
		//public functions
		
		public function FilledRectangle(__color:int=0x000000) 
		{ 
			_color = __color;
			update();
		}
		
		
		public function set color(value:uint):void 
		{
			_color = value;
			update();
		}
		
		//_______________________________________________________________
		//private functions
		
		private function update():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(_color);
			g.drawRect(0, 0, 100, 100);
		}
		
		
		
		//_______________________________________________________________
		//events handlers=
	}
	
}