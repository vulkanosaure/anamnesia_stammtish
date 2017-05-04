package data.dataplayer.pages {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.text.TextFormat;
	import data.dataplayer.pages.Page;
	
	public class Page_embarquer extends Page {
		
		//params
		public var id:String = "embarquer";
		var _urlplayer:String;
		var _urlvideo:String;
		
		public var videoWidth:Number;
		public var videoHeight:Number;
		
		
		//private vars
		var tft:TextFormat;
		
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function Page_embarquer() 
		{ 
			btn_fermer.addEventListener(MouseEvent.CLICK, onClose);
			btn_copier.addEventListener(MouseEvent.CLICK, onCopy);
			
			btn_fermer.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_fermer.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			btn_copier.addEventListener(MouseEvent.ROLL_OVER, onRollover);
			btn_copier.addEventListener(MouseEvent.ROLL_OUT, onRollout);
			
			btn_fermer.buttonMode = true;
			btn_copier.buttonMode = true;
			
			
			//todo : ne doit pas se faire ds le constructeur -> on a pas encore les dimensions
			
		}
		
		public function set urlplayer(str:String):void
		{
			_urlplayer = str;
		}
		
		public function set urlvideo(str:String):void
		{
			_urlvideo = str;
		}
		
		public function init()
		{
			var w, h:Number; 
			var __urlvideo:String = ((_urlvideo.substr(0, 7)=="http://") ? "" : _urlplayer) + _urlvideo;
			w = 400;
			h = Math.round(w * videoHeight / videoWidth);
			
			var _str:String = "";
			_str += "<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=$FV,$JR,$NR,0' width='" + w + "' height='" + h + "' id='dataplayer' align=''>";
			_str += "<param name='allowScriptAccess' value='sameDomain' />";
			_str += "<param name='allowFullScreen' value='false' />";
			_str += "<param name='movie' value='" + _urlplayer + "dataplayer.swf' />";
			_str += "<param name='wmode' value='opaque' />";
			_str += "<param name='allowFullScreen' value='true' />";
			_str += "<param name='FlashVars' value='embarquer=1&amp;url_player=" + _urlplayer + "&video=" + __urlvideo + "' />";
			_str += "<embed src='" + _urlplayer + "dataplayer.swf' width='" + w + "' height='" + h + "' name='dataplayer' wmode='opaque' align='' allowScriptAccess='sameDomain' FlashVars='embarquer=1&amp;url_player=" + _urlplayer + "&video=" + __urlvideo + "' allowFullScreen='true' type='application/x-shockwave-flash' pluginspage='http://www.adobe.com/go/getflashplayer_fr' />";
			_str += "</object>";
			
			
			tf_link.text = _str;
		
			
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
			e.currentTarget.play();
		}
		private function onRollout(e:MouseEvent)
		{
			e.currentTarget.playbackTo(1);
		}
	}
	
}