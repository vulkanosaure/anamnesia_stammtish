package data2.states 
{
	import data2.layoutengine.LayoutSprite;
	import data2.effects.Effect;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class State 
	{
		private var _id:String;
		private var _listdobj:Array;
		
		private var _effect:Effect;
		private var _effecthide:Effect;
		private var _transitionDef:TransitionDef;
		
		private var _buttoneffect:Effect;
		private var _buttoneffecthide:Effect;
		
		private var _propertySet:PropertySet;
		
		
		public function State(__id:String) 
		{
			_id = __id;
			_listdobj = new Array();
			_transitionDef = null;
			_propertySet = new PropertySet();
			_transitionDef = new TransitionDef();
		}
		
		public function addComponent(_dobj:DisplayObject):void
		{
			_listdobj.push(_dobj);
		}
		
		
		public function setComponentProperty(_dobj:DisplayObject, _prop:String, _value:*):void 
		{
			if (_prop == "scale") {
				_propertySet.add(_dobj, "scaleX", _value);
				_propertySet.add(_dobj, "scaleY", _value);
			}
			else {
				
				if (PropertySet.PROPERTIES_POSITION_LAYOUT.indexOf(_prop) != -1 && !(_dobj is LayoutSprite)) 
					throw new Error("property " + _prop + " is only allowed for LayoutSprite (" + _dobj + ")");
					
				if (PropertySet.PROPERTIES.indexOf(_prop) == -1) throw new Error("property " + _prop + " is not allowed to be set in statemanager");
				_propertySet.add(_dobj, _prop, _value);
			}
			
		}
		
		
		public function containDobj(_dobj:DisplayObject):Boolean
		{
			return (_listdobj.indexOf(_dobj) != -1);
		}
		
		public function setTransitionDef(_transitionmode:String, _tempo:Number, _timetransform:Number, _effecttransform:Function, _customTransition:CustomTransition):void 
		{
			if (_transitionmode != "") _transitionDef.mode = _transitionmode;
			if (!isNaN(_tempo)) _transitionDef.tempo = _tempo;
			if (!isNaN(_timetransform)) _transitionDef.timetransform = _timetransform;
			if (_effecttransform != null) _transitionDef.effecttransform = _effecttransform;
			if (_customTransition != null) _transitionDef.customTransition = _customTransition;
			
		}
		
		
		
		
		
		
		//_________________________________________________________________
		//set / get
		
		public function get effect():Effect 
		{
			return _effect;
		}
		
		public function set effect(value:Effect):void 
		{
			_effect = value;
		}
		
		public function get effecthide():Effect 
		{
			return _effecthide;
		}
		
		public function set effecthide(value:Effect):void 
		{
			_effecthide = value;
		}
		
		public function get transitionDef():TransitionDef 
		{
			return _transitionDef;
		}
		
		public function get listdobj():Array 
		{
			return _listdobj;
		}
		
		public function get propertySet():PropertySet 
		{
			return _propertySet;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get buttoneffecthide():Effect 
		{
			return _buttoneffecthide;
		}
		
		public function set buttoneffecthide(value:Effect):void 
		{
			_buttoneffecthide = value;
		}
		
		public function get buttoneffect():Effect 
		{
			return _buttoneffect;
		}
		
		public function set buttoneffect(value:Effect):void 
		{
			_buttoneffect = value;
		}
		
		
		
	}

}