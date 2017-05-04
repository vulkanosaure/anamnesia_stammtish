package data2.behaviours 
{
	import data2.InterfaceSprite;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class Behaviour extends EventDispatcher
	{
		protected var childrens:Array;
		protected var _interfaceSprite:InterfaceSprite;
		
		public function Behaviour() 
		{
			
		}
		
		public function add(_child:DisplayObject):void
		{
			if (childrens == null) childrens = new Array();
			childrens.push(_child);
		}
		
		public function resetBehaviour():void
		{
			childrens = new Array();
		}
		
		
		public function update():void
		{
			
		}
		
		public function init():void
		{
			
		}
		
		public function addItem(_item:*):void
		{
			
		}
		
		public function set interfaceSprite(value:InterfaceSprite):void 
		{
			_interfaceSprite = value;
		}
		
		
		
		
		
	}

}