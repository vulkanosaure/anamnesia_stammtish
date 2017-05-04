package data.layout.dropdownlist 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Vincent
	 */
	public class DropDownListHeader extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		protected var _isSelected:Boolean;
		
		public function DropDownListHeader() 
		{
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function select():void
		{
			throw new Error("too be overridden");
		}
		
		public function unselect():void
		{
			throw new Error("too be overridden");
		}
		
		public function isSelected():Boolean
		{
			return _isSelected;
		}
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}