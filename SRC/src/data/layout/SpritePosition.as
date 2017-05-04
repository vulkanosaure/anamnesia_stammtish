/*
 * 
Nouvelle classe container

se positionne par rapport a un container donnée
ce container peut etre le stage ou n'importe quel DisplayObjectContainer

il faudra une propriété de positionnement x,y en px a partir du coin en bas et droite
question : est ce qu'on continue a l'abonner au modif de dims de container ?
ou alors juste updatePosition ? mieux

actuellement, _container doit etre le parent (displaylist) de SpritePosition
on pourrait ptet envisage _container:DisplayObject qui n'est pas forcément un parent

marchera pas si contenu n'est pas aligné en haut a gauche

drag n drop marche si container != stage (et position !=)
*/



package data.layout {
	
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SpritePosition extends Sprite{
		
		//params
		
		var _px:Number;
		var _py:Number;
		
		//private vars
		
		var _container:DisplayObjectContainer;
		var _parentDims:Point;
		var _boundType:String;
		var _ptDrag:Point;
		
		
		
		
		//constantes
		public static const BOUND_INTERNAL:String = "boundInternal";
		public static const BOUND_EXTERNAL:String = "boundExternal";
		public static const BOUND_NONE:String = "boundNone";
		
		
		//_______________________________________________________________
		//public functions
		
		public function SpritePosition(_container:DisplayObjectContainer) 
		{ 
			this.container = _container;
			_boundType = BOUND_NONE;
		}
		
		
		public function set container(__container:DisplayObjectContainer):void
		{
			_container = __container;
			var _propWidth:String = (_container is Stage) ? "stageWidth" : "width";
			var _propHeight:String = (_container is Stage) ? "stageHeight" : "height";
			
			_parentDims = new Point();
			_parentDims.x = _container[_propWidth];
			_parentDims.y = _container[_propHeight];
			
		}
		
		public function set px(v:Number):void
		{
			_px = v;
			var _x:Number = _parentDims.x * v - this.width * v;
			this.x = _x;
		}
		
		public function set py(v:Number):void
		{
			_py = v;
			var _y:Number = _parentDims.y * v - this.height * v;
			this.y = _y;
		}
		
		
		public function set boundType(value:String):void 
		{
			if (value != BOUND_EXTERNAL && value != BOUND_INTERNAL && value != BOUND_NONE) throw new Error("boundType must be " + BOUND_EXTERNAL + ", " + BOUND_INTERNAL + " or " + BOUND_NONE);
			_boundType = value;
		}
		
		
		
		
		
		
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragEvent);
			_ptDrag = new Point();
			_ptDrag.x = stage.mouseX - this.x;
			_ptDrag.y = stage.mouseY - this.y;
		}
		
		override public function stopDrag():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragEvent);
		}
		
		
		override public function set x(value:Number):void 
		{
			var _minBounds:Number = 0;
			var _maxBounds:Number = _parentDims.x - this.width;
			
			if (_boundType == BOUND_INTERNAL) {
				if (value < _minBounds) value = _minBounds;
				if (value > _maxBounds) value = _maxBounds;
			}
			else if (_boundType == BOUND_EXTERNAL) {
				if (value > _minBounds) value = _minBounds;
				if (value < _maxBounds) value = _maxBounds;
			}
			
			super.x = value;
		}
		
		
		
		override public function set y(value:Number):void 
		{
			var _minBounds:Number = 0;
			var _maxBounds:Number = _parentDims.y - this.height;
			
			if (_boundType == BOUND_INTERNAL) {
				if (value < _minBounds) value = _minBounds;
				if (value > _maxBounds) value = _maxBounds;
			}
			else if (_boundType == BOUND_EXTERNAL) {
				if (value > _minBounds) value = _minBounds;
				if (value < _maxBounds) value = _maxBounds;
			}
			
			super.y = value;
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		//_______________________________________________________________
		//events handlers
		
		
		private function onDragEvent(e:MouseEvent):void 
		{
			//trace("onDragEvent");
			var _x:Number = stage.mouseX - _ptDrag.x;
			var _y:Number = stage.mouseY - _ptDrag.y;
			
			this.x = _x;
			this.y = _y;
			//todo : que faire si drag_external et trop petit et inversement ?
		}
	}
	
}