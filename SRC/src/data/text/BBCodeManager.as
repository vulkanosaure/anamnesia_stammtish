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
	
	
	public class BBCodeManager{
		
		
		var items:Array;
		
		public function BBCodeManager() 
		{ 
			items = new Array();
		}
		
		public function add(_srcmarkup1:String, _srcmarkup2:String, _dstmarkup1:String, _dstmarkup2:String, ... args):void
		{
			//trace("args : "+args);
			var obj:Object = new Object();
			obj.srcmarkup1 = _srcmarkup1;
			obj.srcmarkup2 = _srcmarkup2;
			obj.dstmarkup1 = _dstmarkup1;
			obj.dstmarkup2 = _dstmarkup2;
			obj.args = args;
			items.push(obj);
		}
		
		
		
		
		public function transform(_str:String):String
		{
			//...
			var _m1, _m2, _m3, _m4:String;
			var _args:Array;
			var _p:String;
			var _reg:RegExp;
			var _regparam:RegExp;
			var _len:int;
			for(var i in items){
				
				_m1 = items[i].srcmarkup1;
				_m2 = items[i].srcmarkup2;
				_m3 = items[i].dstmarkup1;
				_m4 = items[i].dstmarkup2;
				_args = items[i].args;
				
				_len = (_args!=null) ? _args.length : 0;
				for(var j:int=0;j<_len;j++){
					_p = _args[j];
					_m1 = _m1.replace(_p, "([\\s\\S]*?)");
					_m3 = _m3.replace(_p, "$"+(j+1));
				}
				
				_reg = new RegExp(_m1+"(.+?)"+_m2, "sg");
				_str = _str.replace(_reg, _m3 + "$" + (_len + 1) + _m4);
				
			}
			return _str;
		}
		
		
		
		
		
		
		
		
		//_________________________________________________________
		//events
		
		
		
	}
	
}