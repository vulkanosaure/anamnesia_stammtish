package data.fx.transitions.transitionbitmap 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Vincent
	 */
	public class TransitionBitmapManager extends Sprite
	{
		//_______________________________________________________________________________
		// properties
		
		private var transitions:Object;
		private var items:Array;
		private var cur_id:int;
		private var old_id:int;
		
		
		public function TransitionBitmapManager() 
		{
			cur_id = -1;
			items = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		public function addTransition(_transition:TransitionBitmap, _key:String=""):void
		{
			if (transitions == null) transitions = new Object();
			if (_key == "") _key = "default";
			
			transitions[_key] = _transition;
			_transition.container = this;
		}
		
		
		
		public function reset():void
		{
			while (this.numChildren) this.removeChildAt(0);
			items = new Array();
			transitions = new Object();
			old_id = -1;
			cur_id = -1;
		}
		
		
		public function goto(_id:uint, _key:String=""):void
		{
			if(_id==cur_id) return;
			if (_id >= items.length) throw new Error("TransitionBitmapManager.goto(), arg 1 must be in interval [0;" + items.length + "[");
			if (_key == "") _key = "default";
			
			old_id = cur_id;
			cur_id = _id;
			
			
			if (transitions == null) throw new Error("no transition was defined");
			if(transitions[_key]==undefined) throw new Error("transition key "+_key+" was not found");
			var transition:TransitionBitmap = TransitionBitmap(transitions[_key]);
			
			var _childOut:DisplayObject = DisplayObject(items[old_id]);
			var _childIn:DisplayObject = DisplayObject(items[cur_id]);
			transition.targetOut = Sprite(_childOut);
			transition.targetIn = Sprite(_childIn);
			transition.start();
		}
		
		public function next(_key:String=""):void
		{
			var _id:int = cur_id + 1;
			if (_id == items.length) _id = 0;
			goto(_id, _key);
		}
		
		public function prev(_key:String=""):void
		{
			var _id:int = cur_id - 1;
			if (_id == -1) _id = items.length - 1;
			goto(_id, _key);
		}
		
		
		
		public function init(_id:int):void
		{
			if (items.length == 0) throw new Error("TransitionBitmapManager.init(), can't use init() : no item was found");
			if(_id>=items.length) throw new Error("TransitionBitmapManager.init(), arg 1 must be in interval [0;"+items.length+"[");
			//todo
			DisplayObject(items[_id]).visible = true;
			cur_id = _id;
		}
		
		
		
		public function register(_d:DisplayObject):void
		{
			items.push(_d);
			_d.visible = false;
			addChild(_d);
		}
		
		public function get selectedIndex():uint
		{
			return cur_id;
		}
		
		public function get length():uint
		{
			return items.length;
		}
		
		public function getItemAt(i:int):DisplayObject
		{
			return DisplayObject(items[i]);
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}