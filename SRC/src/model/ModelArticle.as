package model 
{
	import adobe.utils.CustomActions;
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
		
		
		
		
		static public function getFilteredIndexes(_listindexes:Array, _search:String):Array 
		{
			var _output:Array = new Array();
			
			var _regexp:RegExp = new RegExp(_search, "i");
			
			
			var _rawtab:Array = getArticleByIndexes(_listindexes);
			var _len:int = _rawtab.length;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _data:Object = _rawtab[i];
				var _index:int = _listindexes[i];
				
				var _title:String = _data.title;
				var _content:String = _data.content;
				
				if (_title.match(_regexp)) _output.push(_index);
				else if (_content.match(_regexp)) _output.push(_index);
				
			}
			
			return _output;
		}
		
		
		public static function getIndexesByTags(_listtags:Array, _typecat:String, _afternow:Boolean = false):Array
		{
			var _output:Array = new Array();
			var _nbtag:int = _listtags.length;
			
			var _rawdata:Object = Constantes.get("fr.list_articles.item");
			var _rawtab:Array = _rawdata as Array;
			var _len:int = _rawtab.length;
			
			
			var _idlisted:Array = [];
			var _tsnow:Number = Math.round(new Date().getTime() / 1000);
			
			
			//raccourci pour 1 seul tag (performances)
			var _tagrubric:String = _listtags[0];
			trace("_tagrubric : " + _tagrubric);
			var _isIncontournable:Boolean = _tagrubric == "incontournable";
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _data:Object = _rawtab[i];
				
				if (_isIncontournable) {
					if (_data["focus"] == "1") {
						if (_idlisted.indexOf(_data.id) == -1) {
							_output.push(i);
							_idlisted.push(_data.id);
						}
					}
				}
				else {
					
					//if (Math2.getRandProbability(0.01)) trace("- _tag : " + _tag);
					
					if (!_afternow || Number(_data["date"]) > _tsnow) {
						
						var _tag:String = _data[_typecat];
						
						if (_tag == _tagrubric) {
							if (_idlisted.indexOf(_data.id) == -1) {
								_output.push(i);
								_idlisted.push(_data.id);
							}
						}
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
			
			var _tsnow:Number = Math.round(new Date().getTime() / 1000);
			var _counter:int = 0;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _obj:Object = _rawtab[i];
				
				if (Number(_obj["date"]) > _tsnow) {
					_obj["content"] = CharEncoding.br2nl(_obj["content"]);
					_obj["content"] = CharEncoding.stripTags(_obj["content"]);
					
					_output.push(_obj);
					_counter++;
					if (_counter >= _max - 1) break;
				}
				
				
			}
			
			return _output;
		}
		
		
		
		
		
		
		
	}

}