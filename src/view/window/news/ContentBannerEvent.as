package view.window.news 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ContentBannerEvent extends MovieClip 
	{
		private var linkClick:String = "";
		public function ContentBannerEvent() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x123456, 0);
			sp.graphics.drawRect(0, 0, 600, 207);
			sp.graphics.endFill();
			addChild(sp);
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			addEventListener(MouseEvent.MOUSE_UP, onShowLink);
		}
		
		private function onRemoveStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			linkClick = "";
			removeEventListener(MouseEvent.MOUSE_UP, onShowLink);
		}
		
		private function onShowLink(e:MouseEvent):void 
		{
			if (linkClick != "") 
			{
				navigateToURL(new URLRequest(linkClick), "_blank");
			}
		}
		
		public function addInfo(img:String, linkToWeb:String):void 
		{
			linkClick = linkToWeb;
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(img);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(urlRequest);
			addChild(loader);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			
			Bitmap(e.target.content).smoothing = true;
		}
	}

}