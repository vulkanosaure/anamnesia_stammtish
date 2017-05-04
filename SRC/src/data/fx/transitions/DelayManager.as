package data.fx.transitions 
{
	import data.utils.Delay;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DelayManager extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var items:Array;
		
		public function DelayManager() 
		{
			items = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function reset():void
		{
			deleteAll();
		}
		
		
		public function add(t:Number, f:Function, ...args):void
		{
			deleteItemWithFunction(f, args);
			
			var d:Delay = new Delay(t, f);
			d.params = args;
			items.push(d);
			
			//il faut supprimer tous les delay en cours appelant la mm fonction
		}
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private function deleteItemWithFunction(f:Function, _params:Array):void
		{
			var d:Delay;
			for (var i:* in items) {
				d = Delay(items[i]);
				if(d!=null && d.func == f){
					
					var sameParams:Boolean = true;
					var _lenparam:int = d.params.length;
					if (_lenparam != _params.length) sameParams = false;
					else {
						for (var j:int = 0; j < _lenparam; j++) {
							if (d.params[j] != _params[j]) sameParams = false;
						}
					}
					
					if (sameParams) {
						if (d.waiting) d.stop();
						items.splice(i, 1);
					}
					
				}
				
			}
		}
		
		
		
		private function deleteAll():void
		{
			var _d:Delay;
			var i:int;
			//trace("items.length : " + items.length + ", delays.length : " + delays.length);
			
			while(items.length > 0){
				//trace("delays[" + i + "] : " + delays[i]);
				_d = items[i];
				if (_d != null && _d.waiting) {
					_d.stop();
					_d = null;
				}
				items.splice(i, 1);
			}
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}