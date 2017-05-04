package utils.virtualkeyboard {

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * IDisposable interface defines a minimalistic contract to help garbage collection process.
	 *
	 * @author antoine fricker <info@taisen.fr>
	 */
	public interface IDisposable {
		
		/**
		 * Dispatched when an error has been destroyed and is ready for garbage collection.
		 * @eventType flash.events.Event
		 */
		[Event(name="dispose",type="virgile.events.VgEvent")]

		/**
		 * Prepares instance for garbage collection
		 * @usage	should dispatch a Event.EXITING event
		 */
		function dispose(e:Event = null):void;
	}

}
