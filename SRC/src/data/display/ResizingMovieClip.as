package data.display {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ResizingMovieClip extends MovieClip {
		
		//params
		
		
		//private vars
		var resolMin, resolMax:int;
		var scaleMin, scaleMax:Number;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function ResizingMovieClip() 
		{ 
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setMin(_resol:int, _scale:Number)
		{
			resolMin = _resol;
			scaleMin = _scale;
		}
		public function setMax(_resol:int, _scale:Number)
		{
			resolMax = _resol;
			scaleMax = _scale;
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onAddedToStage(e:Event)
		{
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(new Event(""));
		}
		
		private function onResize(e:Event)
		{
			var current_resol:int = stage.stageWidth * stage.stageHeight;
			var percent:Number = (current_resol - resolMin) / (resolMax - resolMin);
			var scale:Number = (scaleMax - scaleMin) * percent + scaleMin;
			if(scale<scaleMin) scale = scaleMin;
			if(scale>scaleMax) scale = scaleMax;
			
			this.scaleX = scale;
			this.scaleY = scale;
		}
		
	}
	
}