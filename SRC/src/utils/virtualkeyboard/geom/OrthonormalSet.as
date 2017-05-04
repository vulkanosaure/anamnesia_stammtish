package utils.virtualkeyboard.geom {
	
	
	public class OrthonormalSet {
		
		/**
		 * Rotates a rectangle around a given center point.
		 *
		 * @param	rect					rectangle as source
		 * @param	rotationRad			required rotation (in radians)
		 * @param	center				center of rotation
		 * @return	collection of rotated points [TL, TR, BR, BL]
		 */
		public static function RotateRect(rect:XRect, rotationRad:Number, center:XPoint = null):Vector.<XPoint> {
			var points:Vector.<XPoint>;
			
			points = new Vector.<XPoint>();
			points.push(new XPoint(rect.x, rect.y));
			points.push(new XPoint(rect.right, rect.y));
			points.push(new XPoint(rect.right, rect.bottom));
			points.push(new XPoint(rect.x, rect.bottom));
			
			return rotatePoints(points, rotationRad, center ? center : new XPoint(rect.x, rect.y));
		}
		
		
		/**
		 *	Rotates a sets of points around a given center point.
		 *
		 * @param	points			collections of XPoint instances to be rotated
		 * @param	rotationRad		required rotation (in radians)
		 * @param	center			center of rotation (if none use
		 * @return	collection of rotated points
		 */
		public static function RotatePoints(points:Vector.<XPoint>, rotationRad:Number, center:XPoint = null):Vector.<XPoint> {
			if(!center)
				center = new XPoint();
			for(var i:int = 0, len:int = points.length, point:XPoint; i < len; i++) {
				point = points[i];
				point.minus(center);
				point.setAngleRad(point.getAngleRad() + rotationRad);
				point.plus(center);
			}
			return points;
		}
	}
}
