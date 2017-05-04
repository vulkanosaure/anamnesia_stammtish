package data.layout.menu {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import data.layout.menu.MenuEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Menu extends Sprite{
		
		public static const TYPE_CLICK:String = "click";
		public static const TYPE_ROLL:String = "roll";
		public static const TYPE_NONE:String = "none";
		
		//params
		
		//private vars
		private var items:Array;
		private var selectionStatus:Array;
		
		private var _changeOnClick:Boolean;
		private var _changeOnRoll:Boolean;
		private var _clickable:Boolean;
		
		private var _selectedIndex:int;
		protected var _isVisible:Boolean;
		public var menuParent:Menu;
		private var _keepSelected:int;
		
		
		public var debug:Boolean = false;
		
		//_______________________________________________________________
		//public functions
		
		public function Menu() 
		{ 
			_changeOnClick = true;
			_changeOnRoll = true;
			_clickable = true;
			reset();
		}
		
		public function reset():void
		{
			//while (this.numChildren) this.removeChildAt(0);
			items = new Array();
			selectionStatus = new Array();
			_selectedIndex = -1;
			_keepSelected = -1;
		}
		
		
		public override function addChild(_obj:DisplayObject):DisplayObject
		{
			addMenuItem(_obj);
			return super.addChild(_obj);
		}
		
		
		public function addMenuItem(_obj:DisplayObject):void
		{
			if(!_obj is InteractiveObject) throw new Error("addChild("+_obj+"), child must be an InteractiveObject");
			items.push(_obj);
			selectionStatus.push(TYPE_NONE);
			
			var i:int = items.length - 1;
			
			items[i].buttonMode = true;
			items[i].addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			items[i].addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			items[i].addEventListener(MouseEvent.CLICK, onClick);
			
			items[i].unselect();
			
			var _objc:DisplayObjectContainer = _obj as DisplayObjectContainer;
			//if(_objc!=null) _objc.mouseChildren = false;
			if (_objc is InteractiveObject) InteractiveObject(_objc).mouseEnabled = false;
		}
		
		
		
		public function super_addChild(_obj:DisplayObject):DisplayObject
		{
			return super.addChild(_obj);
		}
		
		public function unselect():void
		{
			var len:int = items.length;
			for(var i:int=0;i<len;i++){
				unselectItem(i);
				items[i].buttonMode = true;
			}
			_selectedIndex = -1;
		}
		
		public function getItemAt(i:int):*
		{
			return items[i];
		}
		
		public function show():void
		{
			this.visible = true;
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function isVisible():Boolean
		{
			return _isVisible;
		}
		
		
		//new, MenuRecursive
		public function keepSelected(_id:int):void
		{
			_keepSelected = _id;
			
		}
		
		public function unkeepSelected(_id:int):void
		{
			if (_id != _keepSelected) return;
			_keepSelected = -1;
			unselectItem(_id);
		}
		
		
		
		
		
		
		//_______________________________________________________________
		//set/get
		
		
		public function set changeOnClick(v:Boolean):void
		{
			_changeOnClick = v;
		}
		public function set changeOnRoll(v:Boolean):void
		{
			_changeOnRoll = v;
		}
		
		public function set clickable(value:Boolean):void 
		{
			_clickable = value;
		}
		
		public function set selectedIndex(id:int):void
		{
			if(id>items.length || id<-1) throw new Error("property selectedIndex must be within -1 and "+(items.length-1));
			if (items.length == 0) throw new Error("class Menu :: you need to add some elements before setting selectedIndex");
			if (id == -1) this.unselect();
			else clickHandler(id);
		}
		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get length():uint
		{
			return items.length;
		}
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function getIndByObj(_obj:DisplayObject):int
		{
			var len:int = items.length;
			var imitem:IMenuItem;
			for (var i:int = 0; i < len; i++) {
				//imitem = IMenuItem(items[i]);
				//if (imitem.getMouseZone() == _obj) return i;
				if(items[i]==_obj) return i;
			}
			throw new Error("Obj indice "+i+" has not been found");
		}
		
		
		protected function selectItem(id:int):void
		{
			//trace("Menu.selectItem(" + id + ") selectionStatus[id] : "+selectionStatus[id]);
			var i:IMenuItem = items[id];
			//if (!i.isSelected()) {
			if(selectionStatus[id]!=TYPE_CLICK) {
				i.select(TYPE_CLICK);
				selectionStatus[id] = TYPE_CLICK;
				
			}
		}
		
		protected function unselectItem(id:int):void
		{
			if (id == _keepSelected) return;
			var i:IMenuItem = items[id];
			//if(i.isSelected()) items[id].unselect();
			
			if (selectionStatus[id] != TYPE_NONE) {
				items[id].unselect();
				selectionStatus[id] = TYPE_NONE;	//test
			}
		}
		
		private function clickHandler(id:int):void
		{
			_keepSelected = -1;
			_selectedIndex = id;
			var len:int = items.length;
			for (var i:int = 0; i < len; i++) {
				if (i != id) {
					unselectItem(i);
					items[i].buttonMode = true;
				}
			}
			selectItem(id);
			items[id].buttonMode = false;
		}
		
		private function isInRectangle(_pt:Point, _rect:Rectangle):Boolean
		{
			if (_pt.x > _rect.left && _pt.x < _rect.right && _pt.y > _rect.top && _pt.y < _rect.bottom) return true;
			return false;
		}
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onMouseOver(e:MouseEvent):void
		{
			
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			//trace("onMouseOver "+id);
			if (!items[id].buttonMode || !_changeOnRoll) return;
			
			items[id].select(TYPE_ROLL);
			selectionStatus[id] = TYPE_ROLL;
			
			dispatchEvent(new MenuEvent(MenuEvent.ROLLOVER, id));
			
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			//trace("Menu.onMouseOut______________________" + id);
			
			//trace("onMouseOut "+id);
			if(!items[id].buttonMode || !_changeOnRoll) return;
			//items[id].unselect();
			unselectItem(id);
			
			dispatchEvent(new MenuEvent(MenuEvent.ROLLOUT, id));
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (!_clickable) return;
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			//trace("onClick "+id);
			if (!items[id].buttonMode) return;
			if (_changeOnClick) clickHandler(id);
			
			dispatchEvent(new MenuEvent(MenuEvent.CLICK, id));
		}
		
	}
	
}






/*
TODO / TOTHINKABOUT :
	- eventuellement : ne plus en faire un displayObject -> plus facile pour cumuler avec d'autres classes
	(encore qu'apparement, y'a pas de conflit, si on refait un addChild derriere, il change pas de displayList)
	- si l'effet de rollover et différent e l'effet de selection : pas pris en compte
	- si besoin de sous menu, voir comment ça peut se goupiller (cumul de menu?)
	

DESCRIPTION :
permet d'integrer un menu standard avec :
	- gestion des elements clickable
	- deselection des autres elements
la propriété changeOnClick (defaut:true) permet de spécifier si le click entraine directement un changement d'état
si false : il faut passer par l'evenement MenuEvent.CLICK et changer la propriété selectedIndex


METHODS :
reset():void;
addChild(obj:DisplayObject):DisplayObject;


PROPERTY :
selectedIndex:int (change l'élement actif)
changeOnClick:Boolean	(defaut:true, specifie si le click entraine un changement d'état)
changeOnRoll:Boolean	(defaut:true, specifie si le rollover entraine un changement d'etat)


INTEGRATION :

//il faut créer une classe correspondant aux élement du menu (MenuItem) et qui implemente IMenuItem :

package  {
	import data.display.FilledRectangle;
	import flash.display.MovieClip;
	import data.layout.menu.IMenuItem;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.IME;
	
	public class MenuItem extends MovieClip implements IMenuItem{
		
		public function MenuItem() 
		{ 
		}
		public function select():void
		{
			//gotoAndStop();
		}
		public function unselect():void
		{
			//gotoAndStop();
		}
	}
}


import data.layout.menu.Menu;
import data.layout.menu.MenuEvent;
import MenuItem;

//MI1 est une classe qui extends MenuItem
var mi1 = new MI1();
var mi2 = new MI1();
var mi3 = new MI1();
mi1.x = 000;
mi2.x = 100;
mi3.x = 200;

var menu = new Menu();
addChild(menu);
menu.addChild(mi1);
menu.addChild(mi2);
menu.addChild(mi3);
menu.selectedIndex = 1;

menu.addEventListener(MenuEvent.CLICK, onClickMenu);
function onClickMenu(e:MenuEvent):void
{
	trace("onClickMenu("+e+")");
	trace(e.id);
	menu.selectedIndex = e.id;
}
*/