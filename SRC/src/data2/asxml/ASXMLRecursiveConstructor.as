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
	public class ASXMLRecursiveConstructor extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static const PREFIX_IMPORT:String = "import ";
		private static const SUFIX_IMPORT:String = "";
		
		private var _loader:URLLoader;
		private var _data:String;
		private var _nbfilecomplete:int;
		private var _tabfiles:Array;
		
		
		public function ASXMLRecursiveConstructor() 
		{
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function init(__data:String):void
		{
			_data = __data;
			construct();
		}
		
		public function get data():String { return _data; }
		
		public function get tabfiles():Array {return _tabfiles;}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function construct():void
		{
			//parcours _content a la recherche de tous les import, les entres ds un tableau sans doublons
			
			_nbfilecomplete = 0;
			var _tab:Array = _data.match(/import\ ([\w\d_\-\/\.]+)(\ {.+})?/g);
			//trace("_tab : " + _tab);
			
			
			
			//pas d'import, fin du traitement
			if (_tab.length == 0) {
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			
			_tabfiles = new Array();
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _instruction:String = _tab[i];
				var _tab_arg:Array = _instruction.match(/\{([\w\d_]+?):([\w\d_\-\/\. %]+?)\}/g);
				var _tab_filename:Array = _instruction.match(/import\ ([\w\d_\-\/\. %]+)(\ {.+})?/);
				//trace("   _tab_arg : " + _tab_arg);
				//trace("   _tab_filename : " + _tab_filename);
				
				var _args:Object = new Object();
				for (var _argindex:String in _tab_arg) {
					var _argdesc:String = _tab_arg[_argindex];
					var _tabkeyvalue:Array = _argdesc.match(/\{([\w\d_]+?):([\w\d_\-\/\. %]+?)\}/);
					//trace("      _tabkeyvalue : " + _tabkeyvalue);
					_args[_tabkeyvalue[1]] = _tabkeyvalue[2];
				}
				
				var _filename:String = _tab_filename[1];
				/*
				trace("_args : ");
				for (var _key:String in _args) trace("   _arg " + _key + " : " + _args[_key]);
				*/
				
				//var _filename:String = getFilename(_tab[i]);
				//if (!fileExist(_tabfiles, _filename)) _tabfiles.push(new ASXMLFileContent(_filename, _args));
				_tabfiles.push(new ASXMLFileContent(_filename, _args, _instruction));
			}
			
			//trace("_tabfiles : " + _tabfiles);
			
			
			//load tout le contenu de ce tableau et stock le contenu dans un tableau associatif
			_len = _tabfiles.length;
			for (i = 0; i < _len; i++) 
			{
				var filecontent:ASXMLFileContent = ASXMLFileContent(_tabfiles[i]);
				filecontent.addEventListener(Event.COMPLETE, onFileContentComplete);
				filecontent.load();
			}
		}
		
		
		private function finishConstruct():void
		{
			//parcours _content et remplace les mentions import par le contenu associé
			var _len:int = _tabfiles.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var filecontent:ASXMLFileContent = ASXMLFileContent(_tabfiles[i]);
				var _regexp:RegExp = new RegExp(filecontent.instruction, "g");
				
				_data = _data.replace(_regexp, filecontent.content);
				
			}
			
		}
		
		
		
		
		
		
		
		private function getFilename(_instruction:String):String
		{
			var _len:int = _instruction.length;
			var _filename:String = _instruction.substr(PREFIX_IMPORT.length, _len - PREFIX_IMPORT.length - SUFIX_IMPORT.length);
			return _filename;
		}
		
		private function fileExist(_tab:Array, _filename:String):Boolean
		{
			var _len:int = _tab.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var obj:ASXMLFileContent = ASXMLFileContent(_tab[i]);
				if (obj.name == _filename) return true;
			}
			return false;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
		
		private function onFileContentComplete(e:Event):void 
		{
			_nbfilecomplete++;
			//trace("onFileContentComplete " + _nbfilecomplete);
			
			if (_nbfilecomplete == _tabfiles.length) {
				finishConstruct();
				construct();
				
			}
		}
		
	}

}