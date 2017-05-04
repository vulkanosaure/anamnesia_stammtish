/*
 * TODO :
 * 
 * seul un element en top de liste est selectionnable, et deselection des autres 					OK
 * 
 * init, tout ouvert ? (plancher a donf)															OK
 * 
 * multiple select effect																			OK
 * 
 * bug rollover, part d'un element root, survol très vite un sub-elmt, tombe ds le vide				OK
 * 
 * gestion Events																					A FAIRE AVC XML ML+
 * 
 * ts les params (halign, valign, delta, _deploymentRollOver) peuvent se déclarer par level			plus tard...
 * (créer Classe LevelDef pour ça)
 * 
 * garde l'effet rollover sur parents de menu														plus tard...
 * 
 * methode hideAll()																				OK
 * 
 * 
 * 
 * PROBLEMES :
 * 
 * rollout de itemselected pas pris en compte
 * responsabilité user de coller les menu pour éviter les trou (sinon, rollout)
 * 
 * 

 * 
 * EXAMPLE :
 * 
var menu:Menu = new Menu();
for (var i:int = 0; i < 10; i++) menu.add("main " + i);

var subMenu:Menu = new Menu();
for (var i:int = 0; i < 3; i++) subMenu.add("1.subtitle " + i);

menuRecursive = new MenuRecursive();
menuRecursive.add(menu, null, 0);
menuRecursive.add(subMenu, menu, 1);

menuRecursive.delta = new Point(175, 0);
menuRecursive.valign = 0.0;

menuRecursive.hideOnClick = false;
menuRecursive.keepSelectedMenuVisible = false;
menuRecursive.hideOnRollOut = false;

menuRecursive.init();
menuRecursive.selectedIndex = 5;
addChild(menuRecursive);
*/




