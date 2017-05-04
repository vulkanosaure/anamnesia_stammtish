/*
 * TODO : 
 * 
 * bug on left ?
 * control-z ?
 * display coords and name on screen corner (selectable)
 * big step with key tab
 * 
 * 
 * */
package data2.debug 
{
	import data2.asxml.ObjectSearch;
	import data2.text.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DebugPannel extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		
		private static const KEYCODE:int = 80;			//P
		private static const WIDTH:Number = 280;
		private static const HEIGHT:Number = 150;
		private static const MARGINS:Number = 10;
		private static const COLOR_HIGHLIGHT:int = 0xDD0000;
		
		private static var dobj:DisplayObject;
		private static var dobjOrigin:DisplayObject;
		private static var stage:Stage;
		private static var isMouseDown:Boolean;
		private static var mouseOffset:Point;
		private static var mouseDownCoords:Point;
		private static var spriteHighlight:Sprite;
		private static var indexDepth:int;
		private static var changedTarget:Boolean;
		private static var _enabled:Boolean;
		private static var _browsed:Boolean;
		
		static private var _spriteBox:Sprite;
		static private var _textName:Text;
		static private var _tft:TextFormat;
		static private var _cross:Sprite;
		
		
		
		public function DebugPannel(_dobj:DisplayObject) 
		{
			throw new Error("is static");
			
		}
		
		static public function init(_stage:Stage):void
		{
			_enabled = false;
			_browsed = false;
			
			_tft = new TextFormat("Courier New", 12);
			
			_spriteBox = new Sprite();
			
			var _bg:Sprite = new Sprite();
			var _g:Graphics = _bg.graphics;
			_g.clear();
			_g.lineStyle(2, 0x000000, 1);
			_g.beginFill(0xced8e9, 1);
			_g.drawRect(0, 0, WIDTH, HEIGHT);
			_spriteBox.addChild(_bg);
			_bg.filters = [new DropShadowFilter(4, 45, 0x000000, 0.5, 4, 4)];
			
			
			
			_textName = new Text();
			_spriteBox.addChild(_textName);
			_textName.x = MARGINS;
			_textName.y = MARGINS;
			_textName.width = WIDTH - MARGINS * 2;
			_textName.updateText();
			//_textName.multiline = false;
			
			
			
			/*
			_text.textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeydownTF);
			_text.textField.addEventListener(Event.CHANGE, onTFChange);
			*/
			
			
			stage = _stage;
			isMouseDown = false;
			changedTarget = false;
			indexDepth = 0;
			spriteHighlight = new Sprite();
			
			_cross = new Sprite();
			var _g:Graphics = _cross.graphics;
			_g.lineStyle(2, COLOR_HIGHLIGHT, 0.5);
			_g.moveTo( -5, 0);
			_g.lineTo(5, 0);
			_g.moveTo(0, -5);
			_g.lineTo(0, 5);
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDrag);
			_bg.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag);
		}
		
		
		static private function enable():void
		{
			_enabled = true;
			stage.addChild(spriteHighlight);
			stage.addChild(_spriteBox);
			stage.addChild((_cross));
			
			if (!_browsed) browse(stage);
			_browsed = true;
		}
		
		
		static private function disable():void
		{
			_enabled = false;
			if(stage.contains(spriteHighlight)) stage.removeChild(spriteHighlight);
			if (stage.contains(_spriteBox)) stage.removeChild(_spriteBox);
			if (stage.contains(_cross)) stage.removeChild(_cross);
			_spriteBox.stopDrag();
		}
		
		
		
		static private function browse(_dobjcont:DisplayObjectContainer):void
		{
			for (var i:int = 0; i < _dobjcont.numChildren; i++) {
				var _child:DisplayObject = _dobjcont.getChildAt(i);
				if (_child is DisplayObjectContainer && _child != _spriteBox) browse(DisplayObjectContainer(_child));
				
				if(_child != _spriteBox){
					_child.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					_child.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				
			}
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		static private function highlight(_dobj:DisplayObject):void
		{
			var g:Graphics = spriteHighlight.graphics;
			g.clear();
			g.lineStyle(1, COLOR_HIGHLIGHT, 0.5);
			
			//convert offset to global
			
			var _bounds:Rectangle = _dobj.getBounds(_dobj);
			
			var _pos:Point = _dobj.parent.localToGlobal(new Point(_dobj.x, _dobj.y));
			_cross.x = _pos.x;
			_cross.y = _pos.y;
			g.drawRect(_pos.x + _bounds.left, _pos.y + _bounds.top, _bounds.width, _bounds.height);
		}
		
		
		
		
		static private function select(_dobj:DisplayObject):void
		{
			dobj = DisplayObject(_dobj);
			highlight(dobj);
			
			//trace("ObjectSearch.formatObject(_dobj) : " + ObjectSearch.formatObject(_dobj));
			
			var _content:String = ObjectSearch.formatObject(_dobj) + "\n";
			_content += "x : " + _dobj.x + "  y : " + _dobj.y + "\n";
			
			_textName.textField.text = _content;
			_textName.textField.setTextFormat(_tft);
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		static private function onMouseDown(e:MouseEvent):void 
		{
			mouseDownCoords = new Point(stage.mouseX, stage.mouseY);
			
			var _target:DisplayObject = DisplayObject(e.currentTarget);
			if (_target != dobjOrigin){
				dobjOrigin = _target;
				indexDepth = 0;
				select(DisplayObject(_target));
				changedTarget = true;
			}
			
			isMouseDown = true;
			e.stopImmediatePropagation();
			
			mouseOffset = new Point();
			mouseOffset.x = stage.mouseX - dobj.x;
			mouseOffset.y = stage.mouseY - dobj.y;
		}
		
		
		
		
		static private function onMouseUp(e:MouseEvent):void 
		{
			if (mouseDownCoords.x == stage.mouseX && mouseDownCoords.y == stage.mouseY && !changedTarget) {
				
				indexDepth++;
				
				var _target:DisplayObject = DisplayObject(e.currentTarget);
				for (var i:int = 0; i < indexDepth; i++) {
					if (_target.parent != null && _target.parent!=stage) _target = _target.parent;
				}
				
				select(DisplayObject(_target));
			}
			else select(dobj);
			
			isMouseDown = false;
			changedTarget = false;
			//givePosition();
			e.stopImmediatePropagation();
		}
		
		
		
		
		static private function onKeydown(e:KeyboardEvent):void 
		{
			//trace("onKeydown " + e.keyCode);
			if (e.keyCode == KEYCODE) {
				(_enabled) ? disable() : enable();
			}
			
			
			if (!_enabled) return;
			var delta:Point = new Point();
			
			if (e.keyCode == Keyboard.LEFT) delta.x = -1;
			else if (e.keyCode == Keyboard.RIGHT) delta.x = 1;
			else if (e.keyCode == Keyboard.UP) delta.y = -1;
			else if (e.keyCode == Keyboard.DOWN) delta.y = 1;
			else return;
			
			dobj.x += delta.x;
			dobj.y += delta.y;
			select(dobj);
		}
		
		
		static private function onEnterframe(e:Event):void 
		{
			if (!_enabled) return;
			if (isMouseDown) {
				dobj.x = stage.mouseX - mouseOffset.x;
				dobj.y = stage.mouseY - mouseOffset.y;
			}
			
		}
		
		
		
		static private function onMouseDownDrag(e:MouseEvent):void 
		{
			_spriteBox.startDrag();
		}
		
		static private function onMouseUpDrag(e:MouseEvent):void 
		{
			_spriteBox.stopDrag();
		}
		
		
	}

}