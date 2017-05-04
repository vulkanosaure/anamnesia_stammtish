package data2.navigation 
{
	import data.fx.transitions.TweenManager;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.InterfaceSprite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	public class NavigationInstance {
		
		private const GROUP:String = "navigationGroup";
		
		
		private var _locked:Boolean = false;
		private var _data:Object;
		private var _dataItem:Object;
		private var _curscreen:String = "";
		private var _prevscreen:String = "";
		
		private var _twm:TweenManager = new TweenManager();
		private var _delay:Number;
		private var _listid:Array;
		
		private var _listCallbackGoto:Object;
		private var _listCallbackGotoTransition:Object;
		private var _listCallbackQuit:Object;
		private var _idgroup:String;
		
		
		
		
		public function NavigationInstance(__idgroup:String) 
		{
			_idgroup = __idgroup;
		}
		
		
		public function addScreen(_idscreen:String, _listDefIn:Array, _listDefOut:Array):void
		{
			for (var name:String in _listDefIn) NavigationDef(_listDefIn[name]).value = true;
			for (var name:String in _listDefOut) NavigationDef(_listDefOut[name]).value = false;
			
			if (_data == null) _data = new Object();
			if (_listid == null) _listid = new Array();
			
			var _obj:Object = new Object();
			_obj.idscreen = _idscreen;
			_obj.listDefIn = _listDefIn;
			_obj.listDefOut = _listDefOut;
			
			_data[_idscreen] = _obj;
			_listid.push(_idscreen);
			
		}
		
		
		public function addItem(_iditem:String, _tabInclude:Array, _tabExclude:Array, _defIn:NavigationDef, _defOut:NavigationDef):void 
		{
			if (_dataItem == null) _dataItem = new Object();
			_defIn.value = true;
			_defOut.value = false;
			
			var _obj:Object = new Object();
			_obj.iditem = _iditem;
			_obj.defIn = _defIn;
			_obj.defOut = _defOut;
			_obj.tabInclude = _tabInclude;
			_obj.tabExclude = _tabExclude;
			_dataItem[_iditem] = _obj;
			
		}
		
		
		public function addCallback(_idscreen:String, _type:String, _func:Function):void 
		{
			if (_listCallbackQuit == null) _listCallbackQuit = new Object();
			if (_listCallbackGoto == null) _listCallbackGoto = new Object();
			if (_listCallbackGotoTransition == null) _listCallbackGotoTransition = new Object();
			
			var _obj:Object;
			if (_type == Navigation.CALLBACK_GOTO) _obj = _listCallbackGoto;
			else if (_type == Navigation.CALLBACK_QUIT) _obj = _listCallbackQuit;
			else if (_type == Navigation.CALLBACK_GOTO_TRANSITION) _obj = _listCallbackGotoTransition;
			else throw new Error("wrong type of callback");
			
			_obj[_idscreen] = _func;
		}
		
		
		
		
		private function onKeydown(e:KeyboardEvent):void 
		{
			//trace("onKeydown " + e.keyCode);
			if (e.keyCode >= 96 && e.keyCode <= 105) {
				var _index:int = e.keyCode - 96;
				if (_index > _listid.length - 1) return;
				var _idscreen:String = _listid[_index];
				
				this.gotoScreen(_idscreen);
				
			}
			
		}
		
		
		public function init(_screeninit:String, _stage:Stage, _debug:Boolean):void
		{
			setAllScreenVisible(false);
			
			
			
			var _nbscreen:int = _listid.length;
			
			for (var _key:String in _dataItem) 
			{
				var _obj = _dataItem[_key];
				if (_obj["tabInclude"] == undefined) {
					var _tabExclude:Array = _obj["tabExclude"];
					var _tabInclude:Array = [];
					for (var i:int = 0; i < _nbscreen; i++) 
					{
						var _sc:String = _listid[i];
						if (_tabExclude.indexOf(_sc) == -1) {
							_tabInclude.push(_sc);
						}
					}
					trace("_tabexclude : " + _tabExclude);
					trace("_tabinclude : " + _tabInclude);
					_obj["tabInclude"] = _tabInclude;
				}
			}
			
			/*
			_curscreen = _screeninit;
			setAllScreenVisible(false);
			setItemVisible(_curscreen, true);
			*/
			
			
			if (_debug) {
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
				
			}
			
			for (var name:String in _dataItem) 
			{
				var _id:String = _dataItem[name].iditem;
				setItemVisible(_id, false);
				
			}
			
			gotoScreen(_screeninit);
		}
		
		
		
		public function gotoPrevScreen():void
		{
			if (_prevscreen != "") {
				gotoScreen(_prevscreen);
			}
		}
		
		
		
		public function gotoScreen(_idscreen:String, _delayLock:Number = 1500):void
		{
			/*
			if (_locked) {
				//trace("return _locked");
				return;
			}
			*/
			if (_curscreen == _idscreen) {
				//trace("return ==");
				return;
			}
			
			//todo : il faudrait reset uniquement pour le _idscreen en question
			DelayManager.resetGroup(GROUP + _idgroup);
			
			
			_delay = 0;
			
			_locked = true;
			DelayManager.add(GROUP + _idgroup, _delayLock, function():void {
				_locked = false;
			});
			
			
			var _listItemOut:Array = new Array();
			var _listItemIn:Array = new Array();
			var _list:Array;
			
			_list = getItemByScreen(_curscreen);
			for (var i:int = 0; i < _list.length; i++) 
			{
				var _obj:Object = _list[i];
				if (!isItemOnScreen(_obj, _idscreen)) {
					trace("- out " + _obj.iditem);
					_listItemOut.push(_obj);
				}
			}
			
			var _list:Array = getItemByScreen(_idscreen);
			for (var i:int = 0; i < _list.length; i++) 
			{
				var _obj:Object = _list[i];
				if (!isItemOnScreen(_obj, _curscreen)) {
					trace("- in " + _obj.iditem);
					_listItemIn.push(_obj);
				}
			}
			
			
			
			//_____________________________________________
			
			trace("_curscreen : " + _curscreen);
			if (_curscreen != "") {
				showScreen(_curscreen, false);
				
				showItems(_listItemOut, false);
				_delay += 0.7;
			}
			
			DelayManager.add(GROUP + _idgroup, _delay * 1000, function():void {
				
				setAllScreenVisible(false);
				if (_idscreen != "") setItemVisible(_idscreen, true);
				
				if (_listCallbackGotoTransition != null && _listCallbackGotoTransition[_idscreen] != undefined) {
					_listCallbackGotoTransition[_idscreen]();
				}
				
			});
			
			showItems(_listItemIn, true);
			if (_idscreen != "") showScreen(_idscreen, true);
			
			
			
			//callback
			if (_listCallbackGoto != null && _listCallbackGoto[_idscreen] != undefined) {
				_listCallbackGoto[_idscreen]();
			}
			
			if (_listCallbackQuit != null && _listCallbackQuit[_curscreen] != undefined) {
				_listCallbackQuit[_curscreen]();
			}
			
			
			_prevscreen = _curscreen;
			_curscreen = _idscreen;
			
			
			
		}
		
		
		
		
		private function isItemOnScreen(_objitem:Object, _idscreen:String):Boolean
		{
			var _listInclude:Array = _objitem["tabInclude"];
			return _listInclude.indexOf(_idscreen) != -1;
		}
			
			
		
		private function getItemByScreen(_idscreen:String):Array
		{
			var _output:Array = [];
			for (var name:String in _dataItem) 
			{
				var _obj:Object = _dataItem[name];
				var _tabInclude:Array = _obj["tabInclude"];
				if (_tabInclude.indexOf(_idscreen) != -1) {
					_output.push(_obj);
				}
			}
			return _output;
		}
		
		
		
		
		private function showScreen(_id:String, _value:Boolean):void
		{
			var _obj:Object = _data[_id];
			if (_obj == null) throw new Error("screen id '" + _id + "' doesn't exist");
			var _list:Array = (_value) ? _obj["listDefIn"] : _obj["listDefOut"];
			
			var _len:int = _list.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _def:NavigationDef = NavigationDef(_list[i]);
				animate(_def.id, _def.value, _def.side, _delay, _def.dist, _def.fade);
				_delay += _def.delay;
			}
			
		}
		
		private function showItems(_listitem:Array, _value:Boolean):void 
		{
			var _len:int = _listitem.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _listitem[i];
				var _def:NavigationDef = (_value) ? NavigationDef(_obj["defIn"]) : NavigationDef(_obj["defOut"]);
				//trace("animate(" + _def.id + ", " + _def.value + ", " + _def.side + ", " + _delay + ")");
				animate(_def.id, _def.value, _def.side, _delay, _def.dist, _def.fade, _def.time);
				_delay += _def.delay;
				
			}
		}
		
		
		
		
		private function setAllScreenVisible(_value:Boolean):void
		{
			var _len:int = _listid.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _id:String = _listid[i];
				setItemVisible(_id, _value);
			}
		}
		
		
		private function setItemVisible(_id:String, _value:Boolean):void
		{
			var _obj:Sprite = Sprite(ObjectSearch.getID(_id));
			_obj.visible = _value;
		}
		
		
		private function setItemTouchable(_id:String, _value:Boolean):void
		{
			var _obj:Sprite = Sprite(ObjectSearch.getID(_id));
			_obj.mouseEnabled = _value;
			_obj.mouseChildren = _value;
		}
		
		
		public function animateNoAnim(__obj:*, _value:Boolean):void
		{
			var _obj:Sprite;
			if (__obj is Sprite) _obj = __obj;
			else _obj = Sprite(ObjectSearch.getID(__obj));
			
			_obj.visible = _value;
			_obj = Sprite(_obj.getChildAt(0));
			_obj.visible = _value;
			if (_value) _obj.alpha = 1.0;
		}
		
		public function animate(__obj:*, _value:Boolean, _side:String, _d:Number, __distslide:Number = 700, _fade:Boolean = false, __timeAnim:Number = 0.6):void 
		{
			var _obj:Sprite;
			if (__obj is Sprite) {
				_obj = __obj;
			}
			else {
				_obj = Sprite(ObjectSearch.getID(__obj));
			}
			
			if (_value && !_obj.visible) _obj.visible = true;
			_obj = Sprite(_obj.getChildAt(0));
			
			var _timeanim:Number = __timeAnim;
			
			if (_fade) {
				var _alphasrc:Number = (_value) ? 0 : 1;
				var _alphadest:Number = (_value) ? 1 : 0;
				_obj.alpha = _alphasrc;
				_twm.tween(_obj, "alpha", NaN, _alphadest, _timeanim, _d);
			}
			
			if (_side != NavigationDef.NONE) {
				var _distslide:Number = __distslide;
				var _prop:String = (_side == NavigationDef.LEFT || _side == NavigationDef.RIGHT) ? "x" : "y";
				var _src:Number;
				var _dst:Number;
				
				if (_value) {
					_src = (_side == NavigationDef.LEFT || _side == NavigationDef.TOP) ? -_distslide : +_distslide;
					_dst = 0;
				}
				else {
					_src = 0;
					_dst = (_side == NavigationDef.LEFT || _side == NavigationDef.TOP) ? -_distslide : +_distslide; 
				}
				_obj[_prop] = _src;
				_twm.tween(_obj, _prop, _src, _dst, _timeanim, _d);
				
			}
		}
		
		
		
		
		public function get curscreen():String 
		{
			return _curscreen;
		}
		
		
		
		
		
	}

}