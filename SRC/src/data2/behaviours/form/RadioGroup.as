package data2.behaviours.form 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vincent
	 */
	public class RadioGroup extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var _items:Array;
		private var _exclusion:Boolean;
		private var _checked:Boolean;
		
		public function RadioGroup(__exclusion:Boolean) 
		{
			_exclusion = __exclusion;
			reset();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function reset():void
		{
			_items = new Array();
		}
		
		public function add(_item:*):void
		{
			if (!_item is InputCheckbox && !_item is RadioGroup) throw new Error("arg must be of type Checkbox or RadioGroup");
			if (_item is InputCheckbox) {
				InputCheckbox(_item).addEventListener(CheckboxEvent.CHECK, onCheckCB);
				InputCheckbox(_item).addEventListener(CheckboxEvent.UNCHECK, onUncheckCB);
			}
			else if (_item is RadioGroup) {
				RadioGroup(_item).addEventListener(CheckboxEvent.CHECK, onCheckCB);
				RadioGroup(_item).addEventListener(CheckboxEvent.UNCHECK, onUncheckCB);
			}
			_items.push(_item);
		}
		
		
		public function set checked(value:Boolean):void
		{
			_checked = value;
			setSelection(value);
		}
		
		public function get checked():Boolean
		{
			return _checked;
		}
		
		public function get length():int
		{
			return _items.length;
			
		}
		
		public function getItem(_index:int):*
		{
			return _items[_index];
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function setSelection(_value:Boolean, _except:*=null):void
		{
			var _len:int = _items.length;
			for (var i:int = 0; i < _len; i++) {
				if (_items[i] != _except) {
					if (_items[i] is InputCheckbox) InputCheckbox(_items[i]).checked = _value;
					else if(_items[i] is RadioGroup) RadioGroup(_items[i]).checked = _value;
				}
			}
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onCheckCB(e:CheckboxEvent):void 
		{
			if(_exclusion) setSelection(false, e.target);
			dispatchEvent(new CheckboxEvent(CheckboxEvent.CHECK));
		}
		
		private function onUncheckCB(e:CheckboxEvent):void 
		{
			var _len:int = _items.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (_items[i] is InputCheckbox && InputCheckbox(_items[i]).checked) return;
				else if(_items[i] is RadioGroup && RadioGroup(_items[i]).checked) return;
			}
			dispatchEvent(new CheckboxEvent(CheckboxEvent.UNCHECK));
		}
		
		
	}

}