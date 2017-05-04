package utils.virtualkeyboard.geom {
	
	import virgile.geom.XPoint;
	import virgile.geom.XRect;
	
	public class XLineSegment {
		
		private var _pt1:XPoint;
		private var _pt2:XPoint;
		private var _length:Number;
		
		/**
		 * Constructor
		 * @param	pt1		first point of segment definition
		 * @param	pt2		second point of segment definition
		 */
		public function XLineSegment(pt1:XPoint, pt2:XPoint) {
			reset(pt1, pt2);
		}
		
		/**
		 * Defines segment definition
		 * @param	pt1		first point of segment definition
		 * @param	pt2		second point of segment definition
		 */
		public function reset(pt1:XPoint, pt2:XPoint):void {
			this.pt1 = pt1;
			this.pt2 = pt2;
		}
		
		/** first point of segment definition */
		public function get pt1():XPoint {
			return _pt1;
		}
		
		public function set pt1(pt1:XPoint):void {
			_pt1 = pt1;
		}
		
		/** second point of segment definition */
		public function get pt2():XPoint {
			return _pt2;
		}
		
		public function set pt2(pt2:XPoint):void {
			_pt2 = pt2;
		}
		
		public function get length():Number {
			var dx:Number, dy:Number;
			
			dx = pt1.x - pt2.x;
			dy = pt1.y - pt2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public function intersectLineSegment(s:XLineSegment, asLines:Boolean = false):XPoint {
			var ip:XPoint;
			var a1:Number, a2:Number;
			var b1:Number, b2:Number;
			var c1:Number, c2:Number;
			var denom:Number;
			
			a1 = pt2.y - pt1.y;
			b1 = pt1.x - pt2.x;
			c1 = pt2.x * pt1.y - pt1.x * pt2.y;
			a2 = s.pt2.y - s.pt1.y;
			b2 = s.pt1.x - s.pt2.x;
			c2 = s.pt2.x * s.pt1.y - s.pt1.x * s.pt2.y;
			
			denom = a1 * b2 - a2 * b1;
			if (denom == 0)
				return null;
			ip = new XPoint((b1 * c2 - b2 * c1) / denom, (a2 * c1 - a1 * c2) / denom);
			
			if (!asLines) {
				if (Math.pow(ip.x - pt2.x, 2) + Math.pow(ip.y - pt2.y, 2) > Math.pow(pt1.x - pt2.x, 2) + Math.pow(pt1.y - pt2.y, 2))
					return null;
				if (Math.pow(ip.x - pt1.x, 2) + Math.pow(ip.y - pt1.y, 2) > Math.pow(pt1.x - pt2.x, 2) + Math.pow(pt1.y - pt2.y, 2))
					return null;
				if (Math.pow(ip.x - s.pt2.x, 2) + Math.pow(ip.y - s.pt2.y, 2) > Math.pow(s.pt1.x - s.pt2.x, 2) + Math.pow(s.pt1.y - s.pt2.y, 2))
					return null;
				if (Math.pow(ip.x - s.pt1.x, 2) + Math.pow(ip.y - s.pt1.y, 2) > Math.pow(s.pt1.x - s.pt2.x, 2) + Math.pow(s.pt1.y - s.pt2.y, 2))
					return null;
			}
			
			return ip;
		}
		
		public function intersectRect(r:XRect, asLine:Boolean = true):Vector.<XPoint> {
			var polygon:XPolygon;
			
			polygon = new XPolygon();
			polygon.resetArray([new XPoint(r.x, r.y), new XPoint(r.x + r.width, r.y), new XPoint(r.x + r.width, r.y + r.height), new XPoint(r.x, r.y + r.height)], false);
			return polygon.intersect(this);
		}
		
		public function intersectCircle(center:XPoint, radius:Number, asLine:Boolean = false):Vector.<XPoint> {
			var points:Vector.<XPoint>;
			var dcx:Number = pt1.x - center.x;
			var dcy:Number = pt1.y - center.y;
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt2.y - pt1.y;
			
			// you can derive a quadratic of the form An^2 + Bn + C = 0
			var A:Number = dx * dx + dy * dy;
			var B:Number = 2 * (dcx * dx + dcy * dy);
			var C:Number = dcx * dcx + dcy * dcy - radius * radius;
			
			var n:Number;
			
			
			
			points = new Vector.<XPoint>();
			
			// checking the discriminant for number of solutions
			var discriminant:Number = B * B - 4 * A * C;
			if (discriminant == 0) {
				n = -B / (2 * A);
				
				if (_isValidPositionMultiplier(n, asLine)) {
					points[0] = new XPoint(center.x + dcx + dx * n, center.y + dcy + dy * n);
				}
			}
			else if (discriminant > 0) {
				discriminant = Math.sqrt(discriminant);
				
				center.x += dcx;
				center.y += dcy;
				
				n = (-B + discriminant) / (2 * A);
				var isFirstValueValid:Boolean = _isValidPositionMultiplier(n, asLine);
				if (isFirstValueValid)
					points[0] = new XPoint(center.x + dx * n, center.y + dy * n);
				
				n = (-B - discriminant) / (2 * A);
				if (_isValidPositionMultiplier(n, asLine)) {
					if (isFirstValueValid)
						points[1] = new XPoint(center.x + dx * n, center.y + dy * n);
					else
						points[0] = new XPoint(center.x + dx * n, center.y + dy * n);
				}
			}
			
			return points;
		}
		
		private function _isValidPositionMultiplier(n:Number, asLine:Boolean = false):Boolean {
			if (isNaN(n))
				return false;
			else if (asLine)
				return n >= 0;
			return n >= 0 && n <= 1;
		}
		
		public function split(tokenNum:int):Vector.<XLineSegment> {
			var lineSegments:Vector.<XLineSegment>;
			var tokenInc:XPoint, tokenPt1:XPoint, tokenPt2:XPoint;
			
			lineSegments = new Vector.<XLineSegment>();
			
			if (tokenNum <= 0) {
				trace('[XLineSegment.split] Illegal "numTokens" parameter: ' + tokenNum);
				lineSegments.push(this);
			}
			else if (tokenNum == 1) {
				lineSegments.push(this);
			}
			else{
				tokenInc = pt2.clone().minus(pt1).multiply(1 / tokenNum);
				for (var i:int = 0; i < tokenNum; ++i){
					tokenPt1 = pt1.clone().plus(tokenInc.clone().multiply(i));
					tokenPt2 = pt1.clone().plus(tokenInc.clone().multiply(i + 1));
					lineSegments.push(new XLineSegment(tokenPt1, tokenPt2));
				}
			}
			return lineSegments;
		}
	}
}