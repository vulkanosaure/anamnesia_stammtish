package assets 
{
	import adobe.utils.CustomActions;
	import data2.asxml.ObjectSearch;
	import data2.mvc.Component;
	import data2.text.Text;
	import flash.text.TextFormat;
	import model.translation.Translation;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Asset_component_actu extends Component
	{
		private var _text1:Text;
		private var _textDate:Text;
		public var _index:int;
		private var _tfttitle:TextFormat;
		private var _tftdesc:TextFormat;
		private var _tftdate:TextFormat;
		
		public function Asset_component_actu() 
		{
			
		}
		
		override public function initComponent():void 
		{
			super.initComponent();
			
			
			
			_textDate = new Text();
			this.addChild(_textDate);
			_textDate.x = 0; _textDate.y = 0; 
			_textDate.width = 255;
			_textDate.multiline = false;
			_textDate.embedFonts = true;
			_textDate.textformat = _tftdate;
			
			var _ybase:int = 20;
			
			var _text0:Text = new Text();
			this.addChild(_text0);
			_text0.x = 0; _text0.y = _ybase; 
			_text0.width = 255;
			_text0.multiline = true;
			_text0.embedFonts = true;
			_text0.textformat = _tfttitle;
			ObjectSearch.registerID(_text0, "text_actu_title" + _index, false);
			Translation.addCallback("text_actu_title" + _index, onChangeTitle);
			
			
			_text1 = new Text();
			this.addChild(_text1);
			_text1.x = 0; _text1.y = _ybase + 15; 
			_text1.width = 255;
			_text1.multiline = true;
			_text1.embedFonts = true;
			_text1.textformat = _tftdesc;
			ObjectSearch.registerID(_text1, "text_actu_desc" + _index, false);
			
			
		}
		
		public function setDate(_ts:int):void
		{
			var _date:Date = new Date(_ts * 1000);
			//_date.setTime((_ts) * 1000);
			
			var _strday:String = String(_date.getDate());
			if (_strday.length < 2) _strday = "0" + _strday;
			
			var _strmon:String = String(_date.getMonth() + 1);
			if (_strmon.length < 2) _strmon = "0" + _strmon;
			
			var _stryear:String = String(_date.getFullYear());
			
			var _strdate:String = _strday + "/" + _strmon + "/" + _stryear;
			_textDate.value = _strdate;
			
			_textDate.updateText();
		}
		
		private function onChangeTitle(_texttitle:Text):void 
		{
			_text1.y = _texttitle.y + _texttitle.getTextBounds().height + 0;
		}
		
		public function get tfttitle():TextFormat {return _tfttitle;}
		
		public function set tfttitle(value:TextFormat):void {_tfttitle = value;}
		
		public function get tftdesc():TextFormat {return _tftdesc;}
		
		public function set tftdesc(value:TextFormat):void {_tftdesc = value;}
		
		public function get tftdate():TextFormat 
		{
			return _tftdate;
		}
		
		public function set tftdate(value:TextFormat):void 
		{
			_tftdate = value;
		}
		
	}

}