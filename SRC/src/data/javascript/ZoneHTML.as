package data.javascript{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class ZoneHTML extends Sprite{
		
		//params
		
		
		//private vars
		var _divid:String;
		
		var __visible:Boolean;
		var __alpha:Number;
		var __x, __y:Number;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function ZoneHTML() 
		{ 
			
		}
		
		
		
		
		
		
		//
		public function getGlobalPosition():Point
		{
			return this.localToGlobal(new Point(0, 0));
		}
		
		
		
		public function getGlobalVisible():Boolean
		{
			var secu:int = 0;
			var _dobj:DisplayObject = this;
			
			while(true){
				if(!_dobj.visible) return false;
				if(_dobj==stage) break;
				_dobj = _dobj.parent;
				secu++;
				//if(secu==10) break;
			}
			return true;
		}
		
		
		
		
		public function getGlobalAlpha():Number
		{
			var secu:int = 0;
			var _dobj:DisplayObject = this;
			var _result:Number = 1;
			while(true){
				_result *= _dobj.alpha;
				if(_dobj==stage) break;
				_dobj = _dobj.parent;
				secu++;
				//if(secu==10) break;
			}
			return _result;
		}
		
		
		
		public function set divid(value:String):void 
		{
			_divid = value;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		private function onEnterFrame(e:Event):void
		{
			if (stage == null) return;
			
			var _visible:Boolean = this.getGlobalVisible();
			if(!_visible){
				ExternalInterface.call("ZoneHTML.setVisible", _divid, false);
				return;
			}
			
			var _alpha:Number = this.getGlobalAlpha();
			if(_alpha==0){
				ExternalInterface.call("ZoneHTML.setVisible", _divid, false);
				return;
			}
			
			var _position:Point = this.getGlobalPosition();
			
			if(_visible!=__visible || _alpha!=__alpha || __x!=_position.x || __y!=_position.y){
				ExternalInterface.call("ZoneHTML.setProperties", _divid, _visible, _alpha, _position.x, _position.y);
			}
			
		}
		
	}
	
}