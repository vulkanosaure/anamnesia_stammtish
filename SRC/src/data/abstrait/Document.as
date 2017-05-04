package data.abstrait 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author Vincent
	 */
	public class Document extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		
		public var flashvars:Object;
		
		
		public function Document() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		
		private function onAddedToStage(e:Event=null):void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		private function onEnterframe(e:Event):void 
		{
			if (stage.stageWidth > 0) {
				removeEventListener(Event.ENTER_FRAME, onEnterframe);
				this.init();
			}
		}
		
		protected function checkFlashvars(_arr:Array):void
		{
			flashvars = stage.loaderInfo.parameters;
			for (var i:int = 0; i < _arr.length; i++) {
				var _key:String = _arr[i];
				if (flashvars[_key] == undefined) throw new Error("Flashvars '"+_key+"' must be defined");
			}
		}
		
		protected function init():void
		{
			throw new Error("not for direct use, only override");
			
			
		}
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		protected function onLoaderProgress(e:ProgressEvent):void 
		{
			
		}
		
		protected function onLoaderComplete(e:Event):void 
		{
			
		}
		
		
	}

}