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
	public class Navigation 
	{
		
		static public const CALLBACK_GOTO:String = "callbackGoto";
		static public const CALLBACK_QUIT:String = "callbackQuit";
		static public const CALLBACK_GOTO_TRANSITION:String = "callbackGotoTransition";
		static public var DEBUG:Boolean = false;
		
		static private const GROUP:String = "navigationGroup";
		static public const GROUP_NO_RESET:String = "navigationGroupNoReset";
		
		private static var _listClickableConflicts:Array;
		
		private static const ROOT_NAME:String = "root_elmt";
		private static var _instances:Object;
		
		
		
		
		
		public function Navigation() 
		{
			
		}
		
		
		public static function addScreen(_screenparent:String, _idscreen:String, _listDefIn:Array, _listDefOut:Array):void
		{
			var _instance:NavigationInstance = getInstance(_screenparent);
			_instance.addScreen(_idscreen, _listDefIn, _listDefOut);
			
		}
		
		
		
		static public function addItem(_iditem:String, _tabInclude:Array, _tabExclude:Array, _defIn:NavigationDef, _defOut:NavigationDef):void 
		{
			var _instanceMain:NavigationInstance = getInstance(ROOT_NAME);
			_instanceMain.addItem(_iditem, _tabInclude, _tabExclude, _defIn, _defOut);
			
		}
		
		
		static public function addCallback(_screenparent:String, _idscreen:String, _type:String, _func:Function):void 
		{
			var _instance:NavigationInstance = getInstance(_screenparent);
			_instance.addCallback(_idscreen, _type, _func);
		}
		
		
		
		
		//______________________________________
		
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
			DelayManager.add(GROUP_NO_RESET, 1500, function():void {
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
		//_________________________________________
		
		
		
		
		
		public static function init(_screenparent:String, _screeninit:String, _stage:Stage):void
		{
			var _instance:NavigationInstance = getInstance(_screenparent);
			var _isMain:Boolean = (_screenparent == "");
			
			_instance.init(_screeninit, _stage, _isMain);
			
		}
		
		static private function getInstance(_screenparent:String):NavigationInstance 
		{
			if (_screenparent == "") _screenparent = ROOT_NAME;
			if (_instances == null) _instances = new Object();
			
			var _instance:NavigationInstance;
			if (_instances[_screenparent] == undefined) {
				_instance = new NavigationInstance(_screenparent);
				_instances[_screenparent] = _instance;
			}
			else {
				_instance = NavigationInstance(_instances[_screenparent]);
			}
			
			return _instance;
		}
		
		
		public static function gotoPrevScreen():void
		{
			var _instanceMain:NavigationInstance = getInstance(ROOT_NAME);
			_instanceMain.gotoPrevScreen();
			
		}
		
		
		
		public static function gotoScreen(_screenparent:String, _idscreen:String, _delayLock:Number = 1500):void
		{
			trace("gotoScreen(" + _screenparent + ", " + _idscreen + ")");
			var _instance:NavigationInstance = getInstance(_screenparent);
			_instance.gotoScreen(_idscreen, _delayLock);
		}
		
		
		
		
		static public function getCurscreen(_screenparent:String):String 
		{
			var _instance:NavigationInstance = getInstance(_screenparent);
			return _instance.curscreen;
		}
		
		
		
		
		
	}

}