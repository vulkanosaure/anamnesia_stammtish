package data2.behaviours.transtions {
	
	import data2.behaviours.Behaviour;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import data.fx.transitions.TweenManager;
	import fl.transitions.easing.*;
	
	public class SpriteTransitioner extends Behaviour{
		
		//params
		
		
		//private vars
		private var _effect_in:Function;
		private var _effect_out:Function;
		private var _inOnTop:Boolean;
		
		private var def_tweens_in:Array;
		private var def_tweens_out:Array;
		
		private var _selectedIndex:int;
		private var _selectedIndexSave:int;
		
		private var twm:TweenManager = new TweenManager();
		private var _inverseCoords:Boolean;
		private var _container:DisplayObjectContainer;
		
		//_______________________________________________________________
		//public functions
		
		public function SpriteTransitioner(__container:DisplayObjectContainer) 
		{ 
			_container = __container;
			
			_effect_in = Regular.easeOut;
			_effect_out = Regular.easeOut;
			_inOnTop = true;
			
			def_tweens_in = new Array();
			def_tweens_out = new Array();
			_selectedIndex = -1;
			
			_inverseCoords = false;
		}
		
		
		
		public function addTween(_type:String, _prop:String, _start:Number, _end:Number, _time:Number, _delay:Number=0, _effect:Function=null)
		{
			if(_type!="in" && _type!="out") throw new Error("Wrong value for arg 1 in SpriteTransitioner.addTween (\"in\" or \"out\")");
			var arr:Array = (_type=="in") ? def_tweens_in : def_tweens_out;
			arr.push({"_prop":_prop, "_start":_start, "_end":_end, "_time":_time, "_delay":_delay, "_effect":_effect});
		}
		
		
		
		public function next():void
		{
			var _id:int = _selectedIndex + 1;
			if (_id == childrens.length) _id = 0;
			this.selectedIndex = _id;
		}
		
		public function prev():void
		{
			var _id:int = _selectedIndex - 1;
			if (_id == -1) _id = childrens.length - 1;
			this.selectedIndex = _id;
		}
		
		
		
		public function init(_id:int):void
		{
			if (childrens.length == 0) throw new Error("SpriteTransitioner.init(), can't use init() : no item was found");
			if(_id>=childrens.length) throw new Error("SpriteTransitioner.init(), arg 1 must be in interval [0;"+childrens.length+"[");
			hideAll();
			childrens[_id].visible = true;
			_selectedIndex = _id;
		}
		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set inverseCoords(v:Boolean):void
		{
			_inverseCoords = v;
		}
		
		public function get length():uint
		{
			return childrens.length;
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
		
		public function set selectedIndex(_id:int):void 
		{
			if(_id==_selectedIndex) return;
			if (_id >= childrens.length) throw new Error("SpriteTransitioner.selectedIndex must be in interval [0;" + childrens.length + "[ (" + _id + ")");
			_selectedIndexSave = _selectedIndex;
			_selectedIndex = _id;
			hideAll();
			if(_selectedIndexSave!=-1) applyTweens("out");
			applyTweens("in");
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function hideAll():void
		{
			var _len = childrens.length;
			var d:DisplayObject;
			for(var i:int=0;i<_len;i++){
				d = childrens[i];
				d.visible = false;
			}
		}
		
		
		public function setDisplayObjectOnTop(_d:DisplayObject):void
		{
			//trace("setDisplayObjectOnTop("+_d+")");
			if (_container.numChildren == 0) return;
			_container.setChildIndex(_d, _container.numChildren-1);
		}
		
		
		
		private function applyTweens(_type:String):void
		{
			var arr:Array = (_type=="in") ? def_tweens_in : def_tweens_out;
			var id:int = (_type=="in") ? _selectedIndex : _selectedIndexSave;
			var effectBase:Function = (_type=="in") ? _effect_in : _effect_out;
			
			var d:DisplayObject = childrens[id]
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
				
				twm.tween(d, _prop, _start, _end, arr[i]["_time"], arr[i]["_delay"], _effect);
				d[_prop] = _start;
			}
			
		}
		
		
		
		
		

		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}