package model 
{
	import data.text.CharEncoding;
	import data2.asxml.Constantes;
	import data2.math.Math2;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ModelArticle 
	{
		
		public function ModelArticle() 
		{
			
		}
		
		
		public static function getIndexesByTags(_listtags:Array, _typecat:String):Array
		{
			var _output:Array = new Array();
			var _nbtag:int = _listtags.length;
			
			var _rawdata:Object = Constantes.get("fr.list_articles.item");
			var _rawtab:Array = _rawdata as Array;
			var _len:int = _rawtab.length;
			
			
			
			
			//raccourci pour 1 seul tag (performances)
			var _tagrubric:String = _listtags[0];
			trace("_tagrubric : " + _tagrubric);
			var _isIncontournable:Boolean = _tagrubric == "incontournable";
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _data:Object = _rawtab[i];
				
				if (_isIncontournable) {
					if (_data["focus"] == "1") _output.push(i);
				}
				else {
					var _tag:String = _data[_typecat];
					
					//if (Math2.getRandProbability(0.01)) trace("- _tag : " + _tag);
					
					if (_tag == _tagrubric) {
						_output.push(i);
					}
				}
				
				
			}
			
			return _output;
		}
		
		
		static public function getArticleByIndexes(_listindexes:Array):Array 
		{
			var _output:Array = new Array();
			
			var _rawdata:Object = Constantes.get("fr.list_articles.item");
			var _rawtab:Array = _rawdata as Array;
			var _len:int = _rawtab.length;
			var _nbindex:int = _listindexes.length;
			
			for (var i:int = 0; i < _nbindex; i++) 
			{
				var _ind:int = _listindexes[i];
				_output.push(_rawtab[_ind]);
				
			}
			
			
			return _output;
		}
		
		static public function getTagsByMenuItem(_idscreen:String):Array 
		{
			
			var _tags:String = String(Constantes.get("fr.rubrics." + _idscreen + ".tags"));
			//trace("_tags : " + _tags);
			var _output:Array = _tags.split(",");
			return _output;
		}
		
		
		static public function getNodeByMenuItem(_idscreen:String):String 
		{
			
			var _output:String = String(Constantes.get("fr.rubrics." + _idscreen + ".node", null, true));
			if (_output == null) _output = "list_articles";
			return _output;
		}
		
		
		
		static public function getTypeCatByMenuItem(_idscreen:String):String 
		{
			var _output:String = String(Constantes.get("fr.rubrics." + _idscreen + ".cattype"));
			return _output;
		}
		
		
		
		static public function getActu(_max:int):Array 
		{
			var _output:Array = new Array();
			
			var _rawdata:Object = Constantes.get("fr.list_actu.item");
			var _rawtab:Array = _rawdata as Array;
			var _len:int = _rawtab.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _rawtab[i];
				_obj["content"] = CharEncoding.br2nl(_obj["content"]);
				_obj["content"] = CharEncoding.stripTags(_obj["content"]);
				
				_output.push(_obj);
				if (i >= _max - 1) break;
			}
			
			return _output;
		}
		
		
		
	}

}