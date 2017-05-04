package data.xtends {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	public class MovieClip2 extends MovieClip {
		
		var _alwaysontop:Boolean = false;
		
		public function MovieClip2()
		{
			super();
		}
		
		public function drag()
		{
			this.addEventListener(Event.ENTER_FRAME, onDrag);
		}
		
		public function drop()
		{
			this.removeEventListener(Event.ENTER_FRAME, onDrag);
		}
		
		
		
		
		
		
		
		
		
		//________________________________________________________________________________
		//events handler
		
		
		private function onDrag(e:Event)
		{
			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		
	}
}