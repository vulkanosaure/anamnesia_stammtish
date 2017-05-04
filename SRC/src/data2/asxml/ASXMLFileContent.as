package data2.asxml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ASXMLFileContent extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var _name:String;
		private var _content:String;
		private var _args:Object;
		private var _instruction:String;
		
		private var _loader:URLLoader;
		
		
		public function ASXMLFileContent(__name:String, __args:Object, __instruction:String) 
		{
			//trace("new ASXMLFileContent "+__name);
			_name = __name;
			_args = __args;
			_instruction = __instruction;
			
			_content = "";
			_loader = new URLLoader();
			
			
		}
		
		public function get name():String { return _name; }
		
		public function get content():String { return _content; }
		
		public function get instruction():String {return _instruction;}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function load():void
		{
			_loader.load(new URLRequest(_name));
			_loader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		private function convertArg(_data:String):String 
		{
			var _tab:Array = _data.match(/{arg:(.+?)}/g);
			//trace("_______________arg _tab : " + _tab);
			
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _argstr:String = _tab[i];
				
				var _tabkey:Array = _argstr.match(/{arg:(.+?)}/);
				var _argkey:String = _tabkey[1];
				var _argvalue:String = _args[_argkey];
				
				if (_argvalue == null) throw new Error("ASXML import : arg \"" + _argkey + "\" is not defined for file " + _name);
				//trace("   _argkey : " + _argkey + ", _argvalue : " +_argvalue);
				_data = _data.replace(_argstr, _argvalue);
			}
			
			return _data;
			
		}
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onComplete(e:Event):void 
		{
			_content = e.target.data;
			_content = convertArg(_content);
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			
		}
		
		
		
	}

}