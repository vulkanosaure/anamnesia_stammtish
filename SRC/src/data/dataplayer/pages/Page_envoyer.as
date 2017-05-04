package data.dataplayer.pages {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	import flash.text.Font;
	import data.dataplayer.pages.Page;
	import data.net.PHPManager;
	import data.utils.StringOperation;
	
	
	public class Page_envoyer extends Page{
		
		//params
		public var id:String = "envoyer";
		public var phpdir;
		public var captureurl:String;
		public var urlplayercomplete:String;
		
		//private vars
		var _urlplayer:String;
		var _urlcredits:String;
		var _pagetitle:String;
		
		var erase_tf:Array;
		var tab_tf:Array;
		var tab_tf_content:Array;
		var tab_error_msg:Array;
		var tab_mandatory:Array;
		var msg_invalid_email:String;
		var nb_tf:int;
		var phpm:PHPManager;
		var mcParent:MovieClip;
		var tft1:TextFormat;
		var tft2:TextFormat;
		var color_input:int = 0xaaaaaa;
		var color_error:int = 0xff0000;
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Page_envoyer(_stage:Stage) 
		{ 
			btn_fermer.addEventListener(MouseEvent.CLICK, onClose);
			btn_envoyer.addEventListener(MouseEvent.CLICK, onSend);
			btn_fermer.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_fermer.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			btn_envoyer.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_envoyer.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeydown);
			btn_fermer.buttonMode = true;
			btn_envoyer.buttonMode = true;
			
			
			
			mcParent = this.parent as MovieClip;
			nb_tf = 5;
			erase_tf = new Array(nb_tf);
			tab_tf = new Array(nb_tf);
			tab_tf_content = new Array(nb_tf);
			tab_error_msg = new Array(nb_tf);
			tab_mandatory = new Array(nb_tf);
			tab_tf[0] = input_votrenom;
			tab_tf[1] = input_votreemail;
			tab_tf[2] = input_sonnom;
			tab_tf[3] = input_sonemail;
			tab_tf[4] = input_message;
			
			tab_mandatory[0] = true;
			tab_mandatory[1] = true;
			tab_mandatory[2] = true;
			tab_mandatory[3] = true;
			tab_mandatory[4] = false;
			
			tab_tf_content[0] = "votre texte ici.........................";
			tab_tf_content[1] = "votre texte ici...................................";
			tab_tf_content[2] = "votre texte ici...........................";
			tab_tf_content[3] = "votre texte ici....................................";
			tab_tf_content[4] = "votre texte ici..........................................................";
			
			tab_tf[0].multiline = false;
			tab_tf[1].multiline = false;
			tab_tf[2].multiline = false;
			tab_tf[3].multiline = false;
			
			
			tab_error_msg[0] = "VOTRE NOM";
			tab_error_msg[1] = "VOTRE ADRESSE EMAIL";
			tab_error_msg[2] = "SON NOM";
			tab_error_msg[3] = "SON ADRESSE EMAIL";
			tab_error_msg[4] = "";
			msg_invalid_email = "L'EMAIL N'EST PAS VALIDE";
			
			tft1 = new TextFormat();
			tft2 = new TextFormat();
			
			tft1.font = "Arial";
			//tf_feedback.embedFonts = true;
			tft2.italic = true;
			tft2.font = "Arial";
			
			for(var i:int=0;i<nb_tf;i++){
				tab_tf[i].tabIndex = i+1+200;
				tab_tf[i].addEventListener(FocusEvent.FOCUS_IN, onTFfocus);
				tab_tf[i].addEventListener(FocusEvent.FOCUS_IN, dispatchFocus);
				tab_tf[i].addEventListener(Event.CHANGE, onChange);
				//tab_tf[i].embedFonts = true;
			}
			reset();
			
		}
		
		
		public function set urlplayer(str:String):void
		{
			_urlplayer = str;
		}
		public function set urlcredits(str:String):void
		{
			_urlcredits = str;
		}
		public function set pagetitle(str:String):void
		{
			_pagetitle = str;
		}
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		private function checkForm():Boolean
		{
			var bok:Boolean = true;
			
			//inputs
			for(var i:int=0;i<nb_tf;i++){
				if(tab_mandatory[i] && !isFieldOK(i)){
					tab_tf[i].text = tab_error_msg[i];
					tab_tf[i].textColor = color_error;
					erase_tf[i] = true;
					bok = false;
				}
				else if(!tab_mandatory[i] && !isFieldOK(i)){
					erase_tf[i] = false;
					tab_tf[i].text = "";
				}
			}
			
			//adresses emails
			for(i=1;i<4;i+=2){
				if(isFieldOK(i) && tab_mandatory[i] && !StringOperation.checkEmailValidity(tab_tf[i].text)){
					tab_tf[i].text = msg_invalid_email;
					tab_tf[i].textColor = color_error;
					erase_tf[i] = true;
					bok = false;
				}
			}
			
			//return true;
			return bok;
		}
		
		private function reset()
		{
			for(var i:int=0;i<nb_tf;i++){
				erase_tf[i] = true;
				tab_tf[i].text = tab_tf_content[i];
				tab_tf[i].textColor = color_input;
				tab_tf[i].setTextFormat(tft2);
			}
			tf_feedback.text = "";
			tf_feedback.mouseEnabled = false;
		}
		
		private function sendForm()
		{
			trace("sendForm");
			phpm = new PHPManager();
			
			
			//config varsIn
			if(captureurl==null) captureurl = "dataplayer-imgs/capture.jpg";
			phpm.varsIn.url_player = _urlplayer;
			phpm.varsIn.urlplayercomplete = urlplayercomplete;
			phpm.varsIn.url_credits = _urlcredits;
			phpm.varsIn.page_title = _pagetitle;
			phpm.varsIn.captureurl = captureurl;
			
			trace("urlplayercomplete : "+urlplayercomplete);
			trace("_urlplayer : "+_urlplayer);
			trace("_pagetitle : "+_pagetitle);
			trace("captureurl : "+captureurl);
			trace("_urlcredits : "+_urlcredits);
			
			//form varsIn
			phpm.varsIn.sender_name = tab_tf[0].text;
			phpm.varsIn.sender_email = tab_tf[1].text;
			phpm.varsIn.dest_name = tab_tf[2].text;
			phpm.varsIn.dest_email = tab_tf[3].text;
			phpm.varsIn.message = tab_tf[4].text;
			phpm.varsIn.urlplayercomplete = urlplayercomplete;
			
			trace("sender_name : "+phpm.varsIn.sender_name);
			trace("email : "+phpm.varsIn.sender_email);
			trace("dest_name : "+phpm.varsIn.dest_name);
			trace("dest_email : "+phpm.varsIn.dest_email);
			trace("message : "+phpm.varsIn.message);
			
			//...
			trace("phpdir : "+phpdir);
			phpm.exec(_urlplayer+phpdir+"send.php");
			phpm.addEventListener(Event.COMPLETE, onSendComplete);
			phpm.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onClose(e:MouseEvent)
		{
			dispatchEvent(new Event("CLOSE"));
			reset();
		}
		private function onSend(e:MouseEvent)
		{
			trace("Page_envoyer::onSend");
			tf_feedback.text = "";
			stage.focus = null;
			if(checkForm()) sendForm();
		}
		
		private function onRollover(e:MouseEvent)
		{
			e.currentTarget.play();
		}
		private function onRollout(e:MouseEvent)
		{
			e.currentTarget.playbackTo(1);
		}
		private function onkeydown(e:KeyboardEvent)
		{
			if(e.keyCode==Keyboard.ENTER && this.visible==true){
				trace("ENTER page_envoyer");
				var tf = stage.focus as TextField;
				if(tf!=null && !tf.multiline) onSend(new MouseEvent(""));
			}
		}
		
		private function isFieldOK(ind:int):Boolean
		{
			if(erase_tf[ind] || tab_tf[ind].text=="") return false;
			return true;
		}
		
		
		
		
		private function onTFfocus(e:FocusEvent)
		{
			var index:int = e.currentTarget.tabIndex-1;
			if(erase_tf[index]){
			    e.currentTarget.text = "";
				erase_tf[index] = false;
				e.currentTarget.textColor = color_input;
			}
		
		}
		
		private function dispatchFocus(e:FocusEvent)
		{
			dispatchEvent(new Event("FOCUS_INPUT"));
		}
		
		private function onChange(e:Event)
		{
			e.target.setTextFormat(tft2);
		}
		
		private function onSendComplete(e:Event)
		{
			trace("onSendComplete");
			trace("phpm.varsOut.variable : "+phpm.varsOut.variable);
			if(phpm.varsOut.variable==1){
				reset();
				tf_feedback.text = "Votre message à bien été envoyé.";
				tft1.color = 0xffffff;
			}
			else{
				tf_feedback.text = "Erreur lors de l'envoi";
				tft1.color = 0xff0000;
			}
			tf_feedback.setTextFormat(tft1);
		}
		
		private function onError(e:IOErrorEvent)
		{
			trace("onError");
		}
	}
	
}