/*
contient des DisplayObject classés ds un ordre
et les dispose dans un flux vertical a la manière d'une page html
x se manipule directement (obj.x)
y se manipule en relatif via la fonction changeY(indice, increment)

var l:InlineLayout = new InlineLayout();
l.addChild(x);
l.addChild(y);
l.space = 20;
l.interline = 10;
l.width = 200;
l.move(0, 5);
l.move2(x, 10);
l.update();	//update doit tjs etre appelé apres des modifs

TODO :
align : CENTER 

*/


package data.layout {
	
	
	import flash.display.*;
	
	public class InlineLayout extends Sprite{
		
		var list_dobj:Array;
		var list_space:Array;
		var num_dobj:int;
		
		var _interline:Number;
		var _dx:Number;
		var _width:Number;
		var _align:String;
		
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";		//todo
		public static const JUSTIFY:String = "justify";		//todo
		
		
		public function InlineLayout() 
		{ 
			reset();
			_interline = 0;
			width = 9999;
			align = LEFT;
		}
		
		public function reset()
		{
			while(numChildren) removeChildAt(0);
			list_dobj = new Array();
			list_space = new Array();
			num_dobj = 0;
			_dx = 0;
			
		}
		
		
		public function register(dobj:DisplayObject):void
		{
			list_dobj.push(dobj);
			list_space.push(undefined);
			num_dobj++;
		}
		
		
		public override function addChild(dobj:DisplayObject):DisplayObject
		{
			register(dobj);
			return super.addChild(dobj);
		}
		public override function removeChild(dobj:DisplayObject):DisplayObject
		{
			var ind:int;
			for(var i:int=0;i<list_dobj.length;i++){
				if(list_dobj[i]==dobj){
					ind = i;
					break;
				}
			}
			list_dobj.splice(ind, 1);
			list_space.splice(ind, 1);
			num_dobj--;
			return super.removeChild(dobj);
		}
		
		
		public override function set width(v:Number):void
		{
			_width = v;
		}
		public function get realWidth():Number
		{
			return super.width;
		}
		
		
		public function update()
		{
			var _cumulX:int = 0;
			var _cumulY:int = 0;
			var _space:int;
			var cur_width:int;
			var prev_width:int;
			var total_width:Number;
			var delta:Number;
			var space:Number;
			var cumul:Number;
			
			
			
			
			//justify
			
			if(_align==JUSTIFY){
				total_width = 0;
				for(var i:int=0;i<num_dobj;i++){
					total_width += list_dobj[i].width;
				}
				delta = _width - total_width;
				space = delta / (num_dobj-1);
				cumul = 0;
				for(i=0;i<num_dobj;i++){
					list_dobj[i].x = cumul;
					cumul += list_dobj[i].width + space;
				}
			}
			
			//left/right
			else if(_align==RIGHT || _align==LEFT){
				for(i=0;i<num_dobj;i++){
					
					if(i==0 && list_space[i]==undefined) _space = 0;
					else if(list_space[i]==undefined) _space = _dx;
					else _space = list_space[i];
					
					cur_width = list_dobj[i].width;
					prev_width = (i>0) ? list_dobj[i-1].width : 0;
					
					_cumulX += _space;
					if(i>0) _cumulX += prev_width;
					
					//new line
					if(_cumulX + cur_width > _width){
						_space = 0;
						_cumulX = _space;
						_cumulY = getLowestItem(i) + _interline;
					}
					
					if(_align==LEFT){
						list_dobj[i].x = _cumulX;
						list_dobj[i].y = _cumulY;
					}
					else if(_align==RIGHT){
						list_dobj[i].x = -_cumulX + _width - list_dobj[i].width;
						list_dobj[i].y = _cumulY;
					}
				}
			}
			
			//center
			else if (_align == CENTER) {
				
				//trace("dev align = center");
				total_width = 0;
				for(i=0;i<num_dobj;i++){
					total_width += list_dobj[i].width;
				}
				delta = _width - total_width;
				space = delta / (num_dobj + 1);
				cumul = space;
				for(i=0;i<num_dobj;i++){
					list_dobj[i].x = cumul;
					cumul += list_dobj[i].width + space;
				}
			}
			
		}
		
		public function move(indice:int, inc:int):void
		{
			list_space[indice] = inc;
		}
		
		public function move2(obj:DisplayObject, inc:int):void
		{
			for(var i:int=0;i<list_dobj.length;i++){
				if(list_dobj[i]==obj) break;
			}
			move(i, inc);
		}
		public function set interline(i:Number)
		{
			_interline = i;
		}
		public function set space(v:Number)
		{
			_dx = v;
		}
		public function set align(_str:String):void
		{
			if(_str!=LEFT && _str!=RIGHT && _str!=CENTER && _str!=JUSTIFY)
				throw new Error("Wrong value for property align");
			_align = _str;
		}
		
		//______________________________________________________________________
		//private
		
		private function getLowestItem(_ind:int):int
		{
			var _max = 0;
			var _mesure;
			var ind_lowest;
			for(var i:int=0;i<_ind;i++){
				_mesure = list_dobj[i].y + list_dobj[i].height;
				if(_mesure > _max){
					ind_lowest = i;
					_max = _mesure;
				}
			}
			return _max;
		}
	
	}
	
}