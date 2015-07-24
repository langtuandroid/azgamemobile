package chat
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.MainData;
	
	import org.bytearray.tools.SmileyRenderer;
	
	import chat.view.chatRow.ChatAllRowLobby;
	import view.ScrollView.ScrollViewYun;
	import view.standardIcon.StandardIcon;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ChatAll extends Sprite 
	{
		
		[Embed(source = '../../init.xml', mimeType="application/octet-stream")]
		private static const MyData:Class;
		
		public static const HAVE_CHAT:String = "haveChat";
		
		private var chatContainerWidth:int;
		private var chatContainerHeight:int;
		private var scrollHeight:int;
		
		private var format:ElementFormat;
		private var fontDescription:FontDescription;
		private var mapper:Dictionary;
		
		private var scroll:Sprite;
		private var scrollChild:Sprite;
		public var inputText:TextField;
		private var chatContainer:Sprite;
		private var chatContainerChild:Sprite;
		private var chatSentenceArray:Array;
		private var regExp:RegExp;
		private var scrollChildMask:Sprite;
		private var form:String;
		private var startX:Number;
		private var startY:Number;
		private var scrollView:ScrollViewYun;
		private var iconScrollView:ScrollViewYun;
		private var isFirstLoad:Boolean = true;
		private var init:XML;
		public var currentText:String;
		private var _maxCharsChat:int = 50;
		
		public var zInputText:TextField;
		public var zChatContainer:Sprite;
		public var zIconTable:Sprite;
		public var zChooseIcon:SimpleButton;
		
		private var _enable:Boolean = true;
		
		private var mainData:MainData = MainData.getInstance();
		
		private var isShowChat:Boolean = true;
		private var tfNormal:TextFormat;
		private var tfChose:TextFormat;
		
		private var content:MovieClip;
		private var max_sq_id:String = '0';
		
		private var urlLoader:URLLoader;
		private var timeOutTimer:Timer;
		
		public function ChatAll() 
		{
			var byteArray:ByteArray = new MyData() as ByteArray;
			init = new XML(byteArray.readUTFBytes(byteArray.length));
			
			content = new ChatAllLobbyMc();
			addChild(content);
			
			
			
			startX = startY = 0;
			tfNormal = new TextFormat();
			tfNormal.color = 0x000000;
			tfChose = new TextFormat();
			tfChose.color = 0x059ADD;
			
			chatContainerWidth = 230;// content["zChatContainer"].width;
			chatContainerHeight = 190;// content["zChatContainer"].height;
			
			scrollView = new ScrollViewYun();
			scrollView.maxList = 30;
			scrollView.isForMobile = !mainData.isShowScroll;
			scrollView.setData(content["zChatContainer"], 5);
			addChild(scrollView);
			
			/*iconScrollView = new ScrollViewYun();
			iconScrollView.isForMobile = false;
			iconScrollView.setData(content["zIconTable"]["iconContainer"]);
			iconScrollView.distance = 8;
			iconScrollView.standardHDistance = 50;
			iconScrollView.columnNumber = 4;
			addChild(content["zIconTable"]);
			content["zIconTable"].addChild(iconScrollView);
			content["zIconTable"].visible = false;
			content["zChooseIcon"].addEventListener(MouseEvent.CLICK, onChooseIconClick);*/
			
			setupContent();
			setupChatContent();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			/*getInfoForChat("http://192.168.0.254:8686/", "60", "bimkute1", 
			"60tour.jpg", 5, "CHAT_ALL", "BACAY", "BaCayPlugin", "ChatAll", "LobbyPlugin", 
			8501, "192.168.0.254", "BACAY_13", "BACAY_14", "BACAY_15");*/
		}
		
		public function startChat():void 
		{
			getListChat();
			if (timeOutTimer) 
			{
				timeOutTimer.stop();
				timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				
				timeOutTimer = null;
			}
			
			timeOutTimer = new Timer(33 * 1000, 1);
			timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			timeOutTimer.start();
		}
		
		private function getListChat():void 
		{
			var basePath:String = '';
			if (mainData.isTest) 
			{
				basePath = "http://wss.test.azgame.us/Service03/";
			}
			else 
			{
				basePath = "http://wss.azgame.us/Service03/";
				//basePath = "http://wss.test.azgame.us/Service03/";
			}
			
			var url:String = basePath + "/OnplayServerChat.asmx/GetListMessages";
			var urlReq:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			
			requestVars.Nk_Nm = mainData.chooseChannelData.myInfo.name;
			requestVars.max_sq_id = max_sq_id;
			requestVars.source_id = 'WEB';
			requestVars.game_id = mainData.game_id;
			
			urlReq.data = requestVars;
			urlReq.method = URLRequestMethod.POST;
			
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, getListChatComplete, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.load(urlReq);
			
			/*if (timeOutTimer) 
			{
				timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				timeOutTimer.stop();
				timeOutTimer = null;
			}
			
			timeOutTimer = new Timer(25 * 1000);
			timeOutTimer.addEventListener(TimerEvent.TIMER, onTimeOut);
			timeOutTimer.start();*/
		}
		
		private function onTimeOut(e:TimerEvent):void 
		{
			clearAll();
			startChat();
		}
		
		private function clearAll():void
		{
			if (timeOutTimer) 
			{
				timeOutTimer.stop();
				timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				
				timeOutTimer = null;
			}
			
			urlLoader.removeEventListener(Event.COMPLETE, getListChatComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
			urlLoader = null;
			
		}
		private function getListChatComplete(e:Event):void 
		{
			var obj:Object = com.adobe.serialization.json.JSON.decode(e.currentTarget.data);
			
			if (obj.TypeMsg == 1) 
			{
				
				max_sq_id = obj.Data[obj.Data.length - 1 ].Sq_Id;
				for (var i:int = 0; i < obj.Data.length; i++) 
				{
					var isMe:Boolean = false;
					if (mainData.chooseChannelData.myInfo.name == obj.Data[i].Nk_Nm) 
					{
						isMe = true;
					}
					addChatSentence(obj.Data[i].Content, obj.Data[i].Nk_Nm, obj.Data[i].Game_Id, isMe);
				}
			}
			
			startChat();
			
		}
		
		
		private function haveUserChat():void 
		{
			var basePath:String = '';
			if (mainData.isTest) 
			{
				basePath = "http://wss.test.azgame.us/Service03/";
			}
			else 
			{
				basePath = "http://wss.azgame.us/Service03/";
				//basePath = "http://wss.test.azgame.us/Service03/";
			}
			
			var url:String = basePath + "/OnplayServerChat.asmx/NewMessage";
			var urlReq:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			
			requestVars.Nk_Nm = mainData.chooseChannelData.myInfo.name;
			requestVars.game_id = mainData.game_id;
			requestVars.message = currentText;
			requestVars.source_id = 'WEB';
			
			urlReq.data = requestVars;
			urlReq.method = URLRequestMethod.POST;
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.load(urlReq);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace('ko gui len dc')
		}
		
		private function loaderCompleteHandler(e:Event):void 
		{
			
		}
		
		private function onIconClick(e:MouseEvent):void 
		{
			if (inputText.text == "Nhập thông tin để chat...")
				inputText.text = '';
			inputText.appendText(StandardIcon(e.currentTarget).description);
			stage.focus = inputText;
			content["zIconTable"].visible = false;
		}
		
		private function onChooseIconClick(e:MouseEvent):void 
		{
			content["zIconTable"].visible = !content["zIconTable"].visible;
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if (enable)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			}
		}
		
		public function addChatSentence(sentence:String, displayName:String, gameName:String,
			isMe:Boolean = false, 
			isSystemMess:Boolean = false):void
		{
			var chatRow:ChatAllRowLobby = new ChatAllRowLobby();
			chatRow.mapper = mapper;
			chatRow.regExp = regExp;
			chatRow.format = format;
			chatRow.chatContainerWidth = chatContainerWidth;
			chatRow.addContent(sentence, displayName, gameName, isSystemMess, isMe);
			
			scrollView.addRow(chatRow);
			
			//if (isDown)
				//scrollView.updateScroll(true);
			//else
				//scrollView.updateScroll();
				
			if (scrollView.isMoving)
				scrollView.updateScroll();
			else
				scrollView.updateScroll(true);
				
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				if (stage.focus != inputText)
				{
					stage.focus = inputText;
					if (inputText.text == "Nhập thông tin để chat...")
						inputText.text = '';
				}
				else
				{
					currentText = inputText.text;
					if (inputText.text != "" && inputText.text != "Nhập thông tin để chat...")
					{
						
						haveUserChat();
					}
					inputText.text = '';
				}	
			}
		}
		
		private function setupChatContent():void 
		{
			format = new ElementFormat();
			fontDescription = new FontDescription("Tahoma");
			format.fontSize = 12;
			format.fontDescription = fontDescription;
			format.color = 0xffffff;
			
			// dictionary handling class mapping
			mapper = new Dictionary(true);
			
			createEmoticon();
		}
		
		private function createEmoticon():void
		{
			var regString:String = '(';
			
			for (var i:int = 0; i < init.emoticon.child.length(); i++) 
			{
				var face:String = init.emoticon.child[i].@face;
				var className:String = init.emoticon.child[i].@className;
				var reg:String = init.emoticon.child[i].@reg;
				mapper[face] = Class(getDefinitionByName(className));
				if (i == 0)
					regString += reg;
				else
					regString += '|' + reg;
			}
			
			regString += ')';
			
			regExp = new RegExp(regString);
			
			var iconObject:Object = new Object();
			for (i = 0; i < init.emoticon.child.length(); i++) 
			{
				className = init.emoticon.child[i].@className;
				var tempClass:Class;
				tempClass = Class(getDefinitionByName(className));
				var icon:StandardIcon = new StandardIcon();
				icon.description = init.emoticon.child[i].@face;
				icon.addIcon(MovieClip(new tempClass()));
				if (!iconObject[className] && className != "ThreeDot")
				{
					iconObject[className] = icon;
					iconScrollView.addRow(icon);
					icon.buttonMode = true;
					icon.addEventListener(MouseEvent.CLICK, onIconClick);
				}
			}
		}
		
		private function setupContent():void 
		{
			inputText = content["zInputText"];
			inputText.text = "Nhập thông tin để chat...";
			inputText.maxChars = maxCharsChat;
			
			TextField(content['chatTxt']).defaultTextFormat = tfChose;
			TextField(content['messTxt']).defaultTextFormat = tfNormal;
			
			TextField(content['chatTxt']).text = 'Phòng chat';
			TextField(content['messTxt']).text = 'Tin nhắn';
			
			
			content['up_downMc'].gotoAndStop(1);
			content['up_downMc'].buttonMode = true;
			
			content['up_downMc'].addEventListener(MouseEvent.CLICK, onHideChat);
			content['chatBtn'].addEventListener(MouseEvent.CLICK, onChoseChat);
			//content['messBtn'].addEventListener(MouseEvent.CLICK, onChoseMess);
			content['sendBtn'].addEventListener(MouseEvent.CLICK, onSendMess);
			
			
		}
		
		private function onSendMess(e:MouseEvent):void 
		{
			currentText = inputText.text;
			if (inputText.text != "" && inputText.text != "Nhập thông tin để chat...")
			{
				haveUserChat();
			}
			inputText.text = '';
		}
		
		private function onChoseMess(e:MouseEvent):void 
		{
			TextField(content['chatTxt']).defaultTextFormat = tfNormal;
			TextField(content['messTxt']).defaultTextFormat = tfChose;
			
			TextField(content['chatTxt']).text = 'Phòng chat';
			TextField(content['messTxt']).text = 'Tin nhắn';
		}
		
		private function onChoseChat(e:MouseEvent):void 
		{
			TextField(content['chatTxt']).defaultTextFormat = tfChose;
			TextField(content['messTxt']).defaultTextFormat = tfNormal;
			
			TextField(content['chatTxt']).text = 'Phòng chat';
			TextField(content['messTxt']).text = 'Tin nhắn';
		}
		
		private function onHideChat(e:MouseEvent):void 
		{
			if (isShowChat) 
			{
				isShowChat = false;
				
				TweenMax.to(this, .2, { y:230 } );
				content['up_downMc'].gotoAndStop(2);
			}
			else 
			{
				isShowChat = true;
				content['up_downMc'].gotoAndStop(1);
				TweenMax.to(this, .2, { y:0 } );
			}
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			if (stage.focus != inputText)
			{
				if (inputText.text == '')
					inputText.text = "Nhập thông tin để chat...";
			}
			else
			{
				if (inputText.text == "Nhập thông tin để chat...")
					inputText.text = '';
			}
		}
		
		public function removeAllChat():void
		{
			scrollView.removeAll();
		}
		
		public function get maxCharsChat():int 
		{
			return _maxCharsChat;
		}
		
		public function set maxCharsChat(value:int):void 
		{
			_maxCharsChat = value;
			inputText.maxChars = value;
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (!enable && stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			}
		}
	}

}