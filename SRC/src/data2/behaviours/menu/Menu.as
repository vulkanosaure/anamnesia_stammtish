package data2.behaviours.menu {
	
	import data2.behaviours.Behaviour;
	import data2.states.StateEngine;
	import data2.states.StateEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Menu extends Behaviour{
		
		public static const TYPE_CLICK:String = "click";
		public static const TYPE_ROLL:String = "roll";
		public static const TYPE_NONE:String = "none";
		
		
		
		//params
		
		//private vars
		private var selectionStatus:Array;
		
		private var _changeOnClick:Boolean;
		private var _changeOnRoll:Boolean;
		private var _clickable:Boolean;
		
		private var _selectedIndex:int;
		private var _keepSelected:int;
		private var _items:Array;
		private var _disableRoll:Boolean;
		
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Menu() 
		{ 
			_changeOnClick = true;
			_changeOnRoll = true;
			_clickable = true;
			_disableRoll = false;
			reset();
		}
		
		
		public function reset():void
		{
			_items = new Array();
			selectionStatus = new Array();
			_selectedIndex = -1;
			_keepSelected = -1;
		}
		
		
		
		
		
		
		public function unselect():void
		{
			var len:int = _items.length;
			for(var i:int=0;i<len;i++){
				unselectItem(i);
				_items[i].buttonMode = true;
			}
			_selectedIndex = -1;
		}
		
		public function getItemAt(i:int):*
		{
			return _items[i];
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
			if(id>_items.length || id<-1) throw new Error("property selectedIndex must be within -1 and "+(_items.length-1));
			if (_items.length == 0) throw new Error("you need to add some elements before setting selectedIndex");
			if (id == -1) this.unselect();
			else clickHandler(id);
		}
		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get length():uint
		{
			return _items.length;
		}
		
		public function set disableRoll(value:Boolean):void { _disableRoll = value; }
		
		
		
		override public function update():void 
		{
			StateEngine.addEventListener(StateEvent.COMPLETE, onStateEngineComplete);
			
		}
		
		
		
		
		
		private function onStateEngineComplete(e:StateEvent):void 
		{
			trace("Menu.onStateEngineComplete");
			//todo :update
			
			if (childrens == null) return;
			var _len:int = childrens.length;
			_items = new Array();
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:DisplayObject = DisplayObject(childrens[i]);
				//trace("obj : " + _obj + ", name : " + _obj.name);
				
				if (_obj.name != "separatorInstance") {
					
					if (!(_obj is Sprite)) throw new Error("child " + _obj + " must be a Sprite");
					selectionStatus.push(TYPE_NONE);
					
					var _sp:Sprite = Sprite(_obj);
					_sp.buttonMode = true;
					_sp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					_sp.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					_sp.addEventListener(MouseEvent.CLICK, onClick);
					
					//IMenuItem(_obj).unselect();
					stateEngineUnselectItem(_obj);
					
					_sp.mouseEnabled = false;
					_items.push(_sp);
				}
				
				
			}
		}
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		protected function selectItem(id:int):void
		{
			//trace("Menu.selectItem(" + id + ") selectionStatus[id] : "+selectionStatus[id]);
			//var i:IMenuItem = _items[id];
			var _dobj:DisplayObject = DisplayObject(_items[id]);
			
			if(selectionStatus[id]!=TYPE_CLICK) {
				//i.select(TYPE_CLICK);
				stateEngineSelectItem(_dobj, TYPE_CLICK);
				selectionStatus[id] = TYPE_CLICK;
				
			}
		}
		
		protected function unselectItem(id:int):void
		{
			if (id == _keepSelected) return;
			//var i:IMenuItem = _items[id];
			var _dobj:DisplayObject = DisplayObject(_items[id]);
			
			if (selectionStatus[id] != TYPE_NONE) {
				//_items[id].unselect();
				stateEngineUnselectItem(_dobj);
				selectionStatus[id] = TYPE_NONE;
			}
		}
		
		private function clickHandler(id:int):void
		{
			_keepSelected = -1;
			_selectedIndex = id;
			var len:int = _items.length;
			for (var i:int = 0; i < len; i++) {
				if (i != id) {
					unselectItem(i);
					_items[i].buttonMode = true;
				}
			}
			selectItem(id);
			_items[id].buttonMode = false;
		}
		
		private function isInRectangle(_pt:Point, _rect:Rectangle):Boolean
		{
			if (_pt.x > _rect.left && _pt.x < _rect.right && _pt.y > _rect.top && _pt.y < _rect.bottom) return true;
			return false;
		}
		
		
		private function stateEngineUnselectItem(_item:DisplayObject):void
		{
			//trace("stateEngineUnselectItem(" + _item + ")");
			StateEngine.buttonOut(_item);
		}
		
		private function stateEngineSelectItem(_item:DisplayObject, _type:String):void
		{
			//todo : type
			//trace("stateEngineSelectItem(" + _item + ", " + _type + ")");
			
			if (_type != TYPE_ROLL || !_disableRoll) {
				
				StateEngine.buttonOver(_item);
			}
		}
		
		private function getIndByObj(_obj:DisplayObject):int
		{
			var len:int = _items.length;
			for (var i:int = 0; i < len; i++) {
				if(_items[i]==_obj) return i;
			}
			throw new Error("Obj " + _obj + " wasn't found");
		}
		
		
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onMouseOver(e:MouseEvent):void
		{
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			/*trace("onMouseOver " + id);
			trace(DisplayObject(_items[id]).name);*/
			if (!_items[id].buttonMode || !_changeOnRoll) return;
			
			//IMenuItem(_items[id]).select(TYPE_ROLL);
			stateEngineSelectItem(DisplayObject(_items[id]), TYPE_ROLL);
			selectionStatus[id] = TYPE_ROLL;
			
			dispatchEvent(new MenuEvent(MenuEvent.ROLLOVER, id));
			
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			//trace("Menu.onMouseOut______________________" + id);
			
			//trace("onMouseOut "+id);
			if(!_items[id].buttonMode || !_changeOnRoll) return;
			//_items[id].unselect();
			unselectItem(id);
			
			dispatchEvent(new MenuEvent(MenuEvent.ROLLOUT, id));
		}
		
		
		
		private function onClick(e:MouseEvent):void
		{
			if (!_clickable) return;
			var id:int = getIndByObj(e.currentTarget as DisplayObject);
			//trace("onClick "+id);
			
			//if (!_items[id].buttonMode) return;
			if (_changeOnClick) clickHandler(id);
			
			dispatchEvent(new MenuEvent(MenuEvent.CLICK, id));
		}
		
		
		
	}
	
}