package data.layout.menu 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Vincent
	 */
	public class MenuRecursive extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		//params
		private var _halign:Number;
		private var _valign:Number;
		private var _delta:Point;
		
		private var _deployOnRollOver:Boolean;
		private var _hideOnClick:Boolean;
		private var _hideOnRollOut:Boolean;
		private var _keepSelectedMenuVisible:Boolean;
		private var _openFirstSublnk:Boolean;
		
		
		//internal
		private var _nodes:Array;
		private var _selectedIndex:int;
		private var _menuRoot:Menu;
		private var _assignPositionIndex:int;
		
		
		public function MenuRecursive() 
		{
			_nodes = new Array();
			
			_delta = new Point(0, 0);
			_valign = 0.0;
			_halign = 0.0;
			
			//default value
			this.deployOnRollOver = true;
			this.hideOnClick = false;
			this.keepSelectedMenuVisible = false;
			this.hideOnRollOut = false;
			this.openFirstSublnk = false;
			
			
			
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		public function add(_menu:Menu, _parent:Menu, _idaccess:int):void
		{
			if (_parent != null && _parent.length <= _idaccess) 
				throw new Error("idaccess " + _idaccess + " is undefined in " + _parent + " (length : " + _parent.length + ")");
				
			var _node:MenuRecursiveNode = new MenuRecursiveNode();
			_node.menu = _menu;
			_node.menu.menuParent = _parent;
			_node.idaccess = _idaccess;
			_nodes.push(_node);
			
			if (_parent == null) _menuRoot = _menu;
			
		}
		
		public function hideAll():void
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			var _bok:Boolean;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				
				_bok = true;
				//si !hideOnClick => filtre l
				//si _node.menu est selected ou est parent d'un item selected => on ne cache pas
				if (!_hideOnClick) {
					if (isSelected(_node.menu) || hasSelectedChildren(_node.menu)) _bok = false;
				}
				if (_node.menu.menuParent == null) _bok = false;
				if (_bok) hideMenu(_node.menu);
			}
		}
		
		public function init():void
		{
			//error handler
			if (_hideOnClick && _keepSelectedMenuVisible) throw new Error("setting both hideOnClick and keepSelectedMenuVisible to true is a nonsense");
			
			var _len:uint = _nodes.length;
			var _menu:Menu;
			var _parent:Menu;
			
			var _node:MenuRecursiveNode;
			
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				_menu = _node.menu;
				_parent = _menu.menuParent;
				
				this.addChild(_menu);
				if (_parent != null) {
					_menu.visible = false;
					positionMenu(_menu, _node.idaccess);
				}
				
				_menu.changeOnClick = false;
				_menu.addEventListener(MenuEvent.CLICK, onClick);
				_menu.addEventListener(MenuEvent.ROLLOVER, onRollover);
				_menu.addEventListener(MenuEvent.ROLLOUT, onRollout);
				_menu.addEventListener(MenuEvent.MOVE, onMenuMove);
				
			}
			
			_assignPositionIndex = 0;
			assignPositionIndex(_menuRoot);
			
		}
		
		
		public function unselect():void
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				_node.menu.unselect();
			}
			//hideAll();
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// setter / getter
		
		public function set delta(v:Point):void
		{
			_delta = v;
		}
		
		public function set valign(v:Number):void
		{
			_valign = v;
		}
		
		public function set halign(v:Number):void
		{
			_halign = v;
		}
		
		public function set deployOnRollOver(value:Boolean):void 
		{
			_deployOnRollOver = value;
		}
		
		public function set hideOnClick(value:Boolean):void 
		{
			_hideOnClick = value;
		}
		
		public function set hideOnRollOut(value:Boolean):void 
		{
			_hideOnRollOut = value;
		}
		
		public function set keepSelectedMenuVisible(value:Boolean):void 
		{
			_keepSelectedMenuVisible = value;
		}
		
		public function set openFirstSublnk(value:Boolean):void 
		{
			_openFirstSublnk = value;
		}
		
		
		public function set selectedIndex(value:int):void
		{
			/*
			 * if(_hideOnClick || _hideOnRollOut) select only root
			 * else select all
			 * 
			 * */
			 
			if (value == -1) {
				this.unselect();
				this.hideAll();
				return;
			}
			 
			var _arr:Array = getMenuByPositionIndex(value);
			var _menu:Menu = _arr[0] as Menu;
			
			var _node:MenuRecursiveNode;
			var idselected:int = _arr[1];
			 
			var _tabLnks:Array = new Array();
			
			while (true) {
				_node = getNodeByMenu(_menu);
				_menu.selectedIndex = idselected;
				_tabLnks.push( { "menu" : _menu, "index" : idselected } );
				_menu = _menu.menuParent;
				idselected = _node.idaccess;
				if (_menu == null) break;
			}
			
			_tabLnks = _tabLnks.reverse();
			var _len:int = _tabLnks.length;
			
			for (var i:int = 0; i < _len; i++) {
				_menu = Menu(_tabLnks[i]["menu"]);
				idselected = _tabLnks[i]["index"];
				if (i < _len - 1) {
					_menu.unselect();
					var _item:IMenuItem = _menu.getItemAt(idselected);
					_item.select(Menu.TYPE_ROLL);
					setDeployment(_menu, idselected, (!_hideOnClick && !_hideOnRollOut));
				}
				else _menu.selectedIndex = idselected;
				
			}
			
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function positionMenu(_menu:Menu, _idaccess:int):void
		{
			var _parent:Menu = _menu.menuParent;
			var _itemaccess:DisplayObject;
			
			var _x:Number;
			var _y:Number;
			var _dimsAccess:Point;
			var _posAccess:Point;
			
			//trace("positionMenu(" + _menu + ", " + _idaccess + ")");
			
			if (_parent != null) {
				_itemaccess = DisplayObject(_parent.getItemAt(_idaccess));
				//trace("_itemaccess : " + _itemaccess);
				
				_dimsAccess = new Point(_itemaccess.width, _itemaccess.height);
				_posAccess = new Point(_itemaccess.x, _itemaccess.y);
				
				_x = _parent.x + _delta.x + _posAccess.x;
				_y = _parent.y + _delta.y + _posAccess.y;
				_x += _dimsAccess.x * _halign - _menu.width * _halign;
				_y += _dimsAccess.y * _valign - _menu.height * _valign;
			}
			else {
				_x = - _menu.width * _halign;
				_y = - _menu.height * _valign;
			}
			
			//trace("position : " + _x + ", " + _y);
			_menu.x = _x;
			_menu.y = _y;
		}
		
		
		
		private function getLinkedMenu(_parent:Menu, _idaccess:int):Menu
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (_node.menu.menuParent == _parent && _idaccess == _node.idaccess) return _node.menu;
			}
			return null;
		}
		
		private function getLinkedMenuList(_parent:Menu):Array
		{
			var _tab:Array = new Array();
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (_node.menu.menuParent == _parent) _tab.push(_node.menu);
			}
			return _tab;
		}
		
		private function hasOpenChildren(_parent:Menu):Boolean
		{
			var _list:Array = getLinkedMenuList(_parent);
			var _len:uint = _list.length;
			var _menu:Menu;
			for (var i:int = 0; i < _len; i++) {
				_menu = Menu(_list[i]);
				if (_menu.isVisible()) return true;
			}
			return false;
		}
		
		private function hasSelectedChildren(_parent:Menu):Boolean
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (isSelected(_node.menu) && isParent(_parent, _node.menu)) return true;
			}
			return false;
		}
		
		
		
		private function setDeployment(_menu:Menu, _id:int, _show:Boolean=true):void
		{
			//trace("setDeployment(" + _menu + ", " + _id + ")");
			var _linkedMenu:Menu = getLinkedMenu(_menu, _id);
			var _bok:Boolean;
			
			//parcours tout les menus, 
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				
				_node = MenuRecursiveNode(_nodes[i]);
				//filtre parent de elmt roll, elmt roll, et enfant ouvert (si existe)
				if (!isParent(_node.menu, _menu) && _node.menu != _menu && _node.menu != _linkedMenu) {
					
					_bok = true;
					
					//si _node.menu est selected ou est parent d'un item selected => on ne cache pas
					if (_keepSelectedMenuVisible) {
						if (isSelected(_node.menu) || hasSelectedChildren(_node.menu)) _bok = false;
					}
					
					if (_bok) {
						hideMenu(_node.menu);
					}
				}
			}
			
			//si on trouve un sous menu, on l'affiche
			if (_linkedMenu != null && _show) {
				if (!_linkedMenu.visible) _linkedMenu.visible = true;
				showMenu(_linkedMenu);
				
				_menu.keepSelected(_id);
				//trace("showMenu : " + _linkedMenu);
			}
		}
		
		private function isSelected(_menu:Menu):Boolean
		{
			return (_menu.selectedIndex != -1);
		}
		
		private function showMenu(_menu:Menu):void
		{
			var _node:MenuRecursiveNode = getNodeByMenu(_menu);
			positionMenu(_menu, _node.idaccess);
			_menu.show();
		}
		
		private function hideMenu(_menu:Menu):void
		{
			//trace("hideMenu(" + _menu + ")");
			_menu.hide();
			var _node:MenuRecursiveNode = getNodeByMenu(_menu);
			//empeche de selectionner le niveau root d'un access selected
			if (_menu.menuParent == _menuRoot && (isSelected(_menu) || hasSelectedChildren(_menu))) {
				//trace("oh yeah");
			}
			else _menu.menuParent.unkeepSelected(_node.idaccess);
		}
		
		private function hideMenuRecursive(_menu:Menu, _limit:Menu):void
		{
			hideMenu(_menu);
			
			var _bok:Boolean = false;
			
			//de _menu a _limit en evitant le root
			if (_menu.menuParent.menuParent != null && _menu.menuParent!=_limit) {
				_bok = true;
			}
			
			//si keepSelected, on s'arrete si menuSelectionné
			if (_keepSelectedMenuVisible && isSelected(_menu.menuParent)) _bok = false;
			
			if (_bok) hideMenuRecursive(_menu.menuParent, _limit);
		}
		
		private function getNodeByMenu(_menu:Menu):MenuRecursiveNode
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (_node.menu == _menu) return _node;
			}
			throw new Error("_node has not beend found");
		}
		
		
		private function isParent(_menuparent:Menu, _menuchild:Menu):Boolean
		{
			//trace("isParent(" + _menuparent + ", " + _menuchild + ") ____________");
			var _m:Menu = _menuchild;
			var secu:int = 0;
			while (_m.menuParent!=null && secu<99) {
				_m = _m.menuParent;
				if (_m == _menuparent) return true;
				secu++;
			}
			return false;
		}
		
		private function isTerminal(_menu:Menu, _id:int):Boolean
		{
			return (getLinkedMenu(_menu, _id) == null);
		}
		
		
		//todo tester avec sous container et positionné autre que 0,0
		private function isMouseInside(_menu:Menu):Boolean
		{
			var _posMouse:Point = new Point(stage.mouseX, stage.mouseY);
			_posMouse = this.globalToLocal(_posMouse);
			var _rect:Rectangle = _menu.getBounds(this);
			
			if (_posMouse.x > _rect.left && _posMouse.x < _rect.right && _posMouse.y > _rect.top && _posMouse.y < _rect.bottom) return true;
			return false;
		}
		
		private function getMenuUnderMouse():Menu
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (isMouseInside(_node.menu)) return _node.menu;
			}
			return null;
		}
		
		private function getDeepestOpenMenu(_parent:Menu):Menu
		{
			var _parentsave:Menu;
			while (true) {
				_parentsave = _parent;
				_parent = getDeepestOpenMenuRecursive(_parent);
				if (_parent == null) break;
			}
			return _parentsave; 
		}
		
		private function getDeepestOpenMenuRecursive(_parent:Menu):Menu
		{
			var _tab:Array = getLinkedMenuList(_parent);
			var _len:uint = _tab.length;
			var _child:Menu;
			for (var i:int = 0; i < _len; i++) {
				_child = Menu(_tab[i]);
				if (_child.isVisible() && !isSelected(_child)) return _child;
			}
			return null;
		}
		
		private function getGlobalID(_menu:Menu, _id:int):int
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			var _count:int = 0;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				if (_node.menu == _menu) break;
				else _count += _node.menu.length;
			}
			return _count + _id;
		}
		
		//renvoit [Menu, ind]
		private function getMenuByPositionIndex(_positionIndex:int):Array
		{
			var _len:uint = _nodes.length;
			var _node:MenuRecursiveNode;
			var _indexOf:int;
			for (var i:int = 0; i < _len; i++) {
				_node = MenuRecursiveNode(_nodes[i]);
				_indexOf = _node.positionIndex.indexOf(_positionIndex);
				if (_indexOf!=-1) return [_node.menu, _indexOf];
			}
			//throw new Error("menu at positionIndex " + _positionIndex + " wasn't found");
			return [];
		}
		
		
		/*assigne a chaque menuitem un positionIndex*/
		
		private function assignPositionIndex(_menu:Menu):void
		{
			var _len:uint = _menu.length;
			var _node:MenuRecursiveNode = getNodeByMenu(_menu);
			var _count:int = 0;
			
			for (var i:int = 0; i < _len; i++) {
				if (isTerminal(_menu, i)) {
					_node.positionIndex.push(_assignPositionIndex);
					_assignPositionIndex++;
				}
				else {
					_node.positionIndex.push(null);
					assignPositionIndex(getLinkedMenu(_menu, i));
				}
			}
		}
		
		
		private function getIdAccessRecursive(_lastid:int, _m:Menu):Array
		{
			var _tabIdAccess:Array = new Array();
			_tabIdAccess.push(_lastid);
			var _node:MenuRecursiveNode;
			
			while (_m!=null && _m != _menuRoot) {
				_node = getNodeByMenu(_m);
				_tabIdAccess.push(_node.idaccess);
				_m = _m.menuParent;
			}
			_tabIdAccess.reverse();
			return _tabIdAccess;
		}
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onClick(e:MenuEvent):void 
		{
			var _menu:Menu = Menu(e.target);
			setDeployment(_menu, e.id);
			
			//si element terminal : on le selectionne, on deselectionne tout le reste
			if (isTerminal(_menu, e.id)) {
				unselect();
				_menu.selectedIndex = e.id;
				hideAll();
				
				//dispatchEvent
				var _node:MenuRecursiveNode = getNodeByMenu(_menu);
				var _idclick:int = _node.positionIndex[e.id];
				//trace("dispatchEvent(CLICK, " + _idclick + ")");
				
				
				
				//dispatchEvent
				var _tabIdAccess:Array = getIdAccessRecursive(e.id, _menu);
				
				var _mevt:MenuEvent = new MenuEvent(MenuEvent.CLICK, _idclick);
				_mevt.id_recursives = _tabIdAccess;
				this.dispatchEvent(_mevt);
				
			}
			
			//si il existe un submenu, et que le 1er item de ce submenu est final
			else if(_openFirstSublnk){
				var _link:Menu = getLinkedMenu(_menu, e.id);
				if (isTerminal(_link, 0)) {
					//on simule un evt click dessus
					_link.dispatchEvent(new MenuEvent(MenuEvent.CLICK, 0));
				}
			}
			
		}
		
		private function onRollover(e:MenuEvent):void 
		{
			//trace("onRollover");
			var _menu:Menu = Menu(e.target);
			//sauf menu root, si methode hide() lancée, rollover + possible
			if (_menu.menuParent != null && !_menu.isVisible()) return;
			if (_deployOnRollOver) setDeployment(_menu, e.id);
			
		}
		
		
		private function onRollout(e:MenuEvent):void 
		{
			//trace("onRollOut : " + _menu);
			
			var _menu:Menu = e.target as Menu;
			_menu = getDeepestOpenMenu(_menu);
			
			var _menuUnderMouse:Menu = getMenuUnderMouse();
			
			//cherche si la souris est sur un menu
			//si non, pareil, si oui, stop la recursivite a ce menu la
			
			if (_hideOnRollOut) {
				if (_keepSelectedMenuVisible && isSelected(_menu)) {}
				
				else if (_menu.menuParent != null			//si menu != root
					&& !isMouseInside(_menu) 				//si la souris n'est pas a l'interieur du menu
					&& !hasOpenChildren(_menu)) {
						//trace("yo");
						hideMenuRecursive(_menu, _menuUnderMouse);					//on cache
					}
					
			}
		}
		
		
		
		private function onMenuMove(e:MenuEvent):void 
		{
			//trace("MenuRecursive.onMenuMove");
			var _menu:Menu = Menu(e.target);
			var _childList:Array = getLinkedMenuList(_menu);
			var _len:uint = _childList.length;
			var _child:Menu;
			var _node:MenuRecursiveNode;
			for (var i:int = 0; i < _len; i++) {
				_child = Menu(_childList[i]);
				if (_child.isVisible()) {
					_node = getNodeByMenu(_child);
					positionMenu(_child, _node.idaccess);
					
				}
			}
			
		}
		
	}
	
}



import data.layout.menu.Menu;

internal class MenuRecursiveNode {
	
	public var menu:Menu;
	public var idaccess;
	public var positionIndex:Array = new Array();
	
	public function MenuRecursiveNode() {}
	
}