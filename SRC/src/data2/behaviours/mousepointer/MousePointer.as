package data2.behaviours.mousepointer 
{
	import data2.behaviours.Behaviour;
	import data2.display.ClickableSprite;
	import data2.effects.Effect;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class MousePointer extends Behaviour
	{
		//_______________________________________________________________________________
		// properties
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		private var _target:InteractiveObject;
		private var _offsetx:Number = NaN;
		private var _offsety:Number = NaN;
		private var _hidden:Boolean;
		private var _keepOnStage:Boolean;
		private var _disabled:Boolean;
		private var _stage:Stage;
		
		private var _halign:String = LEFT;
		private var _valign:String = BOTTOM;
		
		private var _effectover:Effect;
		private var _effectout:Effect;
		
		private var _mouseOver:Boolean;
		
		
		
		public function MousePointer() 
		{
			
			
		}
		
		
		override public function init():void 
		{
			_hidden = true;
			_keepOnStage = true;
			_stage = _interfaceSprite.stage;
			
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			//_interfaceSprite.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverPointer);
			_interfaceSprite.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
			if (_target != null) {
				_target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutTarget);
				_target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverTarget);
			}
			
			_disabled = false;
			_interfaceSprite.visible = false;
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		/*
		public function enable():void
		{
			_disabled = false;
			if(_hidden) this.show();
			onMousemove(new MouseEvent(MouseEvent.MOUSE_MOVE));
		}
		public function disable():void
		{
			_disabled = true;
			if(!_hidden) this.hide();
		}
		*/
		
		public function hide():void
		{
			_hidden = true;
			if (_effectout != null) {
				_effectout.target = _interfaceSprite;
				_effectout.init();
				_effectover.play(null, false, true);
			}
			else if (_effectover != null) {
				_effectover.target = _interfaceSprite;
				_effectover.init();
				_effectover.rewind(null, false, true);
			}
			else {
				_interfaceSprite.visible = false;
			}
			
		}
		
		public function show():void
		{
			_interfaceSprite.visible = true;
			if (_effectover != null) {
				_effectover.target = _interfaceSprite;
				_effectover.init();
				_effectover.play(null, true, false);
			}
			_hidden = false;
		}
		
		
		public function set offsetx(value:Number):void {_offsetx = value;}
		
		public function set offsety(value:Number):void {_offsety = value;}
		
		public function set target(value:InteractiveObject):void {_target = value;}
		
		public function set halign(value:String):void {_halign = value;}
		
		public function set valign(value:String):void {_valign = value;}
		
		public function set effectout(value:Effect):void 
		{
			_effectout = value;
		}
		
		public function set effectover(value:Effect):void 
		{
			_effectover = value;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private function updatePosition(_xmouse:Number, _ymouse:Number):void
		{
			var _x:Number = _xmouse + _offsetx;
			var _y:Number = _ymouse + _offsety;
			
			if(_keepOnStage){
				if (_x + _interfaceSprite.width > _stage.stageWidth) _x = _stage.stageWidth - _interfaceSprite.width;
				if (_y + _interfaceSprite.height > _stage.stageHeight) _y = _stage.stageHeight - _interfaceSprite.height;
				if (_x < 0) _x = 0;
				if (_y < 0) _y = 0;
			}
			
			_interfaceSprite.x = _x;
			_interfaceSprite.y = _y;
		}
		
		
		
		private function updateMargins():void
		{
			if (isNaN(_offsetx)) {
				if (_halign == LEFT) _offsetx = 0;
				else if (_halign == CENTER) _offsetx = -_interfaceSprite.width / 2;
				else if (_halign == RIGHT) _offsetx = -_interfaceSprite.width;
				else throw new Error("wrong value for property \"MousePointer.halign\", accepted values are " + LEFT + ", " + CENTER + ", " + RIGHT);
				
			}
			if (isNaN(_offsety)) {
				if (_valign == TOP) _offsety = 0;
				else if (_valign == CENTER) _offsety = -_interfaceSprite.height / 2;
				else if (_valign == BOTTOM) _offsety = -_interfaceSprite.height;
				else throw new Error("wrong value for property \"MousePointer.valign\", accepted values are " + TOP + ", " + CENTER + ", " + BOTTOM);
				
			}
		}
		
		
		//_______________________________________________________________________________
		// events
		
		private function onEnterframe(e:Event):void
		{
			if(_mouseOver){
				if(_hidden){
					updateMargins();
					updatePosition(_stage.mouseX, _stage.mouseY);
					this.show();
					
				}
			}
			else{
				if (!_hidden) this.hide();
			}
		}
		
		
		private function onMousemove(e:MouseEvent):void 
		{
			//trace("MousePointer.onMousemove");
			if (_hidden || _disabled) return;
			if (_stage == null) return;
			
			updatePosition(_stage.mouseX, _stage.mouseY);
			
			
			
		}
		
		
		private function onMouseLeave(e:Event):void 
		{
			//trace("MousePointer.onMouseLeave");
			if (_disabled) return;
			_mouseOver = false;
			
		}
		
		private function onMouseOutTarget(e:MouseEvent):void 
		{
			//trace("MousePointer.onMouseOutTarget "+_disabled+", "+_hidden);
			if (_disabled) return;
			_mouseOver = false;
		}
		
		
		private function onMouseOverPointer(e:MouseEvent):void 
		{
			//trace("onMouseOverPointer");
			_mouseOver = true;
		}
		
		
		private function onMouseOverTarget(e:MouseEvent):void 
		{
			//trace("MousePointer.onMouseOverTarget");
			if (_disabled) return;
			
			_mouseOver = true;
			
		}
		
		
		
	}

}