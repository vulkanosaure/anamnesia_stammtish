package data.display.containers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DisplayObjectContainerVisibility extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		var _items:Array;
		
		public function DisplayObjectContainerVisibility() 
		{
			_items = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		override public function addChild(_displayObject:DisplayObject):DisplayObject
		{
			_items.push(_displayObject);
			return _displayObject;
		}
		
		
		override public function set visible(value:Boolean):void 
		{
			trace("SET visible (" + value + ")");
			for (var i:int = 0; i < _items.length; i++) 
			{
				trace("loop visible(" + value + ")");
				DisplayObject(_items[i]).visible = value;
			}
			super.visible = value;
		}
		
		
		override public function set alpha(value:Number):void 
		{
			trace("set alpha (" + value + ")");
			for (var i:int = 0; i < _items.length; i++) 
			{
				DisplayObject(_items[i]).alpha = value;
				trace("items[i] : " + _items[i] + ", DisplayObject(_items[i]).alpha : " + DisplayObject(_items[i]).alpha);
			}
			super.alpha = value;
		}
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}