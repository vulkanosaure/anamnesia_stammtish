/*
UTILISATION :

import data.display.OutlineRectangle;
var frame = new OutlineRectangle();
addChild(frame);
frame.type = "external";
frame.lineStyle(5, 0xff0000, 0.5);
frame.width = 100;
frame.height = 50;


*/



package data.display {
	
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	
	public class OutlineRectangle extends Sprite{
		
		//params
		
		
		//private vars
		private var _width, _height:Number;
		private var _thickness:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var _type:String;
		
		
		//_______________________________________________________________
		//public functions
		
		public function OutlineRectangle() 
		{ 
			_width = 100;
			_height = 100;
			_thickness = 1;
			_color = 0x000000;
			_alpha = 1;			
			_type = "internal";
			//drawRect();
		}
		
		public override function set width(v:Number):void
		{
			_width = v;
			//drawRect();
		}
		
		public override function set height(v:Number):void
		{
			_height = v;
			//drawRect();
		}
		
		public function lineStyle(__thickness:Number=1, __color:uint=0, __alpha:Number=1.0):void
		{
			_thickness = __thickness;
			_color = __color;
			_alpha = __alpha;
			//drawRect();
		}
		
		public function set type(_str:String):void
		{
			if(_str!="internal" && _str!="external") throw new Error("OutlineRectangle.type : possible values are [\"internal\" / \"external\"]");
			_type = _str;
			//drawRect();
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			//drawRect();
		}
		
		public function update():void
		{
			drawRect();
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function drawRect():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle(_thickness, _color, _alpha, false, "normal", CapsStyle.NONE, JointStyle.MITER);
			
			var _left:Number, _top:Number, _w:Number, _h:Number;
			_left = (_type=="internal") ? _thickness/2 : -_thickness/2;
			_top = (_type=="internal") ? _thickness/2 : -_thickness/2;
			_w = (_type=="internal") ? _width-_thickness : _width+_thickness;
			_h = (_type=="internal") ? _height-_thickness : _height+_thickness;
			g.drawRect(_left, _top, _w, _h);
		}
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}