package data.form {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.FocusEvent;
	import flash.display.InteractiveObject;
	
	
	import data.form.Input;
	
	public class Form extends Sprite{
		
		
		//params
		
		
		//private vars
		private var offsetFocus:int;
		private var tab_inputs:Array;
		private var __btnvalid:Sprite;
		private var __tffeedback:TextField;
		private var __mcloading:MovieClip;

		protected var tformat:TextFormat;
		private var _enabled:Boolean = false;
		public var debug:Boolean;
		public var submitOnEnterKey:Boolean;
		private var st:Stage;
		private var blockTab:Boolean;
		private var indfocus:int;
		protected var color_normal:int, color_error:int;
		
		
		public static const REGEX_EMAIL:RegExp = /^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,5}$/;		
		
		
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Form(_offsetFocus:int) 
		{
			//trace("constructor Form");
			offsetFocus = _offsetFocus;
			tab_inputs = new Array();
			tformat = new TextFormat();
			debug = false;
			submitOnEnterKey = true;
			blockTab = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			
		}
		
		public function addInput(_tf:TextField, _required:Boolean, _info:String, _errorMsg:String="", _errorFormat:String="", _regex:RegExp=null, _restrict:String="", _rememberValue:Boolean=false):void
		{
			if (_errorFormat != "" && _regex == null) throw new Error("if you specify arg _errorFormat, you must specify arg _regex");
			if (_tf == null || _tf.type != TextFieldType.INPUT) throw new Error("tf must be of type " + TextFieldType.INPUT);
			
			tab_inputs.push(new Input());
			var len:int = tab_inputs.length;
			var i:Input = tab_inputs[len-1];
			i.tf = _tf;
			i.rememberValue = _rememberValue;
			i.required = _required;
			i.info = _info;
			i.error_msg = _errorMsg;
			i.setTabIndex(len + offsetFocus);
			i.restrict = _restrict;
			if (_errorFormat != "" && _errorFormat != null) i.error_format = _errorFormat;
			i.setRegex(_regex);
			
		}
		
		public function setInput(_ind:int, _str:String):void
		{
			if (tab_inputs[_ind] == null) throw new Error("input ind " + _ind + " doesn't exists");
			tab_inputs[_ind].setInput(_str);
		}
		
		
		public function get inputs():Array
		{
			return tab_inputs;
		}
		
		public function set btnValid(_mc:Sprite):void
		{
			__btnvalid = _mc;
			__btnvalid.buttonMode = true;
			__btnvalid.addEventListener(MouseEvent.CLICK, onSubmit);
		}
		
		public function setTfFeedback(_tf:TextField):void
		{
			if (_tf==null || _tf.type != TextFieldType.DYNAMIC) throw new Error("tfFeedback must be of type "+TextFieldType.DYNAMIC);
			__tffeedback = _tf;
			__tffeedback.selectable = false;
			__tffeedback.text = "";
		}
		public function setMcLoading(_mc:MovieClip):void
		{
			__mcloading = _mc;
			__mcloading.visible = false;
		}
		
		public function get btnValid():Sprite
		{
			return __btnvalid;
		}
		
		public function empty():void
		{
			for(var i:int=0;i<tab_inputs.length;i++){
				tab_inputs[i].reset();
				tab_inputs[i].setTextFormat(tformat);
			}
		}
		
		public function emptyAt(_ind:int):void
		{
			tab_inputs[_ind].reset();
			tab_inputs[_ind].setTextFormat(tformat);
		}
		
		public function setSpecialError(_ind:int, _error:String):void
		{
			tab_inputs[_ind].setSpecialError(_error);
		}
		
		public function reset():void
		{
			tab_inputs = new Array();
		}
		
		public function setFontColors(c1:int, c2:int):void
		{
			for(var i:int=0;i<tab_inputs.length;i++){
				tab_inputs[i].color_normal = c1;
				tab_inputs[i].color_error = c2;
			}
			this.color_normal = c1;
			this.color_error = c2;
		}
		
		
		public function enable():void
		{
			_enabled = true;
		}
		public function disable():void
		{
			_enabled = false;
		}
		
		
		public function submit():void
		{
			onSubmit(new MouseEvent(""));
		}
		
		public function isError(_ind:int):Boolean
		{
			return tab_inputs[_ind].error;
		}
		
		public function correctField(_ind:int):Boolean
		{
			return checkField(_ind);
		}
		
		public function setFeedback(_str:String, _col:int):void
		{
			__tffeedback.text = _str;
			__tffeedback.setTextFormat(tformat);
			__tffeedback.textColor = _col;
		}
		
		public function startValidation():void
		{
			if (__mcloading != null) __mcloading.visible = true;
			if (__tffeedback != null) __tffeedback.text = "";
			__btnvalid.mouseEnabled = false;
			__btnvalid.mouseChildren = false;
		}
		public function stopValidation():void
		{
			if(__mcloading!=null) __mcloading.visible = false;
			__btnvalid.mouseEnabled = true;
			__btnvalid.mouseChildren = true;
		}
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function checkForm():Boolean
		{
			var bok:Boolean = true;
			var filled:Boolean;
			var required:Boolean;
			var _isregex:Boolean;
						
			for(var i:int=0;i<tab_inputs.length;i++){
				if (!checkField(i)) bok = false;
			}
			return bok;
		}
		
		private function checkField(i:int):Boolean
		{
			var bok:Boolean = true;
			var filled:Boolean;
			var required:Boolean;
			var _isregex:Boolean;
			
			filled = tab_inputs[i].isFilled();
			required = tab_inputs[i].required;
			_isregex = tab_inputs[i].getRegex() != null;
			
			tab_inputs[i].rewind();
			
			if(required && !filled){
				tab_inputs[i].setError();
				bok = false;
			}
			else if(!required && !filled){
				tab_inputs[i].empty();
			}
			if(_isregex){
				if(filled && !checkRegexSyntax(i)){
					tab_inputs[i].setErrorFormat();
					bok = false;
				}
			}
			return bok;
		}
		
		
		
		private function checkRegexSyntax(_ind:int):Boolean {
			var _str:String = tab_inputs[_ind].text;
			var _regex:RegExp = tab_inputs[_ind].getRegex();
			if(_str.search(_regex)==-1) return false;
			else return true;
		}
		
		private function isObjInForm(_iobj:InteractiveObject):Boolean
		{
			for(var i:* in tab_inputs){
				if(_iobj==tab_inputs[i].textfield) return true;
			}
			return false;
		}
		
		protected function setFocus(i:int):void
		{
			stage.focus = tab_inputs[i].textfield;
		}
		
		private function getFocus():int
		{
			var len:int = tab_inputs.length;
			for(var i:int=0;i<len;i++){
				if(stage.focus==tab_inputs[i].textfield) return i;
			}
			return -1;
		}
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onSubmit(e:MouseEvent):void
		{
			// trace("_enabled = "+_enabled );
			//if(!_enabled) return;				//new
			dispatchEvent(new Event("SUBMIT"));
			stage.focus = null;
			if(__tffeedback!=null) __tffeedback.text = "";
			var bok:Boolean = checkForm();			
			if(debug) bok = true;
			// trace("bok : "+bok);
			if(bok){
				dispatchEvent(new Event("CHECKED"));
			}
			else dispatchEvent(new Event("ERROR"));
		}
		
		
		private function onAddedToStage(e:Event):void
		{
			st = stage;
			stage.addEventListener(KeyboardEvent.KEY_UP, onkeyup);
			stage.addEventListener(FocusEvent.FOCUS_IN, onStageFocusIn);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onkeyup);
			stage.removeEventListener(FocusEvent.FOCUS_IN, onStageFocusIn);
		}
		
		
		private function onkeyup(e:KeyboardEvent):void
		{
			//trace("onkeyup, _enabled : "+_enabled);
			if(_enabled && e.keyCode==Keyboard.ENTER){
				var tf:TextField = stage.focus as TextField;
				if (tf != null && !tf.multiline) {
					dispatchEvent(new Event("PRESS_ENTER"));
					if(submitOnEnterKey) this.submit();
				}
			}
		}
		
		private function onFocusInput(e:Event):void
		{
			//unset fullscreen
			st.displayState = StageDisplayState.NORMAL;
			this.enable();
		}
		
		private function onStageFocusIn(e:FocusEvent):void
		{
			
			indfocus = getFocus();
			var iobj:InteractiveObject = stage.focus;
			// trace("onStageFocusIn "+iobj);
			
			if(!isObjInForm(iobj) && iobj!=btnValid){
				this.disable();
				// trace("Form :: FOCUS_OUT");
			}
			//
			else{
				st.displayState = StageDisplayState.NORMAL;
				this.enable();
				// trace("Form :: FOCUS_INPUT");
			}
			
			
		}
		
		
	}
	
}




