package data2.fx.dragndrop 
{
	import data2.math.Math2;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class DragManager extends EventDispatcher
	{
		private var _dobjs:Array;
		private var _recipients:Array;
		private var _enabled:Boolean;
		private var last_coords:Point;
		
		private var _margin:Number = 40;
		
		public function DragManager() 
		{
			_dobjs = new Array();
			_recipients = new Array();
			_enabled = false;
			
		}
		
		
		public function reset():void
		{
			var _len:int = _dobjs.length;
			for (var i:int = 0; i < _len; i++) {
				_dobjs[i].position = -1;
				
			}
		}
		
		public function addDragable(_dobj:Sprite):void
		{
			var _obj:Object = new Object();
			_obj.dobj = _dobj;
			_obj.position = -1;
			
			_dobjs.push(_obj);
			_dobj.buttonMode = true;
			_dobj.addEventListener(MouseEvent.MOUSE_DOWN, onMousedown);
			_dobj.addEventListener(MouseEvent.MOUSE_UP, onMouseup);
		}
		
		public function addRecipient(_point:Point):void
		{
			var _obj:Object = new Object();
			_obj.point = _point;
			_recipients.push(_obj);
		}
		
		
		public function enable():void
		{
			_enabled = true;
		}
		
		public function disable():void
		{
			_enabled = false;
		}
		
		
		
		
		
		
		
		//____________________________________________________________________
		//set / get
		
		
		public function set margin(value:Number):void 
		{
			_margin = value;
		}
		
		public function get dobjs():Array 
		{
			return _dobjs;
		}
		
		
		
		
		
		
		
		
		//____________________________________________________________________
		//private functions
		
		
		private function getIndexRecipient(_x:Number, _y:Number):int 
		{
			var _len:int = _recipients.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _recipient:Object = _recipients[i];
				var pttest:Point = _recipient.point;
				var _distance:Number = Math2.getHypotenuse(_x, _y, pttest.x, pttest.y);
				if (_distance <= _margin) return i;
			}
			return -1;
		}
		
		private function isFilled(_index:int):Boolean
		{
			var _len:int = _dobjs.length;
			for (var i:int = 0; i < _len; i++) {
				var _obj:Object = _dobjs[i];
				if (_obj.position == _index) return true;
			}
			return false;
		}
		
		private function getIndexByDobj(_dobj:DisplayObject):int
		{
			var _len:int = _dobjs.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (_dobj == _dobjs[i].dobj) return i;
			}
			return -1;
		}
		
		private function allFilled():Boolean
		{
			var _len:int = _recipients.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (!isFilled(i)) return false;
			}
			return true;
		}
		
		
		
		//_____________________________________________________________________
		//events
		
		private function onMousedown(e:MouseEvent):void 
		{
			if (!_enabled) return;
			
			var _sp:Sprite = Sprite(e.currentTarget);
			_sp.startDrag();
			last_coords = new Point(_sp.x, _sp.y);
			_sp.parent.addChild(_sp);
			
			
			var _index:int = getIndexByDobj(_sp);
			trace("_index : " + _index);
			_dobjs[_index].position = -1;
			
			this.dispatchEvent(new DragManagerEvent(DragManagerEvent.DRAG));
		}
		
		
		
		
		private function onMouseup(e:MouseEvent):void 
		{
			if (!_enabled) return;
			
			var _sp:Sprite = Sprite(e.currentTarget);
			_sp.stopDrag();
			var _index:int = getIndexByDobj(_sp);
			trace("_index : " + _index);
			
			var _indexRecipient:int = getIndexRecipient(_sp.x, _sp.y);
			trace("_indexRecipient : " + _indexRecipient);
			
			if (_indexRecipient != -1) {
				if (!isFilled(_indexRecipient)) {
					trace("    ---- NOT filled");
					var _recipient:Object = _recipients[_indexRecipient];
					_sp.x = _recipient.point.x;
					_sp.y = _recipient.point.y;
					_dobjs[_index].position = _indexRecipient;
					this.dispatchEvent(new DragManagerEvent(DragManagerEvent.DROP));
					if (allFilled()) {
						this.dispatchEvent(new DragManagerEvent(DragManagerEvent.COMPLETE));
					}
				}
				else {
					trace("    ---- filled");
					_sp.x = last_coords.x;
					_sp.y = last_coords.y;
					this.dispatchEvent(new DragManagerEvent(DragManagerEvent.DROP_ERROR));
				}
			}
		}
		
		
		
		
	}

}