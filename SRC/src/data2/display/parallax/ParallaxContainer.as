package data2.display.parallax 
{
	import data2.InterfaceSprite;
	import data2.states.IStateActivation;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ParallaxContainer extends InterfaceSprite implements IStateActivation
	{
		private var _ralent:Number;
		
		
		private var _enabled:Boolean;
		private var _stage:Stage;
		private var _parallaxChildrens:Array;
		private var _percentX:Number;
		private var _percentY:Number;
		
		public function ParallaxContainer() 
		{
			_parallaxChildrens = new Array();
			_ralent = 4;
			
		}
		
		public function initParallax(__stage:Stage):void
		{
			
			_enabled = true;
			
			_percentX = 0;
			_percentY = 0;
			
			_stage = __stage;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(Event.ENTER_FRAME, onEnterframe);
			
		}
		
		
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			if (!(child is ParallaxChild)) throw new Error("ParallaxContainer can only contain ParallaxChild");
			_parallaxChildrens.push(child);
			return super.addChild(child);
		}
		
		
		
		public function state_deactivate():void
		{
			//trace("paralax " + this.id + ", state_deactivate()");
			_enabled = false;
		}
		
		public function state_activate():void
		{
			//trace("paralax " + this.id + ", state_activate()");
			_enabled = true;
		}
		
		public function set ralent(value:Number):void{_ralent = value;}
		
		
		
		
		
		//_________________________________________________________________________
		//private functions
		
		private function update():void
		{
			//positif va dans le sens inverse
			
			var _len:int = _parallaxChildrens.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:ParallaxChild = ParallaxChild(_parallaxChildrens[i]);
				var _x:Number = Math.round(_child.offsetx - _percentX * _child.zindex);
				var _y:Number = Math.round(_child.offsety - _percentY * _child.zindex);
				
				_child.x += Math.round((_x - _child.x) / _ralent);
				_child.y += Math.round((_y - _child.y) / _ralent);
				
			}
		}
		
		
		
		
		
		
		
		//_________________________________________________________________________
		//events
		
		
		private function onMouseMove(e:MouseEvent):void 
		{
			_percentX = (_stage.mouseX / _stage.stageWidth) * 2 - 1;
			_percentY = (_stage.mouseY / _stage.stageHeight) * 2 - 1;
			//trace("ParallaxContainer.onMouseMove " + _percentX + ", " + _percentY);
			
			
		}
		
		
		private function onEnterframe(e:Event):void 
		{
			if (!_enabled) return;
			//trace("paralax activated : " + this.id);
			update();
		}
		
		
	}

}