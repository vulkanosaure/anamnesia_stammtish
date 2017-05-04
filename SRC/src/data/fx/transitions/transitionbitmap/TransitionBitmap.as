package data.fx.transitions.transitionbitmap 
{
	import data.fx.transitions.TweenManager;
	import fl.transitions.easing.Regular;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Vincent
	 */
	public class TransitionBitmap extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		public static const TYPE_IN:String = "in";
		public static const TYPE_OUT:String = "out";
		
		private var twmOut:TweenManager = new TweenManager();
		private var twmIn:TweenManager = new TweenManager();
		
		private var _container:DisplayObjectContainer;
		private var _stage:Stage;
		
		private var _targetOut:DisplayObject;
		private var _targetIn:DisplayObject;
		
		private var _cloneOut:Sprite;
		private var _cloneIn:Sprite;
		
		private var _paramsIn:Array;
		private var _paramsOut:Array;
		
		private var _posTargetOut:Point;
		private var _posTargetIn:Point;
		
		private var _duration:Number;
		private var _delay:Number;
		private var _effect:Function;
		
		
		
		
		
		
		public function TransitionBitmap(__stage:Stage, __container:DisplayObjectContainer) 
		{
			_stage = __stage;
			_container = __container;
			
			//default params
			_duration = 1.0;
			_delay = 0.0;
			_effect = Regular.easeOut;
			
			twmOut.addEventListener(Event.COMPLETE, onTweenOutEnd);
			twmIn.addEventListener(Event.COMPLETE, onTweenInEnd);
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// setters
		
		
		
		public function set targetOut(value:DisplayObject):void 
		{
			_targetOut = value;
			if (_cloneOut != null) resetClone(_cloneOut);
			
			if (value == null) _cloneOut = null;
			else {
				_cloneOut = getClone(_targetOut);
				_posTargetOut = new Point(_targetOut.x, _targetOut.y);
			}
		}
		
		
		public function set targetIn(value:DisplayObject):void 
		{
			_targetIn = value;
			if (_cloneIn != null) resetClone(_cloneIn);
			
			if (value == null) _cloneIn = null;
			else {
				_cloneIn = getClone(_targetIn);
				_posTargetIn = new Point(_targetIn.x, _targetIn.y);
			}
		}
		
		
		
		
		public function set effect(value:Function):void 
		{
			_effect = value;
		}
		
		public function set delay(value:Number):void 
		{
			_delay = value;
		}
		
		public function set duration(value:Number):void 
		{
			_duration = value;
		}
		
		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		public function setParams(_type:String, _listprop:Array):void
		{
			if (_type != TYPE_IN && _type != TYPE_OUT) throw new Error("arg _type must be '" + TYPE_IN + "' or '" + TYPE_OUT + "'");
			
			var _params:Array;
			if (_type == TYPE_IN) {
				_paramsIn = new Array();
				_params = _paramsIn;
			}
			else {
				_paramsOut = new Array();
				_params = _paramsOut;
			}
			
			for (var i:int = 0; i < _listprop.length; i++) _params[i] = TransitionProperty(_listprop[i]).clone();
		}
		
		
		
		
		public function start():void
		{	
			trace("_paramsIn : " + _paramsIn);
			trace("_paramsOut : " + _paramsOut);
			
			if (_targetIn != null) {
				_targetIn.visible = false;
				_container.addChildAt(_cloneIn, _container.getChildIndex(_targetIn));
				tweenProperties(_cloneIn, _paramsIn, _posTargetIn, TYPE_IN);
			}
			
			if (_targetOut != null) {
				_targetOut.visible = false;
				_container.addChildAt(_cloneOut, _container.getChildIndex(_targetOut));
				tweenProperties(_cloneOut, _paramsOut, _posTargetOut, TYPE_OUT);
			}
			
			if (_cloneIn != null) _cloneIn.visible = true;
			if (_cloneOut != null) _cloneOut.visible = true;
		}
		
		
		private function resetClone(_clone:Sprite):void
		{
			//trace("resetClone(" + _clone + ")");
			if (_container != null && _container.contains(_clone)) _container.removeChild(_clone);
			var bmp:Bitmap = Bitmap(_clone.getChildAt(0));
			bmp.bitmapData.dispose();
			bmp = null;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function getClone(_dobj:DisplayObject):Sprite
		{
			var bounds:Rectangle = _dobj.getBounds(_dobj);
			var bmpData:BitmapData = new BitmapData(_dobj.width, _dobj.height, true, 0);
			bmpData.draw(_dobj, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			var _bmp:Bitmap = new Bitmap(bmpData);
			var _sp:Sprite = new Sprite();
			_sp.addChild(_bmp);
			//trace("bounds : " + bounds);
			_bmp.x = bounds.x;
			_bmp.y = bounds.y;
			
			return _sp;
		}
		
		
		
		private function tweenProperties(_clone:Sprite, _listprop:Array, _offsetpos:Point, _type:String):void
		{
			if (_type != TYPE_IN && _type != TYPE_OUT) throw new Error("arg _type must be '" + TYPE_IN + "' or '" + TYPE_OUT + "'");
			
			var __start:Number;
			var __end:Number;
			var __duration:Number;
			var __delay:Number;
			var __effect:Function;
			var __twm:TweenManager = (_type == TYPE_IN) ? twmIn : twmOut;
			var __prop:String;
			
			_clone.x = _offsetpos.x;
			_clone.y = _offsetpos.y;
			
			for (var i:int = 0; i < _listprop.length; i++)
			{
				var tp:TransitionProperty = TransitionProperty(_listprop[i]);
				__prop = tp.prop;
				__start = tp.valStart;
				__end = tp.valEnd;
				__duration = (isNaN(tp.duration)) ? _duration : tp.duration;
				__delay = (isNaN(tp.delay)) ? _delay : tp.delay;
				__effect = (tp.effect==null) ? _effect : tp.effect;
				
				
				if (__prop == "x") {
					__start += _offsetpos.x;
					__end += _offsetpos.x;
				}
				else if (__prop == "y") {
					__start += _offsetpos.y;
					__end += _offsetpos.y;
				}
				
				if (__prop == "xstageout" || __prop == "ystageout" || __prop == "xstagein" || __prop == "ystagein") {
					var _stagetype:String;
					if (__prop == "xstageout") {
						__prop = "x";
						_stagetype = "out";
					}
					else if (__prop == "ystageout") {
						__prop = "y";
						_stagetype = "out";
					}
					else if (__prop == "xstagein") {
						__prop = "x";
						_stagetype = "in";
					}
					else if (__prop == "ystagein") {
						__prop = "y";
						_stagetype = "in";
					}
					__start = getStageCoords(__prop, __start, _clone, _stagetype);
					__end = getStageCoords(__prop, __end, _clone, _stagetype);
					trace("__start : " + __start + ", __end : " + __end);
				}
				
				
				
				if (isNaN(__start)) __start = (_type == TYPE_IN) ? _targetIn[__prop] : _targetOut[__prop];
				if (isNaN(__end)) __end = (_type == TYPE_IN) ? _targetIn[__prop] : _targetOut[__prop];
				
				
				_clone[__prop] = __start;
				__twm.tween(_clone, __prop, __start, __end, __duration, __delay, __effect);
				
			}
		}
		
		
		
		
		private function getStageCoords(_prop:String, _value:Number, _clone:Sprite, _stagetype:String):Number
		{
			if (_prop != "x" && _prop != "y") throw new Error("% value only woorks for coords (x or y)");
			if(_stagetype!="in" && _stagetype!="out") throw new Error("stagetype must be in or out");
			if (isNaN(_value)) return NaN;
			
			var stagedim:Number = (_prop == "x") ? _stage.stageWidth : _stage.stageHeight;
			var clonedim:Number = (_prop == "x") ? _clone.width : _clone.height;
			
			var valuepx:Number;
			if (_stagetype == "out") valuepx = _value * (stagedim + clonedim) - clonedim;
			else valuepx = _value * (stagedim - 2 * clonedim) + clonedim;
			
			var ptsrc:Point = (_prop == "x") ? new Point(valuepx, 0) : new Point(0, valuepx);
			var ptdst = _container.localToGlobal(ptsrc);
			return ptdst[_prop];
		}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onTweenOutEnd(e:Event):void 
		{
			trace("TransitionBitmapManager.onTweenOutEnd");
			if (_cloneOut != null) _cloneOut.visible = false;
		}
		
		private function onTweenInEnd(e:Event):void 
		{
			trace("TransitionBitmapManager.onTweenInEnd");
			_targetIn.visible = true;
			if (_cloneIn != null) _cloneIn.visible = false;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}


/*
TODO :

margin, outline bottom-right is not taken			a surveiller
offset bmp if offset target is not [0,0]			OK
static properties in tweenProperties				OK
position initiale									OK
reaparition des target								OK
reset												OK

reset in / out separately (2 twm)					OK
accepted_properties:Array							OK
properties xstagein, ...							OK
correct pos sur scale
test 1 container mode

IDEE / PROBLEMATIQUES : 

*/