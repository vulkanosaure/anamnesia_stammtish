package data.events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Vincent
	 */
	public class MultipleEventListener
	{
		//_______________________________________________________________________________
		// properties
		
		var _events:Array;
		var _func:Function;
		var _occured:Array;
		
		public function MultipleEventListener() 
		{
			_events = new Array();
			_occured = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function addEvent(_dispatcher:EventDispatcher, _evt:String):void
		{
			_events.push( { "dispatcher" : _dispatcher, "evt" : _evt } );
			_dispatcher.addEventListener(_evt, onEvent);
		}
		
		
		public function setFunction(_f:Function):void
		{
			_func = _f;
		}
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		private function allEvtOccured():Boolean
		{
			var _len:int = _events.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (!occured(EventDispatcher(_events[i]["dispatcher"]), _events[i]["evt"])) return false;
			}
			return true;
		}
		
		private function occured(_dispatcher:EventDispatcher, _evt:String):Boolean
		{
			var _len:int = _occured.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (_occured[i]["dispatcher"] == _dispatcher && _occured[i]["evt"] == _evt) return true;
			}
			return false;
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onEvent(e:Event):void 
		{
			trace("MultipleEventListener.onEvent " + e.type + ", " + e.currentTarget);
			_occured.push({ "dispatcher" : e.currentTarget, "evt" : e.type });
			if (allEvtOccured()) {
				trace("yes");
				_func();
			}
			else trace("no yet");
		}
		
	}

}