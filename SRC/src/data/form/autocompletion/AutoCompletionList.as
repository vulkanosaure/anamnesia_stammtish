package data.form.autocompletion 
{
	import data.layout.BlockLayout;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Vincent
	 */
	public class AutoCompletionList extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var _list:Array;
		private var _layout:BlockLayout;
		private var _listItemClass:Class;
		
		public function AutoCompletionList() 
		{
			_layout = new BlockLayout();
			addChild(_layout);
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function add(_id:String, _type:String, _label:String):void
		{
			var _item:AutoCompletionListItem = new _listItemClass();
			_item.addEventListener(MouseEvent.CLICK, onClickItem);
			_item.setContent(_id, _type, _label);
			_layout.addChild(_item);
			_list.push(_item);
		}
		public function update():void
		{
			_layout.update();
		}
		
		public function reset():void
		{
			_layout.reset();
			_list = new Array();
			
			
		}
		
		public function getLabel(identry:String):String
		{
			var _len:int = _list.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _item:AutoCompletionListItem = AutoCompletionListItem(_list[i]);
				if (_item.id == identry) return _item.label;
			}
			throw new Error("entry id " + identry + " wasn't found");
		}
		
		public function set listItemClass(value:Class):void 
		{
			_listItemClass = value;
		}
		
		public function get listItemClass():Class { return _listItemClass; }
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onClickItem(e:MouseEvent):void 
		{
			var _item:AutoCompletionListItem = AutoCompletionListItem(e.currentTarget);
			trace("onClickItem " + _item.id);
			
			var _e:AutoCompletionEvent = new AutoCompletionEvent(AutoCompletionEvent.SELECT_ENTRY);
			_e.identry = _item.id;
			_e.typeentry = _item.type;
			this.dispatchEvent(_e);
			
		}
		
	}

}