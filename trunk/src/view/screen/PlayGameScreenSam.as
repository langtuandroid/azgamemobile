package view.screen 
{
	
	
	
	import com.greensock.TweenMax;
	import control.ConstTlmn;
	import flash.text.AntiAliasType;
	import flash.utils.getDefinitionByName;
	import sound.SoundLib;
	import view.Base;
	import view.window.AddMoneyWindow2;
	
	import control.electroServerCommand.ElectroServerCommandTlmn;
	
	import event.DataFieldPhom;
	import flash.display.SimpleButton;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import model.MainData;
	import model.MyData;
	import request.HTTPRequest;
	import view.card.CardTlmn;
	import view.effectLayer.EffectLayer;
	
	import view.ScrollView.ScrollViewYun;
	import view.window.AddMoneyWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.OrderCardWindow;
	import view.window.windowLayer.WindowLayer;
	
	import control.MainCommand;
	import control.ConstTlmn;
	import event.CommandTlmn;
	import event.DataField;
	import event.PlayingScreenEventTlmn;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import logic.CardsTlmn;
	import model.GameDataTLMN;
	
	import model.modelField.ModelFieldTLMN;
	import model.MyDataTLMN;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenActionTlmn;
	import sound.SoundManager;
	
	import view.card.CardDeck;
	import view.clock.Clock;
	
	//import view.window.NoticePopup;
	//import view.screen.play.BigButton;
	import view.screen.play.ContextMenu;
	
	import view.screen.play.MyInfoTLMN;
	import view.screen.play.PlayerInfoTLMN;
	//import view.screen.play.SmallButton;
	import view.window.InvitePlayWindow;
	import view.window.ResultWindowTlmn;
	/**
	 * ...
	 * @author Bim kute
	 */
	public class PlayGameScreenSam extends Base 
	{
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:ElectroServerCommandTlmn = mainCommand.electroServerCommand;
		private var mainData:MainData = MainData.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance(); // windowLayer để mở cửa sổ bất kỳ
		private var _chatBox:ChatBoxPhom;
		//private var _smallButton:SmallButton;
		///private var _bigButton:BigButton;
		private var _myInfo:MyInfoTLMN;
		private var _userInfo:PlayerInfoTLMN;
		
		private var _contextMenu:ContextMenu;
		
		private var haveUserReady:Boolean = false; // vao phong da thay nguoi san sang
		
		
		/**
		 *  userinfo// mang chua 3 playerinfo con lai
		 * userlist: tong so user trong phong
		 */
		private var _arrUserInfo:Array;
		private var _arrUserList:Array;
		private var _isPlaying:Boolean;
		
		private var _cardsName:String;
		private var _containCard:Sprite;//chua cac quan bai danh ra
		private var _containCardSave:Sprite;//chua cac quan bai danh ra
		private var _textfield:TextField;
		
		public var _arrLastCard:Array = []; // nhung quan bai duoc danh ra truoc do
		public var _userLastDisCard:String = ""; // nhung quan bai duoc danh ra truoc do tu user nao
		
		private var _arrCardSave:Array = [];//nhung quan bai giu lai tren ban den luc het round
		
		private var _resultWindow:ResultWindowTlmn;
		private var _invitePlayWindow:InvitePlayWindow;
		
		private var _glowFilter:TextFormat = new TextFormat(); 
		
		private var _emoBoardButt:MovieClip;
		
		private var arrChat:Array = ["Sad_Game", "Nausea_Game", "Laught_Game", "BigLaugh_Game", "Glass_Game", "Heart_Game", 
										"Whistling_Game", "Cry_Game", "Kiss_Game", "Tongue_Game", "Blink_Game", "Agree_Game", 
										"CrashHeart_Game", "Angry_Game", "Waving_Game", "Sleep_Game"];
		/**
		 * tien cuoc
		 * ten phong 	bet:int, nameRoom:int, nameChannel:String = "du du xanh"
		 * ten sanh
		 */
		
		public var canExitGame:Boolean = true;
		private var whiteWin:Boolean = false;
		private var objWhiteWin:Object;
		
		private var _arrCardListOtherUser:Array = [];
		private var containerCardResult:Sprite;
		
		private var timer:Timer;
		private var timerShowResult:Timer;
		private var timerShowResultWhiteWin:Timer;
		private var timerDealcardForme:Timer;
		private var timerShowChatDe:Timer;
		private var heartbeart:Timer;
		private var _timerKickMaster:Timer;
		private var _timerShowSpecial:Timer;
		private var timerShowEmo:Timer;
		private var timerToGetSystemNoticeInfo:Timer;
		
		
		private var _arrCardDiscard:Array = [];
		
		private var isMeJoinRoom:Boolean = false;
		
		private var _numUser:int;
		
		private var _inviteLayer:Sprite;
		
		private var sharedObject:SharedObject;
		
		private var _arrRealUser:Array = [];
		
		private var _haveUserReady:Boolean = false;
		
		private var _countTimerkick:int;
		private var _timerKick:int = 15;
		
		private var _stageGame:int = 0;
		
		private var emoticonButton:SimpleButton;
		private var emoWindow:Sprite;
		private var emoArray:Array;
		
		private var chatBoxLayer:Sprite;
		private var containerEmo1:Sprite;
		private var containerEmo2:Sprite;
		private var containerEmo3:Sprite;
		private var containerEmo4:Sprite;
		
		
		private var _contanierCardOutUser:Sprite;
		private var _arrEmoForUser:Array = [];
		private var _containerSpecial:Sprite;
		
		
		private var confirmExitWindow:ConfirmWindow;
		private var _arrUserSamWarning:Array = [];
		
		private var is3bich:Boolean;
		
		private var dealcard:int = 0;
		private var timerDealCard:Timer;
		private var _timerNoticeWin:Timer;
		private var _count:int;
		private var _timerShowSam:Timer;
		
		private var oldWinner:String = "";
		private var gameLayer:Sprite;
		private var chatLayer:Sprite;
		
		private var _waitToReady:Sprite;
		private var _waitToStart:Sprite;
		
		private var _containerChatEmo:Sprite;
		private var playingLayer:Sprite;
		private var _timerShowEmo:Timer;
		
		private var inSamTime:Boolean = false;
		private var timerHideIpBoard:Timer;
		
		public function PlayGameScreenSam() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			gameLayer = new Sprite();
			addChild(gameLayer);
			chatLayer = new Sprite();
			addChild(chatLayer);
			
			
			_containerChatEmo = new Sprite();
			addChild(_containerChatEmo);
			
			playingLayer = new Sprite();
			addChild(playingLayer);
			
			content = new PlayScreenTlmnMc();
			gameLayer.addChild(content);
			
			content.showTimeNotice.visible = false;
			content.whiteWinSam.visible = false;
			content.samNotice.visible = false;
			
			var background:MovieClip = new zGameBackground();
			content.backGround.addChild(background);
			
			content.noc.gotoAndStop(2);
			
			if (MyDataTLMN.getInstance().isGame == 1) 
			{
				content.typeOfBoard.gotoAndStop(1);
			}
			else if (MyDataTLMN.getInstance().isGame == 2) 
			{
				content.typeOfBoard.gotoAndStop(2);
			}
			
			var addString:String;
			if (int(mainData.channelNum) == 1)
				addString = '1';
			else if (int(mainData.channelNum) == 2 || (int(mainData.channelNum) == 3))
				addString = '2';
				
			var date:Date = new Date();
			
			if (date.getHours() > 18 || date.getHours() < 6) 
			{
				background.gotoAndStop("night" + addString);
			}
			else 
			{
				background.gotoAndStop("day" + addString);
			}
			
			
			////trace("xem the nao: ", SoundManager.getInstance().isSoundOn, SoundManager.getInstance().isMusicOn)
			if (SoundManager.getInstance().isSoundOn) 
			{
				content.settingBoard.onSoundEffect.visible = true;
			}
			else 
			{
				content.settingBoard.onSoundEffect.visible = false;
			}
			
			if (SoundManager.getInstance().isMusicOn) 
			{
				content.settingBoard.onMusic.visible = true;
			}
			else 
			{
				content.settingBoard.onMusic.visible = false;
			}
			//content.backGround.gotoAndStop(2);
			
			
			_glowFilter.color = 0x663311;
			content.timeKickUserTxt.visible = false;
			
			addPlayerInfo();
			addComponent();
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x123456, 1);
			sp.graphics.drawRect(0, 0, 1024, 600);
			sp.graphics.endFill();
			content.addChild(sp);
			mask = sp;
			
			_containCardSave = new Sprite();
			content.addChild(_containCardSave);
			
			_containCard = new Sprite();
			content.addChild(_containCard);
			
			containerCardResult = new Sprite();
			content.addChild(containerCardResult);
			_arrCardListOtherUser = [];
			
			var j:int;
			/*var arrTest:Array = [1, 2, 4, 5, 6, 7, 8, 9 , 10];
			for (j = 0; j < _arrUserInfo.length; j++) 
			{
				addCardImage(arrTest, j);
			}*/
			
			
			
			
			content.dut3bich.visible = false;
			
			GameDataTLMN.getInstance().playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			
			var textfieldVer:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat("Tahoma");
			txtFormat.color = 0xffffff;
			txtFormat.size = 15;
			textfieldVer.defaultTextFormat = txtFormat;
			textfieldVer.antiAliasType = AntiAliasType.ADVANCED;
			textfieldVer.text = mainData.version;
			textfieldVer.x = 840;
			textfieldVer.y = 22;
			textfieldVer.width = 100;
			textfieldVer.mouseEnabled = false;
			content.addChild(textfieldVer);
			
			content.emoBtn.buttonMode = true;
			content.emoBtn.addEventListener(MouseEvent.CLICK, onEmoticonButtonClick);
			
			content.noticeMc.visible = false;
			content.noticeSpecialCard.visible = false;
			
			if (heartbeart) 
			{
				electroServerCommand.pingToServer();
				
				heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
				heartbeart.stop();
			}
			
			heartbeart = new Timer(1000, 30);
			heartbeart.addEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
			
			heartbeart.start();
			
			createEmo();
			
			//addcardTest([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
		}
		
		private function addcardTest(arr:Array):void 
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				var card:CardTlmn = new CardTlmn(arr[i]);
				card.x = _myInfo.x + 245 + 50 * i;
				card.y = _myInfo.y + 30;
				//card.scaleX = card.scaleY = .8;
				containerCardResult.addChild(card);
				_arrCardDiscard.push(card);
			}
			
			_containCard.x = 0;
			_containCard.y = 0;
		}
		
		private function posEmo():void 
		{
			//if (MyDataTLMN.getInstance().isGame == 1) 
			{
				containerEmo1 = new Sprite();
				chatBoxLayer.addChild(containerEmo1);
				containerEmo1.x = 272;
				containerEmo1.y = 466;
				
				containerEmo2 = new Sprite();
				chatBoxLayer.addChild(containerEmo2);
				containerEmo2.x = 934;
				containerEmo2.y = 234;
				
				containerEmo3 = new Sprite();
				chatBoxLayer.addChild(containerEmo3);
				containerEmo3.x = 620;
				containerEmo3.y = 64;
				
				containerEmo4 = new Sprite();
				chatBoxLayer.addChild(containerEmo4);
				containerEmo4.x = 25;
				containerEmo4.y = 235;
				
			}
		}
		
		public function effectOpen():void
		{
			
		}
		
		public function effectClose():void
		{
			removeAllEvent();
		}
		
		private function createEmo():void 
		{
			emoWindow = content.emoWindow;
			emoWindow["closeButton"].addEventListener(MouseEvent.CLICK, onEmoWindowCloseButtonClick);
			emoWindow.parent.removeChild(emoWindow);
			var emoScrollView:ScrollViewYun = new ScrollViewYun();
			emoScrollView.distanceInRow = 6;
			emoScrollView.distanceInColumn = 10;
			emoScrollView.setData(emoWindow["container"]);
			emoWindow.addChild(emoScrollView);
			emoScrollView.columnNumber = 4;
			emoScrollView.removeAll();
			emoArray = new Array();
			for (var i:int = 0; i < 16; i++) 
			{
				var tempClass:Class;
				tempClass = Class(getDefinitionByName("Emo" + String(i+1)));
				var emo:Sprite = Sprite(new tempClass());
				emo.name = "Emo" + String(i + 1);
				emo.scaleX = emo.scaleY = 0.7;
				emo.addEventListener(MouseEvent.MOUSE_UP, onEmoClick);
				emoArray.push(emo);
				emoScrollView.addRow(emo);
			}
			emoScrollView.updateScroll();
			emoScrollView.recheckTopAndBottom();
		}
		
		private function onEmoClick(e:MouseEvent):void 
		{
			if (!stage) 
			{
				return;
			}
			for (var i:int = 0; i < emoArray.length; i++) 
			{
				if (e.currentTarget == emoArray[i])
				{
					electroServerCommand.sendPublicChat(_myInfo._userName, _myInfo._displayName, e.currentTarget.name, true);
					emoWindow.parent.removeChild(emoWindow);
					return;
				}
			}
		}
		
		
		private function onEmoticonButtonClick(e:MouseEvent):void 
		{
			playingLayer.addChild(emoWindow);
		}
		
		
		private function onEmoWindowCloseButtonClick(e:MouseEvent):void 
		{
			emoWindow.parent.removeChild(emoWindow);
		}
		
		
		private function onGetSystemNoticeInfo(e:TimerEvent):void 
		{
			//mainCommand.getInfoCommand.getSystemNoticeInfo();
		}
		
		private function onUpdateSystemNotice(e:Event):void 
		{
			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldPhom.MESSAGE];
				_chatBox.addChatSentence(textField.text, "Thông báo");
			}
			
			content.chatBtn.play();
		}
		
		private function onSendHeartBeat(e:TimerEvent):void 
		{
			if (stage) 
			{
				electroServerCommand.pingToServer();
			}
			
			
			if (heartbeart) 
			{
				heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
				heartbeart.stop();
			}
			
			heartbeart = new Timer(1000, 30);
			heartbeart.addEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
			heartbeart.start();
		}
		
		
		private function onUpdatePlayingScreen(e:PlayingScreenEventTlmn):void 
		{
			var data:Object;
			switch (e.data[ModelFieldTLMN.ACTION_NAME]) 
			{
				case PlayingScreenActionTlmn.JOIN_ROOM: // mình vừa join room
					listenJoinRoom(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_JOIN_ROOM: // có người khác join room
					listenHaveUserJoinRoom(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_OUT_ROOM: // có người khác rời room
					listenHaveUserOutRoom(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.NEXTTURN: // có người bo luot
					listenNextTurn(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.END_ROUND: // mình vừa join room
					listenEndRound(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.START_GAME_SUCCESS: // chủ phòng ấn start
					listenStartGameSuccess(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.READY_SUCCESS: // chủ phòng ấn start
					listenUserReady(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.DEAL_CARD: // chia bài
					listenDealCard(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.GET_FIRST_PLAYER: // nhan ra ai danh dau tien
					getFirstPlayer(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.GET_CURRENT_PLAYER: // nhan ra ai danh tiep theo
					getCurrentPlayer(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_DISCARD: // chia bài
					listenHaveCard(e.data[ModelFieldTLMN.DATA]);
				break;
				break;
				case PlayingScreenActionTlmn.GAME_OVER: // ván kết thúc
					listenGameOver(e.data[ModelFieldTLMN.DATA]);
				break;
				
				case PlayingScreenActionTlmn.UPDATE_ROOM_MASTER: // Cập nhật thay đổi chủ phòng
					listenUpdateRoomMaster(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.ROOM_MASTER_KICK: // Bị chủ phòng kick
					listenRoomMasterKick(e.data[ModelFieldTLMN.DATA]);
				break;
				
				case PlayingScreenActionTlmn.WHITE_WIN: // Thắng trắng
					listenWhiteWin(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.SHOW_WARNNING: // mình vừa join room
					
					onHaveUserShowWarning(e.data[ConstTlmn.DATA]);
				
				break;
				case PlayingScreenActionTlmn.UPDATE_MONEY: // update tiền
					//listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
					listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
				break;
				/*case PlayingScreenActionTlmn.UPDATE_MONEY_USER: // update tiền
					//listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
					listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
				break;*/
				
				case PlayingScreenActionTlmn.UPDATE_MONEY_SPECIAL: // update tiền
					listenUpdateMoney(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_REQUEST_TIME_CLOCK: // có người khác request time clock khi đang chơi
					//listenHaveUserRequestTimeClock(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_RESPOND_TIME_CLOCK: // có người khác respond time clock khi đang chơi
					//listenHaveUserRespondTimeClock(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_REQUEST_IS_COMPARE_GROUP: // có người khác hỏi xem có phải đang đọ chi không
					//listenHaveUserRequestIsCompareGroup(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.HAVE_USER_RESPOND_IS_COMPARE_GROUP: // có người khác trả lời có phải đang đọ chi không
					//listenHaveUserRespondIsCompareGroup(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.ERROR:
					listenErrorDiscard();
				break;
				
			}
		}
		
		private function onHaveUserShowWarning(obj:Object):void 
		{
			var i:int; 
			var oldpos:int = -1;
			var pos:int;
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i]._userName == oldWinner) 
				{
					oldpos = i;
				}
			}
			
			if (obj[ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				if (obj[ConstTlmn.WARNNING] == 1) 
				{
					_myInfo.stopTimer();
					_myInfo.showWinNotice();
					_myInfo.onSamWarning = true;
					_arrUserSamWarning.push(obj[ConstTlmn.PLAYER_NAME]);
				}
				else 
				{
					_myInfo.stopTimer();
					_myInfo.hideWinNotice();
					_myInfo.onSamWarning = false;
				}
				
				_myInfo.stopTimer();
				hideNotice();
				
			}
			else 
			{
				if (obj[ConstTlmn.WARNNING] == 1) 
				{
					for (i = 0; i < _arrUserInfo.length; i++) 
					{
						if (_arrUserInfo[i]._userName == obj[ConstTlmn.PLAYER_NAME]) 
						{
							_arrUserInfo[i].showWinNotice();
							_arrUserInfo[i].stopTimer();
							_arrUserInfo[i].onSamWarning = true;
							_arrUserSamWarning.push(obj[ConstTlmn.PLAYER_NAME]);
							pos = i;
							break;
						}
					}
				}
				else 
				{
					for (i = 0; i < _arrUserInfo.length; i++) 
					{
						if (_arrUserInfo[i]._userName == obj[ConstTlmn.PLAYER_NAME]) 
						{
							trace("thang nay an huy: ", _arrUserInfo[i]._userName , obj[ConstTlmn.PLAYER_NAME])
							_arrUserInfo[i].stopTimer();
							_arrUserInfo[i].onSamWarning = false;
							
							break;
						}
					}
				}
				
			}
			
			
			
			
			trace("check sam: ", obj[ConstTlmn.PLAYER_NAME] , oldWinner, obj[ConstTlmn.WARNNING], _myInfo._userName, content.samNotice.visible)
			if (obj[ConstTlmn.PLAYER_NAME] == oldWinner)
			{
				if (obj[ConstTlmn.WARNNING] == 1 && 
				obj[ConstTlmn.PLAYER_NAME] != _myInfo._userName && content.samNotice.visible) 
				{
					electroServerCommand.noticeSam(false);
				}
				
			}
			else 
			{
				if (obj[ConstTlmn.WARNNING] == 1 && oldWinner != _myInfo._userName &&
				obj[ConstTlmn.PLAYER_NAME] != _myInfo._userName && content.samNotice.visible) 
				{
					electroServerCommand.noticeSam(false);
				}
			}
			
		}
		
		private function listenRoomMasterKick(obj:Object):void 
		{
			var i:int;
			
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				writelog("roomMaster kick --> out room");
				okOut();
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.roomMasterKick);
				windowLayer.openWindow(kickOutWindow);
				kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
				windowLayer.isNoCloseAll = true;
				
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++) 
				{
					if (obj[DataField.USER_NAME] == _arrUserInfo[i]._userName) 
					{
						_arrUserInfo[i].outRoom();
					}
				}
			}
			
			for (i = 0; i < _arrUserList.length; i++) 
			{
				if (_arrUserList[i])
				{
					if ((_arrUserList[i]).userName == obj[DataField.USER_NAME])
						_arrUserList.splice(i, 1);
				}
			}
		}
		
		private function onKickOutWindowCloseComplete(e:Event):void 
		{
			windowLayer.closeAllWindow();
		}
		
		private function listenEndRound(obj:Object):void 
		{
			if (GameDataTLMN.getInstance().finishRound) 
			{
				content.specialCard.visible = false;
				_arrLastCard = [];
				var cardChilds:Array = [];
				_userLastDisCard = "";
				removeAllDisCard();
				removeAllCardSave();
				_myInfo._isPassTurn = false;
				_cardsName = "";
				
				_myInfo.onCompleteNextturn();
				
				for (var j:int = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
				
				content.specialCard.visible = false;
				GameDataTLMN.getInstance().finishRound = false;
			}
		}
		
		private function listenJoinRoom(obj:Object):void 
		{
			addPlayer(obj);
		}
		
		private function listenUpdateMoneyUser(obj:Object):void 
		{
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				MyDataTLMN.getInstance().myMoney[0] = Number(obj[DataField.MONEY]);
				mainData.chooseChannelData.myInfo.money = Number(obj[DataField.MONEY]);
				_myInfo.addMyMoney();
			}
			else 
			{
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					if (obj[DataField.USER_NAME] == _arrUserInfo[i]._userName) 
					{
						_arrUserInfo[i].addMyMoney(Number(obj[DataField.MONEY]));
					}
					
				}
			}
		}
		
		private function listenDealCard(obj:Object):void 
		{
			listenStartGameSuccess(obj);
			
			dealcard = 0;
			content.noc.visible = true;
			oldWinner = obj[DataField.CURRENT_WINNER];
			
			if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId) 
			{
				_myInfo._isMyTurn = true;
			}
			
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			
			var notDeal:Boolean = false;
			if (obj[DataField.PLAYER_CARDS] && obj[DataField.PLAYER_CARDS][0] == obj[DataField.PLAYER_CARDS][1]) 
			{
				notDeal = true;
			}
			
			timerDealCard = new Timer(200, 3);
			//timer.addEventListener(TimerEvent.TIMER, dealingCard);
			timerDealCard.addEventListener(TimerEvent.TIMER, onCompleteDealCard);
			timerDealCard.start();
			
			if (obj[DataField.PLAYER_CARDS]) 
			{
				if (!notDeal) 
				{
					_myInfo._ready = true;
					_myInfo.dealCard(obj[DataField.PLAYER_CARDS]);
				}
				
			}
			else 
			{
				_isPlaying = false;
				canExitGame = true;
				
				_myInfo.hideReady();
			}
			
			timerDealcardForme = new Timer(250, 10);
			timerDealcardForme.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
			timerDealcardForme.start();
			//addUsersInfo(true);
			
		}
		
		private function onCompleteDealcardForMe(e:TimerEvent):void 
		{
			if (timerDealCard) 
			{
				timerDealCard.stop();
				timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
				content.noc.visible = false;
			}
			if (timerDealcardForme) 
			{
				timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
				timerDealcardForme.stop();
			}
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			
			writelog("after deal card complete for me: " + String(whiteWin));
			
			if (whiteWin) 
			{
				showWhiteWin(objWhiteWin);
				whiteWin = false;
			}
			else 
			{
				//checkPosClock();
				var obj:Object = new Object();
				obj[ConstTlmn.TIME_REMAIN] = 15;
				waitNotice(obj);
			}
			
		}
		
		private function waitNotice(obj:Object):void 
		{
			inSamTime = true;
			if (_myInfo._ready || MyDataTLMN.getInstance().myId == GameDataTLMN.getInstance().master) 
			{
				if (_timerNoticeWin) 
				{
					_timerNoticeWin.removeEventListener(TimerEvent.TIMER, onTimerNoticeWin);
					_timerNoticeWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
					_timerNoticeWin.stop();
				}
				
				_count = obj[ConstTlmn.TIME_REMAIN];
				
				_myInfo.showTimerSam(_count);
				
				content.showTimeNotice.visible = true;
				
				_timerNoticeWin = new Timer(1000, obj[ConstTlmn.TIME_REMAIN]);
				_timerNoticeWin.addEventListener(TimerEvent.TIMER, onTimerNoticeWin);
				_timerNoticeWin.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
				_timerNoticeWin.start();
				
				showNotice();
				
			}
			
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i].ready || GameDataTLMN.getInstance().master == _arrUserInfo[i]._userName) 
				{
					_arrUserInfo[i].showTimerSam(obj[ConstTlmn.TIME_REMAIN]);
				}
			}
			
			/*if (_timerBar) 
			{
				_timerBar.stopTimer();
				_timerBar.visible = false;
			}*/
		}
		
		private function hideNotice():void 
		{
			
			content.samNotice.visible = false;
			
			content.samNotice.accessSam.removeEventListener(MouseEvent.CLICK, onClickNoticeWinGame);
			content.samNotice.cancelSam.removeEventListener(MouseEvent.CLICK, onClickCancelWinGame);
		}
		
		private function onClickNoticeWinGame(e:MouseEvent):void 
		{
			if (GameDataTLMN.getInstance().playSound) 
			{
				SoundManager.getInstance().playSound("Click", 1);
			}
			electroServerCommand.noticeSam(true);
		}
		
		private function onClickCancelWinGame(e:MouseEvent):void 
		{
			if (GameDataTLMN.getInstance().playSound) 
			{
				SoundManager.getInstance().playSound("Click", 1);
			}
			electroServerCommand.noticeSam(false);
		}
		
		
		private function showNotice():void 
		{
			content.samNotice.visible = true;
			content.samNotice.accessSam.buttonMode = true;
			
			content.setChildIndex(content.samNotice, content.numChildren - 1);
			
			content.samNotice.accessSam.addEventListener(MouseEvent.CLICK, onClickNoticeWinGame);
			content.samNotice.cancelSam.addEventListener(MouseEvent.CLICK, onClickCancelWinGame);
		}
		
		private function onTimerNoticeWin(e:TimerEvent):void 
		{
			_count--;
			
			if (_count == 1) 
			{
				if (!_myInfo.onSamWarning && _myInfo.content.samResult.visible) 
				{
					electroServerCommand.noticeSam(false);
				}
				
			}
			
			//var str:String = "Còn " + String(_count) + "s để chờ báo sâm";
			//infoStartGame(str, false);
		}
		
		private function onTimerCompleteNoticeWin(e:TimerEvent):void 
		{
			if (_timerNoticeWin) 
			{
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER, onTimerNoticeWin);
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
				_timerNoticeWin.stop();
			}
			content.showTimeNotice.visible = false;
			//infoStartGame("", false);
		}
		
		private function infoStartGame(str:String, boolean:Boolean):void 
		{
			if (content) 
			{
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.size = 26;
				content.noticeForUserTxt.defaultTextFormat = txtFormat;
				content.noticeForUserTxt.x = 122;
				content.noticeForUserTxt.y = 175;
				//trace("sao lai hien dc: ", str)
				
				content.noticeForUserTxt.visible = true;
				content.setChildIndex(content.noticeForUserTxt, content.numChildren - 1);
				
				content.startGame.visible = boolean;
				content.noticeForUserTxt.text = str;
				
				if (boolean) 
				{
					content.startGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
					content.startGame.addEventListener(MouseEvent.CLICK, onClickStartGame);
				}
				else 
				{
					content.startGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
				}
				
			}
			
		}
		
		private function listenUserReady(obj:Object):void 
		{
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_READY);
			}
			
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				_myInfo.myReady();
				
				writelog("user ready");
			}
			else 
			{
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					
					if (_arrUserInfo[i]._userName == obj[DataField.USER_NAME]) 
					{
						_arrUserInfo[i].myReady();
					}
					
				}
			}
			
			if (!_haveUserReady && !haveUserReady) 
			{
				_haveUserReady = true;
				
				_countTimerkick = _timerKick;
				content.timeKickUserTxt.visible = true;
				content.timeKickUserTxt.text = String(_countTimerkick);
				_timerKickMaster = new Timer(1000, _timerKick);
				_timerKickMaster.addEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.addEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.start();
			}
			
			checkShowTextNotice();
		}
		
		private function writelog(str:String):void 
		{
			var httpReq:HTTPRequest = new HTTPRequest();
			var displayname:String = MyDataTLMN.getInstance().myDisplayName;
			var action:String = "web: " + str;
			var method:String = "POST";
			var obj:Object = new Object();
			var writeLink:String = "";
			//trace(action)
			if (mainData.isTest) 
			{
				writeLink = "http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/ClientWriteLog?game_id=AZGB_TLMN&NK_NM="
								+ displayname + "&ACTION_NOTE=" + action;
				//httpReq.sendRequest(method, writeLink, obj, writeSuccess, true);
			}
			else 
			{
				writeLink = "http://wss.azgame.us/Service02/OnplayGamePartnerExt.asmx/ClientWriteLog?game_id=AZGB_TLMN&NK_NM="
								+ displayname + "&ACTION_NOTE=" + action;
				//httpReq.sendRequest(method, writeLink, obj, writeSuccess, true);
				
				
			}
		}
		
		private function writeSuccess(obj:Object):void 
		{
			trace(obj)
		}
		
		private function onTimerKickMaster(e:TimerEvent):void 
		{
			_countTimerkick--;
			content.timeKickUserTxt.text = String(_countTimerkick);
		}
		
		private function onKickMaster(e:TimerEvent):void 
		{
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			_countTimerkick = 0;
			content.timeKickUserTxt.visible = false;
			
			if (GameDataTLMN.getInstance().master == _myInfo._userName && content) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					var rd:int = int(Math.random() * 5);
					if (MyDataTLMN.getInstance().sex) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_BYE_ + String(rd + 1) );
					}
					else 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_BYE_ + String(rd + 1) );
					}
					
				}
				
				_haveUserReady = false;
				_myInfo._userName = "";
				//GameDataTLMN.getInstance()._userName = "";
				writelog("over time 15s --> out room");
				okOut();
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.timerMasterKick);
				windowLayer.openWindow(kickOutWindow);
				kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
				windowLayer.isNoCloseAll = true;
				
				EffectLayer.getInstance().removeAllEffect();
			}
			
		}
		
		private function deleteCard(obj:Object):void 
		{
			
		}
		
		private function listenUpdateRoomMaster(obj:Object):void 
		{
			var i:int;
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			_haveUserReady = false;
			haveUserReady = false;
			
			_countTimerkick = 0;
			content.timeKickUserTxt.visible = false;
			
			
			if (!_isPlaying)
			{
				if (obj[ConstTlmn.MASTER] == MyDataTLMN.getInstance().myId) 
				{
					var check:Boolean = false;
					for (i = 0; i < _arrUserInfo.length; i++) 
					{
						
						if (_arrUserInfo[i].ready) 
						{
							check = true;
							
						}
						
					}
					
					if (check) 
					{
						checkShowTextNotice();
					}
					else 
					{
						checkShowTextNotice();
					}
					
					
					
					_myInfo.changeMaster(true);
				}
				else 
				{
					_myInfo.changeMaster(false);
					if (!_myInfo._ready && obj[ConstTlmn.MASTER] != _myInfo._userName) 
					{
						_myInfo.content.readyBtn.visible = true;
					}
					
					
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						if (_arrUserInfo[i]._userName != "" || _arrUserInfo[i]._userName != " ")
						{
							if (obj[ConstTlmn.MASTER] == _arrUserInfo[i]._userName) 
							{
								_arrUserInfo[i].content.iconMaster.visible = true;
								_arrUserInfo[i].content.confirmReady.visible = false;
								_arrUserInfo[i].ready = false;
							}
							else 
							{
								_arrUserInfo[i].content.iconMaster.visible = false;
							}
						}
					}
				}
				
				var checkKick:Boolean = false;
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					if (_arrUserInfo[i].ready)
					{
						checkKick = true;
					}
				}
				
				if (!checkKick) 
				{
					if (GameDataTLMN.getInstance().master != _myInfo._userName && _myInfo._ready) 
					{
						checkKick = true;
					}
				}
				
				if (!_haveUserReady && checkKick && _numUser > 1) 
				{
					_haveUserReady = true;
					
					_countTimerkick = _timerKick;
					content.timeKickUserTxt.visible = true;
					content.timeKickUserTxt.text = String(_countTimerkick);
					_timerKickMaster = new Timer(1000, _timerKick);
					_timerKickMaster.addEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
					_timerKickMaster.addEventListener(TimerEvent.TIMER, onTimerKickMaster);
					_timerKickMaster.start();
				}
			}
			else 
			{
				if (obj[ConstTlmn.MASTER] == MyDataTLMN.getInstance().myId) 
				{
					
					_myInfo.changeMaster(true);
				}
				else 
				{
					_myInfo.changeMaster(false);
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						if (_arrUserInfo[i]._userName != "" || _arrUserInfo[i]._userName != " ")
						{
							if (obj[ConstTlmn.MASTER] == _arrUserInfo[i]._userName) 
							{
								_arrUserInfo[i].content.iconMaster.visible = true;
								_arrUserInfo[i].content.confirmReady.visible = false;
							}
							else 
							{
								_arrUserInfo[i].content.iconMaster.visible = false;
							}
						}
					}
				}
				
			}
		}
		
		private function listenNextTurn(obj:Object):void 
		{
			var i:int;
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (obj["user"] == _arrUserInfo[i]._userName) 
				{
					_arrUserInfo[i].nextturn();
					break;
				}
			}
			
			if (obj["user"] == MyDataTLMN.getInstance().myId) 
			{
				_myInfo.nextturn();
			}
			
			if (GameDataTLMN.getInstance().finishRound) 
			{
				content.specialCard.visible = false;
				_arrLastCard = [];
				var cardChilds:Array = [];
				_userLastDisCard = "";
				removeAllDisCard();
				removeAllCardSave();
				_myInfo._isPassTurn = false;
				_cardsName = "";
				
				_myInfo.onCompleteNextturn();
				
				for (var j:int = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
				
				content.specialCard.visible = false;
				GameDataTLMN.getInstance().finishRound = false;
			}
			
			checkPosClock();
		}
		
		private function listenErrorDiscard():void 
		{
			_myInfo._isMyTurn = true;
		}
		
		private function listenUpdateMoney(obj:Object):void 
		{
			//trace(obj);
			var i:int;
			var arrPlus:Array = obj["plus"];
			var arrSub:Array = obj["sub"];
			
			if (arrPlus[0] == MyDataTLMN.getInstance().myId) 
			{
				_myInfo.addMoneySpecial(arrPlus[1]);
				//_myInfo.chatde(true);
				
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++) 
				{
					if (_arrUserInfo[i]._userName == arrPlus[0]) 
					{
						_arrUserInfo[i].addMoney(arrPlus[1]);
						//_arrUserInfo[i].chatde(true);
						break;
					}
				}
			}
			
			if (arrSub[0] == _myInfo._userName) 
			{
				_myInfo.addMoneySpecial(arrSub[1]);
				_myInfo.addMoneySpecial(arrSub[1]);
				//_myInfo.chatde(false);
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++) 
				{
					if (_arrUserInfo[i]._userName == arrSub[0]) 
					{
						_arrUserInfo[i].addMoney(arrSub[1]);
						//_arrUserInfo[i].chatde(false);
						break;
					}
				}
			}
			
		}
		
		private function onCompleteShowChatDe(e:TimerEvent):void 
		{
			_myInfo.completeChatde();
			
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].completeChatde();
			}
		}
		
		private function showWhiteWin(obj:Object):void 
		{
			var i:int;
			var j:int;
			var rd:int;
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_WHITEWIN);
			}
			
			hideNotice();
			_stageGame = 2;
			canExitGame = true;
			_haveUserReady = false;
			GameDataTLMN.getInstance().firstGame = false;	
			content.noticeForUserTxt.text = "";
			content.noticeForUserTxt.visible = false;
			
			content.noticeMc.visible = false;
			
			trace("have white win, removeallcard, reset variable");
			_myInfo.killAllTween();
			_myInfo.removeAllCard();
			
			if (timerDealCard) 
			{
				timerDealCard.stop();
				timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
			}
			
			content.noc.visible = false;
			
			if (timerDealcardForme) 
			{
				timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
				timerDealcardForme.stop();
			}
			
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].reset();
				_arrUserInfo[i].killAllTween();
				_arrUserInfo[i].removeAllCards();
			}
			
			
			var card:CardTlmn;
			
			if (obj["winner"] == MyDataTLMN.getInstance().myId) 
			{
				if (MyDataTLMN.getInstance().sex) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrUserInfo[j]._sex) 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + "SAM_" + String(rd + 1) );
						}
						else 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + "SAM_" + String(rd + 1) );
						}
					}
				}
				
			}
			else 
			{
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					
					if (obj["winner"] == _arrUserInfo[j]._userName)
					{
						if (SoundManager.getInstance().isSoundOn) 
						{
							rd = int(Math.random() * 5);
							if (_arrUserInfo[j]._sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + "SAM_" + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + "SAM_" + String(rd + 1) );
							}
						}
						
						break;
					}
				}
			}
			
			for (i = 0; i < obj[ConstTlmn.PLAYER_LIST].length; i++) 
			{
				if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == obj["winner"]) 
				{
					var arrCardWin:Array = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS];
					arrCardWin = arrCardWin.sort(Array.NUMERIC);
					for (j = 0; j < arrCardWin.length; j++) 
					{
						card = new CardTlmn(arrCardWin[j]);
						card.x = 152 + 35 * j;
						card.y = 110;
						card.scaleX = card.scaleY = .8;
						_containCard.addChild(card);
						_arrCardDiscard.push(card);
					}
					
					
				}
				else if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
				{
					for (j = 0; j < obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS].length; j++) 
					{
						card = new CardTlmn(obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS][j]);
						card.x = _myInfo.x + 245 + 50 * j;
						card.y = _myInfo.y + 30;
						//card.scaleX = card.scaleY = .75;
						
						containerCardResult.addChild(card);
						_arrCardListOtherUser.push(card);
					}
				}
				else 
				{
					for (j = 0; j < _arrUserInfo.length; j++) 
					{
						if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == _arrUserInfo[j]._userName) 
						{
							addCardImage(obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS], _arrUserInfo[j]._pos);
						}
					}
				}
			}
			
			
			
			_containCard.x = 180;
			_containCard.y = 155;
			content.specialCard.gotoAndStop(6);
			content.specialCard.visible = true;
			content.setChildIndex(content.specialCard, content.numChildren - 1);
			content.whiteWinSam.gotoAndStop(convertWhiteWin(obj["whiteWinType"]));
			content.whiteWinSam.visible = true;
			
			content.setChildIndex(content.whiteWinSam, content.numChildren - 1);
			
			var result:Number = 0;
			var outGame:Boolean = false;
			var objResult:Object;
			for (i = 0; i < obj[ConstTlmn.PLAYER_LIST].length; i++) 
			{
				if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
				{
					objResult = new Object();
					objResult[ConstTlmn.MONEY] = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.MONEY];
					result = Number(MyDataTLMN.getInstance().myMoney[0]) + Number(objResult[ConstTlmn.MONEY]);
					if (result < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
					{
						outGame = true;
					}
					_myInfo.showEffectGameOver(objResult, outGame);
				}
				else 
				{
					for (j = 0; j < _arrUserInfo.length; j++) 
					{
						if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == _arrUserInfo[j]._userName) 
						{
							objResult = new Object();
							objResult[ConstTlmn.MONEY] = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.MONEY];
							objResult[ConstTlmn.CARDS] = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS];
							_arrUserInfo[j].showEffectGameOver(objResult);
						}
					}
				}
				
			}
			
			if (_resultWindow) 
			{
				
				_resultWindow.setInfoWhiteWin(obj);
				
			}
			
			if (timerShowResultWhiteWin) 
			{
				timerShowResultWhiteWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetGame);
				timerShowResultWhiteWin.stop();
			}
			timerShowResultWhiteWin = new Timer(1000, 10);
			timerShowResultWhiteWin.addEventListener(TimerEvent.TIMER_COMPLETE, onResetGame);
			timerShowResultWhiteWin.start();
		}
		
		private function listenWhiteWin(obj:Object):void 
		{
			whiteWin = true;
			objWhiteWin = obj;
			
			//trace(obj)
			
			//listenGameOver(obj);
		}
		
		private function onResetGame(e:TimerEvent):void 
		{
			_stageGame = 0;
			removeAllDisCard();
			removeAllCardSave();
			content.specialCard.visible = false;
			content.whiteWinSam.visible = false;
			if (_resultWindow) 
			{
				_resultWindow.visible = true;
				content.setChildIndex(_resultWindow, content.numChildren - 1);
				_resultWindow.open(_myInfo._isPlaying);
				_resultWindow.addEventListener("close", onCloseResultWindow);
				_resultWindow.addEventListener("out game", onOutGame);
			}
			checkShowTextNotice();
			if (Number(MyDataTLMN.getInstance().myMoney[0]) < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
			{
				
				GameDataTLMN.getInstance().notEnoughMoney = true;
				
				//okOut();
			}
			
		}
		
		private function convertWhiteWin(type:String):int 
		{
			var result:int;
			switch (type) 
			{
				case "1":
					result = 1;
				break;
				case "2":
					result = 2;
				break;
				case "3":
					result = 3;
				break;
				case "4":
					result = 5;
				break;
				case "5":
					result = 4;
				break;
				default:
				
			}
			
			return result;
		}
		
		private function getFirstPlayer(obj:Object):void 
		{
			
			if (GameDataTLMN.getInstance().firstPlayer == MyDataTLMN.getInstance().myId) 
			{
				
				_myInfo._arrCardFirst = [];
				if (_myInfo._arrCardInt) 
				{
					for (var i:int = 0; i < _myInfo._arrCardInt.length; i++) 
					{
						_myInfo._arrCardFirst.push(_myInfo._arrCardInt[i]);
					}
					_myInfo._arrCardFirst.sort(Array.NUMERIC);
				}
				if (_myInfo) 
				{
					_myInfo._isMyTurn = true;
					
				}
			}
			
			checkPosClock();
		}
		
		private function checkPosClock():void 
		{
			_myInfo.stopTimer();
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].stopTimer();
			}
			content.noticeSpecialCard.visible = false;
			{
				
				trace(GameDataTLMN.getInstance().currentPlayer, MyDataTLMN.getInstance().myId, "thằng nào có đồng hồ chạy", _isPlaying)
				trace(GameDataTLMN.getInstance().firstGame)
				if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
				{
					if (GameDataTLMN.getInstance().firstGame) 
					{
						//content.noticeForUserTxt.text = "Đánh cây hoặc bộ bé nhất!";
						//content.txtNotice.text = "Đánh cây hoặc bộ bé nhất!";
						//content.noticeForUserTxt.visible = true;
						//content.noticeMc.visible = true;
						content.noticeMc.visible = false;
						content.noticeMc.gotoAndPlay(1);
					}
					
					if ((_cardsName == "Đôi 2" || _cardsName == "Hai" || _cardsName == "3 đôi thông" ||
						_cardsName == "4 đôi thông" || _cardsName == "Tứ quí") && _myInfo._isPassTurn)
					{
						//content.noticeSpecialCard.visible = true;
						content.noticeSpecialCard.visible = false;
					}
					else 
					{
						content.noticeSpecialCard.visible = false;
					}
					_myInfo._isPassTurn = false;
					_myInfo.checkPosClock();
					
					if (SoundManager.getInstance().isSoundOn) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_TURN);
						
					}
				}
				else if (_arrUserInfo[0] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[0]._userName && _isPlaying) 
				{
					_arrUserInfo[0].checkPosClock();
					
				}
				else if (_arrUserInfo[1] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[1]._userName && _isPlaying) 
				{
					_arrUserInfo[1].checkPosClock();
					
				}
				else if (_arrUserInfo[2] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[2]._userName && _isPlaying) 
				{
					_arrUserInfo[2].checkPosClock();
					
				}
				
			}
		}
		
		public function onCountTimeFinish():void 
		{
			if (!stage) 
			{
				return;
			}
			if (GameDataTLMN.getInstance().firstPlayer == MyDataTLMN.getInstance().myId) 
			{
				trace("het gio luot dau tien")
				_myInfo._arrCardChoose = [_myInfo._arrCardFirst[0]];
				_myInfo._isMyTurn = false;
				electroServerCommand.myDisCard(_myInfo._arrCardChoose);
				_myInfo._arrCardChoose = [];
				GameDataTLMN.getInstance().firstPlayer = "";
			}
			else 
			{
				_myInfo.nextturn();
				_myInfo._isMyTurn = false;
				onClickNextTurn(null);
			}
			
		}
		
		private function getCurrentPlayer(obj:Object):void 
		{
			if (_timerNoticeWin) 
			{
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER, onTimerNoticeWin);
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
				_timerNoticeWin.stop();
			}
			
			inSamTime = false;
			
			content.showTimeNotice.visible = false;
			hideNotice();
			var i:int;
			var j:int;
			if (_arrUserSamWarning && _arrUserSamWarning.length > 0) 
			{
				for (i = 0; i < _arrUserSamWarning.length; i++) 
				{
					if (_arrUserSamWarning[i] == obj[ConstTlmn.NEXT_TURN]) 
					{
						if (_arrUserSamWarning[i] == MyDataTLMN.getInstance().myId) 
						{
							for (j = 0; j < _arrUserInfo.length; j++) 
							{
								_arrUserInfo[j].hideWinNotice();
							}
						}
						else 
						{
							_myInfo.hideWinNotice();
							for (j = 0; j < _arrUserInfo.length; j++) 
							{
								if (_arrUserInfo[j]._userName != _arrUserSamWarning[i]) 
								{
									_arrUserInfo[j].hideWinNotice();
								}
							}
						}
						break;
						
					}
					
				}
				
			}
			_arrUserSamWarning = [];
			//trace("den luot ai: ", GameDataTLMN.getInstance().currentPlayer , MyDataTLMN.getInstance().myId , _isPlaying)
			if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
			{
				
				if (_myInfo) 
				{
					
					_myInfo._isMyTurn = true;
					//trace("endround den luot minh")
					
				}
				
			}
			else 
			{
				if (_myInfo) 
				{
					_myInfo.showPassTurn();
				}
			}
			checkPosClock();
			
		}
		
		//private var _containerWinLose:Sprite;
		private function listenGameOver(obj:Object):void 
		{
			_isPlaying = false;
			_stageGame = 2;
			_haveUserReady = false;
			GameDataTLMN.getInstance().finishRound = false;
			_cardsName = "";
			
			if (_timerNoticeWin) 
			{
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER, onTimerNoticeWin);
				_timerNoticeWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
				_timerNoticeWin.stop();
			}
			hideNotice();
			
			if (timerDealCard) 
			{
				timerDealCard.stop();
				timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
				content.noc.visible = false;
			}
			if (timerDealcardForme) 
			{
				timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
				timerDealcardForme.stop();
			}
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			
			if (is3bich) 
			{
				content.dut3bich.visible = false;
			}
			
			var str:String;
			
			content.showTimeNotice.visible = false;
			
			var i:int;
			var j:int;
			var rd:int;
			
			canExitGame = true;
			GameDataTLMN.getInstance().firstGame = false;	
			content.noticeForUserTxt.text = "";
			content.noticeForUserTxt.visible = false;
			
			content.noticeMc.visible = false;
			
			timerShowResult = new Timer(3000, 1);
			timerShowResult.addEventListener(TimerEvent.TIMER_COMPLETE, onShowResult);
			timerShowResult.start();
			
			var arrSam:Array = [];
			var arrDenleng:Array = [];
			var sammSuccess:int = 0;
			
			var arrResult:Array = obj["resultArr"];
			for (i = 0; i < arrResult.length; i++) 
			{
				str = arrResult[i]["description"];
				var num:int = int(str.charAt(str.length - 1));
				var numDenlang:String = str.slice(str.length - 2, str.length);
				if (num == 2 || num == 4) 
				{
					if (_timerShowSam) 
					{
						_timerShowSam.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSam);
						_timerShowSam.stop();
						
					}
					arrSam.push([arrResult[i], "Sâm thành công"]);
					sammSuccess = 1;
					
					_timerShowSam = new Timer(1000, 2);
					_timerShowSam.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSam);
					_timerShowSam.start();
				}
				else if (num == 3 || num == 5 || num == 7) 
				{
					if (_timerShowSam) 
					{
						_timerShowSam.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSam);
						_timerShowSam.stop();
						
					}
					arrSam.push([arrResult[i], "Sâm thất bại"]);
					
					sammSuccess = 2;
					
					_timerShowSam = new Timer(1000, 2);
					_timerShowSam.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSam);
					_timerShowSam.start();
				}
				
				if (numDenlang == "10") 
				{
					arrDenleng.push([arrResult[i], "Đền làng"]);
					for (j = 0; j < arrResult.length; j++) 
					{
						if (arrResult[j][ConstTlmn.PLAYER_NAME] != arrResult[i][ConstTlmn.PLAYER_NAME]) 
						{
							arrDenleng.push([arrResult[j], ""]);
						}
						
						
					}
				}
				
			}
			
			
			_myInfo.allButtonVisible();
			
			_myInfo.stopTimer();
			
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].removeAllCards();
				_arrUserInfo[i].stopTimer();
				_arrUserInfo[i].reset();
			}
			_myInfo._cheater = false;
			
			
			var result:Number = Number(String(MyDataTLMN.getInstance().myMoney[0]).replace(",", ""));
			
			var userResult:String;
			var arrResultSam:Array = [];
			
			for (i = 0; i < arrResult.length; i++) 
			{
				
				userResult = arrResult[i][ConstTlmn.PLAYER_NAME];
				
				var outGame:Boolean = false;
				var objResult:Object;
				if (userResult == MyDataTLMN.getInstance().myId) 
				{
					objResult = new Object();
					objResult[ConstTlmn.MONEY] = arrResult[i][ConstTlmn.SUB_MONEY];
					
					result = Number(MyDataTLMN.getInstance().myMoney[0]) + Number(arrResult[i][ConstTlmn.SUB_MONEY]);
					if (result < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
					{
						outGame = true;
					}
					_myInfo.showEffectGameOver(objResult, outGame);
					
					if (arrResult[i][ConstTlmn.SUB_MONEY] > 0) 
					{
						if (SoundManager.getInstance().isSoundOn) 
						{
							rd = int(Math.random() * 5);
							if (MyDataTLMN.getInstance().sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + "SAM_" + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + "SAM_" + String(rd + 1) );
							}
						}
						
					}
				}
				else 
				{
					
					for (j = 0; j < _arrUserInfo.length; j++) 
					{
						
						if (userResult == _arrUserInfo[j]._userName)
						{
							if (arrResult[i][ConstTlmn.SUB_MONEY] > 0) 
							{
								if (SoundManager.getInstance().isSoundOn) 
								{
									rd = int(Math.random() * 5);
									if (_arrUserInfo[j]._sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + "SAM_" + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + "SAM_" + String(rd + 1) );
									}
								}
								
							}
				
							_arrUserInfo[j]._isPlaying = true;
							objResult = new Object();
							
							objResult[ConstTlmn.MONEY] = arrResult[i][ConstTlmn.SUB_MONEY];
							objResult[ConstTlmn.CARDS] = arrResult[i][ConstTlmn.CARDS];
							
							_arrUserInfo[j].showEffectGameOver(objResult);
							
							addCardImage(arrResult[i][ConstTlmn.CARDS], _arrUserInfo[j]._pos);
							break;
						}
					}
				}
				
				arrResultSam.push([userResult, arrResult[i][ConstTlmn.SUB_MONEY]]);
			}
			
			
			if (arrSam.length > 0) 
			{
				if (_resultWindow) 
				{
					
					_resultWindow.samSuccess(arrResult, sammSuccess);
					
				}
				
				if (sammSuccess == 1) 
				{
					for (i = 0; i < arrResultSam.length; i++) 
					{
						if (arrResultSam[i][1] > 0) 
						{
							if (arrResultSam[i][0] == _myInfo._userName) 
							{
								_myInfo.samResult(1);
							}
							else 
							{
								for (j = 0; j < _arrUserInfo.length; j++) 
								{
									if (arrResultSam[i][0] == _arrUserInfo[j]._userName) 
									{
										_arrUserInfo[j].samResult(1);
									}
								}
							}
							break;
						}
					}
				}
				else if (sammSuccess == 2)
				{
					for (i = 0; i < arrResultSam.length; i++) 
					{
						if (arrResultSam[i][1] > 0) 
						{
							if (arrResultSam[i][0] == _myInfo._userName) 
							{
								_myInfo.samResult(4);
							}
							else 
							{
								for (j = 0; j < _arrUserInfo.length; j++) 
								{
									if (arrResultSam[i][0] == _arrUserInfo[j]._userName) 
									{
										_arrUserInfo[j].samResult(4);
									}
								}
							}
						}
						else if (arrResultSam[i][1] < 0) 
						{
							if (arrResultSam[i][0] == _myInfo._userName) 
							{
								_myInfo.samResult(2);
							}
							else 
							{
								for (j = 0; j < _arrUserInfo.length; j++) 
								{
									if (arrResultSam[i][0] == _arrUserInfo[j]._userName) 
									{
										_arrUserInfo[j].samResult(2);
									}
								}
							}
						}
						else if (arrResultSam[i][1] == 0) 
						{
							if (arrResultSam[i][0] == _myInfo._userName) 
							{
								_myInfo.visibleResultGame();
							}
							else 
							{
								for (j = 0; j < _arrUserInfo.length; j++) 
								{
									if (arrResultSam[i][0] == _arrUserInfo[j]._userName) 
									{
										_arrUserInfo[j].visibleResultGame();
									}
								}
							}
						}
					}
				}
				
			}
			else if (arrDenleng.length > 0) 
			{
				for (j = 0; j < arrResult.length; j++) 
				{
					if (arrResult[j][ConstTlmn.PLAYER_NAME] == _myInfo._userName) 
					{
						if (arrResult[j][ConstTlmn.SUB_MONEY] < 0) 
						{
							_myInfo.samResult(5);
							break;
						}
					}
					else 
					{
						for (i = 0; i < _arrUserInfo.length; i++) 
						{
							if (arrResult[j][ConstTlmn.PLAYER_NAME] == _arrUserInfo[i]._userName) 
							{
								if (arrResult[j][ConstTlmn.SUB_MONEY] < 0) 
								{
									_arrUserInfo[i].samResult(5);
									break;
								}
							}
						}
					}
					
				}
					
				if (_resultWindow) 
				{
					
					_resultWindow.denlang(arrDenleng);
					
				}
			}
			else 
			{
				if (_resultWindow) 
				{
					
					_resultWindow.setInfoSam(obj);
					
				}
			}
			
			
			
		}
		
		private function onCompleteShowSam(e:TimerEvent):void 
		{
			_timerShowSam.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSam);
			_timerShowSam.stop();
			
			content.setChildIndex(content.samNotice, content.numChildren - 1);
		}
		
		private function addCardImage(arr:Array, pos:int):void 
		{
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var card:CardTlmn = new CardTlmn(arr[i]);
				containerCardResult.addChild(card);
				card.scaleX = card.scaleY = .75;
				_arrCardListOtherUser.push(card);
				
				if (pos == 0) 
				{
					card.rotation = 90;
					card.x = _arrUserInfo[0].x - 14;
					card.y = _arrUserInfo[0].y - 35 + (13 - arr.length) * 10 + 18 * i;
				}
				else if (pos == 2)
				{
					card.rotation = 90;
					card.x = _arrUserInfo[2].x + 233;
					card.y = _arrUserInfo[2].y - 35 + (13 - arr.length) * 10 + 18 * i;
				}
				else 
				{
					card.x = _arrUserInfo[1].x - 240 + (13 - arr.length) * 10 + 18 * i;
					card.y = _arrUserInfo[1].y + 31;
				}
			}
		}
		
		private function onShowResult(e:TimerEvent):void 
		{
			//var i:int;
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowResult);
			content.specialCard.visible = false;
			content.dut3bich.visible = false;
			is3bich = false;
			_arrLastCard = [];
			if (_resultWindow) 
			{
				_resultWindow.visible = true;
				content.setChildIndex(_resultWindow, content.numChildren - 1);
				_resultWindow.open(_myInfo._isPlaying);
				_resultWindow.addEventListener("close", onCloseResultWindow);
				_resultWindow.addEventListener("out game", onOutGame);
			}
			
			checkShowTextNotice();
			
			if (Number(MyDataTLMN.getInstance().myMoney[0]) < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
			{
				
				GameDataTLMN.getInstance().notEnoughMoney = true;
				
			}
		}
		private function onOutGame(e:Event):void 
		{
			writelog("click out game in result window --> out room");
			okOut();
		}
		
		private function onCloseResultWindow(e:Event):void 
		{
			_stageGame = 0;
			var outedGame:Boolean = false;
			inSamTime = false;
			
			if (GameDataTLMN.getInstance().notEnoughMoney) 
			{
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					windowLayer.isNoCloseAll = true;
					var kickOutWindow:AddMoneyWindow2 = new AddMoneyWindow2();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				outedGame = true;
				GameDataTLMN.getInstance().notEnoughMoney = false;
				writelog("not enogh money --> out room");
				okOut();
			}
			else 
			{
				_resultWindow.removeEventListener("close", onCloseResultWindow);
				_resultWindow.removeEventListener("out game", onOutGame);
					
				removeAllDisCard();
				removeAllCardSave();
				
				removeAllCardResult();
				
				if (_resultWindow) 
				{
					_resultWindow.visible = false;
				}
				
				_isPlaying = false;
				writelog("game over, remove all card close result window");
				_myInfo.removeAllCard();
				_myInfo.visibleResultGame();
				_myInfo.hideWinNotice();
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					_arrUserInfo[i].removeAllCards();
					_arrUserInfo[i].hideWinNotice();
					_arrUserInfo[i].waitNewGame();
					_arrUserInfo[i].visibleResultGame();
				}
				
				if (GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId) 
				{
					checkShowTextNotice();
					GameDataTLMN.getInstance().autoReady = false;
				}
				else 
				{
					checkShowTextNotice();
					
					_myInfo.waitNewGame();
				}
				
				if (GameDataTLMN.getInstance().autoReady) 
				{
					onClickReady(null);
				}
			}
			
			
			if (SoundManager.getInstance().isSoundOn && !outedGame) 
			{
				var rd:int = int(Math.random() * 5);
				if (MyDataTLMN.getInstance().sex) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_STARTGAME_ + String(rd + 1) );
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_STARTGAME_ + String(rd + 1));
				}
				
			}
				
			
			
		}
		
		private function removeAllCardResult():void 
		{
			for (var i:int = 0; i < _arrCardListOtherUser.length; i++) 
			{
				containerCardResult.removeChild(_arrCardListOtherUser[i]);
				_arrCardListOtherUser[i] = null;
			}
			
			_arrCardListOtherUser = [];
		}
		
		private function onClickStartGame(e:MouseEvent):void 
		{
			if (!stage) 
			{
				return;
			}
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			if (_arrUserList) 
			{
				
			}
			if (_arrUserList && _arrUserList.length > 1 && _stageGame == 0) 
			{
				if (Object(_arrUserList[1]).hasOwnProperty("userName") != "" || 
					Object(_arrUserList[2]).hasOwnProperty("userName") != ""
						|| Object(_arrUserList[3]).hasOwnProperty("userName") != "") 
				{
					
					electroServerCommand.startGame();
				}
			}
			
		}
		
		private function listenStartGameSuccess(obj:Object):void 
		{
			if (_contanierCardOutUser) 
			{
				content.removeChild(_contanierCardOutUser);
				_contanierCardOutUser = null;
			}
			
			if (_containerSpecial) 
			{
				content.removeChild(_containerSpecial);
				_containerSpecial = null;
			}
			
			if (_timerKickMaster) 
			{
				_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
				_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
				_timerKickMaster.stop();
			}
			
			_countTimerkick = 0;
			content.timeKickUserTxt.visible = false;
			
			if (_myInfo) 
			{
				_myInfo.hideReady();
			}
			
			_isPlaying = true;
			_stageGame = 1;
			
			if (obj[DataField.MESSAGE] == "testGame") 
			{
				checkPosClock();
			}
			checkShowTextNotice();
			
			//
		}
		
		private function onCompleteDealCard(e:TimerEvent):void 
		{
			
			var arr:Array = [];
			
			for (var j:int = dealcard; j < _arrUserInfo.length; j++) 
			{
				trace("chia bài: ", j, _arrUserInfo[j]._userName, GameDataTLMN.getInstance().master, _arrUserInfo[j].ready)
				if (_arrUserInfo[j].ready || _arrUserInfo[j]._userName == GameDataTLMN.getInstance().master) 
				{
					_arrUserInfo[j].dealCardSam();
					if (j == 2) 
					{
						if (timerDealCard) 
						{
							timerDealCard.stop();
							timerDealCard.removeEventListener(TimerEvent.TIMER, onCompleteDealCard);
						}
						if (_timerKickMaster) 
						{
							_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
							_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
							_timerKickMaster.stop();
						}
						
						writelog("deal card complete for all user ready");
						
					}
					dealcard = j + 1;
					break;
				}
				
			}
		}
		
		private function dealingCard(e:TimerEvent):void 
		{
			
			
		}
		
		
		private function onClickNextTurn(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			electroServerCommand.nextTurn();
		}
		
		private function onClickHitCard(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			electroServerCommand.myDisCard(e.target._arrCardChoose);
		}
		
		//danh quan bai noa
		//private var arrCardSpecial:Array = [];
		private function listenHaveCard(obj:Object):void 
		{
			//trace(obj)
			var i:int;
			var cardTlmn:CardsTlmn = new CardsTlmn();
			var check:Boolean;
			var cardsName:String = "";
			var arrCard:Array = obj.cardValues;
			var checkAnimationChat2:Boolean = false;
			var checkAnimationChatSanh56:Boolean = false;
			var checkAnimationChatSanh7:Boolean = false;
			var checkAnimationChatTuqui:Boolean = false;
			_arrLastCard = _arrLastCard.sort(Array.NUMERIC);
			content.specialCard.visible = false;
			is3bich = false;
			var rd:int;
			var str:String;
			var ihit:Boolean = false;
			var userSexhit:Boolean = false;
			var userCardRemain:int;
			if (obj.userName == _myInfo._userName) 
			{
				ihit = true;
				userCardRemain = _myInfo._arrCardInt.length;
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					if (_arrUserInfo[i]._userName && obj.userName == _arrUserInfo[i]._userName) 
					{
						userSexhit = _arrUserInfo[i]._sex;
						userCardRemain = _arrUserInfo[i]._remainingCard;
					}
				}
			}
			
			if (arrCard.length == 1 && arrCard[0] == 0) 
			{
				is3bich = true;
			}
			
			
			if (arrCard.length == 1) 
			{
				check = cardTlmn.isHai(arrCard[0]);
				if (check) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DANH2_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DANH2_ + String(rd + 1) );
									}
								}
								
							
							}
							else 
							{
								
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DANH2_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DANH2_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DANH2_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DANH2_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DANH2_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DANH2_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
						
					}
					cardsName = "Hai";
				}
				else if (arrCard[0] == 0) 
				{
					
					if (SoundManager.getInstance().isSoundOn) 
					{
						
						if (_arrLastCard.length > 0) 
						{
							rd = int(Math.random() * 10);
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							rd = int(Math.random() * 5);
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD1CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
										if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD1CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
					}
					
				}
				else
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						
						if (_arrLastCard.length > 0) 
						{
							rd = int(Math.random() * 10);
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							rd = int(Math.random() * 5);
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD1CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD1CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD1CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
					}
					cardsName = "";
				}
				
			}
			else if(arrCard.length == 2)
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE2CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE2CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE2CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE2CARD_ + String(rd + 1) );
								}
							}
							
						}
						
					}
					else 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD2CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD2CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD2CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD2CARD_ + String(rd + 1) );
								}
							}
							
						}
					}
					
					
				}
				cardsName = "Đôi";
				if (int(arrCard[0]) / 4 == 12)
				{
					cardsName = "Đôi 2";
				}
			}
			else if (arrCard.length == 3) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						
					}
					else 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
					}
					
					
				}
				cardsName = "Sảnh 3";
			}
			else if (arrCard.length == 4) 
			{
				check = cardTlmn.isTuQuy(arrCard);
				if (check) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						
						
					}
					cardsName = "Tứ quí";
					if (_arrLastCard && cardTlmn.isHai(_arrLastCard[0])) 
					{
						checkAnimationChat2 = true;
					}
					else if (_arrLastCard && cardTlmn.isBaDoiThong(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
					else if (_arrLastCard && cardTlmn.isTuQuy(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
				}
				else 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
					}
					cardsName = "Sảnh 4";
				}
				
			}
			else if (arrCard.length == 5) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						
					}
					else 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
									if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
					}
					
					
				}
				cardsName = "Sảnh 5";
				if (_arrLastCard && _arrLastCard.length == 5) 
				{
					checkAnimationChatSanh56 = true;
				}
			}
			else if (arrCard.length == 6) 
			{
				
				check = cardTlmn.isBaDoiThong(arrCard);
				if (check) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
										if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
					}
					cardsName = "3 đôi thông";
					if (_arrLastCard && cardTlmn.isHai(_arrLastCard[0]) )
					{
						checkAnimationChat2 = true;
					}
					if (_arrLastCard && cardTlmn.isBaDoiThong(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
				}
				else 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
					}
					cardsName = "Sảnh 6";
					if (_arrLastCard && _arrLastCard.length == 6)
					{
						checkAnimationChatSanh56 = true;
					}
				}
				
			}
			else if (arrCard.length == 7) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						
					}
					else 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
					}
					
					
				}
				cardsName = "Sảnh 7";
				if (_arrLastCard && _arrLastCard.length == 7)
				{
					checkAnimationChatSanh7 = true;
				}
			}
			else if (arrCard.length == 8) 
			{
				check = cardTlmn.isBonDoiThong(arrCard);
				if (check) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
					}
					cardsName = "4 đôi thông";
					if (_arrLastCard && cardTlmn.isHai(_arrLastCard[0]) )
					{
						checkAnimationChat2 = true;
					}
					else if (_arrLastCard && cardTlmn.isBaDoiThong(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
					else if (_arrLastCard && cardTlmn.isTuQuy(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
					else if (_arrLastCard && cardTlmn.isBonDoiThong(_arrLastCard) )
					{
						checkAnimationChatTuqui = true;
					}
				}
				else 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrLastCard.length > 0) 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
									}
								}
								
							}
							
						}
						else 
						{
							if (ihit) 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (MyDataTLMN.getInstance().sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
							else 
							{
								if (arrCard.length < userCardRemain) 
								{
									if (userSexhit) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
									}
								}
								
							}
						}
						
						
					}
					cardsName = "Sảnh 8";
					if (_arrLastCard && _arrLastCard.length == 8)
					{
						checkAnimationChatSanh7 = true;
					}
				}
				
			}
			else if (arrCard.length >= 9) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							
						}
						
					}
					else 
					{
						if (ihit) 
						{
							if (arrCard.length < userCardRemain) 
							{
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
						else 
						{
							if (arrCard.length < userCardRemain) 
							{
									if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DISCARD3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DISCARD3CARD_ + String(rd + 1) );
								}
							}
							
						}
					}
					
					
				}
				cardsName = "Sảnh 9";
				if (_arrLastCard && _arrLastCard.length == 9) 
				{
					checkAnimationChatSanh7 = true;
				}
			}
			
			var cardChilds:Array = [];
			
			/*var arrSave:Array = [];
			for (i = 0; i < _arrCardDiscard.length; i++) 
			{
				arrSave.push(_arrCardDiscard[i]);
			}
			
			if (arrSave.length > 0) 
			{
				
				
				for (i = 0; i < arrSave.length; i++) 
				{
					var card:CardTlmn = new CardTlmn(arrSave[i].id);
					//card.rotation = angel;
					_containCardSave.addChild(card);
					_arrCardSave.push(card);
					card.x = _containCard.x + 30 * i;
					card.y = _containCard.y + 5;
				}
			}*/
			//x:(1024 - _containCard.width) / 2 + 30, y:350
			
			
			removeAllDisCard();
			
			_cardsName = cardsName;
			arrCard = arrCard.sort(Array.NUMERIC);
			_arrLastCard = [];
			_arrLastCard = arrCard;
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].stopTimer();
			}
			_myInfo.stopTimer();
			
			
			
			showCards(arrCard, obj.userName);
			
			if (_userLastDisCard == "") 
			{
				_userLastDisCard = obj.userName;
			}
			else 
			{
				if (obj.userName == _myInfo._userName) 
				{
					
					//_myInfo.chatde(true);
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						
						if (_arrUserInfo[i]._userName && _userLastDisCard == _arrUserInfo[i]._userName) 
						{
							//_arrUserInfo[i].chatde(false);
							break;
						}
					}
				}
				else 
				{
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						
						if (_arrUserInfo[i]._userName && obj.userName == _arrUserInfo[i]._userName) 
						{
							//_arrUserInfo[i].chatde(true);
							break;
						}
					}
					
					if (_userLastDisCard == _myInfo._userName) 
					{
						//_myInfo.chatde(false);
					}
					
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						
						if (_arrUserInfo[i]._userName && _userLastDisCard == _arrUserInfo[i]._userName) 
						{
							//_arrUserInfo[i].chatde(false);
							break;
						}
					}
				}
			}
			
			if (_arrLastCard.length != 0) 
			{
				if (_cardsName == "Tứ quí") 
				{
					content.specialCard.gotoAndStop(3);
					//content.specialCard.visible = true;
					content.setChildIndex(content.specialCard, content.numChildren - 1);
				}
				if (_cardsName == "4 đôi thông") 
				{
					content.specialCard.gotoAndStop(2);
					//content.specialCard.visible = true;
					content.setChildIndex(content.specialCard, content.numChildren - 1);
				}
				if (_cardsName == "3 đôi thông") 
				{
					content.specialCard.gotoAndStop(1);
					//content.specialCard.visible = true;
					content.setChildIndex(content.specialCard, content.numChildren - 1);
				}
			}
			
			
			if (checkAnimationChat2) 
			{
				//showAnimationSpecial("Chat2")
			}
			else if (checkAnimationChatSanh56) 
			{
				//showAnimationSpecial("ChatSanh56")
			}
			else if (checkAnimationChatSanh7) 
			{
				//showAnimationSpecial("ChatSanh7")
			}
			else if (checkAnimationChatTuqui) 
			{
				//showAnimationSpecial("Chat3DoiThong")
			}
			var j:int;
			if (_cardsName == "Đôi 2" || _cardsName == "Hai" || _cardsName == "3 đôi thông" ||
				_cardsName == "4 đôi thông" || _cardsName == "Tứ quí") 
			{
				
				_myInfo.onCompleteNextturn();
				
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
			}
			else 
			{
				_cardsName = "";
			}
			
			if (GameDataTLMN.getInstance().finishRound) 
			{
				content.specialCard.visible = false;
				_arrLastCard = [];
				cardChilds = [];
				content.specialCard.visible = false;
				removeAllDisCard();
				_myInfo._isPassTurn = false;
				_userLastDisCard = "";
				_cardsName = "";
				
				removeAllCardSave();
				
				_myInfo.onCompleteNextturn();
				
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
				
				GameDataTLMN.getInstance().finishRound = false;
			}
			
			GameDataTLMN.getInstance().firstPlayer = "";
			content.noticeForUserTxt.text = "";
			content.noticeForUserTxt.visible = false;
			GameDataTLMN.getInstance().firstGame = false;
			content.noticeMc.visible = false;
			
			//checkPosClock();
			
		}
		
		private function removeAllCardSave():void 
		{
			if (_arrCardSave && _arrCardSave.length > 0) 
			{
				for (var i:int = 0; i < _arrCardSave.length; i++) 
				{
					if (_containCardSave) 
					{
						_containCardSave.removeChild(_arrCardSave[i]);
					}
					
				}
			}
			
			_arrCardSave = [];
		}
		
		
		private function showAnimationSpecial(str:String):void 
		{
			if (GameDataTLMN.getInstance().playSound) 
			{
				SoundManager.getInstance().playSound("Gold22");
			}
			if (_timerShowSpecial) 
			{
				_timerShowSpecial.stop();
				_timerShowSpecial.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSpecial);
			}
			if (_containerSpecial) 
			{
				content.removeChild(_containerSpecial);
				_containerSpecial = null;
			}
			
			if (!_containerSpecial) 
			{
				_containerSpecial = new Sprite();
				content.addChild(_containerSpecial);
				
			}
			else 
			{
				_containerSpecial.visible = true;
			}
			switch (str) 
			{
				
				case "ChatSanh56":
					_containerSpecial.x = 300;
					_containerSpecial.y = 370;
				break;
				case "ChatSanh7":
					_containerSpecial.x = 200;
					_containerSpecial.y = 370;
				break;
				case "Chat2":
					_containerSpecial.x = 300;
					_containerSpecial.y = 370;
				break;
				case "Chat3DoiThong":
					_containerSpecial.x = 200;
					_containerSpecial.y = 370;
				break;
				default:
			}
			/*var arr:Array = GameDataTLMN.getInstance().arrEmoticonPlay;
			var myClass:Class;
			var mc:MovieClip;
			var loader:Loader;
			
			loader = arr[str][0];
			myClass = loader.contentLoaderInfo.applicationDomain.getDefinition(str) as Class;
			mc = new myClass();
			_containerSpecial.addChild(mc);*/
			
			
			/*_timerShowSpecial = new Timer(1000, 3);
			_timerShowSpecial.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSpecial);
			_timerShowSpecial.start();*/
		}
		
		private function onCompleteShowSpecial(e:TimerEvent):void 
		{
			if (_containerSpecial) 
			{
				content.removeChild(_containerSpecial);
				_containerSpecial = null;
			}
			
		}
		
		private function showCards(arr:Array, userName:String):void 
		{
			/*if (_containCard) 
			{
				content.removeChild(_containCard);
				_containCard = null;
			}*/
			var i:int;
			/*if (!_containCard) 
			{
				_containCard = new Sprite();
				content.addChild(_containCard);
				
			}*/
			
			if (userName == _myInfo._userName) 
			{
				
				_containCard.x = _myInfo.x + 200;
				_containCard.y = _myInfo.y - 20;
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					
					if (_arrUserInfo[i]._userName && userName == _arrUserInfo[i]._userName) 
					{
						
						switch (i) 
						{
							
							case 0:
								_containCard.x = _arrUserInfo[i].x + 60;
								_containCard.y = _arrUserInfo[i].y - 20;
							break;
							case 1:
								_containCard.x = _arrUserInfo[i].x - 100;
								_containCard.y = _arrUserInfo[i].y - 20;
							break;
							case 2:
								_containCard.x = _arrUserInfo[i].x + 60;
								_containCard.y = _arrUserInfo[i].y + 250;
							break;
							default:
						}
					}
					
				}
			}
			
			var arrCardCheck:Array = [];
			for (i = 0; i < arr.length; i++) 
			{
				arrCardCheck.push(arr[i]);
			}
			var cardTlmn:CardsTlmn = new CardsTlmn();
			var check:Boolean = false;
			
			if (cardTlmn.isSpecialDay(arrCardCheck)) 
			{
				check = true;
			}
			
			if (check) 
			{
				for (i = 0; i < arr.length; i++) 
				{
					if (arr[i] > 43) 
					{
						arr[i] = arr[i] - 52;
					}
					
				}
				
				arr = arr.sort(Array.NUMERIC);
				
				for (i = 0; i < arr.length; i++) 
				{
					if (arr[i] < 0) 
					{
						arr[i] = arr[i] + 52;
					}
					
				}
				
			}
			
			for (i = 0; i < arr.length; i++) 
			{
				var angel:int = int(Math.random() * 15);
				var card:CardTlmn = new CardTlmn(arr[i]);
				card.scaleX = card.scaleY = .8;
				_containCard.addChild(card);
				_arrCardDiscard.push(card);
				card.x = 30 * i;
				card.y = 5;
				_myInfo.removeCardDisCard(card.id);
			}
			
			//_textfield.defaultTextFormat = new TextFormat("Myriad Pro", 24, 0xffffff, true);
			//_textfield.text = _cardsName;
			/*var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onVisibleTextField);
			timer.start();*/
			
			showEffect();
			if (_invitePlayWindow) 
			{
				content.setChildIndex(_inviteLayer, content.numChildren - 1);
			}
		
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i]._userName == userName) 
				{
					_arrUserInfo[i].removeCardDeck(arr.length);
				}
			}
		}
		
		private function onVisibleTextField(e:TimerEvent):void 
		{
			
			_textfield.text = "";
		}
		
		private function showEffect():void 
		{
			var rdX:int = 20 + int(Math.random() * 50);
			var rdY:int = 20 + int(Math.random() * 20);
			
			TweenMax.to(_containCard, .5, { x:(1024 - _containCard.width) / 2, y:250} );
			
		}
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_OUTROOM);
				
			}
			_numUser--;
			checkShowTextNotice();
			var i:int;
			var j:int;
			var outArr:Array = [];
			if (!_contanierCardOutUser) 
			{
				_contanierCardOutUser = new Sprite();
				content.addChild(_contanierCardOutUser);
			}
			
			_myInfo.hideSameIp();
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].hideSameIp();
			}
			
			for (i = 0; i < _arrUserList.length; i++) 
			{
				if (_arrUserList[i])
				{
					if ((_arrUserList[i]).userName == data[DataField.USER_NAME])
					{
						_arrUserList.splice(i, 1);
						break;
					}
				}
			}
			if (!_isPlaying && MyDataTLMN.getInstance().myId == GameDataTLMN.getInstance().master) 
			{
				var check:Boolean = false;
				for (i = 0; i < _arrUserInfo.length; i++) 
				{
					
					if (_arrUserInfo[i].ready) 
					{
						check = true;
						
					}
					
				}
				
				if (check) 
				{
					checkShowTextNotice();
				}
				else 
				{
					checkShowTextNotice();
				}
			}
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i])
				{
					if ((_arrUserInfo[i])._userName == data[DataField.USER_NAME])
					{
						for (j = 0; j < _arrRealUser.length; j++) 
						{
							if (data[DataField.USER_NAME] == _arrRealUser[j]) 
							{
								_arrRealUser[j] = "";
							}
						}
						
						if (_chatBox) 
						{
							var str:String = (_arrUserInfo[i])._displayName + " vừa thoát bàn chơi!";
							_chatBox.addChatSentence(str, "Thông báo", false, false);
						}
						
						_arrUserInfo[i].hideSameIp();
						_arrUserInfo[i].outRoom();
						if (!_isPlaying) 
						{
							_arrUserInfo[i].waitNewGame();
						}
						var rd:int = int(Math.random() * 5);
						if (_arrUserInfo[i]._sex) 
						{
							if (SoundManager.getInstance().isSoundOn) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_USER_OUTROOM_ + String(rd + 1) );
								
							}
						}
						else 
						{
							if (SoundManager.getInstance().isSoundOn) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_USER_OUTROOM_ + String(rd + 1) );
								
							}
						}
						//_chatBox.addChatSentence(_arrUserInfo[i]._userName + " vừa rời khỏi phòng chơi", "Thông báo", false, true);
						
						break;
					}
					
					
				}
				
			}
			
			var count:int = 0;
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i])
				{
					if (_arrUserInfo[i].ready)
					{
						
						count++;
					}
				}
			}
			if (_myInfo._ready) 
			{
				
				count++;
			}
			
			
			var conflickIp:Boolean = false;
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i].userIp == _myInfo.myIp) 
				{
					conflickIp = true;
					_myInfo.showSameIp();
					_arrUserInfo[i].showSameIp();
				}
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					if (_arrUserInfo[i].userIp == _arrUserInfo[j].userIp && 
						_arrUserInfo[i]._userName != _arrUserInfo[j]._userName) 
					{
						conflickIp = true;
						_arrUserInfo[i].showSameIp();
						_arrUserInfo[j].showSameIp();
					}
				}
			}
			
			if (count == 0 || _numUser == 1) 
			{
				if (_timerKickMaster) 
				{
					_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
					_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
					_timerKickMaster.stop();
				}
				_haveUserReady = false;
				
				_countTimerkick = 0;
				content.timeKickUserTxt.visible = false;
			}
			
			if (!inSamTime) 
			{
				checkPosClock();
			}
			
			
		}
		
		public function removeAllEvent():void 
		{
			if (content) 
			{
				content.settingBoard.onSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
				content.settingBoard.offSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
				content.settingBoard.onMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
				content.settingBoard.offMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
				
				mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
				content.signOutBtn.removeEventListener(MouseEvent.CLICK, onClickSignOutGame);
				content.settingBoard.fullBtn.removeEventListener(MouseEvent.CLICK, onClickFullGame);
				content.settingBoard.ipBtn.removeEventListener(MouseEvent.CLICK, onClickIPGame);
				//content.settingBoard.guideBtn.removeEventListener(MouseEvent.CLICK, onClickGuidGame);
				
				content.startGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
				
				if (timerHideIpBoard) 
				{
					timerHideIpBoard.stop();
					timerHideIpBoard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
				}
				
				if (timerToGetSystemNoticeInfo)
				{
					timerToGetSystemNoticeInfo.removeEventListener(TimerEvent.TIMER, onGetSystemNoticeInfo);
					timerToGetSystemNoticeInfo.stop();
				}
				
				inSamTime = false;
				haveUserReady = false;
				
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					_arrUserInfo[i].removeAllEvent();
					_arrUserInfo[i].removeEventListener("kick", onClickKick);
					_arrUserInfo[i].removeEventListener("add friend", onAddFriend);
					_arrUserInfo[i].removeEventListener("remove friend", onRemoveFriend);
					
					_arrUserInfo[i].removeEventListener(ConstTlmn.UPDATE_USER_INFO, onShowContextMenu);
					_arrUserInfo[i].removeEventListener(ConstTlmn.INVITE, onClickInvite);
				}
				
				if (heartbeart) 
				{
					heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
					heartbeart.stop();
				}
				_arrRealUser = [];
				_myInfo.removeAllEvent();
				_myInfo.removeEventListener(ConstTlmn.UPDATE_USER_INFO, onUpdateMyInfo);
				_myInfo.removeEventListener("next turn", onClickNextTurn);
				_myInfo.removeEventListener("hit card", onClickHitCard);
				_myInfo.removeEventListener(ConstTlmn.READY, onClickReady);
				_myInfo._userName = "";
				
				GameDataTLMN.getInstance().autoReady = false;
				
				_chatBox.removeAllChat();
				GameDataTLMN.getInstance().removeEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
				_chatBox.removeEventListener(ChatBox.HAVE_CHAT, onHaveChat);
				
				if (_invitePlayWindow) 
				{
					_invitePlayWindow.removeEventListener("Invitive", onInvitePlayer);
					_invitePlayWindow.removeEventListener("Close", onCloseInviteWindow);
				}
				
				
				GameDataTLMN.getInstance().playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
				
				if (_resultWindow) 
				{
					_resultWindow.removeEventListener("close", onCloseResultWindow);
					_resultWindow.removeEventListener("out game", onOutGame);
					
					content.removeChild(_resultWindow);
					_resultWindow = null;
				}
				
				if (_timerNoticeWin) 
				{
					_timerNoticeWin.removeEventListener(TimerEvent.TIMER, onTimerNoticeWin);
					_timerNoticeWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteNoticeWin);
					_timerNoticeWin.stop();
				}
				if (timerDealcardForme) 
				{
					timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
					timerDealcardForme.stop();
				}
				if (_timerKickMaster) 
				{
					_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
					_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
					_timerKickMaster.stop();
				}
				
				if (timerShowResult) 
				{
					timerShowResult.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowResult);
					timerShowResult.stop();
				}
				
				if (timerShowResultWhiteWin) 
				{
					timerShowResultWhiteWin.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetGame);
					timerShowResultWhiteWin.stop();
				}
				
				if (_timerShowSpecial) 
				{
					_timerShowSpecial.stop();
					_timerShowSpecial.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowSpecial);
				}
				
				if (timerShowChatDe) 
				{
					timerShowChatDe.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowChatDe);
					timerShowChatDe.stop();
				}
				
				if (timerDealCard) 
				{
					timerDealCard.removeEventListener(TimerEvent.TIMER, onCompleteDealCard);
					timerDealCard.stop();
				}
				removeAllCardResult();
				removeAllDisCard();
				removeAllCardSave();
				
				for (var j:int = 0; j < _arrEmoForUser.length; j++) 
				{
					timer = _arrEmoForUser[j][1];
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowEmo);
					
					_arrEmoForUser[j][0].removeChild(Sprite(_arrEmoForUser[j][0]).getChildAt(0));
					
				}
				_arrEmoForUser = [];
				
				
				//GameDataTLMN.getInstance()._userName = "";
				
				var check:int = content.numChildren;
				for (i = 0; i < check; i++) 
				{
					content.removeChild(content.getChildAt(0));
				}
				
				gameLayer.removeChild(content);
				content = null;
				
				
			}
			
			
		}
		
		private function onHidIpBoard(e:TimerEvent):void 
		{
			content.ipBoard.visible = false;
		}
		
		private function addComponent():void 
		{
			if (!_textfield) 
			{
				_textfield = new TextField();
				content.addChild(_textfield);
				_textfield.x = 600;
				_textfield.y = 350;
				_textfield.defaultTextFormat = new TextFormat("Tahoma", 24, 0x000000);
				
				_textfield.mouseEnabled = false;
			}
			
			content.boardEvent.visible = false;
			content.noc.visible = false;
			
			content.txtNotice.mouseEnabled = false;
			
			content.txtNotice.text = "";
			
			_chatBox = new ChatBoxPhom();
			
			//_chatBox.width = 235;
			//_chatBox.setHeight(275);
			GameDataTLMN.getInstance().addEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			_chatBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
			_chatBox.x = 0;
			_chatBox.y = 0;
			_chatBox.maxCharsChat = 50;
			
			//_chatBox.loadEmo("http://183.91.14.52/gamebai/bimkute/phom/emoticon.swf");
			
			chatLayer.addChild(_chatBox);
			_chatBox.visible = false;
			
			mainData.addEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			if (timerToGetSystemNoticeInfo)
			{
				timerToGetSystemNoticeInfo.removeEventListener(TimerEvent.TIMER, onGetSystemNoticeInfo);
				timerToGetSystemNoticeInfo.stop();
			}
			/*timerToGetSystemNoticeInfo = new Timer(30000);
			timerToGetSystemNoticeInfo.addEventListener(TimerEvent.TIMER, onGetSystemNoticeInfo);
			timerToGetSystemNoticeInfo.start();*/

			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldPhom.MESSAGE];
				_chatBox.addChatSentence(textField.text, "Thông báo");
			}
			
			//_waitToPlay = content["waitToPlay"]; = _waitToPlay.visible
			_waitToReady = content["waitToReady"];
			_waitToStart = content["waitToStart"];
			
			_waitToReady.visible = _waitToStart.visible = false;
			_waitToReady.visible = false;
			
			content.specialCard.visible = false;
			content.xChat.visible = false;
			content.whiteWin.visible = false;
			
			
			if (!_resultWindow) 
			{
				_resultWindow = new ResultWindowTlmn();
				content.addChild(_resultWindow);
				//_resultWindow.scaleX = _resultWindow.scaleY = .75;
				//_resultWindow.x = (this.width - _resultWindow.width) / 2;
				_resultWindow.y = -70; // (600 - _resultWindow.height) / 2;
				_resultWindow.visible = false;
				
				////trace("tao ra thang result window")
			}
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				content.settingBoard.onSoundEffect.visible = false;
				content.settingBoard.offSoundEffect.visible = true;
			}
			else 
			{
				content.settingBoard.onSoundEffect.visible = true;
				content.settingBoard.offSoundEffect.visible = false;
			}
			
			if (SoundManager.getInstance().isMusicOn) 
			{
				content.settingBoard.onMusic.visible = false;
				content.settingBoard.offMusic.visible = true;
			}
			else 
			{
				content.settingBoard.onMusic.visible = true;
				content.settingBoard.offMusic.visible = false;
			}
			
			content.settingBoard.visible = false;
			content.ipBoard.visible = false;
			content.ipBoard.nam1Txt.mouseEnabled = false;
			content.ipBoard.nam2Txt.mouseEnabled = false;
			content.ipBoard.nam3Txt.mouseEnabled = false;
			content.ipBoard.nam4Txt.mouseEnabled = false;
			content.ipBoard.ip1Txt.mouseEnabled = false;
			content.ipBoard.ip2Txt.mouseEnabled = false;
			content.ipBoard.ip3Txt.mouseEnabled = false;
			content.ipBoard.ip4Txt.mouseEnabled = false;
			content.setChildIndex(content.settingBoard, content.numChildren - 1);
			content.setChildIndex(content.ipBoard, content.numChildren - 1);
			content.settingBtn.addEventListener(MouseEvent.CLICK, onShowSettingBoard);
			
			content.settingBoard.onSoundEffect.addEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
			content.settingBoard.offSoundEffect.addEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
			content.settingBoard.onMusic.addEventListener(MouseEvent.CLICK, onClickOnOffMusic);
			content.settingBoard.offMusic.addEventListener(MouseEvent.CLICK, onClickOnOffMusic);
			
			content.settingBoard.fullBtn.visible = false;
			content.signOutBtn.addEventListener(MouseEvent.CLICK, onClickSignOutGame);
			content.settingBoard.fullBtn.addEventListener(MouseEvent.CLICK, onClickFullGame);
			content.settingBoard.ipBtn.addEventListener(MouseEvent.CLICK, onClickIPGame);
			//content.settingBoard.guideBtn.addEventListener(MouseEvent.CLICK, onClickGuidGame);
			
			content.startGame.addEventListener(MouseEvent.CLICK, onClickStartGame);
			content.orderCard.addEventListener(MouseEvent.CLICK, onOrderCard);
			
			content.orderCard.visible = false;
			
			if (mainData.chooseChannelData.myInfo.name == "bim15" || mainData.chooseChannelData.myInfo.name == "haonam01")
			{
				//content.orderCard.visible = true;
			}
			
			checkShowTextNotice();
			
			content.chatBtn.stop();
			content.chatBtn.addEventListener(MouseEvent.CLICK, onChatButtonClick);
			
		}
		
		private function onShowSettingBoard(e:MouseEvent):void 
		{
			if (!content.settingBoard.visible) 
			{
				content.settingBoard.visible = true;
				content.ipBoard.visible = false;
			}
			else if (content.settingBoard.visible && content.ipBoard.visible) 
			{
				content.settingBoard.visible = true;
				content.ipBoard.visible = false;
			}
			else if (content.settingBoard.visible && !content.ipBoard.visible) 
			{
				content.settingBoard.visible = false;
				content.ipBoard.visible = false;
			}
			
			content.setChildIndex(content.settingBoard, content.numChildren - 1);
			content.setChildIndex(content.ipBoard, content.numChildren - 1);
		}
		
		private function onChatButtonClick(e:MouseEvent):void 
		{
			content.chatBtn.gotoAndStop(1);
			_chatBox.visible = true;
		}
		
		private function onChatBoxBackButtonClick(e:Event):void 
		{
			_chatBox.visible = false;
			//chatButton.visible = true;
		}
		
		private function onOrderCard(e:MouseEvent):void 
		{
			if (GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId)
			{
				var orderCardWindow:OrderCardWindow = new OrderCardWindow();
				
				WindowLayer.getInstance().openWindow(orderCardWindow);
				return;
			}
		}
		
		private function onConfirmOrderCard(e:Event):void 
		{
			
		}
		
		private function onClickOnOffSoundEffect(e:MouseEvent):void 
		{
			sharedObject = SharedObject.getLocal("soundConfig");
			
			//trace(sharedObject.data.isSoundOff, sharedObject.data.isMusicOff)
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
				
			}
			if (SoundManager.getInstance().isSoundOn) 
			{
				GameDataTLMN.getInstance().playSound = false;
				content.settingBoard.onSoundEffect.visible = true;
				content.settingBoard.offSoundEffect.visible = false;
				SoundManager.getInstance().isSoundOn = false;
				sharedObject.data.isSoundOff = true;
			}
			else 
			{
				GameDataTLMN.getInstance().playSound = true;
				content.settingBoard.onSoundEffect.visible = false;
				content.settingBoard.offSoundEffect.visible = true;
				SoundManager.getInstance().isSoundOn = true;
				sharedObject.data.isSoundOff = false;
			}
		}
		
		private function onClickOnOffMusic(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			if (SoundManager.getInstance().isMusicOn) 
			{
				GameDataTLMN.getInstance().playGameBackGroud = false;
				content.settingBoard.onMusic.visible = true;
				content.settingBoard.offMusic.visible = false;
				SoundManager.getInstance().isMusicOn = false;
				SoundManager.getInstance().stopMusic(ConstTlmn.MUSIC_BG);
			}
			else 
			{
				GameDataTLMN.getInstance().playGameBackGroud = true;
				content.settingBoard.onMusic.visible = false;
				content.settingBoard.offMusic.visible = true;
				
				/*var rd:int = int(Math.random() * 3);
				if (rd == 0 ) 
				{
					ConstTlmn.MUSIC_BG = "GameSound1";
				}
				else if (rd == 1 ) 
				{
					ConstTlmn.MUSIC_BG = "GameSound2";
				}
				else if (rd == 2 ) 
				{
					ConstTlmn.MUSIC_BG = "GameSound3";
				}
				SoundManager.getInstance().playMusic(ConstTlmn.MUSIC_BG, 100000);*/
				
				SoundManager.getInstance().isMusicOn = true;
			}
		}
		
		private function onClickGuidGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			//navigateToURL(new URLRequest("http://sanhbai.com/ho-tro.html"), "blank");
		}
		
		private function onClickIPGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			if (content.ipBoard.visible) 
			{
				content.ipBoard.visible = false;
			}
			else 
			{
				content.ipBoard.visible = true;
				
				getIpAllPlayer();
			}
		}
		
		private function getIpAllPlayer():void 
		{
			content.ipBoard.nam1Txt.visible = false;
			content.ipBoard.nam2Txt.visible = false;
			content.ipBoard.nam3Txt.visible = false;
			content.ipBoard.nam4Txt.visible = false;
			content.ipBoard.ip1Txt.visible = false;
			content.ipBoard.ip2Txt.visible = false;
			content.ipBoard.ip3Txt.visible = false;
			content.ipBoard.ip4Txt.visible = false;
			
			content.ipBoard.nam1Txt.text = "";
			content.ipBoard.nam2Txt.text = "";
			content.ipBoard.nam3Txt.text = "";
			content.ipBoard.nam4Txt.text = "";
			content.ipBoard.ip1Txt.text = "";
			content.ipBoard.ip2Txt.text = "";
			content.ipBoard.ip3Txt.text = "";
			content.ipBoard.ip4Txt.text = "";
			
			content.ipBoard.nam1Txt.visible = true;
			content.ipBoard.ip1Txt.visible = true;
			
			content.ipBoard.nam1Txt.text = MyDataTLMN.getInstance().myDisplayName;
			content.ipBoard.ip1Txt.text = _myInfo.myIp;
			
			var count:int = 1;
				
			for (var i:int = 1; i < 4; i++) 
			{
				if (_arrUserInfo[i - 1]._userName != "" ) 
				{
					switch (count) 
					{
						case 1:
							content.ipBoard.nam2Txt.visible = true;
							content.ipBoard.ip2Txt.visible = true;
							
							content.ipBoard.nam2Txt.text = _arrUserInfo[i - 1]._displayName;
							content.ipBoard.ip2Txt.text = _arrUserInfo[i - 1].userIp;
						break;
						case 2:
							content.ipBoard.nam3Txt.visible = true;
							content.ipBoard.ip3Txt.visible = true;
							
							content.ipBoard.nam3Txt.text = _arrUserInfo[i - 1]._displayName;
							content.ipBoard.ip3Txt.text = _arrUserInfo[i - 1].userIp;
						break;
						case 3:
							content.ipBoard.nam4Txt.visible = true;
							content.ipBoard.ip4Txt.visible = true;
							
							content.ipBoard.nam4Txt.text = _arrUserInfo[i - 1]._displayName;
							content.ipBoard.ip4Txt.text = _arrUserInfo[i - 1].userIp;
						break;
						default:
					}
					count++;
				}
			}
		}
		
		private function onClickFullGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
		}
		
		public function removeEventChat():void 
		{
			GameDataTLMN.getInstance().removeEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.removeEventListener(ChatBox.HAVE_CHAT, onHaveChat);
		}
		public function addEventChat():void 
		{
			
			GameDataTLMN.getInstance().addEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
		}
		
		
		private function onCreateBoardEmoChat(e:MouseEvent):void 
		{
			//trace(_emoBoard)
			/*if (!_emoBoard) 
			{
				_emoBoard = new Emoticon();
				_emoBoard.x = 225;
				_emoBoard.y = 250;
				addChild(_emoBoard);
				
			}
			else if (_emoBoard.visible == true ) 
			{
				_emoBoard.visible = false;
			}
			else 
			{
				_emoBoard.visible = true;
			}
			if (timer) 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			}
			timer = new Timer(1000, 5);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
			_emoBoard.addEventListener("chose emo", onSendEmo);*/
		}
		
		private function onComplete(e:TimerEvent):void 
		{
			
		}
		
		private function onSendEmo(e:Event):void 
		{
			if (timer) 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			}
			
			if (!stage) 
			{
				return;
			}
			electroServerCommand.sendPublicChat(MyDataTLMN.getInstance().myId, MyDataTLMN.getInstance().myDisplayName,
													e.target.nameOfEmo, true);
		}
		
		private function onClickInvite(e:Event):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			/*if (!_invitePlayWindow) 
			{
				_invitePlayWindow = new InvitePlayWindow();
				_invitePlayWindow.x = 500;
				_invitePlayWindow.y = 300;
				_inviteLayer.addChild(_invitePlayWindow);
			}
			
			
			_invitePlayWindow.getUserInLobby();
			_inviteLayer.visible = true;
			content.setChildIndex(_inviteLayer, content.numChildren - 1);
			//_invitePlayWindow.getUserInlobby();
			_invitePlayWindow.addEventListener("Invitive", onInvitePlayer);
			_invitePlayWindow.addEventListener("Close", onCloseInviteWindow);*/
			
			var invitePlayWindow:InvitePlayWindow = new InvitePlayWindow();
			windowLayer.openWindow(invitePlayWindow);
		}
		
		private function onInvitePlayer(e:Event):void 
		{
			if (_invitePlayWindow) 
			{
				
				_invitePlayWindow.removeEventListener("Invitive", onInvitePlayer);
				_invitePlayWindow.removeEventListener("Close", onCloseInviteWindow);
				_inviteLayer.visible = false;
			}
		}
		
		private function onCloseInviteWindow(e:Event):void 
		{
			if (_invitePlayWindow) 
			{
				
				_invitePlayWindow.removeEventListener("Invitive", onInvitePlayer);
				_invitePlayWindow.removeEventListener("Close", onCloseInviteWindow);
				
				_inviteLayer.visible = false;
				
			}
		}
		
		private function removeAllDisCard():void 
		{
			var i:int;
			
			if (_containCard) 
			{
				for (i = 0; i < _arrCardDiscard.length; i++) 
				{
					_containCard.removeChild(_arrCardDiscard[i]);
					_arrCardDiscard[i] = null;
				}
				
				_arrCardDiscard = [];
			}
			else 
			{
				_arrCardDiscard = [];
			}
			
			
		}
		
		private function onClickSignOutGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			
			if (canExitGame) 
			{
				if (_stageGame == 1) 
				{
					if (_myInfo._ready || GameDataTLMN.getInstance().master == _myInfo._userName) 
					{
						confirmExitWindow = new ConfirmWindow();
						confirmExitWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmExit);
						confirmExitWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
						windowLayer.openWindow(confirmExitWindow);
					}
					else 
					{
						outGameRoom();
					}
				}
				else if (_stageGame == 0) 
				{
					outGameRoom();
				}
				
			}
			
		}
		
		
		private function onConfirmWindow(e:Event):void 
		{
			if (e.currentTarget == confirmExitWindow)
			{
				//mainData.chooseChannelData.myInfo.money -= Number(mainData.playingData.gameRoomData.roomBet) * 4;
				//if (mainData.chooseChannelData.myInfo.money < 0)
				//	mainData.chooseChannelData.myInfo.money = 0;
				outGameRoom();
			}
			
		}
		
		private function outGameRoom():void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				var rd:int = int(Math.random() * 5);
				if (MyDataTLMN.getInstance().sex) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_BYE_ + String(rd + 1) );
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_BYE_ + String(rd + 1) );
				}
				
			}
			_myInfo._userName = "";
			//GameDataTLMN.getInstance()._userName = "";
			
			EffectLayer.getInstance().removeAllEffect();
			
			okOut();
		}
		
		public function destroy():void 
		{
			
		}
		
		private function okOut():void 
		{
			if (!stage) 
			{
				return;
			}
			
			GameDataTLMN.getInstance().playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			
			if (_chatBox) 
			{
				_chatBox.removeAllChat();
			}
			var i:int;
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].visible = false;
				_arrUserInfo[i].removeAllCards();
				_arrUserInfo[i].removeAvatar()
				_arrUserInfo[i].removeAllEvent()
			}
			
			
			_myInfo.removeAllCard();
			_myInfo.removeAllEvent();
			_myInfo._isPlaying = false;
		
			_arrLastCard = [];
			_arrUserList = [];
			
			removeAllDisCard();
			removeAllCardSave();
			
			masterUnVisible();
			
			if (_contanierCardOutUser) 
			{
				content.removeChild(_contanierCardOutUser);
				_contanierCardOutUser = null;
			}
			_isPlaying = false;
			
			electroServerCommand.joinLobbyRoom();
			dispatchEvent(new Event(ConstTlmn.OUT_ROOM, true));
		}
		
		private function masterUnVisible():void 
		{
			checkShowTextNotice();
			GameDataTLMN.getInstance().master = "";
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			
			var i:int;
			var isMe:Boolean;
			var notEmo:Boolean = false;
			if (GameDataTLMN.getInstance().publicChat[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				isMe = true;
			}
			
			/*for (i = 0; i < emoArray.length; i++) 
			{
				if (GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT] == arrChat[i].name) 
				{
					notEmo = true;
					break;
				}
			}*/
			
			if (GameDataTLMN.getInstance().publicChat[DataField.IS_EMO]) 
			{
				showEmo(GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT], 
							GameDataTLMN.getInstance().publicChat[DataField.USER_NAME], isMe);
			}
			else 
			{
				var isNotice:Boolean = false;
				if (GameDataTLMN.getInstance().publicChat[DataField.DISPLAY_NAME] == "Hệ thống") 
				{
					isNotice = true;
				}
				
				var str:String = "??yeumaynhat??" + _myInfo._displayName;
				var str1:String = GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT];
				str1 = str1.substr(0, 14);
				if (str1 == "??yeumaynhat??") 
				{
					if (str == GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT]) 
					{
						okOut();
						windowLayer.isNoCloseAll = true;
				
						var kickOutWindow:AlertWindow = new AlertWindow();
						
						kickOutWindow.setNotice(mainData.init.gameDescription.alertSentence.closeConnection);
						
						windowLayer.openWindow(kickOutWindow);
					}
				}
				else 
				{
					_chatBox.addChatSentence(GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT],
											GameDataTLMN.getInstance().publicChat[DataField.DISPLAY_NAME], isMe);
					if (!isMe) 
					{
						for (i = 0; i < _arrUserInfo.length; i++) 
						{
							if (_arrUserInfo[i]._userName == GameDataTLMN.getInstance().publicChat[DataField.USER_NAME]) 
							{
								_arrUserInfo[i].bubbleChat(GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT]);
							}
						}
					}
					else 
					{
						_myInfo.bubbleChat(GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT]);
					}
				}
				
				
			}
			
		}
		
		private function showEmo(str:String, userChat:String, isMe:Boolean):void 
		{
			var i:int;
			for (i = 0; i < _arrEmoForUser.length; i++) 
			{
				if (userChat == _arrEmoForUser[i][2]) 
				{
					var timer:Timer = _arrEmoForUser[i][1];
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowEmo);
					timer.stop();
					
					_containerChatEmo.removeChild(_arrEmoForUser[i][0]);
					
					_arrEmoForUser.splice(i, 1);
					
					break;
				}
			}
			
			for (i = 0; i < emoArray.length; i++) 
			{
				if (emoArray[i].name == str) 
				{
					var tempClass:Class;
					tempClass = Class(getDefinitionByName(emoArray[i].name));
					var emo:Sprite = Sprite(new tempClass());
					_containerChatEmo.addChild(emo);
					if (isMe) 
					{
						_containerChatEmo.x = 92;
						_containerChatEmo.y = 424;
					}
					else if (_arrUserInfo[0]._userName == userChat) 
					{
						_containerChatEmo.x = 866;
						_containerChatEmo.y = 190;
					}
					else if (_arrUserInfo[1]._userName == userChat) 
					{
						_containerChatEmo.x = 620;
						_containerChatEmo.y = 86;
					}
					else if (_arrUserInfo[2]._userName == userChat) 
					{
						_containerChatEmo.x = 25;
						_containerChatEmo.y = 188;
					}
					
					_timerShowEmo = new Timer(1000, 5);
					_timerShowEmo.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowEmo);
					_timerShowEmo.start();
					
					_arrEmoForUser.push([emo, _timerShowEmo, userChat]);
					
					break;
				}
			}
			
			
		}
		
		private function onCompleteShowEmo(e:TimerEvent):void 
		{
			var timer:Timer = e.currentTarget as Timer;
			for (var i:int = 0; i < _arrEmoForUser.length; i++) 
			{
				if (timer == _arrEmoForUser[i][1]) 
				{
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowEmo);
					timer.stop();
					
					_containerChatEmo.removeChild(_arrEmoForUser[i][0]);
					
					_arrEmoForUser.splice(i, 1);
					
					break;
				}
			}
		}
		
		private function onHaveChat(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			electroServerCommand.sendPublicChat(MyDataTLMN.getInstance().myId, MyDataTLMN.getInstance().myDisplayName,
												e.target.zInputText.text, false);
			
		}
		
		private function listenHaveUserJoinRoom(obj:Object):void 
		{
			var i:int;
			var j:int;
			var obj:Object;
			var objUser:Object;
			var sex:Boolean;
			_numUser++;
			for (j = 0; j < _arrRealUser.length; j++) 
			{
				if (_arrRealUser[j] == "") 
				{
					_arrRealUser[j] = obj[ConstTlmn.PLAYER_NAME];
					
					if (_myInfo.realPos == 0) 
					{
						for (i = 0; i < _arrUserInfo.length; i++) 
						{
							if (_arrUserInfo[i]._userName == "") 
							{
								sex = false;
								if (obj[DataField.SEX] == "M") 
								{
									sex = true;
								}
								_arrUserInfo[i].getInfoPlayer(i + 1, obj[DataField.USER_NAME], obj[DataField.MONEY], obj[DataField.AVATAR], 
								0, String(obj[DataField.LEVEL]), false, _isPlaying, false, obj[DataField.DISPLAY_NAME], 
								sex, obj[DataField.IP], obj.deviceId,
								obj[DataField.WIN], obj[DataField.LOSE]);
								
								objUser = new Object();
								objUser[DataField.USER_NAME] = obj[DataField.USER_NAME];
								objUser[DataField.POSITION] = i + 1;
								objUser[DataField.MONEY] = obj[DataField.MONEY];
								objUser[DataField.AVATAR] = obj[DataField.AVATAR];
								objUser[DataField.NUM_CARD] = obj[DataField.NUM_CARD];
								objUser[DataField.LEVEL] = obj[DataField.LEVEL];
								objUser[DataField.READY] = false;
								
								objUser["isMaster"] = false;
								objUser[DataField.DISPLAY_NAME] = obj[DataField.DISPLAY_NAME];
								objUser[DataField.SEX] = sex;
								_arrUserList[i + 1] = objUser;
								/*if (_stageId == 1) 
								{
									_arrPlayerInfo[i].alpha = .3;
								}*/
								
								
								
								break;
							}
						}
					}
					else 
					{
						i = j - _myInfo.realPos + 3;
						if (i > 3) 
						{
							i = i - 4;
						}
						
						if (_arrUserInfo[i]._userName == "") 
						{
							sex = false;
							if (obj[DataField.SEX] == "M") 
							{
								sex = true;
							}
							_arrUserInfo[i].getInfoPlayer(i + 1, obj[DataField.USER_NAME], obj[DataField.MONEY], obj[DataField.AVATAR], 
								0, String(obj[DataField.LEVEL]), false, _isPlaying, false,
								obj[DataField.DISPLAY_NAME], sex, obj[DataField.IP], obj[DataField.DEVICE_ID],
								obj[DataField.WIN], obj[DataField.LOSE]);
							
							
							/*if (_stageId == 1) 
							{
								_arrPlayerInfo[i].alpha = .3;
							}*/
							objUser = new Object();
							objUser[DataField.USER_NAME] = obj[DataField.USER_NAME];
							objUser[DataField.POSITION] = i + 1;
							objUser[DataField.MONEY] = obj[DataField.MONEY];
							objUser[DataField.AVATAR] = obj[DataField.AVATAR];
							objUser[DataField.NUM_CARD] = obj[DataField.NUM_CARD];
							objUser[DataField.LEVEL] = obj[DataField.LEVEL];
							objUser[DataField.READY] = false;
							
							objUser["isMaster"] = false;
							objUser[DataField.DISPLAY_NAME] = obj[DataField.DISPLAY_NAME];
							objUser[DataField.SEX] = sex;
							_arrUserList[i + 1] = objUser;
						}
					}
					
					break;
				}
			}
			
			var rd:int;
			if (SoundManager.getInstance().isSoundOn) 
			{
				rd = int(Math.random() * 5);
				
				if (sex) 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_JOINGAME_ + String(rd + 1) );
				}
				else 
				{
					SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_JOINGAME_ + String(rd + 1) );
				}
			}
			
			if (_chatBox) 
			{
				var str:String = obj[DataField.DISPLAY_NAME] + " vừa vào bàn chơi!";
				_chatBox.addChatSentence(str, "Thông báo", false, false);
			}
			
			
			var conflickIp:Boolean = false;
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i].userIp == _myInfo.myIp) 
				{
					conflickIp = true;
					_myInfo.showSameIp();
					_arrUserInfo[i].showSameIp();
				}
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					if (_arrUserInfo[i].userIp == _arrUserInfo[j].userIp && 
						_arrUserInfo[i]._userName != _arrUserInfo[j]._userName) 
					{
						conflickIp = true;
						_arrUserInfo[i].showSameIp();
						_arrUserInfo[j].showSameIp();
					}
				}
			}
			
			
			if (timerHideIpBoard) 
			{
				timerHideIpBoard.stop();
				timerHideIpBoard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
			}
			
			if (conflickIp) 
			{
				content.ipBoard.visible = true;
				getIpAllPlayer();
				timerHideIpBoard = new Timer(1000, 3);
				timerHideIpBoard.addEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
				timerHideIpBoard.start();
			}
			
			checkShowTextNotice();
		}
		
		private function addPlayer(obj:Object):void 
		{
			//specialAvatar
			var i:int;
			var j:int;
			var count:int = 0;
			if (GameDataTLMN.getInstance().gameRoomInfo["gameState"] == "waiting") 
			{
				
				_isPlaying = false;
			}
			else 
			{
				_isPlaying = true;
			}
			
			
			for (i = 0; i < 4; i++) 
			{
				_arrRealUser[i] = "";
				for (j = 0; j < obj.userList.length; j++) 
				{
					if (obj.userList[j].position == i)
					{
						_arrRealUser[i] = obj.userList[j][ConstTlmn.PLAYER_NAME];
						
					}
				}
			}
			
			for (i = 0; i < obj.userList.length; i++) 
				{
					//trace(i, obj.userList[i].userName)
					if (obj.userList[i].userName == MyDataTLMN.getInstance().myId) 
					{
						count = obj.userList[i].position;
						_myInfo.realPos = count;
						
						break;
					}
				}
				
				_numUser = obj.userList.length;
				_arrUserList = converArrAgain(count, obj.userList);
				addUsersInfo();
				
				var channelName:String = mainData.playingData.gameRoomData.channelName;
				
				content.txtNotice.text = "SÂM - " + channelName + " - Bàn " 
										+ String(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID]) + " - Cược "
										+ format(Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]));
										
			if (obj.userList.length == 1) 
			{
				
				checkShowTextNotice();
				//content.ruleDescription.y = content.channelNameAndRoomId.y;
			}
			else 
			{
				
				var waiting:Boolean = true;
				for (i = 0; i < obj.userList.length; i++) 
				{
					if (obj.userList[i].remaningCard > 0) 
					{
						waiting = false;
						break;
					}
				}
				
			}
			
			
			checkShowTextNotice();
			
			var conflickIp:Boolean = false;
			
			for (i = 1; i < _arrUserList.length; i++) 
			{
				if (_arrUserList[0].ip == _arrUserList[i].ip) 
				{
					conflickIp = true;
					_myInfo.showSameIp();
					_arrUserInfo[i - 1].showSameIp();
				}
				
				for (j = 0; j < _arrUserList.length; j++) 
				{
					if (_arrUserList[i].ip == _arrUserList[j].ip && _arrUserList[i].userName != _arrUserList[j].userName) 
					{
						conflickIp = true;
						_arrUserInfo[i - 1].showSameIp();
					}
				}
			}
			
			if (timerHideIpBoard) 
			{
				timerHideIpBoard.stop();
				timerHideIpBoard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
			}
			
			if (conflickIp) 
			{
				content.ipBoard.visible = true;
				getIpAllPlayer();
				timerHideIpBoard = new Timer(1000, 3);
				timerHideIpBoard.addEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
				timerHideIpBoard.start();
			}
			
		}
		
		private function addPlayerInfo():void 
		{
			_arrUserInfo = [];
			//var count:int = 0;
			var i:int;
			for (i = 0; i < 3; i++) 
			{
				_userInfo = new PlayerInfoTLMN(i);
				content.addChild(_userInfo);
				////trace(count)
				switch (i) 
				{
					case 0:
						_userInfo.x = 840;
						_userInfo.y = 145;
					break;
					case 1:
						_userInfo.x = 592;
						_userInfo.y = 48;
					break;
					case 2:
						_userInfo.x = 0;
						_userInfo.y = 145;
					break;
					default:
				}
				
				//_userInfo.visible = false;
				_arrUserInfo.push(_userInfo);
				_userInfo.addEventListener("showInfo", onShowInfo);
				_userInfo.addEventListener("kick", onClickKick);
				_userInfo.addEventListener("add friend", onAddFriend);
				_userInfo.addEventListener("remove friend", onRemoveFriend);
				_userInfo.addEventListener(ConstTlmn.INVITE, onClickInvite);
				//_userInfo.addcarddeck();
				//count++;
			}
			
			_myInfo = new MyInfoTLMN(this);
			content.addChild(_myInfo);
			_myInfo.x = 60;
			_myInfo.y = 372;
			_myInfo.addEventListener("showInfo", onShowMyInfo);
			_myInfo.addEventListener("next turn", onClickNextTurn);
			_myInfo.addEventListener("hit card", onClickHitCard);
			_myInfo.addEventListener(ConstTlmn.READY, onClickReady);
		}
		
		private function onShowMyInfo(e:Event):void 
		{
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].onClose(null);
			
			}
			_myInfo.onClose(null);
			
			_myInfo.showContextMenu();
			content.setChildIndex(_myInfo, content.numChildren - 1);
		}
		
		private function onShowInfo(e:Event):void 
		{
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].onClose(null);
			
			}
			_myInfo.onClose(null);
			var user:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			content.setChildIndex(user, content.numChildren - 1);
			user.showContextMenu();
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].onClose(null);
			
			}
			_myInfo.onClose(null);
			
			_myInfo.showContextMenu();
			content.setChildIndex(_myInfo, content.numChildren - 1);
			content.setChildIndex(content.samNotice, content.numChildren - 1);
		}
		
		private function onShowContextMenu(e:Event):void 
		{
			
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].onClose(null);
			
			}
			_myInfo.onClose(null);
			var user:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			content.setChildIndex(user, content.numChildren - 1);
			content.setChildIndex(content.samNotice, content.numChildren - 1);
			user.showContextMenu();
		}
		
		private function onAddFriend(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			_userInfo = player;
			electroServerCommand.makeFriend(player._userName, DataField.IN_GAME_ROOM);
			
		}
		
		private function onConfirmWindowAddFriend(e:Event):void 
		{
			windowLayer.closeAllWindow();
		}
		
		private function onRemoveFriend(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			_userInfo = player;
			electroServerCommand.removeFriend(player._userName, DataField.IN_GAME_ROOM);
			
		}
		
		private function onClickReady(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			electroServerCommand.readyPlay();
		}
		
		private function onClickKick(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			electroServerCommand.kickUser(e.target._userName);
		}
		
		/**
		 * add thong tin cua 3 nugoi choi con lai
		 * @param	obj: user list
		 */
		private function addUsersInfo(startGame:Boolean = false):void 
		{
			var i:int;
			var checkEvent:Boolean = false;
			
			if (GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId) 
			{
				_arrUserList[0].isMaster = true;
				
				checkShowTextNotice();
			}
			else 
			{
				_arrUserList[0].isMaster = false;
				checkShowTextNotice();
			}
			var rd:int;
			
			if (_myInfo._userName == "") 
			{
				isMeJoinRoom = true;
				
				if (isMeJoinRoom && _numUser > 1) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						
						if (MyDataTLMN.getInstance().sex) 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_JOINGAME_ + String(rd + 1) );
						}
						else 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_JOINGAME_ + String(rd + 1) );
						}
					}
				}
			}
		
			_myInfo.addInfoForMe(_arrUserList[0].userName, _arrUserList[0].money, _arrUserList[0].avatar, 
									_arrUserList[0].remaningCard, _arrUserList[0].level,
									_arrUserList[0].isMaster, _isPlaying, _arrUserList[0].displayName, _arrUserList[0].ready,
									_arrUserList[0].ip, _arrUserList[0].deviceId, _arrUserList[0].win, _arrUserList[0].lose);
			//
			MyDataTLMN.getInstance().myMoney[0] = String(_arrUserList[0].money);
			mainData.chooseChannelData.myInfo.money = Number(_arrUserList[0].money);
			if (_arrUserList[0].isMonster) 
			{
				checkEvent = true;
			}
			
			for (i = 1; i < _arrUserList.length; i++) 
			{
				
				if (_arrUserList[i]["userName"] && _arrUserInfo[i - 1]._userName == "" ) 
				{
					
					if (_arrUserList[i].isMonster) 
					{
						checkEvent = true;
					}
					_arrUserList[i].isMaster = _arrUserList[i].isMaster;
					//_arrUserInfo[i - 1].removeAllCards();
					_arrUserInfo[i - 1].visible = true;
					if (_arrUserList[i].ready) 
					{
						haveUserReady = true;
					}
					
					_arrUserInfo[i - 1].getInfoPlayer(_arrUserList[i]["position"], _arrUserList[i].userName, 
														_arrUserList[i].money, _arrUserList[i].avatar,
													_arrUserList[i].numCard, String(_arrUserList[i].level), 
													_arrUserList[i].ready, _isPlaying, _arrUserList[i].isMaster, 
													_arrUserList[i].displayName, _arrUserList[i].sex, _arrUserList[i].ip,
													_arrUserList[i].deviceId, _arrUserList[i].win, _arrUserList[i].lose
													);
					//checkPosClock();
					if (!isMeJoinRoom) 
					{
						if (SoundManager.getInstance().isSoundOn) 
						{
							rd = int(Math.random() * 5);
							
							if (_arrUserList[i].sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_JOINGAME_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_JOINGAME_ + String(rd + 1) );
							}
						}
					}
					
				}
				
			}
			startGame = false;
			isMeJoinRoom = false;
			
			if (checkEvent) 
			{
				content.boardEvent.visible = true;
			}
			else 
			{
				content.boardEvent.visible = false;
			}
			
		}
		
		/**
		 * 
		 * @param	pos: vi tri cua minh trong mang --> 0, 1, 2, 3
		 * @param	arr: mang user
		 * @return
		 */
		private function converArrAgain(pos:int, arr:Array):Array 
		{
			var i:int;
			var j:int;
			var count:int = pos;
			
			var obj:Object;
			var arrAgain:Array = [];
			var haveMe:Boolean = false;
			var current:int;
			
			
			for (i = 0; i < 4; i++) 
			{
				if (arr[i][ConstTlmn.POSSITION] == pos) 
				{
					arrAgain[0] = arr[i];
					current = pos + 1;
					haveMe = true;
					break;
				}
				
			}
			
			var done:Boolean = false;
			for (i = 0; i < 4; i++) 
			{
				if (current < 4) 
				{
					if (arr[i] && arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[1] = arr[i];
						
						done = true;
						break;
					}
					
				}
				else 
				{
					current = 0;
					
					if (arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[1] = arr[i];
						done = true;
						break;
					}
				}
			}
			
			if (!done) 
			{
				obj = new Object();
				arrAgain[1] = obj;
				
			}
			done = false;
			current++;
			
			for (i = 0; i < 4; i++) 
			{
				if (current < 4) 
				{
					if (arr[i] && arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[2] = arr[i];
						
						done = true;
						break;
					}
					
				}
				else 
				{
					current = 0;
					
					if (arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[2] = arr[i];
						done = true;
						break;
					}
				}
			}
			
			if (!done) 
			{
				obj = new Object();
				arrAgain[2] = obj;
				
			}
			done = false;
			current++;
			
			for (i = 0; i < 4; i++) 
			{
				if (current < 4) 
				{
					if (arr[i] && arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[3] = arr[i];
						
						done = true;
						break;
					}
					
				}
				else 
				{
					current = 0;
					
					if (arr[i][ConstTlmn.POSSITION] == current) 
					{
						arrAgain[3] = arr[i];
						done = true;
						break;
					}
				}
			}
			
			if (!done) 
			{
				obj = new Object();
				arrAgain[3] = obj;
				
			}
			done = false;
			current++;
			
			return arrAgain;
		}
		
		private function checkShowTextNotice():void 
		{
			_waitToReady.visible = false;
			_waitToStart.visible = false;
			if (_isPlaying) 
			{
				if (_myInfo._isPlaying) 
				{
					content.noticeForUserTxt.text = "";
				}
				else 
				{
					content.noticeForUserTxt.text = "";// "BÀN CHƠI ĐANG DIỄN RA, XIN VUI LÒNG ĐỢI GIÂY LÁT!";
				}
				
				content.startGame.visible = false;
			}
			else 
			{
				if (_numUser > 1) 
				{
					//trace("numuser > 1: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
					if (GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId) 
					{
						var count:int = 0;
						for (var i:int = 0; i < _arrUserInfo.length; i++) 
						{
							//trace("count++", _arrUserInfo[i].ready)
							if (_arrUserInfo[i].ready) 
							{
								//trace("count++")
								count++;
							}
						}
						//trace("count++", count)
						if (count > 0) 
						{
							content.noticeForUserTxt.text = "";//"ĐÃ CÓ THỂ BẮT ĐẦU VÁN CHƠI!";
							content.startGame.visible = true;
						}
						else 
						{
							_waitToReady.visible = true;
							content.noticeForUserTxt.text = "";// "ĐỢI NGƯỜI CHƠI KHÁC SẴN SÀNG!";
							content.startGame.visible = false;
						}
					}
					else 
					{
						if (_myInfo._ready) 
						{
							_waitToStart.visible = true;
							content.noticeForUserTxt.text = "";// "ĐỢI CHỦ BÀN BẮT ĐẦU!";
						}
						else 
						{
							content.noticeForUserTxt.text = "";// "HÃY SẴN SÀNG ĐỂ BẮT ĐẦU CHƠI GAME!";
						}
					}
				}
				else 
				{
					content.startGame.visible = false;
					content.noticeForUserTxt.text = "";// "HÃY ĐỢI THÊM NGƯỜI THAM GIA ĐỂ CHƠI GAME!";
				}
				
			}
		}
		
	}

}