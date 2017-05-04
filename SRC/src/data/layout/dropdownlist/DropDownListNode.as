package data.layout.dropdownlist {
	
	import data.fx.transitions.TweenManager;
	import data.layout.dropdownlist.DropDownListEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import fl.transitions.easing.*;
	
	
	public class DropDownListNode extends Sprite{
		
		//params
		public var ID:int;
		
		//private vars
		var header:DropDownListHeader;
		var body:DisplayObject;
		var _state:Boolean;
		var timer:Timer;
		
		public var interlineNode:Number;
		public var speedAlphaShow:Number;
		public var speedAlphaHide:Number;
		public var effect:Function;
		public var delaiShow:Number;
		public var delaiHide:Number;
		private var twm:TweenManager;
		
		
		//_______________________________________________________________
		//public functions
		
		public function DropDownListNode(_header:DropDownListHeader, _body:DisplayObject) 
		{ 
			reset();
			setHeader(_header);
			setBody(_body);
			_state = true;
			_header.addEventListener(MouseEvent.CLICK, onClickHeader);
			twm = new TweenManager();
		}
		
		public function setHeader(_dobj:DropDownListHeader):void
		{
			header = _dobj;
			addChild(header);
			header.mouseChildren = false;
			header.buttonMode = true;
		}
		public function setBody(_dobj:DisplayObject):void
		{
			body = _dobj;
			if(body!=null) addChild(body);
		}
		
		public function getHeader():DropDownListHeader
		{
			return header;
		}
		
		public function getBody():DisplayObject
		{
			return body;
		}
		
		public function reset():void
		{
			while(this.numChildren) this.removeChildAt(0);
			header = null;
			body = null;
		}
		
		public function update():void
		{
			header.y = 0;
			if (body != null) body.y = header.y + header.height + interlineNode;
		}
		
		public function close(_tween:Boolean=true):void
		{
			if(!_state) return;
			var de = new DropDownListEvent(DropDownListEvent.CLOSE_ITEM);
			de.idNode = this.ID;
			dispatchEvent(de);
			hide(_tween);
			_state = false;
		}
		
		public function open(_tween:Boolean=true):void
		{
			if (_state) return;
			var de = new DropDownListEvent(DropDownListEvent.OPEN_ITEM);
			de.idNode = this.ID;
			dispatchEvent(de);
			show(_tween);
			_state = true;
		}
		
		public function get state():Boolean
		{
			return _state;
		}
		
		public override function get height():Number
		{
			if(_state) return super.height;
			else return header.height;
		}
		
		public function select():void
		{
			header.select();
		}
		public function unselect():void
		{
			header.unselect();
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function show(_tween:Boolean=true):void
		{
			trace("body : " + body+", "+this.contains(body)+", "+body.visible);
			if(timer!=null) timer.stop();
			if(_tween) delai(delaiShow, tween_show);
			else {
				if (body != null) body.alpha = 1;
			}
		}
		
		private function hide(_tween:Boolean=true):void
		{
			if(timer!=null) timer.stop();
			if(_tween) delai(delaiHide, tween_hide);
			else {
				if(body!=null){
					body.visible = false;
					body.alpha = 0;
				}
			}
		}
		
		private function tween_show(e:TimerEvent):void
		{
			if (body == null) return;
			twm.tween(body, "alpha", NaN, 1.0, speedAlphaShow);
		}
		private function tween_hide(e:TimerEvent):void
		{
			if (body == null) return;
			twm.tween(body, "alpha", NaN, 0.0, speedAlphaHide);
		}
		
		private function delai(t:Number, f:Function):void
		{
			timer = new Timer(t*1000, 1);
			timer.addEventListener(TimerEvent.TIMER, f);
			timer.start();
		}
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onClickHeader(e:MouseEvent)
		{
			var de:DropDownListEvent = new DropDownListEvent(DropDownListEvent.CLICK_HEADER);
			de.idNode = this.ID;
			dispatchEvent(de);
			
		}
		
		
	}
	
}