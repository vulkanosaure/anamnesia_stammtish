package utils.virtualkeyboard.geom {
	
	import flash.geom.Point;
	import flash.ui.Mouse;
	import org.osflash.signals.Signal;
	//import virgile.app.Global;
	
	/**
	 * The XPoint object represents a location in a two-dimensional coordinate system, where x  represents the horizontal axis and y represents the vertical axis
	 * @author antoine fricker - info@taisen.fr
	 */
	public class XPoint {
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _changed:Signal;
		
		/**
		 * Constructor.
		 * @param	x	x-axis coordinate
		 * @param	y	y-axis coordinate
		 */
		public function XPoint(x:Number = 0, y:Number = 0) {
			reset(x, y);
		}
		
		/**
		 * Signal broadcasting position changes. For performance purposes, signal has to be broadcasted intentionally.
		 */
		public function get changed():Signal {
			if (_changed == null) {
				_changed = new Signal();
			}
			return _changed;
		}
		public function dispose():void {
			_changed.removeAll();
			_changed = null;
		}
		
		/**
		 * Resets point coordinates.
		 * @param	x	x-axis coordinate
		 * @param	y	y-axis coordinate
		 */
		public function reset(x:Number = 0, y:Number = 0):void {
			this.x = x;
			this.y = y;
		}
		
		/** Implements instance from a Point instance */
		public function fromPoint(point:Point):void{
			x = point.x;
			y = point.y;
		}
		
		/** Implements instance from a mouse position */
		/*public function fromMouse():void {
			x = Global.stage.mouseX;
			y = Global.stage.mouseY;
		}*/
		
		/**
		 * Implements instance from unit circle
		 * @param	theta		point angle on unit circle radius (in radians)
		 * @param	radius		unit circle radius
		 * @param	initPoint	center of unit circle
		 */
		public function fromUnitCircle(thetaRad:Number, radius:Number = 1, initPoint:XPoint = null):void {
			if(initPoint)
				reset(initPoint.x, initPoint.y);
			x += Math.cos(thetaRad) * radius;
			y += Math.sin(thetaRad) * radius;
		}
		
		/** Implements instance as the barycenter of all given equally weighted XPoint instances */
		public function fromAverage(...points:Array):void {
			reset(0, 0);
			if (!points || points.length == 0)
				return;
			for each(var point:XPoint in points)
				plus(point);
			multiply(1 / points.length);
		}
		
		/**
		 * Implements instance based on source object "x" and "y" properties
		 * @param	source	object to be converted
		 * @throws	Error	if source object is null or any of source coordinate is not a valid Number
		 */
		public function fromObject(source:*):void{
			if (!source)
				throw new Error('Invalid source parameter. source can not be null.');
			reset(source.x, source.y);
		}
		
		
		//	---------------------- SYSTEM OPERATIONS
		
		/** Returns a string representation of the instance */
		public function toString():String{
			return 'XPoint {' + x.toFixed(2) + ', ' + y.toFixed(2) + '}';
		}
		
		/**
		 * Rounds coordinates according to the rounding precision
		 * @param	rounding	rounding precision
		 */
		public function roundTo(rounding:Number = 1):XPoint {
			if (rounding == 0 || isNaN(rounding))
				return this;
				
			if(rounding == 1){
				x = int(x + .5);
				y = int(y + .5);
			}
			else {
				x = Math.round(x / rounding) * rounding;
				y = Math.round(y / rounding) * rounding;
			}
			return this;
		}
		
		/**
		 * Ceils coordinates according to the rounding precision
		 * @param	rounding	rounding precision
		 */
		public function ceilTo(rounding:Number = 1):XPoint {
			if (rounding == 0 || isNaN(rounding))
				return this;
				
			if (rounding == 1) {
				x = Math.ceil(x);
				y = Math.ceil(y);
			}
			else {
				x = Math.ceil(x / rounding) * rounding;
				y = Math.ceil(y / rounding) * rounding;
			}
			return this;
		}
		
		/** Returns a clone of the instance */
		public function clone():XPoint{
			return new XPoint(x, y);
		}
		
		/** Converts instance to a Point instance of the same coordinates */
		public function toPoint():Point {
			return new Point(x, y);
		}
		
		/**
		 * Applies x and y properties on passed-in object
		 * @throws	Error	if target object is null or do not hold "x" and "y" properties
		 */
		public function apply(o:*):void{
			o.x = x;
			o.y = y;
		}
		
		
		//	---------------------- GEOMETRY OPERATION
		
		/**
		 * Returns normalized vector
		 * @usage	The normalized vector of X is a vector in the same direction but where norm (length) equals 1
		 */
		public function normalize():XPoint {
			length = 1;
			return this;
		}
		
		/** Inverts this vector */
		public function invert():XPoint{
			x = - _x;
			y = - _y;
			return this;
		}
		
		/**  Adds self and passed-in XPoint instances */
		public function plus(point:XPoint):XPoint {
			x += point.x;
			y += point.y;
			return this;
		}
		
		/**  Substracts self and passed-in XPoint instances */
		public function minus(point:XPoint):XPoint {
			x -= point.x;
			y -= point.y;
			return this;
		}
		
		/**
		 * Scales XPoint instance
		 * @param	scaleX	horizontal axis scale multiplier
		 * @param	scaleY	vertical axis scale multiplier (if omitted scaleX will be used for both axis)
		 */
		public function multiply(scaleX:Number, scaleY:Number = Number.NaN):XPoint{
			x *= scaleX;
			y *= scaleY != scaleY ? scaleX : scaleY;
			return this;
		}
		
		/**
		 * Divides XPoint coordinates by passed-in coefficient.
		 * @param	xCoef	horizontal axis divider
		 * @param	yCoef	vertical axis divider (if omitted xCoef will be used for both axis)
		 */
		public function divide(xCoef:Number, yCoef:Number = Number.NaN):XPoint {
			x /= xCoef;
			y /= yCoef != yCoef ? xCoef : yCoef;
			return this;
		}
		
		/**
		 * Returns slope angle between two XPoint instances (in radian).
		 * @param	point	secondary XPoint instance (if omitted uses the coordinate system origin)
		 */
		public function getAngleRad(point:XPoint = null):Number{
			if(!point)
				point = new XPoint(0, 0);
			return Math.atan2(point.y - y, point.x - x);
		}
		
		/**
		 * Sets slope angle between two XPoint instances (in radian).
		 * @param	theta	assigned angle in radians
		 */
		public function setAngleRad(theta:Number):XPoint{
			var magnitude:Number = Math.sqrt(x * x + y * y);
			x = magnitude * Math.cos(theta) || 0;
			y = magnitude * Math.sin(theta) || 0;
			return this;
		}
		
		/** Returns true is the vector is empty (vector length equals 0) */
		public function isEmpty():Boolean {
			return x == 0 && y == 0;
		}
		
		public function equals(pt:XPoint):Boolean {
			return pt.x == x && pt.y == y;
		}
		
		/** Returns a new XPoint containing the addition result of self and passed-in instances */
		public function addition(added:XPoint):XPoint{
			return  new XPoint(x + added.x, y + added.y);
		}
		
		
		//	---------------------- PROPERTIES ACCESS
		
		/** x-axis coordinate */
		public function get x():Number {
			return _x;
		}
		public function set x(x:Number):void {
			if (x != x)
				throw new Error('Invalid parameter. "x" property must be a valid Number');
			_x = x;
		}
		
		/** y-axis coordinate */
		public function get y():Number {
			return _y;
		}
		public function set y(y:Number):void {
			if (y != y)
				throw new Error('Invalid parameter. "y" property must be a valid Number');
			_y = y;
		}
		
		/** length of the vector formed by the instance coordinates */
		public function get length():Number {
			return Math.sqrt(x * x + y * y);
		}
		public function set length(length:Number):void {
			var currentLength:Number = this.length;
			if (currentLength == 0){
				x = length;
				y = 0;
			}
			else{
				var coef:Number = length / currentLength;
				x *= coef;
				y *= coef;
			}
		}
	}
}
