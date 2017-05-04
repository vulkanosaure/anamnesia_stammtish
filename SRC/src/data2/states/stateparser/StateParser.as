package data2.states.stateparser 
{
	import data.javascript.SWFAddress;
	import data2.asxml.ASXML;
	import data2.asxml.ClassManager;
	import data2.asxml.Constantes;
	import data2.asxml.DynamicStateDef;
	import data2.asxml.ObjectSearch;
	import data2.behaviours.menu.Menu;
	import data2.effects.Effect;
	import data2.effects.FadeEffect;
	import data2.InterfaceSprite;
	import data2.net.URLLoaderManager;
	import data2.states.CustomTransition;
	import data2.states.navigation.Navigation;
	import data2.states.navigation.NavigationEvent;
	import data2.states.StateEngine;
	import data2.states.StateEvent;
	import data2.states.StateManager;
	import data2.states.StateUtils;
	import data2.parser.StyleSheet2;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	/**
	 * ...
	 * @author 
	 */
	public class StateParser 
	{
		public static const BASE_CONTAINER:String = "base";
		
		
		private static const ATTRIBUTES:Array = ["container", "swfaddress", "default", "default_out", "dynamiclist", "htmltitle"];
		private static const ATTRIBUTES_DYNVALUES:Array = ["htmltitle"];
		private static const DYNAMIC_VALUES_PREFIX:Array = ["flashvars", "constante"];
		
		public static const ROOT_NODE:String = "root";
		
		private static const BALISE_DOBJ:String = "dobj";
		private static const BALISE_PROPERTIES:String = "properties";
		private static const BALISE_PROP:String = "prop";
		private static const BALISE_EFFECT_DEF:String = "effect_def";
		private static const BALISE_EFFECT:String = "effect";
		private static const BALISE_EFFECT_HIDE:String = "effecthide";
		private static const BALISE_CUSTOM_TRANSITION:String = "custom_transition";
		private static const BALISE_TIME_TRANSFORM:String = "timetransform";
		private static const BALISE_EFFECT_TRANSFORM:String = "effecttransform";
		private static const BALISE_TEMPO:String = "tempo";
		private static const BALISE_TRANSITIONMODE:String = "transitionmode";
		
		
		
		
		private static var _baseContainer:Sprite;
		private static var _stage:Stage;
		private static var _rootEffectDef:Object;
		private static var _childEffectDefs:Array;
		private static var _debug:Boolean;
		private static var _rootnodes:Array;
		private static var _belongtorootNodes:Array;
		
		
		
		
		
		public function StateParser() 
		{
			
		}
		
		
		
		public static function reset():void
		{
			Navigation.reset();
			StateEngine.reset();
		}
		
		
		public static function init(__stage:Stage, __baseContainer:DisplayObjectContainer, _xmlList:XMLList, _effectsSheetStr:String):void
		{
			StateEngine.init(__baseContainer);
			_stage = __stage;
			
			var _effectsSheet:StyleSheet2 = new StyleSheet2();
			_effectsSheet.parseCSS(_effectsSheetStr);
			
			EffectParser.stage = _stage;
			EffectParser.initEffects(_effectsSheet);
			
			_childEffectDefs = new Array();
			_rootnodes = new Array();
			_belongtorootNodes = new Array();
			_baseContainer = Sprite(__baseContainer);	//navigation use Sprite instead of DisplayObjectContainer, maybe change later
			scan_recursive(_xmlList, "", null, null, "", "", null, false, 0);
			
			if (_rootEffectDef == null) throw new Error("you must set a <effect_def> for root");
			setEffect(_rootEffectDef, "", "");
			
			var _nbchildeffect:int = _childEffectDefs.length;
			for (var i:int = 0; i < _nbchildeffect; i++) 
			{
				var _childEffect:Object = _childEffectDefs[i];
				setEffect(_childEffect.effectDef, _childEffect.idsm, _childEffect.idstate);
			}
			
			trace("___________________________________________ END STATE PARSER (setEffect)");
			
			//Navigation.addEventListener(NavigationEvent.AFTER_ADDRESS_CHANGE, onAfterAddressChange);
			
			EffectParser.initAssociations(_effectsSheet);
			
			StateEngine.addEventListener(StateEvent.GOTO, onStateEngineGoto);
			Navigation.init();
			
			
		}
		
		
		
		public static function goto_(_stateparent:String, _state:String):void
		{
			var _berror:Boolean = false;
			if (!StateEngine.stateManagerExists(_stateparent)) _berror = true;
			if (!_berror) {
				if (!StateEngine.stateExists(_stateparent, _state)) _berror = true;
			}
			
			if (_berror) throw new Error("state " + _stateparent + "." + _state + " doesn't exist");
			
			
			//todo : need to know if couple _stateparent / _state belong to "root" node or not
			var _isInRoot:Boolean = (_belongtorootNodes.indexOf(_stateparent) != -1);
			
			if(_isInRoot){
				Navigation.goto_(_stateparent, _state);
			}
			else {
				StateEngine.goto_(_stateparent, _state, true);
			}
		}
		
		
		
		
		public static function addMenuAssociation(_menu:Menu, _index:int, _stateparent:String, _state:String):void
		{
			Navigation.addMenuAssociation(_menu, _index, _stateparent, _state);
		}
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		//private functions
		
		private static function scan_recursive(_xmllist:Object, _baliseparent:String, _attributesparent:Object, _containerParent:DisplayObjectContainer, _idstateparent:String, _idstate:String, _effectDef:Object, _belongRoot:Boolean, _level:int=0):void
		{
			var _balisename:String = _xmllist.name();
			if (_balisename == null) return;
			
			//tracelvl("SR " + _idstate + ", " + _balisename, _level);
			
			
			//attributes extraction
			
			var _attributes:Object = new Object();
			var _attributesxmllist:XMLList = _xmllist.attributes();
			for (var _key in _attributesxmllist) {
				var _att:String = _attributesxmllist[_key].name();
				_attributes[_att] = _attributesxmllist[_key];
			}
			
			
			//dynamic values
			for (var _key:String in _attributes) {
				if (ATTRIBUTES.indexOf(_key) == -1) throw new Error("attribute \"" + _key + "\" doesn't exist");
				if (ATTRIBUTES_DYNVALUES.indexOf(_key) != -1) {
					
					var _tab:Array;
					var _nbmatch:int;
					var _datakey:String;
					var _value:String;
					var _dynamicvalue:Object;
					
					
					do{
						
						_value = _attributes[_key];
						if (_value == null) break;
						
						_tab = _value.match(/{([\w\d:\/\.\*\#\-@]+?)}/g);
						_dynamicvalue;
						var _sessionKey:String = "";
						
						_nbmatch = _tab.length;
						
						for (var i:int = 0; i < _nbmatch; i++) {
							
							
							var _str:String = _tab[i];
							var _isSession:Boolean = false;
							
							var _objdynvalues:Object = ASXML.getDynamicValueComponent(_str, "xmlnode");
							_datakey = _objdynvalues.datakey;
							var _prefix:String = _objdynvalues.prefix;
							var _subdatakey:String = _objdynvalues.subdatakey;
							
							
							//flashvars
							if(_prefix=="flashvars"){
								_dynamicvalue = ObjectSearch.flashvars(_subdatakey);
							}
							//constantes
							else if (_prefix == "constante") {
								_dynamicvalue = Constantes.get(_subdatakey);
							}
							else throw new Error("StateParser : prefix " + _prefix + " doesn't exist for dynamic definitions \n" + DYNAMIC_VALUES_PREFIX);
							
							if (_dynamicvalue is String) {
								_value = _value.replace("{" + _datakey + "}", _dynamicvalue);
								_attributes[_key] = _value;
							}
							else {
								_attributes[_key] = _dynamicvalue;
							}
						}
					}
					while (_nbmatch > 0);
					
				}
			}
			if (_key == "swfaddress" && _balisename != ROOT_NODE) throw new Error("attribute \"" + _key + "\" is only allowed for <root> node");
			
			
			
			if (_balisename == "states") {
				//do nothing
			}
			
			
			//effect definitions
			
			else if (_balisename == BALISE_EFFECT_DEF) {
				_effectDef = new Object();
			}
			else if (_balisename == BALISE_EFFECT) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_EFFECT + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["effect"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_CUSTOM_TRANSITION) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_CUSTOM_TRANSITION + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["custom_transition"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_EFFECT_HIDE) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_EFFECT_HIDE + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["effecthide"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_TEMPO) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_TEMPO + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["tempo"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_TRANSITIONMODE) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_TRANSITIONMODE + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["transitionmode"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_TIME_TRANSFORM) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_TIME_TRANSFORM + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["timetransform"] = _xmllist.toString();
			}
			else if (_balisename == BALISE_EFFECT_TRANSFORM) {
				if (_baliseparent != BALISE_EFFECT_DEF) throw new Error("balise <" + BALISE_EFFECT_TRANSFORM + "> must be in <" + BALISE_EFFECT_DEF + ">");
				_effectDef["effecttransform"] = _xmllist.toString();
			}
			
			
			//dobj component
			
			else if (_balisename == BALISE_DOBJ) {
				
				var _contentdobj:String = _xmllist.toString();
				var _listdobj:Array = _contentdobj.split(" ");
				var _nbdobj:int = _listdobj.length;
				for (var i:int = 0; i < _nbdobj; i++) {
					StateEngine.addStateComponent(_idstateparent, _idstate, _listdobj[i]);
				}
				
				
			}
			
			
			//transprop
			
			else if (_balisename == BALISE_PROPERTIES) {
				
			}
			else if (_balisename == BALISE_PROP) {
				
				if (_baliseparent != BALISE_PROPERTIES) throw new Error("balise <" + BALISE_PROP + "> must be in <" + BALISE_PROPERTIES + ">");
				
				var _propstr:String = _xmllist.toString();
				//var _tabmatch:Array = _propstr.match(/^(([\.\#\*]{1}\w+)?(\[(-?\d+)\])?\.)?(\w+)=([\w\.]+)$/);
				var _tabmatch:Array = _propstr.match(/^(([\.\#\*]{1}\w+)?(\[(-?\d+)\])?\.)?(\w+)=(.+)$/);
				trace("_tabmatch " + _propstr);
				
				if (_tabmatch != null) {
					var _dobjdef:String = _tabmatch[2];		//null if not defined
					var _index:int = int(_tabmatch[4]);		//converted to 0 if not defined, voir si ça passe de mettre 0 qd pas d'index defini
					var _prop:String = _tabmatch[5];
					var _value:* = _tabmatch[6];
					trace("_dobjdef : " + _dobjdef + ", _index : " + _index + ", _prop : " + _prop + ", _value : " + _value);
					//todo : StateEngine ne gère pas les index négatif, a modifier si on veut les prendre a compte
					
					if (_dobjdef == null) {
						StateEngine.setSelectedProperty(_idstateparent, _prop, _value);
					}
					else {
						StateEngine.setStateComponentProperty(_idstateparent, _idstate, _dobjdef, _index, _prop, _value);
					}
					
				}
				else throw new Error("wrong format for <prop> " + _propstr + " in state <" + _idstate + ">");
				
			}
			
			//statename
			else {
				
				_idstateparent = _idstate;
				_idstate = _balisename;
				
				
				var _htmltitle:String = (_attributes["htmltitle"] == undefined) ? "" : _attributes["htmltitle"];
				
				
				
				if (_idstateparent == "") {
					
					StateEngine.addStateManager(_balisename, StateEngine.VALUE_BASE_CONTAINER);
					_containerParent = _baseContainer;
					_rootnodes.push(_idstate);
					
					if (_balisename == ROOT_NODE) {
						_belongRoot = true;
						Navigation.setRoot(ROOT_NODE, _htmltitle, Sprite(_baseContainer));
						var _swfaddress:Boolean = (_attributes["swfaddress"] == "false") ? false : true;
						if(!_swfaddress) SWFAddress.availability = _swfaddress;
					}
					else _belongRoot = false;
					
				}
				
				else {
					
					if (!StateEngine.stateManagerExists(_idstateparent)) throw new Error("property \"container\" of state parent \"" + _idstateparent + "\" is not defined for state \"" + _idstate + "\"");
					
					
					var _default:Boolean = (_attributesparent["default"] == _balisename);
					var _swfaddress:Boolean = true;
					//trace("_attributes['swfaddress'] : " + _attributes["swfaddress"] + ", balisename : " + _balisename);
					
					//rubric
					if (_attributes["default"] == undefined && _attributes["dynamiclist"] == undefined && _attributes["container"] == undefined) {
						
						Navigation.addRub(_idstate, 0, _idstateparent, _htmltitle, _default, _swfaddress);
						StateEngine.addState(_idstateparent, _idstate);
						
					}
					
					//rubric container
					else {
						/*
						if (_attributes["default"] == undefined && _attributes["dynamiclist"] != "true") throw new Error("StateParser : you must set 'default' attribute for state container " + _balisename);
						*/
						
						var _argContainer:*;
						var _container:DisplayObjectContainer;
						if (_attributes["container"] == undefined) {
							_container = _containerParent;
							_argContainer = _container;
						}
						else{
							var _listdobj:Array = StateUtils.getListByDobjdef(_containerParent, _attributes["container"]);
							if (_listdobj.length == 0) throw new Error("StateParser : " + _attributes["container"] + " wasn't found for <" + _balisename + ">");
							if (_listdobj.length > 1) throw new Error("StateParser : more than 1 " + _attributes["container"] + " was found for <" + _balisename + ">");
							_container = DisplayObjectContainer(_listdobj[0]);
							_argContainer = _attributes["container"];
						}
						
						var _dynamiclist:Boolean = (_attributes["dynamiclist"] == "true");
						
						Navigation.addRubContainer(_idstate, 0, Sprite(_container), _idstateparent, _htmltitle, _default, _swfaddress);
						StateEngine.addStateManager(_idstate, _argContainer);
						StateEngine.addState(_idstateparent, _idstate);
						
						
						//en cours
						trace("_dynamiclist : " + _dynamiclist + ", _balisename : " + _balisename + ", _baliseparent : " + _baliseparent);
						if (_dynamiclist) {
							
							var _hasDynamicStateDef:Boolean = false;
							var _dynamicStateDefs:Array;
							if (_container is InterfaceSprite) {
								_dynamicStateDefs = InterfaceSprite(_container).getDynamicStateDefs();
								if (_dynamicStateDefs.length > 0) _hasDynamicStateDef = true;
							}
							//trace("_dynamiclist, _hasDynamicStateDef : " + _hasDynamicStateDef+", _dynamicStateDefs.length : "+_dynamicStateDefs.length);
							
							if(!_hasDynamicStateDef){
								var _numchildren:int = _container.numChildren;
								for (var i:int = 0; i < _numchildren; i++) 
								{
									var _child:DisplayObject = _container.getChildAt(i);
									//trace(" - " + _child);
									
									var _id:String = _idstate + "_" + i;
									Navigation.addRub(_id, i, _idstate, "", (i == 0));
									
									//trace("create state " + _idstate + ", " + _id);
									
									StateEngine.addState(_idstate, _id);
									StateEngine.addStateComponentDobj(_idstate, _id, _child);
								}
							}
							else {
								var _numchildren:int = _dynamicStateDefs.length;
								
								for (var i:int = 0; i < _numchildren; i++) 
								{
									var _dsd:DynamicStateDef = DynamicStateDef(_dynamicStateDefs[i]);
									//trace(" - " + _child);
									
									var _id:String = _idstate + "_" + i;
									Navigation.addRub(_id, i, _idstate, _dsd.htmltitle, (i == 0));
									
									trace("create state " + _idstate + ", " + _id);
									
									StateEngine.addState(_idstate, _id);
									
								}
							}
						}
						
						_containerParent = _container;
					}
					
				}
				
				if(_belongRoot) _belongtorootNodes.push(_idstate);
				
			}
			
			
			
			
			var _children:XMLList = _xmllist.children();
			for each(var _xml:XML in _children)
			{
				scan_recursive(_xml, _balisename, _attributes, _containerParent, _idstateparent, _idstate, _effectDef, _belongRoot, _level + 1);
			}
			
			
			
			//error handling
			
			if (_attributes["default"] != undefined) {
				if (!StateEngine.stateExists(_idstate, _attributes["default"])) throw new Error("default state \"" + _attributes["default"] + "\" not found for state \"" + _balisename + "\"");
			}
			if (_attributes["default_out"] != undefined) {
				if (!StateEngine.stateExists(_idstate, _attributes["default_out"])) throw new Error("default_out state \"" + _attributes["default_out"] + "\" not found for state \"" + _balisename + "\"");
			}
			
			
			//effect definition
			//trace("test effectdef : " + _balisename + ", " + _effectDef);
			if (_balisename == BALISE_EFFECT_DEF) {
				
				tracelvl("_effectDef : " + _effectDef + ", " + _idstate + ", " + _idstateparent, _level);
				/*
				if (_idstateparent != "") {
					
					_childEffectDefs.push( { "effectDef":_effectDef, "idsm" : _idstateparent, "idstate":_idstate });
					_childEffectDefs.push( { "effectDef":_effectDef, "idsm" : _idstate, "idstate":"" });
					
				}
				else {
					_rootEffectDef = _effectDef;
				}
				*/
				if (_idstate == "root") {
					_rootEffectDef = _effectDef;
				}
				else {
					if (_idstateparent != "") _childEffectDefs.push( { "effectDef":_effectDef, "idsm" : _idstateparent, "idstate":_idstate });
					_childEffectDefs.push( { "effectDef":_effectDef, "idsm" : _idstate, "idstate":"" });
				}
			}
			
		}
		
		
		
		
		
		private static function setEffect(_effectDef:Object, _idstatemanager:String, _idstate:String):void
		{
			var _effect:Effect = (_effectDef["effect"] == undefined) ? null : EffectParser.getEffect(_effectDef["effect"]);
			var _effecthide:Effect = (_effectDef["effecthide"] == undefined) ? null : EffectParser.getEffect(_effectDef["effecthide"]);
			var _tempo:Number = (_effectDef["tempo"] == undefined) ? NaN : Number(_effectDef["tempo"]);
			var _transitionmode:String = (_effectDef["transitionmode"] == undefined) ? "" : String(_effectDef["transitionmode"]);
			var _timetransform:Number = (_effectDef["timetransform"] == undefined) ? NaN : Number(_effectDef["timetransform"]);
			var _effecttransform:Function = (_effectDef["effecttransform"] == undefined) ? null : EffectParser.getEffectByString(_effectDef["effecttransform"]);
			
			
			var _customTransition:CustomTransition;
			if (_effectDef["custom_transition"] == undefined) _customTransition = null;
			else {
				var _customTransitionClass:Class = ClassManager.getClassByName(_effectDef["custom_transition"]);
				if (_customTransitionClass == null) throw new Error("CustomTransition class \"" + _effectDef["custom_transition"] + "\" is not registered");
				_customTransition = CustomTransition(new _customTransitionClass());
				_customTransition._stage = _stage;
			}
			
			//tocheck
			//todo : dobj specification
			
			//trace("SP.setEffect(" + _idstatemanager + ", " + _idstate + ")");
			StateEngine.setEffect(_idstatemanager, _idstate, "", _effect, _effecthide, _transitionmode, _tempo, _timetransform, _effecttransform, _customTransition);
			
		}
		
		
		
		
		private static function tracelvl(_msg:String, _lvl:int):void
		{
			var _space:String = "";
			for (var i:int = 0; i < _lvl; i++) _space += "   ";
			trace(_space + _msg);
		}
		
		
		
		static public function set debug(value:Boolean):void 
		{
			_debug = value;
			
		}
		
		
		
		
		
		
		
		
		//______________________________________________________________________________________________
		//events
		
		
		/*
		static private function onAfterAddressChange(e:NavigationEvent):void 
		{
			if (_debug) {
				
				ContextMenuHandler.initMenu(_rootnodes);
				var _contextMenu:ContextMenu = ContextMenuHandler.getMenu();
				_baseContainer.contextMenu = _contextMenu;
				
			}
		}
		*/
		static private function onStateEngineGoto(e:StateEvent):void 
		{
			if (_debug) {	
				ContextMenuHandler.initMenu(_rootnodes);
				var _contextMenu:ContextMenu = ContextMenuHandler.getMenu();
				_baseContainer.contextMenu = _contextMenu;
				
			}
		}
		
		
		
		
		
		
	}

}