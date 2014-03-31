package view.userInfo.avatar 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	import flash.errors.IOError;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class Avatar extends Sprite 
	{
		public static const MY_AVATAR:String = "myAvatar";
		public static const FRIEND_AVATAR:String = "friendAvatar";
		private var form_1:Sprite;
		private var form_2:Sprite;
		private var currentForm:Sprite;
		private var mainData:MainData = MainData.getInstance();
		private var loader:Loader;
		public var logoLoader:Loader;
		public var avatarBackground:Sprite;
		public var avatarMask:Sprite;
		private var formName:String;
		public var playingStatus:Sprite;
		public var avatarString:String;
		private var logoWidth:Number = 12;
		private var logoHeight:Number = 12;
		
		public function Avatar() 
		{
			
		}
		
		public function setForm(_formName:String):void
		{
			formName = _formName;
			switch (formName) 
			{
				case Avatar.MY_AVATAR:
					addForm(1);
				break;
				case Avatar.FRIEND_AVATAR:
					addForm(2);
				break;
			}
			avatarBackground = currentForm["avatarBackground"];
			avatarMask = currentForm["avatarMask"];
			playingStatus = currentForm["playingStatus"];
			if (playingStatus)
				playingStatus.visible = false;
			avatarBackground.mask = avatarMask;
		}
		
		public function addImg(imgSrc:String, logoSrc:String = null, isConvert:Boolean = true, userId:String = ''):void
		{
			if (loader)
			{
				if (avatarBackground.contains(loader))
					avatarBackground.removeChild(loader);
			}
			
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.allowCodeImport = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			
			context.securityDomain = SecurityDomain.currentDomain;
			Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
			
			if (isConvert)
			{
				var url:String = imgSrc;
			}
			else
			{
				url = imgSrc;
			}
			
			try 
			{
				loader = new Loader();
				var urlRequest:URLRequest = new URLRequest(url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.load(urlRequest, context);
				if (form_1)
				{
					if (currentForm["avatarBackground"]["avatarDefault"])
					{
						currentForm["avatarBackground"]["avatarDefault"].visible = false;
					}
				}
			}
			catch (err:Error)
			{
				
			}
			
			if (!logoSrc)
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
			}
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			try 
			{
				var formRatio:Number = avatarMask.width / avatarMask.height;
				var loaderRatio:Number = loader.width / loader.height;
				var ratio:Number;
				Bitmap(loader.content).smoothing = true;
					
				if (formRatio > loaderRatio)
					ratio = avatarMask.width / loader.width;
				else
					ratio = avatarMask.height / loader.height;	
					
				loader.scaleX = loader.scaleY = ratio;
				
				loader.x = (avatarBackground.width - loader.width) / 2; 
				loader.y = (avatarBackground.height - loader.height) / 2;
				
				/*switch (formName) 
				{
					case Avatar.MY_AVATAR:
						width = height = 76;
					break;
				}*/
			
				avatarBackground.addChild(loader);
			}
			catch (err:Error)
			{
				
			}
		}
		
		private function onLoadLogoComplete(e:Event):void
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
			}
			catch (err:Error)
			{
				
			}
		}
		
		private function addForm(index:int):void
		{
			var _formName:String = "form_" + String(index);
			var className:String = "zAvatarForm_" + String(index);
			addContent(_formName, className);
		}
		
		private function addContent(varName:String, className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			this[varName] = Sprite(new tempClass());
			addChild(this[varName]);
			currentForm = this[varName];
		}
	}

}