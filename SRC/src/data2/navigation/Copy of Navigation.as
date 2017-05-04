package data2.navigation 
{
	import data.display.FilledRectangle;
	import data.fx.transitions.TweenManager;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.InterfaceSprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Navigation__ 
	{
		
		static public const CALLBACK_GOTO:String = "callbackGoto";
		static public const CALLBACK_QUIT:String = "callbackQuit";
		
		
		public static var DEBUG:Boolean = false;
		static private const GROUP:String = "navigationGroup";
		
		private static var _locked:Boolean = false;
		private static var _data:Object;
		private static var _dataItem:Object;
		private static var _curscreen:String = "";
		private static var _prevscreen:String = "";
		
		private static var _twm:TweenManager = new TweenManager();
		private static var _delay:Number;
		private static var _listid:Array;
		private static var _listClickableConflicts:Array;
		
		private static var _listCallbackGoto:Object;
		private static var _listCallbackQuit:Object;
		
		
		
		
		public function Navigation__() 
		{
			
		}
		
		
		public static function addScreen(_idscreen:String, _listDefIn:Array, _listDefOut:Array):void
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
		
		
		static public function addItem(_iditem:String, _tabInclude:Array, _tabExclude:Array, _defIn:NavigationDef, _defOut:NavigationDef):void 
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
		
		
		static public function addCallback(_idscreen:String, _type:String, _func:Function):void 
		{
			if (_listCallbackQuit == null) _listCallbackQuit = new Object();
			if (_listCallbackGoto == null) _listCallbackGoto = new Object();
			
			var _obj:Object;
			if (_type == CALLBACK_GOTO) _obj = _listCallbackGoto;
			else if (_type == CALLBACK_QUIT) _obj = _listCallbackQuit;
			else throw new Error("wrong type of callback");
			
			_obj[_idscreen] = _func;
		}
		
		
		static public function addClickableConflict(_idbtn:String, _idgroup:String = ""):void 
		{
			if (_listClickableConflicts == null) _listClickableConflicts = new Array();
			var _btn:InterfaceSprite = InterfaceSprite(ObjectSearch.getID(_idbtn));
			var _group:InterfaceSprite = null;
			if (_idgroup != "") {
				_group = InterfaceSprite(ObjectSearch.getID(_idgroup));
			}
			
			_listClickableConflicts.push([_btn, _group]);
			_btn.addEventListener(MouseEvent.CLICK, onClickBtnConflict);
			
		}
		
		static private function onClickBtnConflict(e:MouseEvent):void 
		{
			var _sp:InterfaceSprite = InterfaceSprite(e.currentTarget);
			
			var _tab:Array = getTabConflict(_sp);
			
			if (_tab[1] != null) InterfaceSprite(_tab[1]).touchable = false;
			_sp.touchable = false;
			DelayManager.add(GROUP, 1500, function():void {
				_sp.touchable = true;
				if (_tab[1] != null) InterfaceSprite(_tab[1]).touchable = true;
			});
			
		}
		
		static private function getTabConflict(sp:InterfaceSprite):Array 
		{
			var _len:int = _listClickableConflicts.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _tab:Array = _listClickableConflicts[i];
				if (_tab[0] == sp) return _tab;
			}
			return null;
		}
		
		
		
		public static function init(_screeninit:String, _stage:Stage):void
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
			
			if (DEBUG) {
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
				
			}
			
			
			/*
			_curscreen = _screeninit;
			setAllScreenVisible(false);
			setItemVisible(_curscreen, true);
			*/
			
			for (var name:String in _dataItem) 
			{
				var _id:String = _dataItem[name].iditem;
				setItemVisible(_id, false);
				
			}
			
			gotoScreen(_screeninit);
		}
		
		
		static private function onKeydown(e:KeyboardEvent):void 
		{
			trace("onKeydown " + e.keyCode);
			if (e.keyCode >= 96 && e.keyCode <= 105) {
				var _index:int = e.keyCode - 96;
				if (_index > _listid.length - 1) return;
				var _idscreen:String = _listid[_index];
				gotoScreen(_idscreen);
				
			}
			
		}
		
		public static function gotoPrevScreen():void
		{
			if (_prevscreen != "") {
				gotoScreen(_prevscreen);
			}
		}
		
		
		
		public static function gotoScreen(_idscreen:String):void
		{
			if (_locked) return;
			if (_curscreen == _idscreen) return;
			
			_delay = 0;
			
			_locked = true;
			DelayManager.add(GROUP, 1500, function():void {
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
			
			
			if (_curscreen != "") {
				showScreen(_curscreen, false);
				
				showItems(_listItemOut, false);
				_delay += 0.7;
			}
			
			DelayManager.add(GROUP, _delay * 1000, function():void {
				setAllScreenVisible(false);
				setItemVisible(_idscreen, true);
			});
			
			showItems(_listItemIn, true);
			showScreen(_idscreen, true);
			
			
			
			
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
		
		
		
		
		private static function isItemOnScreen(_objitem:Object, _idscreen:String):Boolean
		{
			var _listInclude:Array = _objitem["tabInclude"];
			return _listInclude.indexOf(_idscreen) != -1;
		}
			
			
		
		private static function getItemByScreen(_idscreen:String):Array
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
		
		
		
		
		private static function showScreen(_id:String, _value:Boolean):void
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
		
		static private function showItems(_listitem:Array, _value:Boolean):void 
		{
			var _len:int = _listitem.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _listitem[i];
				var _def:NavigationDef = (_value) ? NavigationDef(_obj["defIn"]) : NavigationDef(_obj["defOut"]);
				//trace("animate(" + _def.id + ", " + _def.value + ", " + _def.side + ", " + _delay + ")");
				animate(_def.id, _def.value, _def.side, _delay, _def.dist, _def.fade);
				_delay += _def.delay;
				
			}
		}
		
		
		
		
		private static function setAllScreenVisible(_value:Boolean):void
		{
			var _len:int = _listid.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _id:String = _listid[i];
				setItemVisible(_id, _value);
			}
		}
		
		
		private static function setItemVisible(_id:String, _value:Boolean):void
		{
			var _obj:Sprite = Sprite(ObjectSearch.getID(_id));
			_obj.visible = _value;
		}
		
		
		private static function setItemTouchable(_id:String, _value:Boolean):void
		{
			var _obj:Sprite = Sprite(ObjectSearch.getID(_id));
			_obj.mouseEnabled = _value;
			_obj.mouseChildren = _value;
		}
		
		
		public static function animateNoAnim(__obj:*, _value:Boolean):void
		{
			var _obj:Sprite;
			if (__obj is Sprite) _obj = __obj;
			else _obj = Sprite(ObjectSearch.getID(__obj));
			
			_obj.visible = _value;
			_obj = Sprite(_obj.getChildAt(0));
			_obj.visible = _value;
			if (_value) _obj.alpha = 1.0;
		}
		
		public static function animate(__obj:*, _value:Boolean, _side:String, _d:Number, __distslide:Number = 700, _fade:Boolean = false, __timeAnim:Number = 0.6):void 
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
		
		
		
		
		static public function get curscreen():String 
		{
			return _curscreen;
		}
		
		
		
		
		
	}

}