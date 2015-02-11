package view.screen 
{
	
	
	
	import com.greensock.TweenMax;
	import control.ConstTlmn;
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import event.DataFieldMauBinh;
	import event.DataFieldPhom;
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	import inapp_purchase.IAPManager;
	import request.HTTPRequest;
	import sound.SoundLib;
	import view.ScrollView.ScrollViewYun;
	import view.window.AddMoneyWindow2;
	import view.window.BaseWindow;
	
	import logic.CardsTlmn;
	import model.MainData;
	import model.modelField.ModelFieldTLMN;
	import model.playingData.PlayingScreenActionTlmn;
	import view.Base;
	import view.card.CardTlmn;
	import view.effectLayer.EffectLayer;
	
	import view.window.AlertWindow;
	import view.window.ConfirmWindow;
	import view.window.OrderCardWindow;
	import view.window.ResultWindowTlmn;
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
	import view.card.CardTlmn;
	import model.GameDataTLMN;
	
	import model.MyDataTLMN;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import sound.SoundManager;
	
	import view.card.CardDeck;
	import view.clock.Clock;
	
	
	import view.screen.play.ContextMenu;
	
	import view.screen.play.MyInfoTLMN;
	import view.screen.play.PlayerInfoTLMN;
	
	import view.window.InvitePlayWindow;
	import view.window.ResultWindow;
	
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class PlayGameScreenTlmn extends Base 
	{
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:ElectroServerCommandTlmn = mainCommand.electroServerCommand;
		private var mainData:MainData = MainData.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance(); // windowLayer để mở cửa sổ bất kỳ
		private var _chatBox:ChatBoxPhom;;
		//private var _smallButton:SmallButton;
		///private var _bigButton:BigButton;
		private var _myInfo:MyInfoTLMN;
		private var _userInfo:PlayerInfoTLMN;
		private var _card:CardTlmn;
		private var _contextMenu:ContextMenu;
		
		
		//private var _waitToPlay:Sprite;
		private var _waitToReady:Sprite;
		private var _waitToStart:Sprite;
		
		/**
		 *  userinfo// mang chua 3 playerinfo con lai
		 * userlist: tong so user trong phong
		 */
		private var _arrUserInfo:Array;
		private var _arrUserList:Array;
		private var _isPlaying:Boolean;
		
		private var _cardsName:String;
		private var _containCard:Sprite;//chua cac quan bai danh ra
		private var _textfield:TextField;
		
		public var _arrLastCard:Array = []; // nhung quan bai duoc danh ra truoc do
		public var _userLastDisCard:String = ""; // nhung quan bai duoc danh ra truoc do
		
		private var _resultWindow:ResultWindowTlmn;
		
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
		private var _arrCardDiscard:Array = [];
		
		private var heartbeart:Timer;
		
		private var chatLayer:Sprite;
		private var gameLayer:Sprite;
		
		private var _containerChatEmo:Sprite;
		
		private var confirmExitWindow:ConfirmWindow;
		private var _numUser:int;
		private var sharedObject:SharedObject;
		private var isMeJoinRoom:Boolean;
		//private var _containerWhiteWin:Sprite;
		//private var arrChat:Array = [];
		
		private var dealcard:int = 0;
		private var timerDealCard:Timer;
		
		private var _containerSpecial:Sprite;
		private var _timerShowSpecial:Timer;
		//private var _containerWinLose:Sprite;
		//private var arrCardSpecial:Array = [];
		private var _contanierCardOutUser:Sprite;
		
		private var _arrRealUser:Array = [];
		private var timerToGetSystemNoticeInfo:Timer;
		
		private var _haveUserReady:Boolean = false;
		private var haveUserReady:Boolean = false; //da co nguoi choi san sang, chi tinh khi get playing info
		private var _timerKickMaster:Timer;
		private var _countTimerkick:int;
		private var _timerKick:int = 15;
		
		private var emoWindow:Sprite;
		private var emoArray:Array;
		private var playingLayer:Sprite;
		private var _arrEmoForUser:Array = [];
		private var _timerShowEmo:Timer;
		
		private var _stageGame:int = 0;
		private var _arrCardSave:Array = [];
		private var _containCardSave:Sprite;
		
		private var is3bich:Boolean;
		private var timerHideIpBoard:Timer;
		
		public function PlayGameScreenTlmn() 
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
			
			content.noc.gotoAndStop(1);
			
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
			
			/*var j:int;
			var arrTest:Array = [1, 2, 4, 5, 6, 7, ,8, 9 , 10, 11, 12, 13];
			for (j = 0; j < arrTest.length; j++) 
			{
				var card:CardTlmn = new CardTlmn(arrTest[j]);
				card.x = 102 + 34 * j;
				card.y = 110;
				card.scaleX = card.scaleY = .8;
				_containCard.addChild(card);
				_arrCardDiscard.push(card);
			}
			
			_containCard.x = 176;
			_containCard.y = 155;*/
			
			containerCardResult = new Sprite();
			content.addChild(containerCardResult);
			_arrCardListOtherUser = [];
			
			content.dut3bich.visible = false;
			
			GameDataTLMN.getInstance().playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			
			var textfieldVer:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = 0xffffff;
			txtFormat.size = 11;
			textfieldVer.defaultTextFormat = txtFormat;
			textfieldVer.text = mainData.version;
			textfieldVer.x = 840;
			textfieldVer.y = 5;
			textfieldVer.width = 40;
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
			
			/*var j:int;
			var arrTest:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 40, 44, 36];
			//var arrTest:Array = [1];
			for (j = 0; j < _arrUserInfo.length; j++) 
			{
				addCardImage(arrTest, j);
			}*/
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
					electroServerCommand.sendPublicChat(_myInfo._userName, _myInfo._displayName, emoArray[i].name, true);
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
		
		
		
		public function effectOpen():void
		{
			
		}
		
		public function effectClose():void
		{
			removeAllEvent();
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
				
				case PlayingScreenActionTlmn.UPDATE_MONEY: // update tiền
					//listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
					listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
				break;
				
				case PlayingScreenActionTlmn.UPDATE_MONEY_SPECIAL: // update tiền
					listenUpdateMoney(e.data[ModelFieldTLMN.DATA]);
				break;
				
				case PlayingScreenActionTlmn.ERROR:
					listenErrorDiscard();
				break;
				
			}
		}
		
		private function listenRoomMasterKick(obj:Object):void 
		{
			var i:int;
			////trace("thang bi kick la minh: ", obj[DataField.USER_NAME] , MyDataTLMN.getInstance().myId)
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				writelog("roomMaster kick --> out room");
				okOut();
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.roomMasterKick);
				windowLayer.openWindow(kickOutWindow);
				
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
		
		private function listenEndRound(obj:Object):void 
		{
			GameDataTLMN.getInstance().finishRound = true;
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
			
			dealcard = 0;
			content.noc.visible = true;
			if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId) 
			{
				_myInfo._isMyTurn = true;
			}
			
			timerDealCard = new Timer(200, 3);
			//timer.addEventListener(TimerEvent.TIMER, dealingCard);
			timerDealCard.addEventListener(TimerEvent.TIMER, onCompleteDealCard);
			timerDealCard.start();
			
			if (obj[DataField.PLAYER_CARDS]) 
			{
				_myInfo._ready = true;
				_myInfo.dealCard(obj[DataField.PLAYER_CARDS]);
				writelog("deal card for me");
				
			}
			else 
			{
				_isPlaying = false;
				canExitGame = true;
				
				_myInfo.hideReady();
			}
			
			timerDealcardForme = new Timer(250, 13);
			timerDealcardForme.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
			timerDealcardForme.start();
			
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
				checkPosClock();
			}
			
		}
		
		private function listenUserReady(obj:Object):void 
		{
			////trace("thang ready: ", obj[DataField.USER_NAME] , MyDataTLMN.getInstance().myId)
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.READY_SOUND);
			}
			
			////trace("nut bat dau: ", _isPlaying, GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
			
			
			
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				_myInfo.myReady();
				writelog("user ready");
			}
			else 
			{
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					//trace("thang ready ko phai minh: ", obj[DataField.USER_NAME] , _arrUserInfo[i]._userName)
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
			if (GameDataTLMN.getInstance().master == _myInfo._userName) 
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
		
		private function onKickOutWindowCloseComplete(e:Event):void 
		{
			windowLayer.closeAllWindow();
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
			
			//trace(obj[ConstTlmn.MASTER], "la chu phong moi")
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
			
			////trace("sua khi thay bo luot da het vong hay chua: ", GameDataTLMN.getInstance().finishRound)
			if (GameDataTLMN.getInstance().finishRound) 
			{
				content.specialCard.visible = false;
				_arrLastCard = [];
				var cardChilds:Array = [];
				_userLastDisCard = "";
				removeAllDisCard();
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
			////trace(obj);
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
				SoundManager.getInstance().playSound(SoundLib.WHITE_WIN_SOUND);
			}
			
			_myInfo.killAllTween();
			_myInfo.removeAllCard();
			
			if (timerDealCard) 
			{
				timerDealCard.stop();
				timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
			}
			canExitGame = true;
			content.noc.visible = false;
			_stageGame = 2;
			
			content.noticeForUserTxt.text = "";
			content.noticeForUserTxt.visible = false;
			GameDataTLMN.getInstance().firstGame = false;
			content.noticeMc.visible = false;
			
			_haveUserReady = false;
			
			if (timerDealcardForme) 
			{
				timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
				timerDealcardForme.stop();
			}
			
			if (obj["winner"] == MyDataTLMN.getInstance().myId) 
			{
				if (MyDataTLMN.getInstance().sex) 
				{
					if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (_arrUserInfo[j]._sex) 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
						}
						else 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
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
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
							}
						}
						
						break;
					}
				}
			}
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].reset();
				_arrUserInfo[i].killAllTween();
				_arrUserInfo[i].removeAllCards();
			}
			
			var card:CardTlmn;
			
			for (i = 0; i < obj[ConstTlmn.PLAYER_LIST].length; i++) 
			{
				if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == obj["winner"]) 
				{
					var arrCardWin:Array = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS];
					arrCardWin = arrCardWin.sort(Array.NUMERIC);
					for (j = 0; j < arrCardWin.length; j++) 
					{
						card = new CardTlmn(arrCardWin[j]);
						card.x = 102 + 34 * j;
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
						card.x = _myInfo.x + 180 + 50 * j;
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
			
			
			
			_containCard.x = 176;
			_containCard.y = 155;
			content.specialCard.gotoAndStop(6);
			content.specialCard.visible = true;
			content.whiteWin.gotoAndStop(convertWhiteWin(obj["whiteWinType"]));
			content.whiteWin.visible = true;
			//content.whiteWin.x = 390;
			
			content.setChildIndex(content.whiteWin, content.numChildren - 1);
			
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
			////trace(obj)
			
			//listenGameOver(obj);
		}
		
		private function onResetGame(e:TimerEvent):void 
		{
			_stageGame = 0;
			whiteWin = false;
			_isPlaying = false;
			removeAllDisCard();
			content.specialCard.visible = false;
			content.whiteWin.visible = false;
			if (_resultWindow) 
			{
				_resultWindow.visible = true;
				content.setChildIndex(_resultWindow, content.numChildren - 1);
				_resultWindow.open(_myInfo._isPlaying);
				_resultWindow.addEventListener("close", onCloseResultWindow);
				_resultWindow.addEventListener("out game", onOutGame);
			}
			checkShowTextNotice()
			if (Number(MyDataTLMN.getInstance().myMoney[0]) < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
			{
				EffectLayer.getInstance().removeAllEffect();
				
				GameDataTLMN.getInstance().notEnoughMoney = true;
				
				//okOut();
			}
		}
		
		private function convertWhiteWin(type:String):int 
		{
			var result:int;
			switch (type) 
			{
				case "0":
					result = 2;
				break;
				case "1":
					result = 8;
				break;
				case "2":
					result = 1;
				break;
				case "3":
					result = 5;
				break;
				case "4":
					result = 6;
				break;
				case "5":
					result = 3;
				break;
				case "6":
					result = 8;
				break;
				case "8":
					result = 7;
				break;
				case "7":
					result = 9;
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
				
				////trace(GameDataTLMN.getInstance().currentPlayer, MyDataTLMN.getInstance().myId, "thằng nào có đồng hồ chạy", _isPlaying)
				if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
				{
					if (GameDataTLMN.getInstance().firstGame) 
					{
						//content.noticeForUserTxt.text = "Đánh lá bài hoặc bộ bài bé nhất!";
						//content.txtNotice.text = "Đánh cây hoặc bộ bé nhất!";
						//content.noticeForUserTxt.visible = true;
						content.noticeMc.visible = true;
						content.noticeMc.gotoAndPlay(1);
					}
					
					if ((_cardsName == "Đôi 2" || _cardsName == "Hai" || _cardsName == "3 đôi thông" ||
						_cardsName == "4 đôi thông" || _cardsName == "Tứ quí" ) && _myInfo._isPassTurn)
					{
						content.noticeSpecialCard.visible = true;
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
				//trace("het gio luot dau tien")
				_myInfo._arrCardChoose = [_myInfo._arrCardFirst[0]];
				_myInfo._isMyTurn = false;
				electroServerCommand.myDisCard(_myInfo._arrCardChoose);
				_myInfo._arrCardChoose = [];
				GameDataTLMN.getInstance().firstPlayer = "";
			}
			else 
			{
				//_myInfo.nextturn();
				onClickNextTurn(null);
			}
			
		}
		
		private function getCurrentPlayer(obj:Object):void 
		{
			
			//trace("den luot ai: ", GameDataTLMN.getInstance().currentPlayer , MyDataTLMN.getInstance().myId , _isPlaying)
			if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
			{
				
				if (_myInfo) 
				{
					
					_myInfo._isMyTurn = true;
					//trace("endround den luot minh")
					//_myInfo.checkHitOrPassTurn();
				}
				
				
			}
			
			//checkPosClock();
			
				
			
		}
		
		private function listenGameOver(obj:Object):void 
		{
			_isPlaying = false;
			_stageGame = 2;
			GameDataTLMN.getInstance().finishRound = false;
			_cardsName = "";
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
			
			var str:String;
			
			content.noticeForUserTxt.text = "";
			content.noticeForUserTxt.visible = false;
			GameDataTLMN.getInstance().firstGame = false;
			content.noticeMc.visible = false;
			_haveUserReady = false;
			
			var i:int;
			var j:int;
			var rd:int;
			
			
			if (is3bich) 
			{
				content.dut3bich.visible = true;
			}
			
			
			canExitGame = true;
			
			timerShowResult = new Timer(3000, 1);
			timerShowResult.addEventListener(TimerEvent.TIMER_COMPLETE, onShowResult);
			timerShowResult.start();
			
			if (_resultWindow) 
			{
				
				_resultWindow.setInfo(obj);
				
			}
			
			
			_myInfo.allButtonVisible();
			//_myInfo.removeAllCard();
			_myInfo.stopTimer();
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].removeAllCards();
				_arrUserInfo[i].stopTimer();
				_arrUserInfo[i].reset();
			}
			_myInfo._cheater = false;
			
			var arrResult:Array = obj["resultArr"];
			var result:Number = Number(String(MyDataTLMN.getInstance().myMoney[0]).replace(",", ""));
			
			var userResult:String;
			
			for (i = 0; i < arrResult.length; i++) 
			{
				//trace(i, "check cac thang dc add card: ", arrResult[i][ConstTlmn.PLAYER_NAME] , MyDataTLMN.getInstance().myId)
				
				userResult = arrResult[i][ConstTlmn.PLAYER_NAME];
				
				var outGame:Boolean = false;
				var objResult:Object;
				//trace("check cac thang dc add card: ", userResult , MyDataTLMN.getInstance().myId)
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
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
							}
						}
					}
				}
				else 
				{
					//trace("tien su may; ", userResult )
					for (j = 0; j < _arrUserInfo.length; j++) 
					{
						//trace(i, "thang nao dc add card; ", userResult , _arrUserInfo[j]._userName)
						
						if (userResult == _arrUserInfo[j]._userName)
						{
							if (arrResult[i][ConstTlmn.SUB_MONEY] > 0) 
							{
								if (SoundManager.getInstance().isSoundOn) 
								{
									rd = int(Math.random() * 5);
									if (_arrUserInfo[j]._sex) 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_WIN_ + String(rd + 1) );
									}
									else 
									{
										SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_WIN_ + String(rd + 1) );
									}
								}
							}
				
							_arrUserInfo[j]._isPlaying = true;
							objResult = new Object();
							//trace("user nay co bao nhieu tien: ", arrResult[i][ConstTlmn.SUB_MONEY])
							objResult[ConstTlmn.MONEY] = arrResult[i][ConstTlmn.SUB_MONEY];
							objResult[ConstTlmn.CARDS] = arrResult[i][ConstTlmn.CARDS];
							
							_arrUserInfo[j].showEffectGameOver(objResult);
							
							addCardImage(arrResult[i][ConstTlmn.CARDS], _arrUserInfo[j]._pos);
							break;
						}
					}
				}
			}
			
		}
		
		private function addCardImage(arr:Array, pos:int):void 
		{
			//trace("card cua cac user: ", arr)
			//trace("card cua cac user: ", pos)
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
					card.y = _arrUserInfo[0].y - 50 + (13 - arr.length) * 18 + 18 * i;
				}
				else if (pos == 2)
				{
					card.rotation = 90;
					card.x = _arrUserInfo[2].x + 233;
					card.y = _arrUserInfo[2].y - 50 + (13 - arr.length) * 18 + 18 * i;
				}
				else 
				{
					card.x = _arrUserInfo[1].x - 262 + (13 - arr.length) * 18 + 18 * i;
					card.y = _arrUserInfo[1].y + 30;
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
			/*for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].removeAllCards();
				_arrUserInfo[i].stopTimer();
			}*/
			
			if (Number(MyDataTLMN.getInstance().myMoney[0]) < Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
			{
				EffectLayer.getInstance().removeAllEffect();
				
				
				GameDataTLMN.getInstance().notEnoughMoney = true;
				//okOut();
			}
			
			checkShowTextNotice();
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
			
			
			
			if (GameDataTLMN.getInstance().notEnoughMoney) 
			{
				outedGame = true;
				writelog("not enogh money --> out room");
				okOut();
				GameDataTLMN.getInstance().notEnoughMoney = false;
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					windowLayer.isNoCloseAll = true;
					var kickOutWindow:AddMoneyWindow2 = new AddMoneyWindow2();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
			}
			else 
			{
				_resultWindow.removeEventListener("close", onCloseResultWindow);
				_resultWindow.removeEventListener("out game", onOutGame);
					
				removeAllDisCard();
				
				removeAllCardResult();
				
				if (_resultWindow) 
				{
					_resultWindow.visible = false;
				}
				writelog("game over, remove all card close result window");
				_myInfo.removeAllCard();
				_myInfo.visibleResultGame();
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					_arrUserInfo[i].removeAllCards();
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
			//trace("click bat dau: ")
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
			}
			if (_arrUserList) 
			{
				//trace(_arrUserList)
			}
			if (_arrUserList && _arrUserList.length > 1) 
			{
				if (Object(_arrUserList[1]).hasOwnProperty("userName") || Object(_arrUserList[2]).hasOwnProperty("userName") 
						|| Object(_arrUserList[3]).hasOwnProperty("userName")) 
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
			_stageGame = 1;
			
			_isPlaying = true;
			
			
			if (obj[DataField.MESSAGE] == "testGame") 
			{
				checkPosClock();
			}
			checkShowTextNotice();
			
			writelog("start game");
		}
		
		private function onCompleteDealCard(e:TimerEvent):void 
		{
			
			var arr:Array = [];
			
			//trace("1 lan vao thang chia bai", dealcard)
			for (var j:int = dealcard; j < _arrUserInfo.length; j++) 
			{
				//trace("xem thang nao vua dc chia: ", j, _arrUserInfo[j].ready, _arrUserInfo[j]._userName , GameDataTLMN.getInstance().master)
				if (_arrUserInfo[j].ready || _arrUserInfo[j]._userName == GameDataTLMN.getInstance().master) 
				{
					_arrUserInfo[j].dealCard(arr);
					if (j == 2) 
					{
						if (timerDealCard) 
						{
							//trace("da di du qua 3 thang")
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
					//trace("co 1 thang duowc chia: ", dealcard)
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
			//trace("====== cac quan danh ra =====")
			//trace(e.target._arrCardChoose)
			electroServerCommand.myDisCard(e.target._arrCardChoose);
		}
		
		//danh quan bai noa
		
		private function listenHaveCard(obj:Object):void 
		{
			////trace(obj)
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
			
			//trace("thang danh cuoi cung: ", _userLastDisCard)
			if (_userLastDisCard == "") 
			{
				_userLastDisCard = obj.userName;
			}
			else 
			{
				if (obj.userName == _myInfo._userName) 
				{
					
					_myInfo.chatde(true);
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						
						if (_arrUserInfo[i]._userName && _userLastDisCard == _arrUserInfo[i]._userName) 
						{
							_arrUserInfo[i].chatde(false);
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
							_arrUserInfo[i].chatde(true);
							break;
						}
					}
					
					if (_userLastDisCard == _myInfo._userName) 
					{
						_myInfo.chatde(false);
					}
					
					for (i = 0; i < _arrUserInfo.length; i++)
					{
						
						if (_arrUserInfo[i]._userName && _userLastDisCard == _arrUserInfo[i]._userName) 
						{
							_arrUserInfo[i].chatde(false);
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
				
				_myInfo.onCompleteNextturn();
				
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
				
				GameDataTLMN.getInstance().finishRound = false;
			}
			
			GameDataTLMN.getInstance().firstPlayer = "";
			content.noticeForUserTxt.text = "";
			GameDataTLMN.getInstance().firstGame = false;
			content.noticeMc.visible = false;
			
			checkPosClock();
			
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
			//trace("thang nao dang danh bai: ", userName)
			
			if (userName == _myInfo._userName) 
			{
				//trace("bai tu minh di ra: ", _myInfo._userName)
				_containCard.x = _myInfo.x + 200;
				_containCard.y = _myInfo.y - 20;
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					//trace("bai tu thang nao di ra: ", _arrUserInfo[i]._userName)
					if (_arrUserInfo[i]._userName && userName == _arrUserInfo[i]._userName) 
					{
						//trace("bai tu thang nao di ra trong if: ", _arrUserInfo[i]._userName)
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
			
			for (i = 0; i < arr.length; i++) 
			{
				var angel:int = int(Math.random() * 15);
				var card:CardTlmn = new CardTlmn(arr[i]);
				//card.rotation = angel;
				card.scaleX = card.scaleY = .75;
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
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i]._userName == userName) 
				{
					if (_myInfo._cheater) 
					{
						_arrUserInfo[i].removeCardImage(arr);
					}
					else 
					{
						_arrUserInfo[i].removeCardDeck(arr.length);
					}
					
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
			//TweenMax.to(_containCard, 1, { x:(this.width - _containCard.width) / 2, y:(this.height = _containCard.height) / 2 } );
			TweenMax.to(_containCard, .5, { x:(1024 - _containCard.width) / 2, y:250} );
			//_containCard.x = (this.width - _containCard.width) / 2;
			//_containCard.y = (this.height - _containCard.height) / 2;
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
		
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.OUT_ROOM_SOUND);
				
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
			//trace("co user out room: ", _arrUserList)
			
			for (i = 0; i < _arrUserList.length; i++) 
			{
				
				if (_arrUserList[i])
				{
					if ((_arrUserList[i]).userName == data[DataField.USER_NAME])
					{
						
						_arrUserList.splice(i, 1);
					}
				}
			}
			
			
			
			
			//trace("co user out room: ", _arrUserList)
			//trace("co user out room: ", _isPlaying, MyDataTLMN.getInstance().myId , data["master"])
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
			
			checkPosClock();
		}
		
		public function removeAllEvent():void 
		{
			if (content) 
			{
				content.settingBoard.onSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
				content.settingBoard.offSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
				content.settingBoard.onMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
				content.settingBoard.offMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
				content.emoBtn.removeEventListener(MouseEvent.CLICK, onEmoticonButtonClick);
				var i:int;
				for (i = 0; i < emoArray.length; i++) 
				{
					
					emoArray[i].removeEventListener(MouseEvent.MOUSE_UP, onEmoClick);
					
				}
				
				for (i = 0; i < _arrEmoForUser.length; i++) 
				{
					var timer:Timer = _arrEmoForUser[i][1];
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShowEmo);
					timer.stop();
					
					_arrEmoForUser[i][0].parent.removeChild(_arrEmoForUser[i][0]);
				}
				
				haveUserReady = false;
				
				if (timerHideIpBoard) 
				{
					timerHideIpBoard.stop();
					timerHideIpBoard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHidIpBoard);
				}
				
				if (_timerKickMaster) 
				{
					_timerKickMaster.removeEventListener(TimerEvent.TIMER_COMPLETE, onKickMaster);
					_timerKickMaster.removeEventListener(TimerEvent.TIMER, onTimerKickMaster);
					_timerKickMaster.stop();
				}
				
				content.signOutBtn.removeEventListener(MouseEvent.CLICK, onClickSignOutGame);
				content.settingBoard.fullBtn.removeEventListener(MouseEvent.CLICK, onClickFullGame);
				content.settingBoard.ipBtn.removeEventListener(MouseEvent.CLICK, onClickIPGame);
				content.settingBoard.guideBtn.removeEventListener(MouseEvent.CLICK, onClickGuidGame);
				
				content.startGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
				
				_arrRealUser = [];
				
				for (i = 0; i < _arrUserInfo.length; i++) 
				{
					_arrUserInfo[i].removeAllEvent();
					_arrUserInfo[i].removeEventListener("showInfo", onShowInfo);
					_arrUserInfo[i].removeEventListener("kick", onClickKick);
					_arrUserInfo[i].removeEventListener("add friend", onAddFriend);
					_arrUserInfo[i].removeEventListener("remove friend", onRemoveFriend);
					_arrUserInfo[i].removeEventListener(ConstTlmn.INVITE, onClickInvite);
					
				}
				
				
				
				mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
				if (timerToGetSystemNoticeInfo)
				{
					timerToGetSystemNoticeInfo.removeEventListener(TimerEvent.TIMER, onGetSystemNoticeInfo);
					timerToGetSystemNoticeInfo.stop();
				}
				
				if (heartbeart) 
				{
					heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
					heartbeart.stop();
				}
				
				_myInfo.removeAllEvent();
				_myInfo.removeEventListener("showInfo", onShowMyInfo);
				_myInfo.removeEventListener("next turn", onClickNextTurn);
				_myInfo.removeEventListener("hit card", onClickHitCard);
				_myInfo.removeEventListener(ConstTlmn.READY, onClickReady);
				_myInfo._userName = "";
				
				_chatBox.removeAllChat();
				GameDataTLMN.getInstance().removeEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
				_chatBox.removeEventListener(ChatBox.HAVE_CHAT, onHaveChat);
				_chatBox.removeEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
				chatLayer.removeChild(_chatBox);
				
				//GameDataTLMN.getInstance().removeEventListener(ConstTlmn.ADD_FRIEND, onUpdateAddFriend);
				GameDataTLMN.getInstance().playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
				
				_resultWindow.removeEventListener("close", onCloseResultWindow);
				_resultWindow.removeEventListener("out game", onOutGame);
				
				GameDataTLMN.getInstance().autoReady = false;
				
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
				if (timerDealcardForme) 
				{
					timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
					timerDealcardForme.stop();
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
				
				var check:int = content.numChildren;
				for (i = 0; i < check; i++) 
				{
					content.removeChild(content.getChildAt(0));
				}
				
				gameLayer.removeChild(content);
				content = null;
				
			}
			
		}
		
		private function addComponent():void 
		{
			if (!_textfield) 
			{
				_textfield = new TextField();
				content.addChild(_textfield);
				_textfield.x = 600;
				_textfield.y = 350;
				_textfield.defaultTextFormat = new TextFormat("arial", 24, 0x000000);
				
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
			/*if (timerToGetSystemNoticeInfo)
			{
				timerToGetSystemNoticeInfo.removeEventListener(TimerEvent.TIMER, onGetSystemNoticeInfo);
				timerToGetSystemNoticeInfo.stop();
			}
			timerToGetSystemNoticeInfo = new Timer(30000);
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
			content.settingBoard.guideBtn.addEventListener(MouseEvent.CLICK, onClickGuidGame);
			
			content.startGame.addEventListener(MouseEvent.CLICK, onClickStartGame);
			content.orderCard.addEventListener(MouseEvent.CLICK, onOrderCard);
			
			content.orderCard.visible = false;
			
			if (mainData.chooseChannelData.myInfo.name == "bim15" || mainData.chooseChannelData.myInfo.name == "haonam01")
			{
				content.orderCard.visible = true;
			}
			
			checkShowTextNotice();
			
			content.chatBtn.addEventListener(MouseEvent.CLICK, onChatButtonClick);
			
			
			
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
			
		}
		
		private function onChatButtonClick(e:MouseEvent):void 
		{
			_chatBox.visible = true;
		}
		
		private function onChatBoxBackButtonClick(e:Event):void 
		{
			_chatBox.visible = false;
			//chatButton.visible = true;
		}
		
		private function onOrderCard(e:MouseEvent):void 
		{
			//trace("order card: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myName)
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
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
			}
		}
		
		private function onClickIPGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
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
			
			content.ipBoard.nam1Txt.text = _myInfo._displayName;
			content.ipBoard.ip1Txt.text = _myInfo.myIp;
				
			for (var i:int = 1; i < 4; i++) 
			{
				if (_arrUserInfo[i - 1]._userName != "" ) 
				{
					switch (i) 
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
					
				}
			}
		}
		
		private function onClickFullGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
			}
		}
		
		public function removeEventChat():void 
		{
			GameDataTLMN.getInstance().removeEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.removeEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			_chatBox.removeEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
		}
		public function addEventChat():void 
		{
			
			GameDataTLMN.getInstance().addEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			_chatBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
		}
		
		
		private function onCreateBoardEmoChat(e:MouseEvent):void 
		{
			
		}
		
		private function onComplete(e:TimerEvent):void 
		{
			
		}
		
		private function onSendEmo(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			if (timer) 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			}
			////trace("co emo gui len ne: ", e.target.nameOfEmo)
			
			electroServerCommand.sendPublicChat(MyDataTLMN.getInstance().myId, MyDataTLMN.getInstance().myDisplayName,
													e.target.nameOfEmo, true);
		}
		
		private function onClickInvite(e:Event):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
			}
			var invitePlayWindow:InvitePlayWindow = new InvitePlayWindow();
			windowLayer.openWindow(invitePlayWindow);
		}
		
		private function onInvitePlayer(e:Event):void 
		{
			
		}
		
		private function onCloseInviteWindow(e:Event):void 
		{
			
		}
		
		private function removeAllDisCard():void 
		{
			var i:int;
			////trace("remove tat ca bai da danh ra")
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
			var rd:int;
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(SoundLib.CLICK_BUTTON_SOUND);
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
				else if (_stageGame == 0 || _stageGame == 2)
				{
					/*if (SoundManager.getInstance().isSoundOn) 
					{
						rd = int(Math.random() * 5);
						if (MyDataTLMN.getInstance().sex) 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_BYE_ + String(rd + 1) );
						}
						else 
						{
							SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_BYE_ + String(rd + 1) );
						}
						
					}
					*/
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
					
				/*if (SoundManager.getInstance().isSoundOn) 
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
					
				}*/
				outGameRoom();
			}
			
		}
		
		private function outGameRoom():void 
		{
			writelog("click out room --> out room");
			okOut();
		}
		
		public function destroy():void 
		{
			//removeAllEvent();
		}
		
		public function okOut():void 
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
			writelog("out room, remove all card");
			_myInfo.removeAllCard();
			_myInfo.removeAllEvent();
			_myInfo._isPlaying = false;
			
			_arrLastCard = [];
			_arrUserList = [];
			
			removeAllDisCard();
			
			masterUnVisible();
			
			if (_contanierCardOutUser) 
			{
				content.removeChild(_contanierCardOutUser);
				_contanierCardOutUser = null;
			}
			_isPlaying = false;
			
			
			electroServerCommand.joinLobbyRoom();
			dispatchEvent(new Event(ConstTlmn.OUT_ROOM, true));
			
			
			EffectLayer.getInstance().removeAllEffect();
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
				showEmo(GameDataTLMN.getInstance().publicChat[DataFieldMauBinh.CHAT_CONTENT], 
							GameDataTLMN.getInstance().publicChat[DataFieldMauBinh.USER_NAME], isMe);
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
			////trace(e.target.inputText.text);
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
								0, String(obj[DataField.LEVEL]), false, _isPlaying, false,
								obj[DataField.DISPLAY_NAME], sex, obj[DataField.IP], obj[DataField.DEVICE_ID],
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
				}
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					if (_arrUserInfo[i].userIp == _arrUserInfo[j].userIp && 
						_arrUserInfo[i]._userName != _arrUserInfo[j]._userName) 
					{
						conflickIp = true;
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
					////trace(i, obj.userList[i].userName)
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
				
			if (obj.userList.length == 1) 
			{
				
				
				//content.channelNameAndRoomId.text = "Bạn đang chơi ở " + String(MainData.getInstance().chooseChannelData[2]);
				content.txtNotice.text = "TIẾN LÊN - " + mainData.playingData.gameRoomData.channelName + " - Bàn " 
										+ String(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID]) + " - Cược "
										+ format(Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]));
				
				checkShowTextNotice();
				//content.ruleDescription.y = content.channelNameAndRoomId.y;
			}
			else 
			{
				content.txtNotice.text = "TIẾN LÊN - " + mainData.playingData.gameRoomData.channelName + " - Bàn " 
										+ String(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID]) + " - Cược "
										+ format(Number(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]));
										
				
				
				
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
				}
				
				for (j = 0; j < _arrUserList.length; j++) 
				{
					if (_arrUserList[i].ip == _arrUserList[j].ip && _arrUserList[i].userName != _arrUserList[j].userName) 
					{
						conflickIp = true;
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
		
		private function onHidIpBoard(e:TimerEvent):void 
		{
			if (content.ipBoard.visible) 
			{
				content.ipBoard.visible = false;
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
		
		private function onAddFriend(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			electroServerCommand.makeFriend(player._userName, DataField.IN_GAME_ROOM);
		}
		
		private function onRemoveFriend(e:Event):void 
		{
			if (!stage) 
			{
				return;
			}
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
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
			
			
			////trace("master in adduserinfo: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
			////trace("master in adduserinfo: ", _arrUserList[0].userName , _arrUserList[0].displayName)
			var i:int;
			var checkEvent:Boolean = false;
			
			////trace("master in adduserinfo: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
			
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
			////trace("minh join room: ", _myInfo._userName )
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
			//trace("master là mình: ", _arrUserList[0].isMaster, _arrUserList)
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
				////trace("_arruserlist cuoi cung dc add vao", _arrUserList[i]["userName"], _arrUserList[i].isMaster)
				if (_arrUserList[i]["userName"] && _arrUserInfo[i - 1]._userName == "" ) 
				{
					////trace("=====", i, _arrUserList[i].userName , "======")
					////trace("=====", _arrUserList[i].money, _arrUserList[i].avatar , "======")
					////trace("=====", _arrUserList[i].remaningCard, "======")
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
														_arrUserList[i].money, _arrUserList[i].avatar, _arrUserList[i].numCard, 
														String(_arrUserList[i].level), _arrUserList[i].ready, _isPlaying, 
													_arrUserList[i].isMaster, _arrUserList[i].displayName, 
													_arrUserList[i].sex, _arrUserList[i].ip, _arrUserList[i].deviceId
													, _arrUserList[i].win, _arrUserList[i].lose
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
			checkShowTextNotice();
			
			/*for (i = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].addCardDeck(13);
			}*/
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
		
		
		private function writelog(str:String):void 
		{
			var httpReq:HTTPRequest = new HTTPRequest();
			var displayname:String = MyDataTLMN.getInstance().myDisplayName;
			var action:String = "mobile: " + str;
			var method:String = "POST";
			var obj:Object = new Object();
			var writeLink:String = "";
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
		
		
	}

}