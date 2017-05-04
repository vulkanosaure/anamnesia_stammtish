package data2.states 
{
	import data2.asxml.DynamicStateDef;
	import data2.asxml.IDynamicStateContainer;
	import data2.behaviours.Behaviour;
	import data2.layoutengine.LayoutEngine;
	import data2.layoutengine.LayoutSprite;
	import data2.layoutengine.MarginObject;
	import data.fx.transitions.TweenManager;
	import data.utils.Delay;
	import data2.asxml.ObjectSearch;
	import data2.display.ClickableSprite;
	import data2.effects.Effect;
	import data2.effects.EffectEvent;
	import data2.InterfaceSprite;
	import data2.states.stateparser.StateParser;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Regular;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class StateManager 
	{
		public static const RESERVED_KEYWORD_STATE:Array = ["show", "hide", "selected"];
		
		private var _id:String;
		private var _container:DisplayObjectContainer;
		private var _states:Object;
		private var _idstate:String;
		private var _idstateprev:String;
		private var _listdobj:Array;
		private var _delays:Array;
		
		private var _effect:Effect;
		private var _effecthide:Effect;
		private var _transitionDef:TransitionDef;
		
		private var _dynamiclist:Boolean;
		private var _dynamicStatesDefs:Array;
		private var _buttonmode:Boolean;
		private var _buttonover:Boolean;
		private var _twm:TweenManager;
		private var _saveprop:Object;
		
		
		
		
		//__________________________________________________________________________________
		//public functions
		
		
		
		public function StateManager(__id:String, __container:DisplayObjectContainer, __buttonmode:Boolean) 
		{
			_id = __id;
			_container = __container;
			
			_buttonmode = __buttonmode;
			_buttonover = false;
			_dynamiclist = false;
			_states = new Object();
			_saveprop = new Object();
			_listdobj = new Array();
			_delays = new Array();
			_transitionDef = new TransitionDef();
			
			_twm = new TweenManager();
			
			
			var _hasDynamicStateDef:Boolean = false;
			var __dynamicStateDefs:Array;
			if (_container is InterfaceSprite) {
				__dynamicStateDefs = InterfaceSprite(_container).getDynamicStateDefs();
				if (__dynamicStateDefs.length > 0) _hasDynamicStateDef = true;
			}
			if (_hasDynamicStateDef) {
				_dynamicStatesDefs = __dynamicStateDefs;
				_dynamiclist = true;
			}
			
			
		}
		
		
		
		
		
		public function addState(__id:String):void
		{
			if (_states[__id] != null) throw new Error("statemanager " + _id + " : state id " + __id + " allready exists");
			if (RESERVED_KEYWORD_STATE.indexOf(__id) != -1) throw new Error("id \"" + __id + "\" is a reserved keyword for states");
			_states[__id] = new State(__id);
			
		}
		
		
		public function addStateComponent(_idstate:String, _dobjdef:String):void
		{
			//trace("SM.addStateComponent( " + _id + " " + _idstate + ", " + _dobjdef + ") _container : " + _container.name);
			
			if (_states[_idstate] == null) throw new Error("statemanager " + _id + " : state id " + _idstate + " doesn't exist");
			
			//var _list:Array = getDisplayObjectList(_name, _type);
			
			var _list:Array = StateUtils.getListByDobjdef(_container, _dobjdef);
			var _len:int = _list.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobj:DisplayObject = DisplayObject(_list[i]);
				State(_states[_idstate]).addComponent(_dobj);
				addDisplayObject(_dobj);
				
			}
		}
		
		public function addStateComponentDobj(_idstate:String, _dobj:DisplayObject):void
		{
			//trace("addStateComponent(" + _idstate + ")");
			if (_states[_idstate] == null) throw new Error("statemanager " + _id + " : state id " + _idstate + " doesn't exist");
			
			State(_states[_idstate]).addComponent(_dobj);
			addDisplayObject(_dobj);
			
		}
		
		
		public function setStateComponentProperty(_idstate:String, _dobjdef:String, _index:int, _prop:String, _value:*):void
		{
			if (_states[_idstate] == null) throw new Error("statemanager " + _id + " : state id " + _idstate + " doesn't exist");
			
			//var _list:Array = getDisplayObjectList(_name, _type);
			var _list:Array = StateUtils.getListByDobjdef(_container, _dobjdef);
			var _len:int = _list.length;
			
			if (_index != -1) {
				if (_index >= _list.length) throw new Error("index " + _index + " is out of bounds (" + _list.length + " items only)");
				var _newlist:Array = new Array();
				_newlist.push(_list[_index]);
				_list = _newlist;
			}
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobj:DisplayObject = DisplayObject(_list[i]);
				State(_states[_idstate]).setComponentProperty(_dobj, _prop, _value);
			}
		}
		
		
		
		public function setSelectedProperty(_prop:String, _value:*):void
		{
			var _numchildren:int = _container.numChildren;
			for (var i:int = 0; i < _numchildren; i++) 
			{
				var _child:DisplayObject = _container.getChildAt(i);
				var _idstate:String = "selected_" + i;
				State(_states[_idstate]).setComponentProperty(_child, _prop, _value);
			}
		}
		
		
		
		
		
		
		
		
		public function gotoDyn(__idstate:String):void 
		{
			trace("TODO StateManager.gotoDyn(" + __idstate + ")");
			_idstate = __idstate;
			
			
			var _tab:Array = __idstate.split("_");
			var _index:int = int(_tab[_tab.length - 1]);
			
			trace("_index : " + _index);
			var _dynStateDef:DynamicStateDef = _dynamicStatesDefs[_index];
			trace("_dynStateDef : " + _dynStateDef);
			
			var _is:InterfaceSprite = InterfaceSprite(_container);
			var _behaviours:Array = _is.getBehaviours();
			var _len:int = _behaviours.length;
			var _behaviour:Behaviour;
			for (var i:int = 0; i < _len; i++) 
			{
				var _b:Behaviour = Behaviour(_behaviours[i]);
				if (_b is IDynamicStateContainer) {
					_behaviour = _b;
					break;
				}
			}
			if (_behaviour == null) throw new Error("InterfaceSprite " + ObjectSearch.formatObject(_container) + " must have a Behaviour that implements IDynamicStateContainer");
			IDynamicStateContainer(_b).goto_(_dynStateDef);
			
		}
		
		
		
		
		
		public function goto_(__idstate:String):void 
		{
			trace("sm " + _id + ".goto(" + __idstate + ")");
			if (_states[__idstate] == null) throw new Error("statemanager " + _id + " : state id " + __idstate + " doesn't exist");
			
			_idstateprev = _idstate;
			_idstate = __idstate;
			
			//trace("sm " + _id + ".goto(" + __idstate + ")");
			//trace("_idstateprev : " + _idstateprev);
			
			var i:int;
			var _stateprev:State = State(_states[_idstateprev]);
			var _nbdobj:int = _listdobj.length;
			
			
			var _state:State = State(_states[_idstate]);
			//doit tout désaficher, sauf les dobj contenus dans states
			
			
			var _dobjshow:Array = new Array();
			var _dobjhide:Array = new Array();
			
			for (i = 0; i < _nbdobj; i++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[i]);
				
				//trace("_dobjinfo : " + _dobjinfo + ", contains : " + _state.containDobj(_dobjinfo.displayObject));
				if (_state.containDobj(_dobjinfo.displayObject)) {
					
					if (!_dobjinfo.display) {
						_dobjshow.push(_dobjinfo);
						_dobjinfo.display = true;
						state_activate(_dobjinfo.displayObject);
					}
				}
				else {
					if (_dobjinfo.display) {
						_dobjhide.push(_dobjinfo);
						_dobjinfo.display = false;
						
					}
					state_deactivate(_dobjinfo.displayObject);
				}
			}
			/*
			trace(" -- _dobjshow : " + _dobjshow);
			trace(" -- _dobjhide : " + _dobjhide);
			*/
			
			
			//TRANSITION DEF
			
			var _tempo_show:Number;
			var _tempo_hide:Number;
			var _timetransform:Number;
			var _effecttransform:Function;
			var _customTransition:CustomTransition;
			var _transitionmode:String;
			
			//tempo
			if (!isNaN(_state.transitionDef.tempo)) _tempo_show = _state.transitionDef.tempo;
			else _tempo_show = _transitionDef.tempo;
			if (_stateprev != null) {
				if (!isNaN(_stateprev.transitionDef.tempo)) _tempo_hide = _stateprev.transitionDef.tempo;
				else _tempo_hide = _transitionDef.tempo;
			}
			//timetransform
			if (!isNaN(_state.transitionDef.timetransform)) _timetransform = _state.transitionDef.timetransform;
			else _timetransform = _transitionDef.timetransform;
			
			//transitionmode
			if (_transitionDef.mode == null) _transitionmode = _state.transitionDef.mode;
			else _transitionmode = _transitionDef.mode;
			if (_transitionmode == null) _transitionmode = "fifo";
			trace("_transitionmode : " + _transitionmode);
			
			//customtransition
			if (_state.transitionDef.customTransition != null) {
				trace("get from state");
				_customTransition = _state.transitionDef.customTransition;
			}
			else {
				trace("get from sm");
				_customTransition = _transitionDef.customTransition;
			}
			
			//effecttransform
			if (_state.transitionDef.effecttransform!=null) _effecttransform = _state.transitionDef.effecttransform;
			else _effecttransform = _transitionDef.effecttransform;
			
			
			/*
			trace("_timetransform : " + _timetransform + ", _effecttransform : " + _effecttransform);
			trace("_state.transitionDef.timetransform : " + _state.transitionDef.effecttransform);
			trace("_transitionDef.timetransform; : " + _transitionDef.effecttransform);
			*/
			trace("_customTransition : " + _customTransition);
			
			//trace("tempo_show : " + _tempo_show + ", tempo_hide : " + _tempo_hide);
			
			
			
			if (_customTransition != null) {
				//CUSTOM TRANSITION
				
				_customTransition.transition(_id, _idstateprev, _idstate, _dobjhide, _dobjshow);
				
			}
			else {
				//SHOW / HIDE
				
				var _nbhide:int = _dobjhide.length;
				var _time:Number = 0;
				if (_transitionmode == "lifo") _dobjhide = _dobjhide.reverse();
				
				for (i = 0; i < _nbhide; i++) 
				{
					hideObject(_dobjhide[i], _time);
					_time += _tempo_hide
				}
				
				var _nbshow:int = _dobjshow.length;
				for (i = 0; i < _nbshow; i++) 
				{
					showObject(_dobjshow[i], _time);
					_time += _tempo_show;
				}
			}
			
			
			
			
			
			
			//TRANSPROP
			/*
			prend prevstate et state
			filtre les dobj communs
				pour toutes les PROPERTY_SAVE
					si les valeur de prevstate et state sont différentes
						lance une tween
						
			temporise avec un delay
			
			*/
			
			
			
			//trace("_idstate : " + __idstate + ", _idstateprev : " + _idstateprev);
			
			
			var _nbprop:int = PropertySet.PROPERTIES.length;
			var _count:int = 0;
			
			for (var j:int = 0; j < _nbdobj; j++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[j]);
				
				if (_state.containDobj(_dobjinfo.displayObject)) {
					
					if(_stateprev==null || _stateprev.containDobj(_dobjinfo.displayObject)){
					
						var _bTweenprop:Boolean = false;
						
						for (var k:int = 0; k < _nbprop; k++) 
						{
							var _prop:String = PropertySet.PROPERTIES[k];
							
							//todo filter
							if(PropertySet.acceptProperties(_dobjinfo.displayObject, _prop)) {
								
								var _oldvalue:*;
								if (_stateprev == null) _oldvalue = _dobjinfo.displayObject[_prop];
								else _oldvalue = _stateprev.propertySet.getValue(_dobjinfo.displayObject, _prop);
								
								var _newvalue:* = _state.propertySet.getValue(_dobjinfo.displayObject, _prop);
								
								
								if (_oldvalue != null && _newvalue != null && _oldvalue != _newvalue) {
									
									if (isNaN(_timetransform)) _timetransform = 0.01;
									if (isNaN(_tempo_show)) _tempo_show = 0;
									if (_effecttransform == null) _effecttransform = Regular.easeOut;
									
									if (PropertySet.PROPERTIES_POSITION_LAYOUT.indexOf(_prop) != -1) {
										//trace("is layout prop");
										var _typeold:String = MarginObject.getType(_oldvalue);
										var _typenew:String = MarginObject.getType(_newvalue);
										var _valueold:Number = MarginObject.getValue(_oldvalue);
										var _valuenew:Number = MarginObject.getValue(_newvalue);
										//trace("_types : " + _typeold + ", " + _typenew + ", values : " + _valueold + ", " + _valuenew);
										
										var _ls:LayoutSprite = LayoutSprite(_dobjinfo.displayObject);
										
										
										_oldvalue = _valueold;
										_newvalue = _valuenew;
										
										//trace("_ls[" + _prop + "] = " + _oldvalue);
										_ls[_prop] = _oldvalue;
										LayoutEngine.update();
										
										//if (_typeold != _typenew) throw new Error("StateEngine, transprop : type of margins in layout props must be the sames");
										
										if (_typeold != _typenew) {
											_oldvalue = LayoutEngine.getChildPositionInUnit(_ls, _prop, _typenew);
											_ls.defaultType = _typenew;
										}
										
									}
									
									_dobjinfo.displayObject[_prop] = _oldvalue;
									trace("tween " + _dobjinfo.displayObject+", prop " + _prop + ", from " + _oldvalue + " to " + _newvalue + ", " + _timetransform + ", " + _count * _tempo_show + ", " + _effecttransform);
									_twm.tween(_dobjinfo.displayObject, _prop, _oldvalue, _newvalue, _timetransform, _count * _tempo_show, _effecttransform);
									_bTweenprop = true;
								}
							}
						}
						
						if (_bTweenprop) _count++;
					}
				}
				
			}
		}
		
		
		
		
		private function state_activate(_dobj:DisplayObject):void 
		{
			state_activate_rec(_dobj, true);
		}
		
		private function state_deactivate(_dobj:DisplayObject):void 
		{
			state_activate_rec(_dobj, false);
		}
		
		
		private function state_activate_rec(_dobj:DisplayObject, _value:Boolean):void
		{
			if (_dobj is IStateActivation) {
				if (_value) {
					IStateActivation(_dobj).state_activate();
					_dobj.dispatchEvent(new StateActivationEvent(StateActivationEvent.ACTIVATE));
				}
				else {
					IStateActivation(_dobj).state_deactivate();
					_dobj.dispatchEvent(new StateActivationEvent(StateActivationEvent.DEACTIVATE));
				}
			}
			
			if (_dobj is InterfaceSprite) {
				var _is:InterfaceSprite = InterfaceSprite(_dobj);
				var _behaviours:Array = _is.getBehaviours();
				var _nb:int = _behaviours.length;
				for (var j:int = 0; j < _nb; j++) 
				{
					var _b:Behaviour = Behaviour(_behaviours[j]);
					if (_b is IStateActivation) {
						if (_value) {
							IStateActivation(_b).state_activate();
							_b.dispatchEvent(new StateActivationEvent(StateActivationEvent.ACTIVATE));
						}
						else {
							IStateActivation(_b).state_deactivate();
							_b.dispatchEvent(new StateActivationEvent(StateActivationEvent.DEACTIVATE));
						}
					}
				}
			}
			
			var _len:int = (_dobj is DisplayObjectContainer) ? DisplayObjectContainer(_dobj).numChildren : 0;
			var _dobjc:DisplayObjectContainer = _dobj as DisplayObjectContainer;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(_dobjc.getChildAt(i));
				state_activate_rec(_child, _value);
			}
		}
		
		
		
		
		
		//_____________________
		//effects
		
		public function setEffect(_idstate:String, _dobjdef:String, __effect:*, __effecthide:*, _transitionmode:String, _tempo:Number, _timetransform:Number, _effecttransform:Function, _customTransition:CustomTransition):void
		{
			 /* 
			 * il nous quoi coté statemanager :
				 * 0 0  -> statemanager.effect 
				 * 1 0  -> state.effect
				 * 0 1  -> préenregistre les classname et les name dans DisplayObjectInfo pour rapidité, parcours _listdobj
				 * 1 1  -> il faudrait un array de couple effect/effecthide dans DisplayObjectInfo associé a des statename
			 * */
			 
			//trace("StateManager "+_id+" .setEffect " + _customTransition);
			 
			if (_idstate == "" && _dobjdef == "") {
				
				//set non prioritaire
				if (__effect != null) _effect = __effect;
				if (__effecthide != null) _effecthide = __effecthide;
				if (_transitionmode != "") _transitionDef.mode = _transitionmode;
				if (!isNaN(_tempo)) _transitionDef.tempo = _tempo;
				if (!isNaN(_timetransform)) _transitionDef.timetransform = _timetransform;
				if (_effecttransform != null) _transitionDef.effecttransform = _effecttransform;
				_transitionDef.customTransition = _customTransition;
			}
			
			else if (_idstate != "" && _dobjdef == "") {
				var _st:State = State(_states[_idstate]);
				if (_st == null) return;			//si appelé sur tous les sm, certains ne contiendront pas les states
				if (__effect != null) _st.effect = __effect;
				if (__effecthide != null) _st.effecthide = __effecthide;
				_st.setTransitionDef(_transitionmode, _tempo, _timetransform, _effecttransform, _customTransition);
			}
			
			else if (_idstate == "" && _dobjdef != "") {
				
				if (_transitionmode != "" || !(isNaN(_tempo))) throw new Error("setting transitionmode or tempo is illegal when specifying a dobjdef (" + _dobjdef + ")");
				if (!isNaN(_timetransform) || _effecttransform != null) throw new Error("TODO : timetransform and effecttransform for dobjdef");
				
				var _type:String = StateUtils.getDisplayObjectDefType(_dobjdef);
				var _value:String = StateUtils.getDisplayObjectDefValue(_dobjdef);
				
				var _list:Array = getDobjInfoByDef(_type, _value);
				for (var i in _list) {
					var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_list[i]);
					if (__effect != null) _dobjinfo.effect = __effect;
					if (__effecthide != null) _dobjinfo.effecthide = __effecthide;
				}
			}
			
			else if (_idstate != "" && _dobjdef != "") {
				throw new Error("todo : define objdef + state");
				
				if (_transitionmode != "" || !(isNaN(_tempo))) throw new Error("setting transitionmode or tempo is illegal when specifying a dobjdef (" + _dobjdef + ")");
				if (!isNaN(_timetransform) || _effecttransform != null) throw new Error("TODO : timetransform and effecttransform for dobjdef");
				
			}
		}
		
		
		
		public function stopAllEffect():void 
		{
			_twm.reset();
			
			if (_effect != null) _effect.stopEffect();
			if (_effecthide != null) _effecthide.stopEffect();
			
			var _len:int = _listdobj.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[i]);
				if (_dobjinfo.effect != null) _dobjinfo.effect.stopEffect();
				if (_dobjinfo.effecthide != null) _dobjinfo.effecthide.stopEffect();
			}
			
			_len = _states.length;
			for (i = 0; i < _len; i++) 
			{
				var _state:State = State(_states[i]);
				if (_state.effect != null) _state.effect.stopEffect();
				if (_state.effecthide != null) _state.effecthide.stopEffect();
			}
			
			//stop current delays
			var _nbdelays:int = _delays.length;
			for (var j:int = 0; j < _nbdelays; j++) 
			{
				var _d:Delay = _delays[j];
				if (_d.waiting) _d.stop();
			}
			_delays = new Array();
		}
		
		
		
		
		
		
		//met les bon visible / !visible en fonction des states definition - applique les propertySet
		public function syncDobj(__idstate:String):void 
		{
			/*
			trace(" -- ________________________________");
			trace(" -- SMTEST "+_id+".syncDobj");
			*/
			var _state:State;
			if (__idstate == "") {
				if (_idstate == null) return;
				_state = State(_states[_idstate]);
			}
			else _state = State(_states[__idstate]);
			
			//trace(" -- SMOK " + _id + ".syncDobj(" + ((_state == null)?"":_state.id) + ")");
			
			syncState(_state);
		}
		
		
		
		public function syncDobjAll(__idstate:String):void
		{
			if (__idstate == "") __idstate = _idstate;
			
			for (var i:* in _states) {
				if (i != __idstate) {
					syncState(State(_states[i]));
				}
			}
			
			if(__idstate != null){
				var _curstate:State = State(_states[__idstate]);
				syncState(_curstate);
			}
		}
		
		
		
		
		private function syncState(_state:State):void
		{
			var _nbdobj:int = _listdobj.length;
			for (var i:int = 0; i < _nbdobj; i++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[i]);
				
				if (_dobjinfo.displayObject.visible != _dobjinfo.display) 
					_dobjinfo.displayObject.visible = _dobjinfo.display;
					
				//pour celui qu'on va show, il est sur le state hide
				//le state hide ne contient aucun objet
				//donc on ne reset par leurs property...
				if (_state.containDobj(_dobjinfo.displayObject)) {
					
					_state.propertySet.apply(_dobjinfo.displayObject);
					
				}
			}
		}
		
		
		
		
		public function syncContainer():void
		{
			var _nbprop:int = PropertySet.PROPERTIES.length;
			for (var k:int = 0; k < _nbprop; k++) 
			{
				var _prop:String = PropertySet.PROPERTIES[k];
				
				if (PropertySet.acceptProperties(_container, _prop)) {
					var _value:* = _saveprop[_prop];
					if (_value != null)_container[_prop] = _value;
				}
			}
			
		}
		
		
		public function registerPropertySet():void 
		{
			var _len:int = _listdobj.length;
			var _nbprop:int = PropertySet.PROPERTIES.length;
			
			
			for (var i:* in _states) {
				var _state:State = State(_states[i]);
				
				for (var j:int = 0; j < _len; j++) 
				{
					var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[j]);
					if (_state.containDobj(_dobjinfo.displayObject)) {
						
						for (var k:int = 0; k < _nbprop; k++) 
						{
							var _prop:String = PropertySet.PROPERTIES[k];
							if (!_state.propertySet.contains(_dobjinfo.displayObject, _prop)) {
								
								if(PropertySet.acceptProperties(_dobjinfo.displayObject, _prop)){
									var _value:* = _dobjinfo.displayObject[_prop];
									_state.propertySet.add(_dobjinfo.displayObject, _prop, _value);
								}
							}
						}
						
					}
				}
			}
			
			//save les prop du container
			for (var k:int = 0; k < _nbprop; k++) 
			{
				var _prop:String = PropertySet.PROPERTIES[k];
				
				if(PropertySet.acceptProperties(_container, _prop)){
					
					_saveprop[_prop] = _container[_prop];
				}
			}
			
		}
		
		
		
		public function addSubchildToState(__idstate:String):void 
		{
			var _numchildren:int = _container.numChildren;
			var _state:State = State(_states[__idstate]);
			//trace("addSubchildToState(" + __idstate + ")");
			for (var i:int = 0; i < _numchildren; i++) 
			{
				var _dobj:DisplayObject = DisplayObject(_container.getChildAt(i));
				//trace(" --- child _dobj : " + _dobj);
				_state.addComponent(_dobj);
				addDisplayObject(_dobj);
			}
		}
		
		
		
		
		
		//__________________________________________________________________________________
		//set / get
		
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get container():DisplayObjectContainer 
		{
			return _container;
		}
		
		public function get buttonmode():Boolean 
		{
			return _buttonmode;
		}
		
		public function get effecthide():Effect 
		{
			return _effecthide;
		}
		
		public function get effect():Effect 
		{
			return _effect;
		}
		
		public function get buttonover():Boolean {return _buttonover;}
		
		public function set buttonover(value:Boolean):void {_buttonover = value;}
		
		public function get idstate():String {return _idstate;}
		
		public function set idstate(value:String):void {_idstate = value;}
		
		public function get transitionDef():TransitionDef {return _transitionDef;}
		
		public function get dynamiclist():Boolean {return _dynamiclist;}
		
		public function stateExists(_idstate:String):Boolean
		{
			for (var i in _states) {
				var _state:State = State(_states[i]);
				if (_state.id == _idstate) return true;
			}
			return false;
		}
		
		public function setButtonEffect(__idstate:String, _itemroll:String, __effectover:Effect, __effectout:Effect):void 
		{
			var _state:State = State(_states[__idstate]);
			if (_state == null) throw new Error("statemanager \"" + _id + "\" : state \"" + __idstate + "\"doesn't exist");
			
			_state.buttoneffect = __effectover;
			_state.buttoneffecthide = __effectout;
			
			var _typeitemroll:String = StateUtils.getDisplayObjectDefType(_itemroll);
			var _valueitemroll:String = StateUtils.getDisplayObjectDefValue(_itemroll);
			//var _listitemroll:Array = getDobjInfoByDef(_typeitemroll, _valueitemroll);
			var _listitemroll:Array = StateUtils.getDisplayObjectList(_container, _valueitemroll, _typeitemroll);
			
			
			if (_listitemroll.length == 0) throw new Error("itemroll " + _itemroll + " wasn't found");
			//var _dobjroll:DisplayObject = DisplayObjectInfo(_listitemroll[0]).displayObject;
			var _dobjroll:DisplayObject = DisplayObject(_listitemroll[0]);
			trace("_dobjroll : " + _dobjroll);
			
			if (_dobjroll is DisplayObjectContainer) {
				ClickableSprite.updateClickable(DisplayObjectContainer(_dobjroll));
			}
			_dobjroll.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverBtn);
			_dobjroll.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutBtn);
		}
		
		
		
		
		public function applyButtonEffect(__idstate:String):void 
		{
			var _state:State = State(_states[__idstate]);
			if (_state == null) throw new Error("statemanager \"" + _id + "\" : state \"" + __idstate + "\"doesn't exist");
			
			var _e:Effect = Effect(_state.buttoneffect);
			_e.target = _container;
			_e.init();
			_e.play();
		}
		
		
		public function getListIdstates():Array 
		{
			var _tab:Array = new Array();
			
			for (var _idstate:String in _states) {
				_tab.push(_idstate);
			}
			return _tab;
		}
		
		
		
		
		
		
		//__________________________________________________________________________________
		//private functions
		
		private function addDisplayObject(_dobj:DisplayObject):void
		{
			var _len:int = _listdobj.length;
			//prevent from doublon
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[i]);
				if (_dobjinfo.displayObject == _dobj) return;
			}
			
			var _classname:String = ObjectSearch.getClassName(_dobj);
			var _dobjinfo:DisplayObjectInfo = new DisplayObjectInfo(_dobj, _classname, _dobj.name);
			
			//a voir, lié a l'automatisation de la navigation (prendre le tps pour y reflechir)
			if (_idstate != null) _dobjinfo.display = true;
			
			_listdobj.push(_dobjinfo);
			_dobj.visible = _dobjinfo.display;
			
			if (!_dobjinfo.display) {
				state_deactivate(_dobjinfo.displayObject);
			}
			
			//trace("_sm " + _id + ", adddobj " + _dobj + ", visible:  " + _dobj.visible);
			
		}
		
		
		
		
		
		
		
		private function showObject(_dobjinfo:DisplayObjectInfo, _delay:Number):void 
		{
			//si _dobjinfo n'a pas subi son reset, on le fait ici
			
			var _state:State = State(_states[_idstate]);
			
			//todo later : couple state + dobjdef
			var _eff:Effect;
			if (_dobjinfo.effect != null) _eff = _dobjinfo.effect;
			else if (_state.effect != null) _eff = _state.effect;
			else _eff = _effect;
			
			if (_eff == null) throw new Error("Effect is not defined for StateManager " + _id);
			if (_eff is Effect) {
				var _e:Effect = Effect(_eff);
				_e.target = _dobjinfo.displayObject;
				_e.delay = _delay;
				_e.init();
				_e.play(null, true);
			}
			else throw new Error("why effect is not an Effect");
			
		}
		
		
		private function hideObject(_dobjinfo:DisplayObjectInfo, _delay:Number):void 
		{
			var _state:State = State(_states[_idstateprev]);
			
			var _eff:Effect;
			var _hideDefined:Boolean;
			if (_dobjinfo.effect != null) {
				_eff = (_dobjinfo.effecthide == null) ? _dobjinfo.effect : _dobjinfo.effecthide;
				_hideDefined = (_dobjinfo.effecthide != null);
			}
			else if (_state.effect != null) {
				_eff = (_state.effecthide == null) ? _state.effect : _state.effecthide;
				_hideDefined = (_state.effecthide != null);
			}
			else {
				_eff = (_effecthide == null) ? _effect : _effecthide;
				_hideDefined = (_effecthide != null);
			}
			
			if (_eff == null) throw new Error("Effect is not defined for StateManager " + _id);
			if (_eff is Effect) {
				var _e:Effect = Effect(_eff);
				_e.target = _dobjinfo.displayObject;
				_e.delay = _delay;
				_e.init();
				if (!_hideDefined) _e.rewind(null, false, true);
				else _e.play(null, false, true);
				
			}
			else throw new Error("why effect is not an Effect");
			
		}
		
		
		
		
		
		
		private function getDobjInfoByDef(_type:String, _value:String):Array
		{
			var _len:int = _listdobj.length;
			var _tab:Array = new Array();
			
			if (_type == StateUtils.DOBJ_DEF_ID) {
				_tab.push(ObjectSearch.getID(_value));
				return _tab;
			}
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _dobjinfo:DisplayObjectInfo = DisplayObjectInfo(_listdobj[i]);
				if (_type == StateUtils.DOBJ_DEF_CLASS && _dobjinfo.classname == _value) _tab.push(_dobjinfo);
				else if (_type == StateUtils.DOBJ_DEF_NAME && _dobjinfo.name == _value) _tab.push(_dobjinfo);
				
			}
			return _tab;
		}
		
		
		
		
		
		
		
		
		
		
		//______________________________________________________________________________
		//events
		
		
		private function onMouseOutBtn(e:MouseEvent):void 
		{
			//trace("onMouseOutBtn "+_idstate);
			var _state:State = State(_states[_idstate]);
			if (_state.buttoneffect != null) {
				
				this.syncDobj(_idstate);
				var _hideDefined:Boolean = (_state.buttoneffecthide != null);
				var _e:Effect = (_hideDefined) ? _state.buttoneffecthide : _state.buttoneffect;
				_e.target = _container;
				_e.init();
				if (_hideDefined) _e.play();
				else _e.rewind();
			}
		}
		
		private function onMouseOverBtn(e:MouseEvent):void 
		{
			//trace("onMouseOverBtn "+_idstate);
			var _state:State = State(_states[_idstate]);
			if (_state.buttoneffect != null) {
				this.syncDobj(_idstate);
				var _e:Effect = _state.buttoneffect;
				_e.target = _container;
				_e.init();
				_e.play();
			}
		}
		
	}

}