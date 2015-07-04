package chat.view.chatRow 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.bytearray.tools.SmileyRenderer;
	
	/**
	 * ...
	 * @author 
	 */
	public class ChatAllRowGame extends ChatAllGameRowMc 
	{
		private var fontDescription:FontDescription;
		public var mapper:Dictionary;
		public var regExp:RegExp;
		public var chatContainerWidth:int;
		public var format:ElementFormat;
		private var lineNumber:int;
		private var lineHeight:Number = 16;
		
		private var content:MovieClip;
		private var loader:Loader;
		public function ChatAllRowGame() 
		{
			avatarContainer.mask = avatarContainer.maskAvatar;
		}
		
		public function addContent(sentence:String, displayName:String, gameName:String, avatar:String, isSystemMess:Boolean = false, isMe:Boolean = false):void
		{
			//trace("game name: ", gameName)
			if (gameName == "TLMN") 
			{
				gameNameMc.gotoAndStop(1);
			}
			else if (gameName == "PHOM") 
			{
				gameNameMc.gotoAndStop(2);
			}
			else if (gameName == "BINH") 
			{
				gameNameMc.gotoAndStop(3);
			}
			else if (gameName == "SAM") 
			{
				gameNameMc.gotoAndStop(4);
			}
			else if (gameName == "BACAY") 
			{
				//trace("o chu 3 cay")
				gameNameMc.gotoAndStop(5);
			}
			else 
			{
				gameNameMc.gotoAndStop(1);
			}
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.allowCodeImport = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			
			//context.securityDomain = SecurityDomain.currentDomain;
			
			Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
			
			
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			//Security.loadPolicyFile('http://api.facebook.com/crossdomain.xml');
			
			/*Security.allowDomain('http://profile.ak.fbcdn.net');
		Security.allowInsecureDomain('http://profile.ak.fbcdn.net');*/
			
			//trace("load avatar: ", avatar)
			loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(avatar);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(urlRequest, context);
			
			avatarContainer.addChild(loader);
			
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = new TextFormat("Tahoma", 12);
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.text = displayName + ": ";
			
			if (isSystemMess)
			{
				var tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 12;
				tempFormat.fontDescription = fontDescription;
				tempFormat.color = 0xFFFF00;
				
				format = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				format.fontSize = 12;
				format.fontDescription = fontDescription;
				format.color = 0xFFFF00;
			}
			else
			{
				tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 12;
				tempFormat.fontDescription = fontDescription;
				if (isMe)
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 12;
					format.fontDescription = fontDescription;
					format.color = 0x0099FF;
					tempFormat.color = 0x0099FF;
				}
				else
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 12;
					format.fontDescription = fontDescription;
					format.color = 0xffffff;
					tempFormat.color = 0xffffff;
				}
			}
			
			var nameTextField:SmileyRenderer = new SmileyRenderer(mapper, tempFormat, tempTextField.width);
			nameTextField.lineHeight = lineHeight;
			nameTextField.text = "[" + displayName + "]";
			/*nameTextField.x = 15;
			nameTextField.y = 10;*/
			var distanceString:String = "";
			
			tempTextField.text = '';
			while (nameTextField.width > tempTextField.width)
			{
				distanceString += " ";
				tempTextField.text = distanceString;
			}
			distanceString += "  ";
			
			var smileyText:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 9);
			
			var tempSmiley:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 2);
			tempSmiley.text = "aaaaaaa";
			
			smileyText.lineHeight = lineHeight;
			smileyText.standardHeight = tempSmiley.firstLine.height;
			smileyText.reg = regExp;
			
			smileyText.text = distanceString + sentence;
			if (nameTextField.height < smileyText.firstLine.height)
				smileyText.y = - (smileyText.firstLine.height - nameTextField.height) - 1;
			bgChat.addChild(smileyText);
			bgChat.addChild(nameTextField);
			lineNumber = smileyText.lineNumber;
			//trace("info height: ", smileyText.lineHeight, smileyText.standardHeight, nameTextField.height, nameTextField.lineHeight, bgChat.height)
		}
		
		private function onIOError(e:Event):void 
		{
			//trace("load avatar loi");
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			
			var bm:Bitmap = loader.content as Bitmap;
			var formRatio:Number = 35 / 35;
			var loaderRatio:Number = 0;
			if (loader.content) 
			{
				loaderRatio = loader.content.width / loader.content.height;
			}
			
			var ratio:Number;
			
			if (formRatio < loaderRatio)
			{
				ratio = 35 / int(loader.content.height);
			}
			else
			{
				ratio = 35 / int(loader.content.width);	
			}
			
			
			
			
			
			bm.scaleX = bm.scaleY = ratio;
			bm.smoothing = true;
			bm.x = (35 - loader.width) / 2;
			bm.y = (35 - loader.height) / 2;
			
			avatarContainer.addChild(bm);
		}
		
		public override function get height():Number 
		{
			return lineHeight;//lineNumber * lineHeight;
		}
	}

}