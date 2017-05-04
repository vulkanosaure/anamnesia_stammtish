/*
contient des DisplayObject classés ds un ordre
et les dispose dans un flux vertical a la manière d'une page html
x se manipule directement (obj.x)
y se manipule en relatif via la fonction changeY(indice, increment)

var l:BlockLayout = new BlockLayout();
l.addChild(x);
// l.addChild(y);
l.interline = 0;
l.moveYByInd(0, 5);
l.moveYByInd(-1, 10);			//ajoutera un espace a la fin (override get height)
l.moveYByDObject(x, 10);
l.update();						//update doit tjs etre appelé apres des modifs


recent correctif sur le get height : ajoute l'offset du 1er element
*/


package data.layout {
	
	
	import flash.display.*;
	
	public class BlockLayout extends Sprite{
		
		var list_dobj:Array;
		var list_space:Array;
		var space_end:Number = 0;
		var num_dobj:int;
		var _interline:Number;
		
		
		public function BlockLayout() 
		{ 
			reset();
			_interline = 0;
			
		}
		
		
		public function reset()
		{
			while(numChildren) removeChildAt(0);
			list_dobj = new Array();
			list_space = new Array();
			num_dobj = 0;
		}
		
		
		public override function get height():Number
		{
			if (list_dobj[0] == null) return 0;
			return list_dobj[0].y + super.height + space_end;
		}
		
		
		public override function addChild(dobj:DisplayObject):DisplayObject
		{
			list_dobj.push(dobj);
			list_space.push(undefined);
			num_dobj++;
			return super.addChild(dobj);
		}
		public override function addChildAt(dobj:DisplayObject, index:int):DisplayObject
		{
			list_dobj = insertInArray(list_dobj, dobj, index);
			list_space = insertInArray(list_space, undefined, index);
			
			list_space[index] = undefined;
			num_dobj++;
			return super.addChildAt(dobj, index);
		}
		
		
		
		
		
		public override function removeChild(dobj:DisplayObject):DisplayObject
		{
			//array.splice(x, 1);
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
		
		public override function removeChildAt(index:int):DisplayObject
		{
			return this.removeChild(this.getChildAt(index));
		}
		
		
		
		public function update()
		{
			if(list_dobj[0]!=null) list_dobj[0].y = 0;
			for(var i:int=0;i<num_dobj;i++){
			    list_dobj[i].y = getY(i);
			}
		}
		
		public function moveYByInd(indice:int, inc:int):void
		{
			if(indice==-1){
				space_end = inc;
			}
			else list_space[indice] = inc;
		}
		
		public function moveYByDObject(obj:DisplayObject, inc:int):void
		{
			for(var i:int=0;i<list_dobj.length;i++){
				if(list_dobj[i]==obj) break;
			}
			moveYByInd(i, inc);
		}
		public function set interline(i:Number)
		{
			_interline = i;
		}
		
		
		
		
		private function insertInArray(_arr:Array, _value:Object, _index:int):Array
		{
			var _len:int = _arr.length;
			for(var i:int=_len-1; i>=_index; i--) _arr[i+1] = _arr[i];
			_arr[_index] = _value;
			return _arr;
		}
		
		
		
		
		//______________________________________________________________________
		//private
		
		private function getY(indice:int):Number
		{
			var pos:Number;
			if(indice==0 && list_space[indice]==undefined){
				return 0;
			}
			if(indice==0){
				pos = 0;
			}
			else pos = list_dobj[indice-1].y + list_dobj[indice-1].height;
			var space:Number = (list_space[indice]!=undefined) ? _interline+list_space[indice] : _interline;
			return pos + space;
		}
	
	}
	
}