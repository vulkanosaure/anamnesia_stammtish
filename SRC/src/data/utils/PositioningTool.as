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
package data.utils 
{
	import data2.asxml.ObjectSearch;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
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
	import flash.geom.Point;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Vincent
	 */
	public class PositioningTool extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static var dobj:DisplayObject;
		private static var dobjOrigin:DisplayObject;
		private static var stage:Stage;
		private static var isMouseDown:Boolean;
		private static var mouseOffset:Point;
		private static var mouseDownCoords:Point;
		private static var spriteHighlight:Sprite;
		private static var indexDepth:int;
		private static var changedTarget:Boolean;
		
		public function PositioningTool(_dobj:DisplayObject) 
		{
			throw new Error("is static");
			
		}
		
		static public function init(_stage:Stage):void
		{
			stage = _stage;
			isMouseDown = false;
			changedTarget = false;
			indexDepth = 0;
			spriteHighlight = new Sprite();
			stage.addChild(spriteHighlight);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
			browse(stage);
			
		}
		
		
		static private function browse(_dobjcont:DisplayObjectContainer):void
		{
			for (var i:int = 0; i < _dobjcont.numChildren; i++) {
				var _child:DisplayObject = _dobjcont.getChildAt(i);
				if (_child is DisplayObjectContainer) browse(DisplayObjectContainer(_child));
				
				_child.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_child.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
			}
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		static private function givePosition():void
		{
			var _strinterface:String = "";
			
			if (dobj.x != 0) _strinterface += " marginLeft='" + dobj.x + "px'";
			if (dobj.y != 0) _strinterface += " marginTop='" + dobj.y + "px'";
			if (_strinterface.charAt(0) == " ") _strinterface = _strinterface.substr(1);
			
			trace(ObjectSearch.formatObject(dobj) + " position : [" + dobj.x + ", " + dobj.y + "]");
			trace(_strinterface);
			
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _strinterface);
		}
		
		static private function highlight(_dobj:DisplayObject):void
		{
			var g:Graphics = spriteHighlight.graphics;
			g.clear();
			g.lineStyle(1, 0xDD0000, 1.0);
			
			//convert offset to global
			var _pos:Point = _dobj.parent.localToGlobal(new Point(_dobj.x, _dobj.y));
			g.drawRect(_pos.x, _pos.y, _dobj.width, _dobj.height);
		}
		
		
		static private function select(_dobj:DisplayObject):void
		{
			dobj = DisplayObject(_dobj);
			highlight(dobj);
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		static private function onMouseDown(e:MouseEvent):void 
		{
			mouseDownCoords = new Point(stage.mouseX, stage.mouseY);
			
			var _target:DisplayObject = DisplayObject(e.target);
			
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
				
				var _target:DisplayObject = DisplayObject(e.target);
				for (var i:int = 0; i < indexDepth; i++) {
					if (_target.parent != null && _target.parent!=stage) _target = _target.parent;
				}
				
				
				select(DisplayObject(_target));
			}
			
			isMouseDown = false;
			changedTarget = false;
			givePosition();
			e.stopImmediatePropagation();
		}
		
		
		
		
		static private function onKeydown(e:KeyboardEvent):void 
		{
			//trace("onKeydown " + e.keyCode);
			var delta:Point = new Point();
			
			if (e.keyCode == Keyboard.LEFT) delta.x = -1;
			else if (e.keyCode == Keyboard.RIGHT) delta.x = 1;
			else if (e.keyCode == Keyboard.UP) delta.y = -1;
			else if (e.keyCode == Keyboard.DOWN) delta.y = 1;
			else return;
			
			dobj.x += delta.x;
			dobj.y += delta.y;
			givePosition();
		}
		
		
		static private function onEnterframe(e:Event):void 
		{
			if (isMouseDown) {
				dobj.x = stage.mouseX - mouseOffset.x;
				dobj.y = stage.mouseY - mouseOffset.y;
			}
			
		}
		
		
		
	}

}