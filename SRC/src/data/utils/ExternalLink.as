package data.utils 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ExternalLink
	{
		//_______________________________________________________________________________
		// properties
		
		private var _link:*;
		private var _target:String;
		
		public function ExternalLink(_btn:InteractiveObject, __link:*, __target="_blank") 
		{
			if (!_link is String && !_link is Function) throw new Error("link must be of type String or Function");
			if (__target != "_blank" && __target != "_self") throw new Error("target must be _blank or _self");
			_btn.addEventListener(MouseEvent.CLICK, onClick);
			_link = __link;
			_target = __target;
			if(_btn is Sprite) Sprite(_btn).buttonMode = true;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_link is String) navigateToURL(new URLRequest(_link), _target);
			else if (_link is Function) _link();
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}