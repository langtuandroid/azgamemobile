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
	import view.card.CardManagerPhom;
	import view.card.CardPhom;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.ResultWindowPhom;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenPhom extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		
		private var belowUserInfo:PlayerInfoPhom;
		private var rightUserInfo:PlayerInfoPhom;
		private var leftUserInfo:PlayerInfoPhom;
		private var aboveUserInfo:PlayerInfoPhom;
		
		private var chatBox:ChatBox;
		
		private var cardManager:CardManagerPhom;
		private var allPlayerArray:Array; // Mảng chứa tất cả người chơi
		private var playingPlayerArray:Array; // Mảng chứa các người chơi đang trong ván bài
		
		private var roomBet:TextField;
		private var channelNameAndRoomId:TextField;
		private var ruleDescription:TextField;
		private var waitToReady:TextField;
		private var waitToPlay:TextField;
		private var waitToStart:TextField;
		
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
		private var resultWindow:ResultWindowPhom;
		private var _isPlaying:Boolean;
		private var nextTurn:String; // Biến để lưu userName của thằng đánh ở turn kế tiếp
		//private var isHaveUserReady:Boolean;
		private var timerToPing:Timer;
		private var pingTime:int = 55;
		private var myContextMenu:MyContextMenu;
		
		private var playingLayer:Sprite;
		private var chatboxLayer:Sprite;
		
		private var potMoneyTxt:TextField;
		
		private var autoStartTimeTxt:TextField;
		private var gaIcon:Sprite;
		private var isFirstJoin:Boolean;
		private var timerToAutoStart:Timer;
		
		public function PlayingScreenPhom() 
		{
			super();
			addContent("zPlayingScreen");
			createLayer();
			setupTextField();
			hidePosition();
			createVariable();
			mainData.playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			chatBox = new ChatBox();
			waitToPlay = content["waitToPlay"];
			waitToReady = content["waitToReady"];
			waitToStart = content["waitToStart"];
			waitToPlay.selectable = waitToReady.selectable = waitToStart.selectable = false;
			waitToReady.visible = waitToPlay.visible = waitToStart.visible = false;
			chatboxLayer.addChild(chatBox);
			chatBox.visible = false;
			
			autoStartTimeTxt = content["autoStartTimeTxt"];
			autoStartTimeTxt.text = '';
			autoStartTimeTxt.visible = false;
			gaIcon = content["gaIcon"];
			gaIcon.visible = false;
			
			timerToPing = new Timer(pingTime * 1000);
			timerToPing.addEventListener(TimerEvent.TIMER, onPingToServer);
			timerToPing.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			zPlayingScreen(content).chatButton.addEventListener(MouseEvent.CLICK, onChatIconClick);
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
			//addPlayer();
			isFirstJoin = true;
			
			var currDate:Date = new Date();
			
			var H:int = currDate.getHours();
			
			if (H >= 6 && H <= 18)
				MovieClip(content["background"]).gotoAndStop("day");
			else
				MovieClip(content["background"]).gotoAndStop("night");
		}
		
		public function addPlayer():void // add người chơi - tùy thuộc số lượng
		{
			addOnePlayer(0);
			addOnePlayer(1);
			addOnePlayer(3);
			addOnePlayer(2);
			
			belowUserInfo.cardInfoArray = [1, 2, 3, 13, 11, 12, 11, 17, 18];
			
			leftUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0];
			rightUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0];
			aboveUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			
			addCardManager();
			playingPlayerArray = new Array();
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
					playingPlayerArray.push(allPlayerArray[i]);
			}
			cardManager.playerArray = playingPlayerArray;
			//cardManager.divideCard();
			belowUserInfo.setMyTurn(PlayerInfoPhom.PLAY_CARD);
			
			var cardInfo:Object = new Object();
			cardInfo[DataField.NUM_CARD] = 7;
			cardInfo[DataField.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataField.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataField.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [43, 44, 45, 46]];
			cardManager.addAllCard(rightUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataField.NUM_CARD] = 7;
			cardInfo[DataField.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataField.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataField.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(leftUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataField.NUM_CARD] = 7;
			cardInfo[DataField.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataField.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataField.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(aboveUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataField.NUM_CARD] = 7;
			cardInfo[DataField.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataField.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataField.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(belowUserInfo, cardInfo);
			
			for (i = 0; i < belowUserInfo.cardInfoArray.length; i++) 
			{
				var card:CardPhom;
				card = new CardPhom(belowUserInfo.unLeaveCardSize);
				card.id = belowUserInfo.cardInfoArray[i];
				card.rotation = belowUserInfo.unLeaveCardRotation;
				
				var tempPoint:Point = new Point();
				var tempObject:Object = belowUserInfo.getUnUsePosition(Card.UN_LEAVE_CARD);
				tempObject["isUsed"] = true;
				tempPoint.x = tempObject.x;
				tempPoint.y = tempObject.y;
				tempPoint.x = belowUserInfo.localToGlobal(tempPoint).x;
				tempPoint.y = belowUserInfo.localToGlobal(tempPoint).y;
			
				var point:Point = tempPoint;
				point = cardManager.globalToLocal(point);
				card.x = point.x;
				card.y = point.y;
				cardManager.addChild(card);
				card.simpleOpen();
				belowUserInfo.pushNewUnLeaveCard(card);
			}
			
			belowUserInfo.playingPlayerArray = new Array();
			belowUserInfo.playingPlayerArray.push(belowUserInfo);
			belowUserInfo.playingPlayerArray.push(rightUserInfo);
			belowUserInfo.playingPlayerArray.push(leftUserInfo);
			belowUserInfo.userName = "aaa";
			isPlaying = true;
			//cardManager.sendCard(belowUserInfo, rightUserInfo, 17, 2);
			//var tempArray:Array = belowUserInfo.checkSendCard(belowUserInfo.unLeaveCards);
			
			/*var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				moneyEffectPosition = PlayerInfo(playingPlayerArray[i]).localToGlobal(PlayerInfo(playingPlayerArray[i]).moneyEffectPosition);
				resultEffectPosition = PlayerInfo(playingPlayerArray[i]).localToGlobal(PlayerInfo(playingPlayerArray[i]).resultEffectPosition);
				effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, 100, 10000);
				effectLayer.addEffect(EffectLayer.NO_DECK_EFFECT, resultEffectPosition, 100);
			}*/
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
			
			if (timerToAutoStart)
			{
				timerToAutoStart.removeEventListener(TimerEvent.TIMER, onTimerToAutoStart);
				timerToAutoStart.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
				timerToAutoStart.stop();
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
						PlayerInfoPhom(allPlayerArray[i]).addChatSentence(mainData.publicChatData.chatContent);
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
			content["aboveUserInfoPosition"].visible = false;
			content["cardManagerPosition"].visible = false;
			content["readyButtonPosition"].visible = false;
			content["chatBoxPosition"].visible = false;
			content["leaveCardPoint"].visible = false;
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
				case PlayingScreenAction.HAVE_USER_DISCARD: // có người đánh bài, trong đó tính cả mình
					listenHaveUserDiscard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.GET_CARD_SUCCESS: // bốc bài thành công
					listenGetCardSuccess(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_GET_CARD: // có user bốc bài
					listenHaveUserGetCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_STEAL_CARD: // có user ăn bài
					listenHaveUserStealCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_DOWN_CARD: // có user hạ bài
					listenHaveUserDownCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_DOWN_CARD_FINISH: // có user hạ bài xong
					listenHaveUserDownCardFinish(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_SEND_CARD_FINISH: // có user gửi bài xong
					listenHaveUserSendCardFinish(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.GAME_OVER: // ván kết thúc
					listenGameOver(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_SEND_CARD: // ván kết thúc
					listenHaveUserSendCard(e.data[ModelField.DATA]);
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
				case Command.UPDATE_POT: // update tiền trong gà
					listenUpdatePot(e.data[ModelField.DATA]);
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
					if (tempNumber > 3)
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
						if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoPhom(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
							for (j = 0; j < playingPlayerArray.length; j++)
							{
								// Kiểm tra xem thằng vừa out có phải thằng đang có turn và đứng trước mình không
								if (allPlayerArray[i] == playingPlayerArray[j] && PlayerInfoPhom(playingPlayerArray[j]).userName == nextTurn)
								{
									var myIndex:int;
									if (j != playingPlayerArray.length - 1)
										myIndex = j + 1;
									else
										myIndex = 0;
									if (playingPlayerArray[myIndex] == belowUserInfo && belowUserInfo.isPlaying)
									{
										belowUserInfo.cardOfPreviousPlayer = null;
										belowUserInfo.setMyTurn(PlayerInfoPhom.GET_CARD);
									}
									else if (PlayerInfoPhom(playingPlayerArray[myIndex]).isPlaying)
									{
										PlayerInfoPhom(playingPlayerArray[myIndex]).countTime(mainData.init.playTime.playCardTimePhom);
									}
								}
								// Nếu mình đang có turn mà thằng trc mình thoát thì đề phòng trường hợp mình đang có thể ăn đc con bài thằng kia vừa đánh
								if (nextTurn == belowUserInfo.userName && PlayerInfoPhom(allPlayerArray[i]).isPlaying) 
									belowUserInfo.stealCardButton.enable = false;
							}
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
						if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoPhom(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
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
					waitToPlay.visible = false;
					waitToStart.visible = false;
					waitToReady.visible = true;
					belowUserInfo.isReadyPlay = false;
					hideReadyButton();
				}
				if (belowUserInfo.isRoomMaster)
				{
					for (i = 0; i < allPlayerArray.length; i++) 
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay)
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
			roomBet.text = PlayingLogic.format(data[DataField.ROOM_BET], 1);
			roomBet.selectable = ruleDescription.selectable = false;
			roomBet.mouseEnabled = ruleDescription.mouseEnabled = false;
			
			mainData.playingData.gameRoomData.roomBet = data[DataField.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataField.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataField.IS_SEND_CARD];
			
			if (data[DataField.IS_SEND_CARD])
				var sendCardRule:String = mainData.init.gameDescription.playingScreen.sendCardRule;
			else
				sendCardRule = mainData.init.gameDescription.playingScreen.notSendCardRule;
				
			if (data[DataField.IS_GA])
				var gaRule:String = mainData.init.gameDescription.playingScreen.gaRule;
			else
				gaRule = mainData.init.gameDescription.playingScreen.notGaRule;
				
			gaIcon.visible = data[DataField.IS_GA];
			mainData.isPhomGa = data[DataField.IS_GA];
				
			ruleDescription.text = sendCardRule + " - " + gaRule;
				
			if (data[DataField.IS_GA])
			{
				potMoneyTxt.text = PlayingLogic.format(data[DataField.POT], 1) + " - " + data[DataField.POT_LEVEL];
				mainData.gaData = data;
			}
			
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
			
			belowUserInfo.setMyTurn(PlayerInfoPhom.DO_NOTHING);
			belowUserInfo.arrangeCardButton.enable = false;
			
			if (data[DataField.GAME_STATE] == DataField.WAITING) // Nếu phòng chơi chưa bắt đầu
			{
				if (allPlayerArray.length > 1)
					showReadyButton();
				else
					waitToReady.visible = true;
					//belowUserInfo.showTooltip(mainData.init.gameDescription.playingScreen.waitOtherPlayer);
			}
			else // Nếu phòng chơi đang chơi
			{
				addCardManager();
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
						if (PlayerInfoPhom(allPlayerArray[i]).isPlaying)
						{
							playingPlayerArray.push(allPlayerArray[i]);
						}
					}
				}
				isPlaying = true;
				cardManager.playerArray = playingPlayerArray;
			}
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
					{
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = true;
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
					if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay)
						playingPlayerArray.push(allPlayerArray[i]);
				}
			}
			
			// tính index của người thắng
			var winnerIndex:int = data[DataField.WINNER_INDEX];
			winnerIndex -= jumpIndex;
			if (winnerIndex < 0)
				winnerIndex += mainData.maxPlayer;
				
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoPhom(playingPlayerArray[i]).isPlaying = true;
				PlayerInfoPhom(playingPlayerArray[i]).isReadyPlay = false;
				PlayerInfoPhom(playingPlayerArray[i]).playingPlayerArray = playingPlayerArray;
					
				if (playingPlayerArray[i] == belowUserInfo) // Gán cho mình dữ liệu các lá bài của server gửi về
				{							
					PlayerInfoPhom(playingPlayerArray[i]).cardInfoArray = data[DataField.PLAYER_CARDS] as Array;
				}
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).position == winnerIndex)
					{
						nextTurn = PlayerInfoPhom(playingPlayerArray[i]).userName;
						PlayerInfoPhom(playingPlayerArray[i]).isCurrentWinner = true;
						PlayerInfoPhom(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.playCardTimePhom) + 3);
						PlayerInfoPhom(playingPlayerArray[i]).cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
					}
					else
					{
						PlayerInfoPhom(playingPlayerArray[i]).isCurrentWinner = false;
						PlayerInfoPhom(playingPlayerArray[i]).cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0];
					}
				}
			}
			addCardManager();
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
			if (data[DataField.IS_CURRENT_WINNER])
			{
				nextTurn = belowUserInfo.userName;
				belowUserInfo.setMyTurn(PlayerInfoPhom.PLAY_CARD);
				belowUserInfo.isCurrentWinner = true;
				belowUserInfo.countTime(Number(mainData.init.playTime.playCardTimePhom) + 3);
			}
			else
			{
				belowUserInfo.isCurrentWinner = false;
			}
		}
		
		private function listenHaveUserDiscard(data:Object):void 
		{
			var i:int;
			nextTurn = data[DataField.NEXT_TURN];
			// Nếu người đánh bài không phải là mình thì xử lý đánh bài
			if (data[DataField.USER_NAME] != belowUserInfo.userName)
			{
				for (i = 0; i < playingPlayerArray.length; i++) // Tìm user server vừa gửi về để gọi lệnh đánh bài của user đó
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataField.USER_NAME])
					{
						PlayerInfoPhom(playingPlayerArray[i]).addValueForOneUnleavedCard(data[DataField.CARD]);
						PlayerInfoPhom(playingPlayerArray[i]).playOneCard(data[DataField.CARD]);
						var tempCard:CardPhom = PlayerInfoPhom(playingPlayerArray[i]).leavedCards[PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length - 1];
						if (playingPlayerArray[i] != belowUserInfo)
							PlayerInfoPhom(playingPlayerArray[i]).stopCountTime();
						i = playingPlayerArray.length;
					}
				}
			}
			
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataField.NEXT_TURN] == PlayerInfoPhom(playingPlayerArray[i]).userName) 
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).isPlaying && PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length < 4) // Nếu đang chơi
					{
						if (playingPlayerArray[i] == belowUserInfo)// Nếu người chơi của mình là người đánh tiếp theo
						{
							belowUserInfo.cardOfPreviousPlayer = tempCard;
							belowUserInfo.setMyTurn(PlayerInfoPhom.GET_CARD);
						}
						else
						{
							PlayerInfoPhom(playingPlayerArray[i]).countTime(mainData.init.playTime.playCardTimePhom);
						}
					}
					else // Nếu không thì đây là lần đánh cuối cùng của người hạ cuối, và ván chơi đã kết thúc
					{
						belowUserInfo.setMyTurn(PlayerInfoPhom.DO_NOTHING);
						belowUserInfo.arrangeCardButton.enable = false;
					}
				}
			}
		}
		
		private function listenGetCardSuccess(data:Object):void 
		{
			cardManager.divideOneCard(belowUserInfo, data[DataField.CARD], CardManagerPhom.cardToDesTime / 2);
			belowUserInfo.checkAutoPlayCard();
			belowUserInfo.getCardSuccess();
		}
		
		private function listenHaveUserGetCard(data:Object):void // Có người bốc bài
		{
			if (data[DataField.USER_NAME] == belowUserInfo.userName)
				return;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataField.USER_NAME])
				{
					cardManager.divideOneCard(PlayerInfoPhom(playingPlayerArray[i]), CardManagerPhom.cardToDesTime / 2);
					
					// Nếu user đó đến lượt hạ thì đếm thời gian hạ
					if(PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length == mainData.cardNumberToDown)
						PlayerInfoPhom(playingPlayerArray[i]).countTime(mainData.init.playTime.downCardTime);
						
					i = playingPlayerArray.length;
				}
			}
		}
		
		private function listenHaveUserDownCard(data:Object):void // Có người hạ bài
		{
			var i:int;
			var downCardArray:Array = data[DataField.CARDS] as Array;
			if (data[DataField.USER_NAME] == belowUserInfo.userName) // Nếu người hạ bài là mình
			{
				belowUserInfo.downOneDeck(downCardArray);
				return;
			}
			belowUserInfo.isHaveUserDownCard = true;
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataField.USER_NAME])
				{
					for (var j:int = 0; j < downCardArray.length; j++) 
					{
						PlayerInfoPhom(playingPlayerArray[i]).addValueForOneUnleavedCard(downCardArray[j]);
					}
					PlayerInfoPhom(playingPlayerArray[i]).downOneDeck(downCardArray);
					i = playingPlayerArray.length;
				}
			}
		}
		
		private function listenHaveUserDownCardFinish(data:Object):void // có user hạ bài xong
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
				{
					PlayerInfoPhom(playingPlayerArray[i]).downCardFinish();
					return;
				}
			}
		}
		
		private function listenHaveUserSendCardFinish(data:Object):void // có user gửi bài xong
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
				{
					PlayerInfoPhom(playingPlayerArray[i]).countTime(mainData.init.playTime.playCardTimePhom);
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
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = true;
					else
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = false;
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
							if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay && allPlayerArray[i] != belowUserInfo)
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
							if (PlayerInfoPhom(allPlayerArray[i]).isRoomMaster)
							{
								PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = false;
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
				
				dispatchEvent(new Event(PlayerInfoPhom.EXIT));
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
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataField.USER_NAME])
					{
						PlayerInfoPhom(allPlayerArray[i]).updateMoney(data[DataField.MONEY]);
						
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
								
								dispatchEvent(new Event(PlayerInfoPhom.EXIT));
								windowLayer.isNoCloseAll = true;
								electroServerCommand.joinLobbyRoom();
								
								EffectLayer.getInstance().removeAllEffect();
							}
						}
					}
				}
			}
		}
		
		private function listenUpdatePot(data:Object):void // update tiền trong gà
		{
			potMoneyTxt.text = PlayingLogic.format(data[DataField.POT], 1) + " - " + data[DataField.POT_LEVEL];
			mainData.gaData = data;
		}
		
		private function listenHaveUserSendCard(data:Object):void // có user hạ bài xong
		{
			var fromPlayer:PlayerInfoPhom;
			var toPlayer:PlayerInfoPhom;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataField.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
					fromPlayer = playingPlayerArray[i];
				if (data[DataField.PLAYER_DESTINATION] == PlayerInfoPhom(playingPlayerArray[i]).userName)
					toPlayer = playingPlayerArray[i];
			}
			if (fromPlayer != belowUserInfo)
			{
				fromPlayer.addValueForOneUnleavedCard(data[DataField.CARD]);
			}
			cardManager.sendCard(fromPlayer, toPlayer, data[DataField.CARD], data[DataField.INDEX] + 1);
		}
		
		private function listenGameOver(data:Object):void // ván bài kết thúc
		{
			var playerList:Array = data[DataField.PLAYER_LIST] as Array;
			var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			var time:Number;
			var playerFullDeck:PlayerInfoPhom;
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (playerList[i][DataField.USER_NAME] == PlayerInfoPhom(playingPlayerArray[j]).userName)
					{
						PlayerInfoPhom(playingPlayerArray[j]).isPlaying = false;
						PlayerInfoPhom(playingPlayerArray[j]).stopCountTime();
						
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfoPhom(playingPlayerArray[j]).localToGlobal(PlayerInfoPhom(playingPlayerArray[j]).moneyEffectPosition);
						if (playerList[i][DataField.RESULT_POSITION] != 0)
						{
							//PlayerInfoPhom(playingPlayerArray[j]).updateMoney(playerList[i][DataField.MONEY] * -1);
							effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataField.MONEY] * -1);
						}
						else
						{
							//PlayerInfoPhom(playingPlayerArray[j]).updateMoney(playerList[i][DataField.MONEY]);
							effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataField.MONEY]);
						}
							
						// add effect kết quả - móm, ù, thắng
						time = mainData.init.effect.time.resultEffect;
						resultEffectPosition = PlayerInfoPhom(playingPlayerArray[j]).localToGlobal(PlayerInfoPhom(playingPlayerArray[j]).resultEffectPosition);
						
						if (playerList[i][DataField.RESULT_POSITION] == 0) // Về nhất
						{
							if (playerList[i][DataField.POINT] == 0) // Ù
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j])
								effectLayer.addEffect(EffectLayer.FULL_DECK_EFFECT, resultEffectPosition, time);
							}
							else if (playerList[i][DataField.POINT] == -5) // Ù khan
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j])
								effectLayer.addEffect(EffectLayer.NO_RELATIONSHIP_EFFECT, resultEffectPosition, time);
							}
							else
							{
								effectLayer.addEffect(EffectLayer.WIN_EFFECT, resultEffectPosition, time); // Thắng
							}
						}
						else // Không về nhất
						{
							if(playerList[i][DataField.POINT] == -1) // Móm
								effectLayer.addEffect(EffectLayer.NO_DECK_EFFECT, resultEffectPosition, time);
							else if(playerList[i][DataField.POINT] == -2) // Đền
								effectLayer.addEffect(EffectLayer.COMPENSATE_ALL_EFFECT, resultEffectPosition, time);
						}
					}
					
					if (PlayerInfoPhom(playingPlayerArray[j]).userName == playerList[i][DataField.USER_NAME] && playingPlayerArray[j] != belowUserInfo)
					{
						var cardArray:Array = playerList[i][DataField.PLAYER_CARDS] as Array;
						for (var k:int = 0; k < cardArray.length; k++) 
						{
							PlayerInfoPhom(playingPlayerArray[j]).addValueForOneUnleavedCard(cardArray[k]);
						}
						PlayerInfoPhom(playingPlayerArray[j]).openAllCard();
					}
				}
			}
			
			if (playerFullDeck) // nếu có người ù giữa ván thì hạ tất cả các phỏm của người đó xuống
			{
				if (playerFullDeck == belowUserInfo)
					windowLayer.closeAllWindow();
				playerFullDeck.downAllCardWhenFullDeck();
			}
				
			belowUserInfo.setMyTurn(PlayerInfoPhom.DO_NOTHING);
			belowUserInfo.arrangeCardButton.enable = false;
			
			resultWindow = new ResultWindowPhom();
			resultWindow.setInfo(playerList);
			
			timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
			
			if (cardManager)
			{
				cardManager.hideTwinkle();
			}
		}
		
		private function onResetMatch(e:TimerEvent):void 
		{
			if (!stage || !resultWindow)
				return;
			
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet))
			{
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					var kickOutWindow:AlertWindow = new AlertWindow();
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				
				dispatchEvent(new Event(PlayerInfoPhom.EXIT));
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom();
				
				EffectLayer.getInstance().removeAllEffect();
				return;
			}
			
			windowLayer.openWindow(resultWindow);
			resetMatch();
			isPlaying = false;
			
			if (belowUserInfo.isReadyPlay && !belowUserInfo.isRoomMaster)
				waitToStart.visible = true;
				
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay)
						PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
				}
			}
		}
		
		private function resetMatch():void // reset ván bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				PlayerInfoPhom(playingPlayerArray[i]).removeAllCards();
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
					if (!belowUserInfo.isReadyPlay)
						showReadyButton();
				}
				else
				{
					waitToPlay.visible = true;
					for (j = 0; j < allPlayerArray.length; j++) 
					{
						if (allPlayerArray[j])
						{
							if (PlayerInfoPhom(allPlayerArray[j]).isReadyPlay)
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
				waitToPlay.visible = false;
				waitToStart.visible = false;
				waitToReady.visible = true;
			}
			removeCardManager();
		}
		
		private function listenHaveUserStealCard(data:Object):void // có user ăn bài
		{
			var stealedPlayer:PlayerInfoPhom; // Người bị ăn bài
			var stealPlayer:PlayerInfoPhom; // Người ăn bài
			var i:int;
			var effectPosition:Point;
			var time:Number = mainData.init.effect.time.moneyEffect;
			var addMoney:Number = data[DataField.MONEY_AFTER_REBET];
			var lessMoney:Number = data[DataField.MONEY_BEFORE_REBET];
				
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataField.USER_NAME])
				{
					stealPlayer = playingPlayerArray[i];
					if (i == 0)
						stealedPlayer = playingPlayerArray[playingPlayerArray.length - 1];
					else
						stealedPlayer = playingPlayerArray[i - 1];
					cardManager.stealCard(stealPlayer, stealedPlayer, data[DataField.CARD]);
					i = playingPlayerArray.length;
					
					// add effect tiền
					effectPosition = stealPlayer.localToGlobal(stealPlayer.moneyEffectPosition);
					//stealPlayer.updateMoney(addMoney);
					effectLayer.addEffect(EffectLayer.MONEY_EFFECT, effectPosition, time, addMoney);
					effectPosition = stealedPlayer.localToGlobal(stealedPlayer.moneyEffectPosition);
					//stealedPlayer.updateMoney(lessMoney * -1);
					effectLayer.addEffect(EffectLayer.MONEY_EFFECT, effectPosition, time, lessMoney * -1);
				}
			}
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
				{
					//belowUserInfo.stopCountTime();
					playingLayer.removeChild(readyButton);	
				}
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
			
			if (mainData.isPhomGa)
			{
				autoStartTimeTxt.visible = true;
				autoStartTimeTxt.text = '10';
				if (timerToAutoStart)
				{
					timerToAutoStart.removeEventListener(TimerEvent.TIMER, onTimerToAutoStart);
					timerToAutoStart.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
					timerToAutoStart.stop();
				}
				timerToAutoStart = new Timer(1000, 10);
				timerToAutoStart.addEventListener(TimerEvent.TIMER, onTimerToAutoStart);
				timerToAutoStart.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
				timerToAutoStart.start();
			}
		}
		
		private function onTimerCompleteToAutoStart(e:TimerEvent):void 
		{
			electroServerCommand.startGame();
			startButton.content["child"].removeEventListener(MouseEvent.CLICK, onButtonClick);
			autoStartTimeTxt.visible = false;
		}
		
		private function onTimerToAutoStart(e:TimerEvent):void 
		{
			var num:int = int(autoStartTimeTxt.text);
			num--;
			autoStartTimeTxt.text = String(num);
		}
		
		private function hideStartButton():void
		{
			if (startButton)
			{
				if (this.contains(startButton))
					playingLayer.removeChild(startButton);	
			}
			
			autoStartTimeTxt.visible = false;
			if (timerToAutoStart)
			{
				timerToAutoStart.removeEventListener(TimerEvent.TIMER, onTimerToAutoStart);
				timerToAutoStart.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
				timerToAutoStart.stop();
			}
		}
		
		// add một người chơi, đầu vào là vị trí tương ứng từ 1-4
		public function addOnePlayer(position:int):void 
		{
			switch (position) 
			{
				case 0:
					addPlayerByType(PlayerInfoPhom.BELOW_USER, position, true);
					// Lắng nghe đến lượt mình bốc bài thì thông báo cho cardManager
					belowUserInfo.addEventListener(PlayerInfoPhom.GET_CARD_TURN, onGetCardTurn);
					// Lắng nghe nếu mình ăn bài thì thông báo để cardManager không nhấp nháy nữa
					belowUserInfo.addEventListener(PlayerInfoPhom.STEAL_CARD, onStealCard); 
					// Lắng nghe nếu mình bốc bài thì thông báo để cardManager không nhấp nháy nữa
					belowUserInfo.addEventListener(PlayerInfoPhom.GET_CARD, onGetCard); 
				break;
				case 1:
					addPlayerByType(PlayerInfoPhom.RIGHT_USER, position, false);
				break;
				case 2:
					addPlayerByType(PlayerInfoPhom.ABOVE_USER, position, false);
				break;
				case 3:
					addPlayerByType(PlayerInfoPhom.LEFT_USER, position, false);
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
					if (PlayerInfoPhom(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						PlayerInfoPhom(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataField.READY])
						{
							//isHaveUserReady = true;
							PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
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
					if (PlayerInfoPhom(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfoPhom(allPlayerArray[i]).isPlaying = true;
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
					if (PlayerInfoPhom(allPlayerArray[i]).position == position)
					{
						if (isPlaying)
						{
							for (var j:int = 0; j < playingPlayerArray.length; j++) 
							{
								if (PlayerInfoPhom(allPlayerArray[i]) == PlayerInfoPhom(playingPlayerArray[j]))
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
					PlayerInfoPhom(this[PlayerInfoPhom.BELOW_USER]).destroy();
				break;
				case 1:
					PlayerInfoPhom(this[PlayerInfoPhom.RIGHT_USER]).destroy();
				break;
				case 2:
					PlayerInfoPhom(this[PlayerInfoPhom.ABOVE_USER]).destroy();
				break;
				case 3:
					PlayerInfoPhom(this[PlayerInfoPhom.LEFT_USER]).destroy();
				break;
			}
		}
		
		private function addPlayerByType(playerType:String, position:int, isCardInteractive:Boolean = false):void
		{
			this[playerType] = new PlayerInfoPhom();
			this[playerType].addEventListener(PlayerInfoPhom.AVATAR_CLICK, onShowContextMenu);
			PlayerInfoPhom(this[playerType]).position = position;
				
			// Có cho phép tương tác vào quân bài của người chơi này không
			PlayerInfoPhom(this[playerType]).isCardInteractive = isCardInteractive;
			
			PlayerInfoPhom(this[playerType]).setForm(playerType);
				
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
			contextMenuData[DataField.DISPLAY_NAME] = PlayerInfoPhom(e.currentTarget).displayName;
			contextMenuData[DataField.USER_NAME] = PlayerInfoPhom(e.currentTarget).userName;
			contextMenuData[DataField.AVATAR] = PlayerInfoPhom(e.currentTarget).avatarString;
			contextMenuData[DataField.LOGO] = PlayerInfoPhom(e.currentTarget).logoString;
			myContextMenu.data = contextMenuData;
			
			if (!isPlaying && belowUserInfo.isRoomMaster)
				myContextMenu.enableKickOut = true;
			else
				myContextMenu.enableKickOut = false;
				
			var tempPoint:Point = PlayerInfoPhom(e.currentTarget).contextMenuPosition;
			tempPoint = PlayerInfoPhom(e.currentTarget).localToGlobal(tempPoint);
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
						var tempPlayer:PlayerInfoPhom = playingPlayerArray[i];
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
				cardManager = new CardManagerPhom();
			cardManager.addEventListener(CardManagerPhom.GET_CARD, onClickCardManagerToGetCard);
			cardManager.x = content["cardManagerPosition"].x;
			cardManager.y = content["cardManagerPosition"].y;
			playingLayer.addChild(cardManager);
		}
		
		private function onClickCardManagerToGetCard(e:Event):void 
		{
			belowUserInfo.getCard();
		}
		
		private function removeCardManager():void
		{
			if (cardManager)
			{
				if (contains(cardManager))
				{
					cardManager.removeEventListener(CardManagerPhom.GET_CARD, onClickCardManagerToGetCard);
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
					if (mainData.isPhomGa && isFirstJoin && mainData.gaData[DataField.POT_LEVEL] > 0)
					{
						isFirstJoin = false;
						var confirmPlayWindow:ConfirmWindow = new ConfirmWindow();
						confirmPlayWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmPlay);
						var st1:String = mainData.init.gameDescription.playingScreen.confirmPlayGa1;
						var st2:String = mainData.init.gameDescription.playingScreen.confirmPlayGa2;
						var st3:String = mainData.init.gameDescription.playingScreen.confirmPlayGa3;
						var st4:String = mainData.init.gameDescription.playingScreen.confirmPlayGa4;
						var potLevel:int = mainData.gaData[DataField.POT_LEVEL] + 1;
						var conditionMoney:int = int(mainData.playingData.gameRoomData.roomBet) * potLevel
						confirmPlayWindow.setNotice(st1 + " " + String(potLevel) + " " + st2 + " " + String(potLevel) + " " + st3 + " " + String(conditionMoney) + " " + st4);
						windowLayer.openWindow(confirmPlayWindow);
					}
					else
					{
						electroServerCommand.readyPlay();
						readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
					}
				break;
				case startButton.content["child"]:
					if (timerToAutoStart)
					{
						timerToAutoStart.removeEventListener(TimerEvent.TIMER, onTimerToAutoStart);
						timerToAutoStart.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
						timerToAutoStart.stop();
					}
					autoStartTimeTxt.visible = false;
					electroServerCommand.startGame();
					startButton.content["child"].removeEventListener(MouseEvent.CLICK, onButtonClick);
				break;
			}
		}
		
		private function onConfirmPlay(e:Event):void 
		{
			electroServerCommand.readyPlay();
			readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
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
						if (data[DataField.USER_NAME] == PlayerInfoPhom(allPlayerArray[i]).userName)
							PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
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
					if (data[DataField.USER_NAME] == PlayerInfoPhom(allPlayerArray[i]).userName)
					{
						/*if (!isHaveUserReady)
						{
							for (var j:int = 0; j < allPlayerArray.length; j++) 
							{
								if (allPlayerArray[j])
								{
									if (allPlayerArray[j] != allPlayerArray[i] && !PlayerInfoPhom(allPlayerArray[j]).isReadyPlay)
									{
										PlayerInfoPhom(allPlayerArray[j]).showTooltip(mainData.init.gameDescription.playingScreen.readyAlert)
										PlayerInfoPhom(allPlayerArray[j]).countTime(Number(mainData.init.playTime.readyTime));
										PlayerInfoPhom(allPlayerArray[j]).isWaitingToReady = true;
									}
								}
							}
						}*/
						
						PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
						//isHaveUserReady = true;
						if (allPlayerArray[i] == belowUserInfo)
						{
							//belowUserInfo.isWaitingToReady = false;
							hideReadyButton();
							if (!isPlaying)
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
			channelNameAndRoomId.selectable = false;
			channelNameAndRoomId.text = "Kênh " + mainData.playingData.gameRoomData.channelName + " - Phòng " + mainData.playingData.gameRoomData.roomId;
			
			potMoneyTxt = content["potMoneyTxt"];
			
			potMoneyTxt.text = '';
			
			potMoneyTxt.mouseEnabled = false;
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
						PlayerInfoPhom(allPlayerArray[i]).removeEventListener(PlayerInfoPhom.AVATAR_CLICK, onShowContextMenu);
						PlayerInfoPhom(allPlayerArray[i]).destroy();
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
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void 
		{
			_isPlaying = value;
		}
	}

}