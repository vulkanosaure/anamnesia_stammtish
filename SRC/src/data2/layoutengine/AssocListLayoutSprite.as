package data2.layoutengine 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Vincent
	 */
	public class AssocListLayoutSprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var _items:Array;
		
		public function AssocListLayoutSprite() 
		{
			_items = new Array();
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function add(_ls:LayoutSprite):void
		{
			_items.push(_ls);
		}
		
		public function getAssoc(_dobj:DisplayObject):LayoutSprite
		{
			var _len:int = _items.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _ls:LayoutSprite = LayoutSprite(_items[i]);
				if (_ls.attachedDobj == _dobj) return _ls;
			}
			return null;
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}