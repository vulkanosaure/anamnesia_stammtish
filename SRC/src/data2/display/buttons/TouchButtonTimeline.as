package data2.display.buttons 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class TouchButtonTimeline extends Sprite
	{
		private var _objtpl:MovieClip;
		private var _enabled:Boolean;
		
		public function TouchButtonTimeline(_mc:MovieClip) 
		{
			_objtpl = _mc;
			_objtpl.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_objtpl.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_objtpl.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			_enabled = true;
			_objtpl.gotoAndStop(1);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			//trace("TouchButton.onMouseDown");
			_objtpl.gotoAndStop(2);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			//trace("TouchButton.onMouseUp");
			if (_enabled) _objtpl.gotoAndStop(1);
			
		}
	}

}