package data2.states 
{
	import data2.effects.Effect;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class DisplayObjectInfo 
	{
		private var _displayObject:DisplayObject;
		private var _name:String;
		private var _classname:String;
		
		public var display:Boolean;
		public var saveObject:Object;
		
		private var _effect:Effect;
		private var _effecthide:Effect;
		private var _transitionDef:TransitionDef;
		
		
		
		
		public function DisplayObjectInfo(_dobj:DisplayObject, __classname:String, __name:String) 
		{
			_displayObject = _dobj;
			_classname = __classname;
			_name = __name;
			display = false;
			_transitionDef = new TransitionDef();
		}
		
		
		
		public function toString():String
		{
			var _str:String = "";
			_str += "Dobjinfo, classname : " + _classname + ", name : "+_displayObject.name+", display : " + display;
			return _str;
		}
		
		public function setTransitionDef(_transitionmode:String, _tempo:Number, _timetransform:Number, _effecttransform:Function):void 
		{
			_transitionDef.mode = _transitionmode;
			_transitionDef.tempo = _tempo;
			_transitionDef.timetransform = _timetransform;
			_transitionDef.effecttransform = _effecttransform;
		}
		
		
		//_________________________________________________________________
		//set / get
		
		
		public function get displayObject():DisplayObject 
		{
			return _displayObject;
		}
		
		public function get classname():String 
		{
			return _classname;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		
		
		
		
		public function get effect():Effect {return _effect;}
		
		public function set effect(value:Effect):void {_effect = value;}
		
		public function get effecthide():Effect {return _effecthide;}
		
		public function set effecthide(value:Effect):void {_effecthide = value;}
		
		
		
		
	}

}