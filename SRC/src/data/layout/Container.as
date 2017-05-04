/*
permet de gérer la position d'un module avec une dimension de scène variable (full-screen)
notes : doit etre ajouté sur le stage (et pas ds un sous dobjc)
forcesize permet de définir soi meme les dimensions (car les objets utilisant des masques ont une taille apparente != de leur taille réelle)

exemple :
import data.fx.Container;
import flash.display.DisplayObject;
var cont:Container = new Container(stage, [forcesize=false, width, height]);
addChild(cont);
cont.setHorizontalPosition("PIXEL", "RIGHT", 0);
cont.setVerticalPosition("PERCENT", "TOP", 50);
*/



package data.layout {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	
	
	public dynamic class Container extends MovieClip{
		
		var h_type:String;
		var h_side:String;
		var h_value:Number;
		
		var v_type:String;
		var v_side:String;
		var v_value:Number;
		
		var b_horizontal:Boolean = false;
		var b_vertical:Boolean = false;
		
		var st:Stage;
		var forcesize:Boolean;
		var force_width:Number;
		var force_height:Number;
		
		var forcestagesize:Boolean;
		var force_stagewidth:Number;
		var force_stageheight:Number;
		
		var save_width:Number;
		var save_height:Number;
		
		var _shiftx:Number = 0;
		var _shifty:Number = 0;
		
		var _enabled:Boolean = true;
		var _useVisibleDimensions:Boolean = false;
		
		var handle_resize:Boolean;
		public var debugMode:Boolean = false;
		
		//constantes
		public static var TYPE_PIXEL:String = "PIXEL";
		public static var TYPE_PERCENT:String = "PERCENT";
		public static var SIDE_LEFT:String = "LEFT";
		public static var SIDE_RIGHT:String = "RIGHT";
		public static var SIDE_TOP:String = "TOP";
		public static var SIDE_BOTTOM:String = "BOTTOM";
		
		
		
		
		
		public function Container(_stage:Stage, force_size:Boolean=false, _force_width:Number=0, _force_height:Number=0, _handle_resize:Boolean=true)
		{
			
			st = _stage;
			setHorizontalPosition(TYPE_PIXEL, SIDE_LEFT, 0);
			setVerticalPosition(TYPE_PIXEL, SIDE_TOP, 0);
			
			forcesize = force_size;
			force_width = _force_width;
			force_height = _force_height;
			forcestagesize = false;
			handle_resize = _handle_resize;
		}
		
		public function setSize(_width:Number, _height:Number)
		{
			forcesize = true;
			force_width = _width;
			force_height = _height;
			onResize(new Event(""));
		}
		
		public function setStageSize(_width:Number, _height:Number)
		{
			forcestagesize = true;
			force_stagewidth = _width;
			force_stageheight = _height;
		}
		
		public function init():void
		{
			st.addEventListener(Event.RESIZE, onResize);
			if(handle_resize) this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			else onResize(new Event(""));
		}
		
		public function setHorizontalPosition(type:String, side:String, value:Number):void
		{
			if(type!=TYPE_PIXEL && type!=TYPE_PERCENT) 
				trace("ERROR : possible values are "+TYPE_PIXEL+" and "+TYPE_PERCENT+" for arg1 in Container::setHorizontalPosition()");
			if(side!=SIDE_LEFT && side!=SIDE_RIGHT) 
				trace("ERROR : possible values are "+SIDE_LEFT+" and "+SIDE_RIGHT+" for arg2 in Container::setHorizontalPosition()");
			
			h_type = type;
			h_side = side;
			h_value = value;
			b_horizontal = true;
			init();
		}
		
		public function setVerticalPosition(type:String, side:String, value:Number):void
		{
			if(type!=TYPE_PIXEL && type!=TYPE_PERCENT) 
				trace("ERROR : possible values are "+TYPE_PIXEL+" and "+TYPE_PERCENT+" for arg1 in Container::setVerticalPosition()");
			if(side!=SIDE_TOP && side!=SIDE_BOTTOM) 
				trace("ERROR : possible values are "+SIDE_TOP+" and "+SIDE_BOTTOM+" for arg2 in Container::setVerticalPosition()");
			
			v_type = type;
			v_side = side;
			v_value = value;
			b_vertical = true;
			init();
		}
		
		
		public function setX(value:String, side:String="LEFT"):void
		{
			setPositionByString(value, side);
		}
		public function setY(value:String, side:String="TOP"):void
		{
			setPositionByString(value, side);
		}
		
		public function setPosition(_x:String, _xside:String, _y:String, _yside:String):void
		{
			this.setX(_x, _xside);
			this.setY(_y, _yside);
		}
		
		
		public function set useVisibleDimensions(v:Boolean):void
		{
			_useVisibleDimensions = v;
		}
		
		
		public function set shiftX(v:Number):void
		{
			_shiftx= v;
			onResize(new Event(""));
		}
		
		public function set shiftY(v:Number):void
		{
			_shifty= v;
			onResize(new Event(""));
		}
		public function get shiftX():Number
		{
			return _shiftx;
		}
		public function get shiftY():Number
		{
			return _shifty;
		}
		
		public function enable()
		{
			_enabled = true;
		}
		public function disable()
		{
			_enabled = false;
		}
		public function update()
		{
			onResize(new Event(""));
		}
		
		
		
		public function getVisibleDimensions():Point
		{			
			var bitmapDataSize:int = 2000;
		  	var bounds:Rectangle;
			if(this.width==0 || this.height==0) return new Point(0, 0);
			
		  	var bitmapData:BitmapData = new BitmapData(this.width, this.height, true, 0);
		  	bitmapData.draw(this);
		  	bounds = bitmapData.getColorBoundsRect( 0xFF000000, 0x00000000, false );
		  	bitmapData.dispose(); 
			
			var w:Number = bounds.x + bounds.width;
		  	var h:Number = bounds.y + bounds.height;
			return new Point(w, h);
		}
		
		
		
		
		
		
		//_____________________________________________________
		//private functions
		
		
		
		
		private function setPositionByString(value:String, side:String)
		{
			var len:int = value.length;
			var last_char:String = value.substr(len-1, 1);
			var last_char2:String = value.substr(len-2, 2);
			var type:String;
			var unit:String;
			if(last_char=="%"){
				type = TYPE_PERCENT;
				unit = "%";
			}
			else if(last_char2.toLowerCase()=="px"){
				type = TYPE_PIXEL;
				unit = "px";
			}
			else throw new Error("You must set either a value in 'px' or '%' ("+value+")");
			
			var val:Number = parseInt(value.substr(0, len-unit.length));
			if(side==SIDE_LEFT || side==SIDE_RIGHT) setHorizontalPosition(type, side, val);
			else if(side==SIDE_TOP || side==SIDE_BOTTOM) setVerticalPosition(type, side, val);
			else throw new Error("possible values are "+SIDE_TOP+", "+SIDE_BOTTOM+", "+SIDE_LEFT+", "+SIDE_RIGHT+", for arg2 in Container::setX()/setY()");
		}
		
		
		private function onResize(e:Event):void
		{
			var w:Number = (force_width==0) ? this.width : force_width;
			var h:Number = (force_height == 0) ? this.height : force_height;
			
			var visibleDimensions:Point;
			if(_useVisibleDimensions){
				visibleDimensions = getVisibleDimensions();
				if(force_width==0) w = visibleDimensions.x;
				if(force_height==0) h = visibleDimensions.y;
			}
			
			
			var stage_w:Number;
			var stage_h:Number;
			
			if(debugMode){
				trace("...");
			}
			
			if(forcestagesize){
				stage_w = force_stagewidth;
				stage_h = force_stageheight;
			}
			else{
				stage_w = st.stageWidth;
				stage_h  = st.stageHeight;
			}
			
			var _x:Number, _y:Number;
			
			//horizontal
			if(h_type==TYPE_PIXEL){
				if(h_side==SIDE_LEFT) _x = h_value;
				else if(h_side==SIDE_RIGHT) _x = stage_w - w - h_value;
			}
			else if(h_type==TYPE_PERCENT){
				_x = stage_w*h_value/100 - w*h_value/100;
				if(h_side==SIDE_RIGHT) _x = stage_w - w - _x;
			}
			
			//vertical
			if(v_type==TYPE_PIXEL){
				if(v_side==SIDE_TOP) _y = v_value;
				else if(v_side==SIDE_BOTTOM) _y = stage_h - h - v_value;
			}
			else if(v_type==TYPE_PERCENT){
				_y = stage_h*v_value/100 - h*v_value/100;
				if(v_side==SIDE_BOTTOM) _y = stage_h - h - _y;
			}
			
			
			if (_enabled) {
				if(b_horizontal) this.x = _x + _shiftx;
				if(b_vertical) this.y = _y + _shifty;
			}
		}
		
		
		
		
		private function onEnterFrame(e:Event)
		{
			//trace("onEnterFrame");
			if(forcesize || _useVisibleDimensions) return;
			if(width!=save_width || height!=save_height){
				onResize(new Event(""));
			}
			save_width = width;
			save_height = height;
		}
	}
	
}