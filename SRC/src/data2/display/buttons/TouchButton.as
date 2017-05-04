package data2.display.buttons 
{
	import data2.asxml.ObjectSearch;
	import data2.InterfaceSprite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class TouchButton extends InterfaceSprite
	{
		private var _template:String;
		private var _objtpl:MovieClip;
		private var _enabled:Boolean;
		
		public function TouchButton() 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			_enabled = true;
			
		}
		
		
		
		
		public function disableButton():void
		{
			trace("disableButton on " + ObjectSearch.formatObject(this));
			_enabled = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_objtpl.gotoAndStop(3);
		}
		public function enableButton():void
		{
			trace("enableButton on " + ObjectSearch.formatObject(this));
			_enabled = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			_objtpl.gotoAndStop(1);
		}
		
		public function gotoAndStop(_number:Number):void 
		{
			_objtpl.gotoAndStop(_number);
		}
		
		
		
		private function onMouseDown(e:MouseEvent):void 
		{
			trace("TouchButton.onMouseDown");
			
			_objtpl.gotoAndStop(2);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			trace("TouchButton.onMouseUp");
			if (_enabled) _objtpl.gotoAndStop(1);
			
		}
		
		
		
		
		
		override public function set template(value:String):void 
		{
			_template = value;
			
			var _class:Class = getDefinitionByName(_template) as Class;
			_objtpl = MovieClip(new _class());
			_objtpl.gotoAndStop(1);
			this.addChild(_objtpl);
		}
		
	}

}