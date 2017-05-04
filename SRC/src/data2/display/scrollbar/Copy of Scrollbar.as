/*
TODO :
	molette marche plus
	voir si on peut s'affranchir de stage (voir si c judicieux d'ailleurs)
	interface pour méthod init et postinit (aussi pour Skin)
	definition de la width en fonction du child (padding-right) ?
*/


package data2.display.scrollbar {
	
	import data2.debug.InterfaceTrace;
	import data2.InterfaceSprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import data2.layoutengine.LayoutSprite;
	//import flash.Date;
	//import ScrollbarEvent;
	
	
	public dynamic class Scrollbar_ extends LayoutSprite {
		
		public static const ASSET_TRACK:String = "assetTrack";
		public static const ASSET_HANDLE:String = "assetHandle";
		public static const ASSET_BTNUP:String = "assetBtnup";
		public static const ASSET_BTNDOWN:String = "assetBtndown";
		
		private var mcTarget:DisplayObject;
		//declared manually in flash authoring tool
		private var mcHandle_as:MovieClip;
		private var mcTrack_as:MovieClip;
		private var mcBtnup_as:MovieClip;
		private var mcBtndown_as:MovieClip;
		
		private var isup:Boolean, isdown:Boolean;
		private var isclicktrack:Boolean;
		private var isDraging:Boolean;
		private var click_count:int;
		private var rectMask:Shape;
		private var _stage:DisplayObjectContainer;
		private var _stageReal:Stage;
		
		private var _width:Number, _height:Number;
		private var shift_drag:Number;
		private var top, bottom:Number;
		
		private var mouseOver:Boolean = false;
		private var _enabled:Boolean;
		private var _contentheight:Number;
		private var _forceContentHeight:Boolean;
		
		private var date1, date2:Date;
		private var timelimit_scroll:Number = 10;
		public var handleSpeed:Number;
		public var wheelSpeed:Number;
		public var click_sleep:int;
		private var fullscreen:Boolean;
		private var _debug:Boolean;
		private var _scroll:Number;
		private var _scrollPx:Number;
		
		
		
		private var _arrow:Boolean;
		private var _handleAutoSize:Boolean;
		private var _always_visible:Boolean;
		private var _template:String;
		private var _scrollneeded:Boolean;
		private var _touchMode:Boolean;
		private var _lock:Boolean;
		
		
		
		//public functions____________________________________________________
		
		public function Scrollbar_() 
		{
			handleSpeed = 5;
			wheelSpeed = 3;
			click_sleep = 10;
			fullscreen = false;
			_forceContentHeight = false;
			_touchMode = false;
			
			//default values
			_arrow = false;
			_handleAutoSize = false;
			_always_visible = true;
			_width = 150;
			_height = 200;
			_scroll = 0;
			_scrollPx = 0;
			_lock = false;
		}
		
		
		
		
		public override function set width(v:Number):void
		{
			_width = v;
			this.layoutWidth = _width;
		}
		
		public override function get width():Number
		{
			return _width;
		}
		
		public function get contentWidth():Number
		{
			var _maxWidth:Number = 0;
			if (mcHandle_as.width > _maxWidth) _maxWidth = mcHandle_as.width;
			if (mcTrack_as.width > _maxWidth) _maxWidth = mcTrack_as.width;
			if (mcBtnup_as.width > _maxWidth) _maxWidth = mcBtnup_as.width;
			if (mcBtndown_as.width > _maxWidth) _maxWidth = mcBtndown_as.width;
			return _width - _maxWidth;
		}
		
		public override function set height(v:Number):void
		{
			_height = v;
			this.layoutHeight = _height;
		}
		
		public function set arrow(b:Boolean):void {
			//trace("Scrollbar.set arrow (" + b + ")");
			_arrow = b;
		}
		
		
		public function set contentheight(value:Number):void 
		{
			_contentheight = value;
			_forceContentHeight = true;
		}
		
		public function get always_visible():Boolean {return _always_visible;}
		
		public function set always_visible(value:Boolean):void {_always_visible = value;}
		
		public function get handleAutoSize():Boolean {return _handleAutoSize;}
		
		public function set handleAutoSize(value:Boolean):void {_handleAutoSize = value;}
		
		public function get template():String {return _template;}
		
		public function set template(value:String):void{ _template = value;}
		
		public function set debug(value:Boolean):void {_debug = value;}
		
		public function get scroll():Number {return _scroll;}
		
		public function set scroll(value:Number):void 
		{
			_scroll = value;
			scrollTo(_scroll * 100);
		}
		
		public function get scrollPx():Number { return _scrollPx; }
		
		public function set scrollPx(_value:Number):void
		{
			_scrollPx = _value;
			scrollToPx(_value);
		}
		
		public function get scrollneeded():Boolean
		{
			//return _scrollneeded;
			//trace("scrolleeded ? (" + _contentheight + " > " + _height + ") : " + (_contentheight > _height));
			return (_contentheight > _height);
			
		}
		
		public function set touchMode(value:Boolean):void {_touchMode = value;}
		
		public function set lock(value:Boolean):void { _lock = value; }
		
		
		
		
		public function update():void
		{
			//si la prop contentheight n'a pas été défini, on prend mcTarget.height
			if (!_forceContentHeight) {
				if(_debug) trace("get real height");
				_contentheight = mcTarget.height;
			}
			
			//start new
			setSize(_height);
			
			//reglage top / bottom
			if(_arrow){
				top = mcBtnup_as.height;
				bottom = _height - mcBtndown_as.height;
			}
			else{
				top = 0;
				bottom = _height;
			}
			//end new
			onresize(new Event(""));
			keepHandleOnTrack();
			updateMC(new MouseEvent(""));
			
			if (_touchMode) setBackgroundTarget();
		}
		
		
		
		
		public function scrollTo(percent:Number):void
		{
			_scrollPx = percent / 100 * (bottom - mcHandle_as.height - top);
			mcHandle_as.y = top + _scrollPx;
			keepHandleOnTrack();
			updateMC(new MouseEvent(""));
		}
		
		public function scrollToPx(_px:Number):void
		{
			mcHandle_as.y = top + _px;
			keepHandleOnTrack();
			updateMC(new MouseEvent(""));
		}
		
		
		
		
		
		public function scrollToPxContent(_px:Number):void
		{
			
		}
		
		
		
		public override function addChild(obj:DisplayObject):DisplayObject
		{
			//trace("Scrollbar.addChild(" + obj + ")");
			if (this.numChildren > 0) throw new Error("Scrollbar :: you can only add 1 child");
			super.addChild(obj);
			mcTarget = obj;
			mcTarget.x = 0;
			mcTarget.y = 0;
			return obj;
		}
		
		
		
		
		public function init(__stage:DisplayObjectContainer, __stageReal:Stage):void
		{
			if (mcTarget == null) throw new Error("Scrollbar :: you must addChild something before use method init");
			if (_template == null) throw new Error("Scrollbar : you must set template property");
			
			var _skinClass:Class = Class(getDefinitionByName(_template));
			var _skinObj:Sprite = new _skinClass();
			
			
			
			mcHandle_as = MovieClip(_skinObj.getChildByName("mcHandle"));
			mcTrack_as = MovieClip(_skinObj.getChildByName("mcTrack"));
			mcBtnup_as = MovieClip(_skinObj.getChildByName("mcBtnup"));
			mcBtndown_as = MovieClip(_skinObj.getChildByName("mcBtndown"));
			
			if (mcHandle_as == null) throw new Error("Scrollbar : template must contain occurences named mcHandle, mcTrack, mcBtnup, mcBtndown");
			if (mcTrack_as == null) throw new Error("Scrollbar : template must contain occurences named mcHandle, mcTrack, mcBtnup, mcBtndown");
			if (mcBtnup_as == null) throw new Error("Scrollbar : template must contain occurences named mcHandle, mcTrack, mcBtnup, mcBtndown");
			if (mcBtndown_as == null) throw new Error("Scrollbar : template must contain occurences named mcHandle, mcTrack, mcBtnup, mcBtndown");
			
			
			super.addChild(mcTrack_as);
			super.addChild(mcHandle_as);
			super.addChild(mcBtnup_as);
			super.addChild(mcBtndown_as);
			
			
			//arrow visible
			//trace("Scrollbar.init " + _arrow);
			//mcBtnup_as.visible = _arrow;
			//mcBtndown_as.visible = _arrow;
			setAssetAvailable(mcBtnup_as, _arrow);
			setAssetAvailable(mcBtndown_as, _arrow);
			
			
			//width : fonctionne sur la taille globale (assets compris)
			mcHandle_as.x = _width - mcHandle_as.width;
			mcTrack_as.x = _width - mcHandle_as.width;
			mcBtnup_as.x = _width - mcHandle_as.width;
			mcBtndown_as.x = _width - mcHandle_as.width;
			
			
			
			
			isup = false;
			isdown = false;
			isclicktrack = false;
			isDraging = false;
			click_count = 0;
			if (rectMask != null && this.contains(rectMask)) super.removeChild(rectMask);
			rectMask = new Shape();
			super.addChild(rectMask);
			_stage = __stage;
			_stageReal = __stageReal;
			
			setSize(_height);
			
			//reglage top / bottom
			if(_arrow){
				top = mcBtnup_as.height;
				bottom = _height - mcBtndown_as.height;
			}
			else{
				top = 0;
				bottom = _height;
			}
			
			//positionnement interne
			mcBtnup_as.y = 0;
			mcTrack_as.y = top;
			mcHandle_as.y = top;
			
			
			
			//stop la lecture des sous-clips
			mcTrack_as.gotoAndStop(1);
			mcHandle_as.gotoAndStop(1);
			mcBtnup_as.gotoAndStop(1);
			mcBtndown_as.gotoAndStop(1);
			
			mcHandle_as.buttonMode = true;
			mcBtnup_as.buttonMode = true;
			mcBtndown_as.buttonMode = true;
			
			
			//mask, multiinit, component
			update();
			_stage.addEventListener(Event.RESIZE, onresize);
			updateMC(new MouseEvent(""));
			
			if (_touchMode) {
				/*
				mcTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownTarget);
				mcTarget.addEventListener(MouseEvent.MOUSE_UP, onMouseUpTarget);
				mcTarget.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveTarget);
				*/
				addMouseListener(mcTarget, MouseEvent.MOUSE_DOWN, onMouseDownTarget);
				addMouseListener(_stage, MouseEvent.MOUSE_UP, onMouseUpTarget);
				addMouseListener(_stage, MouseEvent.MOUSE_MOVE, onMouseMoveTarget);
				
				setBackgroundTarget();
				
				
				
			}
		}
		
		private function addMouseListener(_target:DisplayObject, _type:String, _handler:Function):void 
		{
			
			if (_type == MouseEvent.MOUSE_DOWN) {
				_target.addEventListener(TouchEvent.TOUCH_BEGIN, _handler);
			}
			else if (_type == MouseEvent.MOUSE_UP) {
				_target.addEventListener(TouchEvent.TOUCH_END, _handler);
			}
			else if (_type == MouseEvent.MOUSE_MOVE) {
				_target.addEventListener(TouchEvent.TOUCH_MOVE, _handler);
			}
			
			if (!Multitouch.supportsTouchEvents) {
				_target.addEventListener(_type, _handler);
			}
			
		}
		
		
		
		
		private function enableMouseEvent(_dobj:DisplayObject, _value:Boolean):void
		{
			//if (_dobj is InteractiveObject) InteractiveObject(_dobj).mouseEnabled = _value;
			if (_dobj is DisplayObjectContainer) DisplayObjectContainer(_dobj).mouseChildren = _value;
		}
		
		
		private function setBackgroundTarget():void
		{
			if (mcTarget is DisplayObjectContainer) {
				
				
				var mcT:DisplayObjectContainer = DisplayObjectContainer(mcTarget);
				if (_bgTarget == null) {
					_bgTarget = new Sprite();
				}
				
				if (mcT is InterfaceSprite) {
					var _is:InterfaceSprite = InterfaceSprite(mcT);
					_is.simpleAddChildAt(_bgTarget, 0);
				}
				else {
					mcT.addChildAt(_bgTarget, 0);
				}
				
				var g:Graphics = _bgTarget.graphics;
				g.clear();
				g.beginFill(0xFF0000, 0.0);
				g.drawRect(0, 0, _width, mcT.height);
				
				
				if (_debug) {
					trace("_______________________________");
					trace("setBackgroundTarget");
					trace("mcT dims : " + _width + ", " + mcT.height);
				}
			}
			else trace("not a DobjContainer");
		}
		
		private function setEvents()
		{
			//Events______
			//drag handle
			mcHandle_as.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);
			mcHandle_as.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			//click on track
			mcTrack_as.addEventListener(MouseEvent.MOUSE_DOWN, clicktrack);
			mcTrack_as.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			//mcTrack_as.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcTrack_as.addEventListener(Event.ENTER_FRAME, clicktrackHandler);
			//btn up & down
			mcBtnup_as.addEventListener(MouseEvent.MOUSE_DOWN, scrollup);
			mcBtnup_as.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			mcBtnup_as.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcBtnup_as.addEventListener(Event.ENTER_FRAME, scrollupHandler);
			mcBtndown_as.addEventListener(MouseEvent.MOUSE_DOWN, scrolldown);
			mcBtndown_as.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			mcBtndown_as.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcBtndown_as.addEventListener(Event.ENTER_FRAME, scrolldownHandler);
			//mouse wheel
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//roll out
			mcTrack_as.addEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcTrack_as.addEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcHandle_as.addEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcHandle_as.addEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcBtnup_as.addEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcBtnup_as.addEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcBtndown_as.addEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcBtndown_as.addEventListener(MouseEvent.MOUSE_UP, onrollout);
			//rollover
			mcTrack_as.addEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcHandle_as.addEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcBtnup_as.addEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcBtndown_as.addEventListener(MouseEvent.ROLL_OVER, onrollover);
			//mouse down
			mcTrack_as.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcHandle_as.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcBtnup_as.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcBtndown_as.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onDetectMousePosition);
		}
		
		private function unsetEvents()
		{
			//Events______
			//drag handle
			mcHandle_as.removeEventListener(MouseEvent.MOUSE_DOWN, startScroll);
			mcHandle_as.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			//click on track
			mcTrack_as.removeEventListener(MouseEvent.MOUSE_DOWN, clicktrack);
			mcTrack_as.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			//mcTrack_as.removeEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcTrack_as.removeEventListener(Event.ENTER_FRAME, clicktrackHandler);
			//btn up & down
			mcBtnup_as.removeEventListener(MouseEvent.MOUSE_DOWN, scrollup);
			mcBtnup_as.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			mcBtnup_as.removeEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcBtnup_as.removeEventListener(Event.ENTER_FRAME, scrollupHandler);
			mcBtndown_as.removeEventListener(MouseEvent.MOUSE_DOWN, scrolldown);
			mcBtndown_as.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			mcBtndown_as.removeEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			mcBtndown_as.removeEventListener(Event.ENTER_FRAME, scrolldownHandler);
			//mouse wheel
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//roll out
			mcTrack_as.removeEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcTrack_as.removeEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcHandle_as.removeEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcHandle_as.removeEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcBtnup_as.removeEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcBtnup_as.removeEventListener(MouseEvent.MOUSE_UP, onrollout);
			mcBtndown_as.removeEventListener(MouseEvent.ROLL_OUT, onrollout);
			mcBtndown_as.removeEventListener(MouseEvent.MOUSE_UP, onrollout);
			//rollover
			mcTrack_as.removeEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcHandle_as.removeEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcBtnup_as.removeEventListener(MouseEvent.ROLL_OVER, onrollover);
			mcBtndown_as.removeEventListener(MouseEvent.ROLL_OVER, onrollover);
			//mouse down
			mcTrack_as.removeEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcHandle_as.removeEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcBtnup_as.removeEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			mcBtndown_as.removeEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDetectMousePosition);
		}
		
		private function onresize(e:Event):void
		{
			if(fullscreen) setFullscreen();
			if(_handleAutoSize) mcHandle_as.height = getHandleHeight();
			setMask();
			
			if (_debug) trace("_contentheight : " + _contentheight);
			//if scroll needed
			if (_contentheight > _height + 0.1) {
				_scrollneeded = true;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCROLL_SHOW));
				drawMask();
				this.layoutHeight = _height;
				
				//mcHandle_as.visible = true;
				setAssetAvailable(mcHandle_as, true);
				if(!_always_visible){
					if (_arrow) {
						trace("Scrollbar on resize set arrow visible");
						//mcBtnup_as.visible = true;
						//mcBtndown_as.visible = true;
						setAssetAvailable(mcBtnup_as, true);
						setAssetAvailable(mcBtndown_as, true);
						
					}
					//mcTrack_as.visible = true;
					setAssetAvailable(mcTrack_as, true);
				}
				unsetEvents();
				setEvents();
			}
			else {
				_scrollneeded = false;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCROLL_HIDE));
				drawMask(_contentheight);
				this.layoutHeight = _contentheight;
				//mcHandle_as.visible = false;
				setAssetAvailable(mcHandle_as, false);
				if(!_always_visible){
					if(_arrow){
						//mcBtnup_as.visible = false;
						//mcBtndown_as.visible = false;
						setAssetAvailable(mcBtnup_as, false);
						setAssetAvailable(mcBtndown_as, false);
					}
					//mcTrack_as.visible = false;
					setAssetAvailable(mcTrack_as, false);
				}
				scrollTo(0);
				unsetEvents();
			}
		}
		
		private function setMask():void
		{
			if(mcTarget==null) throw new Error("Scrollbar :: child must be added before calling method init()");
			drawMask();
			if(_debug) trace("_height : " + _height);
			mcTarget.mask = rectMask;
		}
		
		private function drawMask(__h:Number=-1):void
		{
			var x1:Number = 0;
			if(fullscreen) x1 = 0;
			var y1:Number = 0;
			var x2:Number = mcHandle_as.x;
			//if(!mcTrack_as.visible) x2 += mcHandle_as.width;
			if (!this.contains(mcTrack_as)) x2 += mcHandle_as.width;
			
			var y2:Number;
			/*
			if (__h == -1) y2 = mcBtndown_as.y + mcBtndown_as.height;
			else y2 = __h;
			*/
			y2 = _height;
			if(_debug) trace("drawMask " + x1 + ", " + y1 + ", " + x2 + ", " + y2);
			
			rectMask.graphics.clear();
			rectMask.graphics.beginFill(0xff0000, 0.5);
			rectMask.graphics.drawRect(x1, y1, x2, y2);
		}
		
		
		
		
		
		//private functions________________________________________________________
		
		//drag handle
		private function startScroll(e:MouseEvent):void
		{
			startdrag();
			mcHandle_as.addEventListener(MouseEvent.MOUSE_MOVE, updateMC);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);	//release outside
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, updateMC);
		}
		
		private function stopScroll(e:MouseEvent):void
		{
			isup = false;
			isdown = false;
			isclicktrack = false;
			click_count = 0;
			stopdrag();
			mcHandle_as.removeEventListener(MouseEvent.MOUSE_MOVE, updateMC);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateMC);
			
			if (_touchMode) {
				_touchMouseDown = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterframeCaptureMove);
			}
		}
		
		//click on track
		private function clicktrack(e:MouseEvent):void
		{
			isclicktrack = true;
		}
		
		private function clicktrackHandler(e:Event):void
		{
			if(isclicktrack){
				if(click_count==0 || click_count>click_sleep){
					var d:Number = mcHandle_as.height;
					if(mouseY<mcHandle_as.y) d *= -1;
					mcHandle_as.y += d;
					keepHandleOnTrack();
					updateMC(new MouseEvent(""));
					//sécurité pour éviter les haut-bas...
					if(mouseY>mcHandle_as.y && mouseY<mcHandle_as.y+mcHandle_as.height)
						stopScroll(new MouseEvent(""));
				}
				click_count++;
			}
		}
		
		
		//scroll up
		private function scrollup(e:MouseEvent):void
		{
			if (_lock) return;
			isup = true;
		}
		private function scrollupHandler(e:Event):void
		{
			if(isup){
			 	if(click_count==0 || click_count>click_sleep){
					mcHandle_as.y -= handleSpeed;
					keepHandleOnTrack();
					updateMC(new MouseEvent(""));
				}
				click_count++;
			}
		}
		//scroll down
		private function scrolldown(e:MouseEvent):void
		{
			if (_lock) return;
			isdown = true;
		}
		private function scrolldownHandler(e:Event):void
		{
			if(isdown){
				if(click_count==0 || click_count>click_sleep){
					mcHandle_as.y += handleSpeed;
					keepHandleOnTrack();
					updateMC(new MouseEvent(""));
				}
				click_count++;
			}
		}
		//mouse wheel
		private function onMouseWheel(e:MouseEvent):void
		{
			if (_lock) return;
			if(_touchMode) this.removeEventListener(Event.ENTER_FRAME, onThrowEnterframe);
			
			//if(!_enabled) return;
			if(date1!=null){
				date2 = new Date();
				if(date2.time - date1.time < timelimit_scroll) return;
			}
			date1 = new Date();
			if(mouseOver){
				mcHandle_as.y -= e.delta * 6;
				keepHandleOnTrack();
				updateMC(e);
			}
		}
		
		private function keepHandleOnTrack():void
		{
			if (mcHandle_as.y > (bottom - mcHandle_as.height)) mcHandle_as.y = bottom - mcHandle_as.height;
			else if (mcHandle_as.y < top) mcHandle_as.y = top;
		}
		
		
		private function updateMC(e:MouseEvent):void
		{
			mcTarget.y = handle2mc(mcHandle_as.y - top);
			_scroll = mcHandle_as.y / (mcTrack_as.height - mcHandle_as.height);
			_scrollPx = mcHandle_as.y - top;
		}
		
		private function getHandleHeight():Number
		{
			var _value:Number = _height / _contentheight * mcTrack_as.height;
			if(_value > mcTrack_as.height) _value = mcTrack_as.height;
			return _value;
			
		}
		
		private function setSize(_h:Number):void
		{
			if(_arrow) mcTrack_as.height = _h - mcBtnup_as.height - mcBtndown_as.height;
			else mcTrack_as.height = _h;
			if (!_handleAutoSize && mcTrack_as.height < mcHandle_as.height) throw new Error("Scrollbar :: if !handleAutoSize, property height must be > than handle.height (defined in flash authoring tool)");
			mcBtndown_as.y = _h - mcBtndown_as.height;
		}
		
		private function setFullscreen():void
		{
			var w:Number = _stageReal.stageWidth;
			var h:Number = _stageReal.stageHeight;
			this.x = w - mcTrack_as.width - 1;
			this.y = mcBtnup_as.height;
			setSize(h);
		}
		
		private function handle2mc(_y:Number):Number
		{
			var length_movemc:Number = - (_contentheight - _height);
			var _divide:Number = mcTrack_as.height - mcHandle_as.height;
			if (_divide == 0) return 0;
			return _y * length_movemc / _divide;
		}
		
		//aspects btns
		private function onrollout(e:MouseEvent):void
		{
			//e.target.gotoAndStop(1);
			if(e.target==mcHandle_as && !isDraging) e.target.gotoAndStop(1);
		}
		private function onrollover(e:MouseEvent):void
		{
			//e.target.gotoAndStop(2);
			if(e.target==mcHandle_as) e.target.gotoAndStop(2);
		}
		private function onmousedown(e:MouseEvent):void
		{
			//e.target.gotoAndStop(3);
			if(_touchMode) this.removeEventListener(Event.ENTER_FRAME, onThrowEnterframe);
		}
		
		private function startdrag()
		{
			isDraging = true;
			mcHandle_as.gotoAndStop(2);
			/*
			var pt:Point = new Point(_stage.mouseX, _stage.mouseY);
			pt = this.globalToLocal(pt);
			*/
			
			var pt:Point = getLocalMousePosition();
			shift_drag = mcHandle_as.y - pt.y;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
		}
		
		private function getLocalMousePosition():Point 
		{
			/*
			var pt:Point = new Point(_stage.mouseX, _stage.mouseY);
			pt = this.globalToLocal(pt);
			*/
			var pt:Point = new Point(this.mouseX, this.mouseY);
			return pt;
		}
		
		private function stopdrag()
		{
			isDraging = false;
			mcHandle_as.gotoAndStop(1);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
		}
		
		private function onMousemove(e:MouseEvent)
		{
			if (_lock) return;
			/*
			var pt:Point = new Point(_stage.mouseX, _stage.mouseY);
			pt = this.globalToLocal(pt);
			*/
			var pt:Point = getLocalMousePosition();
			
			mcHandle_as.y = pt.y + shift_drag;
			
			keepHandleOnTrack();
			//trace("mcHandle_as.y : " + mcHandle_as.y);
		}
		
		
		
		private var _touchPosition:Point;
		private var _touchPositionInit:Point;
		private var _touchMouseDown:Boolean = false;
		private var _bgTarget:Sprite;
		private var _touchThrowDelta:Number;
		private var _targetClickDisabled:Boolean = false;
		private var _listScrollMove:Array;
		
		private function onMouseDownTarget(e:Event):void 
		{
			
			if (_lock) return;
			
			if (e is TouchEvent) {
				var _te:TouchEvent = TouchEvent(e);
				_touchPosition = this.globalToLocal(new Point(_te.stageX, _te.stageY));
			}
			else {
				InterfaceTrace.trace2("Scrollbar.onMouseDownTarget");
				_touchPosition = new Point(this.mouseX, this.mouseY);
			}
			
			this.removeEventListener(Event.ENTER_FRAME, onThrowEnterframe);
			_touchPositionInit = new Point(mcTarget.x, mcTarget.y);
			_touchMouseDown = true;
			_listScrollMove = new Array();
			_stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			
			_listScrollMove.push(this.mouseY);
			this.addEventListener(Event.ENTER_FRAME, onEnterframeCaptureMove);
			
		}
		
		
		private function onMouseUpTarget(e:Event):void 
		{
			if (_lock) return;
			if (!_touchMouseDown) return;
			_touchMouseDown = false;
			
			this.removeEventListener(Event.ENTER_FRAME, onEnterframeCaptureMove);
			InterfaceTrace.trace2("Scrollbar.onMouseUpTarget");
			
			var _deltapos:Number = Math.abs(_touchPositionInit.y - mcTarget.y);
			//trace("_deltapos : " + _deltapos);
			enableMouseEvent(mcTarget, true);
			_targetClickDisabled = false;
			
			var _delta:Number = getDeltaTouchDrop();
			trace("_delta : " + _delta);
			_delta *= 0.4;	//to affine
			//trace("_delta : " + _delta);
			throwAfterTouch( -_delta);
			
		}
		
		
		private function throwAfterTouch(_delta:Number):void
		{
			_touchThrowDelta = _delta;
			this.addEventListener(Event.ENTER_FRAME, onThrowEnterframe);
		}
		
		private function onThrowEnterframe(e:Event):void 
		{
			if (_lock) return;
			mcHandle_as.y += _touchThrowDelta;
			keepHandleOnTrack();
			updateMC(new MouseEvent(""));
			
			
			_touchThrowDelta *= 0.86;
			//trace("_touchThrowDelta : " + _touchThrowDelta);
			if (Math.abs(_touchThrowDelta) < 0.5) this.removeEventListener(Event.ENTER_FRAME, onThrowEnterframe);
		}
		
		private function getDeltaTouchDrop():Number 
		{
			var _nbvalue:Number = 4;
			var _len:int = _listScrollMove.length;
			if (_len == 0) return 0;
			//trace("_listScrollMove : " + _listScrollMove);
			var _firstindex:int = _len - _nbvalue;
			if (_firstindex < 0) _firstindex = 0;
			trace("_listScrollMove : " + _listScrollMove);
			var _delta:Number = _listScrollMove[_len - 1] - _listScrollMove[_firstindex];
			return _delta;
		}
		
		
		private function onEnterframeCaptureMove(e:Event):void 
		{
			_listScrollMove.push(this.mouseY);
		}
		
		private function onMouseMoveTarget(e:Event):void 
		{
			if (_lock) return;
			if (_touchMouseDown) {
				
				var _touchDelta:Number;
				
				this.mouseX
				if (e is TouchEvent) {
					var _te:TouchEvent = TouchEvent(e);
					//_touchDelta = _te.stageY - _touchPosition.y;
					//_touchDelta = this.mouseY - _touchPosition.y;
					
					var _position:Point = this.globalToLocal(new Point(_te.stageX, _te.stageY));
					_touchDelta = _position.y - _touchPosition.y;
					
				}
				else {
					_touchDelta = this.mouseY - _touchPosition.y;
				}
				
				
				/*
				if (!_targetClickDisabled && Math.abs(_touchDelta) > 5) {
					trace(" - disable mouseevent");
					enableMouseEvent(mcTarget, false);
					_targetClickDisabled = true;
				}
				*/
				
				var _newpos:Point = new Point();
				_newpos.y = _touchPositionInit.y + _touchDelta;
				//trace("_newpos.y= " + _touchPositionInit.y + " + " + _touchDelta);
				var _posmax:Number = _height - mcTarget.height;
				var _ratio:Number = _newpos.y / _posmax;
				this.scroll = _ratio;
				
			}
			
		}
		
		
		
		
		private function onDetectMousePosition(e:MouseEvent)
		{				
			var p:Point = this.localToGlobal(new Point(0, 0));
			var _xmouse, _ymouse:Number;
			_xmouse = _stage.mouseX;
			_ymouse = _stage.mouseY;
			if(_xmouse>p.x && _xmouse<p.x+_width && _ymouse>p.y && _ymouse<p.y+_height) mouseOver = true;
			else mouseOver = false;
		}
		
		
		private function setAssetAvailable(_asset:DisplayObject, _b:Boolean):void
		{
			
			if (!this.contains(_asset)) {
				this.addChild(_asset);
			}
			_asset.visible = _b;
			
			
			/*
			if (_b && !this.contains(_asset)) {
				if (_asset == mcTrack_as) super.addChildAt(_asset, 0);
				else super.addChild(_asset);
			}
			else if (!_b && this.contains(_asset)) {
				super.removeChild(_asset);
			}
			_asset.visible = _b;
			*/
		}
		
	}
	
}