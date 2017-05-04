/*
créer un movieclip qui contient 3 movieclip : "top", "center", "bottom"
exporter pour l'actionscript et lui assigner "data.fx.resizeableShape.VerticalResizeableShape" comme classe de base
on peut ensuite changer sa propriété height, les bords ne seront pas étirés
*/

package data.display.resizeableShape{
	
	import flash.display.MovieClip;
	
	public dynamic class VerticalResizeableShape extends MovieClip {
		
		//params
		
		
		//private vars
		var list_mc:Array;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function VerticalResizeableShape() 
		{ 
			list_mc = ["top", "center", "bottom"];
			
			//error handler
			for(var i in list_mc){
				var _name:String = list_mc[i];
				if(this[_name]==undefined) throw new Error("VerticalResizeableShape must contain MovieClip named '"+_name+"'");
			}
			
			//positionning
			for(i in list_mc){
				this[list_mc[i]].x = 0;
			}
			
			
		}
		
		
		
		
		public override function set height(v:Number):void
		{
			v = Math.round(v);
			var _prop:String = "height";
			var _prop2:String = "y";
			var mc1:MovieClip = this[list_mc[0]];
			var mc2:MovieClip = this[list_mc[1]];
			var mc3:MovieClip = this[list_mc[2]];
			
			var _dim1:Number = mc1[_prop];
			var _dim2:Number = mc3[_prop];
			var v2:Number = v - _dim1 - _dim2;
			if(v2<0) v2=0;
			mc1[_prop2] = 0;
			mc2[_prop2] = _dim1;
			mc2[_prop] = v2;
			mc3[_prop2] = _dim1 + mc2[_prop];
		}
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}