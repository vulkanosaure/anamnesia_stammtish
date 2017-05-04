


package data.text {
	
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	
	public class LoadedTextField extends TextField{
		
		private const MARGIN:Number = 2;
		
		private var loader_src:URLLoader;
		private var loader_css:URLLoader;
		private var _css:StyleSheet;
		private var _maxHeight:Number;
		
		public var debug:Boolean = false;
		
		
		public function LoadedTextField() 
		{ 
			loader_src = new URLLoader();
			loader_src.addEventListener(Event.COMPLETE, onCompleteSRC);
			
			loader_css = new URLLoader();
			loader_css.addEventListener(Event.COMPLETE, onCompleteCSS);
			
			_css = new StyleSheet();
			_maxHeight = -1;
			
			
			//propriétés par défaut
			//this.condenseWhite = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.multiline = true;
			this.wordWrap = true;
			//this.embedFonts = false;
			this.mouseWheelEnabled = false;
			
			this.addEventListener(TextEvent.LINK, onLink);
			
		}
		
		
		
		
		public override function set multiline(v:Boolean):void
		{
			super.multiline = v;
			wordWrap = v;
		}
		
		public override function set backgroundColor(v:uint):void
		{
			this.background = true;
			super.backgroundColor = v;
		}
		
		public override function set htmlText(_str:String):void
		{
			if(debug) trace("LoadedTextField.set htmlText ("+_str+")");
			var _content:String = removeDoubleLineBreaks(_str);
			super.htmlText = _content;
			if (_maxHeight != -1) updateMaxHeight(_maxHeight);
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.UPDATE));
			
			var _listImg:Array = getListImgID(_content);
			for (var i:int = 0; i < _listImg.length; i++) registerImg(_listImg[i]);
			
		}
		
		public function set src(_url:String)
		{
			if(debug) trace("LoadedTextField.set src ("+_url+")");
			loader_src.load(new URLRequest(_url));
		}
		
		public function set css(_url:String)
		{
			loader_css.load(new URLRequest(_url));
			this.styleSheet = _css;
		}
		
		
		override public function set selectable(value:Boolean):void 
		{
			super.selectable = value;
			this.mouseEnabled = value;
		}
		
		
		
		
		
		public function set maxHeight(value:Number):void 
		{
			_maxHeight = value;
			if (_maxHeight == -1) {
				this.autoSize = TextFieldAutoSize.LEFT;
			}
			else {
				this.autoSize = TextFieldAutoSize.NONE;
				updateMaxHeight(_maxHeight);
			}
		}
		
		
		public static function removeDoubleLineBreaks(str:String):String
		{
			str = str.replace(/\r\n/g, "\n");
			return str;
		}
		
		/*
		public static function transformHtmlChars(str:String):String
		{
			str = str.replace(/&lt;/g, "<");
			str = str.replace(/&gt;/g, ">");
			str = str.replace(/&amp;/g, "&");
			return str;
		}
		*/
		
		
		private function getListImgID(_content:String):Array
		{
			var regex:RegExp = new RegExp("<img(.+?)id=('|\")([0-9a-zA-Z\.-_]*?)('|\")", "g");
			var _matches:Array;
			var _list:Array = new Array();
			
			if (debug) trace("\nLoadedTextField.getListImgID___________________________");
			do {
				_matches = regex.exec(_content);
				if (_matches != null) _list.push(_matches[3]);
				if (debug) trace("  _matches : " + _matches);
			}
			while (_matches != null);
			return _list;
		}
		
		
		private function registerImg(_id:String):void
		{
			var _loader:Loader = Loader(this.getImageReference(_id));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
		}
		
		
		
		private function updateMaxHeight(_max:int):void
		{
			/*
			var lm:TextLineMetrics;
			var count:Number = MARGIN * 2;
			for (var i:int = 0; i < _max; i++) {
				lm = this.getLineMetrics(i);
				if (count + lm.height > _max) break;
				count += lm.height;
			}
			
			this.height = count;
			*/
			this.height = _max;
		}
		
		public function get rheight():Number
		{
			var lm:TextLineMetrics;
			var count:Number = MARGIN * 2;
			for (var i:int = 0; i < this.numLines; i++) {
				lm = this.getLineMetrics(i);
				count += lm.height;
			}
			return count;
		}
		
		
		
		
		
		
		
		
		
		//_________________________________________________________
		//events
		
		private function onCompleteSRC(e:Event)
		{
			var data:String = removeDoubleLineBreaks(e.target.data);
			super.htmlText = data;
			if (_maxHeight != -1) updateMaxHeight(_maxHeight);
			
			dispatchEvent(new Event("UPDATE"));			//rétrocompatibilité (don't use)
			dispatchEvent(new Event("SRC_LOADED"));		//rétrocompatibilité (don't use)
			
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.UPDATE));
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.SRC_LOADED));
		}
		
		private function onCompleteCSS(e:Event)
		{
			_css.parseCSS(e.target.data);
			this.styleSheet = _css;
			if (_maxHeight != -1) updateMaxHeight(_maxHeight);
			
			dispatchEvent(new Event("UPDATE"));			//rétrocompatibilité (don't use)
			dispatchEvent(new Event("CSS_LOADED"));		//rétrocompatibilité (don't use)
			
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.UPDATE));
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.CSS_LOADED));
		}
		
		private function onLink(e:TextEvent):void
		{
			dispatchEvent(new Event(e.text));			//rétrocompatibilité (don't use)
			
			var evt:LoadedTextFieldEvent = new LoadedTextFieldEvent(LoadedTextFieldEvent.CLICK_LINK);
			evt.label = e.text;
			dispatchEvent(evt);
		}
		
		
		private function onImgLoaded(e:Event):void 
		{
			if(debug) trace("\nLoadedTextField.onImgLoaded________________________________________\n");
			dispatchEvent(new LoadedTextFieldEvent(LoadedTextFieldEvent.UPDATE));
		}
		
	}
	
}



/*
UTILISATION :

import data.text.LoadedTextField;
import flash.text.TextLineMetrics;
import flash.text.TextLineMetrics;
import flash.text.TextLineMetrics;
import flash.text.TextLineMetrics;
import flash.text.TextLineMetrics;
var tf = new LoadedTextField();
addChild(tf);
tf.src = "src.txt";
tf.css = "style.css";
tf.width = 200;
tf.embedFonts = true;		//defaut:false
//toutes les propriétés de TextField...

REMARQUES :

il est conseillés d'utiliser des fichiers text au format UTF-8
(meilleure compatibilité pour certains signes comme '€')
LoadedTextField hérite de TextField et en possède donc toutes les propriétés
*/