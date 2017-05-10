package data2.text 
{
	import data2.asxml.ClassManager;
	import data2.layoutengine.LayoutSprite;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class Text extends LayoutSprite
	{
		public static var DEFAULT_SELECTABLE:Boolean = true;
		public static var DEFAULT_DEBUGBORDER:Boolean = false;
		
		public static const VALIGN_TOP:String = "top";
		public static const VALIGN_BOTTOM:String = "bottom";
		public static const VALIGN_CENTER:String = "center";
		
		private const MARGIN:Number = 2;
		
		private var _tf:TextField;
		
		private var _value:String;
		private var _width:Number;
		private var _height:Number;
		private var _type:String;
		private var _multiline:Boolean;
		private var _embedFonts:Boolean;
		private var _antiAliasType:String;
		private var _selectable:Boolean;
		private var _debugBorder:Boolean;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _template:String;
		private var _cssinit:Boolean;
		private var _valign:String;
		private var _removeLineBreak:Boolean;
		
		private var _textformat:TextFormat = null;
		
		
		
		
		public function Text() 
		{
			_multiline = false;
			_embedFonts = false;
			_type = TextFieldType.DYNAMIC;
			_maxHeight = -1;
			_maxWidth = -1;
			_antiAliasType = AntiAliasType.NORMAL;
			_template = null;
			_selectable = Text.DEFAULT_SELECTABLE;
			_value = null;
			_cssinit = false;
			_debugBorder = DEFAULT_DEBUGBORDER;
			_valign = "";
			_removeLineBreak = false;
		}
		
		
		
		
		public function updateText():void
		{
			//_____________________________________________
			//creation du tf
			
			if (_tf == null) {
				
				if (_template != null) {
					
					var _skinClass:Class = ClassManager.getClassByClassPath(_template);
					if (_skinClass == null) throw new Error("Text.template : class \"" + _template + "\" is not registered");
					var _skinObj:Sprite = new _skinClass();
					
					if (_skinObj.numChildren == 1 && _skinObj.getChildAt(0) is TextField) {
						_tf = TextField(_skinObj.getChildAt(0));
					}
					else if (_skinObj.numChildren > 0) throw new Error("Text.template must have only 1 child and it must be a TextField");
				}
				else {
					_tf = new TextField();
				}
				addChild(_tf);
				_tf.x = 0;
				_tf.y = 0;
			}
			
			
			
			
			
			
			
			//_____________________________________________
			//apply properties
			
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.multiline = _multiline;
			_tf.wordWrap = _multiline;
			//_tf.embedFonts = false;
			_tf.mouseWheelEnabled = false;
			_tf.embedFonts = _embedFonts;
			_tf.antiAliasType = _antiAliasType;
			_tf.border = _debugBorder;
			
			
			
			
			//_type
			if (_type != TextFieldType.INPUT && _type != TextFieldType.DYNAMIC) throw new Error("wrong value for property Text.type (" + _type + ") possible values are " + TextFieldType.INPUT + " and " + TextFieldType.DYNAMIC);
			_tf.type = _type;
			if (_type == TextFieldType.INPUT) _tf.styleSheet = null;
			
			//selectable
			_tf.selectable = _selectable;
			this.mouseEnabled = _selectable;
			
			//maxwidth
			updateMaxWidth(_maxWidth);
			
			//maxheight
			if (_maxHeight == -1) _tf.autoSize = TextFieldAutoSize.LEFT;
			else {
				_tf.autoSize = TextFieldAutoSize.NONE;
				updateMaxHeight(_maxHeight);
			}
			
			
			//width + multiline
			if (!isNaN(_width)) _multiline = true;
			_tf.multiline = _multiline;
			_tf.wordWrap = _multiline;
			if (!isNaN(_width)) _tf.width = _width;
			
			if (!isNaN(_height)) {
				//trace("text _height isNaN " + _height);
				_tf.multiline = true;
				_tf.autoSize = TextFieldAutoSize.NONE;
				_tf.height = _height;
			}
			
			
			
			if (_textformat != null) {
				
				//trace("textformat, _value : " + _value+" /// "+_tf.getTextFormat());
				_tf.text = _value;
				_tf.setTextFormat(_textformat);
				return;
			}
			
			
			
			
			
			//value
			
			if (TextStylesheetConverter.ready()) {
				
				
				updateAutoSize();
				var _objectConvert:Object = TextStylesheetConverter.process(_value);
				_tf.styleSheet = _objectConvert["styleSheet"];
				
				
				var _valuetrans:String = _objectConvert["content"];
				var _content:String = removeDoubleLineBreaks(_valuetrans);
				
				if (_removeLineBreak) _content = _content.replace(/\n/g, " ");
				
				_tf["htmlText"] = _content;
				if (_maxHeight != -1) updateMaxHeight(_maxHeight);
				if (_maxWidth != -1) updateMaxWidth(_maxWidth);
				
				
				
				dispatchEvent(new TextInterfaceEvent(TextInterfaceEvent.UPDATE));
				
				var _listImg:Array = getListImgID(_content);
				for (var i:int = 0; i < _listImg.length; i++) registerImg(_listImg[i]);
				
				_cssinit = true;
				
				
				//valign
				
				if (_valign != "") {
					
					var _rheight:Number = this.rheight;
					if (_valign == VALIGN_CENTER) {
						_tf.y = Math.round((_height - _rheight) * 0.5);
						trace("_center, _tf.y = ((" + _height + " - " + _rheight + ") * 0.5");
						trace("_tf.y : " + _tf.y);
					}
					else if (_valign == VALIGN_BOTTOM) {
						_tf.y = Math.round((_tf.height - _rheight));
					}
					else if (_valign == VALIGN_TOP) {
						//nothing to do here
						_tf.y = 0;
					}
					
					
				}
			}
			
			
			
		}
		
		
		
		
		public function set multiline(v:Boolean):void{_multiline = v;}
		
		public function set type(_value:String):void{_type = _value;}
		public function get type():String{return _type;}
		
		public function get textField():TextField{return _tf;}
		
		public function get value():String{return _value;}
		
		public function set value(_str:String):void{_value = _str;}
		
		public function set embedFonts(value:Boolean):void{_embedFonts = value;}
		
		public function set antiAliasType(value:String):void { _antiAliasType = value; }
		
		public function set selectable(value:Boolean):void { _selectable = value; }
		
		
		
		
		public override function set maxHeight(value:Number):void {_maxHeight = value;}
		
		public override function set maxWidth(value:Number):void { _maxWidth = value; }
		
		
		
		public function get rheight():Number
		{
			var lm:TextLineMetrics;
			var count:Number = MARGIN * 2;
			for (var i:int = 0; i < _tf.numLines; i++) {
				lm = _tf.getLineMetrics(i);
				count += lm.height;
			}
			return count;
		}
		
		
		override public function set width(value:Number):void {
			_width = value;
			_multiline = true;
		}
		
		override public function set height(value:Number):void {
			_height = value;
		}
		
		public function set template(value:String):void {_template = value;}
		
		public function set debugBorder(value:Boolean):void { _debugBorder = value; }
		
		
		
		public function set valign(value:String):void { _valign = value; }
		
		public function set removeLineBreak(value:Boolean):void { _removeLineBreak = value; }
		
		public function set textformat(value:TextFormat):void { _textformat = value; }	
		
		public function getTextBounds():Rectangle
		{
			return _tf.getBounds(_tf);
		}
		
		
		
		
		
		
		
		//________________________________________________________________________________
		//private functions
		
		
		private function updateAutoSize():void
		{
			//for single line text, if width is specified, don't autosize
			if (!_tf.multiline && !isNaN(_width)) {
				_tf.autoSize = TextFieldAutoSize.NONE;
			}
			else _tf.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function removeDoubleLineBreaks(str:String):String
		{
			str = str.replace(/\r\n/g, "\n");
			return str;
		}
		
		
		private function getListImgID(_content:String):Array
		{
			var regex:RegExp = new RegExp("<img(.+?)id=('|\")([0-9a-zA-Z\.-_]*?)('|\")", "g");
			var _matches:Array;
			var _list:Array = new Array();
			
			//trace("\nLoadedTextField.getListImgID___________________________");
			do {
				_matches = regex.exec(_content);
				if (_matches != null) _list.push(_matches[3]);
				//trace("  _matches : " + _matches);
			}
			while (_matches != null);
			return _list;
		}
		
		
		private function registerImg(_id:String):void
		{
			var _loader:Loader = Loader(_tf.getImageReference(_id));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
		}
		
		
		private function updateMaxHeight(_max:int):void
		{
			_tf.height = _max;
		}
		
		
		private function updateMaxWidth(maxWidth:Number):void 
		{
			if (_tf.width > _maxWidth) {
				_tf.autoSize = TextFieldAutoSize.NONE;
				_tf.width = _maxWidth;
			}
		}
		
		
		
		
		
		
		
		
		//________________________________________________________________________________
		//events
		
		
		private function onImgLoaded(e:Event):void 
		{
			//trace("\nLoadedTextField.onImgLoaded________________________________________\n");
			dispatchEvent(new TextInterfaceEvent(TextInterfaceEvent.UPDATE));
		}
		
		
	}

}