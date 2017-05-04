package data.javascript
{
	import flash.system.Capabilities;	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	/**
	 * @author Gabriel Bucknall
	 * 
	 * Class that supports using the mouseWheel on Mac OS, requires javascript class
	 * swfmacmousewheel.js
	 */
	public class MacMouseWheel
	{
		private static var instance:MacMouseWheel;
		
		private var _stage:Stage;
		private var _currItem:InteractiveObject;
		private var _clonedEvent:MouseEvent;
		private var _isMouseOver:Boolean;

		public static function getInstance():MacMouseWheel
		{
			if (instance == null) instance = new MacMouseWheel( new SingletonEnforcer() );
			return instance;
		}
	
		public function MacMouseWheel( enforcer:SingletonEnforcer )
		{
		}
		
		/*
		 * Initialize the MacMouseWheel class
		 * 
		 * @param stage Stage instance e.g DocumentClass.stage
		 * 
		 */
		public static function setup( stage:Stage ):void
		{
			var isMac:Boolean = Capabilities.os.toLowerCase().indexOf( "mac" ) != -1;
			if( true ) getInstance()._setup( stage );
		}
		
		private function _setup( stage:Stage ):void
		{
			_stage = stage;
			_stage.addEventListener( MouseEvent.MOUSE_MOVE, _getItemUnderCursor );
			
			if( ExternalInterface.available )
			{
				ExternalInterface.addCallback( 'externalMouseEvent', _externalMouseEvent );	
				ExternalInterface.addCallback( 'setFocusOut', _setFocusOut );	
			}
		}
		
		private function _getItemUnderCursor( e:MouseEvent ):void
		{
			if (!_isMouseOver && ExternalInterface.available) ExternalInterface.call("SWFMacMouseWheel.setFocusIn");
			_currItem = InteractiveObject( e.target );
			_clonedEvent = MouseEvent( e );
			_isMouseOver = true;
		}
		
		private function _setFocusOut():void
		{
			//trace("MacMouseWheel._setFocusOut");
			_isMouseOver = false;
		}
		
		private function _externalMouseEvent( delta:Number ):void
		{
			//trace("MacMouseWheel._externalMouseEvent(" + delta + "), _currItem : " + _currItem);
			if (!_isMouseOver) return;
			
			var wheelEvent:MouseEvent = new MouseEvent( 
					MouseEvent.MOUSE_WHEEL, 
					true, 
					false, 
					_clonedEvent.localX, 
					_clonedEvent.localY, 
					_clonedEvent.relatedObject, 
					_clonedEvent.ctrlKey, 
					_clonedEvent.altKey, 
					_clonedEvent.shiftKey, 
					_clonedEvent.buttonDown, 
					int( delta )
				);
			_currItem.dispatchEvent( wheelEvent );
		}
		
		public static function get isMouseOver():Boolean { return getInstance()._isMouseOver; }
	}
}

internal class SingletonEnforcer{}
