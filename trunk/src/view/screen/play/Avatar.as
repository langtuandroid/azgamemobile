package view.screen.play
{
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	import model.GameDataTLMN;
	
	import flash.errors.IOError;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class Avatar extends MovieClip 
	{
		private var mainData:GameDataTLMN = GameDataTLMN.getInstance();
		private var loader:Loader;
		public var avatarBackground:Sprite;
		public var avatarMask:Sprite;
		
		//public var avatarString:String;
		private var content:MovieClip;
		private var check:Boolean = true;
		
		public function Avatar() 
		{
			
			content = new MyAvatar();
			addChild(content);
			
			avatarBackground = content["avatarBackground"];
			avatarMask = content["avatarMask"];
			
			avatarMask.visible = false;
			
			content.click.buttonMode = true;
			content.click.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event("onClick"));
		}
		
		public function setForm(_formName:String):void
		{
			
			//avatarBackground = content["avatarBackground"];
			//avatarMask = content["avatarMask"];
			
			//avatarBackground.mask = avatarMask;
		}
		
		public function addImg(imgSrc:String, logoSrc:String = null, isConvert:Boolean = true):void
		{
			if (loader)
			{
				if (avatarBackground.contains(loader))
					avatarBackground.removeChild(loader);
			}
			
			//avatarString = imgSrc;
			loader = new Loader();
			/*if (isConvert)
			{
				var url:String = mainData.basepath + mainData.init.requestLink.convertImg.@url;
				url += imgSrc;
			}
			else
			{
				url = imgSrc;
			}*/
			
			if (imgSrc == "http://183.91.14.52/gamebai/public/shop/avatar/default_1.png" ||
					imgSrc == "www.daodudu.com/public/shop/avatar/default_1.png" ||
					imgSrc == "www.daodudu.com/public/shop/avatar/default_2.png" ||
					imgSrc == "http://183.91.14.52/gamebai/public/shop/avatar/default_2.png") 
			{
				check = false;
			}
			else 
			{
				check = true;
			}
			
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.allowCodeImport = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			
			//context.securityDomain = SecurityDomain.currentDomain;
			
			Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("http://azgamebai.com/crossdomain.xml");
			
			
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			//Security.loadPolicyFile('http://api.facebook.com/crossdomain.xml');
			
			/*Security.allowDomain('http://profile.ak.fbcdn.net');
			Security.allowInsecureDomain('http://profile.ak.fbcdn.net');*/
			
			var urlRequest:URLRequest = new URLRequest(imgSrc);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(urlRequest, context);
			content.addChild(loader);
			/*if (!logoSrc)
				return;
			if (logoLoader)
			{
				if (contains(logoLoader))
					removeChild(logoLoader);
			}
			
			if (logoSrc)
			{
				logoLoader = new Loader();
				urlRequest = new URLRequest(logoSrc);
				logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadLogoComplete);
				logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				logoLoader.load(urlRequest);
			}*/
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("BBBBBBBBBBBBBBBB")
			dispatchEvent(new Event("loadError"));
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			trace("AAAAAAAAAAAAAAA")
			/*if (loader.content is Bitmap) 
			{
				Bitmap(loader.content).smoothing = true;
			}
			else 
			{
				MovieClip(loader.content).smoothing = true;
			}
			*/
			var formRatio:Number = loader.width / loader.height;
			var loaderRatio:Number = 1;
			var ratio:Number = 0;
			
			if (formRatio > loaderRatio)
			{
				ratio = 100 / int(loader.height);
			}
			else
			{
				ratio = 100 / int(loader.width);	
			}
				
			loader.scaleX = loader.scaleY = ratio;
			
			loader.x = (100 - loader.width) / 2; 
			loader.y = (100 - loader.height) / 2; 
		}
		
		public function removeAvatar():void 
		{
			content.removeChild(loader);
			loader = null;
		}
		
		private function onCompleteStartLoader(e:TimerEvent):void 
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteStartLoader);
			MovieClip(loader.content).play();
		}
		
		/*private function onLoadLogoComplete(e:Event):void
		{
			try 
			{
				if (scaleX > 1)
				{
					logoLoader.width *= 1 / scaleX;
					logoLoader.height *= 1 / scaleX;
				}
				logoLoader.x = avatarMask.width - logoWidth - 3;
				logoLoader.y = avatarMask.height - logoHeight - 3;
				addChild(logoLoader);
				logoLoader.visible = false;
			}
			catch (err:Error)
			{
				
			}
		}*/
		
		private function addForm(index:int):void
		{
			var _formName:String = "form_" + String(index);
			var className:String = "_AvatarForm_" + String(index);
			addContent(className, "playingScreen");//_formName, varName:String, [varName][varName][varName]
		}
		
		private function addContent(className:String, nameClass:String):void
		{
			/*content = MovieClip(LoaderController.getInstance().getClass(className, nameClass));
			addChild(content);*/
			
		}
	}

}