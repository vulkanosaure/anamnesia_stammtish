package assets.menu2 
{
	import data.fx.transitions.TweenManager;
	import data2.asxml.ObjectSearch;
	import data2.fx.delay.DelayManager;
	import data2.InterfaceSprite;
	import data2.text.Text;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import model.translation.Translation;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Component_menu2 extends InterfaceSprite
	{
		private const NB_MAX_TEXT:int = 20;
		private const DELTA_X:Number = 233;
		
		private var _listTextBig:Vector.<Text>;
		private var _listTextSmall:Vector.<Text>;
		
		
		private var _nbitem:int;
		private var _index:int;
		private var _twm:TweenManager = new TweenManager();
		
		private const POSITION_BIG:Point = new Point(-149, +169);
		private var _timer:Timer;
		private var _content:Array;
		
		
		public function Component_menu2() 
		{
			
			
			
		}
		
		
		public function initComponent():void
		{
			_listTextBig = new Vector.<Text>();
			_listTextSmall = new Vector.<Text>();
			
			for (var i:int = 0; i < NB_MAX_TEXT; i++) 
			{
				var _textsmall:Text = new Text();
				_textsmall.embedFonts = true;
				_textsmall.multiline = true;
				_textsmall.width = 203;
				_listTextSmall.push(_textsmall);
				ObjectSearch.registerID(_textsmall, "text_menu2_small_" + i, false);
				
				
				var _textbig:Text = new Text();
				_textbig.embedFonts = true;
				_textbig.multiline = true;
				_textbig.width = 1000;
				_textbig.x = POSITION_BIG.x; _textbig.y = POSITION_BIG.y;
				_listTextBig.push(_textbig);
				ObjectSearch.registerID(_textbig, "text_menu2_big_" + i, false);
				
			}
			
			
			_timer = new Timer(5000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			//_timer.start();
			
			
			
			
		}
		
		
		public function play():void
		{
			_index = -1;
			_timer.reset();
			_timer.start();
			onTimer(null);
		}
		
		public function stop():void
		{
			_timer.stop();
		}
		
		
		
		
		private function onTimer(e:TimerEvent):void 
		{
			//trace("Component_menu2.onTimer");
			
			_index++;
			display(_index);
			
		}
		
		
		
		
		public function updateComponent(_listtexts:Array, _tabindexes:Array):void
		{
			
			_content = _listtexts;
			_nbitem = _content.length;
			
			//
			
			//text_menu2_small_,text_menu2_big_
			var _filters:Array = [];
			
			for (var i:int = 0; i < _nbitem; i++) 
			{
				var _dynindex:int = _tabindexes[i];
				
				var _id:String;
				_id = "text_menu2_small_" + i;
				Translation.addDynamic(_id, "questions.item", "text", _id, "MS500_15_FFFFFF");
				Translation.setDynamicIndex(_id, _dynindex);
				_filters.push(_id);
				
				
				_id = "text_menu2_big_" + i;
				Translation.addDynamic(_id, "questions.item", "text", _id, "MS900_72_FFFFFF_menu2");
				Translation.setDynamicIndex(_id, _dynindex);
				_filters.push(_id);
				
				
			}
			
			Translation.translate("", _filters);
			
			
			for (var j:int = 0; j < NB_MAX_TEXT; j++) 
			{
				if (j < _nbitem) {
					if (!this.contains(_listTextSmall[j])) this.addChild(_listTextSmall[j]);
					if (!this.contains(_listTextBig[j])) this.addChild(_listTextBig[j]);
				}
				else {
					if (this.contains(_listTextSmall[j])) this.removeChild(_listTextSmall[j]);
					if (this.contains(_listTextBig[j])) this.removeChild(_listTextBig[j]);
				}
				
			}
			
			
			var _tabbtnsmall:Array = new Array();
			_tabbtnsmall.push(Sprite(ObjectSearch.getID("menu2_btn_small0")));
			_tabbtnsmall.push(Sprite(ObjectSearch.getID("menu2_btn_small1")));
			_tabbtnsmall.push(Sprite(ObjectSearch.getID("menu2_btn_small2")));
			_tabbtnsmall.push(Sprite(ObjectSearch.getID("menu2_btn_small3")));
			
			var _nbitemtop:int = _nbitem - 1;
			if (_nbitemtop > 4) _nbitemtop = 4;
			
			for (var k:int = 0; k < 4; k++) 
			{
				var _btn:Sprite = Sprite(_tabbtnsmall[k]);
				
				_btn.visible = k < _nbitemtop;
				if (_btn.visible) {
					_btn.x = -20 + k * DELTA_X;
				}
			}
			
			
			_index = 0;
			display(_index);
		}
		
		
		
		
		
		public function hideAll():void
		{
			for (var j:int = 0; j < NB_MAX_TEXT; j++) 
			{
				if (this.contains(_listTextBig[j])) {
					_listTextBig[j].visible = false;
				}
				if (this.contains(_listTextSmall[j])) {
					_listTextSmall[j].visible = false;
				}
			}
		}
		
		
		
		public function getTitle(index:int):String 
		{
			var _ind:int = -_index + index;
			_ind %= _nbitem;
			while (_ind < 0) _ind += _nbitem;
			return _content[_ind];
			
		}
		
		public function getTitleMain():String 
		{
			var _nbitemtop:int = _nbitem - 1;
			var _ind:int = -_index + _nbitemtop;
			_ind %= _nbitem;
			while (_ind < 0) _ind += _nbitem;
			return _content[_ind];
		}
		
		
		public function getRealIndex(__index:int):int 
		{
			if (__index == -1) {
				var _nbitemtop:int = _nbitem - 1;
				if (_nbitemtop > 4) _nbitemtop = 4;
				var _ind:int = -_index + _nbitemtop;
				
				_ind %= _nbitem;
				while (_ind < 0) _ind += _nbitem;
				return _ind;
				
			}
			
			var _ind:int = -_index + __index;
			_ind %= _nbitem;
			while (_ind < 0) _ind += _nbitem;
			return _ind;
		}
		
		
		
		
		
		
		private function display(__index:int):void 
		{
			_index = __index;
			//trace("menu2.display(" + _index + ")");
			
			for (var j:int = 0; j < NB_MAX_TEXT; j++) 
			{
				if (this.contains(_listTextBig[j])) {
					_listTextBig[j].visible = false;
				}
				/*
				if (this.contains(_listTextSmall[j])) {
					_listTextSmall[j].visible = false;
				}
				*/
			}
			
			
			var _nbitemtop:int = _nbitem - 1;
			if (_nbitemtop > 4) _nbitemtop = 4;
			
			var _delay:Number = 0;
			
			//small
			for (var i:int = 0; i < _nbitemtop + 1; i++) 
			{
				var _ind:int = -_index + i;
				_ind %= _nbitem;
				while (_ind < 0) _ind += _nbitem;
				var _text:Text = _listTextSmall[_ind];
				
				var _x:Number = i * DELTA_X;
				_text.x = _x;
				_text.visible = true;
				_text.alpha = 1;
				//_twm.tween(_text, "alpha", NaN, 1, 0.7, _delay);
				_twm.tween(_text, "x", _x - DELTA_X, _x, 0.7, _delay);
				//_delay += 0.1;
				
				if(i == 0) _twm.tween(_text, "alpha", 0, 1, 0.7, _delay);
				if(i == _nbitemtop) _twm.tween(_text, "alpha", 1, 0, 0.7, _delay);
			}
			
			
			var _ind:int = -_index + _nbitemtop;
			_ind %= _nbitem;
			while (_ind < 0) _ind += _nbitem;
			var _textbig:Text = _listTextBig[_ind];
			_textbig.visible = true;
			_textbig.alpha = 0;
			
			_delay = 0.35;
			_twm.tween(_textbig, "alpha", NaN, 1, 0.7, _delay);
			_twm.tween(_textbig, "x", POSITION_BIG.x - 150, POSITION_BIG.x, 0.7, _delay);
			
			
		}
		
		
		
		
		
	}

}