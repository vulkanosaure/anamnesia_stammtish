package utils.virtualkeyboard.geom {
	
	import flash.geom.Point;
	import virgile.geom.XPoint;
	import virgile.utils.XMLParseUtils;
	
	
	public class XPolygon {
		
		private var _vertices:Vector.<XPoint>;
		private var _edges:Vector.<XLineSegment>;
		private var _perimeter:Number;
		private var _center:XPoint;
		
		
		//	################# SYSTEM UTILITIES
		
		/** Constructor */
		public function XPolygon() {
			_vertices = new Vector.<XPoint>();
			_edges = new Vector.<XLineSegment>();
			_perimeter = 0;
		}
		
		/** Returns a string representation of the instance */
		public function toString():String {
			return "[XPolygon] vertices: " + _vertices.length + ", closed: " + isClosed + ", perimeter: " + _perimeter.toFixed(2);
		}
		
		/** Returns a cloned Polygon instance */
		public function clone():XPolygon {
			var poly:XPolygon;
			
			poly = new XPolygon();
			poly._reset(_vertices);
			return poly;
		}
		
		
		//	################# MODEL UTILITIES
		
		/** 
		 * Defines polygon points from an XML node source
		 * @param	node	XML node source, template: <node><xxx value="xn,yn" /></node>			
		 */
		public function fromXML(node:XML):void {
			var children:XMLList;
			var vertex:XPoint;
			
			children = node.children();
			
			_vertices = new Vector.<XPoint>();
			for (var i:int = 0, len:int = children.length(); i < len; i++) {
				vertex = XMLParseUtils.ParseXPoint(String(children[i].@value), ";");
				_vertices.push(vertex);
			}
			_updateInnerProps();
		}
		
		/**
		 * Resets polygon vertices.
		 * @param	vertices	points collection defining shape as an array of XPoint instance
		 * @param	doClose	whether or not shape should be closed
		 */
		public function resetArray(vertices:Array, doClose:Boolean):void {
			var vertex:XPoint;
			
			_vertices = new Vector.<XPoint>();
			for(var i:int = 0, len:int = vertices.length; i < len; i++) {
				vertex = vertices[i] as XPoint;
				if(!vertex){
					trace("[XPolygon.resetArray] Illegal parameter: " + vertices[i]);
					continue;
				}
				_vertices.push(vertex);
			}
			
			if (doClose)
				close();
			
			_updateInnerProps();
		}
		
		/**
		 * Resets polygon vertices.
		 * @param	vertices	points collection defining shape as an vector of XPoint instance
		 * @param	doClose	whether or not shape should be closed
		 */
		public function resetVector(vertices:Vector.<XPoint>, doClose:Boolean):void {
			_vertices = vertices;
			
			if (doClose)
				close();
			
			_updateInnerProps();
		}
		
		/** Closes polygon shape if not closed yet. */
		public function close():void {
			if (isClosed)
				return;
			_vertices.push(_vertices[0]);
		}
		
		
		//	################# PROPERTIES ACCESSORS
		
		/** perimeter length */
		public function get perimeter():Number {
			return _perimeter;
		}
		
		/** points collection defining shape */
		public function get vertices():Vector.<XPoint> {
			return _vertices;
		}
		
		/** line segments collection defining shape */
		public function get edges():Vector.<XLineSegment> {
			return _edges;
		}
		
		/** whether or not the polygon has a valid settings */
		public function get isValid():Boolean {
			if (_vertices.length >= 3)
				return true;
			return (_vertices.length == 3) && (_vertices[0] == _vertices[_vertices.length - 1]);
		}
		
		/** whether shape is closed or not */
		public function get isClosed():Boolean {
			return isValid && _vertices[0].equals(_vertices[_vertices.length - 1]);
		}
		
		
		//	################# GEOMETRY UTILITIES
		
		/**
		 * Returns the intersections points between polygon and a line segment
		 * @param	ls			target line segment
		 * @param	asLine		whether or not line segment should be considered as a line
		 * @return	intersection points as XPoint instances.
		 */
		public function intersect(ls:XLineSegment, asLine:Boolean = true):Vector.<XPoint> {
			var intersections:Vector.<XPoint>;
			var intersection:XPoint;
			
			// --- computes line segments
			intersections = new Vector.<XPoint>();
			for (var i:int = 0, len:int = _edges.length; i < len; ++i) {
				intersection = _edges[i].intersectLineSegment(ls, asLine);
				if(intersection){
					intersections.push(intersection);
				}
			}
			return intersections;
		}
		
		public function get center():XPoint {
			if (!_center) {
				_center = new XPoint();
				for (var i:int = 1, len:int = _vertices.length; i < len; ++i){
					_center.plus(_vertices[i]);
				}
				_center.multiply(1 / (len - 1));
			}
			return _center;
		}
		
		
		//	##################################################################################################################
		//	PRIVATE UTILITIES
		
		private function _reset(vertices:Vector.<XPoint>):void {
			_vertices = new Vector.<XPoint>();
			for (var i:int = 0, len:int = vertices.length; i < len; i++){
				_vertices[i] = vertices[i].clone();
			}
			_updateInnerProps();
		}
		
		private function _updateInnerProps():void{
			var i:int;
			var len:int;
			var pointer:int;
			var formerVertex:XPoint;
			var edge:XLineSegment;
			
			// ---	reset properties
			_center = null;
			_edges = new Vector.<XLineSegment>();
			_perimeter = 0;
			
			// --- cancel 
			if (_vertices.length == 0) {
				trace("[XPolygon._updateInnerProps] polygon is not defined.");
				return;
			}
			
			// ---	computes line segments
			if(isClosed){
				for (i = 0, len = _vertices.length; i <= len; ++i) {
					pointer = i % len;
					if (formerVertex)
						_edges.push(new XLineSegment(formerVertex, _vertices[pointer])); 
					formerVertex = _vertices[pointer];
				}
			}
			else {
				for (i = 0, len = _vertices.length; i < len; ++i) {
					if (formerVertex)
						_edges.push(new XLineSegment(formerVertex, _vertices[i])); 
					formerVertex = _vertices[i];
				}
			}
			
			// ---	compute perimeter
			for(i = 0, len = _edges.length; i < len; ++i){
				_perimeter += _edges[i].length;
			}
		}
		
	}
}