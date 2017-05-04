package data2.states 
{
	import data2.layoutengine.LayoutSprite;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class PropertySet 
	{
		public static const PROPERTIES:Array = ["x", "y", "alpha", "rotation", "scaleX", "scaleY", "marginLeft", "marginTop", "marginRight", "marginBottom"];
		public static const PROPERTIES_POSITION_LAYOUT:Array = ["marginLeft", "marginTop", "marginRight", "marginBottom"];
		public static const PROPERTIES_POSITION_NORMAL:Array = ["x", "y"];
		
		
		private var _tab:Array;
		public function PropertySet() 
		{
			_tab = new Array();
			
			
		}
		
		public function contains(_dobj:DisplayObject, _prop:String):Boolean
		{
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _tab[i];
				if (_obj.dobj == _dobj && _obj.prop == _prop) return true;
			}
			return false;
		}
		
		public function getValue(_dobj:DisplayObject, _prop:String):*
		{
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _tab[i];
				if (_obj.dobj == _dobj && _obj.prop == _prop) {
					return _obj.value;
				}
			}
			throw new Error("_dobj " + _dobj + " and prop " + _prop + " wasn't found");
		}
		
		
		public function add(_dobj:DisplayObject, _prop:String, _value:*):void
		{
			var _obj:Object = new Object();
			_obj.dobj = _dobj;
			_obj.prop = _prop;
			_obj.value = _value;
			_tab.push(_obj);
		}
		
		
		public function apply(_dobj:DisplayObject):void 
		{
			var _len:int = _tab.length;
			
			for (var i:int = 0; i < _len; i++) {
				var _obj:Object = _tab[i];
				if (_obj.dobj == _dobj) {
					//if (_obj.prop == "y" || _obj.prop=="marginTop") trace(" ------ PropertySet.apply ." + _obj.prop + " = " + _obj.value);
					
					var _value:* = _obj.value;
					if(_value != null) _dobj[_obj.prop] = _value;
				}
			}
		}
		
		
		
		static public function acceptProperties(_dobj:DisplayObject, _prop:String):Boolean
		{
			//si obj n'est pas LayoutSprite et que property est PositionLayoutProp, pas bon
			if ((!(_dobj is LayoutSprite)/* || !LayoutSprite(_dobj).enabled*/) && PROPERTIES_POSITION_LAYOUT.indexOf(_prop) != -1) return false;
			//si obj est LayoutSprite et que property est PositionNormalProp, pas bon
			else if (_dobj is LayoutSprite && LayoutSprite(_dobj).enabled && PROPERTIES_POSITION_NORMAL.indexOf(_prop) != -1) return false;
			return true;
			
		}
		
	}

}