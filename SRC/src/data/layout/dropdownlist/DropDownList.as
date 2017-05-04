/*
import data.layout.dropdownlist.DropDownList;
import fl.controls.dataGridClasses.HeaderRenderer;


var ddl = new DropDownList();
addChild(ddl);

ddl.addItem(obj_header, obj_body);
//...

//paramétrage
ddl.interlineGlobal = 20;
ddl.interlineNode = 10;
ddl.autoClose = true;
ddl.speedMove = 0.5;
ddl.speedShow = 0.3;
ddl.speedHide = 0.15;
ddl.delaiShow = 0.25;
ddl.delaiHide = 0;

ddl.update();
ddl.open(2);

*/

package data.layout.dropdownlist {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import data.fx.transitions.TweenManager;
	import flash.events.MouseEvent;
	
	import data.layout.dropdownlist.DropDownListNode;
	import data.layout.dropdownlist.DropDownListEvent;
	
	
	
	public class DropDownList extends Sprite{
		
		//params
		
		
		//private vars
		private var nodes:Array;
		private var posY:Array;
		private var list_active:Array;
		private var list_dobj_visible:Array;
		private var tweens_y:Array;
		private var first_update:Boolean;
		
		private var _interlineGlobal:Number;
		private var _interlineNode:Number;
		private var _speedY:Number;
		private var _speedAlphaShow:Number;
		private var _speedAlphaHide:Number;
		private var _effect:Function;
		private var _autoClose:Boolean;
		private var _delaiShow:Number;
		private var _delaiHide:Number;
		private var twm:TweenManager;
		
		private const speed_min:Number = 0.01;
		
		
		//_______________________________________________________________
		//public functions
		
		public function DropDownList() 
		{ 
			//propriétés par défaut
			_interlineGlobal = 10;
			_interlineNode = 5;
			_speedY = 0.5;
			_speedAlphaShow = 0.3;
			_speedAlphaHide = 0.15;
			_delaiShow = 0.25;
			_delaiHide = 0;
			_autoClose = true;
			_effect = Regular.easeOut;
			twm = new TweenManager();
			reset();
		}
		
		public function addItem(_header:DropDownListHeader, _body:DisplayObject):void
		{
			var d:DropDownListNode = new DropDownListNode(_header, _body);
			var ind:int = nodes.length;
			d.ID = ind;
			d.speedAlphaShow = _speedAlphaShow;
			d.speedAlphaHide = _speedAlphaHide;
			d.interlineNode = _interlineNode;
			d.effect = _effect;
			d.delaiShow = _delaiShow;
			d.delaiHide = _delaiHide;
			
			d.close(false);
			
			
			d.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			d.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			d.addEventListener(DropDownListEvent.CLICK_HEADER, onClick);
			d.addEventListener(DropDownListEvent.OPEN_ITEM, onOpenItem);
			d.addEventListener(DropDownListEvent.CLOSE_ITEM, onCloseItem);
			this.addChild(d);
			nodes.push(d);
			posY.push(0);
		}
		
		
		public function reset():void
		{
			while(this.numChildren) this.removeChildAt(0);
			nodes = new Array();
			posY = new Array();
			tweens_y = new Array();
			first_update = true;
		}
		
		public function open(ind:int):void
		{
			if (nodes[ind].state) return;
			if(_autoClose) closeAll();
			nodes[ind].open();
			update();
		}
		
		public function close(ind:int):void
		{
			if(!nodes[ind].state) return;
			nodes[ind].close();
			update();
		}
		
		public function update()
		{
			var len:int = nodes.length;
			var _y:Number;
			for(var i:int=0;i<len;i++) nodes[i].update();
			
			for(i=0;i<len;i++){
				_y = getY(i);
				posY[i] = _y;
			}
			animate(!first_update);
			first_update = false;
		}
		
		
		
		
		
		public override function get height():Number
		{
			var h:Number = 0;
			var len:int = nodes.length;
			for (var i:int = 0; i < len; i++) {
				if (i > 0) h += _interlineGlobal;
				h += nodes[i].height;
			}
			return h;
		}
		
		
		
		
		
		public function set interlineGlobal(v:Number):void
		{
			_interlineGlobal = v;
		}
		public function set speedMove(v:Number):void
		{
			if(v==0) v = speed_min;
			_speedY = v;
		}
		public function set autoClose(v:Boolean):void
		{
			_autoClose = v;
		}
		
		//nodes property
		public function set interlineNode(v:Number):void
		{
			_interlineNode = v;
			updateNodesProperty();
		}
		public function set speedShow(v:Number):void
		{
			if(v==0) v = speed_min;
			_speedAlphaShow = v;
			updateNodesProperty();
		}
		public function set speedHide(v:Number):void
		{
			if(v==0) v = speed_min;
			_speedAlphaHide = v;
			updateNodesProperty();
		}
		public function set effect(v:Function):void
		{
			_effect = v;
			updateNodesProperty();
		}
		public function set delaiShow(v:Number):void
		{
			_delaiShow = v;
			updateNodesProperty();
		}
		public function set delaiHide(v:Number):void
		{
			_delaiHide = v;
			updateNodesProperty();
		}
		
		public function getHeaderAt(v:uint):DropDownListHeader
		{
			return DropDownListNode(nodes[v]).getHeader();
		}
		
		public function getBodyAt(v:uint):DisplayObject
		{
			return DropDownListNode(nodes[v]).getBody();
		}
		
		public function get length():uint
		{
			return nodes.length;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		//avant : public, voir si pas utilisé hors de la classe
		private function animate(_tween:Boolean=true):void
		{
			var len:int = nodes.length;
			for(var i:int=0;i<len;i++){
				if(_tween) tweenY(i, posY[i]);
				else nodes[i].y = posY[i];
			}
		}
		
		private function getY(indice:int):Number
		{
			var pos:Number;
			if(indice==0) pos = 0;
			else pos = posY[indice-1] + nodes[indice-1].height + _interlineGlobal;
			return pos;
		}
		
		
		private function tweenY(ind:int, _dest:Number):void
		{
			//tweens_y[ind] = new Tween(nodes[ind], "y", _effect, nodes[ind].y, _dest, _speedY, true);
			//tweens_y[ind].addEventListener(TweenEvent.MOTION_FINISH, onTweenFinished);
			//tweens_y[ind].addEventListener(TweenEvent.MOTION_CHANGE, onTweenDuring);
			
			twm.tween(nodes[ind], "y", NaN, _dest, _speedY, 0.0, _effect);
			twm.addTweenListener(onTweenFinished, TweenEvent.MOTION_FINISH);
			twm.addTweenListener(onTweenDuring, TweenEvent.MOTION_CHANGE);
			
		}
		
		private function updateNodesProperty():void
		{
			var len:int = nodes.length;
			for(var i:int=0;i<len;i++){
				nodes[i].interlineNode = _interlineNode;
				nodes[i].speedAlphaShow = _speedAlphaShow;
				nodes[i].speedAlphaHide = _speedAlphaHide;
				nodes[i].effect = _effect;
				nodes[i].delaiShow = _delaiShow;
				nodes[i].delaiHide = _delaiHide;
			}
		}
		
		private function closeAll():void
		{
			var len:int = nodes.length;
			for(var i:int=0;i<len;i++){
				nodes[i].close();
			}
		}
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onClick(e:DropDownListEvent):void
		{
			var evt:DropDownListEvent = new DropDownListEvent(DropDownListEvent.CLICK_HEADER);
			evt.idNode = e.idNode;
			this.dispatchEvent(evt);
			
			var id:int = e.idNode;
			if (DropDownListNode(nodes[id]).body == null) return;
			if(nodes[id].state) close(id);
			else open(id);
			update();
		}
		private function onOpenItem(e:DropDownListEvent):void
		{
			var de:DropDownListEvent = new DropDownListEvent(DropDownListEvent.OPEN_ITEM);
			de.idNode = e.idNode;
			de.header = getHeaderAt(e.idNode) as DropDownListHeader;
			dispatchEvent(de);
			DropDownListNode(nodes[e.idNode]).select();
		}
		private function onCloseItem(e:DropDownListEvent):void
		{
			var de:DropDownListEvent = new DropDownListEvent(DropDownListEvent.CLOSE_ITEM);
			de.idNode = e.idNode;
			de.header = getHeaderAt(e.idNode) as DropDownListHeader;
			dispatchEvent(de);
			DropDownListNode(nodes[e.idNode]).unselect();
		}
		
		private function onTweenDuring(e:TweenEvent):void
		{
			dispatchEvent(new DropDownListEvent(DropDownListEvent.TWEEN));
		}
		
		private function onTweenFinished(e:TweenEvent):void
		{
			dispatchEvent(new DropDownListEvent(DropDownListEvent.UPDATE));
		}
		
		
		private function onMouseOver(e:MouseEvent):void 
		{
			var evt:DropDownListEvent = new DropDownListEvent(DropDownListEvent.OVER_HEADER);
			evt.idNode = DropDownListNode(e.currentTarget).ID;
			dispatchEvent(evt);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			var evt:DropDownListEvent = new DropDownListEvent(DropDownListEvent.OUT_HEADER);
			evt.idNode = DropDownListNode(e.currentTarget).ID;
			dispatchEvent(evt);
		}
	}
	
}