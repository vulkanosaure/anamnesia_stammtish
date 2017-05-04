package data.layout.dialog 
{
	import data.fx.transitions.TweenManager;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DialogManager extends EventDispatcher
	{
		//_______________________________________________________________________________
		// properties
		
		private static var _bgcolor:uint = 0x000000;
		private static var _bgalpha:Number = 0.5;
		private static var _positionX:Number = 0.5;
		private static var _positionY:Number = 0.5;
		private static var _size:Point;
		private static var _timeShow:Number = 0.2;
		private static var _timeHide:Number = 0.2;
		private static var _closeOnClickOutside:Boolean = true;
		
		private static var _stage:Stage;
		private static var twm:TweenManager;
		private static var _bg:Sprite;
		private static var _listDialog = new Array();
		private static var _evtDispatcher:EventDispatcher;
		private static var _curkey:String;
		
		
		
		public function DialogManager() 
		{
			throw new Error("is static");
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public static function init(__stage:Stage):void
		{
			_stage = __stage;
			_stage.addEventListener(Event.RESIZE, onStageResized);
			
			twm = new TweenManager();
			
			_bg = new Sprite();
			_bg.alpha = 0.0;
			_bg.visible = false;
			_stage.addChild(_bg);
			
			if(_closeOnClickOutside){
				_bg.buttonMode = true;
				_bg.addEventListener(MouseEvent.CLICK, onCloseDialog);
			}
			
			var _nbDialog:int = _listDialog.length;
			for (var i:int = 0; i < _nbDialog; i++) 
			{
				var _def:DialogDefinition = DialogDefinition(_listDialog[i]);
				_stage.addChild(_def.dialogSprite);
				if(!_def.dialogSprite is IDialogItem) _def.dialogSprite.alpha = 0.0;
				_def.dialogSprite.visible = false;
				_def.dialogSprite.addEventListener(DialogManagerEvent.CLOSE, onCloseDialog);
			}
			
			onStageResized(new Event(""));
			
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
		}
		
		
		public static function add(_key:String, _dialogSprite:Sprite, _size:Point = null, _position:Point = null):void
		{
			if (getDefinition(_key) != null) throw new Error("_key " + _key + " allready exists");
			if (_key == "") throw new Error("_key can't be empty");
			if (_listDialog == null) _listDialog = new Array();
			var _dialogDef:DialogDefinition = new DialogDefinition(_key, _dialogSprite, _size, _position);
			_listDialog.push(_dialogDef);
		}
		
		
		public static function show(_key:String):void
		{
			var _def:DialogDefinition = getDefinition(_key);
			if (_def == null) throw new Error("Dialog " + _key + " wasn't found");
			if (_stage == null) throw new Error("you must call init before using method show");
			
			twm.tween(_bg, "alpha", NaN, 1, _timeShow);
			if (_def.dialogSprite is IDialogItem) IDialogItem(_def.dialogSprite).showDialog();
			else twm.tween(_def.dialogSprite, "alpha", NaN, 1, _timeShow);
			
			_def.isVisible = true;
			_curkey = _key;
		}
		
		public static function hide():void
		{
			var _def:DialogDefinition = getVisibleDialog();
			if (_def == null) throw new Error("nothing to hide");
			
			twm.tween(_bg, "alpha", NaN, 0, _timeHide);
			
			if (_def.dialogSprite is IDialogItem) IDialogItem(_def.dialogSprite).hideDialog();
			else twm.tween(_def.dialogSprite, "alpha", NaN, 0, _timeHide);
			_def.isVisible = false;
		}
		
		public static function addEventListener(_type:String, _handler:Function):void
		{
			if (_evtDispatcher == null) _evtDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(_type, _handler);
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// set / get
		
		public static function set bgalpha(value:Number):void 
		{
			_bgalpha = value;
		}
		
		public static function set bgcolor(value:uint):void 
		{
			_bgcolor = value;
		}
		
		public static function set positionX(value:Number):void 
		{
			if (value < 0 || value > 1) throw new Error("positionX must be set in interval [0,1]");
			_positionX = value;
		}
		
		public static function set positionY(value:Number):void 
		{
			if (value < 0 || value > 1) throw new Error("positionY must be set in interval [0,1]");
			_positionY = value;
		}
		
		public static function set size(value:Point):void 
		{
			_size = value;
		}
		
		public static function set timeHide(value:Number):void 
		{
			_timeHide = value;
		}
		
		public static function set timeShow(value:Number):void 
		{
			_timeShow = value;
		}
		
		public static function set closeOnClickOutside(value:Boolean):void 
		{
			_closeOnClickOutside = value;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private static function drawBG(_width:Number, _height:Number):void
		{
			var g:Graphics = _bg.graphics;
			g.clear();
			g.beginFill(_bgcolor, _bgalpha);
			g.drawRect(0, 0, _width, _height);
			
		}
		
		private static function getDefinition(_key:String):DialogDefinition
		{
			var _nbDialog:int = _listDialog.length;
			for (var i:int = 0; i < _nbDialog; i++) 
			{
				var _def:DialogDefinition = DialogDefinition(_listDialog[i]);
				if (_def.key == _key) return _def;
			}
			return null;
		}
		
		private static function getVisibleDialog():DialogDefinition
		{
			var _nbDialog:int = _listDialog.length;
			for (var i:int = 0; i < _nbDialog; i++) 
			{
				var _def:DialogDefinition = DialogDefinition(_listDialog[i]);
				if (_def.isVisible) return _def;
			}
			return null;
		}
		
		
		//_______________________________________________________________________________
		// events
		
		
		private static function onStageResized(e:Event):void 
		{
			drawBG(_stage.stageWidth, _stage.stageHeight);
			
			var _nbDialog:int = _listDialog.length;
			for (var i:int = 0; i < _nbDialog; i++) 
			{
				var _def:DialogDefinition = DialogDefinition(_listDialog[i]);
				var _x:Number = _stage.stageWidth * _def.position.x - _def.size.x * _def.position.x;
				var _y:Number = _stage.stageHeight * _def.position.y - _def.size.y * _def.position.y;
				trace("_x : " + _x + ", _y : " + _y);
				_x = Math.round(_x);
				_y = Math.round(_y);
				_def.dialogSprite.x = _x;
				_def.dialogSprite.y = _y;
			}
		}
		
		
		private static function onCloseDialog(e:Event):void 
		{
			hide();
			var _evt:DialogManagerEvent = new DialogManagerEvent(DialogManagerEvent.CLOSE);
			_evt.id_dialog = _curkey;
			_evtDispatcher.dispatchEvent(_evt);
		}
		
		
	}

}