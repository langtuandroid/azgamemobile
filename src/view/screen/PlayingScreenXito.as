package view.screen 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.gskinner.motion.GTween;
	import control.MainCommand;
	import event.Command;
	import event.DataFieldXito;
	import event.PlayingScreenEvent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import logic.MauBinhLogic;
	import sound.SoundManagerXito;
	import view.card.CardManagerXito;
	import view.ScrollView.ScrollViewYun;
	import view.userInfo.playerInfo.PlayerInfoXito;
	import view.window.AddFriendWindow;
	import view.window.AddMoneyWindow2;
	import view.window.ResultWindowXito;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import sound.SoundLibChung;
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	import view.button.MyButton;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfoXito;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.InvitePlayWindow;
	import view.window.OrderCardWindow;
	import view.window.UserProfileWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenXito extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		public static const BACK_TO_CHOOSE_CHANNEL_SCREEN:String = "backToChooseChannelScreen";
		
		private var belowUserInfo:PlayerInfoXito;
		private var rightUserInfo:PlayerInfoXito;
		private var leftUserInfo:PlayerInfoXito;
		private var aboveLeftUserInfo:PlayerInfoXito;
		private var aboveRightUserInfo:PlayerInfoXito;
		
		private var betInfo:Sprite;
		private var totalMoneyText:TextField;
		private var previousBetText:TextField;
		
		private var chatBox:ChatBox
		
		private var cardManager:CardManagerXito;
		private var allPlayerArray:Array; // Mảng chứa tất cả người chơi
		private var playingPlayerArray:Array; // Mảng chứa các người chơi đang trong ván bài
		
		private var countToKickTxt:TextField;
		private var ruleDescription:TextField;
		private var waitToPlay:Sprite;
		private var waitToStart:Sprite;
		private var versionTxt:TextField;
		private var ipBoard:Sprite;
		private var emoWindow:Sprite;
		
		private var mainData:MainData = MainData.getInstance();
		
		private var moneyIcon:Loader;
		private var readyButton:MyButton;
		private var startButton:MyButton;
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var timerToResetMatch:Timer;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var effectTime:Number = 1;
		private var jumpIndex:int = 0; // Bước nhẩy để tính khoảng cách chênh lệch giữa position người chơi của server và client
		private var effectLayer:EffectLayer = EffectLayer.getInstance();
		private var resultWindow:ResultWindowXito;
		private var isPlaying:Boolean;
		private var isResetDone:Boolean = true;
		private var nextTurn:String; // Biến để lưu userName của thằng đánh ở turn kế tiếp
		//private var isHaveUserReady:Boolean;
		private var timerToPing:Timer;
		private var pingTime:int = 55;
		private var myContextMenu:MyContextMenu;
		private var timerToShowMoney:Timer;
		private var isFirstJoinGame:Boolean = true;
		private var isEnableKickOut:Boolean = true;
		private var invitePlayButtonArray:Array;
		public var autoReady:MovieClip;
		
		private var settingBoard:MovieClip;
		private var settingButton:SimpleButton;
		private var snapShotButton:SimpleButton;
		private var showIpButton:SimpleButton;
		private var soundOnButton:SimpleButton;
		private var soundOffButton:SimpleButton;
		private var musicOnButton:SimpleButton;
		private var musicOffButton:SimpleButton;
		private var orderCardButton:SimpleButton;
		private var playingLayer:Sprite;
		private var chatboxLayer:Sprite;
		private var emoticonButton:SimpleButton;
		private var chatButton:SimpleButton;
		
		private var _giveUpPlayerArray:Array;
		private var isGameOver:Boolean = true;
		private var addMoneyObject:Object;
		
		public function PlayingScreenXito() 
		{
			mainData.isAutoReady = false;
			
			background = new zGameBackground();
			addChild(background);
			
			super();
			addContent("zPlayingScreenXito");
			createLayer();
			
			invitePlayButtonArray = new Array();
			invitePlayButtonArray.push(content["invitePlayButton1"]);
			invitePlayButtonArray.push(content["invitePlayButton2"]);
			invitePlayButtonArray.push(content["invitePlayButton3"]);
			invitePlayButtonArray.push(content["invitePlayButton4"]);
			for (var i:int = 0; i < 4; i++) 
			{
				invitePlayButtonArray[i].addEventListener(MouseEvent.CLICK, onInvitePlayButtonClick);
			}
			
			setupButton();
			setupTextField();
			hidePosition();
			createVariable();
			mainData.playingData.addEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			chatBox = new ChatBox();
			chatBox.maxCharsChat = 50;
			chatBox.visible = false;
			chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			chatBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onChatBoxBackButtonClick);
			//chatBox.x = Math.round(content["chatBoxPosition"].x);
			//chatBox.y = Math.round(content["chatBoxPosition"].y);
			waitToPlay = content["waitToPlay"];
			waitToStart = content["waitToStart"];
			waitToPlay.visible = waitToStart.visible = false;
			
			betInfo = content["betInfo"];
			totalMoneyText = betInfo["totalMoneyText"];
			previousBetText = betInfo["previousBetText"];
			totalMoneyText.text = '';
			previousBetText.text = '';
			betInfo.visible = false;
			
			versionTxt = content["versionTxt"];
			//if (!mainData.isTest)
				//versionTxt.visible = false;
			//if (mainData.chooseChannelData.myInfo.name == "dung296")
				//versionTxt.visible = true;
			versionTxt.text = mainData.version;
			
			chatboxLayer.addChild(chatBox);
			
			timerToPing = new Timer(pingTime * 1000);
			timerToPing.addEventListener(TimerEvent.TIMER, onPingToServer);
			timerToPing.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			autoReady = content["autoReady"];
			autoReady.stop();
			autoReady.buttonMode = true;
			autoReady.addEventListener(MouseEvent.CLICK, onAutoReadyClick);
			
			ipBoard = content["ipBoard"];
			chatboxLayer.addChild(ipBoard);
			ipBoard.addEventListener(MouseEvent.CLICK, onIpBoardClick);
			ipBoard.visible = false;
			
			createEmo();
			
			//addPlayer();
			
			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldXito.MESSAGE];
				chatBox.addChatSentence(textField.text, "Thông báo");
			}
		}
		
		private function createEmo():void 
		{
			emoWindow = content["emoWindow"];
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
				emo.scaleX = emo.scaleY = 0.7;
				emo.addEventListener(MouseEvent.MOUSE_UP, onEmoClick);
				emoArray.push(emo);
				emoScrollView.addRow(emo);
			}
			emoScrollView.updateScroll();
			emoScrollView.recheckTopAndBottom();
		}
		
		private function onEmoWindowCloseButtonClick(e:MouseEvent):void 
		{
			emoWindow.parent.removeChild(emoWindow);
		}
		
		private function onEmoClick(e:MouseEvent):void 
		{
			for (var i:int = 0; i < emoArray.length; i++) 
			{
				if (e.currentTarget == emoArray[i])
				{
					electroServerCommand.sendEmo(belowUserInfo.userName, i + 1);
					emoWindow.parent.removeChild(emoWindow);
					return;
				}
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
		
		private function onIpBoardClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
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
				TextField(ipBoard["displayNameTxt" + String(i + 1)]).text = '';
				TextField(ipBoard["ipTxt" + String(i + 1)]).text = '';
			}
			
			for (i = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					TextField(ipBoard["displayNameTxt" + String(ipIndex + 1)]).text = PlayerInfoXito(allPlayerArray[i]).displayName;
					var ipString:String = String(PlayerInfoXito(allPlayerArray[i]).ip);
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
		
		private var sharedObject:SharedObject;
		private var timerToHideIpBoard:Timer;
		private var timerToCheckTime:Timer;
		private var bestResult:String;
		private var destroyPlayerArray:Array;
		private var timerToKickRoomMaster:Timer;
		private var emoArray:Array;
		private var background:zGameBackground;
		private function setupButton():void 
		{
			emoticonButton = content["emoticonButton"];
			chatButton = content["chatButton"];
			settingBoard = content["settingBoard"];
			settingBoard.visible = false;
			chatboxLayer.addChild(settingBoard);
			settingButton = content["settingButton"];
			snapShotButton = settingBoard["snapShotButton"];
			showIpButton = settingBoard["showIpButton"];
			soundOnButton = settingBoard["soundOnButton"];
			soundOffButton = settingBoard["soundOffButton"];
			musicOnButton = settingBoard["musicOnButton"];
			musicOffButton = settingBoard["musicOffButton"];
			orderCardButton = content["orderCardButton"];
			orderCardButton.visible = false;
			if (mainData.chooseChannelData.myInfo.name == "zhaolong296")
				orderCardButton.visible = true;
			if (mainData.chooseChannelData.myInfo.name == "dung2963")
				orderCardButton.visible = true;
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
			emoticonButton.addEventListener(MouseEvent.CLICK, onEmoticonButtonClick);
			chatButton.addEventListener(MouseEvent.CLICK, onChatButtonClick);
		}
		
		private function onEmoticonButtonClick(e:MouseEvent):void 
		{
			playingLayer.addChild(emoWindow);
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
		
		private function onInvitePlayButtonClick(e:MouseEvent):void 
		{
			var invitePlayWindow:InvitePlayWindow = new InvitePlayWindow();
			windowLayer.openWindow(invitePlayWindow);
		}
		
		private function onMoneyIconComplete(e:Event):void 
		{
			
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			var isMe:Boolean;
			if (mainData.chooseChannelData.myInfo.uId == mainData.publicChatData.userName)
				isMe = true;
			chatBox.addChatSentence(mainData.publicChatData.chatContent, mainData.publicChatData.displayName, isMe);
			
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
		
		private function onUpdateEmoChat(e:Event):void 
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).userName == mainData.emoChatData[DataFieldXito.USER_NAME])
					{
						PlayerInfoXito(allPlayerArray[i]).showEmo(mainData.emoChatData[DataFieldXito.EMO_TYPE]);
						return;
					}
				}
			}
		}
		
		private function onHaveChat(e:Event):void 
		{
			electroServerCommand.sendPublicChat(mainData.chooseChannelData.myInfo.name, chatBox.currentText);
		}
		
		private function onFriendConfirmAddFriendInvite(e:Event):void 
		{
			var alertWindow:AlertWindow = new AlertWindow();
			
			if (mainData.responseAddFriendData[DataFieldXito.CONFIRM])
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataFieldXito.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.acceptAddFriend);
			}
			else
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataFieldXito.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.rejectAddFriend);
			}
			
			windowLayer.openWindow(alertWindow);
		}
		
		private function onConfirmFriendRequest(e:Event):void 
		{
			var invitedNameArray:Array = [mainData.confirmFriendRequestData[DataFieldXito.FRIEND_ID]];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldXito.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldXito.MESSAGE, mess);
			
			if (mainData.confirmFriendRequestData[DataFieldXito.CONFIRM])
				esObject.setBoolean(DataFieldXito.CONFIRM, true);
			else
				esObject.setBoolean(DataFieldXito.CONFIRM, false);
			
			electroServerCommand.sendPrivateMessage(invitedNameArray, Command.CONFIRM_ADD_FRIEND_INVITE, esObject);
			
			if (electroServerCommand.coreAPI.myData.friendList)
			{
				if (mainData.confirmFriendRequestData[DataFieldXito.CONFIRM])
				{
					electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldXito.FRIEND_ID]] = new Object();
					if (electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldXito.FRIEND_ID]])
					{
						var displayName:String = electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldXito.FRIEND_ID]][DataFieldXito.USER_INFO][DataFieldXito.DISPLAY_NAME];
						electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldXito.FRIEND_ID]][DataFieldXito.DISPLAY_NAME] = displayName;
					}
				}
			}
		}
		
		private function onInviteAddFriend(e:Event):void 
		{
			var inviteAddFriendWindow:ConfirmWindow = new ConfirmWindow();
			inviteAddFriendWindow.setNotice(mainData.inviteAddFriendData[DataFieldXito.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.addFriendSentence);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmInvite);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.REJECT, onRejectInvite);
			windowLayer.openWindow(inviteAddFriendWindow);
		}
		
		private function onConfirmInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldXito.USER_NAME], true, DataFieldXito.IN_GAME_ROOM);
		}
		
		private function onRejectInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldXito.USER_NAME], false, DataFieldXito.IN_GAME_ROOM);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			mainData.addEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			mainData.addEventListener(MainData.UPDATE_EMO_CHAT, onUpdateEmoChat);
			
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
			
			var addString:String;
			if (int(mainData.channelNum) == 1)
				addString = '1';
			else if (int(mainData.channelNum) == 2 || (int(mainData.channelNum) == 3))
				addString = '2';
			if (H >= 6 && H < 18)
				background.gotoAndStop("day" + addString);
			else
				background.gotoAndStop("night" + addString);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (timerToCheckTime)
			{
				timerToCheckTime.removeEventListener(TimerEvent.TIMER, onTimerToCheckTime);
				timerToCheckTime.stop();
			}
			
			if (timerToResetMatch)
			{
				timerToResetMatch.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.stop();
				timerToResetMatch = null;
			}
			
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
			mainData.addEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			var tempTween1:GTween = new GTween(this, effectTime, { alpha:1 } );
		}
		
		public function effectClose():void
		{	
			mainData.removeEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.removeEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.removeEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.removeEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			mainData.removeEventListener(MainData.UPDATE_EMO_CHAT, onUpdateEmoChat);
			mainData.removeEventListener(MainData.UPDATE_SYSTEM_NOTICE, onUpdateSystemNotice);
			
			dispatchEvent(new Event(CLOSE_COMPLETE));
		}
		
		private function onUpdateSystemNotice(e:Event):void 
		{
			for (var j:int = 0; j < mainData.systemNoticeList.length; j++) 
			{
				var textField:TextField = new TextField();
				textField.htmlText = mainData.systemNoticeList[j][DataFieldXito.MESSAGE];
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
			content["aboveLeftUserInfoPosition"].visible = false;
			content["aboveRightUserInfoPosition"].visible = false;
			content["cardManagerPosition"].visible = false;
			content["readyButtonPosition"].visible = false;
			content["startButtonPosition"].visible = false;
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
		
		private function listenHaveUserJoinRoom(data:Object):void 
		{
			SoundManager.getInstance().soundManagerXito.playOtherJoinGamePlayerSound(data[DataFieldXito.SEX]);
			
			chatBox.addChatSentence(data[DataFieldXito.DISPLAY_NAME] + " " + mainData.init.gameDescription.playingScreen.userJoinRoom, "Thông báo", false, true);
			var indexEmpty:int;
			indexEmpty = allPlayerArray.length;
			/*for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (!allPlayerArray[i])
				{
					data[DataFieldXito.POSITION] = i;
					i = allPlayerArray.length + 1;
				}
			}
			if (!data[DataFieldXito.POSITION])
				data[DataFieldXito.POSITION] = allPlayerArray.length;
			addOnePlayer(data[DataFieldXito.POSITION]);
			addPersonalInfo(data);*/
			
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
			data[DataFieldXito.POSITION] = indexEmpty;
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
				if (giveUpObject[DataFieldXito.POSITION] == indexEmpty)
				{
					PlayerInfoXito(giveUpObject[DataFieldXito.PLAYER]).destroy();
					giveUpPlayerArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			var i:int;
			var j:int;
			var outPlayer:PlayerInfoXito;
			
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (playingPlayerArray[i])
				{
					if (PlayerInfoXito(playingPlayerArray[i]).userName == data[DataFieldXito.USER_NAME])
					{
						//playingPlayerArray.splice(i, 1);
					}
				}
			}
			
			if (isPlaying)
			{
				SoundManager.getInstance().playSound(SoundLibChung.GIVE_UP_SOUND);
				
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataFieldXito.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoXito(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo", false, true);
							outPlayer = allPlayerArray[i];
							if (outPlayer.isPlaying)
								removeOnePlayer(i, true);
							else
								removeOnePlayer(i);
							for (j = 0; j < allPlayerArray.length; j++) 
							{
								if (allPlayerArray[j])
									countPlayer++;
							}
							if (countPlayer < 2)
								removeCardManager();
							if (addMoneyObject)
							{
								addMoneyObject[DataFieldXito.TOTAL] += (6);
								addMoneyObject[DataFieldXito.MONEY] += (((Number(mainData.playingData.gameRoomData.roomBet) * 6)) * (1 - mainData.fee));
							}
						}
					}
				}
			}
			else
			{
				var countPlayer:int = 0;
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataFieldXito.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoXito(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo", false, true);
							outPlayer = allPlayerArray[i];
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
					belowUserInfo.isReadyPlay = false;
					hideReadyButton();
				}
				var countReady:int = 0;
				for (i = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay)
							countReady++;
					}
				}
				if (countReady == 0)
				{
					if (timerToKickRoomMaster)
					{
						timerToKickRoomMaster.removeEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
						timerToKickRoomMaster.stop();
						countToKickTxt.visible = false;
					}
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
			
			SoundManager.getInstance().soundManagerXito.playOtherExitGamePlayerSound(outPlayer.sex);
		}
		
		private function listenJoinRoom(data:Object):void 
		{
			SoundManager.getInstance().soundManagerXito.playOtherJoinGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			mainData.isSelectOpenCard = false;
			var channelName:String = mainData.playingData.gameRoomData.channelName;
			var roomId:String = String(mainData.playingData.gameRoomData.roomId);
			var roomBet:String = PlayingLogic.format(data[DataFieldXito.ROOM_BET], 1);
			ruleDescription.text = mainData.gameName + " - " + channelName + " - Bàn " + roomId + " - Cược " + roomBet + " G";
			
			mainData.playingData.gameRoomData.roomBet = data[DataFieldXito.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataFieldXito.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataFieldXito.IS_SEND_CARD];
			
			var i:int;
			var userList:Array = data[DataFieldXito.USER_LIST] as Array;
			
			// sắp xếp lại các position
			reArrangePositions(userList);
			
			// add người chơi
			for (i = 0; i < userList.length; i++) 
			{
				addOnePlayer(userList[i][DataFieldXito.POSITION]);
			}
			
			// bổ sung thông tin cá nhân
			for (i = 0; i < userList.length; i++) 
			{
				addPersonalInfo(userList[i]);
			}
			
			if (data[DataFieldXito.GAME_STATE] == DataFieldXito.WAITING) // Nếu phòng chơi chưa bắt đầu
			{
				if (allPlayerArray.length > 1)
				{
					showReadyButton();
				}
			}
			else // Nếu phòng chơi đang chơi
			{
				betInfo.visible = true;
				if (data[DataFieldXito.GAME_STATE] == DataFieldXito.PRE_FLOP && data[DataFieldXito.CURRENT_POT] == 0) // Trường hợp vào đúng lúc có lệnh chia bài
				{
					for (i = 0; i < allPlayerArray.length; i++)
					{
						for (var j:int = 0; j < userList.length; j++) 
						{
							if (PlayerInfoXito(allPlayerArray[i]))
							{
								if (PlayerInfoXito(allPlayerArray[i]).userName == userList[j][DataFieldXito.USER_NAME])
								{
									if (!userList[j][DataFieldXito.IS_VIEWER])
										PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
								}
							}
						}
					}
				}
				else
				{
					currentTotalMoney = data[DataFieldXito.CURRENT_POT];
					hideStartButton();
					hideReadyButton();
					waitToPlay.visible = false;
					waitToStart.visible = false;
					addCardManager();
					// bổ sung thông tin cá nhân
					for (i = 0; i < userList.length; i++) 
					{
						// Không phải add cho mình vì minh vừa vào nên chắc chắc là không có bài
						if (!userList[i][DataFieldXito.IS_VIEWER]) 
						{
							addCardInfo(userList[i]);
						}
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
					isResetDone = false;
					cardManager.playerArray = playingPlayerArray;
				}
			}
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataFieldXito.ROOM_MASTER])
					{
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = true;
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = false;
						i = allPlayerArray.length + 1;
					}
				}
			}
			
			chatboxLayer.addChild(chatBox);
			
			checkConflictIp();
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
							if (PlayerInfoXito(allPlayerArray[i]).ip == PlayerInfoXito(allPlayerArray[j]).ip)
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
		
		private function onHideIpBoard(e:TimerEvent):void 
		{
			ipBoard.visible = false;
		}
		
		private function listenDealCard(data:Object):void 
		{
			mainData.isRecentlyDealCard = true;
			betInfo.visible = true;
			if (timerToKickRoomMaster)
			{
				timerToKickRoomMaster.removeEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
				timerToKickRoomMaster.stop();
				countToKickTxt.visible = false;
			}
			
			addMoneyObject = new Object();
			addMoneyObject[DataFieldXito.TOTAL] = 0;
			addMoneyObject[DataFieldXito.MONEY] = 0;
			
			isGameOver = false;
			giveUpPlayerArray = new Array();
			isEnableKickOut = false;
			hideStartButton();
			hideReadyButton();
			waitToPlay.visible = false;
			waitToStart.visible = false;
			var i:int;
			isPlaying = true;
			isResetDone = false;
			
			destroyPlayerArray = new Array();
			playingPlayerArray = new Array();
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					PlayerInfoXito(allPlayerArray[i]).isFold = false;
					PlayerInfoXito(allPlayerArray[i]).numRaise = 0;
					PlayerInfoXito(allPlayerArray[i]).maxNumRaise = 1;
					if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay || PlayerInfoXito(allPlayerArray[i]).isRoomMaster)
						playingPlayerArray.push(allPlayerArray[i]);
				}
			}
				
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoXito(playingPlayerArray[i]).isPlaying = true;
				PlayerInfoXito(playingPlayerArray[i]).isReadyPlay = false;
				PlayerInfoXito(playingPlayerArray[i]).playingPlayerArray = playingPlayerArray;
				PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE, Number(mainData.playingData.gameRoomData.roomBet), true);
				
				PlayerInfoXito(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.selectOpenCardTime));	
				if (playingPlayerArray[i] == belowUserInfo)
				{
					var timerToEnableSelectOpenCard:Timer = new Timer(1000, 1);
					timerToEnableSelectOpenCard.addEventListener(TimerEvent.TIMER_COMPLETE, onEnableSelectOpenCard)
					timerToEnableSelectOpenCard.start();
				}
					
				if (playingPlayerArray[i] == belowUserInfo) // Gán cho mình dữ liệu các lá bài của server gửi về							
					PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = data[DataFieldXito.PLAYER_CARDS] as Array;
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
					PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = [0, 0];
			}
			addCardManager();
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
			if (data[DataFieldXito.IS_CURRENT_WINNER])
			{
				nextTurn = belowUserInfo.userName;
				belowUserInfo.isCurrentWinner = true;
			}
			else
			{
				belowUserInfo.isCurrentWinner = false;
			}
			
			currentTotalMoney = playingPlayerArray.length * Number(mainData.playingData.gameRoomData.roomBet);
			mainData.startMoney = playingPlayerArray.length * Number(mainData.playingData.gameRoomData.roomBet);
		}
		
		private function onEnableSelectOpenCard(e:TimerEvent):void 
		{
			belowUserInfo.setMyTurn(PlayerInfoXito.SELECT_OPEN_CARD);
			mainData.isRecentlyDealCard = false;
		}
		
		private function listenHaveUserCheck(data:Object):void // có user nhường tố
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.CHECK);
				}
				else
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction();
				}
			}
		}
		
		private function listenHaveUserRaise(data:Object):void // có user tố
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					switch (data[DataFieldXito.RAISE_TYPE]) 
					{
						case 1:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE,data[DataFieldXito.MONEY]);
						break;
						case 2:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_DOUBLE,data[DataFieldXito.MONEY]);
						break;
						case 3:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_TRIPLE,data[DataFieldXito.MONEY]);
						break;
						case 4:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.RAISE_FOURPLE,data[DataFieldXito.MONEY]);
						break;
						case 5:
							PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.ALL_IN,data[DataFieldXito.MONEY]);
						break;
						default:
					}
					PlayerInfoXito(playingPlayerArray[i]).numRaise = data[DataFieldXito.NUM_RAISE];
					PlayerInfoXito(playingPlayerArray[i]).maxNumRaise = data[DataFieldXito.MAX_NUM_RAISE];
					trace("ccccccccccccccccccc",Number(data[DataFieldXito.MONEY]),PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound);
					if (Number(data[DataFieldXito.MONEY]) + PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound > mainData.maxMoneyOfRound)
					{
						trace("ddddddddđ");
						betMoneyOfPreviousUser = Number(data[DataFieldXito.MONEY]) + PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound;
					}
					PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound += Number(data[DataFieldXito.MONEY]);
					currentTotalMoney += Number(data[DataFieldXito.MONEY]);
					mainData.actionStatus = 2; // trạng thái đã có ng tố
				}
				else
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction();
				}
				if (PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound > mainData.maxMoneyOfRound)
					mainData.maxMoneyOfRound = PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound;
			}
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
			totalMoneyText.text = String(PlayingLogic.format(currentTotalMoney, 1));
		}
		
		private function listenHaveUserCall(data:Object):void // có user theo
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.CALL);
					var callMoney:Number = mainData.maxMoneyOfRound - PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound;
					if (mainData.moneyOfCurrentUser >= callMoney)
						currentTotalMoney += callMoney;
					else // trường hợp user đó hết tiền thì số tiền gà hiện tại phải cộng thêm số tiền user đó còn lại chứ không phải số tiền theo chuẩn.
						currentTotalMoney += mainData.moneyOfCurrentUser;
					PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound = mainData.maxMoneyOfRound;
				}
				else
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction();
				}
			}
		}
		
		private function listenHaveUserFold(data:Object):void // có user ụp bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction(PlayerInfoXito.FOLD);
					if (playingPlayerArray[i] != belowUserInfo)
					{
						for (var j:int = 0; j < PlayerInfoXito(playingPlayerArray[i]).unLeaveCards.length; j++) 
						{
							PlayerInfoXito(playingPlayerArray[i]).closeAllCard();
						}
					}
				}
				else
				{
					PlayerInfoXito(playingPlayerArray[i]).setAction();
				}
			}
		}
		
		private var dealMoreCardObject:Object;
		private function listenDealMoreCard(data:Object):void // chia thêm bài
		{
			if (isGameOver)
				return;
			mainData.isRecentlyDealCard = true;	
			dealMoreCardObject = data;
			var timerToDealMoreCard:Timer = new Timer(500, 1);
			timerToDealMoreCard.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerToDealMoreCard);
			timerToDealMoreCard.start();
			betMoneyOfPreviousUser = 0;
			mainData.actionStatus = 1;
			
			var i:int;
			cardManager.addUpChip();
			mainData.maxMoneyOfRound = 0;
			totalMoneyText.text = String(PlayingLogic.format(currentTotalMoney, 1));
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoXito(playingPlayerArray[i]).setAction();
				PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound = 0;
				PlayerInfoXito(playingPlayerArray[i]).addUpChip(cardManager.chipPosition);
				PlayerInfoXito(playingPlayerArray[i]).numRaise = 0;
				PlayerInfoXito(playingPlayerArray[i]).maxNumRaise = 1;
			}
		}
		
		private function onTimerToDealMoreCard(e:TimerEvent):void 
		{
			if (isGameOver)
				return;
			var i:int;
			var tempArray:Array = new Array();
			if (dealMoreCardObject[DataFieldXito.USER_LIST].length < 2) // Lượt chia bài cuối
			{
				for (i = 0; i < playingPlayerArray.length; i++) 
				{
					if (playingPlayerArray[i] == belowUserInfo && dealMoreCardObject[DataFieldXito.USER_LIST][0])
					{
						//cardManager.divideOneCard(playingPlayerArray[i], dealMoreCardObject[DataFieldXito.USER_LIST][i][DataFieldXito.CARD_ID]);							
						PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = [dealMoreCardObject[DataFieldXito.USER_LIST][0][DataFieldXito.CARD_ID]];
						tempArray.push(playingPlayerArray[i]);
					}
					else if (!PlayerInfoXito(playingPlayerArray[i]).isFold)
					{
						//cardManager.divideOneCard(playingPlayerArray[i], 0);
						PlayerInfoXito(playingPlayerArray[i]).cardInfoArray = [0];
						tempArray.push(playingPlayerArray[i]);
					}
				}
			}
			else
			{
				for (i = 0; i < dealMoreCardObject[DataFieldXito.USER_LIST].length; i++) 
				{
					for (var j:int = 0; j < playingPlayerArray.length; j++) 
					{
						if (dealMoreCardObject[DataFieldXito.USER_LIST][i][DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
						{
							//cardManager.divideOneCard(playingPlayerArray[j], dealMoreCardObject[DataFieldXito.USER_LIST][i][DataFieldXito.CARD_ID]);
							PlayerInfoXito(playingPlayerArray[j]).cardInfoArray = [dealMoreCardObject[DataFieldXito.USER_LIST][i][DataFieldXito.CARD_ID]];
							tempArray.push(playingPlayerArray[j]);
						}
					}
				}
			}
			cardManager.playerArray = tempArray;
			cardManager.divideMoreCard();
		}
		
		public function get betMoneyOfPreviousUser():Number 
		{
			return _betMoneyOfPreviousUser;
		}
		
		public function set betMoneyOfPreviousUser(value:Number):void 
		{
			_betMoneyOfPreviousUser = value;
			previousBetText.text = String(PlayingLogic.format(value, 1));
			mainData.betMoneyOfPreviousUser = value;
		}
		
		private var _betMoneyOfPreviousUser:Number = 0;
		private var gameOverObject:Object;
		private var soundManagerXito:SoundManagerXito = SoundManager.getInstance().soundManagerXito;
		
		private function listenUpdateCurrentTurn(data:Object):void // cập nhật turn hiện tại
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (data[DataFieldXito.CURRENT_TURN] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					//PlayerInfoXito(playingPlayerArray[i]).countTime(Number(mainData.init.playTime.selectActionTime));
					mainData.moneyOfCurrentUser = PlayerInfoXito(playingPlayerArray[i]).moneyNumber;
					if (playingPlayerArray[i] == belowUserInfo)
						belowUserInfo.setMyTurn(PlayerInfoXito.SELECT_ACTION);
					else
						PlayerInfoXito(playingPlayerArray[i]).isMyTurn = true;
					mainData.isRecentlyDealCard = false;
					//betMoneyOfPreviousUser = mainData.maxMoneyOfRound - PlayerInfoXito(playingPlayerArray[i]).currentMoneyOfRound + mainData.maxMoneyOfRound;
					return;
				}
			}
		}
		
		private function listenHaveUserOpenCard(data:Object):void // có user lật bài
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[i]).userName)
				{
					PlayerInfoXito(playingPlayerArray[i]).addValueForOneUnleavedCard(data[DataFieldXito.OPEN_CARDS][0]);
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
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataFieldXito.ROOM_MASTER])
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = false;
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = true;
					}
					else
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = true;
						PlayerInfoXito(allPlayerArray[i]).isRoomMaster = false;
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
							if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay && allPlayerArray[i] != belowUserInfo)
							{
								belowUserInfo.isReadyPlay = false;
								hideReadyButton();
								showStartButton();
								
								countTimeToKickRoomMaster();
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
					var countReady:int = 0;
					for (i = 0; i < allPlayerArray.length; i++)
					{
						if (allPlayerArray[i])
						{
							if (PlayerInfoXito(allPlayerArray[i]).isRoomMaster)
								PlayerInfoXito(allPlayerArray[i]).isReadyPlay = false;
							else if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay)
								countReady++;
						}
					}
					if (countReady > 0)
						countTimeToKickRoomMaster();
				}
			}
		}
		
		private function countTimeToKickRoomMaster():void
		{
			if (timerToKickRoomMaster)
			{
				timerToKickRoomMaster.removeEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
				timerToKickRoomMaster.stop();
			}
			countToKickTxt.text = String(mainData.kickTime);
			countToKickTxt.visible = true;
			timerToKickRoomMaster = new Timer(1000, mainData.kickTime);
			timerToKickRoomMaster.addEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
			timerToKickRoomMaster.start();
		}
		
		private function onTimerToKickRoomMaster(e:TimerEvent):void 
		{
			if (!stage || isPlaying)
			{
				if (timerToKickRoomMaster)
				{
					timerToKickRoomMaster.removeEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
					timerToKickRoomMaster.stop();
				}
				return;
			}
			var timeNumber:int = int(countToKickTxt.text);
			timeNumber--;
			countToKickTxt.text = String(timeNumber);
			if (timeNumber == 0)
			{
				countToKickTxt.visible = false;
				if (belowUserInfo.isRoomMaster)
				{
					dispatchEvent(new Event(PlayerInfoXito.EXIT));
					windowLayer.isNoCloseAll = true;
					electroServerCommand.joinLobbyRoom();
					
					var kickOutWindow:AlertWindow = new AlertWindow();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice("Bạn bị mất quyền Chủ bàn do không bắt đầu ván chơi!");
					windowLayer.openWindow(kickOutWindow);
				}
			}
		}
		
		private function listenRoomMasterKick(data:Object):void // Bị chủ phòng kick
		{
			if (data[DataFieldXito.USER_NAME] == belowUserInfo.userName) // Nếu người bị kick là mình
			{
				dispatchEvent(new Event(PlayerInfoXito.EXIT));
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
					if (PlayerInfoXito(allPlayerArray[i]).userName == data[DataFieldXito.USER_NAME])
						PlayerInfoXito(allPlayerArray[i]).updateMoney(data[DataFieldXito.MONEY]);
				}
			}
		}
		
		private function updateMoney():void 
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					PlayerInfoXito(allPlayerArray[i]).updateMoney(PlayerInfoXito(allPlayerArray[i]).moneyNumber);
				}
			}
			
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet) * mainData.minBetRate)
			{
				dispatchEvent(new Event(PlayerInfoXito.EXIT));
				electroServerCommand.joinLobbyRoom();
				
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					windowLayer.isNoCloseAll = true;
					var kickOutWindow:AddMoneyWindow2 = new AddMoneyWindow2();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				
				EffectLayer.getInstance().removeAllEffect();
			}
		}
		
		private function listenGameOver(data:Object):void // ván bài kết thúc
		{
			isGameOver = true;
			totalMoneyText.text = String(PlayingLogic.format(currentTotalMoney, 1));
			var playerList:Array = data[DataFieldXito.PLAYER_LIST] as Array;
			var quiterList:Array = data[DataFieldXito.QUITERS] as Array;
			gameOverObject = data;
			var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			var time:Number;
			betInfo.visible = false;
			totalMoneyText.text = '';
			previousBetText.text = '';
			cardManager.addUpChip();
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					PlayerInfoXito(playingPlayerArray[j]).isPlaying = false;
					PlayerInfoXito(playingPlayerArray[j]).isFold = false;
					if (playerList[i][DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
					{
						PlayerInfoXito(playingPlayerArray[j]).setAction();
						PlayerInfoXito(playingPlayerArray[j]).stopCountTime();
						PlayerInfoXito(playingPlayerArray[j]).addUpChip(cardManager.chipPosition);
					}
				}
			}
			
			for (i = 0; i < quiterList.length; i++) 
			{
				for (j = 0; j < playingPlayerArray.length; j++)
				{
					if (quiterList[i][DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
						quiterList[i][DataFieldXito.IS_FOLD] = true;
				}
			}
				
			belowUserInfo.setMyTurn(PlayerInfoXito.DO_NOTHING);
			
			var addTime:Number = 0;
			if (checkEarlyGameOver())
				addTime = 1.5;
			
			timerToResetMatch = new Timer((addTime + mainData.resetMatchTime) * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
			
			var timerToShowMoneyEffect:Timer = new Timer(1000 + addTime * 1000, 1);
			timerToShowMoneyEffect.addEventListener(TimerEvent.TIMER_COMPLETE, onShowMoneyEffect);
			timerToShowMoneyEffect.start();
			
			var timerToPlayWinSound:Timer = new Timer(3000 + addTime * 1000, 1);
			timerToPlayWinSound.addEventListener(TimerEvent.TIMER_COMPLETE, onPlayWinSound);
			timerToPlayWinSound.start();
		}
		
		private function checkEarlyGameOver():Boolean 
		{
			var isEarlyGameOver:Boolean;
			var playerList:Array = gameOverObject[DataFieldXito.PLAYER_LIST] as Array;
			var quiterList:Array = gameOverObject[DataFieldXito.QUITERS] as Array;
			playerList = playerList.concat(quiterList);
			var tempArray:Array = new Array();
			for (var i:int = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (PlayerInfoXito(playingPlayerArray[j]).userName == playerList[i][DataFieldXito.USER_NAME])
					{
						var isFold:Boolean = playingPlayerArray[j].isFold;
						if (playerList[i][DataFieldXito.HAND_CARDS] && !isFold)
						{
							var tempNumber:int = PlayerInfoXito(playingPlayerArray[j]).unLeaveCards.length;
							if (tempNumber < 5)
							{
								isEarlyGameOver = true;
								PlayerInfoXito(playingPlayerArray[j]).cardInfoArray = new Array();
								for (var k:int = 0; k < 5 - tempNumber; k++) 
								{
									PlayerInfoXito(playingPlayerArray[j]).cardInfoArray.push(0);
								}
								tempArray.push(playingPlayerArray[j]);
							}
						}
					}
				}
			}
			
			cardManager.playerArray = tempArray;
			cardManager.divideMoreCard();
			
			return isEarlyGameOver;
		}
		
		private function onPlayWinSound(e:TimerEvent):void 
		{
			if (!stage)
				return;
			var i:int;
			var playerList:Array = gameOverObject[DataFieldXito.PLAYER_LIST] as Array;
			var quiterList:Array = gameOverObject[DataFieldXito.QUITERS] as Array;
			playerList = playerList.concat(quiterList);
			for (i = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (playerList[i][DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
					{
						if (playerList[i][DataFieldXito.MONEY])
						{
							if (playerList[i][DataFieldXito.MONEY] > 0)
								soundManagerXito.playWinPlayerSound(PlayerInfoXito(playingPlayerArray[j]).sex);
						}
						else
						{
							if (playerList.length < 2)
							{
								soundManagerXito.playWinPlayerSound(PlayerInfoXito(playingPlayerArray[j]).sex);
							}
						}
					}
				}
			}
		}
		
		private function onShowMoneyEffect(e:TimerEvent):void 
		{
			if (!stage)
				return;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
					PlayerInfoXito(allPlayerArray[i]).setAction();
			}
			
			var playerList:Array = gameOverObject[DataFieldXito.PLAYER_LIST] as Array;
			var quiterList:Array = gameOverObject[DataFieldXito.QUITERS] as Array;
			playerList = playerList.concat(quiterList);
			var moneyEffectPosition:Point;
			var resultEffectPosition:Point;
			var time:Number;
			cardManager.removeChipContainer();
			for (i = 0; i < playerList.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++)
				{
					if (playerList[i][DataFieldXito.USER_NAME] == PlayerInfoXito(playingPlayerArray[j]).userName)
					{
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfoXito(playingPlayerArray[j]).localToGlobal(PlayerInfoXito(playingPlayerArray[j]).moneyEffectPosition);
						resultEffectPosition = PlayerInfoXito(playingPlayerArray[j]).localToGlobal(PlayerInfoXito(playingPlayerArray[j]).resultEffectPosition);
						if(int(playerList[i][DataFieldXito.GROUP_RANK]) == 1)
							playerList[i][DataFieldXito.GROUP_RANK] = MauBinhLogic.getInstance().checkMauThau(playerList[i][DataFieldXito.HAND_CARDS]);
						if (playerList[i][DataFieldXito.GROUP_RANK])
						{
							if (playingPlayerArray[j] == belowUserInfo)
								effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, resultEffectPosition, time, 0, playerList[i][DataFieldXito.GROUP_RANK]);
							else 
								effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, resultEffectPosition, time,1, playerList[i][DataFieldXito.GROUP_RANK]);
						}
						
						// add effect cộng trừ tiền
						time = mainData.init.effect.time.moneyEffect;
						moneyEffectPosition = PlayerInfoXito(playingPlayerArray[j]).localToGlobal(PlayerInfoXito(playingPlayerArray[j]).moneyEffectPosition);
						if (playerList[i][DataFieldXito.MONEY])
						{
							effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, playerList[i][DataFieldXito.MONEY]);
							PlayerInfoXito(playingPlayerArray[j]).receiveChip(cardManager.chipPosition, playerList[i][DataFieldXito.MONEY]);
						}
						else
						{
							if (playerList.length < 2)
							{
								PlayerInfoXito(playingPlayerArray[j]).receiveChip(cardManager.chipPosition, mainData.currentTotalMoney);
								effectLayer.addEffect(EffectLayer.MONEY_EFFECT, moneyEffectPosition, time, mainData.currentTotalMoney);
							}
						}
						
						if(int(playerList[i][DataFieldXito.GROUP_RANK]) == 1)
							playerList[i][DataFieldXito.GROUP_RANK] = MauBinhLogic.getInstance().checkMauThau(playerList[i][DataFieldXito.HAND_CARDS]);
						if (playerList[i][DataFieldXito.GROUP_RANK])
						{
							if (playerList[i][DataFieldXito.MONEY])
							{
								if (playerList[i][DataFieldXito.MONEY] > 0)
								{
									switch (int(playerList[i][DataFieldXito.GROUP_RANK])) 
									{
										case 7:
											SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
										break;
										case 8:
											SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
										break;
										case 9:
											SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
										break;
										case 10:
											SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
										break;
										default:
									}
									soundManagerXito.playNormalPlayerSound(PlayerInfoXito(playingPlayerArray[j]).sex, playerList[i][DataFieldXito.GROUP_RANK]);
								}
							}
						}
					}
					
					if (PlayerInfoXito(playingPlayerArray[j]).userName == playerList[i][DataFieldXito.USER_NAME]/* && playingPlayerArray[j] != belowUserInfo*/)
					{
						if (playerList[i][DataFieldXito.HAND_CARDS])
						{
							var cardArray:Array = playerList[i][DataFieldXito.HAND_CARDS] as Array;
							for (var k:int = 0; k < cardArray.length; k++) 
							{
								PlayerInfoXito(playingPlayerArray[j]).addValueForOneUnleavedCard(cardArray[k]);
							}
							PlayerInfoXito(playingPlayerArray[j]).openAllCard();
						}
					}
				}
			}
		}
		
		private function onResetMatch(e:TimerEvent):void 
		{
			if (!stage)
				return;
			mainData.isSelectOpenCard = false;
			updateMoney();
			
			var playerList:Array = gameOverObject[DataFieldXito.PLAYER_LIST] as Array;
			var quiterList:Array = gameOverObject[DataFieldXito.QUITERS] as Array;
			
			playerList = playerList.concat(quiterList);
			resultWindow = new ResultWindowXito();
			resultWindow.setInfo(playerList);
			windowLayer.openWindow(resultWindow);
			
			isEnableKickOut = true;
			isPlaying = false;
			
			var timerToHideAllStatus:Timer = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToHideAllStatus.addEventListener(TimerEvent.TIMER_COMPLETE, onHideAllStatus);
			timerToHideAllStatus.start();
			
			for (var i:int = 0; i < playerList.length; i++) 
			{
				if (belowUserInfo.userName == playerList[i][DataFieldXito.USER_NAME])
				{
					if (playerList[i][DataFieldXito.MONEY] > 0)
						SoundManager.getInstance().playSound(SoundLibChung.WIN_SOUND);
					else
						SoundManager.getInstance().playSound(SoundLibChung.LOSE_SOUND);
				}
			}
		}
		
		private function onHideAllStatus(e:TimerEvent):void 
		{
			if (!stage)
				return;
				
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet) * mainData.minBetRate)
			{
				dispatchEvent(new Event(PlayerInfoXito.EXIT));
				electroServerCommand.joinLobbyRoom();
				
				if (mainData.chooseChannelData.myInfo.money >= mainData.minMoney)
				{
					windowLayer.isNoCloseAll = true;
					var kickOutWindow:AddMoneyWindow2 = new AddMoneyWindow2();
					kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onKickOutWindowCloseComplete);
					kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutMoney);
					windowLayer.openWindow(kickOutWindow);
				}
				
				EffectLayer.getInstance().removeAllEffect();
				return;
			}
			
			resetMatch();
		}
		
		private function onExitButtonClick(e:Event):void 
		{
			dispatchEvent(new Event(PlayerInfoXito.EXIT));
			electroServerCommand.joinLobbyRoom();
		}
		
		private function resetMatch():void // reset ván bài
		{
			totalMoneyText.text = '';
			previousBetText.text = '';
			SoundManager.getInstance().soundManagerXito.playStartGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			isResetDone = true;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					PlayerInfoXito(allPlayerArray[i]).isFirstClick = true;
					PlayerInfoXito(allPlayerArray[i]).removeAllCards();
					PlayerInfoXito(allPlayerArray[i]).setAction();
				}
			}
			if (destroyPlayerArray)
			{
				for (i = 0; i < destroyPlayerArray.length; i++)
				{
					PlayerInfoXito(destroyPlayerArray[i]).destroy();
				}
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
					
					for (j = 0; j < allPlayerArray.length; j++) 
					{
						if (allPlayerArray[j])
						{
							if (PlayerInfoXito(allPlayerArray[j]).isReadyPlay)
							{
								j = allPlayerArray.length + 1;
								countTimeToKickRoomMaster();
							}
						}
					}
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
								
								countTimeToKickRoomMaster();
							}
						}
					}
				}
			}
			removeCardManager();
			destroyPlayerArray = new Array();
			playingPlayerArray = new Array();
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
					readyButton.parent.removeChild(readyButton);	
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
		}
		
		private function hideStartButton():void
		{
			if (startButton)
			{
				if (startButton.parent)
					startButton.parent.removeChild(startButton);	
			}
		}
		
		// add một người chơi, đầu vào là vị trí tương ứng từ 1-4
		public function addOnePlayer(position:int):void 
		{
			switch (position) 
			{
				case 0:
					addPlayerByType(PlayerInfoXito.BELOW_USER, position, true);
					// Lắng nghe đến lượt mình bốc bài thì thông báo cho cardManager
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
			if (position != 0)
				invitePlayButtonArray[position - 1].visible = false;
		}
		
		// add thông tin cá nhân (tên, money, cấp độ, avatar)
		public function addPersonalInfo(data:Object):void
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoXito(allPlayerArray[i]).position == data[DataFieldXito.POSITION])
					{
						PlayerInfoXito(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataFieldXito.READY])
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
					if (PlayerInfoXito(allPlayerArray[i]).position == data[DataFieldXito.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfoXito(allPlayerArray[i]).isPlaying = true;
						i = allPlayerArray.length;
					}
				}
			}
		}
		
		public function removeOnePlayer(position:int, isGiveUp:Boolean = false):void // xóa một người chơi
		{
			if (!destroyPlayerArray)
				destroyPlayerArray = new Array();
			var isPlayingUser:Boolean;
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
						else
						{
							for (j = 0; j < playingPlayerArray.length; j++) 
							{
								if (PlayerInfoXito(allPlayerArray[i]) == PlayerInfoXito(playingPlayerArray[j]))
								{
									PlayerInfoXito(allPlayerArray[i]).hideAllInfo();
									isPlayingUser = true;
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
						PlayerInfoXito(this[PlayerInfoXito.BELOW_USER]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoXito(this[PlayerInfoXito.BELOW_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoXito.BELOW_USER]);
					break;
					case 1:
						PlayerInfoXito(this[PlayerInfoXito.RIGHT_USER]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoXito(this[PlayerInfoXito.RIGHT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoXito.RIGHT_USER]);
					break;
					case 2:
						PlayerInfoXito(this[PlayerInfoXito.ABOVE_RIGHT_USER]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoXito(this[PlayerInfoXito.ABOVE_RIGHT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoXito.ABOVE_RIGHT_USER]);
					break;
					case 3:
						PlayerInfoXito(this[PlayerInfoXito.ABOVE_LEFT_USER]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoXito(this[PlayerInfoXito.ABOVE_LEFT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoXito.ABOVE_LEFT_USER]);
					break;
					case 4:
						PlayerInfoXito(this[PlayerInfoXito.LEFT_USER]).removeEventListener(PlayerInfoXito.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoXito(this[PlayerInfoXito.LEFT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoXito.LEFT_USER]);
					break;
				}
				
				if (position != 0)
					invitePlayButtonArray[position - 1].visible = true;
			}
			else if (isPlaying)
			{
				var giveUpPlayer:PlayerInfoXito;
				switch (position) 
				{
					case 1:
						giveUpPlayer = rightUserInfo;
					break;
					case 2:
						giveUpPlayer = aboveRightUserInfo;
					break;
					case 3:
						giveUpPlayer = aboveLeftUserInfo;
					break;
					case 4:
						giveUpPlayer = leftUserInfo;
					break;
				}
				
				giveUpPlayer.isGiveUp = true;
				var giveUpObject:Dictionary = new Dictionary();
				giveUpObject[DataFieldXito.PLAYER] = giveUpPlayer
				giveUpObject[DataFieldXito.POSITION] = position;
				
				var timerToRemoveGiveUpPlayer:Timer = new Timer(5000, 1);
				timerToRemoveGiveUpPlayer.addEventListener(TimerEvent.TIMER_COMPLETE, onRemoveGiveUpPlayer);
				timerToRemoveGiveUpPlayer.start();
				
				giveUpObject[DataFieldXito.TIME] = timerToRemoveGiveUpPlayer;
				
				giveUpPlayerArray.push(giveUpObject);
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
					if (giveUpObject[DataFieldXito.TIME] == e.currentTarget)
					{
						if (giveUpObject[DataFieldXito.POSITION] != 0)
							invitePlayButtonArray[giveUpObject[DataFieldXito.POSITION] - 1].visible = true;
						PlayerInfoXito(giveUpObject[DataFieldXito.PLAYER]).destroy();
						giveUpPlayerArray.splice(i, 1);
						break;
					}
				}
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
				
			this[playerType].x = Math.round(content[playerType + "Position"].x);
			this[playerType].y = Math.round(content[playerType + "Position"].y);
			playingLayer.addChild(this[playerType]);
			allPlayerArray[position] = this[playerType];
		}
		
		private function onShowContextMenu(e:Event):void 
		{
			var userData:UserDataULC = new UserDataULC();
			userData.levelName = String(PlayerInfoXito(e.currentTarget).levelNumber);
			userData.money = String(PlayerInfoXito(e.currentTarget).moneyNumber);
			userData.displayName = PlayerInfoXito(e.currentTarget).displayName;
			userData.avatar = PlayerInfoXito(e.currentTarget).avatarString;
			userData.userName = PlayerInfoXito(e.currentTarget).userName;
			userData.isFriend = false;
			for (var i:int = 0; i < mainData.lobbyRoomData.friendList.length; i++) 
			{
				if (UserDataULC(mainData.lobbyRoomData.friendList[i]).userName == userData.userName)
				{
					userData.isFriend = true;
					break;
				}
			}
			userData.win = PlayerInfoXito(e.currentTarget).win;
			userData.lose = PlayerInfoXito(e.currentTarget).lose;
			
			var addFriendWindow:AddFriendWindow = new AddFriendWindow();
			addFriendWindow.isInGame = true;
			addFriendWindow.data = userData;
			if (belowUserInfo.isRoomMaster && !isPlaying)
				addFriendWindow.isShowKickOut = true;
			else
				addFriendWindow.isShowKickOut = false;
			windowLayer.openWindow(addFriendWindow);
		}
		
		private function onKickOutClick(e:Event):void 
		{
			var confirmKickOutWindow:ConfirmWindow = new ConfirmWindow();
			confirmKickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmKickOut + " " + myContextMenu.data[DataFieldXito.DISPLAY_NAME]);
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
			electroServerCommand.kickUser(myContextMenu.data[DataFieldXito.USER_NAME]);
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
			{
				cardManager = new CardManagerXito();
				cardManager.addEventListener(CardManagerXito.DIVIDE_FINISH, onDivideFinish);
			}
			cardManager.x = content["cardManagerPosition"].x;
			cardManager.y = content["cardManagerPosition"].y;
			playingLayer.addChild(cardManager);
		}
		
		private function onDivideFinish(e:Event):void 
		{
			if (isFirstJoinGame)
			{
				isFirstJoinGame = false;
			}
		}
		
		private function removeCardManager():void
		{
			if (cardManager)
			{
				if (cardManager.parent)
					cardManager.parent.removeChild(cardManager);
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
						if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(allPlayerArray[i]).userName)
							PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
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
			
			var countReady:int = 0;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (data[DataFieldXito.USER_NAME] == PlayerInfoXito(allPlayerArray[i]).userName)
					{
						PlayerInfoXito(allPlayerArray[i]).isReadyPlay = true;
						if (allPlayerArray[i] == belowUserInfo)
						{
							hideReadyButton();
							waitToStart.visible = true;
						}
					}
					if (PlayerInfoXito(allPlayerArray[i]).isReadyPlay)
						countReady++;
				}
			}
			
			if (countReady == 1 && isResetDone)
				countTimeToKickRoomMaster();
		}
		
		private function setupTextField():void
		{
			ruleDescription = content["ruleDescription"];
			ruleDescription.selectable = false;
			
			countToKickTxt = content["countToKickTxt"];
			countToKickTxt.text = '';
			countToKickTxt.visible = false;
		}
		
		// Sắp xếp lại vị trí của người chơi để position 0 bắt đầu từ chính người chơi của mình
		private function reArrangePositions(userList:Array):void
		{
			jumpIndex = 0; // Dùng để sắp xếp lại vị trí của các người chơi
			var i:int;
			
			// tính lại vị trí của các người chơi, vì position của chính mình bao giờ cũng là 0
			for (i = 0; i < userList.length; i++) 
			{
				if (userList[i][DataFieldXito.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					jumpIndex = userList[i][DataFieldXito.POSITION];
					i = userList.length;
				}
			}
			if (jumpIndex != 0)
			{
				for (i = 0; i < userList.length; i++) 
				{
					userList[i][DataFieldXito.POSITION] -= jumpIndex;
					if (userList[i][DataFieldXito.POSITION] < 0)
						userList[i][DataFieldXito.POSITION] += mainData.maxPlayer;
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
			
			if (cardManager)
			{
				removeEventListener(CardManagerXito.DIVIDE_FINISH, onDivideFinish);
				cardManager.destroy();
			}
			
			cardManager = null;
			playingPlayerArray = null;
			
			ruleDescription = null;
			
			if (mainData)
				mainData.playingData.removeEventListener(PlayingData.UPDATE_PLAYING_SCREEN, onUpdatePlayingScreen);
			//mainData = null;
			
			if(readyButton)
				readyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			readyButton = null;
			mainCommand = null;
			
			if (timerToResetMatch)
			{
				timerToResetMatch.removeEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.stop();
				timerToResetMatch = null;
			}
			
			if (resultWindow)
			{
				if (resultWindow.parent)
					resultWindow.close();
			}
			
			if (parent)
				parent.removeChild(this);
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