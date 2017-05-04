package data2.states 
{
	import data2.layoutengine.LayoutEngine;
	import data2.display.ClickableSprite;
	import data2.effects.Effect;
	import data2.effects.MEffect;
	import data2.layoutengine.LayoutSprite;
	import data2.states.stateparser.StateParser;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author 
	 */
	public class StateEngine 
	{
		public static const VALUE_BASE_CONTAINER:String = "BASE_CONTAINER";
		
		private static var _baseContainer:DisplayObjectContainer;
		private static var _statemanagers:Object;
		private static var _animsm:Array;
		
		public static var _effect:*;
		public static var _effecthide:*;
		
		private static var _buttons:Array;
		private static var _evtDispatcher:EventDispatcher;
		
		
		
		
		public function StateEngine() 
		{
			throw new Error("StateEngine is static");
			
		}
		
		
		
		static public function reset():void 
		{
			_statemanagers = new Object();
			_animsm = new Array();
			_buttons = new Array();
		}
		
		static public function init(__baseContainer:DisplayObjectContainer):void 
		{
			_statemanagers = new Object();
			_animsm = new Array();
			_baseContainer = __baseContainer;
			
		}
		
		
		static public function goto_(_idstatemanager:String, _idstate:String, _sync:Boolean=true):void
		{
			if (_statemanagers[_idstatemanager] == null) throw new Error("statemanager id \"" + _idstatemanager + "\" doesn't exist");
			var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
			if (!_sm.stateExists(_idstate)) throw new Error("state \"" + _idstate + "\" wasn't found in statemanager \"" + _idstatemanager + "\"");
			
			var _prevstate:String = getState(_idstatemanager);
			trace("StateEngine.goto(" + _idstatemanager + ", " + _idstate + ", " + _sync + ")");
			
			
			//trace("StateEngine.goto(" + _idstatemanager + ", " + _idstate + ")");
			
			if(!_sm.dynamiclist){
				if(_sync){
					stopAllEffect();
					syncDobjAll(_idstatemanager, _idstate);
					LayoutEngine.update();
				}
				
				if (_sm.idstate != _idstate) {
					_sm.goto_(_idstate);
					
					var _evt:StateEvent = new StateEvent(StateEvent.GOTO);
					_evt.idstatemanager = _idstatemanager;
					_evt.idstate = _idstate;
					_evt.prevstate = _prevstate;
					dispatchEvent(_evt);
				}
			}
			else {
				_sm.gotoDyn(_idstate);
			}
			
		}
		
		
		
		
		
		static public function sync(_idstatemanager:String, _idstate:String):void
		{
			stopAllEffect();
			syncDobjAll(_idstatemanager, _idstate);
			LayoutEngine.update();
		}
		
		
		
		static public function addState(_idstatemanager:String, _idstate:String):void
		{
			StateManager(_statemanagers[_idstatemanager]).addState(_idstate);
		}
		
		static public function addStateComponent(_idstatemanager:String, _idstate:String, _dobjdef:String):void
		{
			StateManager(_statemanagers[_idstatemanager]).addStateComponent(_idstate, _dobjdef);
		}
		
		static public function addStateComponentDobj(_idstatemanager:String, _idstate:String, _dobj:DisplayObject):void
		{
			StateManager(_statemanagers[_idstatemanager]).addStateComponentDobj(_idstate, _dobj);
		}
		
		static public function setStateComponentProperty(_idstatemanager:String, _idstate:String, _dobjdef:String, _index:int, _prop:String, _value:*):void
		{
			StateManager(_statemanagers[_idstatemanager]).setStateComponentProperty(_idstate, _dobjdef, _index, _prop, _value);
		}
		
		static public function setSelectedProperty(_idstatemanager:String, _prop:String, _value:*):void
		{
			StateManager(_statemanagers[_idstatemanager]).setSelectedProperty(_prop, _value);
		}
		
		
		
		static public function addButtonState(_idstatemanager:String, _idstate:String, _itemroll:String, _effectover:Effect, _effectout:Effect, _auto:Boolean):void
		{
			var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
			if (_sm == null) throw new Error("statemanager \"" + _idstatemanager + "\" doesn't exist");
			_sm.setButtonEffect(_idstate, _itemroll, _effectover, _effectout);
			
		}
		
		
		
		static public function addButtonMenu(_dobjdef:String, _effectover:Effect, _effectout:Effect, _rolleffect:Effect, _rolleffectout:Effect):void
		{
			addButton(_dobjdef, _effectover, _effectout, false, "");
			
		}
		
		
		static public function addAnimSM(_dobjdef:String, _tempo:Number):void
		{
			var _type:String = StateUtils.getDisplayObjectDefType(_dobjdef);
			var _value:String = StateUtils.getDisplayObjectDefValue(_dobjdef);
			var _listdobj:Array = StateUtils.getDisplayObjectList(_baseContainer, _value, _type);
			//trace("_listdobj : " + _listdobj);
			
			if (_listdobj.length == 0) throw new Error("statemanager animSM : container of def " + _dobjdef + " have not been found in container " + _baseContainer);
			
			var _len:int = _listdobj.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (!(_listdobj[i] is DisplayObjectContainer)) throw new Error("animSM with container " + _dobjdef + " must be a DisplayObjectContainer");
				var _container:DisplayObjectContainer = DisplayObjectContainer(_listdobj[i]);
				var _sm:StateManager = new StateManager(_dobjdef, _container, false);
				_sm.transitionDef.tempo = _tempo;
				_animsm.push(_sm);
				
			}
			
		}
		
		
		static public function getAnimSM(_container:DisplayObject):StateManager
		{
			var _len:int = _animsm.length;
			for (var i:int = 0; i < _len; i++)
			{
				var _sm:StateManager = StateManager(_animsm[i]);
				if (_sm.container == _container) return _sm;
			}
			return null;
		}
		
		
		
		static public function setAnimEffect(_smdobjdef:String, _subdobjdef:String, __effect:*, __effecthide:*):void
		{
			var _len:int = _animsm.length;
			for (var i:int = 0; i < _len; i++)
			{
				var _sm:StateManager = StateManager(_animsm[i]);
				if (_sm.id == _smdobjdef) {
					//trace("set sm " + _sm);
					_sm.setEffect("", _subdobjdef, __effect, __effecthide, "", NaN, NaN, null, null);
				}
				
			}
		}
		
		
		
		
		static public function addButton(_dobjdef:String, _effectover:Effect, _effectout:Effect, _auto:Boolean, _itemroll:String=""):void
		{
			//trace("StateEngine.addButton(" + _dobjdef + ", " + _effectover + ", " + _auto + ") ----------");
			
			
			if (_buttons == null) _buttons = new Array();
			if (_buttons.indexOf(_dobjdef) != -1) throw new Error("button with def \"" + _dobjdef + "\" allready exists");
			
			_buttons.push(_dobjdef);
			
			var _type:String = StateUtils.getDisplayObjectDefType(_dobjdef);
			var _value:String = StateUtils.getDisplayObjectDefValue(_dobjdef);
			
			var _list:Array = StateUtils.getDisplayObjectList(_baseContainer, _value, _type);
			var _len:int = _list.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobj:DisplayObjectContainer = DisplayObjectContainer(_list[i]);
				
				var _sm:StateManager = new StateManager(_dobjdef, _dobj, true);
				_sm.setEffect("", "", _effectover, _effectout, "", NaN, NaN, null, null);
				_statemanagers[_dobjdef + "_" + i] = _sm;
				
				//_sm.idstate = "buttonstate";
				if (_effectover.isSubtarget()) {
					
					var _buttonstatename:String = "buttonstate";
					_sm.addState(_buttonstatename);
					_sm.idstate = _buttonstatename;
					_sm.addSubchildToState(_buttonstatename);
				}
				
				
				ClickableSprite.updateClickable(_dobj);
				
				if (_auto) {
					var _zoneroll:DisplayObject;
					if (_itemroll == "") _zoneroll = _dobj;
					else {
						var _type:String = StateUtils.getDisplayObjectDefType(_itemroll);
						var _value:String = StateUtils.getDisplayObjectDefValue(_itemroll);
						var _list:Array = StateUtils.getDisplayObjectList(_dobj, _value, _type);
						_zoneroll = DisplayObject(_list[0]);
					}
					
					//trace("_itemroll : " + _itemroll + ", _zoneroll : " + _zoneroll);
					_zoneroll.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverBtn);
					_zoneroll.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutBtn);
				}
				
				//init bouton en out
				buttonOver(_zoneroll, true);
				buttonOut(_zoneroll, true);
				
			}
		}
		
		
		static public function buttonOver(_dobj:DisplayObject, _straight:Boolean=false):void
		{
			//trace("buttonOver(" + _dobj + ")");
			
			var _btn:StateManager = getButton(_dobj);
			//trace("_btn : " + _btn);
			if (_btn == null) return;
			if (_btn.buttonover) return;
			_btn.buttonover = true;
			
			//trace("_btn : " + _btn);
			_btn.syncContainer();
			_btn.syncDobj("buttonstate");
			LayoutEngine.update(_dobj.parent);
			
			var _e:Effect = _btn.effect;
			//trace("_e : " + _e);
			_e.target = _dobj;
			_e.init();
			_e.play(null, false, false, _straight);
			
		}
		
		
		static public function buttonOut(_dobj:DisplayObject, _straight:Boolean=false):void
		{
			//trace("buttonOut(" + _dobj + ")");
			
			var _btn:StateManager = getButton(_dobj);
			if (_btn == null) return;
			//if (!_btn.buttonover) return;
			_btn.buttonover = false;
			
			_btn.syncContainer();
			_btn.syncDobj("buttonstate");
			LayoutEngine.update(_dobj.parent);
			
			var _hideDefined:Boolean = (_btn.effecthide != null);
			
			var _e:Effect = (_hideDefined) ? _btn.effecthide : _btn.effect;
			_e.target = _dobj;
			_e.init();
			if (_hideDefined) _e.play(null, false, false, _straight);
			else _e.rewind(null, false, false, _straight);
		}
		
		static public function getState(_idstatemanager:String):String
		{
			var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
			return _sm.idstate;
		}
		
		static public function getListIdstates(_idstatemanager:String):Array
		{
			var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
			return _sm.getListIdstates();
		}
		
		
		static public function addEventListener(_type:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _handler);
		}
		
		static public function dispatchEvent(_evt:Event):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		
		
		static public function stateExists(_idstatemanager:String, _idstate:String):Boolean 
		{
			var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
			if (_sm == null) throw new Error("StateManager " + _idstatemanager + " doesn't exist");
			return _sm.stateExists(_idstate);
		}
		
		static public function stateManagerExists(_idstatemanager:String):Boolean
		{
			return (_statemanagers[_idstatemanager] != undefined);
		}
		
		
		static public function registerPropertySet():void 
		{
			for (var i in _statemanagers)
			{
				var _sm:StateManager = StateManager(_statemanagers[i]);
				_sm.registerPropertySet();
			}
			
			var _nbanimsm:int = _animsm.length;
			for (var j:int = 0; j < _nbanimsm; j++) 
			{
				var _sm:StateManager = StateManager(_animsm[j]);
				_sm.registerPropertySet();
			}
		}
		
		static public function addStateManager(_id:String, _dobjdef:*):void
		{
			var _container:DisplayObjectContainer;
			if (_statemanagers[_id] != null) throw new Error("state id " + _id + " allready exist");
			
			if (_dobjdef == VALUE_BASE_CONTAINER) {
				_container = _baseContainer;
				
			}
			else if (_dobjdef is DisplayObjectContainer) {
				_container = DisplayObjectContainer(_dobjdef);
			}
			else {
				var _type:String = StateUtils.getDisplayObjectDefType(_dobjdef);
				var _value:String = StateUtils.getDisplayObjectDefValue(_dobjdef);
				var _listdobj:Array = StateUtils.getDisplayObjectList(_baseContainer, _value, _type);
				//var _listdobj:Array = StateUtils.getDisplayObjectByClass(_baseContainer, _classname);
				
				if (_listdobj.length == 0) throw new Error("statemanager "+_id+" : container of def " + _dobjdef + " have not been found in container " + _baseContainer);
				if (_listdobj.length > 1) throw new Error("statemanager " + _id + " : more than 1 DisplayObject have been found for def " + _dobjdef);
				if (!(_listdobj[0] is DisplayObjectContainer)) throw new Error("statemanager " + _id + " : container " + _dobjdef + " must be a DisplayObjectContainer");
				_container = DisplayObjectContainer(_listdobj[0]);
			}
			
			_statemanagers[_id] = new StateManager(_id, _container, false);
		}
		
		
		
		
		
		
		
		
		
		//_____________________________________________________________________________
		//private functions
		
		
		static private function stopAllEffect():void
		{
			for (var i:* in _statemanagers) {
				var _sm:StateManager = StateManager(_statemanagers[i]);
				if(!_sm.buttonmode) _sm.stopAllEffect();
			}
			
			var _len:int = _animsm.length;
			for (var j:int = 0; j < _len; j++) 
			{
				var _sm:StateManager = StateManager(_animsm[j]);
				_sm.stopAllEffect();
			}
			
		}
		
		
		static private function syncDobjAll(_idstatemanager:String, _idstate:String):void 
		{
			//trace("StateEngine.syncDobjAll(" + _idstatemanager + ", " + _idstate + ")");
			
			for (var i in _statemanagers)
			{
				var _sm:StateManager = StateManager(_statemanagers[i]);
				if (!_sm.buttonmode) {
					
					if (_sm.id == _idstatemanager) _sm.syncDobjAll(_idstate);
					else _sm.syncDobjAll("");
				}
			}
			
			var _len:int = _animsm.length;
			for (var j:int = 0; j < _len; j++) 
			{
				var _sm:StateManager = StateManager(_animsm[j]);
				_sm.syncDobj("");
				//_sm.syncContainer();
			}
			
		}
		
		
		
		
		static private function getButton(_dobj:DisplayObject):StateManager
		{
			for (var i in _statemanagers) {
				var _sm:StateManager = StateManager(_statemanagers[i]);
				if (_sm.buttonmode) {
					if (_sm.container == _dobj) {
						return _sm;
					}
				}
			}
			return null;
			throw new Error("button with dobj " + _dobj + " wasn't found");
		}
		
		
		
		
		
		//_____________________________________________________________________________
		//effects
		
		
		
		
		public static function setEffect(_idstatemanager:String, _idstate:String, _dobjdef:String, __effect:*, __effecthide:*, _transitionmode:String="", _tempo:Number=NaN, _timetransform:Number=NaN, _effecttransform:Function=null, _customTransition:CustomTransition=null):void
		{
			//les 3 1er args peuvent etre "" independemment (toutes les combinaisons sont aurorisées)
			//_dobjdef commence par . * ou # selon qu'il cible une class, un name ou un id
			
			
			if (_idstatemanager == "") {
				for (var k in _statemanagers)
				{
					var _sm:StateManager = StateManager(_statemanagers[k]);
					_sm.setEffect(_idstate, _dobjdef, __effect, __effecthide, _transitionmode, _tempo, _timetransform, _effecttransform, _customTransition);
				}
			}
			else {
				var _sm:StateManager = StateManager(_statemanagers[_idstatemanager]);
				_sm.setEffect(_idstate, _dobjdef, __effect, __effecthide, _transitionmode, _tempo, _timetransform, _effecttransform, _customTransition);
			}
			
			
			
		}
		
		
		
		
		
		
		
		
		
		//_____________________________________________________________________________
		//events
		
		static private function onMouseOverBtn(e:MouseEvent):void 
		{
			//trace("onMouseOverBtn "+e.currentTarget+", "+e.target);
			buttonOver(DisplayObject(e.currentTarget));
			
		}
		
		static private function onMouseOutBtn(e:MouseEvent):void 
		{
			//trace("onMouseOutBtn");
			buttonOut(DisplayObject(e.currentTarget));
		}
		
		
	}

}