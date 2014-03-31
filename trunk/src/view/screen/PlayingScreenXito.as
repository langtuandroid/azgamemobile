package view.screen 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.gskinner.motion.GTween;
	import control.MainCommand;
	import event.Command;
	import event.DataField;
	import event.PlayingScreenEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import view.button.MyButton;
	import view.card.Card;
	import view.card.CardManagerXito;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfoXito;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.ResultWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenXito extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		
		private var belowUserInfo:PlayerInfoXito;
		private var rightUserInfo:PlayerInfoXito;
		private var leftUserInfo:PlayerInfoXito;
		private var aboveLeftUserInfo:PlayerInfoXito;
		private var aboveRightUserInfo:PlayerInfoXito;
		
		private var chatBox:ChatBox;
		
		private var cardManager:CardManagerXito;
		private var allPlayerArray:Array; // Mảng chứa tất cả người chơi
		private var playingPlayerArray:Array; // Mảng chứa các người chơi đang trong ván bài
		
		private var roomBet:TextField;
		private var channelNameAndRoomId:TextField;
		private var ruleDescription:TextField;
		private var waitToReady:TextField;
		private var waitToPlay:TextField;
		private var waitToStart:TextField;
		private var totalMoneyText:TextField;
		private var previousBetText:TextField;
		
		private var mainData:MainData = MainData.getInstance();
		
		private var readyButton:MyButton;
		private var startButton:MyButton;
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var timerToResetMatch:Timer;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var effectTime:Number = 1;
		private var jumpIndex:int = 0; // Bước nhẩy để tính khoảng cách chênh lệch giữa position người chơi của server và client
		private var effectLayer:EffectLayer = EffectLayer.getInstance();
		private var resultWindow:ResultWindow;
		private var isPlaying:Boolean;
		private var timerToPing:Timer;
		private var pingTime:int = 55;
		private var myContextMenu:MyContextMenu;
		
		private var playingLayer:Sprite;
		private var chatboxLayer:Sprite;
		
		public function PlayingScreenXito() 
		{
			super();
			addContent("zPlayingScreenXito");
			createLayer();
			setupTextField();
			hidePosition();
			createVariable();
			mainData.playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			chatBox = new ChatBox();
			chatBox.visible = false;
			waitToPlay = content["waitToPlay"];
			waitToReady = content["waitToReady"];
			waitToStart = content["waitToStart"];
			totalMoneyText = content["totalMoneyText"];
			previousBetText = content["previousBetText"];
			waitToPlay.selectable = waitToReady.selectable = waitToStart.selectable = false;
			waitToReady.visible = waitToPlay.visible = waitToStart.visible = false;
			chatboxLayer.addChild(chatBox);
			
			timerToPing = new Timer(pingTime * 1000);
			timerToPing.addEventListener(TimerEvent.TIMER, onPingToServer);
			timerToPing.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			content["leaveCardPoint"].visible = false;
			//addPlayer();
			
			zPlayingScreenXito(content).chatButton.addEventListener(MouseEvent.CLICK, onChatIconClick);
		}
		
		private function createLayer():void 
		{
			playingLayer = new Sprite();
			chatboxLayer = new Sprite();
			addChild(playingLayer);
			addChild(chatboxLayer);
		}
		
		private function onChatIconClick(e:MouseEvent):void 
		{
			chatBox.visible = true;
		}
		
		public function addPlayer():void // add người chơi - tùy thuộc số lượng
		{
			addOnePlayer(0);
			addOnePlayer(1);
			addOnePlayer(3);
			addOnePlayer(2);
			addOnePlayer(4);
			
			belowUserInfo.cardInfoArray = [1, 2, 3, 4, 5];
			leftUserInfo.cardInfoArray = [1, 2, 3, 4, 5];
			rightUserInfo.cardInfoArray = [1, 2, 3, 4, 5];
			aboveLeftUserInfo.cardInfoArray = [1, 2, 3, 4, 5];
			aboveRightUserInfo.cardInfoArray = [1, 2, 3, 4, 5];
			
			addCardManager();
			playingPlayerArray = new Array();
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
					playingPlayerArray.push(allPlayerArray[i]);
			}
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				var moneyEffectPosition:Point = PlayerInfoXito(allPlayerArray[i]).localToGlobal(PlayerInfoXito(allPlayerArray[i]).moneyEffectPosition);
				var resultEffectPosition:Point = PlayerInfoXito(allPlayerArray[i]).localToGlobal(PlayerInfoXito(allPlayerArray[i]).resultEffectPosition);
				//effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, 100, 100000);
				//effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, resultEffectPosition, 100, 0, "Thùng phá sảnh");
				PlayerInfoXito(allPlayerArray[i]).isPlaying = true;
				//PlayerInfoXito(allPlayerArray[i]).countTime(100);
				PlayerInfoXito(allPlayerArray[i]).setAction(PlayerInfoXito.CHECK);
			}
		}
		
		private function onFriendConfirmAddFriendInvite(e:Event):void 
		{
			var alertWindow:AlertWindow = new AlertWindow();
			
			if (mainData.responseAddFriendData[DataField.CONFIRM])
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataField.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.acceptAddFriend);
				if (mainData.chooseChannelData.myInfo.siteId == 2)
				{
					alertWindow.addFeedButton();
					alertWindow.feedName = DataField.ACCEPT_FRIEND;
					var option:Object = new Object();
					option[DataField.FRIEND_NAME] = mainData.responseAddFriendData[DataField.DISPLAY_NAME];
					alertWindow.feedOption = option;
				}
			}
			else
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataField.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.rejectAddFriend);
			}
			
			windowLayer.openWindow(alertWindow);
		}
		
		private function onConfirmFriendRequest(e:Event):void 
		{
			var invitedNameArray:Array = [mainData.confirmFriendRequestData[DataField.FRIEND_ID]];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataField.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataField.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataField.MESSAGE, mess);
			
			if (mainData.confirmFriendRequestData[DataField.CONFIRM])
			{
				if (electroServerCommand.coreAPI.myData.friendList)
				{
					electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataField.FRIEND_ID]] = new Object();
					if (electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataField.FRIEND_ID]])
					{
						var displayName:String = electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataField.FRIEND_ID]][DataField.USER_INFO][DataField.DISPLAY_NAME];
						electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataField.FRIEND_ID]][DataField.DISPLAY_NAME] = displayName;
					}
				}
				esObject.setBoolean(DataField.CONFIRM, true);
			}
			else
			{
				esObject.setBoolean(DataField.CONFIRM, false);
			}
			
			electroServerCommand.sendPrivateMessage(invitedNameArray, Command.CONFIRM_ADD_FRIEND_INVITE, esObject);
		}
		
		private function onInviteAddFriend(e:Event):void 
		{
			var inviteAddFriendWindow:ConfirmWindow = new ConfirmWindow();
			inviteAddFriendWindow.setNotice(mainData.inviteAddFriendData[DataField.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.addFriendSentence);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmInvite);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.REJECT, onRejectInvite);
			windowLayer.openWindow(inviteAddFriendWindow);
		}
		
		private function onConfirmInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataField.USER_NAME], true, DataField.IN_GAME_ROOM);
		}
		
		private function onRejectInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataField.USER_NAME], false, DataField.IN_GAME_ROOM);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			
			var currDate:Date = new Date();
			
			var H:int = currDate.getHours();
			
			if (H >= 6 && H <= 18)
				MovieClip(content["background"]).gotoAndStop("day");
			else
				MovieClip(content["background"]).gotoAndStop("night");
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (timerToPing)
			{
				timerToPing.removeEventListener(TimerEvent.TIMER, onPingToServer);
				timerToPing.stop();
			}
		}
		
		private function onPingToServer(e:TimerEvent):void 
		{
			electroServerCommand.pingToServer();
		}
		
		public function effectOpen():void
		{
			mainData.addEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.addEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.addEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.addEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			//alpha = 0;
			//var tempTween1:GTween = new GTween(this, effectTime, { alpha:1 } );
		}
		
		public function effectClose():void
		{
			mainData.removeEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.removeEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.removeEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.removeEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			//var tempTween1:GTween = new GTween(this, effectTime, { alpha:0 } );
			//tempTween1.addEventListener(Event.COMPLETE, closeComplete);
			dispatchEvent(new Event(CLOSE_COMPLETE));
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (allPlayerArray[i].userName == mainData.publicChatData.userName)
					{
						PlayerInfoXito(allPlayerArray[i]).addChatSentence(mainData.publicChatData.chatContent);
						return;
					}
				}
			}
		}
		
		private function closeComplete(e:Event):void 
		{
			dispatchEvent(new Event(CLOSE_COMPLETE));
		}
		
		private function createVariable():void 
		{
			allPlayerArray = new Array();
			playingPlayerArray = new Array();
		}
		
		private function hidePosition():void 
		{
			content["belowUserInfoPosition"].visible = false;
			content["leftUserInfoPosition"].visible = false;
			content["rightUserInfoPosition"].visible = false;
			content["aboveLeftUserInfoPosition"].visible = false;
			content["aboveRightUserInfoPosition"].visible = false;
			content["cardManagerPosition"].visible = false;
			content["readyButtonPosition"].visible = false;
			content["chatBoxPosition"].visible = false;
		}
		
		private function onUpdatePlayingScreen(e:PlayingScreenEvent):void 
		{
			var data:Object;
			switch (e.data[ModelField.ACTION_NAME]) 
			{
				case PlayingScreenAction.JOIN_ROOM: // mình vừa join room
					listenJoinRoom(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_JOIN_ROOM: // có người khác join room
					listenHaveUserJoineRoom(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_OUT_ROOM: // có người khác rời room
					listenHaveUserOutRoom(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.READY_SUCCESS: // có người ấn ready
					listenReadySuccess(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.START_GAME_SUCCESS: // chủ phòng ấn start
					listenStartGameSuccess(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.DEAL_CARD: // chia bài
					listenDealCard(e.data[ModelField.DATA]);
				break;
				break;
				case PlayingScreenAction.HAVE_USER_OPEN_CARD: // có user lật bài
					listenHaveUserOpenCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.CHECK: // có user nhường tố
					listenHaveUserCheck(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.RAISE: // có user tố
					listenHaveUserRaise(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.CALL: // có user theo
					listenHaveUserCall(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.FOLD: // có user ụp bài
					listenHaveUserFold(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.UPDATE_CURRENT_TURN: 
					listenUpdateCurrentTurn(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.GAME_OVER: // ván kết thúc
					listenGameOver(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.UPDATE_ROOM_MASTER: // Cập nhật thay đổi chủ phòng
					listenUpdateRoomMaster(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.ROOM_MASTER_KICK: // Bị chủ phòng kick
					listenRoomMasterKick(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.UPDATE_MONEY: // update tiền
					listenUpdateMoney(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.DEAL_MORE_CARD: // Chia thêm bài cho lượt mới
					listenDealMoreCard(e.data[ModelField.DATA]);
				break;
			}
		}
		
		private function listenHaveUserJoineRoom(data:Object):void 
		{
			chatBox.addChatSentence(data[DataField.DISPLAY_NAME] + " " + mainData.init.gameDescription.playingScreen.userJoinRoom, "Thông báo");
			var indexEmpty:int;
			indexEmpty = allPlayerArray.length;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (!allPlayerArray[i])
				{
					var tempNumber:int = i + jumpIndex;
					if (tempNumber > 4)
						tempNumber -= mainData.maxPlayer;
					if(indexEmpty > tempNumber)
					indexEmpty = tempNumber;
				}
			}
			indexEmpty -= jumpIndex;
			if (indexEmpty < 0)
				indexEmpty += mainData.maxPlayer;
			addOnePlayer(indexEmpty);
			data[DataField.POSITION] = indexEmpty;
			addPersonalInfo(data);
			
			var countPlayer:int = 0;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
					countPlayer++;
			}
			if (!isPlaying && countPlayer == 2)
			{
				removeCardManager();
				waitToPlay.visible = true;
				waitToReady.visible = false;
			}
		}
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			var i:int;
			var j:int;
			if (isPlaying)
			{
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoXito(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
							removeOnePlayer(i);
						}
					}
					for (j = 0; j < allPlayerArray.length; j++) 
					{
						if (allPlayerArray[j])
							countPlayer++;
					}
					if (countPlayer < 2)
						removeCardManager();
				}
			}
			else
			{
				var countPlayer:int = 0;
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoXito(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
							removeOnePlayer(i);
						}
					}
				}
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
						countPlayer++;
				}
				if (countPlayer < 2)
				{
					waitToReady.visible = true;
					waitToPlay.visible = false;
					belowUserInfo.isReadyPlay = false;
					//isHaveUserReady = false;
					hideReadyButton();
				}
				if (belowUserInfo.isRoomMaster)
				{
					for (i = 0; i < allPlayerArray.length; i++) 
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay)
								return;
						}
					}
					hideStartButton();
					if(countPlayer > 1)
						waitToPlay.visible = true;
				}
			}
		}
		
		private function listenJoinRoom(data:Object):void 
		{
			mainData.isSelectOpenCard = false;
			roomBet.text = PlayingLogic.format(data[DataField.ROOM_BET], 1);
			roomBet.selectable = ruleDescription.selectable = false;
			
			mainData.playingData.gameRoomData.roomBet = data[DataField.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataField.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataField.IS_SEND_CARD];
			
			if (data[DataField.IS_SEND_CARD])
				ruleDescription.text = "Gửi bài";
			else
				ruleDescription.text = "Không gửi bài";
			
			var i:int;
			var userList:Array = data[DataField.USER_LIST] as Array;
			
			// sắp xếp lại các position
			reArrangePositions(userList);
			
			// add người chơi
			for (i = 0; i < userList.length; i++) 
			{
				addOnePlayer(userList[i][DataField.POSITION]);
			}
			
			// bổ sung thông tin cá nhân
			for (i = 0; i < userList.length; i++) 
			{
				addPersonalInfo(userList[i]);
			}
			
			belowUserInfo.setMyTurn(PlayerInfoXito.DO_NOTHING);
			
			if (data[DataField.GAME_STATE] == DataField.WAITING) // Nếu phòng chơi chưa bắt đầu
			{
				if (allPlayerArray.length > 1)
					showReadyButton();
				else
					waitToReady.visible = true;
			}
			else // Nếu phòng chơi đang chơi
			{
				if (data[DataField.GAME_STATE] == DataField.PRE_FLOP && data[DataField.CURRENT_POT] == 0) // Trường hợp vào đúng lúc có lệnh chia bài
				{
					for (i = 0; i < allPlayerArray.length; i++)
					{
						for (var j:int = 0; j < userList.length; j++) 
						{
							if (PlayerInfoXito(allPlayerArray[i]))
							{
								if (PlayerInfoXito(allPlayerArray[i]).userName == userList[j][DataField.USER_NAME])
								{
									if (!userList[j][DataField.IS_VIEWER])
										PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
								}
							}
						}
					}
				}
				else
				{
					addCardManager();
					currentTotalMoney = data[DataField.CURRENT_POT];
					// bổ sung thông tin cá nhân
					for (i = 0; i < userList.length; i++) 
					{
						// Không phải add cho mình vì minh vừa vào nên chắc chắc là không có bài
						if(!userList[i][DataField.IS_VIEWER]) 
							addCardInfo(userList[i]);
					}
				
					playingPlayerArray = new Array();
					for (i = 0; i < allPlayerArray.length; i++)
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoXito(allPlayerArray[i]).isPlaying)
							{
								playingPlayerArray.push(allPlayerArray[i]);
							}
						}
					}
					isPlaying = true;
					cardManager.playerArray = playingPlayerArray;
				}
			}
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
					{
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = true;
						i = allPlayerArray.length + 1;
					}
				}
			}
		}
		
		private function listenDealCard(data:Object):void 
		{
			//isHaveUserReady = false;
			hideReadyButton();
			waitToPlay.visible = false;
			waitToReady.visible = false;
			waitToStart.visible = false;
			var i:int;
			isPlaying = true;
			playingPlayerArray = new Array();
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay)
						playingPlayerArray.push(allPlayerArray[i]);
				}
			}
			
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoXito(playingPlayerArray[i]).isPlaying = true;
				PlayerInfoXito(playingPlayerArray[i]).isReadyPlay = false;
				PlayerInfoXito(playingPlayerArray[i]).playingPlayerArray = playingPlayerArray;
				
				PlayerInfoXito(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.selectOpenCardTime));
				if (playingPlayerArray[i] == belowUserInfo)
				{
					belowUserInfo.setMyTurn(PlayerInfoXito.SELECT_OPEN_CARD);
				}
				
				if (playingPlayerArray[i] == belowUserInfo) // Gán cho mình dữ liệu các lá bài của server gửi về
					PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = data[DataField.PLAYER_CARDS] as Array;
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
					PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = [0, 0];
			}
			addCardManager();
			cardManager.playerArray = playingPlayerArray;
			if (playingPlayerArray.length != 0)
				cardManager.divideCard();
			
			currentTotalMoney = playingPlayerArray.length * Number(mainData.playingData.gameRoomData.roomBet);
			mainData.startMoney = playingPlayerArray.length * Number(mainData.playingData.gameRoomData.roomBet);
		}
		
		private function listenHaveUserCheck(data:Object):void // có user nhường tố
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.CHECK);
					return;
				}
			}
		}
		
		private function listenHaveUserRaise(data:Object):void // có user tố
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					switch (data[DataField.RAISE_TYPE]) 
					{
						case 1:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE);
						break;
						case 2:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_QUATER);
						break;
						case 3:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_HALF);
						break;
						case 4:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_DOUBLE);
						break;
						case 5:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.ALL_IN);
						break;
						default:
					}
					betMoneyOfPreviousUser = data[DataField.MONEY] - (mainData.maxMoneyOfRound - PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound);
					PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound += Number(data[DataField.MONEY]);
					currentTotalMoney += Number(data[DataField.MONEY]);
					mainData.actionStatus = 2; // trạng thái đã có ng tố
				}
				if (PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound > mainData.maxMoneyOfRound)
					mainData.maxMoneyOfRound = PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound;
			}
		}
		
		private function listenHaveUserCall(data:Object):void // có user theo
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.CALL);
					var callMoney:Number = mainData.maxMoneyOfRound - PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound;
					if (mainData.moneyOfCurrentUser >= callMoney)
						currentTotalMoney += callMoney;
					else // trường hợp user đó hết tiền thì số tiền gà hiện tại phải cộng thêm số tiền user đó còn lại chứ không phải số tiền theo chuẩn.
						currentTotalMoney += mainData.moneyOfCurrentUser;
					PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound = mainData.maxMoneyOfRound;
					return;
				}
			}
		}
		
		private function listenHaveUserFold(data:Object):void // có user ụp bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.FOLD);
					for (var j:int = 0; j < PlayerInfoXito(playingPlayerArray[i]).unLeaveCards.length; j++) 
					{
						PlayerInfoXito(playingPlayerArray[i]).addValueForOneUnleavedCard(0);
					}
					return;
				}
			}
		}
		
		private function listenDealMoreCard(data:Object):void // chia thêm bài
		{
			mainData.actionStatus = 1; // Chia thêm bài, bắt đầu 1 lượt tố mới
			var i:int;
			mainData.maxMoneyOfRound = 0;
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound = 0;
			}
			if (data[DataField.USER_LIST].length < 2) // Lượt chia bài cuối
			{
				for (i = 0; i < playingPlayerArray.length; i++) 
				{
					if (playingPlayerArray[i] == belowUserInfo && data[DataField.USER_LIST][i])
						cardManager.divideOneCard(playingPlayerArray[i], data[DataField.USER_LIST][i][DataField.CARD_ID]);
					else
						cardManager.divideOneCard(playingPlayerArray[i], 0);
				}
			}
			else
			{
				for (i = 0; i < data[DataField.USER_LIST].length; i++) 
				{
					for (var j:int = 0; j < playingPlayerArray.length; j++) 
					{
						if (data[DataField.USER_LIST][i][DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
							cardManager.divideOneCard(playingPlayerArray[j], data[DataField.USER_LIST][i][DataField.CARD_ID]);
					}
				}
			}
		}
		
		private function listenUpdateCurrentTurn(data:Object):void // cập nhật turn hiện tại
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataField.CURRENT_TURN] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.selectActionTime));
					mainData.moneyOfCurrentUser = PlayerInfoXito(playingPlayerArray[i]).moneyNumber;
					if (playingPlayerArray[i] == belowUserInfo)
						belowUserInfo.setMyTurn(PlayerInfoXito.SELECT_ACTION);
					else
						PlayerInfoXito(playingPlayerArray[i]).isMyTurn = true;
					return;
				}
			}
		}
		
		private function listenHaveUserOpenCard(data:Object):void // có user lật bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).addValueForOneUnleavedCard(data[DataField.OPEN_CARDS][0]);
					PlayerInfoXito(playingPlayerArray[i]).stopCountTime();
					return;
				}
			}
		}
		
		private function listenUpdateRoomMaster(data:Object):void // cập nhật thay đổi chủ phòng
		{
			var i:int;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = true;
					else
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = false;
				}
			}
			if (!isPlaying)
			{
				if (belowUserInfo.isRoomMaster)
				{
					waitToPlay.visible = false;
					waitToReady.visible = false;
					waitToStart.visible = false;
				
					for (i = 0; i < allPlayerArray.length; i++)
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay && allPlayerArray[i] != belowUserInfo)
							{
								belowUserInfo.isReadyPlay = false;
								hideReadyButton();
								showStartButton();
								return;
							}
						}
					}
					hideReadyButton();
					belowUserInfo.isReadyPlay = false;
					waitToPlay.visible = true;
				}
				else
				{
					for (i = 0; i < allPlayerArray.length; i++)
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoXito(allPlayerArray[i]).isRoomMaster)
							{
								PlayerInfoXito(allPlayerArray[i]).isReadyPlay = false;
								return;
							}
						}
					}
				}
			}
		}
		
		private function listenRoomMasterKick(data:Object):void // Bị chủ phòng kick
		{
			if (data[DataField.USER_NAME] == belowUserInfo.userName) // Nếu người bị kick là mình
			{
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.roomMasterKick);
				windowLayer.openWindow(kickOutWindow);
				
				dispatchEvent(new Event(PlayerInfoXito.EXIT));
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom(true);
			}
		}
		
		private function listenUpdateMoney(data:Object):void // update tiền
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataField.USER_NAME])
					{
						PlayerInfoXito(allPlayerArray[i]).updateMoney(data[DataField.MONEY]);
						
						if (data[DataField.USER_NAME] == belowUserInfo.userName && !isPlaying)
						{
							// Nếu không đủ tiền để chơi ván mới
							if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet))
							{
								if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
								{
									var kickOutWindow:AlertWindow = new AlertWindow();
									kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
									windowLayer.openWindow(kickOutWindow);
								}
								
								dispatchEvent(new Event(PlayerInfoXito.EXIT));
								windowLayer.isNoCloseAll = true;
								electroServerCommand.joinLobbyRoom();
								
								EffectLayer.getInstance().removeAllEffect();
							}
						}
					}
				}
			}
		}
		
		private function listenGameOver(data:Object):void // ván bài kết thúc
		{
			var playerList:Array = data[DataField.PLAYER_LIST] as Array;
			var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			var time:Number;
			totalMoneyText.text = '';
			previousBetText.text = '';
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					PlayerInfoXito(playingPlayerArray[j]).isPlaying = false;
					if (playerList[i][DataField.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
					{
						PlayerInfoXito(playingPlayerArray[j]).stopCountTime();
						
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfoXito(playingPlayerArray[j]).localToGlobal(PlayerInfoXito(playingPlayerArray[j]).moneyEffectPosition);
						if (playerList[i][DataField.MONEY])
						{
							effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataField.MONEY]);
						}
						else
						{
							if (playerList.length < 2)
								effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, mainData.currentTotalMoney);
						}
						resultEffectPosition = PlayerInfoXito(playingPlayerArray[j]).localToGlobal(PlayerInfoXito(playingPlayerArray[j]).resultEffectPosition);
						if (playerList[i][DataField.GROUP_RANK])
							effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, resultEffectPosition, time,0, playerList[i][DataField.GROUP_RANK]);
					}
					
					if (PlayerInfoXito(playingPlayerArray[j]).userName == playerList[i][DataField.USER_NAME] && playingPlayerArray[j] != belowUserInfo)
					{
						if (playerList[i][DataField.HAND_CARDS])
						{
							var cardArray:Array = playerList[i][DataField.HAND_CARDS] as Array;
							for (var k:int = 0; k < cardArray.length; k++) 
							{
								PlayerInfoXito(playingPlayerArray[j]).addValueForOneUnleavedCard(cardArray[k]);
							}
							PlayerInfoXito(playingPlayerArray[j]).openAllCard();
						}
					}
				}
			}
				
			belowUserInfo.setMyTurn(PlayerInfoXito.DO_NOTHING);
			
			resultWindow = new ResultWindow();
			resultWindow.setInfo(playerList);
			
			timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
		}
		
		private function onResetMatch(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			totalMoneyText.text = '';
			previousBetText.text = '';
			
			for (var i:int = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
					PlayerInfoXito(allPlayerArray[i]).isPlaying = false;
			}
				
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet))
			{
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					var kickOutWindow:AlertWindow = new AlertWindow();
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				
				dispatchEvent(new Event(PlayerInfoXito.EXIT));
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom();
				
				EffectLayer.getInstance().removeAllEffect();
				return;
			}
			
			windowLayer.openWindow(resultWindow);
			resetMatch();
			isPlaying = false;
		}
		
		private function resetMatch():void // reset ván bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				PlayerInfoXito(playingPlayerArray[i]).removeAllCards();
			}
			var countPlayer:int = 0;
			for (var j:int = 0; j < allPlayerArray.length; j++) 
			{
				if (allPlayerArray[j])
					countPlayer++;
			}
			if (countPlayer > 1)
			{
				if (!belowUserInfo.isRoomMaster)
				{
					showReadyButton();
				}
				else
				{
					waitToPlay.visible = true;
					for (j = 0; j < allPlayerArray.length; j++) 
					{
						if (allPlayerArray[j])
						{
							if (PlayerInfoXito(allPlayerArray[j]).isReadyPlay)
							{
								showStartButton();
								waitToPlay.visible = false;
								j = allPlayerArray.length + 1;
							}
						}
					}
				}
			}
			else
			{
				waitToReady.visible = true;
			}
			removeCardManager();
			mainData.isSelectOpenCard = false;
		}
		
		private function showReadyButton():void
		{
			waitToReady.visible = false;
			if (!readyButton)
				createButton("readyButton", "zReadyButton", "readyButtonPosition");
			readyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			playingLayer.addChild(readyButton);
		}
		
		private function hideReadyButton():void
		{
			var countPlayer:int = 0;
			var i:int;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
					countPlayer++;
			}
				
			if (readyButton)
			{
				if (this.contains(readyButton))
					playingLayer.removeChild(readyButton);	
			}
		}
		
		private function showStartButton():void
		{
			if (!startButton)
			{
				createButton("startButton", "zStartButton", "readyButtonPosition");
				startButton.buttonMode = false;
			}
			startButton.content["child"].addEventListener(MouseEvent.CLICK, onButtonClick);
			playingLayer.addChild(startButton);
		}
		
		private function hideStartButton():void
		{
			if (startButton)
			{
				if (this.contains(startButton))
					playingLayer.removeChild(startButton);	
			}
		}
		
		// add một người chơi, đầu vào là vị trí tương ứng từ 1-5
		public function addOnePlayer(position:int):void 
		{
			switch (position) 
			{
				case 0:
					addPlayerByType(PlayerInfoXito.BELOW_USER, position, true);
					// Lắng nghe đến lượt mình bốc bài thì thông báo cho cardManager
					belowUserInfo.addEventListener(PlayerInfoXito.GET_CARD_TURN, onGetCardTurn);
					// Lắng nghe nếu mình ăn bài thì thông báo để cardManager không nhấp nháy nữa
					belowUserInfo.addEventListener(PlayerInfoXito.STEAL_CARD, onStealCard); 
					// Lắng nghe nếu mình bốc bài thì thông báo để cardManager không nhấp nháy nữa
					belowUserInfo.addEventListener(PlayerInfoXito.GET_CARD, onGetCard); 
				break;
				case 1:
					addPlayerByType(PlayerInfoXito.RIGHT_USER, position, false);
				break;
				case 2:
					addPlayerByType(PlayerInfoXito.ABOVE_RIGHT_USER, position, false);
				break;
				case 3:
					addPlayerByType(PlayerInfoXito.ABOVE_LEFT_USER, position, false);
				break;
				case 4:
					addPlayerByType(PlayerInfoXito.LEFT_USER, position, false);
				break;
			}
		}
		
		private function onGetCard(e:Event):void 
		{
			cardManager.hideTwinkle();
		}
		
		private function onStealCard(e:Event):void 
		{
			cardManager.hideTwinkle();
		}
		
		private function onGetCardTurn(e:Event):void 
		{
			cardManager.showTwinkle();
		}
		
		// add thông tin cá nhân (tên, money, cấp độ, avatar)
		public function addPersonalInfo(data:Object):void
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						PlayerInfoXito(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataField.READY])
						{
							//isHaveUserReady = true;
							PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
						}
						i = allPlayerArray.length;
					}
				}
			}
		}
		
		// add thông tin các quân bài
		public function addCardInfo(data:Object):void
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfoXito(allPlayerArray[i]).isPlaying = true;
						i = allPlayerArray.length;
					}
				}
			}
		}
		
		public function removeOnePlayer(position:int):void // xóa một người chơi
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).position == position)
					{
						if (isPlaying)
						{
							for (var j:int = 0; j < playingPlayerArray.length; j++) 
							{
								if (PlayerInfoXito(allPlayerArray[i]) == PlayerInfoXito(playingPlayerArray[j]))
								{
									playingPlayerArray.splice(j, 1);
									j = playingPlayerArray.length + 1;
								}
							}
						}
						allPlayerArray[i] = null;
						i = allPlayerArray.length + 1;
					}
				}
			}
			var countPlayer:int = 0;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
					countPlayer++;
			}
			
			if (countPlayer < 2)
				hideReadyButton();
				
			switch (position) 
			{
				case 0:
					PlayerInfoXito(this[PlayerInfoXito.BELOW_USER]).destroy();
				break;
				case 1:
					PlayerInfoXito(this[PlayerInfoXito.RIGHT_USER]).destroy();
				break;
				case 2:
					PlayerInfoXito(this[PlayerInfoXito.ABOVE_RIGHT_USER]).destroy();
				break;
				case 3:
					PlayerInfoXito(this[PlayerInfoXito.ABOVE_LEFT_USER]).destroy();
				break;
				case 4:
					PlayerInfoXito(this[PlayerInfoXito.LEFT_USER]).destroy();
				break;
			}
		}
		
		private function addPlayerByType(playerType:String, position:int, isCardInteractive:Boolean = false):void
		{
			this[playerType] = new PlayerInfoXito();
			this[playerType].addEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
			PlayerInfoXito(this[playerType]).position = position;
				
			// Có cho phép tương tác vào quân bài của người chơi này không
			PlayerInfoXito(this[playerType]).isCardInteractive = isCardInteractive;
			
			PlayerInfoXito(this[playerType]).setForm(playerType);
				
			this[playerType].x = content[playerType + "Position"].x;
			this[playerType].y = content[playerType + "Position"].y;
			playingLayer.addChild(this[playerType]);
			allPlayerArray[position] = this[playerType];
		}
		
		private function onShowContextMenu(e:Event):void 
		{
			if (myContextMenu)
			{
				if (contains(myContextMenu))
				{
					myContextMenu.removeEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
					myContextMenu.removeEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
					playingLayer.removeChild(myContextMenu);
				}
			}
			
			myContextMenu = new MyContextMenu();
			myContextMenu.addEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
			myContextMenu.addEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
				
			var contextMenuData:Object = new Object();
			contextMenuData[DataField.DISPLAY_NAME] = PlayerInfoXito(e.currentTarget).displayName;
			contextMenuData[DataField.USER_NAME] = PlayerInfoXito(e.currentTarget).userName;
			contextMenuData[DataField.AVATAR] = PlayerInfoXito(e.currentTarget).avatarString;
			contextMenuData[DataField.LOGO] = PlayerInfoXito(e.currentTarget).logoString;
			myContextMenu.data = contextMenuData;
			
			if (!isPlaying && belowUserInfo.isRoomMaster)
				myContextMenu.enableKickOut = true;
			else
				myContextMenu.enableKickOut = false;
				
			var tempPoint:Point = PlayerInfoXito(e.currentTarget).contextMenuPosition;
			tempPoint = PlayerInfoXito(e.currentTarget).localToGlobal(tempPoint);
			tempPoint = globalToLocal(tempPoint);
			myContextMenu.x = Math.round(tempPoint.x);
			myContextMenu.y = Math.round(tempPoint.y);
			if (!contains(myContextMenu))
			{
				playingLayer.addChild(myContextMenu);
			}
			else
			{
				myContextMenu.removeEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
				myContextMenu.removeEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
				playingLayer.removeChild(myContextMenu);
			}
		}
		
		private function onKickOutClick(e:Event):void 
		{
			var confirmKickOutWindow:ConfirmWindow = new ConfirmWindow();
			confirmKickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmKickOut + " " + myContextMenu.data[DataField.DISPLAY_NAME]);
			confirmKickOutWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmKickOut);
			windowLayer.openWindow(confirmKickOutWindow);
		}
		
		private function onAccuseClick(e:Event):void 
		{
			var accuseWindow:AccuseWindow = new AccuseWindow();
			accuseWindow.data = myContextMenu.data;
			windowLayer.openWindow(accuseWindow);
		}
		
		private function onConfirmKickOut(e:Event):void 
		{
			electroServerCommand.kickUser(myContextMenu.data[DataField.USER_NAME]);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (myContextMenu)
			{
				if (contains(myContextMenu))
				{
					myContextMenu.removeEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
					myContextMenu.removeEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
					playingLayer.removeChild(myContextMenu);
				}
			}
		}
		
		// Hàm sắp xếp lại thứ tự của mảng các người chơi
		private function arrangePlayer():void
		{
			var isArrangeFinish:Boolean;
			while (!isArrangeFinish && playingPlayerArray.length > 1)
			{
				for (var i:int = playingPlayerArray.length - 1; i > 0; i--) 
				{
					if (playingPlayerArray[i].position < playingPlayerArray[i - 1].position)
					{
						var tempPlayer:PlayerInfoXito = playingPlayerArray[i];
						playingPlayerArray[i] = playingPlayerArray[i - 1];
						playingPlayerArray[i - 1] = tempPlayer;
					}
					else
					{
						isArrangeFinish = true;
					}
				}
			}
		}
		
		private function addCardManager():void 
		{
			if (!cardManager)
				cardManager = new CardManagerXito();
			cardManager.x = content["cardManagerPosition"].x;
			cardManager.y = content["cardManagerPosition"].y;
			playingLayer.addChild(cardManager);
		}
		
		private function removeCardManager():void
		{
			if (cardManager)
			{
				if (contains(cardManager))
				{
					playingLayer.removeChild(cardManager);
				}
			}
		}
		
		private function createButton(buttonName:String,className:String,positionName:String):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].scaleX = this[buttonName].scaleY = 0.9;
			MyButton(this[buttonName]).addContent(className);
			this[buttonName].x = content[positionName].x;
			this[buttonName].y = content[positionName].y;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case readyButton:
					electroServerCommand.readyPlay();
					readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
				break;
				case startButton.content["child"]:
					electroServerCommand.startGame();
					startButton.content["child"].removeEventListener(MouseEvent.CLICK, onButtonClick);
				break;
			}
		}
		
		private function listenStartGameSuccess(data:Object):void
		{
			if (belowUserInfo.isRoomMaster)
			{
				hideStartButton();
				belowUserInfo.isReadyPlay = true;
			}
			else
			{
				for (var i:int = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (data[DataField.USER_NAME] == PlayerInfoXito(allPlayerArray[i]).userName)
							PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
					}
				}
			}
		}
		
		private function listenReadySuccess(data:Object):void 
		{
			if (belowUserInfo.isRoomMaster && !isPlaying)
			{
				waitToPlay.visible = false;
				showStartButton();
			}
			
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (data[DataField.USER_NAME] == PlayerInfoXito(allPlayerArray[i]).userName)
					{
						/*if (!isHaveUserReady)
						{
							for (var j:int = 0; j < allPlayerArray.length; j++) 
							{
								if (allPlayerArray[j])
								{
									if (allPlayerArray[j] != allPlayerArray[i] && !PlayerInfoXito(allPlayerArray[j]).isReadyPlay)
									{
										PlayerInfoXito(allPlayerArray[j]).showTooltip(mainData.init.gameDescription.playingScreen.readyAlert)
										PlayerInfoXito(allPlayerArray[j]).countTime(Number(mainData.init.playTime.readyTime));
										PlayerInfoXito(allPlayerArray[j]).isWaitingToReady = true;
									}
								}
							}
						}*/
						
						PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
						//isHaveUserReady = true;
						if (allPlayerArray[i] == belowUserInfo)
						{
							//belowUserInfo.isWaitingToReady = false;
							hideReadyButton();
							waitToStart.visible = true;
						}
						return;
					}
				}
			}
		}
		
		private function setupTextField():void
		{
			roomBet = content["roomBet"];
			roomBet.autoSize = TextFieldAutoSize.LEFT;
			channelNameAndRoomId = content["channelNameAndRoomId"];
			channelNameAndRoomId.autoSize = TextFieldAutoSize.LEFT;
			ruleDescription = content["ruleDescription"];
			ruleDescription.selectable = false;
			ruleDescription.visible = false;
			content["rule"].visible = false;
			channelNameAndRoomId.selectable = false;
			channelNameAndRoomId.text = "Kênh " + mainData.playingData.gameRoomData.channelName + " - Phòng " + mainData.playingData.gameRoomData.roomId;
		}
		
		// Sắp xếp lại vị trí của người chơi để position 0 bắt đầu từ chính người chơi của mình
		private function reArrangePositions(userList:Array):void
		{
			jumpIndex = 0; // Dùng để sắp xếp lại vị trí của các người chơi
			var i:int;
			
			// tính lại vị trí của các người chơi, vì position của chính mình bao giờ cũng là 0
			for (i = 0; i < userList.length; i++) 
			{
				if (userList[i][DataField.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					jumpIndex = userList[i][DataField.POSITION];
					i = userList.length;
				}
			}
			if (jumpIndex != 0)
			{
				for (i = 0; i < userList.length; i++) 
				{
					userList[i][DataField.POSITION] -= jumpIndex;
					if (userList[i][DataField.POSITION] < 0)
						userList[i][DataField.POSITION] += mainData.maxPlayer;
				}
			}
		}
		
		public function destroy():void
		{
			if (allPlayerArray)
			{
				for (var i:int = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						PlayerInfoXito(allPlayerArray[i]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						PlayerInfoXito(allPlayerArray[i]).destroy();
					}
				}
			}
			allPlayerArray = null;
			
			if(cardManager)
				cardManager.destroy();
			cardManager = null;
			playingPlayerArray = null;
			
			roomBet = null;
			channelNameAndRoomId = null;
			ruleDescription = null;
			
			if (mainData)
				mainData.playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			mainData = null;
			
			if(readyButton)
				readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			readyButton = null;
			mainCommand = null;
			electroServerCommand = null;
			windowLayer = null;
			
			if (timerToResetMatch)
			{
				timerToResetMatch.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.stop();
				timerToResetMatch = null;
			}
			
			if (parent)
				parent.removeChild(this);
		}
		
		private var _currentTotalMoney:Number = 0;
		
		public function get currentTotalMoney():Number 
		{
			return _currentTotalMoney;
		}
		
		public function set currentTotalMoney(value:Number):void 
		{
			_currentTotalMoney = value;
			mainData.currentTotalMoney = value;
			totalMoneyText.text = "Tổng tiền: " + String(PlayingLogic.format(value, 1));
		}
		
		public function get betMoneyOfPreviousUser():Number 
		{
			return _betMoneyOfPreviousUser;
		}
		
		public function set betMoneyOfPreviousUser(value:Number):void 
		{
			_betMoneyOfPreviousUser = value;
			previousBetText.text = "Tố: " + String(PlayingLogic.format(value, 1));
			mainData.betMoneyOfPreviousUser = value;
		}
		
		private var _betMoneyOfPreviousUser:Number = 0;
	}

}