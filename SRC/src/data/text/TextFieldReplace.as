package data.text
{
        import flash.text.TextField;
        import flash.events.Event;
        import flash.events.KeyboardEvent;

        public class TextFieldReplace
        {
				private static var replacements:Array;
               
				
                public static function add(_field:TextField, _charTarget:String, _charReplace:String):void
                {
					if (replacements == null) replacements = new Array();
					replacements.push({"field" : _field, "charTarget" : _charTarget, "charReplace" : _charReplace});
                    _field.addEventListener(Event.CHANGE, onFieldChangeHandler);
                    _field.addEventListener(KeyboardEvent.KEY_DOWN, onFieldKeyDownHandler);
					
                }
               
                private static function onFieldChangeHandler(evt:Event):void
                {
                    //trace("onFieldChangeHandler");
					
					var _field:TextField = evt.target as TextField;
					
					var _rep:Object;
					for (var i:int = 0; i < replacements.length; i++) {
						_rep = replacements[i];
						if (_rep["field"] == _field) {
							if (_field.text.indexOf(_rep["charTarget"]) != -1) {
								_field.text = _field.text.replace(_rep["charTarget"], _rep["charReplace"]);
								_field.setSelection(_field.length, _field.length);
							}
							
						}
					}
                }
               
                private static function onFieldKeyDownHandler(evt:KeyboardEvent):void
                {
					
                }
               
        }
}