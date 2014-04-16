package view.screen 
{
	
	
	
	import com.greensock.TweenMax;
	import control.ConstTlmn;
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import control.electroServerCommand.ElectroServerCommandTlmn;
	
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
	import view.screen.play.Emoticon;
	import view.screen.play.Setting;
	//import view.window.NoticePopup;
	//import view.screen.play.BigButton;
	import view.screen.play.ContextMenu;
	import view.screen.play.MoneyEffect;
	import view.screen.play.MyInfoTLMN;
	import view.screen.play.PlayerInfoTLMN;
	//import view.screen.play.SmallButton;
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
		private var _moneyEffect:MoneyEffect;
		
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
		
		private var _settingWindow:Setting;
		
		private var _resultWindow:ResultWindowTlmn;
		
		private var _glowFilter:TextFormat = new TextFormat(); 
		
		private var _emoBoardButt:MovieClip;
		private var _emoBoard:Emoticon;
		
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
			
			content = new PlayScreenTlmnMc();
			gameLayer.addChild(content);
			
			
			
			var date:Date = new Date();
			trace(date.getHours())
			if (date.getHours() > 18 || date.getHours() < 6) 
			{
				content.backGround.gotoAndStop(1);
			}
			else 
			{
				content.backGround.gotoAndStop(2);
			}
			
			trace("xem the nao: ", SoundManager.getInstance().isSoundOn, SoundManager.getInstance().isMusicOn)
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
			
			addPlayerInfo();
			addComponent();
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x123456, 1);
			sp.graphics.drawRect(0, 0, 1024, 600);
			sp.graphics.endFill();
			content.addChild(sp);
			mask = sp;
			
			_containCard = new Sprite();
			content.addChild(_containCard);
			
			containerCardResult = new Sprite();
			content.addChild(containerCardResult);
			_arrCardListOtherUser = [];
			
			GameDataTLMN.getInstance().playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			
			var textfield:TextField = new TextField();
			textfield.text = "test 28/03/2013 : 12h20m";
			textfield.x = 20;
			textfield.y = 20;
			content.addChild(textfield);
			
			if (heartbeart) 
			{
				electroServerCommand.pingToServer();
				
				heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
				heartbeart.stop();
			}
			
			heartbeart = new Timer(1000, 30);
			heartbeart.addEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
			
			heartbeart.start();
		}
		
		
		public function effectOpen():void
		{
			
		}
		
		public function effectClose():void
		{
			
		}
		
		private function onSendHeartBeat(e:TimerEvent):void 
		{
			electroServerCommand.pingToServer();
			
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
				/*case PlayingScreenActionTlmn.LIST_BEFORE_START://lay danh sach cuoi cung
					listenGetUserListLast(e.data[ModelFieldTLMN.DATA]);
				break;*/
				case PlayingScreenActionTlmn.UPDATE_ROOM_MASTER: // Cập nhật thay đổi chủ phòng
					listenUpdateRoomMaster(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.ROOM_MASTER_KICK: // Bị chủ phòng kick
					listenRoomMasterKick(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.SORT_FINISH: // Có người xếp bài xong hoặc bỏ xếp bài xong
					//listenHaveUserSortCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.COMPARE_GROUP: // Đọ chi
					//listenCompareGroup(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.WHITE_WIN: // Thắng trắng
					listenWhiteWin(e.data[ModelFieldTLMN.DATA]);
				break;
				case PlayingScreenActionTlmn.DICE: // kết quả xúc xắc
					//listenDice(e.data[ModelField.DATA]);
				break;
				case PlayingScreenActionTlmn.UPDATE_MONEY: // update tiền
					//listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
					listenUpdateMoneyUser(e.data[ModelFieldTLMN.DATA]);
				break;
				
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
		
		private function listenRoomMasterKick(obj:Object):void 
		{
			var i:int;
			trace("thang bi kick la minh: ", obj[DataField.USER_NAME] , MyDataTLMN.getInstance().myId)
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				okOut();
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.roomMasterKick);
				windowLayer.openWindow(kickOutWindow);
				
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom(true);
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
				MyDataTLMN.getInstance().myMoney[0] = int(obj[DataField.MONEY]);
				_myInfo.addMyMoney();
			}
			else 
			{
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					if (obj[DataField.USER_NAME] == _arrUserInfo[i]._userName) 
					{
						_arrUserInfo[i].addMyMoney(int(obj[DataField.MONEY]));
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
			
			timerDealCard = new Timer(200);
			//timer.addEventListener(TimerEvent.TIMER, dealingCard);
			timerDealCard.addEventListener(TimerEvent.TIMER, onCompleteDealCard);
			timerDealCard.start();
			
			_myInfo.dealCard(obj[DataField.PLAYER_CARDS]);
			timerDealcardForme = new Timer(100, 13);
			timerDealcardForme.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
			timerDealcardForme.start();
			//addUsersInfo(true);
			
		}
		
		private function onCompleteDealcardForMe(e:TimerEvent):void 
		{
			timerDealCard.stop();
			timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
			content.noc.visible = false;
			
			timerDealcardForme.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealcardForMe);
			timerDealcardForme.stop();
			
			checkPosClock();
		}
		
		private function listenUserReady(obj:Object):void 
		{
			trace("thang ready: ", obj[DataField.USER_NAME] , MyDataTLMN.getInstance().myId)
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_READY);
			}
			
			trace("nut bat dau: ", _isPlaying, GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
			if (!_isPlaying && GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId) 
			{
				content.startGame.visible = true;
			}
			else 
			{
				content.startGame.visible = false;
			}
			
			if (obj[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				_myInfo.myReady();
			}
			else 
			{
				for (var i:int = 0; i < _arrUserInfo.length; i++) 
				{
					trace("thang ready ko phai minh: ", obj[DataField.USER_NAME] , _arrUserInfo[i]._userName)
					if (_arrUserInfo[i]._userName == obj[DataField.USER_NAME]) 
					{
						_arrUserInfo[i].myReady();
					}
					
				}
			}
		}
		
		private function deleteCard(obj:Object):void 
		{
			
		}
		
		private function listenUpdateRoomMaster(obj:Object):void 
		{
			var i:int;
			
			trace(obj[ConstTlmn.MASTER], "la chu phong moi")
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
						content.startGame.visible = true;
					}
					else 
					{
						content.startGame.visible = false;
					}
					
					
					_myInfo.changeMaster(true);
				}
				else 
				{
					_myInfo.changeMaster(false);
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
			
			trace("sua khi thay bo luot da het vong hay chua: ", GameDataTLMN.getInstance().finishRound)
			if (GameDataTLMN.getInstance().finishRound) 
			{
				content.specialCard.visible = false;
				_arrLastCard = [];
				var cardChilds:Array = [];
				_userLastDisCard = "";
				removeAllDisCard();
				_myInfo._isPassTurn = false;
				
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
				_myInfo.addMoney(arrPlus[1]);
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
				_myInfo.addMoney(arrSub[1]);
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
		
		private function listenWhiteWin(obj:Object):void 
		{
			//trace(obj)
			var i:int;
			var j:int;
			var rd:int;
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_WHITEWIN);
			}
			
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
			whiteWin = true;
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
						card.x = 42 + 35 * j;
						card.y = 110;
						_containCard.addChild(card);
						_arrCardDiscard.push(card);
					}
					
					
				}
				else if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
				{
					for (j = 0; j < obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS].length; j++) 
					{
						card = new CardTlmn(obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.CARDS][j]);
						card.x = _myInfo.x + 160 + 35 * j;
						card.y = _myInfo.y + 130;
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
			
			
			
			_containCard.x = 270;
			_containCard.y = 285;
			content.specialCard.gotoAndStop(6);
			content.specialCard.visible = true;
			content.whiteWin.gotoAndStop(convertWhiteWin(obj["whiteWinType"]));
			content.whiteWin.visible = true;
			
			content.setChildIndex(content.whiteWin, content.numChildren - 1);
			
			
			var outGame:Boolean = false;
			var objResult:Object;
			for (i = 0; i < obj[ConstTlmn.PLAYER_LIST].length; i++) 
			{
				if (obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.PLAYER_NAME] == MyDataTLMN.getInstance().myId) 
				{
					objResult = new Object();
					objResult[ConstTlmn.MONEY] = obj[ConstTlmn.PLAYER_LIST][i][ConstTlmn.MONEY];
					
					MyDataTLMN.getInstance().myMoney[0] = int(MyDataTLMN.getInstance().myMoney[0]) + int(objResult[ConstTlmn.MONEY]);
					if (MyDataTLMN.getInstance().myMoney[0] < int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
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
			//listenGameOver(obj);
		}
		
		private function onResetGame(e:TimerEvent):void 
		{
			
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
			
			if (int(MyDataTLMN.getInstance().myMoney[0]) < int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
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
			{
				
				trace(GameDataTLMN.getInstance().currentPlayer, MyDataTLMN.getInstance().myId, "thằng nào có đồng hồ chạy", _isPlaying)
				if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
				{
					_myInfo.checkPosClock();
					content.userTurn.x = _myInfo.x + 20;
					content.userTurn.y = _myInfo.y - 80;
					content.userTurn.rotation = 0;
					
					if (SoundManager.getInstance().isSoundOn) 
					{
						SoundManager.getInstance().playSound(ConstTlmn.SOUND_TURN);
						
					}
				}
				else if (_arrUserInfo[0] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[0]._userName && _isPlaying) 
				{
					_arrUserInfo[0].checkPosClock();
					content.userTurn.x = _arrUserInfo[0].x - 100;
					content.userTurn.y = _arrUserInfo[0].y + 100;
					content.userTurn.rotation = -90;
				}
				else if (_arrUserInfo[1] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[1]._userName && _isPlaying) 
				{
					_arrUserInfo[1].checkPosClock();
					content.userTurn.x = _arrUserInfo[1].x + 90;
					content.userTurn.y = _arrUserInfo[1].y + 230;
					content.userTurn.rotation = 180;
				}
				else if (_arrUserInfo[2] && GameDataTLMN.getInstance().currentPlayer == _arrUserInfo[2]._userName && _isPlaying) 
				{
					_arrUserInfo[2].checkPosClock();
					content.userTurn.x = _arrUserInfo[2].x + 280;
					content.userTurn.y = _arrUserInfo[2].y + 30;
					content.userTurn.rotation = 90;
				}
				content.userTurn.visible = false;// true;
			}
		}
		
		public function onCountTimeFinish():void 
		{
			
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
				//_myInfo.nextturn();
				onClickNextTurn(null);
			}
			
		}
		
		private function getCurrentPlayer(obj:Object):void 
		{
			
			trace("den luot ai: ", GameDataTLMN.getInstance().currentPlayer , MyDataTLMN.getInstance().myId , _isPlaying)
			if (GameDataTLMN.getInstance().currentPlayer == MyDataTLMN.getInstance().myId && _isPlaying) 
			{
				
				if (_myInfo) 
				{
					
					_myInfo._isMyTurn = true;
					trace("endround den luot minh")
					//_myInfo.checkHitOrPassTurn();
				}
				
				
			}
			
			//checkPosClock();
			
				
			
		}
		
		//private var _containerWinLose:Sprite;
		private function listenGameOver(obj:Object):void 
		{
			_isPlaying = false;
			GameDataTLMN.getInstance().finishRound = false;
			
			if (timerDealCard) 
			{
				timerDealCard.stop();
				timerDealCard.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteDealCard);
			}
			
			var str:String;
			content.userTurn.visible = false;
			/*if (!_containerWinLose) 
			{
				_containerWinLose = new Sprite();
				addChild(_containerWinLose);
			}
			else 
			{
				_containerWinLose.visible = true;
			}*/
			//var arrLose:Array = ["LoseDiChan", "LoseLiecDeu", "LoseCaNgao"];
			//var arrWin:Array = ["Win2Hand", "WinNhechMep", "WinThoiKen"];
			//thtem vao bang ket qua choi game sau
			//trace(obj);
			var i:int;
			var rd:int;
			
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
			var result:int = int(String(MyDataTLMN.getInstance().myMoney[0]).replace(",", ""));
			
			var userResult:String;
			
			for (i = 0; i < arrResult.length; i++) 
			{
				trace(i, "check cac thang dc add card: ", arrResult[i][ConstTlmn.PLAYER_NAME] , MyDataTLMN.getInstance().myId)
				
				userResult = arrResult[i][ConstTlmn.PLAYER_NAME];
				if (arrResult[i][ConstTlmn.SUB_MONEY] > 0) 
				{
					for (j = 0; j < _arrUserInfo.length; j++) 
					{
						
						if (userResult == _arrUserInfo[j]._userName)
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
				
				var objResult:Object;
				var outGame:Boolean = false;
				trace("check cac thang dc add card: ", userResult , MyDataTLMN.getInstance().myId)
				if (userResult == MyDataTLMN.getInstance().myId) 
				{
					objResult = new Object();
					objResult[ConstTlmn.MONEY] = arrResult[i][ConstTlmn.SUB_MONEY];
					MyDataTLMN.getInstance().myMoney[0] = int(MyDataTLMN.getInstance().myMoney[0]) + int(arrResult[i][ConstTlmn.SUB_MONEY]);
					if (MyDataTLMN.getInstance().myMoney[0] < int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
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
					trace("tien su may; ", userResult )
					for (var j:int = 0; j < _arrUserInfo.length; j++) 
					{
						trace(i, "thang nao dc add card; ", userResult , _arrUserInfo[j]._userName)
						
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
							trace("user nay co bao nhieu tien: ", arrResult[i][ConstTlmn.SUB_MONEY])
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
			trace("card cua cac user: ", arr)
			trace("card cua cac user: ", pos)
			for (var i:int = 0; i < arr.length; i++) 
			{
				var card:CardTlmn = new CardTlmn(arr[i]);
				containerCardResult.addChild(card);
				card.scaleX = card.scaleY = .6;
				_arrCardListOtherUser.push(card);
				
				if (pos == 0) 
				{
					card.rotation = 90;
					card.x = _arrUserInfo[0].x - 79;
					card.y = _arrUserInfo[0].y + 5 + (13 - arr.length) * 10 + 10 * i;
				}
				else if (pos == 2)
				{
					card.rotation = 90;
					card.x = _arrUserInfo[2].x + 124;
					card.y = _arrUserInfo[2].y + 5 + (13 - arr.length) * 10 + 10 * i;
				}
				else 
				{
					card.x = _arrUserInfo[1].x - 165 + (13 - arr.length) * 10 + 10 * i;
					card.y = _arrUserInfo[1].y + 114;
				}
			}
		}
		
		private function onShowResult(e:TimerEvent):void 
		{
			//var i:int;
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowResult);
			content.specialCard.visible = false;
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
			
			if (int(MyDataTLMN.getInstance().myMoney[0]) < int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]) * ConstTlmn.xBet) 
			{
				EffectLayer.getInstance().removeAllEffect();
				
				
				GameDataTLMN.getInstance().notEnoughMoney = true;
				//okOut();
			}
		}
		private function onOutGame(e:Event):void 
		{
			okOut();
		}
		
		private function onCloseResultWindow(e:Event):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
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
			
			if (GameDataTLMN.getInstance().notEnoughMoney) 
			{
				electroServerCommand.joinLobbyRoom();
				dispatchEvent(new Event(ConstTlmn.OUT_ROOM, true));
			}
			
			GameDataTLMN.getInstance().notEnoughMoney = false;
			
			_resultWindow.removeEventListener("close", onCloseResultWindow);
			_resultWindow.removeEventListener("out game", onOutGame);
				
			removeAllDisCard();
			
			removeAllCardResult();
			
			if (_resultWindow) 
			{
				_resultWindow.visible = false;
			}
			
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
				content.startGame.visible = true;
				GameDataTLMN.getInstance().autoReady = false;
			}
			else 
			{
				content.startGame.visible = false;
				
				_myInfo.waitNewGame();
			}
			
			if (GameDataTLMN.getInstance().autoReady) 
			{
				onClickReady(null);
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
		
		private function listenGetUserListLast(obj:Object):void 
		{
			var i:int;
			var arrPlayerList:Array = obj[DataField.PLAYER_LIST];
			var count:int
			
			for (i = 0; i < arrPlayerList.length; i++) 
			{
				if (arrPlayerList[i]["userName"] == MyDataTLMN.getInstance().myId) 
				{
					count = arrPlayerList[i].position;
					_arrUserList = converArrAgain(count, arrPlayerList);
					MyDataTLMN.getInstance().myMoney[0] = String(_arrUserList[0].money);
					if (_arrUserList[0]["isMaster"]) 
					{
						GameDataTLMN.getInstance().master = arrPlayerList[i]["userName"];
					}
					
					break;
				}
			}
			
			if (GameDataTLMN.getInstance().master == _myInfo._userName) 
			{
				
				content.startGame.visible = true;
				//content.startGame.addEventListener(MouseEvent.CLICK, onClickStartGame);
			}
			
			if (int(MyDataTLMN.getInstance().myMoney[0]) > int(content.roomBet.text) * ConstTlmn.xBet) 
			{
				addUsersInfo();
			}
			
		}
		
		private function onClickStartGame(e:MouseEvent):void 
		{
			trace("click bat dau: ")
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			if (_arrUserList) 
			{
				trace(_arrUserList)
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
		
		private var dealcard:int = 0;
		private var timerDealCard:Timer;
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
			content.startGame.visible = false;
			
			dealcard = 0;
			
			_isPlaying = true;
			canExitGame = false;
			
			if (obj[DataField.MESSAGE] == "testGame") 
			{
				checkPosClock();
			}
			//
		}
		
		private function onCompleteDealCard(e:TimerEvent):void 
		{
			
			var arr:Array = [];
			
			trace("1 lan vao thang chia bai")
			for (var j:int = dealcard; j < _arrUserInfo.length; j++) 
			{
				trace("xem thang nao vua dc chia: ", j, _arrUserInfo[j].ready, _arrUserInfo[j]._userName , GameDataTLMN.getInstance().master)
				if (_arrUserInfo[j].ready || _arrUserInfo[j]._userName == GameDataTLMN.getInstance().master) 
				{
					_arrUserInfo[j].dealCard(arr);
					if (j == 2) 
					{
						
					}
					dealcard = j + 1;
					break;
				}
				/*trace("co phai la cheater ko: ", _arrCardListOtherUser.length, _myInfo._cheater)
				if (_arrCardListOtherUser.length > 0) 
				{
					_myInfo._cheater = true;
					//content.setChildIndex(_arrUserInfo[2], content.numChildren - 1);
					for (var i:int = 0; i < _arrCardListOtherUser.length; i++) 
					{
						if (_arrCardListOtherUser[i]["userName"] == _arrUserInfo[j]._userName) 
						{
							arr = _arrCardListOtherUser[i]["cardList"];
							_arrUserInfo[j].dealCard(arr);
						}
					}
				}
				else
				{
					//content.setChildIndex(_chatBox, content.numChildren - 1);
					trace("mang khi ko co j` ", arr.length)
					_arrUserInfo[j].dealCard(arr);
					
				}*/
			}
		}
		
		private function dealingCard(e:TimerEvent):void 
		{
			
			
		}
		
		
		private function onClickNextTurn(e:Event):void 
		{
			
			electroServerCommand.nextTurn();
		}
		
		private function onClickHitCard(e:Event):void 
		{
			trace("====== cac quan danh ra =====")
			trace(e.target._arrCardChoose)
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
			var rd:int;
			var str:String;
			var ihit:Boolean = false;
			var userSexhit:Boolean = false;
			if (obj.userName == _myInfo._userName) 
			{
				ihit = true;
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					if (_arrUserInfo[i]._userName && obj.userName == _arrUserInfo[i]._userName) 
					{
						userSexhit = _arrUserInfo[i]._sex;
					}
				}
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
								/*if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
								}*/
								
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_DANH2_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_DANH2_ + String(rd + 1) );
								}
							
							}
							else 
							{
								/*if (userSexhit) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
								}*/
								
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
						else 
						{
							if (ihit) 
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
							else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
						{
							rd = int(Math.random() * 5);
							if (ihit) 
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
							else 
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
					
					if (obj.userName == MyDataTLMN.getInstance().myId) 
					{
						if (_myInfo._arrCardInt.length == 1) 
						{
							whiteWin = true;
						}
					}
					else 
					{
						for (i = 0; i < _arrUserInfo.length; i++) 
						{
							if (obj.userName == _arrUserInfo[i]._userName) 
							{
								if (_arrUserInfo[i]._remainingCard == 1) 
								{
									whiteWin = true;
								}
								break;
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE1CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE1CARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
						{
							rd = int(Math.random() * 5);
							if (ihit) 
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
							else 
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
							if (MyDataTLMN.getInstance().sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE2CARD_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE2CARD_ + String(rd + 1) );
							}
						}
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
							if (MyDataTLMN.getInstance().sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
							}
						}
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
						{
							if (ihit) 
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
							else 
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
							if (MyDataTLMN.getInstance().sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
							}
						}
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
						{
							if (ihit) 
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
							else 
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
							if (MyDataTLMN.getInstance().sex) 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
							}
							else 
							{
								SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
							}
						}
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
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
								if (MyDataTLMN.getInstance().sex) 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_BOY_CHATDE3CARD_ + String(rd + 1) );
								}
								else 
								{
									SoundManager.getInstance().playSound(ConstTlmn.SOUND_GIRL_CHATDE3CARD_ + String(rd + 1) );
								}
							}
							else 
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
						else 
						{
							if (ihit) 
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
							else 
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
					cardsName = "Sảnh 8";
					if (_arrLastCard && _arrLastCard.length == 8)
					{
						checkAnimationChatSanh7 = true;
					}
				}
				
			}
			else if (arrCard.length == 9) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
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
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
				cardsName = "Sảnh 9";
				if (_arrLastCard && _arrLastCard.length == 9) 
				{
					checkAnimationChatSanh7 = true;
				}
			}
			else if (arrCard.length == 10) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
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
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
				check = cardTlmn.isNamDoiThong(arrCard);
				if (check) 
				{
					cardsName = "5 đôi thông";
				}
				else 
				{
					cardsName = "Sảnh 10";
					if (_arrLastCard && _arrLastCard.length == 10) 
					{
						checkAnimationChatSanh7 = true;
					}
				}
				
			}
			else if (arrCard.length == 11) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
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
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
				cardsName = "Sảnh 11";
				if (_arrLastCard && _arrLastCard.length == 11) 
				{
					checkAnimationChatSanh7 = true;
				}
			}
			else if (arrCard.length == 12) 
			{
				if (SoundManager.getInstance().isSoundOn) 
				{
					rd = int(Math.random() * 5);
					if (_arrLastCard.length > 0) 
					{
						if (ihit) 
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
						else 
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
					else 
					{
						if (ihit) 
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
						else 
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
				cardsName = "Sảnh 12";
				if (_arrLastCard && _arrLastCard.length == 12) 
				{
					checkAnimationChatSanh7 = true;
				}
			}
			else if (arrCard.length == 13) 
			{
				cardsName = "Sảnh rồng";
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
			
			trace("thang danh cuoi cung: ", _userLastDisCard)
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
				_myInfo._isPassTurn = false;
				_myInfo.onCompleteNextturn();
				
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
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
				
				_myInfo.onCompleteNextturn();
				
				for (j = 0; j < _arrUserInfo.length; j++) 
				{
					_arrUserInfo[j].onCompleteNextturn();
				}
				
				GameDataTLMN.getInstance().finishRound = false;
			}
			
			GameDataTLMN.getInstance().firstPlayer = "";
			
			checkPosClock();
			
		}
		
		private var _containerSpecial:Sprite;
		private var _timerShowSpecial:Timer;
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
			trace("thang nao dang danh bai: ", userName)
			
			if (userName == _myInfo._userName) 
			{
				trace("bai tu minh di ra: ", _myInfo._userName)
				_containCard.x = _myInfo.x + 200;
				_containCard.y = _myInfo.y - 20;
			}
			else 
			{
				for (i = 0; i < _arrUserInfo.length; i++)
				{
					trace("bai tu thang nao di ra: ", _arrUserInfo[i]._userName)
					if (_arrUserInfo[i]._userName && userName == _arrUserInfo[i]._userName) 
					{
						trace("bai tu thang nao di ra trong if: ", _arrUserInfo[i]._userName)
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
			//TweenMax.to(_containCard, 1, { x:(this.width - _containCard.width) / 2, y:(this.height = _containCard.height) / 2 } );
			TweenMax.to(_containCard, .5, { x:(1024 - _containCard.width) / 2 + 30, y:250} );
			//_containCard.x = (this.width - _containCard.width) / 2;
			//_containCard.y = (this.height - _containCard.height) / 2;
		}
		
		private var _contanierCardOutUser:Sprite;
		private function listenHaveUserOutRoom(data:Object):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_OUTROOM);
				
			}
			
			var i:int;
			var outArr:Array = [];
			if (!_contanierCardOutUser) 
			{
				_contanierCardOutUser = new Sprite();
				content.addChild(_contanierCardOutUser);
			}
			trace("co user out room: ", _arrUserList)
			for (i = 0; i < _arrUserList.length; i++) 
			{
				if (_arrUserList[i])
				{
					if ((_arrUserList[i]).userName == data[DataField.USER_NAME])
						_arrUserList.splice(i, 1);
				}
			}
			trace("co user out room: ", _arrUserList)
			trace("co user out room: ", _isPlaying, MyDataTLMN.getInstance().myId , data["master"])
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
					content.startGame.visible = true;
				}
				else 
				{
					content.startGame.visible = false;
				}
			}
			
			for (i = 0; i < _arrUserInfo.length; i++) 
			{
				if (_arrUserInfo[i])
				{
					if ((_arrUserInfo[i])._userName == data[DataField.USER_NAME])
					{
						
						_arrUserInfo[i].outRoom();
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
			
		}
		
		public function removeAllEvent():void 
		{
			content.settingBoard.onSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
			content.settingBoard.offSoundEffect.removeEventListener(MouseEvent.CLICK, onClickOnOffSoundEffect);
			content.settingBoard.onMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
			content.settingBoard.offMusic.removeEventListener(MouseEvent.CLICK, onClickOnOffMusic);
			
			
			content.signOutBtn.removeEventListener(MouseEvent.CLICK, onClickSignOutGame);
			content.settingBoard.fullBtn.removeEventListener(MouseEvent.CLICK, onClickFullGame);
			content.settingBoard.ipBtn.removeEventListener(MouseEvent.CLICK, onClickIPGame);
			content.settingBoard.guideBtn.removeEventListener(MouseEvent.CLICK, onClickGuidGame);
			
			content.startGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
			
			for (var i:int = 0; i < _arrUserInfo.length; i++) 
			{
				_arrUserInfo[i].removeAllEvent();
				
				_arrUserInfo[i].removeEventListener(ConstTlmn.INVITE, onClickInvite);
			}
			
			if (heartbeart) 
			{
				heartbeart.removeEventListener(TimerEvent.TIMER_COMPLETE, onSendHeartBeat);
				heartbeart.stop();
			}
			
			_myInfo.removeAllEvent();
			_myInfo.removeEventListener("next turn", onClickNextTurn);
			_myInfo.removeEventListener("hit card", onClickHitCard);
			_myInfo.removeEventListener(ConstTlmn.READY, onClickReady);
			
			_chatBox.removeAllChat();
			GameDataTLMN.getInstance().removeEventListener(ConstTlmn.HAVE_CHAT, onUpdatePublicChat);
			_chatBox.removeEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			_chatBox.removeEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
			chatLayer.removeChild(_chatBox);
			
			GameDataTLMN.getInstance().playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			
			_resultWindow.removeEventListener("close", onCloseResultWindow);
			_resultWindow.removeEventListener("out game", onOutGame);
			
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
			
			if (timerShow) 
			{
				timerShow.stop();
				timerShow.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShow);
			}
			
			if (timerDealCard) 
			{
				timerDealCard.removeEventListener(TimerEvent.TIMER, onCompleteDealCard);
				timerDealCard.stop();
			}
			removeAllCardResult();
			removeAllDisCard();
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
			
			//_chatBox.loadEmo("http://183.91.14.52/gamebai/bimkute/phom/emoticon.swf");
			
			chatLayer.addChild(_chatBox);
			_chatBox.visible = false;
			
			//_waitToPlay = content["waitToPlay"]; = _waitToPlay.visible
			_waitToReady = content["waitToReady"];
			_waitToStart = content["waitToStart"];
			
			_waitToReady.visible = _waitToStart.visible = false;
			_waitToReady.visible = false;
			content.userTurn.visible = false;
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
				
				//trace("tao ra thang result window")
			}
			
			if (SoundManager.getInstance().isSoundOn) 
			{
				content.settingBoard.onSoundEffect.visible = false;
			}
			else 
			{
				content.settingBoard.onSoundEffect.visible = true;
			}
			
			if (SoundManager.getInstance().isMusicOn) 
			{
				content.settingBoard.onMusic.visible = false;
			}
			else 
			{
				content.settingBoard.onMusic.visible = true;
			}
			
			content.settingBoard.visible = false;
			content.setChildIndex(content.settingBoard, content.numChildren - 1);
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
			
			content.startGame.visible = false;
			
			content.chatBtn.addEventListener(MouseEvent.CLICK, onChatButtonClick);
			
		}
		
		private function onShowSettingBoard(e:MouseEvent):void 
		{
			if (content.settingBoard.visible) 
			{
				content.settingBoard.visible = false;
			}
			else 
			{
				content.settingBoard.visible = true;
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
			trace("order card: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myName)
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
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			if (SoundManager.getInstance().isSoundOn) 
			{
				GameDataTLMN.getInstance().playSound = false;
				content.settingBoard.onSoundEffect.visible = true;
				SoundManager.getInstance().isSoundOn = false;
			}
			else 
			{
				GameDataTLMN.getInstance().playSound = true;
				content.settingBoard.onSoundEffect.visible = false;
				SoundManager.getInstance().isSoundOn = true;
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
				SoundManager.getInstance().isMusicOn = false;
				SoundManager.getInstance().stopMusic(ConstTlmn.MUSIC_BG);
			}
			else 
			{
				GameDataTLMN.getInstance().playGameBackGroud = true;
				content.settingBoard.onMusic.visible = false;
				
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
		}
		
		private function onClickIPGame(e:MouseEvent):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
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
			_emoBoard.visible = false;
		}
		
		private function onSendEmo(e:Event):void 
		{
			if (timer) 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			}
			//trace("co emo gui len ne: ", e.target.nameOfEmo)
			_emoBoard.visible = false;
			electroServerCommand.sendPublicChat(MyDataTLMN.getInstance().myId, MyDataTLMN.getInstance().myDisplayName,
													e.target.nameOfEmo);
		}
		
		private function onClickInvite(e:Event):void 
		{
			if (SoundManager.getInstance().isSoundOn) 
			{
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
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
			trace("remove tat ca bai da danh ra")
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
				SoundManager.getInstance().playSound(ConstTlmn.SOUND_CLICK);
			}
			if (canExitGame) 
			{
				if (_myInfo._isPlaying) 
				{
					
					confirmExitWindow = new ConfirmWindow();
					confirmExitWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmExit);
					confirmExitWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
					windowLayer.openWindow(confirmExitWindow);
				}
				else 
				{
					if (SoundManager.getInstance().isSoundOn) 
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
					
					dispatchEvent(new Event(ConstTlmn.OUT_ROOM, true));
					electroServerCommand.joinLobbyRoom();
					
					EffectLayer.getInstance().removeAllEffect();
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
				dispatchEvent(new Event(ConstTlmn.OUT_ROOM, true));
				electroServerCommand.joinLobbyRoom();
				
				EffectLayer.getInstance().removeAllEffect();
			}
			
		}
		
		public function destroy():void 
		{
			removeAllEvent();
		}
		
		public function okOut():void 
		{
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
			content.userTurn.visible = false;
			
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
			removeAllEvent();
			electroServerCommand.joinLobbyRoom();
			//dispatchEvent(new Event("SignOutGame"));
		}
		
		private function masterUnVisible():void 
		{
			content.startGame.visible = false;
			GameDataTLMN.getInstance().master = "";
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			
			var isMe:Boolean;
			var notEmo:Boolean = false;
			if (GameDataTLMN.getInstance().publicChat[DataField.USER_NAME] == MyDataTLMN.getInstance().myId) 
			{
				isMe = true;
			}
			
			for (var i:int = 0; i < arrChat.length; i++) 
			{
				if (GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT] == arrChat[i]) 
				{
					notEmo = true;
					break;
				}
			}
			
			if (!notEmo) 
			{
				var isNotice:Boolean = false;
				if (GameDataTLMN.getInstance().publicChat[DataField.DISPLAY_NAME] == "Hệ thống") 
				{
					isNotice = true;
				}
				_chatBox.addChatSentence(GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT],
										GameDataTLMN.getInstance().publicChat[DataField.DISPLAY_NAME], isMe);
			}
			else 
			{
				//showEmo(e.target.publicChatData.chatContent, e.target.publicChatData.displayName, isMe);
			}
			
			
		}
		
		private var _containerChatEmo:Sprite;
		private var timerShow:Timer;
		private var confirmExitWindow:ConfirmWindow;
		//private var _containerWhiteWin:Sprite;
		//private var arrChat:Array = [];
		private function showEmo(str:String, userChat:String, isMe:Boolean):void 
		{
			/*if (!_containerChatEmo) 
			{
				_containerChatEmo = new Sprite();
				addChild(_containerChatEmo);
			}
			else 
			{
				for (var i:int = 0; i < _containerChatEmo.numChildren; i++) 
				{
					_containerChatEmo.removeChild(_containerChatEmo.getChildAt(i));
				}
			}
			
			var arr:Array = MainData.getInstance().arrEmoticonChat;
			var myClass:Class;
			var mc:MovieClip;
			var loader:Loader;
			
			loader = arr[str][0];
			myClass = loader.contentLoaderInfo.applicationDomain.getDefinition(str) as Class;
			mc = new myClass();
			
			_containerChatEmo.addChild(mc);
			
			mc.scaleX = mc.scaleY = .75;
			if (isMe) 
			{
				_containerChatEmo.x = 300;
				_containerChatEmo.y = 410;
			}
			else if (_arrUserInfo[0]._userName == userChat) 
			{
				_containerChatEmo.x = 745;
				_containerChatEmo.y = 350;
			}
			else if (_arrUserInfo[1]._userName == userChat) 
			{
				_containerChatEmo.x = 430;
				_containerChatEmo.y = 60;
			}
			else if (_arrUserInfo[2]._userName == userChat) 
			{
				_containerChatEmo.x = 200;
				_containerChatEmo.y = 270;
			}
			if (timerShow) 
			{
				timerShow.stop();
				timerShow.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShow);
			}
			timerShow = new Timer(1000, 2);
			timerShow.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteShow);
			timerShow.start();*/
		}
		
		private function onCompleteShow(e:TimerEvent):void 
		{
			for (var i:int = 0; i < _containerChatEmo.numChildren; i++) 
			{
				_containerChatEmo.removeChild(_containerChatEmo.getChildAt(i));
			}
			content.removeChild(_containerChatEmo);
			_containerChatEmo = null;
		}
		
		private function onHaveChat(e:Event):void 
		{
			//trace(e.target.inputText.text);
			electroServerCommand.sendPublicChat(MyDataTLMN.getInstance().myId, MyDataTLMN.getInstance().myDisplayName,
												e.target.zInputText.text);
			
		}
		
		private function listenHaveUserJoinRoom(obj:Object):void 
		{
			//addPlayer(obj);
		}
		
		private function addPlayer(obj:Object):void 
		{
			//specialAvatar
			var i:int;
			var count:int = 0;
			if (GameDataTLMN.getInstance().gameRoomInfo["gameState"] == "waiting") 
			{
				
				_isPlaying = false;
			}
			else 
			{
				_isPlaying = true;
			}
			
			
			for (i = 0; i < obj.userList.length; i++) 
				{
					//trace(i, obj.userList[i].userName)
					if (obj.userList[i].userName == MyDataTLMN.getInstance().myId) 
					{
						count = obj.userList[i].position;
						if (!_myInfo) 
						{
							
							
							MyDataTLMN.getInstance().myMoney[0] = String(obj.userList[i].money);
						}
						
						
						break;
					}
				}
				
				
				_arrUserList = converArrAgain(count, obj.userList);
				addUsersInfo();
				
			if (obj.userList.length == 1) 
			{
				
				
				//content.channelNameAndRoomId.text = "Bạn đang chơi ở " + String(MainData.getInstance().chooseChannelData[2]);
				content.txtNotice.text = "TIẾN LÊN - " + GameDataTLMN.getInstance().levelLobby + " - Bàn " 
										+ String(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID]) + " - Cược "
										+ format(int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]));
				
				content.startGame.visible = true;
				//content.ruleDescription.y = content.channelNameAndRoomId.y;
			}
			else 
			{
				content.txtNotice.text = "TIẾN LÊN - " + GameDataTLMN.getInstance().levelLobby + " - Bàn " 
										+ String(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID]) + " - Cược "
										+ format(int(GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET]));
										
				
				
				
				var waiting:Boolean = true;
				for (i = 0; i < obj.userList.length; i++) 
				{
					if (obj.userList[i].remaningCard > 0) 
					{
						waiting = false;
						break;
					}
				}
				
				
				/*if (!waiting) // Nếu phòng chơi chưa bắt đầu
				{
					if (_arrUserList.length > 1)
					{
						var esObject:EsObject = new EsObject();
						esObject.setString(DataField.USER_NAME, MainData.getInstance().myName);
						var isCompareGroup:Boolean;
						for (i = 0; i < _arrUserList.length; i++) 
						{
							if (_arrUserList[i])
							{
								if (PlayerInfo(_arrUserList[i]).unLeaveCards && PlayerInfo(_arrUserList[i])._userName != MainData.getInstance().myName)
									electroServerCommand.sendPrivateMessage([PlayerInfo(_arrUserList[i]).userName], Command.REQUEST_IS_COMPARE_GROUP, esObject);
							}
						}
						//showReadyButton();
						waitToReady.visible = false;
					}
					else
					{
						waitToReady.visible = true;
					}
				}
				else // Nếu phòng chơi đang chơi
				{
					//hideStartButton();
					//hideReadyButton();
					waitToPlay.visible = false;
					waitToReady.visible = false;
					waitToStart.visible = false;
					//addCardManager();
					// bổ sung thông tin cá nhân
					for (i = 0; i < userList.length; i++) 
					{
						// Không phải add cho mình vì minh vừa vào nên chắc chắc là không có bài
						if (!userList[i][DataField.IS_VIEWER]) 
						{
							//if (userList[i][DataField.NUM_CARD] == 13)
								//arrangeTime.visible = true;
							addCardInfo(userList[i]);
						}
					}
				
					playingPlayerArray = new Array();
					for (i = 0; i < allPlayerArray.length; i++)
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfo(allPlayerArray[i]).isPlaying)
							{
								playingPlayerArray.push(allPlayerArray[i]);
							}
						}
					}*/
					/*esObject = new EsObject();
					esObject.setString(DataField.USER_NAME, mainData.chooseChannelData.myInfo.uId);
					electroServerCommand.sendPrivateMessage([PlayerInfo(playingPlayerArray[0]).userName], Command.REQUEST_TIME_CLOCK, esObject);
					isPlaying = true;
					cardManager.playerArray = playingPlayerArray;
				}*/
			}
			
			
			
		}
		
		private function addPlayerInfo():void 
		{
			_myInfo = new MyInfoTLMN(this);
			content.addChild(_myInfo);
			_myInfo.x = 60;
			_myInfo.y = 372;
			_myInfo.addEventListener("next turn", onClickNextTurn);
			_myInfo.addEventListener("hit card", onClickHitCard);
			_myInfo.addEventListener(ConstTlmn.READY, onClickReady);
							
			_arrUserInfo = [];
			//var count:int = 0;
			var i:int;
			for (i = 0; i < 3; i++) 
			{
				_userInfo = new PlayerInfoTLMN(i);
				content.addChild(_userInfo);
				//trace(count)
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
				_userInfo.addEventListener("kick", onClickKick);
				_userInfo.addEventListener("add friend", onAddFriend);
				_userInfo.addEventListener("remove friend", onRemoveFriend);
				_userInfo.addEventListener(ConstTlmn.INVITE, onClickInvite);
				//count++;
			}
			
			
		}
		
		private function onAddFriend(e:Event):void 
		{
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			electroServerCommand.makeFriend(player._userName, DataField.IN_GAME_ROOM);
		}
		
		private function onRemoveFriend(e:Event):void 
		{
			var player:PlayerInfoTLMN = e.currentTarget as PlayerInfoTLMN;
			electroServerCommand.removeFriend(player._userName, DataField.IN_GAME_ROOM);
		}
		
		private function onClickReady(e:Event):void 
		{
			electroServerCommand.readyPlay();
		}
		
		private function onClickKick(e:Event):void 
		{
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
			MyDataTLMN.getInstance().myId = _arrUserList[0].userName;
			MyDataTLMN.getInstance().myDisplayName = _arrUserList[0].displayName;
			MyDataTLMN.getInstance().myMoney[0] = _arrUserList[0].money;
			trace("master in adduserinfo: ", GameDataTLMN.getInstance().master , MyDataTLMN.getInstance().myId)
			trace("master in adduserinfo: ", _arrUserList[0].userName , _arrUserList[0].displayName)
			
			if (GameDataTLMN.getInstance().master == MyDataTLMN.getInstance().myId) 
			{
				_arrUserList[0].isMaster = true;
				content.startGame.visible = true;
			}
			else 
			{
				_arrUserList[0].isMaster = false;
				content.startGame.visible = false;
			}
			
			trace("master là mình: ", _arrUserList[0].isMaster, _arrUserList);
			MyDataTLMN.getInstance().sex = _arrUserList[0].sex;
			_myInfo.addInfoForMe(_arrUserList[0].userName, _arrUserList[0].money, _arrUserList[0].avatar, 
									_arrUserList[0].remaningCard,
									_arrUserList[0].isMaster, _isPlaying, _arrUserList[0].displayName, _arrUserList[0].ready);
			
			MyDataTLMN.getInstance().myMoney[0] = String(_arrUserList[0].money);
			if (_arrUserList[0].isMonster) 
			{
				checkEvent = true;
			}
			
			for (i = 1; i < _arrUserList.length; i++) 
			{
				trace("_arruserlist cuoi cung dc add vao", _arrUserList[i]["userName"], _arrUserList[i].isMaster)
				if (_arrUserList[i]["userName"] && _arrUserInfo[i - 1]._userName == "" ) 
				{
					//trace("=====", i, _arrUserList[i].userName , "======")
					//trace("=====", _arrUserList[i].money, _arrUserList[i].avatar , "======")
					//trace("=====", _arrUserList[i].remaningCard, "======")
					if (_arrUserList[i].isMonster) 
					{
						checkEvent = true;
					}
					_arrUserList[i].isMaster = _arrUserList[i].isMaster;
					//_arrUserInfo[i - 1].removeAllCards();
					_arrUserInfo[i - 1].visible = true;
					
					_arrUserInfo[i - 1].getInfoPlayer(_arrUserList[i]["position"], _arrUserList[i].userName, 
														_arrUserList[i].money, _arrUserList[i].avatar,
													_arrUserList[i].remaningCard, _arrUserList[i].ready, _isPlaying, 
													_arrUserList[i].isMaster, _arrUserList[i].displayName, _arrUserList[i].sex
													);
					//checkPosClock();
					if (SoundManager.getInstance().isSoundOn) 
					{
						var rd:int = int(Math.random() * 5);
						
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
			startGame = false;
			
			
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
			
			
			var arrAgain:Array = [];
			var i:int;
			
			for (i = 0; i < arr.length; i++) 
			{
				trace(arr[i]["userName"], "=========================", arr[i]["position"])
			}
			
			for (i = 0; i < arr.length; i++) 
			{
				if (arr[i]["position"] == pos) 
				{
					arrAgain[0] = arr[i];
				}
				
			}
			
			arrAgain[1] = [];
			for (i = 0; i < arr.length; i++) 
			{
				
				if (arr[i]["position"] )
				{
					
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 1) % 4)
					{
						arrAgain[1] = arr[i];
						
						break;
					}
					
				}
				else if (arr[i]["position"] == 0) 
				{
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 1) % 4)
					{
						arrAgain[1] = arr[i];
						
						break;
					}
				}
			}
			arrAgain[2] = [];
			for (i = 0; i < arr.length; i++) 
			{
			
				
				if (arr[i]["position"] )
				{
					
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 2) % 4)
					{
						arrAgain[2] = arr[i];
						trace("=========lay dc thang thu 3=========")
						break;
					}
					
				}
				else if (arr[i]["position"] == 0) 
				{
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 2) % 4)
					{
						arrAgain[2] = arr[i];
					
						break;
					}
				}
			}
			arrAgain[3] = [];
			for (i = 0; i < arr.length; i++) 
			{
				
				
				if (arr[i]["position"] )
				{
					
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 3) % 4)
					{
						arrAgain[3] = arr[i];
						
						break;
					}
					
				}
				else if (arr[i]["position"] == 0) 
				{
					if (int(arr[i]["position"]) === (int(arrAgain[0]["position"]) + 3) % 4)
					{
						arrAgain[3] = arr[i];
						
						break;
					}
				}
			}
			
			trace(arrAgain[0]["userName"])
			trace(arrAgain[1]["userName"])
			trace(arrAgain[2]["userName"])
			trace(arrAgain[3]["userName"])
			
			/*for (i = 0; i < 4; i++) 
			{
				
				if (pos + i < 4) 
				{
					if (arr[pos + i]) 
					{
						arrAgain[i] = arr[pos + i];
					}
					else 
					{
						arrAgain[i] = [];
					}
				}
				else 
				{
					arrAgain[i] = arr[(4 - (pos + i)) * (-1)];
				}
				
			}
			var arrAgainLength:int = arrAgain.length;
			
			for (i = 0; i < arr.length - arrAgainLength; i++) 
			{
				arrAgain[arrAgainLength + i] = arr[i];
			}
			
			for (i = 0; i < arrAgain.length; i++) 
			{
				if (!arrAgain[i].remaningCard) 
				{
					arrAgain[i].remaningCard = 0;
				}
				//trace(arr[i].userName)
				//trace(arrAgain[i].userName)
			}*/
			
			return arrAgain;
		}
		
		
		
	}

}