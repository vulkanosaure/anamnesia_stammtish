package ascode 
{
	import com.adobe.serialization.json_custom.JSON2;
	import data2.asxml.ASCode;
	import data2.asxml.Constantes;
	import data2.fx.delay.DelayManager;
	import data2.navigation.Navigation;
	import data2.net.Ajax;
	import events.BroadCaster;
	import flash.events.Event;
	import model.ModelArticle;
	import model.ModelLike;
	import view.ViewEntermail;
	/**
	 * ...
	 * @author Vinc
	 */
	public class ASCodeEntermail extends ASCode
	{
		
		public function ASCodeEntermail() 
		{
			
			
		}
		
		override public function exec():void 
		{
			super.exec();
			ViewEntermail.init(_stage);
			
			BroadCaster.addEventListener("SEND_MAIL_SUCCESS", onSendMailSuccess);
			
			Navigation.addCallback("", "screen_entermail", Navigation.CALLBACK_GOTO, onGotoScreen);
		}
		
		private function onGotoScreen():void 
		{
			ViewEntermail.updateScreen();
		}
		
		private function onSendMailSuccess(e:Event):void 
		{
			var _email:String = ViewEntermail.getEmail();
			trace("ASCodeEntermail.onSendMailSuccess " + _email);
			
			ViewEntermail.displayError("valid");
			
			var _listindexes:Array = ModelLike.getList();
			var _listdata:Array = ModelArticle.getArticleByIndexes(_listindexes);
			trace("_listdata : " + _listdata);
			
			
			sendMail_private(_email);
			
			DelayManager.add("", 1500, function():void
			{
				Navigation.gotoScreen("", "screen_menu");
			});
			
		}
		
		
		public function onClickSendMail():void
		{
			ViewEntermail.validateMail();
		}
		
		
		
		static private function sendMail_private(_email:String):void 
		{
			//send mail
			trace("sendMail_private");
			
			var _list:Array = ModelLike.getList();
			var _listArticles:Array = ModelArticle.getArticleByIndexes(_list);
			var _listArticlesJSON:String = JSON2.encode(_listArticles);
			trace("_listArticlesJSON : \n" + _listArticlesJSON);
			
			var _ajax:Ajax = new Ajax();
			_ajax.addEventListener(Event.COMPLETE, onSendMailComplete);
			_ajax.varsIn.list_emails = _email;
			_ajax.varsIn.list_articles = _listArticlesJSON;
			
			
			_ajax.call(Constantes.get("config.path_server") + "php/send_email.php");
			
		}
		
		static private function onSendMailComplete(e:Event):void 
		{
			trace("onSendMailComplete");
		}
		
		
	}

}