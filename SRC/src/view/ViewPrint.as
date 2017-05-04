package view 
{
	import assets.Component_print_item;
	import data.display.FilledRectangle;
	import data2.fx.delay.DelayManager;
	import data2.mvc.ViewBase;
	import data2.net.imageloader.ImageLoader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintUIOptions;
	/**
	 * ...
	 * @author ...
	 */
	public class ViewPrint extends ViewBase
	{
		private static const MAX_ITEM:int = 6;
		private static var _items:Array;
		
		public function ViewPrint() 
		{
			
		}
		
		
		public static function print(_list:Array):void
		{
			
			var _contentlist:Sprite = getSprite("content_mail_list");
			
			if (_items != null) {
				var _len:int = _items.length;
				for (var j:int = 0; j < _len; j++) 
				{
					var _item:Component_print_item = Component_print_item(_items[j]);
					_item.reset();
					if (_contentlist.contains(_item)) _contentlist.removeChild(_item);
				}
			}
			
			_items = new Array();
			
			var _dobj:Sprite = getSprite("content_mail");
			trace("list printers : " + PrintJob.printers);
			
			var _subdobj:Sprite = getSprite("content_mail_sub");
			//_subdobj.scaleX = _subdobj.scaleY = 0.95;
			_subdobj.scaleX = _subdobj.scaleY = 595 / 1576 * 0.95;
			
			//2,6487394957983193277310924369748
			
			trace("_list : " + _list);
			
			var _len:int = _list.length;
			if (_len > MAX_ITEM) _len = MAX_ITEM;
			
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _data:Object = _list[i];
				var _item:Component_print_item = new Component_print_item();
				_item.initComponent();
				
				_contentlist.addChild(_item);
				_item.y = i * 196;
				
				
				var _url:String = String(_data["img_thumb"]);
				if (_url != "" && _url != "http://otkochersberg.izhak2.client.openagilex.net/") {
					_item.urlimg = _url;
					_item.updateComponent();
				}
				
				
				_item.setTitle(_data["title"]);
				//_item.setDesc(_data["city"]);
				_item.setDesc("");
				
				if (_data["url"] != "") {
					var _qrCode:Bitmap = ViewMainScreen.generateQRCode(_data["url"]);
					_item.setQRCode(_qrCode);
				}
				
				_items.push(_item);
				
			}
			
			
			ImageLoader.loadGroup();
			
			var _debug:Boolean = false;
			if (_debug) {
				getSprite("content_mail").visible = true;
			}
			else {
				var _showDialog:Boolean = false;
				
				DelayManager.add("", 500, function():void {
					var _uioptions:PrintUIOptions = new PrintUIOptions();
					var _printArea:Rectangle = new Rectangle(0, 0, 1362, 1927);
					
					var _pj:PrintJob = new PrintJob();
					var _options:PrintJobOptions = new PrintJobOptions(true);
					
					_pj.pageWidth
					if (_pj.start2(null, _showDialog)) {
						_pj.addPage(_dobj, _printArea, _options);
						_pj.send();
					}
				});
			}
			/*
			
			*/
			
			//595 / 1362 = 
			
		}
		
		static public function init():void 
		{
			var _subdobj:Sprite = getSprite("content_mail_sub");
			var _filledrect:FilledRectangle = new FilledRectangle(0xFFFFFF);
			_filledrect.width = 1576 + 6;
			_filledrect.height = 2230 + 6 + 100;
			_subdobj.addChildAt(_filledrect, 0);
		}
		
	}

}