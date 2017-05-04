package utils.virtualkeyboard.geom {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import utils.virtualkeyboard.FitMode;
	//import virgile.log.Logger;

	/**
	 * A XRect is an rectangular area defined by its top-left corner coordinates (x, y) and by its dimensions (width & height).
	 *
	 * The x, y, width, and height properties are independent of each other; changing the value of one property has no effect on the others.
	 * However, the right and bottom properties are relative to existing setting (right value affects width, bottom value affect height).
	 *
	 * @author antoine fricker - info@taisen.fr
	 */
	public class XRect {

		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;

		/**
		 * Constructor.
		 * @param	x			x coordinate
		 * @param	y			x coordinate
		 * @param	width		width dimension
		 * @param	height		height dimension
		 * @throws	Error 		if any of passed-in parameters is not a valid Number
		 */
		public function XRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			reset(x, y, width, height);
		}

		/** Returns a String representation of the object */
		public function toString():String {
			return "[XRect] {" + x.toFixed(.01) + ", " + y.toFixed(.01) + ", " + width.toFixed(.01) + ", " + height.toFixed(.01) + "}";
		}

		/** Returns the width/height ratio (ie: 16/9) */
		public function get screenRatio():Number {
			return width / height;
		}

		/**
		 * Implements instance values from passed-in ccordinates.
		 * @param	x			x coordinate
		 * @param	y			x coordinate
		 * @param	width		width dimension
		 * @param	height		height dimension
		 * @throws	Error 		if any of passed-in parameters is not a valid Number
		 */
		public function reset(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}

		/**
		 * Implements instance values from passed-in source properties (x, y, width, height).
		 * @param	source		source object used as model
		 */
		public function fromObject(source:*):void {
			reset(source.x, source.y, source.width, source.height);
		}

		/**
		 * Implements instance values from passed-in rectangle instance settings.
		 * @param	source		rectangle object used as model
		 * @throws	Error 		if any of sources parameters is not a valid Number
		 */
		public function fromRectangle(rect:Rectangle):void {
			reset(rect.x, rect.y, rect.width, rect.height);
		}

		/**
		 * Implements instance values from two passed-in points instance corresponding to opposite rectangle corners.
		 * @param	source		rectangle object used as model
		 * @throws	Error 		if any of sources parameters is not a valid Number
		 */
		public function fromCorners(pt1:XPoint, pt2:XPoint):void {
			var xMax:Number;
			var xMin:Number;
			var yMax:Number;
			var yMin:Number;


			if(pt1.x < pt2.x) {
				xMin = pt1.x;
				xMax = pt2.x;
			} else {
				xMin = pt2.x;
				xMax = pt1.x;
			}

			if(pt1.y < pt2.y) {
				yMin = pt1.y;
				yMax = pt2.y;
			} else {
				yMin = pt2.y;
				yMax = pt1.y;
			}

			reset(xMin, yMin, xMax - xMin, yMax - yMin);
		}

		/**
		 * Implements instance values from passed-in display object bounds.
		 * @param	source		source object used as model
		 * @throws	Error 		if any of sources parameters is not a valid Number
		 */
		public function fromBounds(source:DisplayObject, targetCoordinatesSpace:DisplayObject):void {
			var bounds:Rectangle = source.getBounds(targetCoordinatesSpace);
			reset(bounds.x, bounds.y, bounds.width, bounds.height);
		}

		/** Returns a cloned instance */
		public function clone():XRect {
			return new XRect(x, y, width, height);
		}

		/** Converts XRect object into a Rectangle object. */
		public function toRectangle(rounding:Number = Number.NaN):Rectangle {
			var cloned:XRect = clone();
			if(rounding == rounding)
				cloned.roundTo(rounding);
			return new Rectangle(cloned.x, cloned.y, cloned.width, cloned.height);
		}

		public function resetPosition(x:*, y:Number = Number.NaN):void {
			if(x is Point || x is XPoint) {
				this.x = x.x;
				this.y = x.y;
			} else if(x is Number && x == x && y == y) {
				this.x = x;
				this.y = y;
			} else {
				trace("[XRect.resetPosition] Illegal parameters / x: " + x + ", y: " + y);
			}
		}

		public function addToPosition(x:*, y:Number = Number.NaN):void {
			if(x is Point || x is XPoint) {
				this.x += x.x;
				this.y += x.y;
			} else if(x is Number && x == x && y == y) {
				this.x += x;
				this.y += y;
			} else {
				trace("[XRect.addToPosition] Illegal parameters / x: " + x + ", y: " + y);
			}
		}

		/**
		 * Apply instance dimension and positionto the passed-in target object.
		 * @param target object
		 */
		public function apply(target:*):void {
			target.x = x;
			target.y = y;
			target.width = width;
			target.height = height;
		}

		/**
		 * Rounds coordinates and dimensions according to the rounding precision
		 * @param	rounding	rounding precision
		 */
		public function roundTo(rounding:Number = 1):void {
			if(rounding == 0 || isNaN(rounding))
				return;
			x = _roundTo(x, rounding);
			y = _roundTo(y, rounding);
			width = _roundTo(width, rounding);
			height = _roundTo(height, rounding);
		}
		
		/**
		 * Floors coordinates and dimensions according to the rounding precision
		 * @param	rounding	rounding precision
		 */
		public function floorTo(rounding:Number = 1):void {
			if(rounding == 0 || isNaN(rounding))
				return;
			x = _floorTo(x, rounding);
			y = _floorTo(y, rounding);
			width = _floorTo(width, rounding);
			height = _floorTo(height, rounding);
		}
		
		/**
		 * Ceils coordinates and dimensions according to the rounding precision
		 * @param	rounding	rounding precision
		 */
		public function ceilTo(rounding:Number = 1):void {
			if(rounding == 0 || isNaN(rounding))
				return;
			x = _ceilTo(x, rounding);
			y = _ceilTo(y, rounding);
			width = _ceilTo(width, rounding);
			height = _ceilTo(height, rounding);
		}

		/** Rounds coordinates and dimensions taking maximal boundaries */
		public function wrapTo(rounding:Number = 1):void {
			var right:int;
			var bottom:int;

			right = int(x + width + .5);
			x = int(x);
			width = Math.abs(right - x);

			bottom = int(y + height + .5);
			y = int(y);
			height = Math.abs(bottom - y);
		}


		//	###################################################
		//	SCALING

		/**
		 * Scales instance to fit in passed-in width
		 * @param	width		target width
		 * @param	applyScale	whether or not the rectangle should be rescaled
		 * @return	applied scale
		 */
		public function fitWidth(targetWidth:Number, applyScale:Boolean = true):Number {
			var r:Number = targetWidth / width;
			if(applyScale)
				multiply(r);
			return r;
		}

		/**
		 * Scales instance to fit in passed-in height
		 * @param	targetHeight	target height
		 * @param	applyScale		whether or not the rectangle should be rescaled
		 * @return					applied scale
		 */
		public function fitHeight(targetHeight:Number, applyScale:Boolean = true):Number {
			var r:Number;
			
			r = targetHeight / height;
			if(applyScale)
				multiply(r);
			return r;
		}

		/**
		 * Scales instance to fit inside in passed-in XRect instance
		 * @param	area		area that must contain self instance
		 * @return				applied scale
		 */
		public function fitIn(area:XRect, applyScale:Boolean = true):Number {
			var r:Number;
			
			if (area.width / area.height < width / height)
				r = area.width / width;
			else
				r = area.height / height;
			
			if(applyScale)
				multiply(r);
			
			return r;
		}

		/**
		 * Scales instance to fill passed-in XRect instance (that means self dimensions must at least equal passed-in dimensions).
		 * @param	area		area that must be filled by self instance
		 * @return				applied scale
		 */
		public function fitOut(area:XRect, applyScale:Boolean = true):Number {
			var r:Number;
			
			if(area.width / area.height > width / height) 
				r = area.width / width;
			else
				r = area.height / height;
			
			if(applyScale)
				multiply(r);
			return r;
		}

		/**
		 * Scales instance dimensions.
		 * @param	scaleX		horizontal axis scale multiplier
		 * @param	scaleY		vertical axis scale multiplier (if omitted scaleX will be used for both dimensions)
		 * @param	regPoint	point used as center for homothety
		 * @return	modified self instance
		 */
		public function multiply(scaleX:Number, scaleY:Number = Number.NaN, regPoint:XPoint = null):XRect {
			scaleY = (scaleY == scaleY) ? scaleY : scaleX;
			width *= scaleX;
			height *= scaleY;
			if(regPoint) {
				x -= regPoint.x * scaleX;
				y -= regPoint.y * scaleY;
			}
			return this;
		}

		/**
		 * Scales instance dimensions and position.
		 * @param	scaleX		horizontal axis scale multiplier
		 * @param	scaleY		vertical axis scale multiplier (if omitted scaleX will be used for both dimensions)
		 * @return	modified self instance
		 */
		public function scale(scaleX:Number, scaleY:Number = Number.NaN):XRect {
			scaleY = (scaleY == scaleY) ? scaleY : scaleX;

			width *= scaleX;
			height *= scaleY;
			x *= scaleX;
			y *= scaleY;
			return this;
		}

		//	###################################################
		//	MISCALLENOUS

		/** Determines whether instance is empty (width or height is equal to 0). */
		public function isEmpty():Boolean {
			return width == 0 || height == 0;
		}

		/**
		 * Wraps area with specified margins.
		 * @usage positive values are outer margins
		 * @param	marginX		horizontal margins to be added
		 * @param	marginY		vertical margins to be added
		 */
		public function addMargin(marginX:Number, marginY:Number):void {
			x -= marginX;
			y -= marginY;
			width += (2 * marginX);
			height += (2 * marginY);
		}

		/**
		 * Aligns/justifies two XRect instances.
		 * @param	area				target area to be aligned to
		 * @param	hAlign			horizontal alignement (allowed values are "l", "c", "r")
		 * @param	vAlign			vertical alignement (allowed values are "t", "c", "b")
		 * @return	self modified instance
		 */
		public function alignOn(area:XRect, hAlign:String = "c", vAlign:String = "c"):XRect {
			var hCoef:Object
			var vCoef:Object;

			hCoef = {l: 0, c: .5, r: 1};
			vCoef = {t: 0, c: .5, b: 1};

			x = area.x + hCoef[hAlign] * (area.width - width);
			y = area.y + vCoef[vAlign] * (area.height - height);

			return this;
		}

		/**
		 *	Aligns/justifies two XRect instances.
		 * @param	area				target area to be aligned to
		 * @param	alignement		alignement pattern "horizontal first letter + vertical first letter" (ie: "cc", "lt", "rb"...)
		 * @see		virgile.display.AlignMode
		 * @return	self modified instance
		 */
		public function alignOn2(area:XRect, alignement:String):XRect {
			alignement = alignement ? alignement.toLowerCase() : null;
			if(alignement.length != 2)
				throw new Error("[XRect.alignOn2] alignement string pattern must be of length 2. See <code>virgile.display.AlignMode</code> constants.");
			return alignOn(area, alignement.charAt(0), alignement.charAt(1));
		}

		//	###################################################
		//	COMPARISON, UNION

		/**
		 * Returns the area of intersections between self and passed-in instances.
		 * @param	rect	XRect instance to compare against
		 * @return	if rectangles do not intersect, method returns an empty instance
		 */
		public function intersection(rect:XRect):XRect {
			var intersection:Rectangle = toRectangle().intersection(rect.toRectangle());
			return new XRect(intersection.x, intersection.y, intersection.width, intersection.height);
		}

		/**
		 * Determines whether passed-in and self instances intersect.
		 * @param	rect	XRect instance to compare against
		 * @return	true if areas intersect
		 */
		public function intersects(rect:XRect):Boolean {
			return toRectangle().intersects(rect.toRectangle());
		}

		/**
		 * Determines whether the self and passed-in instances are equal (dimension and position).
		 * @param	rect	XRect or Rectangle instance to compare against
		 */
		public function equals(rect:XRect):Boolean {
			return(rect.x == x) && (rect.y == y) && (rect.width == width) && (rect.height == height);
		}

		/**
		 * Adds self and passed-in instances and returns the total area.
		 * @param	rect	XRect instance to be added
		 */
		public function union(rect:XRect):XRect {
			var union:Rectangle;

			union = toRectangle().union(rect.toRectangle());
			return new XRect(union.x, union.y, union.width, union.height);
		}

		/**
		 * Determines whether self instance contains the passed-in coordinates.
		 * @param	point	coordinate point
		 */
		public function containsPoint(point:XPoint):Boolean {
			return(point.x > x) && (point.x < x + width) && (point.y > y) && (point.y < y + height);
		}
		
		/** 
		 * Constrains point within reactangular coordinates.
		 * @param	point	coordinate point
		 * @return constrained point
		 */
		public function constrainPoint(point:XPoint):XPoint {
			if (point.x < x)
				point.x = x;
			else if (point.x > right)
				point.x = right;
			if (point.y < y)
				point.y = y;
			else if (point.y > bottom)
				point.y = bottom;
			return point;
		}

		/**
		 * Determines whether the passed-in instance is contained within self instance.
		 * @param	rect	XRect instance to be tested
		 */
		public function containsRect(rect:XRect):Boolean {
			return containsPoint(rect.position) && containsPoint(new XPoint(rect.right, rect.bottom));
		}

		/** Returns the distance between a point and a rectangular area */
		public function distanceToPoint(point:XPoint):Number {
			var xDistance:Number;
			var yDistance:Number;

			if(point.x < x)
				xDistance = x - point.x;
			else if(point.x > right)
				xDistance = point.x - right;
			else
				xDistance = 0;

			if(point.y < y)
				yDistance = y - point.y;
			else if(point.y > bottom)
				yDistance = point.y - bottom;
			else
				yDistance = 0;

			return Math.sqrt(xDistance * xDistance + yDistance * yDistance);
		}

		/**
		 *	Scales instance to fit target area according to the passed-in fit mode.
		 * @param	area			target display area
		 * @param	fitMode		fit mode used for scaling
		 * @see		virgile.display.FitMode
		 * @return	scale
		 */
		public function fit(area:XRect, fitMode:String):Number {
			if(equals(area))
				return 1;

			switch(fitMode) {
				case FitMode.FIT_HEIGHT:
					return fitHeight(area.height, true);
				case FitMode.FIT_WIDTH:
					return fitWidth(area.width, true);
				case FitMode.FIT_IN:
					return fitIn(area, true);
				case FitMode.FIT_OUT:
					return fitOut(area, true);
				case FitMode.FIT_NONE:
					break;
				default:
					//Logger.Warning("[XRect.fit] Illegal fitMode: \"" + fitMode + "\"");
					break;
			}
			return 1;
		}


		//	###################################################
		//	DATA ACCESSORS

		/** x coordinate of the top-left corner of the rectangle */
		public function get x():Number {
			return _x;
		}
		public function set x(x:Number):void {
			if(x != x)
				throw new Error("[XRect.reset] Invalid \"x\" parameter: " + x);
			_x = x;
		}

		/** y coordinate of the top-left corner of the rectangle */
		public function get y():Number {
			return _y;
		}
		public function set y(y:Number):void {
			if(y != y)
				throw new Error("[XRect.reset] Invalid \"y\" parameter: " + y);
			_y = y;
		}

		/** y coordinate of the top-left corner of the rectangle */
		public function get position():XPoint {
			return new XPoint(x, y);
		}
		public function set position(position:XPoint):void {
			x = position.x;
			y = position.y;
		}

		/** center point of the instance */
		public function get center():XPoint {
			return new XPoint(x + .5 * width, y + .5 * height);
		}
		public function set center(point:XPoint):void {
			x = point.x - .5 * width;
			y = point.y - .5 * height;
		}

		/** width of the instance */
		public function get width():Number {
			return _width;
		}
		public function set width(width:Number):void {
			if(width != width)
				throw new Error("[XRect.reset] Invalid \"width\" parameter: " + width);
			if(width < 0) {
				width = -width;
				x -= width;
			}
			_width = width;
		}

		/** height of the instance */
		public function get height():Number {
			return _height;
		}
		public function set height(height:Number):void {
			if(height != height)
				throw new Error("[XRect.reset] Invalid \"height\" parameter: " + height);
			if(height < 0) {
				height = -height;
				y -= height;
			}
			_height = height;
		}

		/** position of the left side of the XRect on the x axis (scales instance, use x to move XRect if scaling is not intended) */
		public function get left():Number {
			return x;
		}
		public function set left(left:Number):void {
			width = right - left;
			x = left;
		}

		/** position of the right side of the XRect on the x axis (scales instance, use x to move XRect if scaling is not intended) */
		public function get right():Number {
			return x + width;
		}
		public function set right(right:Number):void {
			width = right - x;
		}

		/** position of the top side of the XRect on the y axis (scales instance, use x to move XRect if scaling is not intended) */
		public function get top():Number {
			return y;
		}
		public function set top(top:Number):void {
			height = bottom - top;
			y = top;
		}

		/** position of the bottom side of the XRect on the y axis (scales instance, use x to move XRect if scaling is not intended) */
		public function get bottom():Number {
			return y + height;
		}
		public function set bottom(bottom:Number):void {
			height = bottom - y;
		}
		
		
		public function set dimension(dimension:XPoint):void {
			width = dimension.x;
			height = dimension.x;
		}
		public function get dimension():XPoint{
			return new XPoint(width, height);
		}


		//	##################################################################################################################
		//	PRIVATE UTILITIES

		private function _roundTo(val:Number, rounding:Number):Number {
			return Math.round(val / rounding) * rounding;
		}

		private function _floorTo(val:Number, rounding:Number):Number {
			return Math.floor(val / rounding) * rounding;
		}

		private function _ceilTo(val:Number, rounding:Number):Number {
			return Math.ceil(val / rounding) * rounding;
		}
	}
}
