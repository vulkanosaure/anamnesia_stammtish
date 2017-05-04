package data.math
{
	import data.math.functions.LinearFunction;
	import flash.geom.Point;
	public class Math2 {
		
		
		
		public function Math2()
		{
			throw new Error("Class Math2 is static, it can't be instanciated");
		}
		
		
		//_____________________________________________________________________________
		//trigo
		
		static public function getTrigoCoord(_coord:String, angle:Number, rayon:Number, useDegre:Boolean=false):Number
		{
			if(_coord!="x" && _coord!="y") throw new Error("Math2.getTrigoCoord(), value must be 'x' or 'y' for arg 1");
			if(useDegre) angle = angle*Math.PI/180;
			var retour:Number;
			if(_coord=="x") retour = Math.cos(angle)*rayon;
			else if(_coord=="y") retour = Math.sin(angle)*rayon;
			return retour;
		}
		
		
		//todo : a améliorer pour la gestion des exceptions
		static public function getAngle2pt(x_start:Number, y_start:Number, x_end:Number, y_end:Number, useDegre:Boolean=false):Number
		{
			var dx:Number = x_end-x_start;
			var dy:Number = y_end-y_start;
			var angle:Number = Math.atan2(dy, dx);
			if(useDegre) angle = angle * 180/Math.PI;
			return angle;
		}
		
		
		
		//tothink
		//le sens est ici important, eventuellement, param qui se fiche du sens -> result %180
		static public function getAngle3pt(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, witch:Number=0, useDegre:Boolean=false):Number
		{
			var ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
			if(witch==0){
				ax = x1;
				ay = y1;
				bx = x2;
				by = y2;
				cx = x3;
				cy = y3;
			}
			else if(witch==1){
				ax = x2;
				ay = y2;
				bx = x1;
				by = y1;
				cx = x3;
				cy = y3;
			}
			else if(witch==2){
				ax = x3;
				ay = y3;
				bx = x1;
				by = y1;
				cx = x2;
				cy = y2;
			}
			
			var a1:Number = getAngle2pt(ax, ay, bx, by, useDegre);
			var a2:Number = getAngle2pt(ax, ay, cx, cy, useDegre);
			var result:Number = (a1 - a2);
			while(result<0) result += (useDegre) ? 360 : Math.PI*2;
			return result;
		}
		
		
		
		static public function getHypotenuse(x1:Number, y1:Number, x2:Number, y2:Number): Number
		{
			var dx:Number = x2-x1;
			var dy:Number = y2-y1;
			return Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
		}
		
		
		
		
		//calcul la hauteur d'un triangle issu du point désigné par l'argument witch
		static public function getTriangleHeight(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, witch:Number=0):Number
		{
			var ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
			if(witch==0){
				ax = x1;
				ay = y1;
				bx = x2;
				by = y2;
				cx = x3;
				cy = y3;
			}
			else if(witch==1){
				ax = x2;
				ay = y2;
				bx = x3;
				by = y3;
				cx = x1;
				cy = y1;
			}
			else if(witch==2){
				ax = x3;
				ay = y3;
				bx = x2;
				by = y2;
				cx = x1;
				cy = y1;
			}
			
			var angle:Number = Math2.getAngle3pt(ax, ay, bx, by, cx, cy, 1, false);
			var hypotenuse:Number = Math2.getHypotenuse(ax, ay, bx, by);
			//sinus(anglB) = h / hypotenuse (SOH)
			var result:Number = Math.sin(angle) * hypotenuse;
			return result;
		}
		
		
		
		
		
		
		
		
		
		
		
		//_____________________________________________________________________________
		//arrondis
		
		static public function floor(nb:Number, inc:Number):Number
		{
			if(!inc>0) throw new Error("Math2.floor(), inc must be > than 0");
			var retour:Number = Math.floor(nb/inc) * inc;
			return retour;
		}
		
		static public function round(nb:Number, inc:Number):Number
		{
			if(!inc>0) throw new Error("Math2.floor(), inc must be > than 0");
			var retour:Number = Math.round(nb/inc) * inc;
			return retour;
		}
		
		static public function ceil(nb:Number, inc:Number):Number
		{
			if(!inc>0) throw new Error("Math2.floor(), inc must be > than 0");
			var retour:Number = Math.ceil(nb/inc) * inc;
			return retour;
		}
		
		
		
		
		
		//_____________________________________________________________________________
		//functions
		
		static public function getLinearFunction(_pt1:Point, _pt2:Point):LinearFunction
		{
			//security vertical
			if (_pt1.x == _pt2.x) {
				_pt1.x -= 0.01;
				_pt2.x += 0.01;
			}
			
			var _a:Number = (_pt2.y - _pt1.y) / (_pt2.x - _pt1.x);
			var _b:Number = _pt1.y - _pt1.x * _a;
			return new LinearFunction(_a, _b);
		}
		
		
		static public function isPointInSegRect(_pt:Point, _seg:Segment):Boolean
		{
			var _minx:Number = (_seg.pt1.x > _seg.pt2.x) ? _seg.pt2.x : _seg.pt1.x;
			var _maxx:Number = (_seg.pt1.x < _seg.pt2.x) ? _seg.pt2.x : _seg.pt1.x;
			var _miny:Number = (_seg.pt1.y > _seg.pt2.y) ? _seg.pt2.y : _seg.pt1.y;
			var _maxy:Number = (_seg.pt1.y < _seg.pt2.y) ? _seg.pt2.y : _seg.pt1.y;
			
			if (_pt.x >= _minx && _pt.x <= _maxx && _pt.y >= _miny && _maxy <= _maxy) return true;
			return false;
		}
		
		
		
		static public function getIntersectionPoint(_s1:Segment, _s2:Segment):Point
		{
			var _f1:LinearFunction = getLinearFunction(_s1.pt1, _s1.pt2);
			var _f2:LinearFunction = getLinearFunction(_s2.pt1, _s2.pt2);
			
			var _x:Number = (_f2.b - _f1.b) / (_f1.a - _f2.a);
			var _y:Number = _f1.a * _x + _f1.b;
			
			return new Point(_x, _y);
		}
		
		static public function segmentCross(_s1:Segment, _s2:Segment):Boolean
		{
			var _int:Point = getIntersectionPoint(_s1, _s2);
			if (isPointInSegRect(_int, _s1) && isPointInSegRect(_int, _s2)) return true;
			else return false;
		}
		
		
		
		
		//_____________________________________________________________________________
		//random
		
		static public function random(min:Number, max:Number, inc:Number=1):Number
		{
			if(!inc>0) throw new Error("Math2.floor(), inc must be > than 0");
			var retour:Number = Math2.floor(Math.random() * (max-min+inc) + min, inc);
			return retour;
		}
		
		
		static public function random2(min:Number, max:Number, inc:Number, elmt:Number, indproba:Number):Number
		{
			if (elmt < min || elmt > max) throw new Error("elmt must be in interval [" + min + "," + max + "]");
			if (inc < 0) throw new Error("arg inc must be positive");
			
			var eventail:Array = new Array();
			elmt = Math2.round(elmt, inc);
			var nbelmt:Number = (max - min) / inc + 1;
			//trace("nbelmt : " + nbelmt);
			
			var nbElementHigh:int = Math.round((nbelmt-1) * indproba) + 1;
			
			
			
			var nbelmt_left:Number = (elmt - min) / inc;
			var nbelmt_right:Number = (max - elmt) / inc;
			//trace("nbelmt_left : " + nbelmt_left + ", nbelmt_right : " + nbelmt_right);
			
			var decr_left:Number = (nbelmt - 1) / nbelmt_left;
			var decr_right:Number = (nbelmt - 1) / nbelmt_right;
			//trace("decr_left : " + decr_left + ", decr_right : " + decr_right);
			
			var decr:Number = (decr_right < decr_left) ? decr_right : decr_left;
			
			
			var _item:Number;
			var _nbRepet:Number;
			var _len:int;
			var i:Number;
			
			
			
			//left side
			_item = elmt;
			_nbRepet = nbElementHigh;
			
			while (_item >= min) {
				_len = Math.round(_nbRepet);
				for (i = 0; i < _len; i++) eventail.push(_item);
				
				_item -= inc;
				_nbRepet -= decr;
			}
			
			
			//right side
			_item = elmt;
			_nbRepet = nbElementHigh;
			
			
			while (_item <= max) {
				if (_item != elmt) {
					_len = Math.round(_nbRepet);
					for (i = 0; i < _len; i++) eventail.push(_item);
				}
				
				_item += inc;
				_nbRepet -= decr;
			}
			
			
			_len = eventail.length;
			var _ind:int = Math2.random(0, _len - 1, 1);
			
			return eventail[_ind];
		}
		
		
		
		static public function getRegression(list_pts:Array):LinearFunction
		{
			var sum_xy:Number = 0;
			var sum_x2:Number = 0;
			var sum_x:Number = 0;
			var sum_y:Number = 0;
			var moy_x:Number;
			var moy_y:Number;
			
			var _n:int = list_pts.length;
			for (var i:int = 0; i < _n; i++) 
			{
				var _pt:Point = Point(list_pts[i]);
				sum_x += _pt.x;
				sum_y += _pt.y;
				sum_x2 += _pt.x * _pt.x;
				sum_xy += _pt.x * _pt.y;
			}
			
			var a:Number = (_n * sum_xy - sum_x * sum_y) / (_n * sum_x2 - sum_x * sum_x);
			
			moy_x = sum_x / _n;
			moy_y = sum_y / _n;
			var b:Number = moy_y - a * moy_x;
			
			return new LinearFunction(a, b);
		}
		
		
		
		
	}
}