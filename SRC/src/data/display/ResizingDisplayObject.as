package data.display {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class ResizingDisplayObject extends MovieClip {
		
		//params
		
		
		//private vars
		var _ratioX, _offsetX:Number;
		var _ratioY, _offsetY:Number;
		var defineX, defineY:Boolean;
		var st:Stage;
		
		//_______________________________________________________________
		//public functions
		
		public function ResizingDisplayObject(_stage:Stage) 
		{ 
			st = _stage;
			defineX = false;
			defineY = false;
			st.addEventListener(Event.RESIZE, onResize);
			onResize(new Event(""));
		}
		
		public function setWidth(_ratio:Number, _offset:Number=0):void
		{
			defineX = true;
			_ratioX = _ratio;
			_offsetX = _offset;
		}
		
		public function setHeight(_ratio:Number, _offset:Number=0):void
		{
			defineY = true;
			_ratioY = _ratio;
			_offsetY = _offset;
		}
		
		public function update():void
		{
			onResize(new Event(""));
			
		}
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		
		
		private function onResize(e:Event)
		{
			
			var stageWidth:Number = st.stageWidth
			var stageHeight:Number = st.stageHeight;
			trace("Resizing :: onResize "+stageWidth+", "+stageHeight);
			
			var _width:Number = _ratioX * stageWidth + _offsetX;
			var _height:Number = _ratioY * stageHeight + _offsetY;
			
			if(defineX) this.width = _width;
			if(defineY) this.height = _height;
		}
		
	}
	
}