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
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import view.button.MyButton;
	import view.card.Card;
	import view.card.CardManager;
	import view.card.CardManagerTLMN;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfo;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.ResultWindow;
	import view.window.WhiteWinWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreen extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		
		private var belowUserInfo:PlayerInfo;
		private var rightUserInfo:PlayerInfo;
		private var leftUserInfo:PlayerInfo;
		private var aboveUserInfo:PlayerInfo;
		
		private var chatBox:ChatBox;
		
		private var cardManager:CardManagerTLMN;
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
		private var resultWindow:ResultWindow;
		private var isPlaying:Boolean;
		//private var isHaveUserReady:Boolean;
		private var timerToPing:Timer;
		private var pingTime:int = 55;
		private var myContextMenu:MyContextMenu;
		private var whiteWinWindow:WhiteWinWindow;
		
		public function PlayingScreen() 
		{
			super();
			addContent("zPlayingScreen");
			setupTextField();
			hidePosition();
			createVariable();
			mainData.playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			chatBox = new ChatBox();
			chatBox.x = content["chatBoxPosition"].x;
			chatBox.y = content["chatBoxPosition"].y;
			waitToPlay = content["waitToPlay"];
			waitToReady = content["waitToReady"];
			waitToStart = content["waitToStart"];
			waitToPlay.selectable = waitToReady.selectable = waitToStart.selectable = false;
			waitToReady.visible = waitToPlay.visible = waitToStart.visible = false;
			//addChild(chatBox);
			
			timerToPing = new Timer(pingTime * 1000);
			timerToPing.addEventListener(TimerEvent.TIMER, onPingToServer);
			timerToPing.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//cacheAsBitmap = true;
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
			//alpha = 0;
			//var tempTween1:GTween = new GTween(this, effectTime, { alpha:1 } );
		}
		
		public function effectClose():void
		{
			mainData.removeEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.removeEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.removeEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			//var tempTween1:GTween = new GTween(this, effectTime, { alpha:0 } );
			//tempTween1.addEventListener(Event.COMPLETE, closeComplete);
			dispatchEvent(new Event(CLOSE_COMPLETE));
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
				case PlayingScreenAction.HAVE_USER_NEXT_TURN: // có người bỏ qua, trong đó tính cả mình
					listenHaveUserNextTurn(e.data[ModelField.DATA]);
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
				case PlayingScreenAction.UPDATE_CURRENT_TURN: 
					listenUpdateCurrentTurn(e.data[ModelField.DATA]);
				break;
			}
		}
		
		private function listenUpdateCurrentTurn(data:Object):void // cập nhật turn hiện tại
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataField.CURRENT_TURN] == PlayerInfo(playingPlayerArray[i]).userName)
				{
					PlayerInfo(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.playCardTime));
					if (playingPlayerArray[i] == belowUserInfo)
						belowUserInfo.setMyTurn(PlayerInfo.PLAY_CARD);
					return;
				}
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
				//showReadyButton();
				waitToPlay.visible = true;
				waitToReady.visible = false;
			}
			/*else if (!isPlaying && countPlayer > 3)
			{
				if (isHaveUserReady)
				{
					switch (indexEmpty) 
					{
						case 1:
							if (!rightUserInfo.isReadyPlay)
								rightUserInfo.countTime(Number(mainData.init.playTime.readyTime));
						break;
						case 2:
							if (!aboveUserInfo.isReadyPlay)
								aboveUserInfo.countTime(Number(mainData.init.playTime.readyTime));
						break;
						case 3:
							if (!leftUserInfo.isReadyPlay)
								leftUserInfo.countTime(Number(mainData.init.playTime.readyTime));
						break;
					}
				}
			}*/
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
						if (PlayerInfo(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfo(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
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
						if (PlayerInfo(allPlayerArray[i]).userName == data[DataField.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfo(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo");
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
							if (PlayerInfo(allPlayerArray[i]).isReadyPlay)
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
			
			mainData.playingData.gameRoomData.roomBet = data[DataField.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataField.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataField.IS_SEND_CARD];
			
			if (data[DataField.IS_SEND_CARD])
				ruleDescription.text = "Gửi bài";
			else
				ruleDescription.text = "Không gửi bài";
			ruleDescription.text = ""
			
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
			
			belowUserInfo.setMyTurn(PlayerInfo.DO_NOTHING);
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
						if (PlayerInfo(allPlayerArray[i]).isPlaying)
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
					if (PlayerInfo(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
					{
						PlayerInfo(allPlayerArray[i]).isRoomMaster = true;
						i = allPlayerArray.length + 1;
					}
				}
			}
		}
		
		private function listenDealCard(data:Object):void 
		{
			mainData.lastCardValues = new Array();
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
					if (PlayerInfo(allPlayerArray[i]).isReadyPlay || PlayerInfo(allPlayerArray[i]).isRoomMaster)
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
				PlayerInfo(playingPlayerArray[i]).isPlaying = true;
				PlayerInfo(playingPlayerArray[i]).isReadyPlay = false;
				PlayerInfo(playingPlayerArray[i]).playingPlayerArray = playingPlayerArray;
				
				if (playingPlayerArray[i] == belowUserInfo) // Gán cho mình dữ liệu các lá bài của server gửi về
					PlayerInfo(playingPlayerArray[i]).cardInfoArray = data[DataField.PLAYER_CARDS] as Array;
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
					PlayerInfo(playingPlayerArray[i]).cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
				if (data[DataField.CURRENT_TURN] == playingPlayerArray[i].userName)
				{
					PlayerInfo(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.playCardTime));
					if (playingPlayerArray[i] == belowUserInfo)
						belowUserInfo.setMyTurn(PlayerInfo.PLAY_CARD);
				}
			}
			addCardManager();
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
		}
		
		private function listenHaveUserDiscard(data:Object):void 
		{
			var i:int;
			// Nếu người đánh bài không phải là mình thì xử lý đánh bài
			if (data[DataField.USER_NAME] != belowUserInfo.userName)
			{
				for (i = 0; i < playingPlayerArray.length; i++) // Tìm user server vừa gửi về để gọi lệnh đánh bài của user đó
				{
					PlayerInfo(playingPlayerArray[i]).removeCardsArray(PlayerInfo(playingPlayerArray[i]).leavedCards);
					if (PlayerInfo(playingPlayerArray[i]).userName == data[DataField.USER_NAME])
					{
						var cardValues:Array = data[DataField.CARD_VALUES];
						for (var j:int = 0; j < cardValues.length; j++) 
						{
							PlayerInfo(playingPlayerArray[i]).addValueForOneUnleavedCard(cardValues[j]);
						}
						
						PlayerInfo(playingPlayerArray[i]).playCard(data[DataField.CARD_VALUES]);
						mainData.lastCardValues = data[DataField.CARD_VALUES];
						if (playingPlayerArray[i] != belowUserInfo)
							PlayerInfo(playingPlayerArray[i]).stopCountTime();
						i = playingPlayerArray.length;
					}
				}
			}
			else
			{
				mainData.lastCardValues = new Array();
			}
		}
		
		private function listenHaveUserNextTurn(data:Object):void 
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataField.USER_NAME] == PlayerInfo(playingPlayerArray[i]).userName) 
				{
					PlayerInfo(playingPlayerArray[i]).stopCountTime();
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
					if (PlayerInfo(allPlayerArray[i]).userName == data[DataField.ROOM_MASTER])
						PlayerInfo(allPlayerArray[i]).isRoomMaster = true;
					else
						PlayerInfo(allPlayerArray[i]).isRoomMaster = false;
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
							if (PlayerInfo(allPlayerArray[i]).isReadyPlay && allPlayerArray[i] != belowUserInfo)
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
							if (PlayerInfo(allPlayerArray[i]).isRoomMaster)
							{
								PlayerInfo(allPlayerArray[i]).isReadyPlay = false;
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
				
				dispatchEvent(new Event(PlayerInfo.EXIT));
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
					if (PlayerInfo(allPlayerArray[i]).userName == data[DataField.USER_NAME])
					{
						PlayerInfo(allPlayerArray[i]).updateMoney(data[DataField.MONEY]);
						
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
								
								dispatchEvent(new Event(PlayerInfo.EXIT));
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
			var playerFullDeck:PlayerInfo;
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (playerList[i][DataField.USER_NAME] == PlayerInfo(playingPlayerArray[j]).userName)
					{
						PlayerInfo(playingPlayerArray[j]).isPlaying = false;
						PlayerInfo(playingPlayerArray[j]).stopCountTime();
						
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfo(playingPlayerArray[j]).localToGlobal(PlayerInfo(playingPlayerArray[j]).moneyEffectPosition);
						effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataField.MONEY]);
					}
					
					if (PlayerInfo(playingPlayerArray[j]).userName == playerList[i][DataField.USER_NAME] && playingPlayerArray[j] != belowUserInfo)
					{
						var cardArray:Array = playerList[i][DataField.PLAYER_CARDS] as Array;
						for (var k:int = 0; k < cardArray.length; k++) 
						{
							PlayerInfo(playingPlayerArray[j]).addValueForOneUnleavedCard(cardArray[k]);
						}
						PlayerInfo(playingPlayerArray[j]).openAllCard();
					}
				}
			}
				
			belowUserInfo.setMyTurn(PlayerInfo.DO_NOTHING);
			belowUserInfo.arrangeCardButton.enable = false;
			
			resultWindow = new ResultWindow();
			resultWindow.setInfo(playerList);
			
			if (data[DataField.IS_WHITE_WIN])
				timerToResetMatch = new Timer((mainData.resetMatchTime + 1) * 1000, 1);
			else
				timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
			
			if (cardManager)
			{
				cardManager.hideTwinkle();
			}
			
			if (data[DataField.IS_WHITE_WIN])
			{
				whiteWinWindow = new WhiteWinWindow();
				whiteWinWindow.setCardsValue(data[DataField.CARDS], data[DataField.WHITE_WIN_TYPE]);
				
				var timerToCloseWhiteWinWindow:Timer = new Timer(4000, 1);
				timerToCloseWhiteWinWindow.addEventListener(TimerEvent.TIMER_COMPLETE, onCloseWhiteWinWindow);
				timerToCloseWhiteWinWindow.start();
				
				var timerToOpenWhiteWinWindow:Timer = new Timer(2000, 1);
				timerToOpenWhiteWinWindow.addEventListener(TimerEvent.TIMER_COMPLETE, onOpenWhiteWinWindow);
				timerToOpenWhiteWinWindow.start();
			}
		}
		
		private function onOpenWhiteWinWindow(e:TimerEvent):void 
		{
			windowLayer.openWindow(whiteWinWindow);
		}
		
		private function onCloseWhiteWinWindow(e:TimerEvent):void 
		{
			whiteWinWindow.close(BaseWindow.MIDDLE_EFFECT);
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
				
				dispatchEvent(new Event(PlayerInfo.EXIT));
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
				PlayerInfo(playingPlayerArray[i]).removeAllCards();
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
							if (PlayerInfo(allPlayerArray[j]).isReadyPlay)
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
		}
		
		private function showReadyButton():void
		{
			waitToReady.visible = false;
			/*var i:int;
			
			if (isHaveUserReady)
			{
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (!PlayerInfo(allPlayerArray[i]).isReadyPlay)
						{
							PlayerInfo(allPlayerArray[i]).isWaitingToReady = true;
							PlayerInfo(allPlayerArray[i]).countTime(Number(mainData.init.playTime.readyTime));
						}
						if (allPlayerArray[i] == belowUserInfo)
							belowUserInfo.showTooltip(mainData.init.gameDescription.playingScreen.readyAlert);
					}
				}
			}*/
			
			if (!readyButton)
				createButton("readyButton", "zReadyButton", "readyButtonPosition");
			readyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			addChild(readyButton);
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
			
			/*if (countPlayer == 1)
				waitToReady.visible = true;
			else
				waitToPlay.visible = true;*/
				
			if (readyButton)
			{
				if (this.contains(readyButton))
				{
					//belowUserInfo.stopCountTime();
					removeChild(readyButton);	
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
			addChild(startButton);
		}
		
		private function hideStartButton():void
		{
			if (startButton)
			{
				if (this.contains(startButton))
					removeChild(startButton);	
			}
		}
		
		// add một người chơi, đầu vào là vị trí tương ứng từ 1-4
		public function addOnePlayer(position:int):void 
		{
			switch (position) 
			{
				case 0:
					addPlayerByType(PlayerInfo.BELOW_USER, position, true);
				break;
				case 1:
					addPlayerByType(PlayerInfo.RIGHT_USER, position, false);
				break;
				case 2:
					addPlayerByType(PlayerInfo.ABOVE_USER, position, false);
				break;
				case 3:
					addPlayerByType(PlayerInfo.LEFT_USER, position, false);
				break;
			}
		}
		
		// add thông tin cá nhân (tên, money, cấp độ, avatar)
		public function addPersonalInfo(data:Object):void
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfo(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						PlayerInfo(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataField.READY])
						{
							//isHaveUserReady = true;
							PlayerInfo(allPlayerArray[i]).isReadyPlay = true;
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
					if (PlayerInfo(allPlayerArray[i]).position == data[DataField.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfo(allPlayerArray[i]).isPlaying = true;
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
					if (PlayerInfo(allPlayerArray[i]).position == position)
					{
						if (isPlaying)
						{
							for (var j:int = 0; j < playingPlayerArray.length; j++) 
							{
								if (PlayerInfo(allPlayerArray[i]) == PlayerInfo(playingPlayerArray[j]))
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
					PlayerInfo(this[PlayerInfo.BELOW_USER]).destroy();
				break;
				case 1:
					PlayerInfo(this[PlayerInfo.RIGHT_USER]).destroy();
				break;
				case 2:
					PlayerInfo(this[PlayerInfo.ABOVE_USER]).destroy();
				break;
				case 3:
					PlayerInfo(this[PlayerInfo.LEFT_USER]).destroy();
				break;
			}
		}
		
		private function addPlayerByType(playerType:String, position:int, isCardInteractive:Boolean = false):void
		{
			this[playerType] = new PlayerInfo();
			PlayerInfo(this[playerType]).leavedCardPoint = content["leaveCardPoint"];
			content["leaveCardPoint"].visible = false;
			this[playerType].addEventListener(PlayerInfo.AVATAR_CLICK, onShowContextMenu);
			PlayerInfo(this[playerType]).position = position;
				
			// Có cho phép tương tác vào quân bài của người chơi này không
			PlayerInfo(this[playerType]).isCardInteractive = isCardInteractive;
			
			PlayerInfo(this[playerType]).setForm(playerType);
				
			this[playerType].x = content[playerType + "Position"].x;
			this[playerType].y = content[playerType + "Position"].y;
			addChild(this[playerType]);
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
					removeChild(myContextMenu);
				}
			}
			
			myContextMenu = new MyContextMenu();
			myContextMenu.addEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
			myContextMenu.addEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
				
			var contextMenuData:Object = new Object();
			contextMenuData[DataField.DISPLAY_NAME] = PlayerInfo(e.currentTarget).displayName;
			contextMenuData[DataField.USER_NAME] = PlayerInfo(e.currentTarget).userName;
			contextMenuData[DataField.AVATAR] = PlayerInfo(e.currentTarget).avatarString;
			contextMenuData[DataField.LOGO] = PlayerInfo(e.currentTarget).logoString;
			myContextMenu.data = contextMenuData;
			
			if (!isPlaying && belowUserInfo.isRoomMaster)
				myContextMenu.enableKickOut = true;
			else
				myContextMenu.enableKickOut = false;
				
			var tempPoint:Point = PlayerInfo(e.currentTarget).contextMenuPosition;
			tempPoint = PlayerInfo(e.currentTarget).localToGlobal(tempPoint);
			tempPoint = globalToLocal(tempPoint);
			myContextMenu.x = Math.round(tempPoint.x);
			myContextMenu.y = Math.round(tempPoint.y);
			if (!contains(myContextMenu))
			{
				addChild(myContextMenu);
			}
			else
			{
				myContextMenu.removeEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
				myContextMenu.removeEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
				removeChild(myContextMenu);
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
					removeChild(myContextMenu);
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
						var tempPlayer:PlayerInfo = playingPlayerArray[i];
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
				cardManager = new CardManagerTLMN();
			cardManager.getCardPoint.visible = true;
			cardManager.x = content["cardManagerPosition"].x;
			cardManager.y = content["cardManagerPosition"].y;
			addChild(cardManager);
		}
		
		private function removeCardManager():void
		{
			if (cardManager)
			{
				if (contains(cardManager))
				{
					removeChild(cardManager);
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
						if (data[DataField.USER_NAME] == PlayerInfo(allPlayerArray[i]).userName)
							PlayerInfo(allPlayerArray[i]).isReadyPlay = true;
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
					if (data[DataField.USER_NAME] == PlayerInfo(allPlayerArray[i]).userName)
					{
						/*if (!isHaveUserReady)
						{
							for (var j:int = 0; j < allPlayerArray.length; j++) 
							{
								if (allPlayerArray[j])
								{
									if (allPlayerArray[j] != allPlayerArray[i] && !PlayerInfo(allPlayerArray[j]).isReadyPlay)
									{
										PlayerInfo(allPlayerArray[j]).showTooltip(mainData.init.gameDescription.playingScreen.readyAlert)
										PlayerInfo(allPlayerArray[j]).countTime(Number(mainData.init.playTime.readyTime));
										PlayerInfo(allPlayerArray[j]).isWaitingToReady = true;
									}
								}
							}
						}*/
						
						PlayerInfo(allPlayerArray[i]).isReadyPlay = true;
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
						PlayerInfo(allPlayerArray[i]).removeEventListener(PlayerInfo.AVATAR_CLICK, onShowContextMenu);
						PlayerInfo(allPlayerArray[i]).destroy();
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
	}

}