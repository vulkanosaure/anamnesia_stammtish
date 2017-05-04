package data.dataplayer.pages {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import data.dataplayer.pages.Page;
	
	
	public class Page_credit extends Page {
		
		//params
		public var id:String = "credit";
		var _urlcredits:String;
		
		//private vars
		var _urlplayer:String;
		var tft:TextFormat;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Page_credit() 
		{ 
			btn_fermer.addEventListener(MouseEvent.CLICK, onClose);
			logo.addEventListener(MouseEvent.CLICK, onVisit);
			//btn_visiter.addEventListener(MouseEvent.CLICK, onVisit);
			btn_fermer.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_fermer.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			//btn_visiter.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			//btn_visiter.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			btn_fermer.buttonMode = true;
			//btn_visiter.buttonMode = true;
			logo.buttonMode = true;
			
			tft = new TextFormat();
			tft.font = "Arial";
			//tf_credits.embedFonts = true;
		}
		public function set urlplayer(str:String):void
		{
			_urlplayer = str;
		}
		
		public function set urlcredits(str:String):void
		{
			_urlcredits = str;
			trace("tf_credits.text = "+str);
			
			var strcredits:String;
			if(str.substr(0, 7)=="http://") strcredits = str.substr(7, str.length-7);
			else strcredits = str;
			
			tf_credits.text = strcredits;
			tf_credits.setTextFormat(tft);
		}
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onClose(e:MouseEvent)
		{
			dispatchEvent(new Event("CLOSE"));
		}
		private function onVisit(e:MouseEvent)
		{
			navigateToURL(new URLRequest(_urlcredits));
		}
		
		private function onRollover(e:MouseEvent)
		{
			e.currentTarget.play();
		}
		private function onRollout(e:MouseEvent)
		{
			e.currentTarget.playbackTo(1);
		}
	}
	
}