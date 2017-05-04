package ascode 
{
	
	import color.InterfaceColor;
	import data.display.FilledRectangle;
	import data.events.DynEvent;
	import data.fx.transitions.TweenManager;
	import data.net.SWFLoaderEvent;
	import data.utils.Delay;
	import data2.asxml.ASCode;
	import data2.asxml.ASXML;
	import data2.asxml.Constantes;
	import data2.asxml.ObjectSearch;
	import data2.asxml.Sessions;
	import data2.behaviours.Behaviour;
	import data2.display.Image;
	import data2.display.scrollbar.Scrollbar;
	import data2.dynamiclist.DynamicList;
	import data2.fx.delay.DelayManager;
	import data2.InterfaceSprite;
	import data2.math.Math2;
	import data2.navigation.Navigation;
	import data2.navigation.NavigationDef;
	import data2.net.imageloader.ImageLoader;
	import data2.net.URLLoaderManager;
	import data2.text.Text;
	import events.BroadCaster;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import model.translation.Translation;
	import timertouch.TimerTouch;
	import timertouch.TimerTouchEvent;
	import view.ViewCredits;
	import view.ViewGlobal;
	import view.ViewHeader;
	import view.ViewHome;
	import view.ViewTest;
	
	
	
	
	/**
	 * ...
	 * @author 
	 */
	dynamic public class ASCodeMain extends ASCode 
	{
		
		public function ASCodeMain() { } 
		
		
		override public function exec():void 
		{
			trace("ASCodeMain.exec");
			
			if (Constantes.get("config.mouse_visible") == "0") Mouse.hide();
			
			
			
			
			
			//____________________________________________________________________________
			//navigation
			
			
			var _distSlideDown:Number = 300;
			
			Navigation.addScreen("", "screen_home", [
				new NavigationDef("bg_home", NavigationDef.NONE, 0.3, 0, true),
				new NavigationDef("zone_home", NavigationDef.DOWN, 0.2, _distSlideDown, true),
			],
			[
				new NavigationDef("zone_home", NavigationDef.DOWN, 0.1, _distSlideDown, true),
				new NavigationDef("bg_home", NavigationDef.NONE, 0.2, 0, true),
			]);
			
			
			Navigation.addScreen("", "screen_main", [
				
				new NavigationDef("zone_center", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				new NavigationDef("bg_screen_main", NavigationDef.RIGHT, 0.15),
				new NavigationDef("zone_actu", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				
			],
			[
				new NavigationDef("zone_center", NavigationDef.DOWN, 0.1, _distSlideDown, true),
				new NavigationDef("zone_actu", NavigationDef.DOWN, 0.1, _distSlideDown, true),
				new NavigationDef("bg_screen_main", NavigationDef.RIGHT, 0.1),
			]);
			
			
			Navigation.addScreen("", "screen_territoire", [
				
				new NavigationDef("bg_territoire", NavigationDef.NONE, 0.3, 0, true),
				new NavigationDef("territoire_content", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				new NavigationDef("territoire_pagination", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				
			],
			[
				new NavigationDef("territoire_content", NavigationDef.TOP, 0.1, _distSlideDown, true),
				new NavigationDef("territoire_pagination", NavigationDef.TOP, 0.1, _distSlideDown, true),
				new NavigationDef("bg_territoire", NavigationDef.NONE, 0.2, 0, true),
			]);
			
			Navigation.addScreen("", "screen_embassadeur", [
				
				new NavigationDef("bg_embassadeur", NavigationDef.NONE, 0.3, 0, true),
				new NavigationDef("embassadeur_content", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				new NavigationDef("embassadeur_pagination", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				
			],
			[
				new NavigationDef("embassadeur_content", NavigationDef.TOP, 0.1, _distSlideDown, true),
				new NavigationDef("embassadeur_pagination", NavigationDef.TOP, 0.1, _distSlideDown, true),
				new NavigationDef("bg_embassadeur", NavigationDef.NONE, 0.2, 0, true),
			]);
			
			
			
			
			//detail
			_dist = 1100;
			Navigation.addScreen("subscreen_detail", "subscreen_detail", [
				new NavigationDef("subscreen_detail", NavigationDef.RIGHT, 0.2, _dist, false, 0.4),
			],
			[
				new NavigationDef("subscreen_detail", NavigationDef.RIGHT, 0.2, _dist, false, 0.3),
			]);
			Navigation.init("subscreen_detail", "", _stage);
			
			
			
			var _side:String = NavigationDef.LEFT;
			var _time:Number = 0.18;
			var _time2:Number = 0.12;
			var _dist:Number = 400;
			var _fade:Boolean = true;
			Navigation.addScreen("", "screen_menu", [
				
				new NavigationDef("menu_zone_bottom", NavigationDef.DOWN, _time, _dist, _fade),
				new NavigationDef("btn_dormir", NavigationDef.LEFT, _time, _dist, _fade),
				new NavigationDef("btn_restaurer", NavigationDef.DOWN, _time, _dist, _fade),
				new NavigationDef("btn_actualites", NavigationDef.RIGHT, _time, _dist, _fade),
				new NavigationDef("btn_checkout_new", NavigationDef.DOWN, _time, _dist, _fade),
				
				new NavigationDef("btn_escapades", NavigationDef.DOWN, _time, _dist, _fade),
				new NavigationDef("btn_incontournables", NavigationDef.LEFT, _time, _dist, _fade),
			],
			[
				new NavigationDef("btn_incontournables", NavigationDef.LEFT, _time2, _dist, _fade),
				new NavigationDef("btn_escapades", NavigationDef.DOWN, _time2, _dist, _fade),
				
				new NavigationDef("btn_checkout_new", NavigationDef.DOWN, _time, _dist, _fade),
				new NavigationDef("btn_actualites", NavigationDef.RIGHT, _time2, _dist, _fade),
				new NavigationDef("btn_restaurer", NavigationDef.DOWN, _time2, _dist, _fade),
				new NavigationDef("btn_dormir", NavigationDef.LEFT, _time2, _dist, _fade),
				new NavigationDef("menu_zone_bottom", NavigationDef.DOWN, _time2, _dist, _fade),
				
			]);
			
			
			//submenu escapades
			_dist = 300;
			Navigation.addScreen("submenu", "submenu_on", [
				new NavigationDef("btn_esc_nature", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_esc_territoire", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_esc_famille", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
			],
			[
				new NavigationDef("btn_esc_famille", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_esc_territoire", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_esc_nature", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
			]);
			
			Navigation.init("submenu", "", _stage);
			
			
			//submneu checkout
			Navigation.addScreen("submenu2", "submenu2_on", [
				new NavigationDef("btn_checkout_0", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_1", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_2", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_3", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
			],
			[
				new NavigationDef("btn_checkout_3", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_2", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_1", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
				new NavigationDef("btn_checkout_0", NavigationDef.DOWN, 0.1, _dist, true, 0.2),
			]);
			
			Navigation.init("submenu2", "", _stage);
			
			
			
			
			//menu 2
			Navigation.addScreen("", "screen_menu2", [
				
				new NavigationDef("component_menu2_container", NavigationDef.DOWN, 0.25, 400, true),
				new NavigationDef("btn_valid_menu2_container", NavigationDef.DOWN, 0.25, 400, true),
			],
			[
				new NavigationDef("component_menu2_container", NavigationDef.TOP, 0.15, 300, true),
				new NavigationDef("btn_valid_menu2_container", NavigationDef.TOP, 0.15, 300, true),
				
			]);
			
			
			//enter mail
			Navigation.addScreen("", "screen_entermail", [
				
				new NavigationDef("bg_entermail", NavigationDef.NONE, 0.3, 0, true),
				new NavigationDef("zone_input_email", NavigationDef.DOWN, 0, _distSlideDown, true),
				new NavigationDef("btn_send_mail", NavigationDef.DOWN, 0.15, _distSlideDown, true),
				new NavigationDef("virtual_keyboard", NavigationDef.DOWN, 0.15, _distSlideDown, true),
			],
			[
				
				new NavigationDef("zone_input_email", NavigationDef.TOP, 0, _distSlideDown, true),
				new NavigationDef("btn_send_mail", NavigationDef.TOP, 0.15, _distSlideDown, true),
				new NavigationDef("virtual_keyboard", NavigationDef.TOP, 0.15, _distSlideDown, true),
				new NavigationDef("bg_entermail", NavigationDef.NONE, 0.3, 0, true),
			]);
			
			
			//screen credits
			Navigation.addScreen("", "screen_credits", [
				new NavigationDef("bg_credits", NavigationDef.NONE, 0.3, 0, true),
				new NavigationDef("content_credits", NavigationDef.DOWN, 0, _distSlideDown, true),
				
				//...
			],
			[
				//...
				new NavigationDef("content_credits", NavigationDef.DOWN, 0, _distSlideDown, true),
				new NavigationDef("bg_credits", NavigationDef.NONE, 0.3, 0, true),
				
			]);
			
			
			//screen empty
			Navigation.addScreen("", "empty_screen", [], []);
			
			
			Navigation.addItem("footer_close", ["screen_territoire", "screen_embassadeur", "screen_entermail", "screen_credits"], null, 
				new NavigationDef("footer_close", NavigationDef.DOWN, 0.15),
				new NavigationDef("footer_close", NavigationDef.DOWN, 0.1)
			);
			
			
			Navigation.addItem("footer", null, ["screen_home"], 
				new NavigationDef("footer", NavigationDef.DOWN, 0.15),
				new NavigationDef("footer", NavigationDef.DOWN, 0.1)
			);
			Navigation.addItem("btn_menu_container", ["screen_menu2", "screen_main"], null, 
				new NavigationDef("btn_menu_container", NavigationDef.LEFT, 0.15),
				new NavigationDef("btn_menu_container", NavigationDef.LEFT, 0.1)
			);
			
			
			
			
			
			
			Navigation.DEBUG = DataGlobal.DEBUG_MODE || DataGlobal.DEBUG_NAVIGATION;
			Navigation.init("", "screen_home", _stage);
			//Navigation.init("", "screen_menu", _stage);
			
			
			
			Navigation.addClickableConflict("btn_home_fr", "home_btn_langs");
			Navigation.addClickableConflict("btn_home_en", "home_btn_langs");
			Navigation.addClickableConflict("btn_home_de", "home_btn_langs");
			
			
			/*
			Navigation.addClickableConflict("btn_collection");
			Navigation.addClickableConflict("btn_notre_territoire");
			Navigation.addClickableConflict("btn_histoire_coiffe");
			Navigation.addClickableConflict("btn_game_compose");
			Navigation.addClickableConflict("btn_game_coiffe");
			Navigation.addClickableConflict("btn_game_memory");
			Navigation.addClickableConflict("btn_incontournables");
			
			Navigation.addClickableConflict("header_btn_back");
			*/
			
			
			
			
			
			
			//____________________________________________________________________________
			//translation
			
			
			//menu / global
			Translation.add("text_title_home", "home.title", "MS900_72_FFFFFF", "text-align:center;");
			Translation.add("text_subtitle_home", "home.subtitle", "MS500I_22_FFFFFF", "text-align:center;");
			Translation.add("text_header_day", "home.today", "MS500_15_FFFFFF", "text-align:right;");
			
			//screen main
			
			Translation.add("text_title_actu", "rubrics.actualites.title", "MS900_20_FFFFFF", "");
			Translation.add("text_like_btn", "screen_main.btn_like", "MS500_15_FFFFFF", "");
			Translation.add("text_detail_pagination_prev", "screen_main.btn_prev", "MS900_15_FFFFFF", "");
			Translation.add("text_detail_pagination_next", "screen_main.btn_next", "MS900_15_FFFFFF", "");
			
			
			/*
			//territoire
			Translation.add("text_territoire_title", "rubrics.territoire.titlepage", "MS900_30_FFFFFF");
			Translation.add("text_btn_territoire_prev", "global.prev", "MS900_15_FFFFFF", "text-align:right;");
			Translation.add("text_btn_territoire_next", "global.next", "MS900_15_FFFFFF");
			for (var i:int = 0; i < DataGlobal.NB_PAGE_TERRITOIRE; i++) 
			{
				var _idrub:String = "territoire";
				var _id:String = "text_" + _idrub + "_" + i + "_0";
				Translation.addDynamic(_id, "rubrics." + _idrub + ".content.item", "text", _id, "MS300_15_FFFFFF_justify");
				Translation.setDynamicIndex(_id, i * 2 + 0);
				
				var _id:String = "text_" + _idrub + "_" + i + "_1";
				Translation.addDynamic(_id, "rubrics." + _idrub + ".content.item", "text", _id, "MS300_15_FFFFFF_justify");
				Translation.setDynamicIndex(_id, i * 2 + 1);
			}
			
			//embassadeur
			Translation.add("text_embassadeur_title", "rubrics.embassadeurs.titlepage", "MS900_30_FFFFFF");
			Translation.add("text_btn_embassadeur_prev", "global.prev", "MS900_15_FFFFFF", "text-align:right;");
			Translation.add("text_btn_embassadeur_next", "global.next", "MS900_15_FFFFFF");
			for (var i:int = 0; i < DataGlobal.NB_PAGE_EMBASSADEUR; i++) 
			{
				var _idrub:String = "embassadeurs";
				var _id:String = "text_" + _idrub + "_" + i + "_0";
				Translation.addDynamic(_id, "rubrics." + _idrub + ".content.item", "text", _id, "MS300_15_FFFFFF_justify");
				Translation.setDynamicIndex(_id, i * 2 + 0);
				
				var _id:String = "text_" + _idrub + "_" + i + "_1";
				Translation.addDynamic(_id, "rubrics." + _idrub + ".content.item", "text", _id, "MS300_15_FFFFFF_justify");
				Translation.setDynamicIndex(_id, i * 2 + 1);
			}
			*/
			
			
			//global
			Translation.add("text_btn_valid_menu2", "global.btn_menu2", "MS900_20_FFFFFF", "text-align:right;");
			Translation.add("text_btn_menu", "global.btn_menu1", "MS900_20_FFFFFF", "text-align:right;");
			Translation.add("text_like_header", "global.your_selection", "MS500_15_FFFFFF", "");
			
			
			
			//menu
			Translation.add("text_btn_actualites", "rubrics.actualites.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_esc_nature", "rubrics.esc_nature.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_esc_territoire", "rubrics.esc_territoire.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_esc_famille", "rubrics.esc_famille.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_incontournables", "rubrics.incontournables.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_checkout", "rubrics.checkout.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_dormir", "rubrics.dormir.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_restaurer", "rubrics.restaurer.title", "MS900_20_FFFFFF", "text-align:center;");
			
			Translation.add("text_btn_checkout_0", "rubrics.checkout_0.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_checkout_1", "rubrics.checkout_1.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_checkout_2", "rubrics.checkout_2.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_checkout_3", "rubrics.checkout_3.title", "MS900_20_FFFFFF", "text-align:center;");
			Translation.add("text_btn_escapades", "rubrics.esc.title", "MS900_20_FFFFFF", "text-align:center;");
			
			
			//share mail
			Translation.add("text_error_mail", "share_mail.msg_error", "error_mail", "");
			Translation.add("text_error_mail_empty", "share_mail.msg_error_empty", "error_mail", "");
			Translation.add("text_help_mail", "share_mail.input_email_help", "help_mail", "");
			Translation.add("text_conf_mail", "share_mail.popup_desc", "help_mail", "");
			Translation.add("text_btn_goto_mail", "share_mail.btn_send", "MS900_15_FFFFFF", "text-align:right;");
			Translation.add("text_btn_print", "share_mail.btn_print", "MS900_15_FFFFFF", "text-align:right;");
			
			
			//credits
			Translation.add("title_credits", "credits.title", "MS900_30_FFFFFF", "text-align:center;");
			Translation.add("desc_credits", "credits.desc", "MS300_15_FFFFFF", "text-align:center;");
			
			
			
			Translation.translate(DataGlobal.LIST_LANG[0]);
			
			
			var flashVars : Object = LoaderInfo(DataGlobal.container.loaderInfo).parameters;
			DataGlobal.id = String(flashVars.param);
			trace("DataGlobal.id : " + DataGlobal.id);
			
			ViewHome.setBackgroundIndex(DataGlobal.id);
			ViewGlobal.updateData();
			
			ImageLoader.loadGroup("");
			
			
			//Navigation.gotoScreen("", "screen_entermail");
			
		}
		
		
		
		public function func():void
		{
			
		}
		
		
		public function onClickTest():void
		{
			trace("onClickTest");
			ViewTest.test();
		}
		
		
		
		
		
		
	}
	
}