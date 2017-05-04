package data2.effects 
{
	import data2.asxml.ObjectSearch;
	import data2.layoutengine.LayoutSprite;
	import data.fx.transitions.TweenManager;
	import data.utils.Delay;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class Effect extends EventDispatcher
	{
		private const DIRECTION_VALUES:Array = ["left", "right", "top", "bottom", "topleft", "topright", "bottomleft", "bottomright"];
		private const SIDE_VALUES:Array = ["horizontal", "vertical"];
		public static const SENS_CLOCK:String = "clock";
		public static const SENS_UNCLOCK:String = "unclock";
		
		
		//paramétrable depuis css
		private var _subpath:String;
		private var _subindex:int;
		
		private var _time:Number;
		private var _delay:Number;
		private var _effect:Function;
		
		
		protected var _direction:*;
		protected var _side:String;
		protected var _amountpercent_start:Number;
		protected var _amountpercent_end:Number;
		protected var _amountpx_start:Number;
		protected var _amountpx_end:Number;
		protected var _amountRotation:Number;
		protected var _sensRotation:String;
		
		
		
		
		private var _subtarget:DisplayObject;
		private var _target:DisplayObject;
		protected var _realtarget:DisplayObject;
		
		private var twm:TweenManager;
		private var defs:Array;
		private var _listDelays:Array;
		private var _isPlaying:Boolean;
		
		
		
		
		
		public function Effect() 
		{
			twm = new TweenManager();
			defs = new Array();
			_listDelays = new Array();
			
			_subpath = "";
			_subindex = -1;
		}
		
		
		
		//____________________________________________________________________________________________
		//setter / getter (css)
		
		public function set subpath(value:String):void 
		{
			_subpath = value;
		}
		
		
		public function set subindex(value:int):void 
		{
			_subindex = value;
		}
		
		public function get subindex():int {return _subindex;}
		
		public function get subpath():String {return _subpath;}
		
		
		
		
		public function set amountpx_end(value:Number):void 
		{
			_amountpx_end = value;
		}
		
		public function set amountpx_start(value:Number):void 
		{
			_amountpx_start = value;
		}
		
		public function set amountpercent_end(value:Number):void 
		{
			_amountpercent_end = value;
		}
		
		public function set amountpercent_start(value:Number):void 
		{
			_amountpercent_start = value;
		}
		
		
		public function set amountRotation(value:Number):void 
		{
			_amountRotation = value;
		}
		
		
		public function set sensRotation(value:String):void 
		{
			if (value != SENS_CLOCK && value != SENS_UNCLOCK) 
				throw new Error("wrong value for arg sensRotation (" + value + "), possible values are " + SENS_CLOCK + " or " + SENS_UNCLOCK);
			_sensRotation = value;
		}
		
		
		
		public function set direction(value:*):void 
		{
			if (value is String) {
				if (DIRECTION_VALUES.indexOf(value) == -1) throw new Error("wrong value for param Effect.direction : "+value);
			}
			else _direction = value;
			_direction = value;
		}
		
		
		public function set side(value:String):void 
		{
			if (SIDE_VALUES.indexOf(value) == -1) throw new Error("wrong value for param Effect.side : "+value);
			_side = value;
		}
		
		public function set delay(value:Number):void 
		{
			_delay = value;
		}
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
		
		public function set effect(value:Function):void 
		{
			_effect = value;
		}
		
		
		
		
		
		
		//____________________________________________________________________________________________
		//public functions
		
		public function set target(value:DisplayObject):void 
		{
			_target = value;
			
			if (_subpath != "") {
				//if (!(_target is DisplayObjectContainer)) throw new Error("target dobj " + _target + " must be a DisplayObjectContainer if you use subtarget");
				//_subtarget = DisplayObjectContainer(_target).getChildByName(_subpath);
				
				var _objsearch:* = ObjectSearch.search(_target, _subpath);
				if (!(_objsearch is DisplayObject)) throw new Error("subtarget with path " + _subpath + " must be a DisplayObject");
				_subtarget = DisplayObject(_objsearch);
				_realtarget = _subtarget;
			}
			else if (_subindex != -1) {
				if (!(_target is DisplayObjectContainer)) throw new Error("target dobj " + _target + " must be a DisplayObjectContainer if you use subtarget");
				
				if (DisplayObjectContainer(_target).numChildren - 1 < _subindex) throw new Error("subindex "+_subindex+" is out of bounds in dobj "+_target);
				
				var _numchildren:int = DisplayObjectContainer(_target).numChildren;
				_subtarget = DisplayObjectContainer(_target).getChildAt(_numchildren - 1 - _subindex);
				_realtarget = _subtarget;
			}
			else {
				_realtarget = _target;
			}
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		
		
		
		
		
		
		public function play(_evt:*=null, _showOnStart:Boolean=false, _hideOnFinish:Boolean=false, _straight:Boolean=false):void
		{
			var len:int = defs.length;
			var _timeEffect:Number = getTimeEffect();
			
			
			if(_hideOnFinish){
				new Delay(_timeEffect * 1000, _setUnvisible, _realtarget);
			}
			
			_isPlaying = true;
			new Delay(_timeEffect * 1000, setPlaying, false);
			
			for (var i:int = 0; i < len; i++) 
			{
				var _def:Object = defs[i];
				var _d:Number = isNaN(_delay) ? _def.delay : _delay;
				if (isNaN(_d)) _d = 0;
				
				if(_def.prop == "rotation") trace("play _d : " + _d + " : " + _def.start + ", " + _def.end + ", " + _def.time + ", " + _def.effect);
				var _t:* = (_def.useThis) ? this : _realtarget;
				
				var _transformedProp:String = transformPropLayout(_t, _def.prop);
				_t[_transformedProp] = _def.start;
				
				if (_straight) {
					//trace("play applyStraight : " + ((_t is DisplayObject) ? DisplayObject(_t).name : _t) + ", " + _def.prop + ", " + _def.start);
					applyStraight(_t, _def.prop, _def.end);
				}
				else{
					var _delayobj:Delay = new Delay(_d * 1000, applyTween, _t, _def.prop, _def.start, _def.end, _def.time, _def.effect, _showOnStart);
					_listDelays.push(_delayobj);
				}
			}
		}
		
		private function setPlaying(_value:Boolean):void 
		{
			_isPlaying = _value;
		}
		public function isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		
		
		public function rewind(_evt:*=null, _showOnStart:Boolean=false, _hideOnFinish:Boolean=false, _straight:Boolean=false):void
		{
			var len:int = defs.length;
			
			
			var _timeEffect:Number = getTimeEffect();
			
			if(_hideOnFinish){
				new Delay(_timeEffect * 1000, _setUnvisible, _realtarget);
			}
			
			_isPlaying = true;
			new Delay(_timeEffect * 1000, setPlaying, false);
			
			
			for (var i:int = 0; i < len; i++) 
			{
				var _def:Object = defs[i];
				var _d:Number = isNaN(_delay) ? _def.delay : _delay;
				if (isNaN(_d)) _d = 0;
				
				var _t:* = (_def.useThis) ? this : _realtarget;
				var _transformedProp:String = transformPropLayout(_t, _def.prop);
				_t[_transformedProp] = _def.end;
				
				if (_straight) {
					//trace("rewind applyStraight : " + ((_t is DisplayObject) ? DisplayObject(_t).name : _t) + ", " + _def.prop + ", " + _def.start);
					applyStraight(_t, _def.prop, _def.start);
				}
				else {
					var _delayobj:Delay = new Delay(_d * 1000, applyTween, _t, _def.prop, _def.end, _def.start, _def.time, _def.effect, _showOnStart);
					_listDelays.push(_delayobj);
				}
				
			}
		}
		
		
		
		public function stopEffect():void
		{
			//trace("Effect.stopEffect");
			_isPlaying = false;
			
			twm.reset();
			if (_listDelays == null) {
				_listDelays = new Array();
				return;
			}
			var _len:int = _listDelays.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _d:Delay = Delay(_listDelays[i]);
				if (_d.waiting) _d.stop();
			}
			_listDelays = new Array();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________________
		//private functions
		
		
		
		
		
		private function applyTween(_dobj:*, _prop:String, _start:Number, _end:Number, __time:Number, _effect:Function, _showOnStart:Boolean):void
		{
			if (_showOnStart && _dobj is DisplayObject) _dobj.visible = true;
			
			if (_prop == "alpha") _dobj.alpha = _start;
			
			if (isNaN(__time)) __time = _time;  
			
			var _transformedProp:String = transformPropLayout(_dobj, _prop);
			
			//trace("applyTween(" + _dobj + ", " + _prop + ", " + _start + ", " + _end + ", -- showonstart : " + _showOnStart);
			twm.tween(_dobj, _transformedProp, _start, _end, __time, 0, _effect);
			
		}
		
		
		private function applyStraight(_dobj:*, _prop:String, _end:Number):void 
		{
			var _transformedProp:String = transformPropLayout(_dobj, _prop);
			_dobj[_transformedProp] = _end;
		}
		
		
		
		private function transformPropLayout(_obj:*, _prop:String):String
		{
			if (_obj is LayoutSprite) {
				if (_prop == "x") return "super_x";
				if (_prop == "y") return "super_y";
			}
			return _prop;
		}
		
		
		
		public function init():void
		{
			
		}
		
		public function isSubtarget():Boolean 
		{
			return (_subindex != -1 || _subpath != "");
		}
		
		
		protected function reset():void
		{
			defs = new Array();
		}
		
		protected function addDef(_prop:String, _start:Number, _end:Number, __time:Number, __delay:Number, __effect:Function = null, __useThis:Boolean=false)
		{
			if (!isNaN(_delay)) __delay = _delay;
			if (!isNaN(_time)) __time = _time;
			if (_effect!=null) __effect = _effect;
			
			//trace(this+"addDef(" + _prop + ", " + _start + ", " + _end + ", " + __time + ", " + __delay + ", " + __effect + ")");
			defs.push({"prop":_prop, "start":_start, "end" : _end, "time" : __time, "delay" : __delay, "effect" : __effect, "useThis":__useThis});
		}
		
		
		private function getTimeEffect():Number
		{
			var _len:int = defs.length;
			var _maxtime:Number = 0;
			for (var i:int = 0; i < _len; i++) 
			{
				var def:Object = defs[i];
				var _totaltime:Number = def.time + def.delay;
				if (_totaltime > _maxtime) _maxtime = _totaltime;
			}
			return _maxtime;
		}
		
		
		
		//________________________________________________________________________
		//events
		
		
		
		private function _setUnvisible(_t:DisplayObject):void 
		{
			_t.visible = false;
		}
		
		
		
		
	}

}