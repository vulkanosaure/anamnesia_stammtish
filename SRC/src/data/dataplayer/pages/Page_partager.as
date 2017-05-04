package data.dataplayer.pages {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import data.dataplayer.pages.Page;
	import data.xtends.MovieClipReverse;
	
	
	public class Page_partager extends Page{
		
		//params
		public var id:String = "partager";
		
		
		//private vars
		var _urlplayer:String;
		public var urlfacebook:String;
		var tft:TextFormat;
		
		var btns_share:Array;
		
		//_______________________________________________________________
		//public functions
		
		public function Page_partager() 
		{ 
			btn_fermer.addEventListener(MouseEvent.CLICK, onClose);
			btn_copier.addEventListener(MouseEvent.CLICK, onCopy);
			btn_fermer.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_fermer.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			btn_copier.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_copier.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			
			btn_fermer.buttonMode = true;
			btn_copier.buttonMode = true;
			
			btns_share = new Array();
		
			btns_share.push(btn_partage1);
			btns_share.push(btn_partage2);
			btns_share.push(btn_partage3);
			btns_share.push(btn_partage4);
			btns_share.push(btn_partage6);
			btns_share.push(btn_partage7);
			
			for(var i:int=0;i<btns_share.length;i++){
				btns_share[i].buttonMode = true;
				btns_share[i].addEventListener(MouseEvent.ROLL_OVER, onRollover);
				btns_share[i].addEventListener(MouseEvent.ROLL_OUT, onRollout);
				btns_share[i].addEventListener(MouseEvent.CLICK, onShare);
				btns_share[i].gotoAndStop(1);
				btns_share[i].id = i;
			}
			
		}
		
		public function set urlplayer(str:String):void
		{
			_urlplayer = str;
			//trace("tf_link.text = "+_urlplayer+"/");
			tf_link.text = _urlplayer;
		}
		
		
		
		public function get urlplayer():String
		{
			return _urlplayer;
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		private function onClose(e:MouseEvent)
		{
			dispatchEvent(new Event("CLOSE"));
		}
		private function onCopy(e:MouseEvent)
		{
			trace("Page_partager::onCopy "+tf_link.text);
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, tf_link.text);
			stage.focus = tf_link;
			tf_link.setSelection(0, tf_link.text.length);
		}
		
		private function onRollover(e:MouseEvent)
		{
			trace("onRollover");
			e.currentTarget.playTo("over");
		}
		private function onRollout(e:MouseEvent)
		{
			trace("onRollout");
			e.currentTarget.playbackTo(1);
		}
		private function onShare(e:MouseEvent)
		{
			if(urlfacebook==null) urlfacebook = _urlplayer;
			var id:int = e.currentTarget.id;
			trace("id : "+id);
			trace("onShare urlfacebook : "+urlfacebook);
			var prefix_url:String;
			if(id==0) prefix_url = "http://www.facebook.com/share.php?u=";
			else if(id==1) prefix_url = "http://www.viadeo.com/shareit/share/?url=";
			else if(id==2) prefix_url = "http://twitter.com/home?status=";
			else if(id==3) prefix_url = "https://secure.delicious.com/login?noui=yes&v=5&jump=";
			else if(id==4) prefix_url = "http://blogmarks.net/my/new.php?mini=1&simple=1&url=";
			else if(id==5) prefix_url = "http://www.myspace.com/Modules/PostTo/Pages/?u=";
			
			navigateToURL(new URLRequest(prefix_url+urlfacebook), "_blank");
		}
	}
	
}