package data2.asxml 
{
	import data2.display.ClickableSprite;
	import data2.effects.Effect;
	import data2.states.stateparser.EffectParser;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Vinc
	 */
	public class BtnEffectHandler 
	{
		private var _effect:Effect;
		private var _sprite:Sprite;
		private var _over:Boolean = false;
		private var _lastTarget:Sprite;
		
		public function BtnEffectHandler() 
		{
			
		}
		
		
		public function init(__sprite:Sprite, _effectstr:String):void
		{
			//trace("BtnEffectHandler.init");
			_sprite = __sprite;
			/*_sprite.mouseEnabled = true;
			_sprite.mouseChildren = true;*/
			
			var _sp:Sprite = _sprite;
			var _childtest:DisplayObject = _sprite.getChildByName(ClickableSprite.CLICKABLE_SPRITE_NAME);
			if (_childtest != null) {
				_sp = Sprite(_childtest);
			}
			else {
				_sprite.buttonMode = true;
				_sprite.mouseChildren = false;
			}
			
			
			
			_effect = EffectParser.getEffect(_effectstr);
			
			
			/*
			_sp.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent_over);
			*/
			
			_sp.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent_out);
			_sp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent_over);
			_sp.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent_out);
			
		}
		
		private function onMouseEvent_out(e:MouseEvent):void 
		{
			if (!_over) return;
			_over = false;
			
			//trace("onMouseEvent_out");
			
			//if is running, cancel, and push to last state
			
			var _target:DisplayObject = _sprite.getChildAt(0);
			
			_effect.target = _target;
			_effect.init();
			_effect.rewind();
		}
		
		private function onMouseEvent_over(e:MouseEvent):void 
		{
			if (_over) return;
			_over = true;
			
			
			
			//trace("onMouseEvent_over");
			var _target:DisplayObject = _sprite.getChildAt(0);
			
			_effect.target = _target;
			_effect.init();
			_effect.play();
			
		}
		
	}

}