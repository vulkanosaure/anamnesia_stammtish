/*
   bug value null								OK
   arg event in function and params			OK
   params in js								OK
   todo : SEPARATOR is not cool ! what if i want to put a string with spaces inside ?
   todo : mode as -> specifier l'objet qui heberge la fonction (objectsearch.search)
   todo : c'est l'as code de l'objet visé qui doit héberger la fonction (si c'est un InterfaceSprite)

 */

package data2.asxml
{
	import data2.behaviours.Behaviour;
	import data2.behaviours.menu.Menu;
	import data2.display.ClickableSprite;
	import data2.InterfaceSprite;
	import data2.sound.SoundPlayer;
	import data2.states.stateparser.StateParser;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.utils.describeType;
	import org.gestouch.core.Gestouch;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.AbstractContinuousGesture;
	import org.gestouch.gestures.AbstractDiscreteGesture;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.TapGesture;
	import org.gestouch.gestures.TransformGesture;
	
	/**
	 * ...
	 * @author
	 */
	public class OnClickHandler
	{
		
		private const KEY_URL:String = "url";
		private const KEY_JS:String = "js";
		public static const KEY_AS:String = "as";
		private const KEY_STATE:String = "state";
		private const KEY_SOUND:String = "sound";
		
		public static const PARAM_SEPARATOR:String = "  ";
		public static const INSTRUCTION_SEPARATOR:String = ";;";
		static public const DISTANCE_CANCEL_CLICK:Number = 10;
		
		private var _key:String;
		private var _value:String;
		private var _window:String; //for url
		private var _iobj:InteractiveObject;
		private var _listparams:Array;
		private var _instruction:String;
		private var _type:String;
		private var _stateparent:String;
		private var _state:String;
		private var _dynamicIndex:int;
		private var _volume:Number;	//for sound
		private var _loop:Boolean;	//for sound
		private var _channel:String;	//for sound
		private var _posMouseDown:Point;
		
		public static var UPDATE_CLICKABLE:Boolean = true;
		
		
		
		public function OnClickHandler(__iobj:InteractiveObject, __dynamicIndex:int)
		{
			_iobj = __iobj;
			_dynamicIndex = __dynamicIndex;
			
			if (_iobj is DisplayObjectContainer) {
				
				var _spriteAllowed:Boolean = true;
				if (_iobj is InterfaceSprite && !InterfaceSprite(_iobj).clickableSprite) _spriteAllowed = false;
				
				//trace("OnClickHandler " + UPDATE_CLICKABLE + " && " + _spriteAllowed);
				if (UPDATE_CLICKABLE && _spriteAllowed) {
					ClickableSprite.updateClickable(DisplayObjectContainer(_iobj));
				}
			}
		
		}
		
		
		
		
		//private function onClick(e:MouseEvent):void
		private function onClick(e:Event = null):void
		{
			//trace("onClick " + _iobj + ", " + _key + ", " + _value + ", " + _window + ", listparams : " + _listparams);
			
			if (_key == KEY_URL)
			{
				navigateToURL(new URLRequest(_value), _window);
			}
			else if (_key == KEY_JS)
			{
				var _params:Array = [_value];
				var _nbparam:int = _listparams.length;
				for (var i:int = 0; i < _nbparam; i++)
					_params.push(_listparams[i]);
				
				OnClickHandler.execFuncWithParam(ExternalInterface, "call", _params);
			}
			else if (_key == OnClickHandler.KEY_AS)
			{
				if (_iobj.parent != null)
				{
					OnClickHandler.execAS(_instruction, _iobj);
					
					
				}
			}
			else if (_key == KEY_STATE)
			{
				StateParser.goto_(_stateparent, _state);
				
			}
			else if (_key == KEY_SOUND) {
				
				SoundPlayer.play(_value, _volume, _loop, _channel);
				
			}
		}
		
		
		
		
		public static function execAS(_instruction:String, __iobj:InteractiveObject):void 
		{
			var _asholder:Object;
			var _tab:Array = _instruction.split(OnClickHandler.PARAM_SEPARATOR);
			
			//trace("_tab : " + _tab);
			if (_tab.length < 2) throw new Error("you must at least specify asholder and clickHandler for onclick in mode \"" + OnClickHandler.KEY_AS +"\"");
			
			var _asholderDef:String = _tab[0];
			
			var _fc:String = _asholderDef.charAt(0);
			//global class
			if (_fc != "." && _fc != "#" && _fc != "*") {
				
				var _class:Class = ClassManager.getClassByName(_asholderDef);
				if (_class == null) throw new Error("class " + _asholderDef + " is not registered");
				_asholder = _class;
			}
			//instance object
			else{
				_asholder = ObjectSearch.search(__iobj, _asholderDef);
				if (_asholder is InterfaceSprite) _asholder = InterfaceSprite(_asholder).ascodeInstance;
			}
			
			
			var _value:String = _tab[1];
			_tab.shift();
			_tab.shift();
			var _listparams:Array = _tab;
			
			
			//var _params:Array = [e];
			//var _params:Array = [__iobj];
			var _params:Array = [];
			//ptet plus interessant de lui donner direct l'interactive object, l'event est inutile pour un onclick
			//voir si c'est pas encore mieux de filer le convertir en InterfaceSprite (a voir dans la pratique)
			
			var _nbparam:int = _listparams.length;
			for (var i:int = 0; i < _nbparam; i++) {
				var _param:* = _listparams[i];
				if (_param == "true") _param = true;
				else if (_param == "false") _param = false;
				_params.push(_param);
			}
			
			OnClickHandler.execFuncWithParam(_asholder, _value, _params);
		}
		
		
		
		
		public function init(__type:String, __instruction:String):void
		{
			//trace("OnClickHandler.init(" + __type + ", " + __instruction + ")");
			
			_type = __type;
			_instruction = __instruction;
			
			
			if (_type == MouseEvent.CLICK) {
				
				if (Multitouch.supportsTouchEvents) {
					_iobj.addEventListener(TouchEvent.TOUCH_BEGIN, onTapNativeBefore);
					_iobj.addEventListener(TouchEvent.TOUCH_TAP, onTapNative);
				}
				else {
					_iobj.addEventListener(MouseEvent.MOUSE_DOWN, onTapNativeBefore);
					_iobj.addEventListener(MouseEvent.MOUSE_UP, onTapNative);
				}
				
			}
			else if (_type == MouseEvent.MOUSE_DOWN) {
				
				if (Multitouch.supportsTouchEvents) {
					_iobj.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				}
				else {
					_iobj.addEventListener(_type, onTouchBegin);
				}
				
			}
			else {
				throw new Error("type '" + _type + "' not recognized yet");
			}
			
			
			
			
			var _indexPoint:int = _instruction.indexOf(":");
			if (_indexPoint == -1)
			{
				throw new Error("InterfaceSprite.onclick param must be specified in format \"key:value\" (" + _instruction + ")");
			}
			else
			{
				_key = _instruction.substr(0, _indexPoint);
				_value = _instruction.substr(_indexPoint + 1, _instruction.length - (_indexPoint + 1));
				
				if (_key == KEY_URL)
				{
					
					var _tab:Array = _value.split(OnClickHandler.PARAM_SEPARATOR);
					_value = _tab[0];
					if (_tab.length > 1)
						_window = _tab[1];
					else
						_window = "_blank";
					
				}
				else if (_key == KEY_JS)
				{
					
					var _tab:Array = _value.split(OnClickHandler.PARAM_SEPARATOR);
					_value = _tab[0];
					_tab.shift();
					_listparams = _tab;
					
				}
				else if (_key == OnClickHandler.KEY_AS)
				{
					_instruction = _value;
				}
				else if (_key == KEY_STATE)
				{
					//stateparent.state
					var _tab:Array = _value.split(".");
					if (_tab.length != 2) throw new Error("wrong format for onclick type \"state\" (stateparent.state) : \"" + _value + "\"");
					_stateparent = _tab[0];
					_state = _tab[1];
					
					
					//get Menu that _iobj is part of (if there is one) for association with StateParser (update_link)
					
					var _parent:DisplayObjectContainer = _iobj.parent;
					if (_parent is InterfaceSprite) {
						var _behaviours:Array = InterfaceSprite(_parent).behaviours;
						var _nbbehaviours:int = (_behaviours==null) ? 0 : _behaviours.length;
						var _menu:Menu;
						for (var i:int = 0; i < _nbbehaviours; i++) 
						{
							var _b:Behaviour = Behaviour(_behaviours[i]);
							if (_b is Menu) {
								_menu = Menu(_b);
								break;
							}
						}
						
						if (_menu != null) {
							//trace("_menu : " + _menu + ", _dynamicIndex : " + _dynamicIndex + ", _stateparent : " + _stateparent + ", _state : " + _state);
							StateParser.addMenuAssociation(_menu, _dynamicIndex, _stateparent, _state);
						}
						
					}
					
				}
				else if (_key == KEY_SOUND) {
					
					var _tab:Array = _value.split(OnClickHandler.PARAM_SEPARATOR);
					_value = _tab[0];
					
					if (_tab.length > 1) {
						_volume = Number(_tab[1]);
						if (isNaN(_volume)) throw new Error("wrong value for arg \"volume\", value must be a Number");
						if (_volume > 1.0) _volume = 1.0;
						if (_volume < 0.0) _volume = 0.0;
					}
					else _volume = 1.0;
					
					if (_tab.length > 2) {
						var _loopstr:String = _tab[2];
						if (_loopstr != "false" && _loopstr != "true") throw new Error("wrong value for arg \"loop\", value must be true or false");
						_loop = (_loopstr == "true");
					}
					else _loop = false;
					
					if (_tab.length > 3) {
						_channel = _tab[3];
					}
					else _channel = "";
					
				}
				
				else throw new Error("InterfaceSprite.onclick : wrong key \"" + _key + "\", valid key are \"" + KEY_URL + "\", \"" + OnClickHandler.KEY_AS + "\", \"" + KEY_STATE + "\", \"" + KEY_JS + "\"");
				
			}
			
			//trace("_key : " + _key + ", _value : " + _value + ", _window : " + _window + ", _listparams : " + _listparams);
			
		}
		
		
		
		//mousedown
		
		private function onTouchBegin(e:Event):void 
		{
			trace("OnClickHandler.onTouchBegin");
			onClick();
			
		}
		
		
		//click
		
		private function onTapNativeBefore(e:Event):void 
		{
			//_posMouseDown = getAbsolutePosition();
			_posMouseDown = getMousePosition(e);
			trace("OnClickHandler.onTapNativeBefore " + _posMouseDown);
			
		}
		
		private function getMousePosition(e:Event):Point 
		{
			var _output:Point = new Point();
			if (e is TouchEvent) {
				var _te:TouchEvent = TouchEvent(e);
				_output.x = _te.stageX;
				_output.y = _te.stageY;
			}
			else {
				var _me:MouseEvent = MouseEvent(e);
				_output.x = _me.stageX;
				_output.y = _me.stageY;
			}
			
			return _output;
		}
		
		private function onTapNative(e:Event):void 
		{
			if (_posMouseDown != null) {
				//var _position:Point = getAbsolutePosition();
				var _position:Point = getMousePosition(e);
				trace("_position : " + _position);
				
				var _deltax:Number = Math.abs(_position.x - _posMouseDown.x);
				var _deltay:Number = Math.abs(_position.y - _posMouseDown.y);
				var _delta:Number = Point.distance(new Point(), new Point(_deltax, _deltay));
				trace("(onclickhandler) _delta : " + _delta);
				if (_delta > DISTANCE_CANCEL_CLICK) return;
			}
			trace("OnClickHandler.onTapNative " + _position);
			onClick();
		}
		
		
		private function getAbsolutePosition():Point 
		{
			var _output:Point = _iobj.localToGlobal(new Point(0, 0));
			return _output;
		}
		
		
		
		
		private static function execFuncWithParam(_obj:*, _funcname:String, _params:Array):void
		{
			/*
			trace("execFuncWithParam(" + _obj + ", " + _funcname + ")");
			trace("_params : " + _params);
			*/
			if (_obj[_funcname] == undefined) throw new Error("function \"" + _funcname + "\" is not defined for " + _obj);
			
			
			var _len:int = _params.length;
			if (_len == 0)
				_obj[_funcname]();
			else if (_len == 1)
				_obj[_funcname](_params[0]);
			else if (_len == 2)
				_obj[_funcname](_params[0], _params[1]);
			else if (_len == 3)
				_obj[_funcname](_params[0], _params[1], _params[2]);
			else if (_len == 4)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3]);
			else if (_len == 5)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4]);
			else if (_len == 6)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4], _params[5]);
			else if (_len == 7)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6]);
			else if (_len == 8)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7]);
			else if (_len == 9)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7], _params[8]);
			else if (_len == 10)
				_obj[_funcname](_params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6], _params[7], _params[8], _params[9]);
			else
				throw new Error("too many args for function " + _funcname);
		}
	
	}

}