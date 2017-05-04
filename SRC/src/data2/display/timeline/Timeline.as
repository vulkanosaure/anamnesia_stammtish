package data2.display.timeline 
{
	import data2.layoutengine.LayoutSprite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Vincent
	 */
	public class Timeline extends LayoutSprite
	{
		//_______________________________________________________________________________
		// properties
		
		public static const MODE_FILLING:String = "filling";
		public static const MODE_CURSOR:String = "cursor";
		public static const DIR_HORIZONTAL:String = "horizontal";
		public static const DIR_VERTICAL:String = "vertical";
		
		
		private var track:Sprite;
		private var cursor:Sprite;
		private var filling:Sprite;
		
		private var _uiMode:String;
		private var _progress:Number;
		private var _direction:String;
		
		private var _dynamicTrackSize:Number;
		private var _cursorSize:Number;
		private var _trackSize:Number;
		
		
		private var _positionProp:String;
		private var _dimensionProp:String;
		private var _positionMouseProp:String;
		
		private var _bInit:Boolean;
		private var _isDragging:Boolean = false;
		private var _angleRotation:Number;
		
		private var _template:String;
		private var _objtpl:Sprite;
		
		
		public function Timeline() 
		{
			_bInit = false;
			
			//default value
			_direction = DIR_HORIZONTAL;
			_uiMode = MODE_CURSOR;
			_angleRotation = 0;
			
		}
		
		
		
		
		public function initTimeline():void
		{
			var _class:Class = getDefinitionByName(_template) as Class;
			_objtpl = Sprite(new _class());
			this.addChild(_objtpl);
			
			
			track = Sprite(_objtpl.getChildByName("track_stage"));
			cursor = Sprite(_objtpl.getChildByName("cursor_stage"));
			filling = Sprite(_objtpl.getChildByName("filling_stage"));
			
			filling.mouseEnabled = false;
			filling.mouseChildren = false;
			cursor.buttonMode = true;
			
			
			
			if (_uiMode == MODE_CURSOR) filling.visible = false;
			else if (_uiMode == MODE_FILLING) cursor.visible = false;
			
			_positionProp = (_direction == DIR_HORIZONTAL) ? "x" : "y";
			_dimensionProp = (_direction == DIR_HORIZONTAL) ? "width" : "height";
			_positionMouseProp = (_direction == DIR_HORIZONTAL) ? "localX" : "localY";
			
			
			
			if(isNaN(_cursorSize)) _cursorSize = cursor[_dimensionProp];
			
			if (!isNaN(_dynamicTrackSize)) track[_dimensionProp] = _dynamicTrackSize;
			if(isNaN(_trackSize)) _trackSize = track[_dimensionProp];
			
			track.addEventListener(MouseEvent.CLICK, onClick);
			
			//todo : drag and drop
			if (_uiMode == MODE_CURSOR) {
				cursor.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragCursor);
				_objtpl.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseCursor);
				//_objtpl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				_objtpl.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
			}
			
			
			_bInit = true;
			this.progress = 0;
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// set / get
		
		
		public function set uiMode(value:String):void
		{
			if (value != MODE_CURSOR && value != MODE_FILLING) throw new Error("wrong value for arg mode, possible values are " + MODE_CURSOR + ", " + MODE_FILLING);
			_uiMode = value;
		}
		
		public function set direction(value:String):void 
		{
			_direction = value;
		}
		
		public function set dynamicTrackSize(value:Number):void 
		{
			_dynamicTrackSize = value;
			track[_dimensionProp] = _dynamicTrackSize;
			_trackSize = _dynamicTrackSize;
			
			if (_bInit) this.progress = _progress;
		}
		public function get dynamicTrackSize():Number
		{
			return _dynamicTrackSize;
		}
		
		public function set cursorSize(value:Number):void 
		{
			_cursorSize = value;
		}
		
		public function set trackSize(value:Number):void 
		{
			_trackSize = value;
		}
		
		
		
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void
		{
			if (!_bInit) throw new Error("you must call init before");
			//if (value < 0 || value > 1) throw new Error("property progress must be set in interval [0,1]");
			
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			_progress = value;
			
			if (_uiMode == MODE_CURSOR) {
				cursor[_positionProp] = _progress * (_trackSize - _cursorSize);
			}
			else if (_uiMode == MODE_FILLING) {
				filling[_positionProp] = 0;
				filling[_dimensionProp] = _trackSize * _progress;
			}
			else throw new Error("_mode " + _uiMode + " doesn't exist");
			
		}
		
		
		
		public function set angleRotation(valueDegree:Number):void 
		{
			_angleRotation = valueDegree;
		}
		
		public function set template(value:String):void 
		{
			_template = value;
		}
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function setPositionPixel(value:Number):void
		{
			var _position:Number;
			if (_uiMode == MODE_CURSOR) {
				_position = value - _cursorSize / 2;
				if (_position < 0) _position = 0;
				if (_position > _trackSize - _cursorSize) _position = _trackSize - _cursorSize;
				cursor[_positionProp] = _position;
			}
			else if (_uiMode == MODE_FILLING) {
				filling[_positionProp] = 0;
				_position = value;
				if (_position < 0) _position = 0;
				if (_position > _trackSize) _position = _trackSize;
				filling[_dimensionProp] = _position;
			}
			else throw new Error("_mode " + _uiMode + " doesn't exist");
			
		}
		
		private function getProgressByPosition():Number
		{
			var _progress:Number;
			if (_uiMode == MODE_CURSOR) {
				_progress = cursor[_positionProp] / (_trackSize - _cursorSize);
			}
			else if (_uiMode == MODE_FILLING) {
				_progress = filling[_dimensionProp] / _trackSize;
				trace("_trackSize : " + _trackSize);
			}
			else throw new Error("_mode " + _uiMode + " doesn't exist");
			return _progress;
		}
		
		
		
		//_______________________________________________________________________________
		// events
		
		private function onClick(e:MouseEvent):void 
		{
			trace("onClick " + e[_positionMouseProp]);
			
			var _posMouse:Number = e[_positionMouseProp];
			//
			var _pt:Point = (_direction == DIR_HORIZONTAL) ? new Point(_posMouse, 0) : new Point(0, _posMouse);
			//_pt = this.globalToLocal(_pt);
			var _posMouse = (_direction == DIR_HORIZONTAL) ? _pt.x : _pt.y;
			_posMouse = Math.abs(Math.cos((_angleRotation * Math.PI / 180)) * _posMouse);
			
			
			trace("Math.cos(_angleRotation * Math.PI / 180) : " + Math.cos(_angleRotation * Math.PI / 180));
			trace("_posMouse : " + _posMouse);
			
			//___________________
			
			setPositionPixel(_posMouse);
			
			var evt:TimelineEvent = new TimelineEvent(TimelineEvent.USER_CHANGE);
			evt.progress = getProgressByPosition();
			this.progress = evt.progress;
			this.dispatchEvent(evt);
			
		}
		
		
		private function onStartDragCursor(e:MouseEvent):void 
		{
			trace("onStartDragCursor");
			_isDragging = true;
			
		}
		
		
		
		private function onReleaseCursor(e:MouseEvent):void 
		{
			stopDragCursor();
		}
		
		/*
		private function onMouseOut(e:MouseEvent):void 
		{
			trace("Timeline.onMouseOut");
			if (e.localX > 0 && e.localX < _trackSize) return;
			stopDragCursor();
		}
		*/
		
		private function stopDragCursor():void 
		{
			_isDragging = false;
		}
		private function onMousemove(e:MouseEvent):void 
		{
			/*
			if (e.localX < 0 || e.localX>_trackSize) stopDragCursor();
			else if (Math.abs(e.localY) > cursor.height) stopDragCursor();
			*/
			if (_isDragging) {
				setPositionPixel(_objtpl.mouseX);
				var evt:TimelineEvent = new TimelineEvent(TimelineEvent.USER_CHANGE);
				evt.progress = getProgressByPosition();
				this.progress = evt.progress;
				this.dispatchEvent(evt);
			}
		}
		
		
		
	}

}


/*
 * TODO : 
 * 
 * drag & drop
 * possibilité d'implémenter sa propre classe pour un des sous-composants
 * 
 **/

