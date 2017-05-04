package data.xtends {
	
	import flash.events.MouseEvent;
	
	public class MovieClipRollOver extends MovieClipReverse{
		
		//params
		
		
		//private vars
		
		
		//_______________________________________________________________
		//public functions
		
		public function MovieClipRollOver() 
		{ 
			super();
			this.buttonMode = true;
			
			var frame_over:Number = getFrameByName("over");
			var frame_out:Number = getFrameByName("out");
			
			this.gotoAndStop("out");
			
			if(frame_over==-1 || frame_out==-1 || frame_over<=frame_out)
				throw new Error("MovieClipRollOver must contain \"out\" label followed by \"over\" label");
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onMouseOver(e:MouseEvent):void
		{
			this.playTo("over");
		}
		private function onMouseOut(e:MouseEvent):void
		{
			this.playbackTo("out");
		}
		
		
		
	}
	
}