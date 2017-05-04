/*
UTILISATION :

import data.fx.transitions.SpriteTransitioner;
var container = new SpriteTransitioner();
container.time_in = 0.7;
container.time_out = 0.7;
container.effect_in = Regular.easeIn;
container.effect_in = Regular.easeOut;
container.addTween("in", "alpha", 0, 1);
container.addTween("out", "alpha", 1, 1);
container.inOnTop = true;
container.addChild(...);



DOCUMENTATION

PROPERTIES :
	time_in:Number
	time_out:Number
	effect_in:Function
	effect_out:Function
	inOnTop:Boolean

METHODES :
	addChild(d:DisplayObject)
	addTween(_type:String, _prop:String, _start:Number, _end:Number);
	init(_id:int)
	goto_(_id:int)

EVENT : none

*/

package data.fx.transitions {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import data.fx.transitions.TweenManager;
	import fl.transitions.easing.*;
	
	public class SpriteTransitioner extends Sprite{
		
		//params
		
		
		//private vars
		var _effect_in:Function;
		var _effect_out:Function;
		var _inOnTop:Boolean;
		
		var def_tweens_in, def_tweens_out:Array;
		
		var cur_id, old_id:int;
		var items:Array;
		
		var twm:TweenManager = new TweenManager();
		var _inverseCoords:Boolean;
		var _outNaN:Boolean = false;
		
		
		//_______________________________________________________________
		//public functions
		
		public function SpriteTransitioner() 
		{ 
			_effect_in = Regular.easeOut;
			_effect_out = Regular.easeOut;
			_inOnTop = true;
			
			def_tweens_in = new Array();
			def_tweens_out = new Array();
			cur_id = -1;
			items = new Array();
			
			_inverseCoords = false;
		}
		
		
		
		public function addTween(_type:String, _prop:String, _start:Number, _end:Number, _time:Number, _delay:Number=0, _effect:Function=null)
		{
			if(_type!="in" && _type!="out") throw new Error("Wrong value for arg 1 in SpriteTransitioner.addTween (\"in\" or \"out\")");
			var arr:Array = (_type=="in") ? def_tweens_in : def_tweens_out;
			arr.push({"_prop":_prop, "_start":_start, "_end":_end, "_time":_time, "_delay":_delay, "_effect":_effect});
		}
		
		public function empty():void
		{
			while (this.numChildren) this.removeChildAt(0);
			items = new Array();
			twm.reset();
			old_id = -1;
			cur_id = -1;
		}
		
		
		public function goto_(_id:int):void
		{
			//trace("goto(" + _id + "), cur_id : " + cur_id);
			
			if (_id == cur_id) return;
			
			if (_id >= items.length) throw new Error("SpriteTransitioner.goto_(), arg 1 must be in interval [0;" + items.length + "[ (" + _id + ")");
			old_id = cur_id;
			cur_id = _id;
			hideAll();
			if(old_id!=-1) applyTweens("out");
			applyTweens("in");
		}
		
		public function next():void
		{
			var _id:int = cur_id + 1;
			if (_id == items.length) _id = 0;
			goto_(_id);
		}
		
		public function prev():void
		{
			var _id:int = cur_id - 1;
			if (_id == -1) _id = items.length - 1;
			goto_(_id);
		}
		
		
		
		public function init(_id:int):void
		{
			if (items.length == 0) throw new Error("SpriteTransitioner.init(), can't use init() : no item was found");
			if(_id>=items.length) throw new Error("SpriteTransitioner.init(), arg 1 must be in interval [0;"+items.length+"[");
			hideAll();
			items[_id].visible = true;
			cur_id = _id;
		}
		
		public override function addChild(_d:DisplayObject):DisplayObject
		{
			//trace("override addChild("+_d+")");
			addItem(_d);
			return super.addChild(_d);
		}
		
		public function addItem(_d:DisplayObject):void
		{
			_d.visible = false;
			items.push(_d);
		}
		
		public function get selectedIndex():uint
		{
			return cur_id;
		}
		
		public function set inverseCoords(v:Boolean):void
		{
			_inverseCoords = v;
		}
		
		public function get length():uint
		{
			return items.length;
		}
		
		
		//_______________________________________________________________
		//set / get
		
		public function set effect_in(v:Function):void
		{
			_effect_in = v;
		}
		public function set effect_out(v:Function):void
		{
			_effect_out = v;
		}
		public function set inOnTop(v:Boolean):void
		{
			_inOnTop = v;
		}
		
		public function set outNaN(value:Boolean):void 
		{
			_outNaN = value;
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function hideAll():void
		{
			var _len = items.length;
			var d:DisplayObject;
			for(var i:int=0;i<_len;i++){
				d = items[i];
				d.visible = false;
			}
		}
		
		
		public function setDisplayObjectOnTop(_d:DisplayObject):void
		{
			//trace("setDisplayObjectOnTop("+_d+")");
			if (this.numChildren == 0) return;
			this.setChildIndex(_d, this.numChildren-1);
		}
		
		
		
		private function applyTweens(_type:String):void
		{
			var arr:Array = (_type=="in") ? def_tweens_in : def_tweens_out;
			var id:int = (_type=="in") ? cur_id : old_id;
			var effectBase:Function = (_type=="in") ? _effect_in : _effect_out;
			
			var d:DisplayObject = items[id]
			if(_inOnTop && _type=="in") setDisplayObjectOnTop(d);
			else if(!_inOnTop && _type=="out") setDisplayObjectOnTop(d);
			d.visible = true;
			
			
			var _prop:String;
			var _start:Number;
			var _end:Number;
			var _effect:Function;
			
			for (var i in arr) {
				
				_prop = arr[i]["_prop"];
				_start = arr[i]["_start"];
				_end = arr[i]["_end"];
				_effect = arr[i]["_effect"];
				
				if (_effect == null) _effect = effectBase;
				
				if (_inverseCoords && (_prop == "x" || _prop == "y")) {
					
					if (_type == "in") _start = _end + (_end - _start);
					else if (_type == "out") _end = _start + (_start - _end);
					
				}
				
				if (_outNaN && _type == "out") _start = NaN;
				
				//trace("alphatest : " + d.alpha+", visible : "+d.visible);
				//trace("tween.add(" + d + ", " + _prop + ", " + _start + ", " + _end + ", " + arr[i]["_time"] + ", " + arr[i]["_delay"] + ", " + _effect);
				twm.tween(d, _prop, _start, _end, arr[i]["_time"], arr[i]["_delay"], _effect);
				d[_prop] = _start;
			}
			
		}
		
		
		
		
		

		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}