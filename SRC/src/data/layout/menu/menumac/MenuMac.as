/*
 * gère la couche affichage
 * 
 * peut etre horizontal ou vertical
 * gérer les limites
 * gérer l'alignement des items
 * 
 * 
 * 
 * */

package data.layout.menu.menumac 
{
	import data.layout.menu.Menu;
	import data.layout.menu.MenuEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class MenuMac extends Menu
	{
		//_______________________________________________________________________________
		// properties
		
		public static const MODE_HORIZONTAL:String = "modeHorizontal";
		public static const MODE_VERTICAL:String = "modeVertical";
		
		
		//params
		private var _mode:String;
		private var _valign:Number;
		private var _halign:Number;
		private var _size:Number;
		
		private var _propDimension:String;
		private var _propPosition:String;
		
		
		
		public function MenuMac() 
		{
			super();
		}
		
		
		
		public function init():void
		{
			//trace("MenuMac.init");
			if (!isNaN(_halign) && _mode == MODE_HORIZONTAL) throw new Error("you cannot set _halign when using HORIZONTAL mode");
			if (!isNaN(_valign) && _mode == MODE_VERTICAL) throw new Error("you cannot set _valign when using VERTICAL mode");
			
			_propDimension = (_mode == MODE_HORIZONTAL) ? "width" : "height";
			_propPosition = (_mode == MODE_HORIZONTAL) ? "x" : "y";
			
			this.updatePositions();
			
			var _len:int = this.length;
			var _item:MenuMacItem;
			
			
			for (var i:int = 0; i < _len; i++) {
				_item = this.getItemAt(i) as MenuMacItem;
				_item.addEventListener(MenuMacEvent.ENTER_TWEEN, onEnterTween);
				
				positionItemInternal(_item);
			}
			
		}
		
		
		
		override public function addChild(_obj:DisplayObject):DisplayObject 
		{
			return super.addChild(_obj);
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// setter / getter
		
		public function set mode(value:String):void 
		{
			_mode = value;
		}
		
		public function set valign(value:Number):void 
		{
			_valign = value;
		}
		
		public function set halign(value:Number):void 
		{
			_halign = value;
		}
		
		public function set size(value:Number):void 
		{
			_size = value;
		}
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function updatePositions():void
		{
			var _len:uint = this.length;
			var _item:MenuMacItem;
			
			var _cumul:Number = 0;
			var _interline:Number = getSpaceAllowed(_size, _propDimension);
			
			for (var i:int = 0; i < _len; i++) {
				_item = this.getItemAt(i) as MenuMacItem;
				_item[_propPosition] = _cumul;
				
				//if not last loop
				if (i < _len - 1) _cumul += _item[_propDimension] + _interline;
			}
		}
		
		private function positionItemInternal(_item:MenuMacItem):void
		{
			var _len:uint = _item.numChildren;
			var _child:DisplayObject;
			
			for (var i:int = 0; i < _len; i++) {
				_child = _item.getChildAt(i);
				if(!isNaN(_halign)) _child.x = - _child.width * _halign;
				if(!isNaN(_valign)) _child.y = - _child.height * _valign;
			}
		}
		
		private function getSpaceAllowed(_size:Number, _propdim:String):Number
		{
			var _cumulsize:Number = 0;
			var _len:uint = this.length;
			var _item:MenuMacItem;
			for (var i:int = 0; i < _len; i++) {
				_item = this.getItemAt(i) as MenuMacItem;
				_cumulsize += _item[_propdim];
			}
			return (_size - _cumulsize) / (_len - 1);
		}
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onEnterTween(e:MenuMacEvent):void 
		{
			//trace("onEnterTween");
			this.updatePositions();
			this.dispatchEvent(new MenuEvent(MenuEvent.MOVE, -1));
		}
		
		
		
	}

}