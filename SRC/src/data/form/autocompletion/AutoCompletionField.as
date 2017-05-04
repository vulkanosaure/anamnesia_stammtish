/*
 * Composant, 

 copier coller le dossier dans la librairie de AutoCompletionExample.fla
 
 
var _autoCompletionField:AutoCompletionField = new AutoCompletionFieldExample();
_autoCompletionField.serverfile = "../wp-content/plugins/autocompletion-data/utils/tags.php";
_autoCompletionField.listItemClass = AutoCompletionListItemExample;
this.addChild(_autoCompletionField);
_autoCompletionField.addEventListener(AutoCompletionEvent.SELECT_ENTRY, onSelectEntry);
_autoCompletionField.minCharsActive = 3;
_autoCompletionField.maxResults = 4;
_autoCompletionField.shifty = 1;



coté serveur : 

le script doit prendre en entrée $_GET["term"]
et doit afficher en sortie un JSON contenant un array d'object contenants "id", "label", "type"
[
	{"id":"0","label":"Mairie, PFAFFENHOFFEN", "type" : "xxx"},
	{"id":"2","label":"Mairie, OSTHOUSE", "type" : "yyy"}
]

 * */


package data.form.autocompletion 
{
	import com.adobe.serialization.json.JSON;
	import data.net.PHPManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Vincent
	 */
	public class AutoCompletionField extends Sprite
	{
		static public const UP:String = "up";
		static public const DOWN:String = "down";
		
		//_______________________________________________________________________________
		// properties
		
		private var _inputdisable:TextField;
		private var _inputenable:TextField;
		
		
		private var _serverfile:String;
		private var _phpm:PHPManager;
		private var _list:AutoCompletionList;
		private var _minCharsActive:int = 2;
		private var _maxResults:int = 15;
		private var _shiftx:Number;
		private var _shifty:Number;
		private var _direction:String = DOWN;
		private var _labelDisabled:String;
		
		public function AutoCompletionField() 
		{
			_inputdisable = this.getChildByName("tf_disable") as TextField;
			if (_inputdisable == null) throw new Error("AutoCompletionField must contain 'tf_disable' instance");
			if (_inputdisable.type != TextFieldType.INPUT) throw new Error("textfields must be of type INPUT");
			
			_inputenable = this.getChildByName("tf_enable") as TextField;
			if (_inputenable == null) throw new Error("AutoCompletionField must contain 'tf_enable' instance");
			if (_inputenable.type != TextFieldType.INPUT) throw new Error("textfields must be of type INPUT");
			
			_inputenable.visible = false;
			_inputenable.addEventListener(Event.CHANGE, onTextChange);
			_inputenable.addEventListener(FocusEvent.FOCUS_IN, onFocusTextIn);
			_inputenable.addEventListener(FocusEvent.FOCUS_OUT, onFocusTextOut);
			_inputdisable.addEventListener(MouseEvent.CLICK, onClickTFDisable);
			_inputenable.text = "";
			
			_list = new AutoCompletionList();
			//this.addChild(_list);
			
			_list.listItemClass = AutoCompletionListItem;
			_list.addEventListener(AutoCompletionEvent.SELECT_ENTRY, onSelectEntry);
			
			this.shiftx = 0;
			this.shifty = 0;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function set text(value:String):void
		{
			_inputdisable.visible = false;
			_inputenable.visible = true;
			_inputenable.text = value;
		}
		
		public function get text():String
		{
			return _inputenable.text;
		}
		
		public function set serverfile(value:String):void 
		{
			_serverfile = value;
		}
		
		public function set listItemClass(value:Class):void 
		{
			_list.listItemClass = value;
		}
		
		public function set minCharsActive(value:int):void 
		{
			_minCharsActive = value;
		}
		
		public function set maxResults(value:int):void 
		{
			_maxResults = value;
		}
		
		public function set shiftx(value:Number):void 
		{
			_shiftx = value;
			
		}
		
		public function set shifty(value:Number):void 
		{
			_shifty = value;
			
		}
		
		public function set direction(value:String):void 
		{
			_direction = value;
		}
		
		public function set labelDisabled(value:String):void 
		{
			_labelDisabled = value;
			_inputdisable.text = value;
		}
		
		
		public function hideList():void
		{
			_list.reset();
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function setDataList(_tab:Array):void
		{
			_list.reset();
			var _len:int = _tab.length;
			if (_len > _maxResults) _len = _maxResults;
			
			if(_direction==DOWN){
				for (var i:int = 0; i < _len; i++) 
				{
					var _obj:Object = _tab[i];
					_list.add(_obj.id, _obj.type, _obj.label);
				}
			}
			else {
				for (var i:int = _len-1; i >-1; i--) 
				{
					var _obj:Object = _tab[i];
					_list.add(_obj.id, _obj.type, _obj.label);
				}
			}
			
			_list.update();
			
			
			var _pos:Point;
			if(_direction == DOWN) _pos = new Point(_shiftx, this.height + _shifty);
			else _pos = new Point(_shiftx, -_list.height);
			
			
			if(!stage.contains(_list)) stage.addChild(_list);
			var _posglobal:Point = this.localToGlobal(_pos);
			_list.x = _posglobal.x;
			_list.y = _posglobal.y;
			
			
		}
		
		
		private function displayAutoCompletion(_input:String):void
		{
			_input = removeAccents(_input);
			_list.reset();
			
			if (_input.length < _minCharsActive) return;
			
			_phpm = new PHPManager();
			_phpm.addEventListener(Event.COMPLETE, onPHPComplete);
			_phpm.varsIn.term = _input;
			_phpm.outputMode = PHPManager.OUTPUT_DATA;
			_phpm.exec(_serverfile + "?term=" + _input);
		}
		
		
		private function removeAccents(_str:String):String
		{
			_str = _str.replace(/[éèê]/, "e");
			_str = _str.replace(/[à]/, "a");
			_str = _str.replace(/[ù]/, "u");
			return _str;
		}
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		private function onTextChange(e:Event):void 
		{
			//trace("onTextChange " + _inputenable.text);
			displayAutoCompletion(_inputenable.text);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onPHPComplete(e:Event):void 
		{
			//trace("onPHPComplete");
			var _phpm:PHPManager = PHPManager(e.target);
			//trace("outputData : " + _phpm.outputData);
			
			var _tabData:Array = JSON.decode(_phpm.outputData);
			//trace("_tabData : " + _tabData);
			setDataList(_tabData);
			
		}
		
		private function onSelectEntry(e:AutoCompletionEvent):void 
		{
			//trace("onSelectEntry " + e.identry);
			_inputenable.text = _list.getLabel(e.identry);
			hideList();
			
			var _e:AutoCompletionEvent = new AutoCompletionEvent(AutoCompletionEvent.SELECT_ENTRY);
			_e.identry = e.identry;
			_e.typeentry = e.typeentry;
			this.dispatchEvent(_e);
			
		}
		
		private function onClickTFDisable(e:MouseEvent):void 
		{
			_inputdisable.visible = false;
			_inputenable.visible = true;
			stage.focus = _inputenable;
		}
		
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(e:Event):void 
		{
			hideList();
		}
		
		
		private function onFocusTextIn(e:FocusEvent):void 
		{
			trace("onFocusTextIn");
			displayAutoCompletion(_inputenable.text);
		}
		
		private function onFocusTextOut(e:FocusEvent):void 
		{
			trace("onFocusTextOut");
			trace("stage.focus : " + stage.focus);
			if(!stage.focus is _list.listItemClass) hideList();
		}
		
	}

}