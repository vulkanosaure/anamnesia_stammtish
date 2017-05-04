/*
ajoute un background sur un élement qui doit etre clickable (texte le + souvent)

import data.fx.BGItem;
var bgitem:BGItem = new BGItem(_dobj);
addChild(bgitem);

contraintes :
	update() doit etre appelé après addChild(bgitem)
*/


package data.fx {
	
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	public class BGItem extends Sprite {
		
		//params
		
		
		//private vars
		
		var dobj:DisplayObject;
		var margins:Object;
		
		//_______________________________________________________________
		//public functions
		
		public function BGItem(_dobj:DisplayObject, _marginleft:Number=0, _margintop:Number=0, _marginright:Number=0, _marginbottom:Number=0) 
		{ 
			dobj = _dobj;
			var io:InteractiveObject = _dobj as InteractiveObject;
			if(io!=null) io.mouseEnabled = false;
			this.buttonMode = true;
			this.alpha = 0;
			margins = {"left":_marginleft, "top":_margintop, "right":_marginright, "bottom":_marginbottom};
		}
		
		public function setMargin(_left:Number, _top:Number, _right:Number, _bottom:Number)
		{
			margins.left = _left;
			margins.top = _top;
			margins.right = _right;
			margins.bottom = _bottom;
		}
		
		
		public function update():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0xff0000, 1);
			var _x:Number = -margins.left;
			var _y:Number = -margins.top;
			var _width:Number = dobj.width+margins.left+margins.right;
			var _height:Number =  dobj.height+margins.top+margins.bottom;
			g.drawRect(_x, _y, _width, _height);
			
			
			var _dobjcontainer:DisplayObjectContainer = this;
			var secu:int = 0;
			while (true) {
				if (_dobjcontainer == null) {
					return;
				}
				if(_dobjcontainer.contains(dobj)){
					break;
				}
				_dobjcontainer = _dobjcontainer.parent;
			}
			
			var position:Point = getCoordsFromContainer(dobj, _dobjcontainer);
			
			this.x = position.x;
			this.y = position.y;
		}
		
		public function get displayObject():DisplayObject
		{
			return dobj;
		}
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function getCoordsFromContainer(_dobj:DisplayObject, _container:DisplayObjectContainer):Point
		{
			var p:Point = new Point(0, 0);
			var _cont:DisplayObject = _dobj;
			var count_secu:int = 0;
			var nb_loop_max:int = 20;
			while(true){
				p.x += _cont.x;
				p.y += _cont.y;
				_cont = _cont.parent;
				if(_cont==_container) break;
				count_secu++;
				if(_cont==null) throw new Error("no container was found");
				if(count_secu==nb_loop_max) throw new Error(nb_loop_max+" loops have been processed but no container was found");
			}
			return p;
		}
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}