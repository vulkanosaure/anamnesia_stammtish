/*
créer un movieclip qui contient 3 movieclip : "left", "center", "right"
exporter pour l'actionscript et lui assigner "data.fx.resizeableShape.HorizontalResizeableShape" comme classe de base
on peut ensuite changer sa propriété width, les bords ne seront pas étirés
*/

package data.display.resizeableShape{
	
	import flash.display.MovieClip;
	
	public dynamic class HorizontalResizeableShape extends MovieClip {
		
		//params
		
		
		//private vars
		var list_name_mc:Array;
		var list_mc:Array;
		var _width:Number;
		var _align:String;
		
		//_______________________________________________________________
		//public functions
		
		public function HorizontalResizeableShape() 
		{ 
			list_name_mc = ["left", "center", "right"];
			list_mc = [null, null, null];
			_align = "left";
			
			
			//error handler
			var _count:int = 0;
			for(var i in list_mc){
				var _name:String = list_name_mc[i];
				if (this.getChildByName(_name) == null) throw new Error("HorizontalResizeableShape must contain MovieClip named '" + _name + "'");
				list_mc[_count] = this.getChildByName(_name);
				_count++;
			}
			
			//positionning
			for(i in list_mc){
				list_mc[i].y = 0;
			}
			
			
		}
		
		public function set align(_str:String):void
		{
			if(_str!="right" && _str!="left") throw new Error("value must be left or right for param align");
			_align = _str;
		}
		
		public override function set width(v:Number):void
		{
			trace("Horizontal Machin.set width(" + v + ")");
			v = Math.round(v);
			var _prop:String = "width";
			var _prop2:String = "x";
			var mc1:MovieClip = list_mc[0];
			var mc2:MovieClip = list_mc[1];
			var mc3:MovieClip = list_mc[2];
			
			var _dim1:Number = mc1[_prop];
			var _dim2:Number = mc3[_prop];
			var v2:Number = v - _dim1 - _dim2;
			if(v2<0) v2=0;
			mc2[_prop] = v2;
			
			mc1[_prop2] = 0;
			mc2[_prop2] = _dim1;
			mc3[_prop2] = _dim1 + mc2[_prop];
		
			if(_align=="right"){
				for(var i in list_mc) list_mc[i][_prop2] -= v;
			}
			
			_width = v;
		}
		
		public override function get width():Number
		{
			return _width;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}