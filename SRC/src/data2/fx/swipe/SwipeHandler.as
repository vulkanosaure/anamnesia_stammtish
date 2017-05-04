package data2.fx.swipe 
{
	import data.fx.transitions.TweenManager;
	import data2.debug.InterfaceTrace;
	import data2.fx.delay.DelayManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	/**
	 * ...
	 * @author Vinc
	 */
	public class SwipeHandler 
	{
		private const THRESHOLD_SWIPE_MOVEMENT:Number = 30;
		private const THRESHOLD_SWIPE_PERCENT:Number = 0.20;
		private var _evtDispatcher:EventDispatcher;
		
		private var _containers:Array;
		private var _container:Sprite;
		private var _isDraging:Boolean = false;
		private var _delta:Point;
		private var _width:Number;
		private var _tabx:Array;
		private var _x:Number;
		private var _twm:TweenManager = new TweenManager();
		private var _enabled:Boolean = true;
		private var _swipeback:Boolean = false;
		
		
		public function SwipeHandler() 
		{
			
		}
		
		
		
		public function init(_stage:Stage, __containers:Array, __width:Number):void
		{
			_containers = __containers;
			_width = __width;
			_tabx = new Array();
			
			for (var name:String in _containers) 
			{
				var _sp:Sprite = Sprite(_containers[name]);
				addMouseListener(_sp, MouseEvent.MOUSE_DOWN, onMouseDown);
				addMouseListener(_sp, MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			addMouseListener(_stage, MouseEvent.MOUSE_UP, onMouseUp);
			
			var _spenterframe:Sprite = new Sprite();
			_spenterframe.addEventListener(Event.ENTER_FRAME, onEnterframe);
			_stage.addChild(_spenterframe);
		}
		
		
		
		private function onMouseDown(e:Event):void 
		{
			if (!_enabled) return;
			InterfaceTrace.trace2("SwipeHandler.onMouseDown");
			_isDraging = true;
			_delta = getMousePosition(e);
			trace("onMouseDown, _delta : " + _delta.x);
			_x = 0;
			
			_container = Sprite(e.currentTarget);
			
		}
		
		
		private function onMouseMove(e:Event):void 
		{
			if (!_enabled) return;
			if (!_isDraging) return;
			InterfaceTrace.trace2("SwipeHandler.onMouseMove");
			//trace("onMouseMove");
			var _pos:Point = getMousePosition(e);
			_x = _pos.x - _delta.x;
			_container.x = _x;
			
			
			
		}
		
		private function onMouseUp(e:Event):void 
		{
			if (!_enabled) return;
			if (!_isDraging) return;
			InterfaceTrace.trace2("SwipeHandler.onMouseUp");
			
			_isDraging = false;
			var _pos:Point = getMousePosition(e);
			_x = _pos.x - _delta.x;
			
			var _movementX:Number = _x - _tabx[0];
			
			//var _movementRatio:Number = _movementX / _width;
			
			trace("onMouseUp " + _x + " (" + _pos.x + " - " + _delta.x + "), _movementX : " + _movementX + ", (" + _x + " - " + _tabx[0] + ")");
			
			var _absmovementX:Number = Math.abs(_movementX);
			var _absx:Number = Math.abs(_x);
			if (_absmovementX > THRESHOLD_SWIPE_MOVEMENT || _absx > _width * THRESHOLD_SWIPE_PERCENT) {
				
				var _bnext:Boolean;
				if (_absmovementX > THRESHOLD_SWIPE_MOVEMENT) _bnext = (_movementX > 0);
				else _bnext = (_x > 0);
				
				var _endx:Number = (_bnext) ? +_width : -_width;
				var _evt:SwipeEvent = new SwipeEvent(SwipeEvent.SWIPE);
				_evt.delta = (_bnext) ? -1 : +1;
				dispatchEvent(_evt);
				
				_tabx = new Array();
				
				if (_swipeback) {
					_twm.tween(_container, "x", NaN, 0, 0.18);
				}
			}
			else {
				_twm.tween(_container, "x", NaN, 0, 0.18);
			}
			
		}
		
		
		public function cancelSwipe():void 
		{
			_twm.tween(_container, "x", NaN, 0, 0.18);
		}
		
		
		
		
		public function addEventListener(_type:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _handler);
		}
		
		public function dispatchEvent(_evt:Event):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		public function enable(_value:Boolean):void 
		{
			_enabled = _value;
			
		}
		
		
		private function getMousePosition(e:Event):Point
		{
			var _output:Point;
			if (e is TouchEvent) {
				var _te:TouchEvent = TouchEvent(e);
				_output = new Point(_te.stageX, _te.stageY);
				
			}
			else if (e is MouseEvent) {
				var _me:MouseEvent = MouseEvent(e);
				_output = new Point(_me.stageX, _me.stageY);
			}
			return _output;
		}
		
		
		
		private function onEnterframe(e:Event):void 
		{
			if (!_enabled) return;
			if (_isDraging) {
				
				_tabx.push(_x);
				while (_tabx.length > 2) _tabx.shift();
				//trace("_tabx : " + _tabx);
			}
		}
		
		
		
		
		
		
		private function addMouseListener(_target:DisplayObject, _type:String, _handler:Function):void 
		{
			if (Multitouch.supportsTouchEvents) _type = mouseToTouchEvent(_type);
			_target.addEventListener(_type, _handler);
		}
		
		private function removeMouseListener(_target:DisplayObject, _type:String, _handler:Function):void 
		{
			if (Multitouch.supportsTouchEvents) _type = mouseToTouchEvent(_type);
			_target.removeEventListener(_type, _handler);
		}
		
		
		private function mouseToTouchEvent(_type:String):String 
		{
			var _output:String;
			
			if (_type == MouseEvent.MOUSE_DOWN) _output = TouchEvent.TOUCH_BEGIN;
			else if (_type == MouseEvent.MOUSE_UP) _output = TouchEvent.TOUCH_END;
			else if (_type == MouseEvent.MOUSE_MOVE) _output = TouchEvent.TOUCH_MOVE;
			else throw new Error("can't convert event '" + _type + "'");
			
			return _output;
		}
		
		public function set swipeback(value:Boolean):void { _swipeback = value; }
		
		
	}

}