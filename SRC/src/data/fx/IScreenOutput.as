package data.fx {
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	public interface IScreenOutput extends IEventDispatcher {
		
		function get sprite(): Sprite;	
		
	}
	
}