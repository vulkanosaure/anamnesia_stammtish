package data2.states.stateparser 
{
	import data2.states.StateEngine;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author 
	 */
	public class ContextMenuHandler 
	{
		private static var _menu:ContextMenu;
		private static var _datas:Array;
		private static var _menuitems:Array;
		private static var _separatorBefore:Boolean;
		
		public function ContextMenuHandler() 
		{
			throw new Error("is static");
		}
		
		
		
		public static function initMenu(_rootnodes:Array):void
		{
			
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			
			_datas = new Array();
			_menuitems = new Array();
			_separatorBefore = false;
			
			//trace("initMenu _rootnodes : " + _rootnodes);
			
			
			var _len:int = _rootnodes.length;
			for (var i:int = 0; i < _len; i++) 
			{
				addSeparator();
				var _rootnode:String = _rootnodes[i];
				//var _selected:Boolean = (_rootnode == StateParser.ROOT_NODE);
				var _selected:Boolean = true;
				rec(_rootnode, "", _selected, -1);
			}
		}
		
		
		
		public static function rec(_state:String, _stateparent:String, _selected:Boolean, _level:int):void
		{
			//tracelvl("state:"+_state+"/", _level);
			
			if (_stateparent != "") {
				var _data:Object = { };
				_data.stateparent = _stateparent;
				_data.state = _state;
				addItem(_state, _data, _level, _selected);
			}
			
			var _liststate:Array;
			if (StateEngine.stateManagerExists(_state)) _liststate = StateEngine.getListIdstates(_state);
			else _liststate = new Array();
			
			//tracelvl("liststate : " + _liststate, _level);
			
			
			var _nbstate:int = _liststate.length;
			//if(_nbstate > 0) addSeparator();
			
			for (var i:int = 0; i < _nbstate; i++) 
			{
				var _substate:String = _liststate[i];
				var _newselected:Boolean = (_selected) ? (StateEngine.getState(_state) == _substate) : false;
				rec(_substate, _state, _newselected, _level + 1);
			}
			//if(_nbstate > 0) addSeparator();
		}
		
		
		
		public static function addSeparator():void
		{
			_separatorBefore = true;
		}
		
		
		
		public static function addItem(_label:String, _data:Object, _level:int, _selected:Boolean):void
		{
			var _label2:String = "";
			for (var i:int = 0; i < _level; i++) _label2 += "\u00A0\u00A0\u00A0\u00A0";	//code for empty space
			_label2 += ((_selected) ? "+" : ">") + " ";
			_label2 += _label;
			
			var _menuitem:ContextMenuItem = new ContextMenuItem(_label2);
			_menuitem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClickMenuItem);
			
			
			if (_separatorBefore) {
				_menuitem.separatorBefore = true;
				_separatorBefore = false;
			}
			_menu.customItems.push(_menuitem);
			
			_datas.push(_data);
			_menuitems.push(_menuitem);
		}
		
		
		
		public static function getMenu():ContextMenu
		{
			return _menu;
		}
		
		
		
		
		
		//________________________________________________________________________________
		//private functions
		
		private static function tracelvl(_msg:String, _lvl:int):void
		{
			var _space:String = "";
			for (var i:int = 0; i < _lvl; i++) _space += "   ";
			trace(_space + _msg);
		}
		
		
		private static function getData(_menuitem:ContextMenuItem):Object
		{
			var _nbmenuitem:int = _menuitems.length;
			var _index:int;
			for (var i:int = 0; i < _nbmenuitem; i++) 
			{
				var _mi:ContextMenuItem = ContextMenuItem(_menuitems[i]);
				if (_mi == _menuitem) {
					_index = i;
					break;
				}
			}
			if (isNaN(_index)) throw new Error("menuitem " + _menuitem + " wasn't found");
			
			var _data:Object = _datas[_index];
			return _data;
			
		}
		
		
		
		
		//________________________________________________________________________________
		//events
		
		static private function onClickMenuItem(e:ContextMenuEvent):void 
		{
			var _menuitem:ContextMenuItem = ContextMenuItem(e.target);
			var _data:Object = getData(_menuitem);
			//trace("onClickMenuItem, _data : " + _data.stateparent + ", " + _data.state);
			StateParser.goto_(_data.stateparent, _data.state);
			
			
		}
		
		
		
	}

}