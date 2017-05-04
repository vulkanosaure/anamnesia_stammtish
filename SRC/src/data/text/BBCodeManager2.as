/*
UTILISATION :

contraintes : 
	les params (ex:url,target) doivent passer dans la 1ere balise
	les params doivent etre déclarés ds l'ordre


import data.text.BBCodeManager;
var bbcode = new BBCodeManager();
bbcode.add("<b>", "</b>", "<strong>", "</strong>");
bbcode.add("<centerarea>", "</centerarea>", "<p align='center'>", "</p>");
bbcode.add("<color value='X'>", "</color>", "<font color='X'>", "</font>", "X");
_str = bbcode.transform(_str);
*/


package data.text {
	
	
	public class BBCodeManager2{
		
		
		var items:Array;
		
		public function BBCodeManager2() 
		{ 
			items = new Array();
		}
		
		public function add(_style:String, _className:String):void
		{
			//trace("args : "+args);
			var obj:Object = new Object();
			obj.style = _style;
			obj.className = _className;
			items.push(obj);
			
		}
		
		
		
		
		public function transform(_str:String):String
		{
			var _len:int = items.length;
			var regex:RegExp;
			
			for (var i:int = 0; i < _len; i++) {
				//trace("i : " + i + ", style : " + items[i].style + ", className : " + items[i].className);
				regex = new RegExp("style=\""+items[i].style+"\"", "g");
				_str = _str.replace(regex, "class='"+items[i].className+"'");
			}
			//
			
			return _str;
		}
		
		
		
		
		
		
		
		
		//_________________________________________________________
		//events
		
		
		
	}
	
}