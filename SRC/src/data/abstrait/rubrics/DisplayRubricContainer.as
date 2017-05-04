package data.abstrait.rubrics 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DisplayRubricContainer extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		var items:Array;
		var cur_id:int;
		
		public function DisplayRubricContainer() 
		{
			items = new Array();
			cur_id = -1;
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function add(_displayRubric:DisplayRubric):void
		{
			items.push(_displayRubric);
			_displayRubric.hide();
		}
		
		public function goto(_id:int):void
		{
			trace("DisplayRubricContainer.goto(" + _id + ")");
			if(_id==cur_id) return;
			if(_id>=items.length) throw new Error("DisplayRubricContainer.goto(), arg 1 must be in interval [0;"+items.length+"[");
			
			hideAll();
			var _d:DisplayRubric = DisplayRubric(items[_id]);
			
			_d.show();
			
			cur_id = _id;
		}
		
		public function get length():uint
		{
			return items.length;
		}
		
		public function getItemAt(_ind):DisplayRubric
		{
			return DisplayRubric(items[_ind]);
		}
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function hideAll():void
		{
			trace("DisplayRubricContainer.hideAll()");
			//trace("DisplayRubricContainer.hideAll len : " + items.length);
			var _len:uint = items.length;
			for (var i:int = 0; i < _len; i++) {
				DisplayRubric(items[i]).hide();
			}
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}