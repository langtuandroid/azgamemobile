package view.window.shop 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import model.MainData;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ImageItem extends MovieClip 
	{
		private var loader:Loader;
		private var _linkAvatar:String;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		
		private var textField:TextField;
		private var _type:String = "";
		public function ImageItem(type:String = "") 
		{
			super();
			
			_type = type;
		}
		
		public function addImg(linkAvatar:String):void 
		{
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.allowCodeImport = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			
			context.securityDomain = SecurityDomain.currentDomain;
			
			
			if (MainData.getInstance().isFacebookVersion) 
			{
				Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
				Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
				Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
				Security.loadPolicyFile("https://profile.ak.fbcdn.net/crossdomain.xml");
				Security.loadPolicyFile('http://profile.cc.fbcdn.net/crossdomain.xml');
				Security.loadPolicyFile('https://profile.cc.fbcdn.net/crossdomain.xml');
				Security.loadPolicyFile('http://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
				Security.loadPolicyFile('https://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
				Security.loadPolicyFile('http://fbcdn-sphotos-a.akamaihd.net/crossdomain.xml');
				Security.loadPolicyFile('https://fbcdn-sphotos-a.akamaihd.net/crossdomain.xml');
				Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			}
			
		
			//Security.loadPolicyFile('http://api.facebook.com/crossdomain.xml');
			
			/*Security.allowDomain('http://profile.ak.fbcdn.net');
			Security.allowInsecureDomain('http://profile.ak.fbcdn.net');*/
			
			{
				if (_bitmapData) 
				{
					_bitmapData.dispose();
				}
				if (_bitmap) 
				{
					removeChild(_bitmap);
					_bitmap = null;
				}
				
				if (loader)
				{
					if (contains(loader))
						removeChild(loader);
				}
				
				if (linkAvatar) 
				{
						loader = new Loader();
					var urlRequest:URLRequest = new URLRequest(linkAvatar);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.load(urlRequest);
				}
			}
			
			_linkAvatar = linkAvatar;
			
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("sai link avatar")
		}
		
		public function removeImage():void 
		{
			if (_bitmap) 
			{
				_bitmapData.dispose();
				
				removeChild(_bitmap);
				_bitmap = null;
			}
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			
			if (_bitmap) 
			{
				_bitmapData.dispose();
				
				removeChild(_bitmap);
				_bitmap = null;
			}
			
			if (loader.content) 
			{
				_bitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0x123456);
				_bitmapData.draw(loader);
				_bitmap = new Bitmap(_bitmapData);
				addChild(_bitmap);
				
				
				_bitmap.smoothing = true;
				
				if (_type == "avatar") 
				{
					_bitmap.width = 100;
					_bitmap.height = 100;
					_bitmap.x = (100 - _bitmap.width) / 2;
					_bitmap.y = (100 - _bitmap.height) / 2;
				}
				else 
				{
					_bitmap.x = (65 - _bitmap.width) / 2;
					_bitmap.y = (65 - _bitmap.height) / 2;
				}
				
				
				//_bitmap.alpha = .3;
			}
			
			
			
			//Bitmap(loader.content).smoothing = true;
		}
	}

}