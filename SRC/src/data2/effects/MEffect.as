package data2.effects 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class MEffect extends Effect
	{
		private var _effects:Array;
		private var _nbeffects:int;
		protected var _subtargets:Array;
		
		
		public function MEffect() 
		{
			_effects = new Array();
			_subtargets = new Array();
			_nbeffects = 0;
		}
		
		public function add(_effect:Effect):void
		{
			//trace("MEffect.add(" + _effect + ")");
			_effects.push(_effect);
			_nbeffects++;
		}
		
		
		
		override public function set target(value:DisplayObject):void 
		{
			if (_subtargets.length > 0) {
				if (!(value is DisplayObjectContainer)) throw new Error("MEffect must have target with names : " + _subtargets);
				var _len:int = _subtargets.length;
				var _dobjc:DisplayObjectContainer = DisplayObjectContainer(value);
				for (var i:int = 0; i < _len; i++) 
				{
					if (_dobjc.getChildByName(_subtargets[i]) == null) throw new Error("MEffect must have target with names : " + _subtargets);
				}
			}
			
			setToAll("target", value);
		}
		
		
		override public function set delay(value:Number):void 
		{
			setToAll("delay", value);
		}
		
		override public function set direction(value:*):void 
		{
			setToAll("direction", value);
		}
		
		
		
		//set / get
		override public function set time(value:Number):void 
		{
			//trace("MEffect.set time(" + value + ")");
			setToAll("time", value);
		}
		override public function set effect(value:Function):void 
		{
			setToAll("effect", value);
		}
		
		
		
		
		
		
		override public function init():void 
		{
			funcToAll("init");
		}
		
		override public function play(_evt:*=null, _showOnStart:Boolean=false, _hideOnFinish:Boolean=false, _straight:Boolean=false):void
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				_e.play(_evt, _showOnStart, _hideOnFinish, _straight);
			}
		}
		
		override public function rewind(_evt:*=null, _showOnStart:Boolean=false, _hideOnFinish:Boolean=false, _straight:Boolean=false):void
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				_e.rewind(_evt, _showOnStart, _hideOnFinish, _straight);
			}
		}
		
		override public function stopEffect():void 
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				_e.stopEffect();
			}
		}
		
		override public function isSubtarget():Boolean 
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				if (_e.isSubtarget()) return true;
			}
			return false;
		}
		
		override public function set amountpercent_start(value:Number):void 
		{
			setToAll("amountpercent_start", value);
		}
		override public function set amountpercent_end(value:Number):void 
		{
			setToAll("amountpercent_end", value);
		}
		
		
		
		
		private function funcToAll(_func:String):void
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				_e[_func]();
			}
		}
		
		private function setToAll(_prop:String, _value:*):void
		{
			for (var i:int = 0; i < _nbeffects; i++) 
			{
				var _e:Effect = Effect(_effects[i]);
				_e[_prop] = _value;
			}
		}
	}

}