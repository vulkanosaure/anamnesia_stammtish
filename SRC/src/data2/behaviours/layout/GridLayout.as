package data2.behaviours.layout 
{
	/**
	 * ...
	 * @author 
	 */
	
	import data2.behaviours.Behaviour;
	import data2.layoutengine.LayoutEngine;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	public class GridLayout extends Behaviour
	{
		private var _interline:Number = 100;
		private var _space:Number = 100;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _column:int = 3;
		
		
		
		public function GridLayout() 
		{
			
		}
		
		override public function update():void 
		{
			if (childrens == null) return;
			
			var _len:int = childrens.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = DisplayObject(childrens[i]);
				var __x:Number = _x + (i % _column) * _space;
				var __y:Number = _y + Math.floor(i / _column) * _interline;
				_child.x = __x;
				_child.y = __y;
				
			}
		}
		
		
		
		
		
		public function set interline(value:Number):void {_interline = value;}
		
		public function set space(value:Number):void {_space = value;}
		
		public function set x(value:Number):void {_x = value;}
		
		public function set y(value:Number):void {_y = value;}
		
		public function set column(value:int):void {_column = value;}
		
	}

}