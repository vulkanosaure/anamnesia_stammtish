package utils.virtualkeyboard.geom {
	import virgile.math.RandomUtils;
	
	public class XPolygonTransform{
		
		public function XPolygonTransform(){
			
		}
		
		public function positionOnPerimeter(polygon:XPolygon, ratio:Number):XPoint {
			var edge:XLineSegment;
			var position:XPoint;
			var edgeLength:Number;
			var currentRatio:Number;
			var formerRatio:Number;
			
			formerRatio = 0;
			currentRatio = 0;
			for(var i:int = 0, len:int = polygon.edges.length; i < len; ++i) {
				edge = polygon.edges[i];
				currentRatio += edge.length / polygon.perimeter;
				if (currentRatio == ratio) {
					return edge.pt2.clone();
				}
				else if (currentRatio > ratio) {
					position = edge.pt2.clone();
					position.minus(edge.pt1.clone());
					position.multiply((ratio - formerRatio) / (currentRatio - formerRatio));
					position.plus(edge.pt1);
					return position;
				}
				else {
					formerRatio = currentRatio;
				}
			}
			return polygon.edges[0].pt1.clone();
		}
		
		public function trackOnPerimeter(polygon:XPolygon, ratio:Number):Vector.<XPoint> {
			var path:Vector.<XPoint>;
			var edge:XLineSegment;
			var currentRatio:Number;
			var formerRatio:Number;
			
			path = new Vector.<XPoint>();
			path.push(polygon.edges[0].pt1.clone());
			
			formerRatio = 0;
			currentRatio = 0;
			
			for(var i:int = 0, len:int = polygon.edges.length; i < len; ++i) {
				edge = polygon.edges[i];
				currentRatio += edge.length / polygon.perimeter;
				if(currentRatio == ratio) {
					path.push(edge.pt2.clone());
					break;
				}
				else if(currentRatio > ratio) {
					path.push(positionOnPerimeter(polygon, ratio));
					break;
				}
				else{
					path.push(edge.pt2.clone());
				}
			}
			
			return path;
		}
		
		public function fragment(polygon:XPolygon, maxEdgeLength:Number):void {
			var edges:Vector.<XLineSegment>;
			var edge:XLineSegment;
			var edgeLength:Number;
			var subEdges:Vector.<XLineSegment>;
			var vertices:Vector.<XPoint>;

			edges = new Vector.<XLineSegment>();
			
			for (var i:int = 0, len:int = polygon.edges.length; i < len; ++i) {
				edge = polygon.edges[i];
				edgeLength = edge.length;
				if (edgeLength > maxEdgeLength) {
					subEdges = edge.split(int(Math.ceil(edgeLength / maxEdgeLength)));
					for each(edge in subEdges)
						edges.push(edge);
				}
				else{
					edges.push(edge);
				}
			}
			
			

			vertices = new Vector.<XPoint>();
			for(i = 0, len = edges.length; i < len; ++i){
				vertices.push(edges[i].pt1.clone());
			}
			
			polygon.resetVector(vertices, true);
		}
		
		public function shiver(polygon:XPolygon, shiverRadius:XPoint):void {
			var wasClosed:Boolean;
			
			wasClosed = polygon.isClosed;
			
			for (var i:int = 0, len:int = polygon.vertices.length; i < len; ++i) {
				polygon.vertices[i].x += Math.random() * (2 * shiverRadius.x) - shiverRadius.x;
				polygon.vertices[i].y += Math.random() * (2 * shiverRadius.y) - shiverRadius.y;
			}
			
			if (wasClosed)
				polygon.vertices[polygon.vertices.length - 1] = polygon.vertices[0];
		}
		
		/*
		
		
			var f:Number;
			var currentRatio:Number;
			var formerRatio:Number;
			var position:XPoint;
			
			formerRatio = 0;
			for (var i:int = 0, len:int = _perimeterRatio.length; i < len; ++i) {
				currentRatio = _perimeterRatio[i];
				if (currentRatio > ratio){
					f = ((ratio - formerRatio) / (currentRatio - formerRatio));
					position = _edges[i].pt2.clone();
					position.minus(_edges[i].pt1.clone());
					position.multiply(f);
					position.plus(_edges[i].pt1);
					return position;
				}
				formerRatio = currentRatio;
			}
			
			return _edges[0].pt1;
		}
		
		public function trackOnPerimeter(ratio:Number):Vector.<XPoint>{
			var f:Number;
			var currentRatio:Number;
			var formerRatio:Number;
			var position:XPoint;
			
			formerRatio = 0;
			for (var i:int = 0, len:int = _perimeterRatio.length; i < len; ++i) {
				currentRatio = _perimeterRatio[i];
				if (currentRatio > ratio){
					f = ((ratio - formerRatio) / (currentRatio - formerRatio));
					position = _edges[i].pt2.clone();
					position.minus(_edges[i].pt1.clone());
					position.multiply(f);
					position.plus(_edges[i].pt1);
					return position;
				}
				formerRatio = currentRatio;
			}
			
			return _edges[0].pt1;
		}
		
		*/
	}
}