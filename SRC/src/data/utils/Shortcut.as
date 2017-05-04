package data.utils {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	
	public class Shortcut {
		
		//params
		
		
		//private vars
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Shortcut() 
		{ 
			throw new Error("Shortcut is static, you can't instanciate it");
		}
		
		
		public static function placeOnStage(_node:DisplayObjectContainer, _dobj:DisplayObject, _x:Number, _y:Number):void
		{
			_node.addChild(_dobj);
			_dobj.x = _x;
			_dobj.y = _y;
		}
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}