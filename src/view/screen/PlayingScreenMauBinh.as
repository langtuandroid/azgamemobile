package view.screen 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.gskinner.motion.GTween;
	import control.MainCommand;
	import event.Command;
	import event.DataFieldMauBinh;
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
	import view.ScrollView.ScrollViewYun;
	import view.window.AddFriendWindow;
	import view.window.AddMoneyWindow2;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import logic.MauBinhLogic;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import model.playingData.PlayingScreenAction;
	import sound.SoundLibChung;
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	import view.button.MyButton;
	import view.card.CardMauBinh;
	import view.card.CardManagerMauBinh;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.effectLayer.TextEffect_1;
	import view.userInfo.playerInfo.PlayerInfoMauBinh;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.FeedbackWindow;
	import view.window.InvitePlayWindow;
	import view.window.OrderCardWindow;
	import view.window.ResultWindowMauBinh;
	import view.window.SpecialGroupWindow;
	import view.window.UserProfileWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenMauBinh extends BaseScreen 
	{
		public static const CLOSE_COMPLETE:String = "closeComplete";
		public static const BACK_TO_CHOOSE_CHANNEL_SCREEN:String = "backToChooseChannelScreen";
		
		private static const COMPARE_GROUP_1_INDEX:int = 0;
		private static const COMPARE_GROUP_2_INDEX:int = 1;
		private static const COMPARE_GROUP_3_INDEX:int = 2;
		private static const SAP_HAM_INDEX:int = 3;
		private static const SAP_LANG_INDEX:int = 4;
		private static const BAT_SAP_LANG_INDEX:int = 5;
		private static const SO_AT_INDEX:int = 6;
		
		private var belowUserInfo:PlayerInfoMauBinh;
		private var rightUserInfo:PlayerInfoMauBinh;
		private var leftUserInfo:PlayerInfoMauBinh;
		private var aboveUserInfo:PlayerInfoMauBinh;
		
		private var chatBox:ChatBox
		
		private var cardManager:CardManagerMauBinh;
		private var allPlayerArray:Array; // Mảng chứa tất cả người chơi
		private var playingPlayerArray:Array; // Mảng chứa các người chơi đang trong ván bài
		
		private var countToKickTxt:TextField;
		private var ruleDescription:TextField;
		private var waitToPlay:Sprite;
		private var waitToStart:Sprite;
		private var waitPlaying:Sprite;
		private var compareGroup1:Sprite;
		private var compareGroup2:Sprite;
		private var compareGroup3:Sprite;
		private var sapham:Sprite;
		private var saplang:Sprite;
		private var batsaplang:Sprite;
		private var soAt:Sprite;
		private var maubinh:Sprite;
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
		private var resultWindow:ResultWindowMauBinh;
		private var isPlaying:Boolean;
		private var isResetDone:Boolean = true;
		private var nextTurn:String; // Biến để lưu userName của thằng đánh ở turn kế tiếp
		//private var isHaveUserReady:Boolean;
		private var timerToPing:Timer;
		private var pingTime:int = 55;
		private var myContextMenu:MyContextMenu;
		private var compareGroupData:Object;
		private var specialGroupWindow:SpecialGroupWindow;
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
		private var chatButton:MovieClip;
		
		private var _giveUpPlayerArray:Array;
		private var isGameOver:Boolean = true;
		private var addMoneyObject:Object;
		
		public function PlayingScreenMauBinh() 
		{
			mainData.isAutoReady = false;
			
			background = new zGameBackground();
			addChild(background);
			
			super();
			addContent("zPlayingScreenMauBinh");
			createLayer();
			
			invitePlayButtonArray = new Array();
			invitePlayButtonArray.push(content["invitePlayButton1"]);
			invitePlayButtonArray.push(content["invitePlayButton2"]);
			invitePlayButtonArray.push(content["invitePlayButton3"]);
			for (var i:int = 0; i < 3; i++) 
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
			waitPlaying = content["waitPlaying"];
			waitToPlay.visible = waitToStart.visible = waitPlaying.visible = false;
			
			setupCompareGroupStatus();
			
			versionTxt = content["versionTxt"];
			//if (!mainData.isTest)
				//versionTxt.visible = false;
			//if (mainData.chooseChannelData.myInfo.name == "dung296")
				//versionTxt.visible = true;
			versionTxt.text = mainData.version;
			maubinh = content["maubinh"];
			maubinh.visible = false;
			
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
				textField.htmlText = mainData.systemNoticeList[j][DataFieldMauBinh.MESSAGE];
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
					TextField(ipBoard["displayNameTxt" + String(ipIndex + 1)]).text = PlayerInfoMauBinh(allPlayerArray[i]).displayName;
					var ipString:String = String(PlayerInfoMauBinh(allPlayerArray[i]).ip);
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
		
		private function setupCompareGroupStatus():void 
		{
			compareGroup1 = content["compareGroup1"];
			compareGroup2 = content["compareGroup2"];
			compareGroup3 = content["compareGroup3"];
			sapham = content["sapham"];
			saplang = content["saplang"];
			batsaplang = content["batsaplang"];
			soAt = content["soAt"];
			setCompareGroupStatus();
		}
		
		private function setCompareGroupStatus(type:int = -1):void
		{
			compareGroup1.visible = compareGroup2.visible = compareGroup3.visible = false;
			sapham.visible = saplang.visible = batsaplang.visible = soAt.visible = false;
			
			switch (type) 
			{
				case 0:
					compareGroup1.visible = true;
					addChild(compareGroup1);
				break;
				case 1:
					compareGroup2.visible = true;
					addChild(compareGroup2);
				break;
				case 2:
					compareGroup3.visible = true;
					addChild(compareGroup3);
				break;
				case 3:
					sapham.visible = true;
					addChild(sapham);
				break;
				case 4:
					saplang.visible = true;
					addChild(saplang);
				break;
				case 5:
					batsaplang.visible = true;
					addChild(batsaplang);
				break;
				case 6:
					soAt.visible = true;
					addChild(soAt);
				break;
				default:
			}
		}
		
		private var sharedObject:SharedObject;
		private var countBinhLungAndMauBinh:int;
		private var playerMauBinh:PlayerInfoMauBinh;
		private var timerToHideIpBoard:Timer;
		private var timerToCheckTime:Timer;
		private var bestResult:String;
		private var haveMauBinh:Boolean;
		private var destroyPlayerArray:Array;
		private var timerToKickRoomMaster:Timer;
		private var emoArray:Array;
		private var background:zGameBackground;
		private var isShowResultWindow:Boolean;
		private var userListJoinWhenCompareGroup:Array;
		private var timerToShowResultWindow:Timer;
		private function setupButton():void 
		{
			emoticonButton = content["emoticonButton"];
			chatButton = content["chatButton"];
			chatButton.gotoAndStop(1);
			settingBoard = content["settingBoard"];
			chatboxLayer.addChild(settingBoard);
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
			chatButton.gotoAndStop(1);
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
						PlayerInfoMauBinh(allPlayerArray[i]).addChatSentence(mainData.publicChatData.chatContent);
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
					if (PlayerInfoMauBinh(allPlayerArray[i]).userName == mainData.emoChatData[DataFieldMauBinh.USER_NAME])
					{
						PlayerInfoMauBinh(allPlayerArray[i]).showEmo(mainData.emoChatData[DataFieldMauBinh.EMO_TYPE]);
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
			
			if (mainData.responseAddFriendData[DataFieldMauBinh.CONFIRM])
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataFieldMauBinh.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.acceptAddFriend);
			}
			else
			{
				alertWindow.setNotice(mainData.responseAddFriendData[DataFieldMauBinh.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.rejectAddFriend);
			}
			
			windowLayer.openWindow(alertWindow);
		}
		
		private function onConfirmFriendRequest(e:Event):void 
		{
			var invitedNameArray:Array = [mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldMauBinh.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldMauBinh.MESSAGE, mess);
			
			if (mainData.confirmFriendRequestData[DataFieldMauBinh.CONFIRM])
				esObject.setBoolean(DataFieldMauBinh.CONFIRM, true);
			else
				esObject.setBoolean(DataFieldMauBinh.CONFIRM, false);
			
			electroServerCommand.sendPrivateMessage(invitedNameArray, Command.CONFIRM_ADD_FRIEND_INVITE, esObject);
			
			if (electroServerCommand.coreAPI.myData.friendList)
			{
				if (mainData.confirmFriendRequestData[DataFieldMauBinh.CONFIRM])
				{
					electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]] = new Object();
					if (electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]])
					{
						var displayName:String = electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]][DataFieldMauBinh.USER_INFO][DataFieldMauBinh.DISPLAY_NAME];
						electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]][DataFieldMauBinh.DISPLAY_NAME] = displayName;
					}
				}
			}
		}
		
		private function onInviteAddFriend(e:Event):void 
		{
			var inviteAddFriendWindow:ConfirmWindow = new ConfirmWindow();
			inviteAddFriendWindow.setNotice(mainData.inviteAddFriendData[DataFieldMauBinh.DISPLAY_NAME] + " " + mainData.init.gameDescription.lobbyRoomScreen.addFriendSentence);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmInvite);
			inviteAddFriendWindow.addEventListener(ConfirmWindow.REJECT, onRejectInvite);
			windowLayer.openWindow(inviteAddFriendWindow);
		}
		
		private function onConfirmInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldMauBinh.USER_NAME], true, DataFieldMauBinh.IN_GAME_ROOM);
		}
		
		private function onRejectInvite(e:Event):void 
		{
			electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldMauBinh.USER_NAME], false, DataFieldMauBinh.IN_GAME_ROOM);
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
				textField.htmlText = mainData.systemNoticeList[j][DataFieldMauBinh.MESSAGE];
				chatBox.addChatSentence(textField.text, "Thông báo");
			}
			if (mainData.systemNoticeList.length != 0)
				chatButton.play();
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
				case PlayingScreenAction.GAME_OVER: // ván kết thúc
					listenGameOver(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.UPDATE_ROOM_MASTER: // Cập nhật thay đổi chủ phòng
					listenUpdateRoomMaster(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.ROOM_MASTER_KICK: // Bị chủ phòng kick
					listenRoomMasterKick(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.SORT_FINISH: // Có người xếp bài xong hoặc bỏ xếp bài xong
					listenHaveUserSortCard(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.WHITE_WIN: // Thắng trắng
					listenWhiteWin(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.UPDATE_MONEY: // update tiền
					listenUpdateMoney(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_REQUEST_TIME_CLOCK: // có người khác request time clock khi đang chơi
					listenHaveUserRequestTimeClock(e.data[ModelField.DATA]);
				break;
				case Command.UPDATE_COMPARE_GROUP_STATUS: // update thong bao la dang do chi hoac vua do chi xong
					listenUpdateCompareGroupStatus(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_RESPOND_TIME_CLOCK: // có người khác respond time clock khi đang chơi
					listenHaveUserRespondTimeClock(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_REQUEST_IS_COMPARE_GROUP: // có người khác hỏi xem có phải đang đọ chi không
					listenHaveUserRequestIsCompareGroup(e.data[ModelField.DATA]);
				break;
				case PlayingScreenAction.HAVE_USER_RESPOND_IS_COMPARE_GROUP: // có người khác trả lời có phải đang đọ chi không
					listenHaveUserRespondIsCompareGroup(e.data[ModelField.DATA]);
				break;
			}
		}
		
		private function listenHaveUserJoinRoom(data:Object):void 
		{
			if (!isResetDone && isGameOver && !isShowResultWindow && belowUserInfo.isRoomMaster)
			{
				userListJoinWhenCompareGroup.push(data[DataFieldMauBinh.USER_NAME]);
				electroServerCommand.sendCompareGroupStatus('', [data[DataFieldMauBinh.USER_NAME]]);
			}
			SoundManager.getInstance().soundManagerMauBinh.playOtherJoinGamePlayerSound(data[DataFieldMauBinh.SEX]);
			
			chatBox.addChatSentence(data[DataFieldMauBinh.DISPLAY_NAME] + " " + mainData.init.gameDescription.playingScreen.userJoinRoom, "Thông báo", false, true);
			var indexEmpty:int;
			indexEmpty = allPlayerArray.length;
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (!allPlayerArray[i])
				{
					data[DataFieldMauBinh.POSITION] = i;
					i = allPlayerArray.length + 1;
				}
			}
			if (!data[DataFieldMauBinh.POSITION])
				data[DataFieldMauBinh.POSITION] = allPlayerArray.length;
			addOnePlayer(data[DataFieldMauBinh.POSITION]);
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
				if (giveUpObject[DataFieldMauBinh.POSITION] == indexEmpty)
				{
					PlayerInfoMauBinh(giveUpObject[DataFieldMauBinh.PLAYER]).destroy();
					giveUpPlayerArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function listenHaveUserRequestTimeClock(data:Object):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.TIME_CLOCK, String(belowUserInfo.clock.timeNumber));
			electroServerCommand.sendPrivateMessage([data[DataFieldMauBinh.USER_NAME]], Command.RESPOND_TIME_CLOCK, esObject);
		}
		
		private function listenUpdateCompareGroupStatus(data:Object):void
		{
			if(waitPlaying.visible && !isPlaying)
			{
				showReadyButton();
				waitPlaying.visible = false;
			}
			else if (readyButton.parent)
			{
				hideReadyButton();
				waitPlaying.visible = true;
			}
		}
		
		private function listenHaveUserRequestIsCompareGroup(data:Object):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setBoolean(DataFieldMauBinh.IS_COMPARE_GROUP, !isGameOver);
			electroServerCommand.sendPrivateMessage([data[DataFieldMauBinh.USER_NAME]], Command.RESPOND_IS_COMPARE_GROUP, esObject);
		}
		
		private function listenHaveUserRespondTimeClock(data:Object):void
		{
			belowUserInfo.countTime(data[DataFieldMauBinh.TIME_CLOCK]);
		}
		
		private function listenHaveUserRespondIsCompareGroup(data:Object):void
		{
			//if (!data[DataFieldMauBinh.IS_COMPARE_GROUP])
				//showReadyButton();
		}
		
		private function listenHaveUserOutRoom(data:Object):void 
		{
			var i:int;
			var j:int;
			var outPlayer:PlayerInfoMauBinh;
			
			for (i = 0; i < playingPlayerArray.length; i++) 
			{
				if (playingPlayerArray[i])
				{
					if (PlayerInfoMauBinh(playingPlayerArray[i]).userName == data[DataFieldMauBinh.USER_NAME])
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
						if (PlayerInfoMauBinh(allPlayerArray[i]).userName == data[DataFieldMauBinh.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoMauBinh(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo", false, true);
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
								addMoneyObject[DataFieldMauBinh.TOTAL] += (6);
								addMoneyObject[DataFieldMauBinh.MONEY] += (((Number(mainData.playingData.gameRoomData.roomBet) * 6)) * (1 - mainData.fee));
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
						if (PlayerInfoMauBinh(allPlayerArray[i]).userName == data[DataFieldMauBinh.USER_NAME])
						{
							chatBox.addChatSentence(PlayerInfoMauBinh(allPlayerArray[i]).displayName + " " + mainData.init.gameDescription.playingScreen.userLeaveRoom, "Thông báo", false, true);
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
						if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay)
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
							if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay)
								return;
						}
					}
					hideStartButton();
					if(countPlayer > 1 && isResetDone)
						waitToPlay.visible = true;
				}
			}
			
			SoundManager.getInstance().soundManagerMauBinh.playOtherExitGamePlayerSound(outPlayer.sex);
		}
		
		private function listenJoinRoom(data:Object):void 
		{
			SoundManager.getInstance().soundManagerMauBinh.playOtherJoinGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			
			var channelName:String = mainData.playingData.gameRoomData.channelName;
			var roomId:String = String(mainData.playingData.gameRoomData.roomId);
			var roomBet:String = PlayingLogic.format(data[DataFieldMauBinh.ROOM_BET], 1);
			ruleDescription.text = mainData.gameName + " - " + channelName + " - Bàn " + roomId + " - Cược " + roomBet + " G";
			
			mainData.playingData.gameRoomData.roomBet = data[DataFieldMauBinh.ROOM_BET];
			mainData.playingData.gameRoomData.roomName = data[DataFieldMauBinh.ROOM_NAME];
			mainData.playingData.gameRoomData.isSendCard = data[DataFieldMauBinh.IS_SEND_CARD];
			
			var i:int;
			var userList:Array = data[DataFieldMauBinh.USER_LIST] as Array;
			
			var currentPosition:int = 1;
			for (i = 0; i < userList.length; i++)
			{
				if (userList[i][DataFieldMauBinh.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					userList[i][DataFieldMauBinh.POSITION] = 0;
				}
				else
				{
					userList[i][DataFieldMauBinh.POSITION] = currentPosition;
					currentPosition++;
				}
			}
			
			// add người chơi
			for (i = 0; i < userList.length; i++) 
			{
				addOnePlayer(userList[i][DataFieldMauBinh.POSITION]);
			}
			
			// bổ sung thông tin cá nhân
			for (i = 0; i < userList.length; i++) 
			{
				addPersonalInfo(userList[i]);
			}
			
			if (data[DataFieldMauBinh.GAME_STATE] == DataFieldMauBinh.WAITING) // Nếu phòng chơi chưa bắt đầu
			{
				if (allPlayerArray.length > 1)
				{
					if (!mainData.isCompareGroupTime)
						showReadyButton();
					else
						waitPlaying.visible = true;
					var esObject:EsObject = new EsObject();
					esObject.setString(DataFieldMauBinh.USER_NAME, mainData.chooseChannelData.myInfo.uId);
					var isCompareGroup:Boolean;
				}
			}
			else // Nếu phòng chơi đang chơi
			{
				hideStartButton();
				hideReadyButton();
				waitToPlay.visible = false;
				waitToStart.visible = false;
				addCardManager();
				cardManager.getCardPoint.gotoAndStop("hide");
				// bổ sung thông tin cá nhân
				for (i = 0; i < userList.length; i++) 
				{
					// Không phải add cho mình vì minh vừa vào nên chắc chắc là không có bài
					if (!userList[i][DataFieldMauBinh.IS_VIEWER]) 
					{
						addCardInfo(userList[i]);
					}
				}
			
				playingPlayerArray = new Array();
				for (i = 0; i < allPlayerArray.length; i++)
				{
					if (allPlayerArray[i])
					{
						if (PlayerInfoMauBinh(allPlayerArray[i]).isPlaying)
						{
							playingPlayerArray.push(allPlayerArray[i]);
						}
					}
				}
				esObject = new EsObject();
				esObject.setString(DataFieldMauBinh.USER_NAME, mainData.chooseChannelData.myInfo.uId);
				electroServerCommand.sendPrivateMessage([PlayerInfoMauBinh(playingPlayerArray[0]).userName], Command.REQUEST_TIME_CLOCK, esObject);
				isPlaying = true;
				isResetDone = false;
				cardManager.playerArray = playingPlayerArray;
			}
			
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoMauBinh(allPlayerArray[i]).userName == data[DataFieldMauBinh.ROOM_MASTER])
					{
						PlayerInfoMauBinh(allPlayerArray[i]).isRoomMaster = true;
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
							if (PlayerInfoMauBinh(allPlayerArray[i]).ip == PlayerInfoMauBinh(allPlayerArray[j]).ip)
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
			userListJoinWhenCompareGroup = new Array();
			if (timerToKickRoomMaster)
			{
				timerToKickRoomMaster.removeEventListener(TimerEvent.TIMER, onTimerToKickRoomMaster)
				timerToKickRoomMaster.stop();
				countToKickTxt.visible = false;
			}
			
			addMoneyObject = new Object();
			addMoneyObject[DataFieldMauBinh.TOTAL] = 0;
			addMoneyObject[DataFieldMauBinh.MONEY] = 0;
			
			isGameOver = false;
			haveMauBinh = false;
			giveUpPlayerArray = new Array();
			isEnableKickOut = false;
			hideStartButton();
			hideReadyButton();
			waitToPlay.visible = false;
			waitToStart.visible = false;
			var i:int;
			isPlaying = true;
			isResetDone = false;
			isShowResultWindow = false;
			
			destroyPlayerArray = new Array();
			playingPlayerArray = new Array();
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay || PlayerInfoMauBinh(allPlayerArray[i]).isRoomMaster)
						playingPlayerArray.push(allPlayerArray[i]);
				}
			}
				
			for (i = 0; i < playingPlayerArray.length; i++)
			{
				PlayerInfoMauBinh(playingPlayerArray[i]).isPlaying = true;
				PlayerInfoMauBinh(playingPlayerArray[i]).isReadyPlay = false;
				PlayerInfoMauBinh(playingPlayerArray[i]).playingPlayerArray = playingPlayerArray;
					
				if (playingPlayerArray[i] == belowUserInfo) // Gán cho mình dữ liệu các lá bài của server gửi về
				{							
					PlayerInfoMauBinh(playingPlayerArray[i]).cardInfoArray = data[DataFieldMauBinh.PLAYER_CARDS] as Array;
				}
				else // Nếu không thì chuyền dữ liệu gồm các lá bài úp
				{
					PlayerInfoMauBinh(playingPlayerArray[i]).isCurrentWinner = false;
					PlayerInfoMauBinh(playingPlayerArray[i]).cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
				}
			}
			addCardManager();
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
			if (data[DataFieldMauBinh.IS_CURRENT_WINNER])
			{
				nextTurn = belowUserInfo.userName;
				belowUserInfo.isCurrentWinner = true;
			}
			else
			{
				belowUserInfo.isCurrentWinner = false;
			}
		}
		
		private function listenUpdateRoomMaster(data:Object):void // cập nhật thay đổi chủ phòng
		{
			var i:int;
			for (i = 0; i < allPlayerArray.length; i++)
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoMauBinh(allPlayerArray[i]).userName == data[DataFieldMauBinh.ROOM_MASTER])
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = false;
						PlayerInfoMauBinh(allPlayerArray[i]).isRoomMaster = true;
					}
					else
					{
						if (allPlayerArray[i] == belowUserInfo)
							autoReady.visible = true;
						PlayerInfoMauBinh(allPlayerArray[i]).isRoomMaster = false;
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
							if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay && allPlayerArray[i] != belowUserInfo)
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
							if (PlayerInfoMauBinh(allPlayerArray[i]).isRoomMaster)
								PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay = false;
							else if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay)
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
					dispatchEvent(new Event(PlayerInfoMauBinh.EXIT));
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
			if (data[DataFieldMauBinh.USER_NAME] == belowUserInfo.userName) // Nếu người bị kick là mình
			{
				dispatchEvent(new Event(PlayerInfoMauBinh.EXIT));
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
		
		private function listenHaveUserSortCard(data:Object):void // Có người xếp bài xong hoặc bỏ xếp bài xong
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoMauBinh(playingPlayerArray[i]).userName == data[DataFieldMauBinh.USER_NAME])
				{
					//if(PlayerInfo(playingPlayerArray[i]).formName != PlayerInfo.BELOW_USER)
						PlayerInfoMauBinh(playingPlayerArray[i]).isSortFinish = data[DataFieldMauBinh.IS_SORT];
					i = playingPlayerArray.length + 1;
				}
			}
		}
		
		private function listenWhiteWin(data:Object):void // Thắng trắng
		{
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoMauBinh(playingPlayerArray[i]).isSortFinish)
					PlayerInfoMauBinh(playingPlayerArray[i]).isSortFinish = false;
			}
			belowUserInfo.isPlaying = false;
			belowUserInfo.stopCountTime();
			belowUserInfo.arrangeFinishButton.visible = false;
			belowUserInfo.reArrangeButton.visible = false;
			specialGroupWindow = new SpecialGroupWindow();
			specialGroupWindow.setType(data[DataFieldMauBinh.GROUP_RANK]);
			specialGroupWindow.addCard(data[DataFieldMauBinh.CARDS]);
			windowLayer.openWindow(specialGroupWindow);
		}
		
		private function listenUpdateMoney(data:Object):void // update tiền
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					if (PlayerInfoMauBinh(allPlayerArray[i]).userName == data[DataFieldMauBinh.USER_NAME])
						PlayerInfoMauBinh(allPlayerArray[i]).updateMoneyNumber(data[DataFieldMauBinh.MONEY]);
				}
			}
		}
		
		private function updateMoney():void 
		{
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					PlayerInfoMauBinh(allPlayerArray[i]).updateMoney(PlayerInfoMauBinh(allPlayerArray[i]).moneyNumber);
				}
			}
			
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet) * mainData.minBetRate)
			{
				dispatchEvent(new Event(PlayerInfoMauBinh.EXIT));
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
			compareGroupData = data;
			countBinhLungAndMauBinh = 0;
			isGameOver = true;
			
			if (belowUserInfo)
			{
				belowUserInfo.stopCountTime();
				belowUserInfo.groupStatus.visible = false;
				belowUserInfo.arrangeFinishButton.visible = false;
				belowUserInfo.reArrangeButton.visible = false;
				belowUserInfo.isPlaying = false;
			}
			if (specialGroupWindow)
			{
				specialGroupWindow.close(BaseWindow.MIDDLE_EFFECT);
				specialGroupWindow = null;
			}
			var playerList:Array = data[DataFieldMauBinh.PLAYER_LIST] as Array;
			
			//windowLayer.openWindow(resultWindow);
			//resetMatch();
			var timerToResetPlayingStatus:Timer = new Timer(1000, 1);
			timerToResetPlayingStatus.addEventListener(TimerEvent.TIMER_COMPLETE, onResetPlayingStatus);
			timerToResetPlayingStatus.start();
			
			for (var i:int = 0; i < playerList.length; i++) 
			{
				if (playerList[i][DataFieldMauBinh.USER_NAME] != belowUserInfo.userName)
				{
					for (var j:int = 0; j < playingPlayerArray.length; j++) 
					{
						if (playerList[i][DataFieldMauBinh.USER_NAME] == PlayerInfoMauBinh(playingPlayerArray[j]).userName)
						{
							if (playerList[i][DataFieldMauBinh.NO_COMPARE_GROUP]) // Trường hợp có người thoát và chỉ còn 1 mình mình trong phòng
							{
								timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
								timerToResetMatch.start();
								return;
							}
							
							if(playerList[i][DataFieldMauBinh.CARDS_CHI_1])
								PlayerInfoMauBinh(playingPlayerArray[j]).addValueForOneGroup(1, playerList[i][DataFieldMauBinh.CARDS_CHI_1]);
							if(playerList[i][DataFieldMauBinh.CARDS_CHI_2])
								PlayerInfoMauBinh(playingPlayerArray[j]).addValueForOneGroup(2, playerList[i][DataFieldMauBinh.CARDS_CHI_2]);
							if(playerList[i][DataFieldMauBinh.CARDS_CHI_3])
								PlayerInfoMauBinh(playingPlayerArray[j]).addValueForOneGroup(3, playerList[i][DataFieldMauBinh.CARDS_CHI_3]);
							//PlayerInfo(playingPlayerArray[j]).openAllCard();
						}
						PlayerInfoMauBinh(playingPlayerArray[j]).isSortFinish = false;
					}
				}
				else
				{
					for (j = 0; j < playingPlayerArray.length; j++) 
					{
						if (playerList[i][DataFieldMauBinh.USER_NAME] == PlayerInfoMauBinh(playingPlayerArray[j]).userName)
						{
							if (playerList[i][DataFieldMauBinh.NO_COMPARE_GROUP]) // Trường hợp có người thoát và chỉ còn 1 mình mình trong phòng
							{
								timerToResetMatch = new Timer(mainData.resetMatchTime * 1, 1);
								timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
								timerToResetMatch.start();
								return;
							}
						}
					}
				}
				
				if (playerList[i][DataFieldMauBinh.IS_BINH_LUNG])
					countBinhLungAndMauBinh++;
				if (playerList[i][DataFieldMauBinh.WIN_TYPE] != 0)
					countBinhLungAndMauBinh++;
			}
			
			showGroupNumber(1);
			
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			
			if (countBinhLungAndMauBinh >= playingPlayerArray.length - 1)
			{
				for (i = 0; i < playingPlayerArray.length; i++)
				{
					PlayerInfoMauBinh(playingPlayerArray[i]).openAllCard();
				}
				
				if (compareGroupData[DataFieldMauBinh.IS_SO_AT])
				{
					var timerToShowSoAt:Timer = new Timer(time * 1000, 1);
					timerToShowSoAt.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSoAt);
					timerToShowSoAt.start();
				}
				else
				{
					timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
					timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
					timerToResetMatch.start();
				}
			}
			else
			{
				var timerToHightlineGroupTwo:Timer = new Timer(time * 1000, 1);
				timerToHightlineGroupTwo.addEventListener(TimerEvent.TIMER_COMPLETE, onHightlineGroupTwo);
				timerToHightlineGroupTwo.start();
			}
		}
		
		private function onResetPlayingStatus(e:TimerEvent):void 
		{
			if (!stage)
				return;
			isPlaying = false;
		}
		
		// DungNT4 - show số chi người chơi ăn thua qua từng chi
		private function showGroupNumber(groupIndex:int):void
		{
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			var p1:Point;
			var p2:Point;
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			var bestScore:int = 0;
			
			setCompareGroupStatus(groupIndex - 1);
			
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						if (resultArray[i][DataFieldMauBinh.WIN_TYPE] == 0 && !resultArray[i][DataFieldMauBinh.IS_BINH_LUNG])
						{
							var groupNumber:int = 0;
							groupNumber = resultArray[i]["score" + String(groupIndex)];
							if (countBinhLungAndMauBinh >= playingPlayerArray.length - 1)
								groupNumber = resultArray[i][DataFieldMauBinh.TOTAL] - resultArray[i][DataFieldMauBinh.BONUS_CHI];
							var groupResult:String = '0';
							var idArray:Array;
							switch (groupIndex) 
							{
								case 1:
									groupResult = resultArray[i][DataFieldMauBinh.RANK_CHI_1];
									idArray = resultArray[i][DataFieldMauBinh.CARDS_CHI_1];
								break;
								case 2:
									groupResult = resultArray[i][DataFieldMauBinh.RANK_CHI_2];
									idArray = resultArray[i][DataFieldMauBinh.CARDS_CHI_2];
								break;
								case 3:
									groupResult = resultArray[i][DataFieldMauBinh.RANK_CHI_3];
									idArray = resultArray[i][DataFieldMauBinh.CARDS_CHI_3];
								break;
								default:
							}
							p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
							p2 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).groupResultEffectPosition);
							
							if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
							{
								if(groupResult == '1')
									groupResult = MauBinhLogic.getInstance().checkMauThau(idArray);
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
								if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, groupResult);
							}
							else
							{
								if(groupResult == '1')
									groupResult = MauBinhLogic.getInstance().checkMauThau(idArray);
								//p1.y = p1.y + (3 - groupIndex) * 39;
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber);
								if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2,time, 1, groupResult);
							}
								
							if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
								PlayerInfoMauBinh(playingPlayerArray[j]).hightlineGroup(groupIndex);
						}
						else if(groupIndex == 1)
						{
							p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
							p2 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).groupResultEffectPosition);
							groupNumber = resultArray[i][DataFieldMauBinh.TOTAL] - resultArray[i][DataFieldMauBinh.BONUS_CHI];
							groupResult = resultArray[i][DataFieldMauBinh.WIN_TYPE];
							
							if (PlayerInfoMauBinh(playingPlayerArray[j]) != belowUserInfo)
								PlayerInfoMauBinh(playingPlayerArray[j]).openAllCard();
							if (resultArray[i][DataFieldMauBinh.IS_BINH_LUNG])
							{
								if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
								{
									SoundManager.getInstance().soundManagerMauBinh.playBinhLungPlayerSound(mainData.chooseChannelData.myInfo.sex);
								}
								if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
								{
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time * 3, 0, '-19');
									if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
										effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time * 3, groupNumber, PlayerInfoMauBinh.BELOW_USER);
									else
										effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time * 3, groupNumber);
								}
								else
								{
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, '-19');
									if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
										effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
									else
										effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber);
								}
							}
							else if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
							{
								haveMauBinh = true;
								var mauBinhIndex:String = groupResult;
								playerMauBinh = PlayerInfoMauBinh(playingPlayerArray[j]);
								if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
								{
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time * 3, groupNumber, PlayerInfoMauBinh.BELOW_USER);
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time * 3, 0, groupResult);
								}
								else
								{
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, groupResult);
								}
							}
							else
							{
								haveMauBinh = true;
								mauBinhIndex = groupResult;
								playerMauBinh = PlayerInfoMauBinh(playingPlayerArray[j]);
								//p1.y = p1.y + (3 - groupIndex) * 39;
								if (countBinhLungAndMauBinh < playingPlayerArray.length - 1)
								{
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time * 3, groupNumber);
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2,time * 3, 1, groupResult);
								}
								else
								{
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT, p1, time, groupNumber);
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2,time, 1, groupResult);
								}
							}
						}
						if (groupNumber > bestScore)
						{
							bestScore = groupNumber;
							bestResult = groupResult;
							
							var timerToPlayNormalPlayerSound:Timer = new Timer(3000, 1);
							timerToPlayNormalPlayerSound.addEventListener(TimerEvent.TIMER_COMPLETE, onPlayNormalPlayerSound)
							timerToPlayNormalPlayerSound.start();
						}
					}
				}
			}
			
			if (countBinhLungAndMauBinh >= playingPlayerArray.length - 1)
			{
				compareGroup1.visible = false;
			}
			else
			{
				if (!haveMauBinh)
				{
					switch (groupIndex - 1) 
					{
						case 0:
							SoundManager.getInstance().soundManagerMauBinh.playDoChiPlayerSound(mainData.chooseChannelData.myInfo.sex, 1);
						break;
						case 1:
							SoundManager.getInstance().soundManagerMauBinh.playDoChiPlayerSound(mainData.chooseChannelData.myInfo.sex, 2);
						break;
						case 2:
							SoundManager.getInstance().soundManagerMauBinh.playDoChiPlayerSound(mainData.chooseChannelData.myInfo.sex, 3);
						break;
						default:
					}
				}
			}
				
			if (haveMauBinh)
			{
				if (countBinhLungAndMauBinh < playingPlayerArray.length - 1 && groupIndex != 1)
					return;
				SoundManager.getInstance().playSound(SoundLibChung.SPECIAL_SOUND);
				
				time = mainData.init.gameDescription.playingScreen.hideMauBinhTime;
				var timerToHideMauBinh:Timer = new Timer(time * 1000, 1);
				timerToHideMauBinh.addEventListener(TimerEvent.TIMER_COMPLETE, onHideMauBinh);
				timerToHideMauBinh.start();
				maubinh.visible = true;
				
				SoundManager.getInstance().soundManagerMauBinh.playSpecialPlayerSound(mainData.chooseChannelData.myInfo.sex, mauBinhIndex);
				
				var timerToPlaySoundMauBinh:Timer = new Timer(3000, 1);
				timerToPlaySoundMauBinh.addEventListener(TimerEvent.TIMER_COMPLETE, onPlaySoundMaubinh)
				timerToPlaySoundMauBinh.start();
			}
		}
		
		private function onPlayNormalPlayerSound(e:TimerEvent):void 
		{
			if (!stage)
				return;
			if (countBinhLungAndMauBinh >= playingPlayerArray.length - 1)
				return;
			SoundManager.getInstance().soundManagerMauBinh.playNormalPlayerSound(mainData.chooseChannelData.myInfo.sex, bestResult);
		}
		
		private function onPlaySoundMaubinh(e:TimerEvent):void 
		{
			if (!stage)
				return;
			SoundManager.getInstance().soundManagerMauBinh.playMauBinhPlayerSound(playerMauBinh.sex);
			
			var timerToPlaySoundMauBinhLose:Timer = new Timer(3000, 1);
			timerToPlaySoundMauBinhLose.addEventListener(TimerEvent.TIMER_COMPLETE, onPlaySoundMaubinhLose)
			timerToPlaySoundMauBinhLose.start();
		}
		
		private function onPlaySoundMaubinhLose(e:TimerEvent):void 
		{
			if (!stage)
				return;
			if (playerMauBinh != belowUserInfo)
				SoundManager.getInstance().soundManagerMauBinh.playMauBinhLosePlayerSound(mainData.chooseChannelData.myInfo.sex);
		}
		
		private function onHideMauBinh(e:TimerEvent):void 
		{
			if (!stage)
				return;
			maubinh.visible = false;
		}
		
		private function onHightlineGroupTwo(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			showGroupNumber(2);
			
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			var timerToHightlineGroupThree:Timer = new Timer(time * 1000, 1);
			timerToHightlineGroupThree.addEventListener(TimerEvent.TIMER_COMPLETE, onHightlineGroupThree);
			timerToHightlineGroupThree.start();
		}
		
		private function onHightlineGroupThree(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			showGroupNumber(3);
			
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			if (compareGroupData[DataFieldMauBinh.IS_SAP_HAM])
			{
				var timerToShowSapHam:Timer = new Timer(time * 1000, 1);
				timerToShowSapHam.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSapHam);
				timerToShowSapHam.start();
			}
			else if (compareGroupData[DataFieldMauBinh.IS_SO_AT])
			{
				var timerToShowSoAt:Timer = new Timer(time * 1000, 1);
				timerToShowSoAt.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSoAt);
				timerToShowSoAt.start();
			}
			else
			{
				timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
				timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.start();
			}
		}
		
		private function onShowSapHam(e:TimerEvent):void 
		{
			if (!stage)
				return;
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			
			SoundManager.getInstance().playSound(SoundLibChung.MORE_COMPARE_SOUND);
			
			setCompareGroupStatus(SAP_HAM_INDEX);
			
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			var p1:Point;
			var p2:Point;
			
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					PlayerInfoMauBinh(playingPlayerArray[j]).removeHightline();
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						if (resultArray[i][DataFieldMauBinh.HE_SO_SAP] != undefined)
						{
							var groupNumber:int = resultArray[i][DataFieldMauBinh.HE_SO_SAP];
							p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
							p2 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).groupResultEffectPosition);
							
							if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
							{
								if (resultArray[i][DataFieldMauBinh.SAP_HAM] || resultArray[i][DataFieldMauBinh.BAT_SAP_HAM])
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
								if (resultArray[i][DataFieldMauBinh.HE_SO_SAP] > 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, '-16');
								else if (resultArray[i][DataFieldMauBinh.HE_SO_SAP] < 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, '-15');
							}
							else
							{
								if (resultArray[i][DataFieldMauBinh.SAP_HAM] || resultArray[i][DataFieldMauBinh.BAT_SAP_HAM])
									effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber);
								if (resultArray[i][DataFieldMauBinh.HE_SO_SAP] > 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 1, '-16');
								else if (resultArray[i][DataFieldMauBinh.HE_SO_SAP] < 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 1, '-15');
							}
						}
					}
				}
			}
			
			if (compareGroupData[DataFieldMauBinh.IS_SAP_LANG])
			{
				var timerToShowSapLang:Timer = new Timer(time * 1000, 1);
				timerToShowSapLang.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSapLang);
				timerToShowSapLang.start();
			}
			else if (compareGroupData[DataFieldMauBinh.IS_BAT_SAP_LANG])
			{
				var timerToShowBatSapLang:Timer = new Timer(time * 1000, 1);
				timerToShowBatSapLang.addEventListener(TimerEvent.TIMER_COMPLETE, onShowBatSapLang);
				timerToShowBatSapLang.start();
			}
			else if (compareGroupData[DataFieldMauBinh.IS_SO_AT])
			{
				var timerToShowSoAt:Timer = new Timer(time * 1000, 1);
				timerToShowSoAt.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSoAt);
				timerToShowSoAt.start();
			}
			else
			{
				timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
				timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.start();
			}
		}
		
		private function onShowSapLang(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			SoundManager.getInstance().playSound(SoundLibChung.MORE_COMPARE_SOUND);
			
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			var p1:Point;
			var p2:Point;
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			
			setCompareGroupStatus(SAP_LANG_INDEX);
			
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						if (resultArray[i][DataFieldMauBinh.HE_SO_SAP_LANG] != 0)
						{
							var groupNumber:int = resultArray[i][DataFieldMauBinh.HE_SO_SAP_LANG];
							p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
							p2 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).groupResultEffectPosition);
							
							if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
							{
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
								if (resultArray[i][DataFieldMauBinh.HE_SO_SAP_LANG] < 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, '-17');
							}
							else
							{
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber);
								if (resultArray[i][DataFieldMauBinh.HE_SO_SAP_LANG] < 0)
									effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 1, '-17');
							}
						}
					}
				}
			}
			
			if (compareGroupData[DataFieldMauBinh.IS_BAT_SAP_LANG])
			{
				var timerToShowBatSapLang:Timer = new Timer(time * 1000, 1);
				timerToShowBatSapLang.addEventListener(TimerEvent.TIMER_COMPLETE, onShowBatSapLang);
				timerToShowBatSapLang.start();
			}
			else if (compareGroupData[DataFieldMauBinh.IS_SO_AT])
			{
				var timerToShowSoAt:Timer = new Timer(time * 1000, 1);
				timerToShowSoAt.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSoAt);
				timerToShowSoAt.start();
			}
			else
			{
				timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
				timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.start();
			}
		}
		
		private function onShowBatSapLang(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			SoundManager.getInstance().playSound(SoundLibChung.MORE_COMPARE_SOUND);
				
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			var p1:Point;
			var p2:Point;
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			
			setCompareGroupStatus(BAT_SAP_LANG_INDEX);
			
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						var groupNumber:int = resultArray[i][DataFieldMauBinh.HE_SO_BAT_SAP_LANG];
						p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
						p2 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).groupResultEffectPosition);
						
						if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
						{
							effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
							if (resultArray[i][DataFieldMauBinh.HE_SO_BAT_SAP_LANG] > 0)
								effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 0, '-18');
						}
						else
						{
							effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber);
							if (resultArray[i][DataFieldMauBinh.HE_SO_BAT_SAP_LANG] > 0)
								effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, time, 1, '-18');
						}
					}
				}
			}
			
			if (compareGroupData[DataFieldMauBinh.IS_SO_AT])
			{
				var timerToShowSoAt:Timer = new Timer(time * 1000, 1);
				timerToShowSoAt.addEventListener(TimerEvent.TIMER_COMPLETE, onShowSoAt);
				timerToShowSoAt.start();
			}
			else
			{
				timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
				timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
				timerToResetMatch.start();
			}
		}
		
		private function onShowSoAt(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			SoundManager.getInstance().playSound(SoundLibChung.MORE_COMPARE_SOUND);
				
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			var p1:Point;
			var time:int = mainData.init.gameDescription.playingScreen.showGroupTime;
			
			setCompareGroupStatus(SO_AT_INDEX);
			
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					PlayerInfoMauBinh(playingPlayerArray[j]).removeHightline();
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						if (resultArray[i][DataFieldMauBinh.BONUS_CHI] != 0)
						{
							var groupNumber:int = resultArray[i][DataFieldMauBinh.BONUS_CHI];
							p1 = PlayerInfoMauBinh(playingPlayerArray[j]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[j]).moneyEffectPosition);
							
							if (PlayerInfoMauBinh(playingPlayerArray[j]) == belowUserInfo)
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber, PlayerInfoMauBinh.BELOW_USER);
							else
								effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, time, groupNumber);
						}
					}
					PlayerInfoMauBinh(playingPlayerArray[j]).showAt();
				}
			}
			
			timerToResetMatch = new Timer(mainData.resetMatchTime * 1000, 1);
			timerToResetMatch.addEventListener(TimerEvent.TIMER_COMPLETE, onResetMatch);
			timerToResetMatch.start();
		}
		
		private function onResetMatch(e:TimerEvent):void 
		{
			if (!stage)
				return;
			
			updateMoney();
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			resultArray.sortOn(DataFieldMauBinh.TOTAL, Array.NUMERIC);
			resultArray.reverse();
			
			if (!playingPlayerArray)
				return;
			for (var i:int = 0; i < resultArray.length; i++) 
			{
				for (var j:int = 0; j < playingPlayerArray.length; j++) 
				{
					if (PlayerInfoMauBinh(playingPlayerArray[j]).userName == resultArray[i][DataFieldMauBinh.USER_NAME])
					{
						if (resultArray[i][DataFieldMauBinh.TOTAL] > 0 && i == 0)
							SoundManager.getInstance().soundManagerMauBinh.playOtherWinPlayerSound(playingPlayerArray[j].sex);
						if (resultArray[i][DataFieldMauBinh.TOTAL] > 0)
							PlayerInfoMauBinh(playingPlayerArray[j]).setStatus('win');
						else if (resultArray[i][DataFieldMauBinh.TOTAL] < 0)
							PlayerInfoMauBinh(playingPlayerArray[j]).setStatus('lose');
						else
							PlayerInfoMauBinh(playingPlayerArray[j]).setStatus('');
					}
				}
			}
			
			timerToShowResultWindow = new Timer(3000, 1);
			timerToShowResultWindow.addEventListener(TimerEvent.TIMER_COMPLETE, onShowResultWindow);
			timerToShowResultWindow.start();
			
			isEnableKickOut = true;
			isPlaying = false;
			
			var timerToHideAllStatus:Timer = new Timer(8000, 1);
			timerToHideAllStatus.addEventListener(TimerEvent.TIMER_COMPLETE, onHideAllStatus);
			timerToHideAllStatus.start();
		}
		
		private function onShowResultWindow(e:TimerEvent):void 
		{
			isShowResultWindow = true;
			var playerList:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST] as Array;
			var quiterList:Array = compareGroupData[DataFieldMauBinh.QUITERS] as Array;
			
			for (var i:int = 0; i < playerList.length; i++) 
			{
				if (!playerList[i][DataFieldMauBinh.TOTAL])
					playerList[i][DataFieldMauBinh.TOTAL] = 0;
			}
			
			playerList = playerList.concat(quiterList);
			
			resultWindow = new ResultWindowMauBinh();
			resultWindow.addEventListener(PlayerInfoMauBinh.EXIT, onExitButtonClick);
			resultWindow.setInfo(playerList);
			windowLayer.openWindow(resultWindow);
			
			var resultArray:Array = compareGroupData[DataFieldMauBinh.PLAYER_LIST];
			
			if (belowUserInfo.isRoomMaster)
			{
				for (i = 0; i < userListJoinWhenCompareGroup.length; i++)
				{
					electroServerCommand.sendCompareGroupStatus('', [userListJoinWhenCompareGroup[i]]);
				}
			}
			
			for (i = 0; i < resultArray.length; i++) 
			{
				if (belowUserInfo.userName == resultArray[i][DataFieldMauBinh.USER_NAME])
				{
					if (resultArray[i][DataFieldMauBinh.TOTAL] == 0)
					{
						SoundManager.getInstance().playSound(SoundLibChung.LOSE_SOUND);
						SoundManager.getInstance().soundManagerMauBinh.playDrawPlayerSound(belowUserInfo.sex);
					}
					else if (resultArray[i][DataFieldMauBinh.TOTAL] < 0)
					{
						SoundManager.getInstance().playSound(SoundLibChung.LOSE_SOUND);
						if (mainData.chooseChannelData.myInfo.money <= Number(mainData.playingData.gameRoomData.roomBet))
							SoundManager.getInstance().soundManagerMauBinh.playLoseAllPlayerSound(belowUserInfo.sex);
						else
							SoundManager.getInstance().soundManagerMauBinh.playLosePlayerSound(belowUserInfo.sex);
					}
					else
					{
						SoundManager.getInstance().playSound(SoundLibChung.WIN_SOUND);
					}
				}
			}
		}
		
		private function onHideAllStatus(e:TimerEvent):void 
		{
			if (!stage)
				return;
				
			for (var k:int = 0; k < allPlayerArray.length; k++) // Thông báo cho những user vừa vào biết là đọ chi xong
			{
				if (PlayerInfoMauBinh(allPlayerArray[k]))
				{
					PlayerInfoMauBinh(allPlayerArray[k]).setStatus('');
					if (!PlayerInfoMauBinh(allPlayerArray[k]).unLeaveCards)
					{
						electroServerCommand.sendPrivateMessage([PlayerInfoMauBinh(allPlayerArray[k]).userName], Command.COMPARE_GROUP_COMPLETE, new EsObject());
					}
					else
					{
						if (PlayerInfoMauBinh(allPlayerArray[k]).unLeaveCards.length == 0)
							electroServerCommand.sendPrivateMessage([PlayerInfoMauBinh(allPlayerArray[k]).userName], Command.COMPARE_GROUP_COMPLETE, new EsObject());
					}
				}
			}
			
			// Nếu không đủ tiền để chơi ván mới
			if (mainData.chooseChannelData.myInfo.money < Number(mainData.playingData.gameRoomData.roomBet) * mainData.minBetRate)
			{
				dispatchEvent(new Event(PlayerInfoMauBinh.EXIT));
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
			dispatchEvent(new Event(PlayerInfoMauBinh.EXIT));
			electroServerCommand.joinLobbyRoom();
		}
		
		private function resetMatch():void // reset ván bài
		{
			SoundManager.getInstance().soundManagerMauBinh.playStartGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
			isResetDone = true;
			setCompareGroupStatus();
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
				{
					PlayerInfoMauBinh(allPlayerArray[i]).isFirstClick = true;
					PlayerInfoMauBinh(allPlayerArray[i]).removeAllCards();
				}
			}
			if (destroyPlayerArray)
			{
				for (i = 0; i < destroyPlayerArray.length; i++)
				{
					PlayerInfoMauBinh(destroyPlayerArray[i]).destroy();
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
							if (PlayerInfoMauBinh(allPlayerArray[j]).isReadyPlay)
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
							if (PlayerInfoMauBinh(allPlayerArray[j]).isReadyPlay)
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
			
			if (giveUpPlayerArray)
			{
				for (i = 0; i < giveUpPlayerArray.length ; i++) 
				{
					var giveUpObject:Dictionary = giveUpPlayerArray[i];
					PlayerInfoMauBinh(giveUpObject[DataFieldMauBinh.PLAYER]).destroy();
				}
			}
		}
		
		public function addPlayer():void // add người chơi - tùy thuộc số lượng
		{
			addOnePlayer(0);
			addOnePlayer(1);
			addOnePlayer(3);
			addOnePlayer(2);
			
			belowUserInfo.cardInfoArray = [10, 11, 12, 13, 14, 4, 5, 6, 7, 8, 52, 51, 1];
			//belowUserInfo.cardInfoArray = [22, 1, 21, 2, 4, 3, 19, 23, 24, 25];
			//belowUserInfo.cardInfoArray = [1, 2, 6, 3, 8, 7, 40, 41, 42, 28];
			
			leftUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			rightUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			aboveUserInfo.cardInfoArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			
			addCardManager();
			playingPlayerArray = new Array();
			for (var i:int = 0; i < allPlayerArray.length; i++) 
			{
				if (allPlayerArray[i])
					playingPlayerArray.push(allPlayerArray[i]);
			}
			cardManager.playerArray = playingPlayerArray;
			cardManager.divideCard();
			
			var tempTimer:Timer = new Timer(4000, 1);
			tempTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			tempTimer.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			//belowUserInfo.countTime(61);
			waitToPlay.visible = false;
			waitToStart.visible = false;
			var p1:Point;
			var p2:Point;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				p1 = PlayerInfoMauBinh(playingPlayerArray[i]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[i]).moneyEffectPosition);
				PlayerInfoMauBinh(playingPlayerArray[i]).addValueForOneGroup(1, [4, 5, 6, 7, 8]);
				PlayerInfoMauBinh(playingPlayerArray[i]).addValueForOneGroup(2, [10, 11, 12, 13, 14]);
				PlayerInfoMauBinh(playingPlayerArray[i]).addValueForOneGroup(3, [52, 51, 1]);
				//PlayerInfo(playingPlayerArray[i]).reAddAllCard();
				PlayerInfoMauBinh(playingPlayerArray[i]).openAllCard();
				//effectLayer.addEffect(EffectLayer.MONEY_EFFECT, p1, 10000, 100000000);
				//effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, 10000, 0, "Năm đôi một sám");
				
				p1 = PlayerInfoMauBinh(playingPlayerArray[i]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[i]).moneyEffectPosition);
				effectLayer.addEffect(EffectLayer.GROUP_NAME_EFFECT_MAU_BINH, p1, 10000, 5);
				
				p2 = PlayerInfoMauBinh(playingPlayerArray[i]).localToGlobal(PlayerInfoMauBinh(playingPlayerArray[i]).groupResultEffectPosition);
				if (playingPlayerArray[i] == belowUserInfo)
					effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2, 10000, 0, "lucphebon");
				else
					effectLayer.addEffect(EffectLayer.GROUP_RESULT_EFFECT, p2,10000, 1, "lucphebon");
			}
			
			/*specialGroupWindow = new SpecialGroupWindow();
			specialGroupWindow.setType(17);
			specialGroupWindow.addCard([5, 13, 3, 26, 1, 31, 14, 42, 9, 22, 11, 37, 50]);
			windowLayer.openWindow(specialGroupWindow);*/
			
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
					addPlayerByType(PlayerInfoMauBinh.BELOW_USER, position, true);
					// Lắng nghe đến lượt mình bốc bài thì thông báo cho cardManager
				break;
				case 1:
					addPlayerByType(PlayerInfoMauBinh.RIGHT_USER, position, false);
				break;
				case 2:
					addPlayerByType(PlayerInfoMauBinh.ABOVE_USER, position, false);
				break;
				case 3:
					addPlayerByType(PlayerInfoMauBinh.LEFT_USER, position, false);
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
					if (PlayerInfoMauBinh(allPlayerArray[i]).position == data[DataFieldMauBinh.POSITION])
					{
						PlayerInfoMauBinh(allPlayerArray[i]).updatePersonalInfo(data);
						if (data[DataFieldMauBinh.READY])
						{
							//isHaveUserReady = true;
							PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay = true;
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
					if (PlayerInfoMauBinh(allPlayerArray[i]).position == data[DataFieldMauBinh.POSITION])
					{
						cardManager.addAllCard(allPlayerArray[i], data);
						PlayerInfoMauBinh(allPlayerArray[i]).isPlaying = true;
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
					if (PlayerInfoMauBinh(allPlayerArray[i]).position == position)
					{
						if (isPlaying)
						{
							for (var j:int = 0; j < playingPlayerArray.length; j++) 
							{
								if (PlayerInfoMauBinh(allPlayerArray[i]) == PlayerInfoMauBinh(playingPlayerArray[j]))
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
								if (PlayerInfoMauBinh(allPlayerArray[i]) == PlayerInfoMauBinh(playingPlayerArray[j]))
								{
									PlayerInfoMauBinh(allPlayerArray[i]).hideAllInfo();
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
						PlayerInfoMauBinh(this[PlayerInfoMauBinh.BELOW_USER]).removeEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoMauBinh(this[PlayerInfoMauBinh.BELOW_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoMauBinh.BELOW_USER]);
					break;
					case 1:
						PlayerInfoMauBinh(this[PlayerInfoMauBinh.RIGHT_USER]).removeEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoMauBinh(this[PlayerInfoMauBinh.RIGHT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoMauBinh.RIGHT_USER]);
					break;
					case 2:
						PlayerInfoMauBinh(this[PlayerInfoMauBinh.ABOVE_USER]).removeEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoMauBinh(this[PlayerInfoMauBinh.ABOVE_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoMauBinh.ABOVE_USER]);
					break;
					case 3:
						PlayerInfoMauBinh(this[PlayerInfoMauBinh.LEFT_USER]).removeEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
						if (!isPlayingUser)
							PlayerInfoMauBinh(this[PlayerInfoMauBinh.LEFT_USER]).destroy();
						else
							destroyPlayerArray.push(this[PlayerInfoMauBinh.LEFT_USER]);
					break;
				}
				
				if (position != 0)
					invitePlayButtonArray[position - 1].visible = true;
			}
			else if (isPlaying)
			{
				var giveUpPlayer:PlayerInfoMauBinh;
				switch (position) 
				{
					case 1:
						giveUpPlayer = rightUserInfo;
					break;
					case 2:
						giveUpPlayer = aboveUserInfo;
					break;
					case 3:
						giveUpPlayer = leftUserInfo;
					break;
				}
				
				giveUpPlayer.isGiveUp = true;
				var giveUpObject:Dictionary = new Dictionary();
				giveUpObject[DataFieldMauBinh.PLAYER] = giveUpPlayer
				giveUpObject[DataFieldMauBinh.POSITION] = position;
				
				var timerToRemoveGiveUpPlayer:Timer = new Timer(5000, 1);
				timerToRemoveGiveUpPlayer.addEventListener(TimerEvent.TIMER_COMPLETE, onRemoveGiveUpPlayer);
				timerToRemoveGiveUpPlayer.start();
				
				giveUpObject[DataFieldMauBinh.TIME] = timerToRemoveGiveUpPlayer;
				
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
					if (giveUpObject[DataFieldMauBinh.TIME] == e.currentTarget)
					{
						if (giveUpObject[DataFieldMauBinh.POSITION] != 0)
							invitePlayButtonArray[giveUpObject[DataFieldMauBinh.POSITION] - 1].visible = true;
						PlayerInfoMauBinh(giveUpObject[DataFieldMauBinh.PLAYER]).destroy();
						giveUpPlayerArray.splice(i, 1);
						break;
					}
				}
			}
		}
		
		private function addPlayerByType(playerType:String, position:int, isCardInteractive:Boolean = false):void
		{
			this[playerType] = new PlayerInfoMauBinh();
			this[playerType].addEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
			PlayerInfoMauBinh(this[playerType]).position = position;
				
			// Có cho phép tương tác vào quân bài của người chơi này không
			PlayerInfoMauBinh(this[playerType]).isCardInteractive = isCardInteractive;
			
			PlayerInfoMauBinh(this[playerType]).setForm(playerType);
				
			this[playerType].x = Math.round(content[playerType + "Position"].x);
			this[playerType].y = Math.round(content[playerType + "Position"].y);
			playingLayer.addChild(this[playerType]);
			allPlayerArray[position] = this[playerType];
		}
		
		private function onShowContextMenu(e:Event):void 
		{
			var userData:UserDataULC = new UserDataULC();
			userData.levelName = String(PlayerInfoMauBinh(e.currentTarget).levelNumber);
			userData.money = String(PlayerInfoMauBinh(e.currentTarget).moneyNumber);
			userData.displayName = PlayerInfoMauBinh(e.currentTarget).displayName;
			userData.avatar = PlayerInfoMauBinh(e.currentTarget).avatarString;
			userData.userName = PlayerInfoMauBinh(e.currentTarget).userName;
			userData.isFriend = false;
			for (var i:int = 0; i < mainData.lobbyRoomData.friendList.length; i++) 
			{
				if (UserDataULC(mainData.lobbyRoomData.friendList[i]).userName == userData.userName)
				{
					userData.isFriend = true;
					break;
				}
			}
			userData.win = PlayerInfoMauBinh(e.currentTarget).win;
			userData.lose = PlayerInfoMauBinh(e.currentTarget).lose;
			
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
			confirmKickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmKickOut + " " + myContextMenu.data[DataFieldMauBinh.DISPLAY_NAME]);
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
			electroServerCommand.kickUser(myContextMenu.data[DataFieldMauBinh.USER_NAME]);
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
						var tempPlayer:PlayerInfoMauBinh = playingPlayerArray[i];
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
				cardManager = new CardManagerMauBinh();
				cardManager.addEventListener(CardManagerMauBinh.DIVIDE_FINISH, onDivideFinish);
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
			
			if (belowUserInfo.isPlaying)
			{
				belowUserInfo.arrangeFinishButton.visible = true;
				belowUserInfo.reArrangeButton.visible = false;
			}
			belowUserInfo.countTime(mainData.init.gameDescription.playingScreen.arrangeCardTime);
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
						if (data[DataFieldMauBinh.USER_NAME] == PlayerInfoMauBinh(allPlayerArray[i]).userName)
							PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay = true;
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
					if (data[DataFieldMauBinh.USER_NAME] == PlayerInfoMauBinh(allPlayerArray[i]).userName)
					{
						PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay = true;
						if (allPlayerArray[i] == belowUserInfo)
						{
							hideReadyButton();
							waitToStart.visible = true;
						}
					}
					if (PlayerInfoMauBinh(allPlayerArray[i]).isReadyPlay)
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
				if (userList[i][DataFieldMauBinh.USER_NAME] == mainData.chooseChannelData.myInfo.uId)
				{
					jumpIndex = userList[i][DataFieldMauBinh.POSITION];
					i = userList.length;
				}
			}
			if (jumpIndex != 0)
			{
				for (i = 0; i < userList.length; i++) 
				{
					userList[i][DataFieldMauBinh.POSITION] -= jumpIndex;
					if (userList[i][DataFieldMauBinh.POSITION] < 0)
						userList[i][DataFieldMauBinh.POSITION] += mainData.maxPlayer;
				}
			}
		}
		
		public function destroy():void
		{
			if (timerToShowResultWindow)
			{
				timerToShowResultWindow.removeEventListener(TimerEvent.TIMER_COMPLETE, onShowResultWindow);
				timerToShowResultWindow.stop();
				timerToShowResultWindow = null;
			}
			
			if (allPlayerArray)
			{
				for (var i:int = 0; i < allPlayerArray.length; i++) 
				{
					if (allPlayerArray[i])
					{
						PlayerInfoMauBinh(allPlayerArray[i]).removeEventListener(PlayerInfoMauBinh.AVATAR_CLICK, onShowContextMenu);
						PlayerInfoMauBinh(allPlayerArray[i]).destroy();
					}
				}
			}
			allPlayerArray = null;
			
			if (cardManager)
			{
				removeEventListener(CardManagerMauBinh.DIVIDE_FINISH, onDivideFinish);
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