/*
//EXEMPLE D'INTEGRATION

package src.form {
	
	import flash.events.Event;
	import data.form.Form;
	import data.net.PHPManager;
	public class Form_inscription extends Form{
	
		private const FILE_PHP:String = "php/newsletter.php";
		
		public function Form_inscription(_offsetFocus:int=0) 
		{ 
			super(_offsetFocus);
			addInput(tf_name, true, "", "Champ requis");
			addInput(tf_surname, true, "", "Champ requis");
			addInput(tf_email, true, "", "Champ requis", "email incorrect", Form.REGEX_EMAIL);
			addInput(tf_tel, false, "");
			addInput(tf_address, true, "", "Champ requis");
			addInput(tf_cp, true, "", "Champ requis");
			addInput(tf_city, true, "", "Champ requis");
			
			btnValid = btn_valid;
			setTfFeedback(tf_feedback);
			setMcLoading(mc_loading);
			
			tformat.font = "Arial";
			setFontColors(0x000000, 0xff0000);
			
			addEventListener("SUBMIT", onSubmit);
			addEventListener("CHECKED", onChecked);
			addEventListener("ERROR", onError);
			
			//this.debug = true;
			empty();
			enable();
		}
		
		
		//_______________________________________________________________
		//events handlers
		
		private function onSubmit(e:Event)
		{
			trace("onSubmit");
		}
		
		private function onChecked(e:Event)
		{
			if(true) this.setFeedback("...", 0xff0000);
			trace("onChecked");
			var phpm:PHPManager = new PHPManager();
			phpm.varsIn.varyo = "blabla";
			phpm.exec(FILE_PHP);
			phpm.addEventListener(Event.COMPLETE, onPhpComplete);
			this.startValidation();
		}
		
		private function onError(e:Event)
		{
			trace("onError");
		}
		
		private function onPhpComplete(e:Event)
		{
			var varsout:Object = e.target.varsOut;
			var codeMsg:String = varsout.codeMsg;
			trace("onPhpComplete, codeMsg : "+codeMsg);
			this.stopValidation();
			
		}
	}
}
*/