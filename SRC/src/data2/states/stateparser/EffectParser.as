package data2.states.stateparser 
{
	import data2.asxml.ClassManager;
	import data2.asxml.ObjectSearch;
	import data2.effects.Effect;
	import data2.effects.MEffect;
	import data2.states.StateEngine;
	import data2.parser.StyleSheet2;
	import fl.transitions.easing.Back;
	import fl.transitions.easing.Elastic;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Regular;
	import flash.display.Stage;
	/**
	 * ...
	 * @author 
	 */
	public class EffectParser 
	{
		private static const TYPE_EFFECT:String = "typeEffect";
		private static const TYPE_ASSOCIATION:String = "typeAssociation";
		
		private static const ASSOC_PROPERTIES:Array = ["effectover", "effectout", "rolleffect", "rolleffectout", "auto", "itemroll", "type"];
		
		private static var _stage:Stage;
		private static var _effects:Object;
		
		private static var _functions:Object = { 	"easenone" :  None.easeNone,
													"regular.in" :  Regular.easeIn,
													"regular.out" :  Regular.easeOut,
													"regular.inout" :  Regular.easeInOut,
													"back.in" :  Back.easeIn,
													"back.out" :  Back.easeOut,
													"back.inout" :  Back.easeInOut,
													"elastic.in" :  Elastic.easeIn,
													"elastic.out" :  Elastic.easeOut,
													"elastic.inout" :  Elastic.easeInOut
												};
		
		
		
		
		public function EffectParser() 
		{
			throw new Error("is static");
		}
		
		
		
		public static function initEffects(_styleSheet:StyleSheet2):void
		{
			trace("EffectParser.init(" + _styleSheet + "");
			
			_effects = new Object();
			
			var _listselector:Array = _styleSheet.styleNamesCase;
			var _len:uint = _listselector.length;
			if (_len == 0) trace("WARNING : nothing defined in css effects");
			
			
			//first : definition des Effect
			
			for (var i:int = 0; i < _len; i++) 
			for (var i:int = 0; i < _len; i++) 
			{
				var _selector:String = _listselector[i];
				var _type:String = getType(_selector);
				
				//trace("_selector : " + _selector + ", _type : " + _type);
				if (_type == TYPE_EFFECT) {
					
					//trace("_selector : " + _selector);
					
					var _tab:Array = _selector.split(":");
					if (_tab == null || _tab.length != 2) throw new Error("Effect selector format must be \"occurence:Classname\" (" + _selector + ")");
					
					var _occurence:String = _tab[0];
					var _classname:String = _tab[1];
					var _styledef:Object = _styleSheet.getStyle(_selector);
					
					if (_classname != "MEffect") {
						setEffect(_occurence, _classname, _styledef);
					}
				}
			}
			
			
			
			
			//second : definition des MEffect
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _selector:String = _listselector[i];
				var _type:String = getType(_selector);
				
				//trace("_selector : " + _selector + ", _type : " + _type);
				if (_type == TYPE_EFFECT) {
					
					//trace("_selector : " + _selector);
					
					var _tab:Array = _selector.split(":");
					if (_tab == null || _tab.length != 2) throw new Error("Effect selector format must be \"occurence:Classname\" (" + _selector + ")");
					
					var _occurence:String = _tab[0];
					var _classname:String = _tab[1];
					var _styledef:Object = _styleSheet.getStyle(_selector);
					
					if (_classname == "MEffect") {
						setEffect(_occurence, _classname, _styledef);
					}
				}
			}
			
		}
		
		
		
		static private function setEffect(_occurence:String, _classname:String, _styledef:Object):void 
		{
			
			var _effectClass:Class = ClassManager.getClassByName(_classname, true);
			if (_effectClass == null) throw new Error("Effect class \"" + _classname + "\" is not registered");
			
			var _effect:Effect = new _effectClass();
			_effects[_occurence] = _effect;
			//trace("_occurence : " + _occurence + ", _classname : " + _classname);
			
			
			//prop def
			
			
			if (_classname == "MEffect") {
				if(_styledef["effects"] == undefined) throw new Error("EffectParser : you must set attributes \"effects\" for MEffect \"" + _occurence + "\"");
				
				var _listEffect:Array = String(_styledef["effects"]).split(",");
				var _nbsubeffect:int = _listEffect.length;
				for (var j:int = 0; j < _nbsubeffect; j++) 
				{
					var _eff:Effect = getEffect(_listEffect[j]);
					MEffect(_effect).add(_eff);
				}
				delete _styledef["effects"];
			}
			
			if (_styledef["effect"] != undefined) {
				_styledef["effect"] = getEffectByString(_styledef["effect"]);
			}
			
			
			for (var _prop:String in _styledef) {
				var _value:* = _styledef[_prop];
				//trace(" --- " + _prop + " : " + _value);
				ClassManager.setProperty(_effect, _prop, _value);
			}
		}
		
		
		
		
		
		public static function initAssociations(_styleSheet:StyleSheet2):void
		{
			//trace("EffectParser.initAssociations(" + _styleSheet + "");
			
			
			var _listselector:Array = _styleSheet.styleNamesCase;
			var _len:uint = _listselector.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _selector:String = _listselector[i];
				var _type:String = getType(_selector);
				if (_type == TYPE_ASSOCIATION) {
					
					//trace("_selector : " + _selector);
					
					
					var _styledef:Object = _styleSheet.getStyle(_selector);
					var _initStyleDef:Object = new Object();
					for (var _prop:String in _styledef) {
						//trace("_styledef _prop : " + _prop);
						var _value:* = _styledef[_prop];
						_initStyleDef[_prop] = _value;
						if (ASSOC_PROPERTIES.indexOf(_prop) == -1) throw new Error("EffectParser : prop \"" + _prop + "\" doesn't exist for effect association\n" + ASSOC_PROPERTIES);
						//trace(" --- " + _prop + " : " + _value);
						
					}
					
					
					_styledef["effectover"] = (_styledef["effectover"] == undefined) ? null : getEffect(_styledef["effectover"]);
					_styledef["effectout"] = (_styledef["effectout"] == undefined) ? null : getEffect(_styledef["effectout"]);
					_styledef["rolleffect"] = (_styledef["rolleffect"] == undefined) ? null : getEffect(_styledef["rolleffect"]);
					_styledef["rolleffectout"] = (_styledef["rolleffectout"] == undefined) ? null : getEffect(_styledef["rolleffectout"]);
					
					if (_styledef["auto"] == undefined || _styledef["auto"] == "true") _styledef["auto"] = true;
					else if (_styledef["auto"] == "false") _styledef["auto"] = false;
					else throw new Error("StateParser : wrong value for param \"auto\" (" + _styledef["auto"] + ") possible values are \"true\" or \"false\"");
					
					if (_styledef["itemroll"] == undefined) _styledef["itemroll"] = "";
					
					var _type:String;
					if (_styledef["type"] != undefined) {
						if (_styledef["type"] != "menu" && _styledef["type"] != "button" && _styledef["type"] != "custom") throw new Error("StateParser : wrong value for type (" + _styledef["type"] + "), possible values are \"button\", \"menu\", \"custom\"");
						_type = _styledef["type"];
						delete _styledef["type"];
					}
					else _type = "button";
					
					
					
					if (_type == "menu") {
						StateEngine.addButtonMenu(_selector, _styledef["effectover"], _styledef["effectout"], _styledef["rolleffectover"], _styledef["rolleffectout"]);
						
					}
					else if (_type == "button") {
						StateEngine.addButton(_selector, _styledef["effectover"], _styledef["effectout"], _styledef["auto"], _styledef["itemroll"]);
						
					}
					
					else if (_type == "custom") {
						//list ts les objets concernés
						var _classname:String = _selector.substr(1, _selector.length - 1);
						var _list:Array = ObjectSearch.getObjectByClass(_classname);
						var _len2 = _list.length;
						for (var j:int = 0; j < _len2; j++) 
						{
							var _child:* = _list[j];
							for (var _prop:String in _initStyleDef) 
							{
								if (_prop != "type") {
									_child[_prop] = _styledef[_prop];
								}
							}
						}
					}
					
				}
			}
			
		}
		
		
		
		
		public static function getEffect(_name:String):Effect
		{
			if (_effects[_name] == undefined) throw new Error("Effect \"" + _name + "\" doesn't exist");
			return Effect(_effects[_name]);
		}
		
		
		
		
		static public function getEffectByString(_str:String):Function 
		{
			if (_functions[_str] == undefined) {
				var _strerror:String = "Effect function \"" + _str + "\" doesn't exist\n";
				for (var _key:String in _functions) _strerror += _key + "\n";
				throw new Error(_strerror);
			}
			
			return _functions[_str];
		}
		
		private static function getType(_str:String):String
		{
			var _firstChar:String = _str.charAt(0);
			if (_firstChar == "." || _firstChar == "*" || _firstChar == "#") return TYPE_ASSOCIATION;
			else return TYPE_EFFECT;
			
		}
		
		
		static public function set stage(value:Stage):void {_stage = value;}
		
		
		
	}

}