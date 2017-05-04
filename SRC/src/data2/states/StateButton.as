package data2.states 
{
	import data2.effects.Effect;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class StateButton 
	{
		private var _name:String;
		private var _dobj:DisplayObject;
		private var _effect:Effect;
		private var _effecthide:Effect;
		private var _auto:Boolean;
		
		
		
		public function StateButton(__name:String, __dobj:DisplayObject, __effect:Effect, __effecthide:Effect, __auto:Boolean) 
		{
			_name = __name;
			_dobj = __dobj;
			_effect = __effect;
			_effecthide = __effecthide;
			_auto = __auto;
		}
		
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get dobj():DisplayObject 
		{
			return _dobj;
		}
		
		public function get effect():Effect 
		{
			return _effect;
		}
		
		public function get effecthide():Effect 
		{
			return _effecthide;
		}
		
		public function get auto():Boolean 
		{
			return _auto;
		}
		
		
	}

}