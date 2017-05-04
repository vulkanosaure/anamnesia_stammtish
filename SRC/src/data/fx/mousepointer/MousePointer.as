package data.fx.mousepointer 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class MousePointer extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		var base:DisplayObject;
		var _shift:Point;
		var _hidden:Boolean;
		var _keepOnStage:Boolean;
		var _disabled:Boolean;
		
		public function MousePointer(_stage:Stage, _base:DisplayObject, __shift:Point) 
		{
			base = _base;
			_shift = __shift;
			_hidden = true;
			_keepOnStage = true;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			_base.addEventListener(MouseEvent.CLICK, onClickBase);
			
			if (_base != null) {
				_base.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutBase);
				_base.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverBase);
			}
			
			
			_disabled = true;
			this.visible = false;
			
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
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
		
		public function hide():void
		{
			_hidden = true;
		}
		
		public function show():void
		{
			this.visible = true;
			_hidden = false;
		}
		
		public function set shift(_pt:Point):void
		{
			_shift = _pt;
		}
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private function updatePosition(_xmouse:Number, _ymouse:Number):void
		{
			var _x:Number = _xmouse + _shift.x;
			var _y:Number = _ymouse + _shift.y;
			
			if(_keepOnStage){
				if (_x + this.width > stage.stageWidth) _x = stage.stageWidth - this.width;
				if (_y + this.height > stage.stageHeight) _y = stage.stageHeight - this.height;
				if (_x < 0) _x = 0;
				if (_y < 0) _y = 0;
			}
			
			this.x = _x;
			this.y = _y;
		}
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onMousemove(e:MouseEvent):void 
		{
			if (_disabled) return;
			if (stage == null) {
				return;
			}
			
			//si la base et le stage, on réanime l'info sur mousemove
			if (_hidden && base==null) show();
			
			updatePosition(stage.mouseX, stage.mouseY);
			
		}
		
		
		private function onMouseLeave(e:Event):void 
		{
			if (_disabled) return;
			if(!_hidden) this.hide();
		}
		
		private function onMouseOutBase(e:MouseEvent):void 
		{
			if (_disabled) return;
			if(!_hidden) this.hide();
		}
		
		private function onMouseOverBase(e:MouseEvent):void 
		{
			if (_disabled) return;
			if(_hidden) this.show();
		}
		
		
		private function onClickBase(e:MouseEvent):void 
		{
			if (_disabled) return;
			this.dispatchEvent(new MousePointerEvent(MousePointerEvent.CLICK));
		}
		
	}

}