package data.layout.menu{
	
  public interface IMenuItem {
	  
	  function select(_type:String):void;
	  function unselect():void;
	  function isSelected():Boolean;
	  
  }
}