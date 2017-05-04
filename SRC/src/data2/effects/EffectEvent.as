package data2.effects 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class EffectEvent extends Event 
	{
		public static const EFFECT_FINISH:String = "effectFinish";
		public var displayObject:DisplayObject;
		
		
		public function EffectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EffectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EffectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}