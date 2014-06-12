package view.screen 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.gskinner.motion.GTween;
	import control.electroServerCommand.ElectroServerCommandPhom;
	import control.MainCommand;
	import event.Command;
	import event.DataFieldPhom;
	import event.PlayingScreenEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import sound.SoundLibChung;
	import sound.SoundLibPhom;
	import sound.SoundManager;
	import view.button.MyButton;
	import view.card.CardPhom;
	import view.card.CardManagerPhom;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.InvitePlayWindow;
	import view.window.OrderCardWindow;
	import view.window.ResultWindowPhom;
	import view.window.UserProfileWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenPhom extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		public static const BACK_TO_CHOOSE_CHANNEL_SCREEN:String = "backToChooseChannelScreen";
		
		private var belowUserInfo:PlayerInfoPhom;
		private var rightUserInfo:PlayerInfoPhom;
		private var leftUserInfo:PlayerInfoPhom;
		private var aboveUserInfo:PlayerInfoPhom;
		
		private var chatBox:ChatBoxPhom;
		
		private var cardManager:CardManagerPhom;
		private var allPlayerArray:Array; // Mảng chứa tất cả người chơi
		private var playingPlayerArray:Array; // Mảng chứa các người chơi đang trong ván bài
		
		private var roomBet:TextField;
		private var channelNameAndRoomId:TextField;
		private var ruleDescription:TextField;
		private var waitToPlay:MovieClip;
		private var waitToStart:MovieClip;
		
		private var mainData:MainData = MainData.getInstance();
		
		private var readyButton:MyButton;
		private var startButton:MyButton;
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:ElectroServerCommandPhom = mainCommand.electroServerCommand;
		private var timerToShowResultWindow:Timer;
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
		
		private var autoStartTimeTxt:TextField;
		private var isFirstJoin:Boolean;
		private var timerToAutoStart:Timer;
		
		private var settingBoard:MovieClip;
		private var settingButton:SimpleButton;
		private var snapShotButton:SimpleButton;
		private var showIpButton:SimpleButton;
		private var soundOnButton:SimpleButton;
		private var soundOffButton:SimpleButton;
		private var musicOnButton:SimpleButton;
		private var musicOffButton:SimpleButton;
		private var orderCardButton:SimpleButton;
		private var versionTxt:TextField;
		private var invitePlayButtonArray:Array;
		
		private var ipBoard:Sprite;
		public var autoReady:MovieClip;
		private var playingLayer:Sprite;
		private var chatboxLayer:Sprite;
		private var chatButton:SimpleButton;
		private var isResetDone:Boolean = true;
		
		private var _giveUpPlayerArray:Array;
		
		public function PlayingScreenPhom() 
		{
			super();
			addContent("zPlayingScreenPhom");
			createLayer();
			
			invitePlayButtonArray = new Array();
			invitePlayButtonArray.push(content["invitePlayButton1"]);
			invitePlayButtonArray.push(content["invitePlayButton2"]);
			invitePlayButtonArray.push(content["invitePlayButton3"]);
			for (var i:int = 0; i < 3; i++) 
			{
				invitePlayButtonArray[i].addEventListener(MouseEvent.CLICK, onInvitePlayButtonClick);
			}
			
			versionTxt = content["versionTxt"];
			versionTxt.text = "10h20 - 04.04.2014";
			setupButton();
			setupTextField();
			hidePosition();
			createVariable();
			mainData.playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			chatBox = new ChatBoxPhom();
			chatBox.visible = false;
			chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			chatBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
			waitToPlay = content["waitToPlay"];
			waitToStart = content["waitToStart"];
			waitToPlay.visible = waitToStart.visible = false;
			chatboxLayer.addChild(chatBox);
			
			timerToPing = new Timer(pingTime * 1000);
			timerToPing.addEventListener(TimerEvent.TIMER, onPingToServer);
			timerToPing.start();
			
			autoStartTimeTxt = content["autoStartTimeTxt"];
			autoStartTimeTxt.text = '';
			autoStartTimeTxt.visible = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			autoReady = content["autoReady"];
			autoReady.stop();
			autoReady.buttonMode = true;
			autoReady.addEventListener(MouseEvent.CLICK, onAutoReadyClick);
			
			ipBoard = content["ipBoard"];
			ipBoard.addEventListener(MouseEvent.CLICK, onIpBoardClick);
			ipBoard.visible = false;
			
			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldPhom.MESSAGE];
				chatBox.addChatSentence(textField.text, "Thông báo");
			}
		}
		
		private function onChatBoxBackButtonClick(e:Event):void 
		{
			chatBox.visible = false;
			chatButton.visible = true;
		}
		
		private function createLayer():void 
		{
			playingLayer = new Sprite();
			chatboxLayer = new Sprite();
			addChild(playingLayer);
			addChild(chatboxLayer);
		}
		
		private function onInvitePlayButtonClick(e:MouseEvent):void 
		{
			var invitePlayWindow:InvitePlayWindow = new InvitePlayWindow();
			windowLayer.openWindow(invitePlayWindow);
		}
		
		private function onHaveChat(e:Event):void 
		{
			electroServerCommand.sendPublicChat(mainData.chooseChannelData.myInfo.name, chatBox.currentText);
		}
		
		private function onAutoReadyClick(e:MouseEvent):void 
		{
			if (autoReady.currentFrame == 1)
			{
				autoReady.gotoAndStop(2);
				mainData.isAutoReady = true;
			}
			else
			{
				autoReady.gotoAndStop(1);
				mainData.isAutoReady = false;
			}
		}
		
		private function onIpBoardClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
		private var timerToHideIpBoard:Timer;
		private function showIpBoard():void
		{
			if (timerToHideIpBoard)
			{
				timerToHideIpBoard.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideIpBoard);
				timerToHideIpBoard.stop();
			}
			
			var ipIndex:int = 0;
			var i:int;
			
			for (i = 0; i < mainData.maxPlayer; i++) 
			{
				TextField(ipBoard["displayNameTxt" + String(ipIndex + 1)]).text = '';
				TextField(ipBoard["ipTxt" + String(ipIndex + 1)]).text = '';
			}
			
			for (i = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					TextField(ipBoard["displayNameTxt" + String(ipIndex + 1)]).text = PlayerInfoPhom(allPlayerArray[i]).displayName;
					var ipString:String = String(PlayerInfoPhom(allPlayerArray[i]).ip);
					var countDot:int = 0;
					var postfixString:String = '';
					for (var j:int = 0; j < ipString.length; j++) 
					{
						if (ipString.charAt(j) == '.')
							countDot++;
						if (countDot > 1)
							postfixString += ipString.charAt(j);
					}
					TextField(ipBoard["ipTxt" + String(ipIndex + 1)]).text = "***.***" + postfixString;
					ipIndex++;
				}
			}
			
			playingLayer.addChild(ipBoard);
			ipBoard.visible = true;
			settingBoard.visible = false;
		}
		
		private function onHideIpBoard(e:TimerEvent):void 
		{
			ipBoard.visible = false;
		}
		
		private function checkConflictIp():void 
		{
			var isConflictIp:Boolean;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				for (var j:int = 0; j < allPlayerArray.length; j++) 
				{
					if (allPlayerArray[i] != allPlayerArray[j])
					{
						if (allPlayerArray[i] && allPlayerArray[j])
						{
							if (PlayerInfoPhom(allPlayerArray[i]).ip == PlayerInfoPhom(allPlayerArray[j]).ip)
								isConflictIp = true;
						}
					}
				}
			}
			if (isConflictIp)
			{
				showIpBoard();
				timerToHideIpBoard = new Timer(3000, 1);
				timerToHideIpBoard.addEventListener(TimerEvent.TIMER_COMPLETE, onHideIpBoard);
				timerToHideIpBoard.start();
			}
		}
		
		private var sharedObject:SharedObject;
		private var timerToCheckTime:Timer;
		private var startPlayer:PlayerInfoPhom;
		private var stealedPlayerObject:Object;
		private var stealPlayerObject:Object;
		private var playerCompensateAll:PlayerInfoPhom;
		private var playerWin:PlayerInfoPhom;
		private var timerToResetMatch:Timer;
		private function setupButton():void 
		{
			chatButton = content["chatButton"];
			settingBoard = content["settingBoard"];
			settingBoard.visible = false;
			settingButton = content["settingButton"];
			snapShotButton = settingBoard["snapShotButton"];
			showIpButton = settingBoard["showIpButton"];
			soundOnButton = settingBoard["soundOnButton"];
			soundOffButton = settingBoard["soundOffButton"];
			musicOnButton = settingBoard["musicOnButton"];
			musicOffButton = settingBoard["musicOffButton"];
			orderCardButton = content["orderCardButton"];
			orderCardButton.visible = false;
			if (mainData.chooseChannelData.myInfo.name == "truongvu")
				orderCardButton.visible = true;
			
			sharedObject = SharedObject.getLocal("soundConfig");
			
			musicOnButton.visible = false;
			musicOffButton.visible = true;
			soundOnButton.visible = false;
			soundOffButton.visible = true;
			if (sharedObject.data.isSoundOff)
			{
				soundOnButton.visible = true;
				soundOffButton.visible = false;
			}
			if (sharedObject.data.isMusicOff)
			{
				musicOnButton.visible = true;
				musicOffButton.visible = false;
			}
			
			settingBoard.addEventListener(MouseEvent.CLICK, onSettingBoardClick);
			settingButton.addEventListener(MouseEvent.CLICK, onSettingButtonClick);
			snapShotButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			showIpButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			soundOnButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			soundOffButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			musicOnButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			musicOffButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			orderCardButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			chatButton.addEventListener(MouseEvent.CLICK, onChatButtonClick);
		}
		
		private function onChatButtonClick(e:MouseEvent):void 
		{
			chatBox.visible = true;
			chatButton.visible = false;
		}
		
		private function onSettingBoardClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
		private function onSettingButtonClick(e:MouseEvent):void 
		{
			settingBoard.visible = !settingBoard.visible;
			if (settingBoard.visible)
				ipBoard.visible = false;
			e.stopImmediatePropagation();
		}
		
		private function onMenuButtonClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			switch (e.currentTarget) 
			{
				case soundOnButton:
					SoundManager.getInstance().isSoundOn = true;
					sharedObject.setProperty("isSoundOff", !SoundManager.getInstance().isSoundOn);
					soundOnButton.visible = false;
					soundOffButton.visible = true;
				break;
				case soundOffButton:
					SoundManager.getInstance().isSoundOn = false;
					sharedObject.setProperty("isSoundOff", !SoundManager.getInstance().isSoundOn);
					soundOnButton.visible = true;
					soundOffButton.visible = false;
				break;
				case musicOnButton:
					SoundManager.getInstance().isMusicOn = true;
					sharedObject.setProperty("isMusicOff", !SoundManager.getInstance().isMusicOn);
					musicOnButton.visible = false;
					musicOffButton.visible = true;
				break;
				case musicOffButton:
					SoundManager.getInstance().isMusicOn = false;
					sharedObject.setProperty("isMusicOff", !SoundManager.getInstance().isMusicOn);
					musicOnButton.visible = true;
					musicOffButton.visible = false;
				break;
				case showIpButton:
					if (ipBoard.visible)
						ipBoard.visible = false;
					else
						showIpBoard();
					e.stopImmediatePropagation();
				break;
				case snapShotButton:
					
				break;
				case orderCardButton:
					if (belowUserInfo.isRoomMaster)
					{
						var orderCardWindow:OrderCardWindow = new OrderCardWindow();
						windowLayer.openWindow(orderCardWindow);
					}
				break;
				default:
			}
		}
		
		private function onFriendConfirmAddFriendInvite(e:Event):void 
		{
			
		}
		
		private function onConfirmFriendRequest(e:Event):void 
		{
			var invitedNameArray:Array = [mainData.confirmFriendRequestData[DataFieldPhom.FRIEND_ID]];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldPhom.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldPhom.MESSAGE, mess);
			
			if (mainData.confirmFriendRequestData[DataFieldPhom.CONFIRM])
			{
				if (electroServerCommand.coreAPI.myData.friendList)
				{
					electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldPhom.FRIEND_ID]] = new Object();
					if (electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldPhom.FRIEND_ID]])
					{
						var displayName:String = electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldPhom.FRIEND_ID]][DataFieldPhom.USER_INFO][DataFieldPhom.DISPLAY_NAME];
						electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldPhom.FRIEND_ID]][DataFieldPhom.DISPLAY_NAME] = displayName;
					}
				}
				esObject.setBoolean(DataFieldPhom.CONFIRM, true);
			}
			else
			{
				esObject.setBoolean(DataFieldPhom.CONFIRM, false);
			}
			
			electroServerCommand.sendPrivateMessage(invitedNameArray, Command.CONFIRM_ADD_FRIEND_INVITE, esObject);
		}
		
		private function onInviteAddFriend(e:Event):void 
		{
			var inviteAddFriendWindow:ConfirmWindow = new ConfirmWindow();
			inviteAddFriendWindow.setNotice(mainData.inviteAddFriendData[DataFieldPhom.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.addFriendSentence);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmInvite);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.REJECT, onRejectInvite);
			windowLayer.openWindow(inviteAddFriendWindow);
		}
		
		private function onConfirmInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldPhom.USER_NAME], true, DataFieldPhom.IN_GAME_ROOM);
		}
		
		private function onRejectInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldPhom.USER_NAME], false, DataFieldPhom.IN_GAME_ROOM);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			mainData.addEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			
			isFirstJoin = true;
			//addPlayer();
			
			checkTime();
			
			if (timerToCheckTime)
			{
				timerToCheckTime.removeEventListener(TimerEvent.TIMER, onTimerToCheckTime);
				timerToCheckTime.stop();
			}
			timerToCheckTime = new Timer(60000);
			timerToCheckTime.addEventListener(TimerEvent.TIMER, onTimerToCheckTime);
			timerToCheckTime.start();
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			var isMe:Boolean;
			if (mainData.chooseChannelData.myInfo.uId == mainData.publicChatData.userName)
				isMe = true;
			chatBox.addChatSentence(mainData.publicChatData.chatContent, mainData.publicChatData.displayName, isMe);
		}
		
		private function onTimerToCheckTime(e:TimerEvent):void 
		{
			if (!stage)
				return;
			checkTime();
		}
		
		private function checkTime():void
		{
			var currDate:Date = new Date();
			
			var H:int = currDate.getHours();
			
			if (H >= 6 && H < 18)
				MovieClip(content["background"]).gotoAndStop("day");
			else
				MovieClip(content["background"]).gotoAndStop("night");
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (timerToCheckTime)
			{
				timerToCheckTime.removeEventListener(TimerEvent.TIMER, onTimerToCheckTime);
				timerToCheckTime.stop();
			}
			
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
			mainData.addEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			//alpha = 0;
			//var tempTween1:GTween = new GTween(this, effectTime, { alpha:1 } );
		}
		
		public function effectClose():void
		{
			mainData.removeEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.removeEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.removeEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.removeEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			var tempTween1:GTween = new GTween(this, effectTime, { alpha:0 } );
			mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			//tempTween1.addEventListener(Event.COMPLETE, closeComplete);
			
			dispatchEvent(new Event(CLOSE_COMPLETE));
		}
		
		private function onUpdateSystemNotice(e:Event):void 
		{
			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldPhom.MESSAGE];
				chatBox.addChatSentence(textField.text, "Thông báo");
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
			content["startButtonPosition"].visible = false;
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
					listenHaveUserJoinRoom(e.data[ModelField.DATA]);
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
		
		private function listenHaveUserJoinRoom(data:Object):void 
		{
			SoundManager.getInstance().soundManagerPhom.playOtherJoinGamePlayerSound(data[DataFieldPhom.SEX]);
			
			chatBox.addChatSentence(data[DataFieldPhom.DISPLAY_NAME] + " " + mainData.init.gameDescription.playingScreen.userJoinRoom, "Thông báo");
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
			data[DataFieldPhom.POSITION] = indexEmpty;
			addPersonalInfo(data);
			
			var countPlayer:int = 0;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
					countPlayer++;
			}
			if (isResetDone && countPlayer == 2)
			{
				removeCardManager();
				waitToPlay.visible = true;
			}
			
			checkConflictIp();
			
			for (i = 0; i < giveUpPlayerArray.length ; i++) 
			{
				var giveUpObject:Dictionary = giveUpPlayerArray[i];
				if (giveUpObject[DataFieldPhom.POSITION] == indexEmpty)
				{
					PlayerInfoPhom(giveUpObject[DataFieldPhom.PLAYER]).destroy();
					giveUpPlayerArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			var i:int;
			var j:int;
			var outPlayer:PlayerInfoPhom;
			if (isPlaying)
			{
				SoundManager.getInstance().playSound(SoundLibChung.GIVE_UP_SOUND);
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
						{
							outPlayer = allPlayerArray[i];
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
										PlayerInfoPhom(playingPlayerArray[myIndex]).countTime(mainData.init.playTime.playCardTime);
									}
								}
								// Nếu mình đang có turn mà thằng trc mình thoát thì đề phòng trường hợp mình đang có thể ăn đc con bài thằng kia vừa đánh
								if (nextTurn == belowUserInfo.userName && PlayerInfoPhom(allPlayerArray[i]).isPlaying) 
									belowUserInfo.stealCardButton.enable = false;
							}
							if (outPlayer.isPlaying)
								removeOnePlayer(i, true);
							else
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
						if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
						{
							outPlayer = allPlayerArray[i];
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
							if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay)
								return;
						}
					}
					hideStartButton();
					if(countPlayer > 1)
						waitToPlay.visible = true;
				}
			}
			
			SoundManager.getInstance().soundManagerPhom.playOtherExitGamePlayerSound(outPlayer.sex);
		}
		
		private function listenJoinRoom(data:Object):void 
		{
			SoundManager.getInstance().soundManagerPhom.playOtherJoinGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			
			var channelName:String = mainData.playingData.gameRoomData.channelName;
			var roomId:String = String(mainData.playingData.gameRoomData.roomId);
			var roomBet:String = PlayingLogic.format(data[DataFieldPhom.ROOM_BET], 1);
			ruleDescription.text = mainData.gameName + " - " + channelName + " - Bàn " + roomId + " - Cược " + roomBet + " G";
			
			mainData.playingData.gameRoomData.roomBet = data[DataFieldPhom.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataFieldPhom.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataFieldPhom.IS_SEND_CARD];
			
			if (data[DataFieldPhom.IS_SEND_CARD])
				var sendCardRule:String = mainData.init.gameDescription.playingScreen.sendCardRule;
			else
				sendCardRule = mainData.init.gameDescription.playingScreen.notSendCardRule;
				
			if (data[DataFieldPhom.IS_GA])
				var gaRule:String = mainData.init.gameDescription.playingScreen.gaRule;
			else
				gaRule = mainData.init.gameDescription.playingScreen.notGaRule;
				
			mainData.isPhomGa = data[DataFieldPhom.IS_GA];
			
			var i:int;
			var userList:Array = data[DataFieldPhom.USER_LIST] as Array;
			
			// sắp xếp lại các position
			reArrangePositions(userList);
			
			// add người chơi
			for (i = 0; i < userList.length; i++) 
			{
				addOnePlayer(userList[i][DataFieldPhom.POSITION]);
			}
			
			// bổ sung thông tin cá nhân
			for (i = 0; i < userList.length; i++) 
			{
				addPersonalInfo(userList[i]);
			}
			
			belowUserInfo.setMyTurn(PlayerInfoPhom.DO_NOTHING);
			belowUserInfo.arrangeCardButton.enable = false;
			
			if (data[DataFieldPhom.GAME_STATE] == DataFieldPhom.WAITING) // Nếu phòng chơi chưa bắt đầu
			{
				if (allPlayerArray.length > 1)
					showReadyButton();
					//belowUserInfo.showTooltip(mainData.init.gameDescription.playingScreen.waitOtherPlayer);
			}
			else // Nếu phòng chơi đang chơi
			{
				addCardManager();
				// bổ sung thông tin cá nhân
				for (i = 0; i < userList.length; i++) 
				{
					// Không phải add cho mình vì minh vừa vào nên chắc chắc là không có bài
					if(!userList[i][DataFieldPhom.IS_VIEWER]) 
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
				isResetDone = false;
				cardManager.playerArray = playingPlayerArray;
			}
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataFieldPhom.ROOM_MASTER])
					{
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = true;
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = false;
						i = allPlayerArray.length + 1;
					}
				}
			}
			
			checkConflictIp();
		}
		
		private function listenDealCard(data:Object):void 
		{
			//isHaveUserReady = false;
			giveUpPlayerArray = new Array();
			giveUpPlayerArray = new Array();
			stealedPlayerObject = new Object();
			stealPlayerObject = new Object();
			hideReadyButton();
			hideStartButton();
			waitToPlay.visible = false;
			waitToStart.visible = false;
			var i:int;
			isPlaying = true;
			isResetDone = false;
			playingPlayerArray = new Array();
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay || PlayerInfoPhom(allPlayerArray[i]).isRoomMaster)
						playingPlayerArray.push(allPlayerArray[i]);
				}
			}
			
			// tính index của người thắng
			var winnerIndex:int = data[DataFieldPhom.WINNER_INDEX];
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
					PlayerInfoPhom(playingPlayerArray[i]).cardInfoArray = data[DataFieldPhom.PLAYER_CARDS] as Array;
				}
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).position == winnerIndex)
					{
						nextTurn = PlayerInfoPhom(playingPlayerArray[i]).userName;
						PlayerInfoPhom(playingPlayerArray[i]).isCurrentWinner = true;
						//PlayerInfoPhom(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.playCardTime) + 3);
						PlayerInfoPhom(playingPlayerArray[i]).cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
						startPlayer = playingPlayerArray[i];
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
			if (data[DataFieldPhom.IS_CURRENT_WINNER])
			{
				nextTurn = belowUserInfo.userName;
				belowUserInfo.setMyTurn(PlayerInfoPhom.PLAY_CARD);
				belowUserInfo.isCurrentWinner = true;
				//belowUserInfo.countTime(Number(mainData.init.playTime.playCardTime) + 3);
				startPlayer = belowUserInfo;
			}
			else
			{
				belowUserInfo.isCurrentWinner = false;
			}
			
			var timerToCountTimeForStartPlayer:Timer = new Timer(3000, 1)
			timerToCountTimeForStartPlayer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountTimeForStartPlayer);
			timerToCountTimeForStartPlayer.start();
		}
		
		private function onCountTimeForStartPlayer(e:TimerEvent):void 
		{
			if (!stage || !startPlayer.isPlaying)
				return;
			if (startPlayer == belowUserInfo)
				SoundManager.getInstance().playSound(SoundLibChung.MY_TURN_SOUND);
			startPlayer.countTime(Number(mainData.init.playTime.playCardTime));
		}
		
		private function listenHaveUserDiscard(data:Object):void 
		{
			var i:int;
			
			nextTurn = data[DataFieldPhom.NEXT_TURN];
			var playerDisCard:PlayerInfoPhom;
			// Nếu người đánh bài không phải là mình thì xử lý đánh bài
			//if (data[DataFieldPhom.USER_NAME] != belowUserInfo.userName)
			//{
				for (i = 0; i < playingPlayerArray.length; i++) // Tìm user server vừa gửi về để gọi lệnh đánh bài của user đó
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
					{
						PlayerInfoPhom(playingPlayerArray[i]).addValueForOneUnleavedCard(data[DataFieldPhom.CARD]);
						PlayerInfoPhom(playingPlayerArray[i]).playOneCard(data[DataFieldPhom.CARD]);
						var tempCard:CardPhom = PlayerInfoPhom(playingPlayerArray[i]).leavedCards[PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length - 1];
						if (playingPlayerArray[i] != belowUserInfo)
							PlayerInfoPhom(playingPlayerArray[i]).stopCountTime();
						playerDisCard = playingPlayerArray[i];
						i = playingPlayerArray.length;
					}
				}
			//}
			//else
			//{
				//playerDisCard = belowUserInfo;
			//}
			
			var isBolt:Boolean;
			var isEndPlayer:Boolean;
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataFieldPhom.NEXT_TURN] == PlayerInfoPhom(playingPlayerArray[i]).userName) 
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
							PlayerInfoPhom(playingPlayerArray[i]).countTime(mainData.init.playTime.playCardTime);
						}
						
						if (PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length == 3)
						{
							isBolt = true;
							SoundManager.getInstance().soundManagerPhom.playBoltSoundPlayerSound(playerDisCard.sex);
						}
					}
					else // Nếu không thì đây là lần đánh cuối cùng của người hạ cuối, và ván chơi đã kết thúc
					{
						belowUserInfo.setMyTurn(PlayerInfoPhom.DO_NOTHING);
						belowUserInfo.arrangeCardButton.enable = false;
						isEndPlayer = true;
					}
				}
			}
			
			if (!isBolt && !isEndPlayer)
			{
				if (stealedPlayerObject[playerDisCard.userName] == 2)
					SoundManager.getInstance().soundManagerPhom.playRiskDiscardPlayerSound(playerDisCard.sex);
				else
					SoundManager.getInstance().soundManagerPhom.playDiscardPlayerSound(playerDisCard.sex);
			}
		}
		
		private function listenGetCardSuccess(data:Object):void 
		{
			cardManager.divideOneCard(belowUserInfo, data[DataFieldPhom.CARD], CardManagerPhom.cardToDesTime / 2, true);
			belowUserInfo.checkAutoPlayCard();
			belowUserInfo.getCardSuccess();
		}
		
		private function listenHaveUserGetCard(data:Object):void // Có người bốc bài
		{
			if (data[DataFieldPhom.USER_NAME] == belowUserInfo.userName)
				return;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
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
			var downCardArray:Array = data[DataFieldPhom.CARDS] as Array;
			if (data[DataFieldPhom.USER_NAME] == belowUserInfo.userName) // Nếu người hạ bài là mình
			{
				belowUserInfo.downOneDeck(downCardArray, false, data[DataFieldPhom.INDEX]);
				return;
			}
			belowUserInfo.isHaveUserDownCard = true;
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
				{
					for (var j:int = 0; j < downCardArray.length; j++) 
					{
						PlayerInfoPhom(playingPlayerArray[i]).addValueForOneUnleavedCard(downCardArray[j]);
					}
					PlayerInfoPhom(playingPlayerArray[i]).downOneDeck(downCardArray, false, data[DataFieldPhom.INDEX]);
					i = playingPlayerArray.length;
				}
			}
		}
		
		private function listenHaveUserDownCardFinish(data:Object):void // có user hạ bài xong
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldPhom.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
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
				if (data[DataFieldPhom.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
				{
					if (PlayerInfoPhom(playingPlayerArray[i]).leavedCards.length < 4)
						PlayerInfoPhom(playingPlayerArray[i]).countTime(mainData.init.playTime.playCardTime);
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
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataFieldPhom.ROOM_MASTER])
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = false;
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = true;
					}
					else
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = true;
						PlayerInfoPhom(allPlayerArray[i]).isRoomMaster = false;
					}
				}
			}
			if (isResetDone)
			{
				if (belowUserInfo.isRoomMaster)
				{
					waitToPlay.visible = false;
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
			if (data[DataFieldPhom.USER_NAME] == belowUserInfo.userName) // Nếu người bị kick là mình
			{
				dispatchEvent(new Event(PlayerInfoPhom.EXIT));
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom(true);
				
				var kickOutWindow:AlertWindow = new AlertWindow();
				kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
				kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.roomMasterKick);
				windowLayer.openWindow(kickOutWindow);
			}
		}
		
		private function onKickOutWindowCloseComplete(e:Event):void 
		{
			windowLayer.closeAllWindow();
		}
		
		private function listenUpdateMoney(data:Object):void // update tiền
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
					{
						PlayerInfoPhom(allPlayerArray[i]).updateMoney(data[DataFieldPhom.MONEY]);
						
						if (data[DataFieldPhom.USER_NAME] == belowUserInfo.userName && !isPlaying)
						{
							// Nếu không đủ tiền để chơi ván mới
							if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet))
							{	
								dispatchEvent(new Event(PlayerInfoPhom.EXIT));
								windowLayer.isNoCloseAll = true;
								electroServerCommand.joinLobbyRoom();
								
								if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
								{
									var kickOutWindow:AlertWindow = new AlertWindow();
									kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
									kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
									windowLayer.openWindow(kickOutWindow);
								}
								
								EffectLayer.getInstance().removeAllEffect();
							}
						}
					}
				}
			}
		}
		
		private function listenUpdatePot(data:Object):void // update tiền trong gà
		{

			//mainData.gaData = data;
		}
		
		private function listenHaveUserSendCard(data:Object):void // có user hạ bài xong
		{
			var fromPlayer:PlayerInfoPhom;
			var toPlayer:PlayerInfoPhom;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldPhom.USER_NAME] == PlayerInfoPhom(playingPlayerArray[i]).userName)
					fromPlayer = playingPlayerArray[i];
				if (data[DataFieldPhom.DESTINATION_USER] == PlayerInfoPhom(playingPlayerArray[i]).userName)
					toPlayer = playingPlayerArray[i];
			}
			for (i = 0; i < data[DataFieldPhom.CARD].length; i++)
			{
				if (fromPlayer != belowUserInfo)
				{
					fromPlayer.addValueForOneUnleavedCard(data[DataFieldPhom.CARD][i]);
				}
				cardManager.sendCard(fromPlayer, toPlayer, data[DataFieldPhom.CARD][i], data[DataFieldPhom.INDEX]);
			}
		}
		
		private function listenGameOver(data:Object):void // ván bài kết thúc
		{
			var playerList:Array = data[DataFieldPhom.PLAYER_LIST] as Array;
			var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			var time:Number;
			var playerFullDeck:PlayerInfoPhom;
			playerCompensateAll = null;
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (playerList[i][DataFieldPhom.USER_NAME] == PlayerInfoPhom(playingPlayerArray[j]).userName)
					{
						PlayerInfoPhom(playingPlayerArray[j]).isPlaying = false;
						PlayerInfoPhom(playingPlayerArray[j]).stopCountTime();
						
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfoPhom(playingPlayerArray[j]).localToGlobal(PlayerInfoPhom(playingPlayerArray[j]).moneyEffectPosition);
						if (playerList[i][DataFieldPhom.RESULT_POSITION] != 0)
						{
							//PlayerInfoPhom(playingPlayerArray[j]).updateMoney(playerList[i][DataFieldPhom.MONEY] * -1);
							//effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataFieldPhom.MONEY] * -1);
						}
						else
						{
							//PlayerInfoPhom(playingPlayerArray[j]).updateMoney(playerList[i][DataFieldPhom.MONEY]);
							//effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataFieldPhom.MONEY]);
							playerWin = playingPlayerArray[j];
						}
							
						// add effect kết quả - móm, ù, thắng
						time = mainData.init.effect.time.resultEffect;
						resultEffectPosition = PlayerInfoPhom(playingPlayerArray[j]).localToGlobal(PlayerInfoPhom(playingPlayerArray[j]).resultEffectPosition);
						
						if (playerList[i][DataFieldPhom.RESULT_POSITION] == 0) // Về nhất
						{
							if (playerList[i][DataFieldPhom.POINT] == 0) // Ù
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j]);
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("fullDeck");
								SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
								effectLayer.addEffect(EffectLayer.FULL_DECK_EFFECT, resultEffectPosition, time);
							}
							else if (playerList[i][DataFieldPhom.POINT] == -5) // Ù khan
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j]);
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("fullDeck");
								SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
								effectLayer.addEffect(EffectLayer.FULL_DECK_EFFECT, resultEffectPosition, time);
							}
							else if (playerList[i][DataFieldPhom.POINT] == -6) // Ù tròn
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j]);
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("fullDeck");
								SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
								effectLayer.addEffect(EffectLayer.FULL_DECK_EFFECT, resultEffectPosition, time);
							}
							else if (playerList[i][DataFieldPhom.POINT] == -7) // Ù thiên
							{
								playerFullDeck = PlayerInfoPhom(playingPlayerArray[j]);
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("fullDeck");
								SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
								effectLayer.addEffect(EffectLayer.FULL_DECK_EFFECT, resultEffectPosition, time);
							}
							else
							{
								//effectLayer.addEffect(EffectLayer.WIN_EFFECT, resultEffectPosition, time); // Thắng
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("win")
							}
						}
						else // Không về nhất
						{
							if (playerList[i][DataFieldPhom.POINT] == -1) // Móm
							{
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("noDeck");
								//effectLayer.addEffect(EffectLayer.NO_DECK_EFFECT, resultEffectPosition, time);
							}
							else if (playerList[i][DataFieldPhom.POINT] == -2) // Đền
							{
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("compensateAll");
								playerCompensateAll = PlayerInfoPhom(playingPlayerArray[j]);
								//effectLayer.addEffect(EffectLayer.COMPENSATE_ALL_EFFECT, resultEffectPosition, time);
								
								var timerToAlertCompensateAll:Timer = new Timer(2000, 1)
								timerToAlertCompensateAll.addEventListener(TimerEvent.TIMER_COMPLETE, onAlertCompensateAll);
								timerToAlertCompensateAll.start();
							}
							else
							{
								PlayerInfoPhom(playingPlayerArray[j]).setStatus("lose");
							}
						}
					}
					
					if (PlayerInfoPhom(playingPlayerArray[j]).userName == playerList[i][DataFieldPhom.USER_NAME] && playingPlayerArray[j] != belowUserInfo)
					{
						var cardArray:Array = playerList[i][DataFieldPhom.PLAYER_CARDS] as Array;
						for (var k:int = 0; k < cardArray.length; k++) 
						{
							PlayerInfoPhom(playingPlayerArray[j]).addValueForOneUnleavedCard(cardArray[k]);
						}
						PlayerInfoPhom(playingPlayerArray[j]).openAllCard();
					}
				}
			}
			
			if (playerFullDeck && !playerCompensateAll)
			{
				SoundManager.getInstance().soundManagerPhom.playFullDeckPlayerSound(playerFullDeck.sex);
			}
			else if (playerFullDeck && playerCompensateAll)
			{
				SoundManager.getInstance().soundManagerPhom.playFullDeckAndCompensateAllPlayerSound(playerFullDeck.sex);
			}
			
			if (!playerFullDeck)
			{
				var timerToAlertWin:Timer = new Timer(mainData.resetMatchTime * 1000, 1)
				timerToAlertWin.addEventListener(TimerEvent.TIMER_COMPLETE, onAlertWin);
				timerToAlertWin.start();
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
			resultWindow.addEventListener(PlayerInfoPhom.EXIT, onExitButtonClick);
			resultWindow.setInfo(playerList);
			
			timerToShowResultWindow = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToShowResultWindow.addEventListener(TimerEvent.TIMER_COMPLETE, onShowResultWindow);
			timerToShowResultWindow.start();
			
			if (cardManager)
			{
				cardManager.hideTwinkle();
			}
		}
		
		private function onExitButtonClick(e:Event):void 
		{
			dispatchEvent(new Event(PlayerInfoPhom.EXIT));
			electroServerCommand.joinLobbyRoom();
		}
		
		private function onAlertWin(e:TimerEvent):void 
		{
			if (!stage)
				return;
				
			SoundManager.getInstance().soundManagerPhom.playOtherWinPlayerSound(playerWin.sex);
		}
		
		private function onAlertCompensateAll(e:TimerEvent):void 
		{
			if (!stage)
				return;
				
			SoundManager.getInstance().soundManagerPhom.playCompensateAllPlayerSound(playerCompensateAll.sex);
		}
		
		private function onShowResultWindow(e:TimerEvent):void 
		{
			if (!stage || !resultWindow)
				return;
			
			windowLayer.openWindow(resultWindow);
			
			isPlaying = false;
			
			if (timerToResetMatch)
			{
				timerToResetMatch.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.stop();
			}
			timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
		}
		
		private function onResetMatch(e:TimerEvent):void 
		{
			if (!stage)
				return;
				
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet))
			{
				SoundManager.getInstance().soundManagerPhom.playLoseAllPlayerSound(mainData.chooseChannelData.myInfo.sex);
				
				dispatchEvent(new Event(PlayerInfoPhom.EXIT));
				windowLayer.isNoCloseAll = true;
				electroServerCommand.joinLobbyRoom();
				
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					var kickOutWindow:AlertWindow = new AlertWindow();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				
				EffectLayer.getInstance().removeAllEffect();
				return;
			}
			
			SoundManager.getInstance().soundManagerPhom.playStartGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			
			resetMatch();
		}
		
		private function resetMatch():void // reset ván bài
		{
			isResetDone = true;
			if (timerToResetMatch)
			{
				timerToResetMatch.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.stop();
			}
			
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
			}
			removeCardManager();
			
			if (belowUserInfo.isReadyPlay && !belowUserInfo.isRoomMaster)
				waitToStart.visible = true;
				
			for (i = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					PlayerInfoPhom(allPlayerArray[i]).setStatus("");
					if (PlayerInfoPhom(allPlayerArray[i]).isReadyPlay)
						PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
				}
			}
		}
		
		private function listenHaveUserStealCard(data:Object):void // có user ăn bài
		{
			var stealedPlayer:PlayerInfoPhom; // Người bị ăn bài
			var stealPlayer:PlayerInfoPhom; // Người ăn bài
			
			var i:int;
			var effectPosition:Point;
			var time:Number = mainData.init.effect.time.moneyEffect;
			var addMoney:Number = data[DataFieldPhom.MONEY_AFTER_REBET];
			var lessMoney:Number = data[DataFieldPhom.MONEY_BEFORE_REBET];
				
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == data[DataFieldPhom.USER_NAME])
				{
					stealPlayer = playingPlayerArray[i];
					if (i == 0)
						stealedPlayer = playingPlayerArray[playingPlayerArray.length - 1];
					else
						stealedPlayer = playingPlayerArray[i - 1];
						
					if (!stealedPlayerObject[stealedPlayer.userName])
						stealedPlayerObject[stealedPlayer.userName] = 1;
					else
						stealedPlayerObject[stealedPlayer.userName] = 2;
						
					if (!stealPlayerObject[stealPlayer.userName])
						stealPlayerObject[stealPlayer.userName] = 1;
					else
						stealPlayerObject[stealPlayer.userName] += 1;
						
					if (stealPlayer.leavedCards.length == 3 && stealPlayerObject[stealPlayer.userName] != 3)
					{
						SoundManager.getInstance().soundManagerPhom.playStealBoltPlayerSound(stealPlayer.sex);
					}
					else
					{
						if (stealPlayerObject[stealPlayer.userName] == 1)
							SoundManager.getInstance().soundManagerPhom.playStealFirstCardPlayerSound(stealPlayer.sex);
						
						if (stealPlayerObject[stealPlayer.userName] == 2)
							SoundManager.getInstance().soundManagerPhom.playStealSecondCardPlayerSound(stealPlayer.sex);
					}
			
					cardManager.stealCard(stealPlayer, stealedPlayer, data[DataFieldPhom.CARD]);
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
			cardInfo[DataFieldPhom.NUM_CARD] = 7;
			cardInfo[DataFieldPhom.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataFieldPhom.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataFieldPhom.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [43, 44, 45, 46]];
			cardManager.addAllCard(rightUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataFieldPhom.NUM_CARD] = 7;
			cardInfo[DataFieldPhom.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataFieldPhom.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataFieldPhom.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(leftUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataFieldPhom.NUM_CARD] = 7;
			cardInfo[DataFieldPhom.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataFieldPhom.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataFieldPhom.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(aboveUserInfo, cardInfo);
			
			cardInfo = new Object();
			cardInfo[DataFieldPhom.NUM_CARD] = 7;
			cardInfo[DataFieldPhom.STOLE_CARDS] = [1, 2, 3];
			cardInfo[DataFieldPhom.DISCARDED_CARDS] = [4, 5, 6, 7];
			cardInfo[DataFieldPhom.LAYING_CARDS] = [[40, 41, 42], [44, 45, 46], [44, 45, 46]];
			cardManager.addAllCard(belowUserInfo, cardInfo);
			
			for (i = 0; i < belowUserInfo.cardInfoArray.length; i++) 
			{
				var card:CardPhom;
				card = new CardPhom(belowUserInfo.unLeaveCardSize);
				card.id = belowUserInfo.cardInfoArray[i];
				card.rotation = belowUserInfo.unLeaveCardRotation;
				
				var tempPoint:Point = new Point();
				var tempObject:Object = belowUserInfo.getUnUsePosition(CardPhom.UN_LEAVE_CARD);
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
				moneyEffectPosition = PlayerInfoPhom(playingPlayerArray[i]).localToGlobal(PlayerInfoPhom(playingPlayerArray[i]).moneyEffectPosition);
				resultEffectPosition = PlayerInfoPhom(playingPlayerArray[i]).localToGlobal(PlayerInfoPhom(playingPlayerArray[i]).resultEffectPosition);
				effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, 100, 10000);
				effectLayer.addEffect(EffectLayer.NO_DECK_EFFECT, resultEffectPosition, 100);
			}*/
		}
		
		private function showReadyButton():void
		{
			if (!readyButton)
				createButton("readyButton", "zReadyButton", "readyButtonPosition");
			readyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			playingLayer.addChild(readyButton);
			
			if (mainData.isAutoReady)
				mainCommand.electroServerCommand.readyPlay();
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
				if (readyButton.parent)
				{
					//belowUserInfo.stopCountTime();
					readyButton.parent.removeChild(readyButton);	
				}
			}
		}
		
		private function showStartButton():void
		{
			if (!startButton)
			{
				createButton("startButton", "zStartButton", "startButtonPosition");
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
				if (startButton.parent)
					startButton.parent.removeChild(startButton);	
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
			if (position != 0)
				invitePlayButtonArray[position - 1].visible = false;
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
		
		// add thông tin cá nhân (tên, ciao, cấp độ, avatar)
		public function addPersonalInfo(data:Object):void
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoPhom(allPlayerArray[i]).position == data[DataFieldPhom.POSITION])
					{
						PlayerInfoPhom(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataFieldPhom.READY])
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
					if (PlayerInfoPhom(allPlayerArray[i]).position == data[DataFieldPhom.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfoPhom(allPlayerArray[i]).isPlaying = true;
						i = allPlayerArray.length;
					}
				}
			}
		}
		
		public function removeOnePlayer(position:int, isGiveUp:Boolean = false):void // xóa một người chơi
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
									if (isGiveUp)
									{
										PlayerInfoPhom(allPlayerArray[i]).isGiveUp = true;
										var giveUpObject:Dictionary = new Dictionary();
										giveUpObject[DataFieldPhom.PLAYER] = allPlayerArray[i];
										giveUpObject[DataFieldPhom.POSITION] = position;
										
										var timerToRemoveGiveUpPlayer:Timer = new Timer(5000, 1);
										timerToRemoveGiveUpPlayer.addEventListener(TimerEvent.TIMER_COMPLETE, onRemoveGiveUpPlayer);
										timerToRemoveGiveUpPlayer.start();
										
										giveUpObject[DataFieldPhom.TIME] = timerToRemoveGiveUpPlayer;
										
										giveUpPlayerArray.push(giveUpObject);
									}
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
				
			if (!isGiveUp)
			{
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
				
				if (position != 0)
					invitePlayButtonArray[position - 1].visible = true;
			}
		}
		
		private function onRemoveGiveUpPlayer(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			for (var i:int = 0; i < giveUpPlayerArray.length; i++) 
			{
				var giveUpObject:Dictionary = giveUpPlayerArray[i];
				if (giveUpObject)
				{
					if (giveUpObject[DataFieldPhom.TIME] == e.currentTarget)
					{
						if (giveUpObject[DataFieldPhom.POSITION] != 0)
							invitePlayButtonArray[giveUpObject[DataFieldPhom.POSITION] - 1].visible = true;
						PlayerInfoPhom(giveUpObject[DataFieldPhom.PLAYER]).destroy();
						giveUpPlayerArray.splice(i, 1);
						break;
					}
				}
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
			var userProfileWindow:UserProfileWindow = new UserProfileWindow();
			userProfileWindow.displayName = PlayerInfoPhom(e.currentTarget).displayName;
			userProfileWindow.userName = PlayerInfoPhom(e.currentTarget).userName;
			userProfileWindow.gold = PlayerInfoPhom(e.currentTarget).moneyNumber;
			userProfileWindow.level = PlayerInfoPhom(e.currentTarget).levelNumber;
			userProfileWindow.avatarString = PlayerInfoPhom(e.currentTarget).avatarString;
			userProfileWindow.isFriend = false;
			for (var i:int = 0; i < mainData.lobbyRoomData.friendList.length; i++) 
			{
				if (UserDataULC(mainData.lobbyRoomData.friendList[i]).userName == userProfileWindow.userName)
				{
					userProfileWindow.isFriend = true;
					break;
				}
			}
			if (belowUserInfo.isRoomMaster && !isPlaying)
				userProfileWindow.isShowKickOut = true;
			else
				userProfileWindow.isShowKickOut = false;
			windowLayer.openWindow(userProfileWindow);
		}
		
		private function onKickOutClick(e:Event):void 
		{
			var confirmKickOutWindow:ConfirmWindow = new ConfirmWindow();
			confirmKickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmKickOut + " " + myContextMenu.data[DataFieldPhom.DISPLAY_NAME]);
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
			electroServerCommand.kickUser(myContextMenu.data[DataFieldPhom.USER_NAME]);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (myContextMenu)
			{
				if (myContextMenu.parent)
				{
					myContextMenu.removeEventListener(MyContextMenu.KICK_OUT_CLICK, onKickOutClick);
					myContextMenu.removeEventListener(MyContextMenu.ACCUSE_CLICK, onAccuseClick);
					myContextMenu.parent.removeChild(myContextMenu);
				}
			}
			ipBoard.visible = false;
			settingBoard.visible = false;
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
				if (cardManager.parent)
				{
					cardManager.removeEventListener(CardManagerPhom.GET_CARD, onClickCardManagerToGetCard);
					cardManager.parent.removeChild(cardManager);
				}
			}
		}
		
		private function createButton(buttonName:String,className:String,positionName:String):void
		{
			this[buttonName] = new MyButton();
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
					SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
				break;
				case startButton.content["child"]:
					resetMatch();
					if (timerToAutoStart)
					{
						timerToAutoStart.removeEventListener(TimerEvent.TIMER, onTimerToAutoStart);
						timerToAutoStart.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteToAutoStart);
						timerToAutoStart.stop();
					}
					autoStartTimeTxt.visible = false;
					electroServerCommand.startGame();
					startButton.content["child"].removeEventListener(MouseEvent.CLICK, onButtonClick);
					SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
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
						if (data[DataFieldPhom.USER_NAME] == PlayerInfoPhom(allPlayerArray[i]).userName)
							PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
					}
				}
			}
		}
		
		private function listenReadySuccess(data:Object):void 
		{
			if (belowUserInfo.isRoomMaster && isResetDone)
			{
				waitToPlay.visible = false;
				showStartButton();
			}
			
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (data[DataFieldPhom.USER_NAME] == PlayerInfoPhom(allPlayerArray[i]).userName)
					{
						PlayerInfoPhom(allPlayerArray[i]).isReadyPlay = true;
						if (allPlayerArray[i] == belowUserInfo)
						{
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
			ruleDescription = content["ruleDescription"];
			ruleDescription.selectable = false;
		}
		
		// Sắp xếp lại vị trí của người chơi để position 0 bắt đầu từ chính người chơi của mình
		private function reArrangePositions(userList:Array):void
		{
			jumpIndex = 0; // Dùng để sắp xếp lại vị trí của các người chơi
			var i:int;
			
			// tính lại vị trí của các người chơi, vì position của chính mình bao giờ cũng là 0
			for (i = 0; i < userList.length; i++) 
			{
				if (userList[i][DataFieldPhom.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					jumpIndex = userList[i][DataFieldPhom.POSITION];
					i = userList.length;
				}
			}
			if (jumpIndex != 0)
			{
				for (i = 0; i < userList.length; i++) 
				{
					userList[i][DataFieldPhom.POSITION] -= jumpIndex;
					if (userList[i][DataFieldPhom.POSITION] < 0)
						userList[i][DataFieldPhom.POSITION] += mainData.maxPlayer;
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
			//mainData = null;
			
			if(readyButton)
				readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			readyButton = null;
			mainCommand = null;
			
			if (timerToShowResultWindow)
			{
				timerToShowResultWindow.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowResultWindow);
				timerToShowResultWindow.stop();
				timerToShowResultWindow = null;
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
		
		public function get giveUpPlayerArray():Array 
		{
			if (!_giveUpPlayerArray)
				_giveUpPlayerArray = new Array();
			return _giveUpPlayerArray;
		}
		
		public function set giveUpPlayerArray(value:Array):void 
		{
			_giveUpPlayerArray = value;
		}
	}

}