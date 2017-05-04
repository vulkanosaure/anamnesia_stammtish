/*
import data.layout.scrollbar.Scrollbar;
scrollbar = new Scrollbar();
scrollbar.x = 0;
scrollbar.y = 0;
scrollbar.width = w;
scrollbar.height = h;
scrollbar.autoSize = false;
scrollbar.arrowVisible = false;
scrollbar.always_visible = true;
addChild(scrollbar);
scrollbar.addChild(mc);
scrollbar.init(_stage);
*/


package data.layout.scrollbar {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	//import flash.Date;
	//import ScrollbarEvent;
	
	
	public dynamic class Scrollbar extends MovieClip {
		
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
		private var _stage:Stage;
		private var _width:Number, _height:Number;
		private var shift_drag:Number;
		private var top, bottom:Number;
		private var _arrowVisible:Boolean = true;
		private var mouseOver:Boolean = false;
		private var _enabled:Boolean;
		private var _contentheight:Number;
		private var _forceContentHeight:Boolean;
		
		private var date1, date2:Date;
		private var timelimit_scroll:Number = 10;
		
		public var autoSize:Boolean;
		public var handleSpeed:Number;
		public var wheelSpeed:Number;
		public var click_sleep:int;
		public var fullscreen:Boolean;
		public var always_visible:Boolean;
		public var debug:Boolean;
		
		
		
		
		//public functions____________________________________________________
		
		public function Scrollbar() 
		{
			mcTrack_as = mcTrack;
			mcHandle_as = mcHandle;
			mcBtnup_as = mcBtnup;
			mcBtndown_as = mcBtndown;
			
			//default values
			_forceContentHeight = false;
			autoSize = true;
			handleSpeed = 5;
			wheelSpeed = 3;
			click_sleep = 10;
			fullscreen = false;
			always_visible = true;
			debug = false;
			enable();
		}
		
		public override function set x(v:Number):void
		{
			super.x = v;
		}
		
		public override function set y(v:Number):void
		{
			super.y = v;
		}
		
		public override function set width(v:Number):void
		{
			mcHandle_as.x = v - mcHandle_as.width;
			mcTrack_as.x = v - mcHandle_as.width;
			mcBtnup_as.x = v - mcHandle_as.width;
			mcBtndown_as.x = v - mcHandle_as.width;
			_width = v;
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
		}
		
		public function set arrowVisible(b:Boolean):void
		{
			mcBtnup_as.visible = b;
			mcBtndown_as.visible = b;
			_arrowVisible = b;
			if(!b){
			}
			else{
			}
		}
		
		
		public function set contentheight(value:Number):void 
		{
			_contentheight = value;
			_forceContentHeight = true;
		}
		
		public function enable():void
		{
			_enabled = true;
		}
		public function disable():void
		{
			_enabled = false;
		}
		
		public function update():void
		{
			//si la prop contentheight n'a pas été défini, on prend mcTarget.height
			if (!_forceContentHeight) _contentheight = mcTarget.height;
			
			//start new
			setSize(_height);
			
			//reglage top / bottom
			if(_arrowVisible){
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
		}
		
		public function scrollTo(percent:Number):void
		{
			mcHandle_as.y = top + percent/100 * (bottom-mcHandle_as.height-top);
			keepHandleOnTrack();
			updateMC(new MouseEvent(""));
		}
		
		
		public function setCustomAsset(_type:String, _asset:MovieClip):void
		{
			if (_type == ASSET_TRACK) mcTrack_as = _asset;
			else if (_type == ASSET_HANDLE) mcHandle_as = _asset;
			else if (_type == ASSET_BTNUP) mcBtnup_as = _asset;
			else if (_type == ASSET_BTNDOWN) mcBtndown_as = _asset;
			
			super.addChild(mcTrack_as);
			super.addChild(mcHandle_as);
			super.addChild(mcBtnup_as);
			super.addChild(mcBtndown_as);
		}
		
		
		
		public override function addChild(obj:DisplayObject):DisplayObject
		{
			if (mcTarget != null) throw new Error("Scrollbar :: you can't add more than 1 child in method addChild()");
			super.addChild(obj);
			mcTarget = obj;
			mcTarget.x = 0;
			mcTarget.y = 0;
			return obj;
		}
		
		public function init(st:Stage):void
		{
			if (st == null) throw new Error("Scrollbar :: arg stage is null in method init()");
			if (mcTarget == null) throw new Error("Scrollbar :: you must addChild something before use method init");
			
			isup = false;
			isdown = false;
			isclicktrack = false;
			isDraging = false;
			click_count = 0;
			if (rectMask != null) super.removeChild(rectMask);
			rectMask = new Shape();
			super.addChild(rectMask);
			_stage = st;
			
			setSize(_height);
			
			//reglage top / bottom
			if(_arrowVisible){
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
			if(autoSize) mcHandle_as.height = getHandleHeight();
			setMask();
			//if scroll needed
			if (debug) trace("_contentheight : " + _contentheight+", _height : "+_height);
			if(_contentheight > _height+0.1){
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCROLL_SHOW));
				drawMask();
				mcHandle_as.visible = true;
				if(!always_visible){
					if(_arrowVisible){
						mcBtnup_as.visible = true;
						mcBtndown_as.visible = true;
					}
					mcTrack_as.visible = true;
				}
				unsetEvents();
				setEvents();
			}
			else {
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCROLL_HIDE));
				drawMask();
				mcHandle_as.visible = false;
				if(!always_visible){
					if(_arrowVisible){
						mcBtnup_as.visible = false;
						mcBtndown_as.visible = false;
					}
					mcTrack_as.visible = false;
				}
				scrollTo(0);
				unsetEvents();
			}
		}
		
		private function setMask():void
		{
			if(mcTarget==null) throw new Error("Scrollbar :: child must be added before calling method init()");
			drawMask();
			mcTarget.mask = rectMask;
		}
		
		private function drawMask():void
		{
			var x1:Number = 0;
			if(fullscreen) x1 = 0;
			var y1:Number = 0;
			var x2:Number = mcHandle_as.x;
			if(!mcTrack_as.visible) x2 += mcHandle_as.width;
			var y2:Number = mcBtndown_as.y + mcBtndown_as.height;
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
			if(!_enabled) return;
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
			if(mcHandle_as.y > (bottom-mcHandle_as.height)) mcHandle_as.y = bottom-mcHandle_as.height;
			else if(mcHandle_as.y < top) mcHandle_as.y = top;
		}
		
		
		private function updateMC(e:MouseEvent):void
		{
			mcTarget.y = handle2mc(mcHandle_as.y - top);
			
		}
		
		private function getHandleHeight():Number
		{
			if(debug) trace("_contentheight : " + _contentheight);
			var _value:Number = _height / _contentheight * mcTrack_as.height;
			if(_value > mcTrack_as.height) _value = mcTrack_as.height;
			return _value;
			
		}
		
		private function setSize(_h:Number):void
		{
			if(_arrowVisible) mcTrack_as.height = _h - mcBtnup_as.height - mcBtndown_as.height;
			else mcTrack_as.height = _h;
			if (!autoSize && mcTrack_as.height < mcHandle_as.height) throw new Error("Scrollbar :: if !autoSize, property height must be > than handle.height (defined in flash authoring tool)");
			mcBtndown_as.y = _h - mcBtndown_as.height;
		}
		
		private function setFullscreen():void
		{
			var w:Number = _stage.stageWidth;
			var h:Number = _stage.stageHeight;
			this.x = w - mcTrack_as.width - 1;
			this.y = mcBtnup_as.height;
			setSize(h);
		}
		
		private function handle2mc(_y:Number):Number
		{
			if(debug) trace("_contentheight : " + _contentheight);
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
		}
		
		private function startdrag()
		{
			isDraging = true;
			mcHandle_as.gotoAndStop(2);
			var pt:Point = new Point(0, _stage.mouseY);
			pt = this.globalToLocal(pt);
			shift_drag = mcHandle_as.y - pt.y;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
		}
		
		private function stopdrag()
		{
			isDraging = false;
			mcHandle_as.gotoAndStop(1);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMousemove);
		}
		
		private function onMousemove(e:MouseEvent)
		{
			var pt:Point = new Point(0, _stage.mouseY);
			pt = this.globalToLocal(pt);
			mcHandle_as.y = pt.y + shift_drag;
			keepHandleOnTrack();
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
		
	}
	
}