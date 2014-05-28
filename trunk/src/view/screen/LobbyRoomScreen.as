package view.screen 
{
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import model.ChannelData;
	import model.chooseChannelData.ChooseChannelData;
	import RoomListComponent
	import sound.SoundLibChung;
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	import view.channelList.ChannelList;
	import view.SelectGameWindow;
	import view.window.AddFriendWindow;
	import view.window.BaseWindow;
	import view.window.loginWindow.LoginWindow;
	import view.window.ScoreWindow;
	
	
	import com.ComponentTLMNSocial.ComboBoxClass.MyComboBox;
	import com.electrotank.electroserver5.api.EsObject;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import control.MainCommand;
	import event.Command;
	import event.DataFieldMauBinh;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import view.window.AccuseWindow;
	import view.window.AlertWindow;
	import view.window.ConfirmInvitePlayWindow;
	import view.window.ConfirmWindow;
	import view.window.CreateRoomWindow;
	import view.window.JoinRoomWindow;
	import view.window.SearchRoomWindow;
	import view.window.windowLayer.WindowLayer;	
	/**
	 * ...
	 * @author Yun
	 */
	public class LobbyRoomScreen extends BaseScreen 
	{
		public static const BACK_TO_CHOOSE_CHANNEL_SCREEN:String = "backToChooseChannelScreen";
		public static const CLOSE_COMPLETE:String = "closeComplete";
		
		private var roomList:RoomListComponent;
		private var userList:UserListComponent;
		private var chatBox:ChatBoxLobby;
		private var messageBox:ChatBoxLobby;
		
		private var background:Sprite;
		
		private var createRoomWindow:CreateRoomWindow;
		private var searchRoomWindow:SearchRoomWindow;
		private var joinRoomWindow:JoinRoomWindow;
		private var effectTime:Number = 0.2;
		
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		private var isHideFullRoom:Boolean;
		private var lobbyBtn:MovieClip;
		private var friendBtn:MovieClip;
		
		private var channelButtonArray:Array;
		private var channelButtonStartYArray:Array;
		private var addMoneyButton:SimpleButton;
		private var shopButton:SimpleButton;
		private var inventoryButton:SimpleButton;
		private var eventButton:SimpleButton;
		private var fanPageButton:SimpleButton;
		private var selectGameButton:SimpleButton;
		private var channelList:ChannelList;
		
		private var chatButton:Sprite;
		private var messageButton:MovieClip;
		private var exitButton:SimpleButton;
		private var helpButton:SimpleButton;
		private var soundOnButton:SimpleButton;
		private var soundOffButton:SimpleButton;
		private var musicOnButton:SimpleButton;
		private var musicOffButton:SimpleButton;
		private var sharedObject:SharedObject;
		
		private var channelInfoTxt:TextField;
		private var currentChannelButton:*;
		
		private var selectGameWindow:SelectGameWindow;
		private var timerToGetChannelInfo:Timer;
		private var smallButtonMenu:Sprite;
		private var buttonMenu:Sprite;
		
		public function LobbyRoomScreen() 
		{
			super();
			addContent("zLobbyRoomScreen");
			addRoomList();
			addUserList();
			addUserProfile();
			background = content["background"];
			addChannelButton();
			addOtherButton();
			channelInfoTxt = content["channelInfoTxt"];
			channelInfoTxt.selectable = false;
			channelInfoTxt.mouseEnabled = false;
			channelInfoTxt.text = '';
			channelInfoTxt.visible = false;
			
			lobbyBtn = content["lobbyBtn"];
			friendBtn = content["friendBtn"];
			addChild(lobbyBtn);
			addChild(friendBtn);
			
			chatBox = new ChatBoxLobby();
			chatBox.addEventListener(ChatBox.HAVE_CHAT, onHaveChat);
			chatBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onCloseChatBox);
			
			messageBox = new ChatBoxLobby();
			messageBox.addEventListener(ChatBox.BACK_BUTTON_CLICK, onCloseMessageBox);
			messageBox.enable = false;
			messageBox.inputText.visible = false;
			
			lobbyBtn.addEventListener(MouseEvent.CLICK, onChangeUserListButtonClick);
			friendBtn.addEventListener(MouseEvent.CLICK, onChangeUserListButtonClick);
			lobbyBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			friendBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			lobbyBtn.gotoAndStop("selected");
			lobbyBtn.buttonMode = lobbyBtn.mouseChildren = lobbyBtn.mouseEnabled = false;
			friendBtn.buttonMode = true;
			
			scrollRect = new Rectangle(0, 0, mainData.stageWidth, mainData.stageHeight);
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_MONEY, onUpdateMoney);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if (!selectGameWindow)
			{	
				selectGameWindow = new SelectGameWindow();
				selectGameWindow.addEventListener(SelectGameWindow.SELECT_GAME, onSelectGame);
				selectGameWindow.addEventListener(SelectGameWindow.RE_LOGIN_CLICK, onReLoginClick);
				selectGameWindow.x = mainData.stageWidth / 2;
				selectGameWindow.y = mainData.stageHeight / 2;
				selectGameWindow.visible = true;
			}
			addChild(selectGameWindow);
			
			var loginWindow:LoginWindow = new LoginWindow();
			windowLayer.openWindow(loginWindow);
			
			selectGameButton.addEventListener(MouseEvent.CLICK, onSelectGameButtonClick);
			
		}
		
		private function onCloseMessageBox(e:Event):void 
		{
			removeChild(messageBox);
		}
		
		private function onSelectGameButtonClick(e:MouseEvent):void 
		{
			mainCommand.electroServerCommand.closeConnection();
			if (!selectGameWindow)
			{	
				selectGameWindow = new SelectGameWindow();
				selectGameWindow.addEventListener(SelectGameWindow.SELECT_GAME, onSelectGame);
				selectGameWindow.addEventListener(SelectGameWindow.RE_LOGIN_CLICK, onReLoginClick);
				selectGameWindow.x = mainData.stageWidth / 2;
				selectGameWindow.y = mainData.stageHeight / 2;
				selectGameWindow.visible = true;
			}
			addChild(selectGameWindow);
			smallButtonMenu.visible = true;
			buttonMenu.visible = false;
		}
		
		private function onSelectGame(e:Event):void 
		{
			if (selectGameWindow)
			{
				if (selectGameWindow.parent)
					selectGameWindow.parent.removeChild(selectGameWindow);
			}
			
			mainCommand.getInfoCommand.getChannelInfo();
			mainCommand.getInfoCommand.getMessageInfo();
			
			if (timerToGetChannelInfo)
			{
				timerToGetChannelInfo.removeEventListener(TimerEvent.TIMER, onTimerToGetChannelInfo);
				timerToGetChannelInfo.start();
			}
			timerToGetChannelInfo = new Timer(4000)
			timerToGetChannelInfo.addEventListener(TimerEvent.TIMER, onTimerToGetChannelInfo);
			timerToGetChannelInfo.start();
		}
		
		private function onTimerToGetChannelInfo(e:TimerEvent):void 
		{
			mainCommand.getInfoCommand.getChannelInfo();
		}
		
		private function onReLoginClick(e:Event):void 
		{
			var loginWindow:LoginWindow = new LoginWindow();
			windowLayer.openWindow(loginWindow);
		}
		
		public function showLoginWindow():void
		{
			if (!selectGameWindow)
			{	
				selectGameWindow = new SelectGameWindow();
				selectGameWindow.addEventListener(SelectGameWindow.SELECT_GAME, onSelectGame);
				selectGameWindow.addEventListener(SelectGameWindow.RE_LOGIN_CLICK, onReLoginClick);
				selectGameWindow.x = mainData.stageWidth / 2;
				selectGameWindow.y = mainData.stageHeight / 2;
				selectGameWindow.visible = true;
			}
			addChild(selectGameWindow);
			
			var loginWindow:LoginWindow = new LoginWindow();
			windowLayer.openWindow(loginWindow);
			
			
		}
		
		private function addChannelButton():void 
		{
			smallButtonMenu = content["smallButtonMenu"];
			smallButtonMenu.addEventListener(MouseEvent.CLICK, onSmallButtonMenuClick);
			buttonMenu = content["buttonMenu"];
			buttonMenu.visible = false;
			
			channelButtonArray = new Array();
			channelButtonStartYArray = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				channelButtonArray.push(buttonMenu["channelButton" + String(i + 1)]);
				channelButtonStartYArray.push(buttonMenu["channelButton" + String(i + 1)].y);
				buttonMenu["channelButton" + String(i + 1)].addEventListener(MouseEvent.CLICK, onChannelButtonClick);
			}
		}
		
		private function onSmallButtonMenuClick(e:MouseEvent):void 
		{
			smallButtonMenu.visible = false;
			buttonMenu.visible = true;
			addChild(buttonMenu);
			e.stopImmediatePropagation();
		}
		
		private function addOtherButton():void 
		{
			addMoneyButton = buttonMenu["addMoneyButton"];
			shopButton = buttonMenu["shopButton"];
			inventoryButton = buttonMenu["inventoryButton"];
			eventButton = buttonMenu["eventButton"];
			fanPageButton = buttonMenu["fanPageButton"];
			selectGameButton = buttonMenu["selectGameButton"];
			
			addMoneyButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			shopButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			inventoryButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			eventButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			fanPageButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			selectGameButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			
			
			chatButton = content["chatButton"];
			messageButton = content["messageButton"];
			messageButton["messNumberTxt"].text = '';
			exitButton = content["exitButton"];
			helpButton = content["helpButton"];
			soundOnButton = content["soundOnButton"];
			soundOffButton = content["soundOffButton"];
			musicOnButton = content["musicOnButton"];
			musicOffButton = content["musicOffButton"];
			
			addChild(userList);
			addChild(soundOnButton);
			addChild(soundOffButton);
			addChild(musicOnButton);
			addChild(musicOffButton);
			addChild(chatButton);
			addChild(messageButton);
			
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
			
			chatButton.addEventListener(MouseEvent.CLICK, onChatButtonClick);
			messageButton.addEventListener(MouseEvent.CLICK, onMessageButtonClick);
			exitButton.addEventListener(MouseEvent.CLICK, onExitButtonClick);
			helpButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			soundOnButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			soundOffButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			musicOnButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
			musicOffButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick);
		}
		
		private function onChatButtonClick(e:MouseEvent):void 
		{
			addChild(chatBox);
		}
		
		private function onCloseChatBox(e:Event):void 
		{
			removeChild(chatBox);
		}
		
		private function onMessageButtonClick(e:MouseEvent):void 
		{
			messageButton.gotoAndStop(1);
			mainData.messageObject[DataFieldMauBinh.UNREAD_MESSAGE] = 0;
			messageButton["messNumberTxt"].text = '';
			addChild(messageBox);
		}
		
		private function onExitButtonClick(e:MouseEvent):void 
		{
			if (!selectGameWindow)
			{	
				selectGameWindow = new SelectGameWindow();
				selectGameWindow.addEventListener(SelectGameWindow.SELECT_GAME, onSelectGame);
				selectGameWindow.addEventListener(SelectGameWindow.RE_LOGIN_CLICK, onReLoginClick);
				selectGameWindow.x = mainData.stageWidth / 2;
				selectGameWindow.y = mainData.stageHeight / 2;
				selectGameWindow.visible = true;
			}
			addChild(selectGameWindow);
			mainCommand.electroServerCommand.closeConnection();
		}
		
		private function onMenuButtonClick(e:MouseEvent):void 
		{
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
				case helpButton:
					
				break;
				default:
			}
		}
		
		private function onOtherButtonClick(e:MouseEvent):void 
		{
			/*switch (mainData.gameType) 
			{
				case MainData.MAUBINH:
					SoundManager.getInstance().soundManagerMauBinh.playExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				case MainData.PHOM:
					SoundManager.getInstance().soundManagerPhom.playExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				default:
			}*/
		}
		
		private function onChannelButtonClick(e:MouseEvent):void 
		{
			SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
			if (currentChannelButton == e.currentTarget)
			{
				reArrageChannelButton( -1, true);
				if (channelList.parent)
					channelList.parent.removeChild(channelList);
				return;
			}
			if (e.currentTarget is MovieClip)
			{
				if (MovieClip(e.currentTarget).currentLabel == "disable")
					return;
			}
			for (var i:int = 0; i < channelButtonArray.length; i++) 
			{
				if (e.currentTarget == channelButtonArray[i])
				{
					if (i == 3) // Giải đấu
						SoundManager.getInstance().playSound(SoundLibChung.SELECT_TOURNAMENT_SOUND);
					var dataList:Array = new Array();
					for (var j:int = 0; j < mainData.chooseChannelData.channelInfoArray.length; j++) 
					{
						var channelObject:Object = mainData.chooseChannelData.channelInfoArray[j];
						var channelFirstIndex:String = String(i + 1);
						if (i == 3)
							channelFirstIndex = '9';
						if (String(channelObject[DataFieldMauBinh.CHANNEL_NUM]).charAt(0) == channelFirstIndex)
						{
							var channelData:ChannelData = new ChannelData();
							channelData.channelId = channelObject[DataFieldMauBinh.CHANNEL_NUM];
							channelData.channelName = channelObject[DataFieldMauBinh.CHANNEL_NAME];
							channelData.playerNumber = channelObject[DataFieldMauBinh.USERS_ONLINE];
							channelData.fee = channelObject[DataFieldMauBinh.DEALER_FEE];
							channelData.maxPlayer = 200;
							dataList.push(channelData);
						}
					}
					
					if (!channelList)
					{
						channelList = new ChannelList();
						channelList.addEventListener(ChannelList.CHANNEL_CLICK, onChannelClick);
					}
					buttonMenu.addChild(channelList);
					channelList.list = dataList;
					reArrageChannelButton( -1, true);
					reArrageChannelButton(i, false);
					currentChannelButton = e.currentTarget;
					channelList.x = channelButtonArray[i].x + 1;
					channelList.y = channelButtonArray[i].y + channelButtonArray[i].height;
					
					e.stopImmediatePropagation();
					return;
				}
			}
		}
		
		private function onChannelClick(e:Event):void 
		{
			SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
			mainCommand.electroServerCommand.closeConnection();
			WindowLayer.getInstance().openLoadingWindow();
			mainCommand.electroServerCommand.startConnect("", channelList.currentChannelData.channelId);
			mainData.fee = channelList.currentChannelData.fee;
			channelInfoTxt.text = mainData.gameName + " - " + channelList.currentChannelData.channelName;
			mainData.playingData.gameRoomData.channelName = channelList.currentChannelData.channelName;
		}
		
		private function reArrageChannelButton(index:int, isRollBack:Boolean):void 
		{
			if (isRollBack)
			{
				currentChannelButton = null;
				for (var i:int = 0; i < channelButtonArray.length; i++) 
				{
					channelButtonArray[i].y = channelButtonStartYArray[i];
				}
				
				addMoneyButton.y = 246;
				shopButton.y = 246;
				inventoryButton.y = 299;
				eventButton.y = 299;
				fanPageButton.y = 352;
				selectGameButton.y = 352;
				
				return;
			}
			
			for (i = 0; i < channelButtonArray.length; i++) 
			{
				if (i > index)
				{
					channelButtonArray[i].y += channelList.height;
				}
			}
			
			addMoneyButton.y += channelList.height;
			shopButton.y += channelList.height;
			inventoryButton.y += channelList.height;
			eventButton.y += channelList.height;
			fanPageButton.y += channelList.height;
			selectGameButton.y += channelList.height;
		}
		
		private function onButtonMouseDown(e:MouseEvent):void 
		{
			MovieClip(e.currentTarget).gotoAndStop("selected");
		}
		
		private function onChangeUserListButtonClick(e:MouseEvent):void 
		{
			lobbyBtn.buttonMode = lobbyBtn.mouseChildren = lobbyBtn.mouseEnabled = true;
			friendBtn.buttonMode = friendBtn.mouseChildren = friendBtn.mouseEnabled = true;
			lobbyBtn.gotoAndStop("out");
			friendBtn.gotoAndStop("out");
			
			SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
			
			switch (e.currentTarget) 
			{
				case lobbyBtn:
					lobbyBtn.buttonMode = lobbyBtn.mouseChildren = lobbyBtn.mouseEnabled = false;
					lobbyBtn.gotoAndStop("selected");
					mainData.userListState = 1;
					renderUserList();
				break;
				case friendBtn:
					friendBtn.buttonMode = friendBtn.mouseChildren = friendBtn.mouseEnabled = false;
					friendBtn.gotoAndStop("selected");
					mainData.userListState = 2;
					mainCommand.electroServerCommand.getFriendList();
				break;
				default:
			}
		}
		
		private function renderUserList():void 
		{
			lobbyBtn.buttonMode = lobbyBtn.mouseChildren = lobbyBtn.mouseEnabled = true;
			friendBtn.buttonMode = friendBtn.mouseChildren = friendBtn.mouseEnabled = true;
			
			if (userList)
			{
				if (!userList.isDraggingScroll && !roomList.isDraggingScroll)
				{
					switch (mainData.userListState) 
					{
						case 1:
							userList.userDataList = mainData.lobbyRoomData.userList;
							lobbyBtn.gotoAndStop("selected");
							lobbyBtn.buttonMode = lobbyBtn.mouseChildren = lobbyBtn.mouseEnabled = false;
						break;
						case 2:
							userList.userDataList = mainData.lobbyRoomData.friendList;
							friendBtn.gotoAndStop("selected");
							friendBtn.buttonMode = friendBtn.mouseChildren = friendBtn.mouseEnabled = false;
						break;
						default:
					}
				}
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_CHANNEL_INFO, onUpdateChannelInfo);
			mainData.addEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			mainData.addEventListener(MainData.UPDATE_MESSAGE_LIST, onUpdateMessageList);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			if (mainData.isOnAndroid)
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			buttonMenu.visible = false;
			smallButtonMenu.visible = true;
			if (!channelList)
				return;
			reArrageChannelButton( -1, true);
			if (channelList.parent)
				channelList.parent.removeChild(channelList);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			roomList.isInvite = false;
			renderInviteList();
			
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_CHANNEL_INFO, onUpdateChannelInfo);
			mainData.removeEventListener(MainData.UPDATE_PUBLIC_CHAT, onUpdatePublicChat);
			mainData.removeEventListener(MainData.UPDATE_MESSAGE_LIST, onUpdateMessageList);
			if (mainData.isOnAndroid)
				NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
				
			if (timerToGetChannelInfo)
			{
				timerToGetChannelInfo.removeEventListener(TimerEvent.TIMER, onTimerToGetChannelInfo);
				timerToGetChannelInfo.start();
			}
		}
		
		private function onUpdateMessageList(e:Event):void 
		{
			messageBox.removeAllChat();
			var messageList:Array = mainData.messageObject[DataFieldMauBinh.MESSAGE_LIST];
			for (var i:int = 0; i < messageList.length; i++) 
			{
				messageBox.addChatSentence(messageList[i][DataFieldMauBinh.CHAT_CONTENT], messageList[i][DataFieldMauBinh.SENDER], true);
			}
			
			if (messageButton.visible && mainData.messageObject[DataFieldMauBinh.UNREAD_MESSAGE] != 0)
			{
				messageButton.gotoAndStop(2);
				messageButton["messNumberTxt"].text = mainData.messageObject[DataFieldMauBinh.UNREAD_MESSAGE];
			}
			else
			{
				mainData.messageObject[DataFieldMauBinh.UNREAD_MESSAGE] = 0;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 16777238:
					
				if (mainData.isOnLoginWindow)
					return;
				if (mainData.isOnSelectGameWindow)
				{
					mainData.isLogOut = true;
					e.preventDefault();
					e.stopImmediatePropagation();
					e.stopPropagation();
					return;
				}
					
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				
				if (!selectGameWindow)
				{	
					selectGameWindow = new SelectGameWindow();
					selectGameWindow.addEventListener(SelectGameWindow.SELECT_GAME, onSelectGame);
					selectGameWindow.addEventListener(SelectGameWindow.RE_LOGIN_CLICK, onReLoginClick);
					selectGameWindow.x = mainData.stageWidth / 2;
					selectGameWindow.y = mainData.stageHeight / 2;
					selectGameWindow.visible = true;
				}
				addChild(selectGameWindow);
				mainCommand.electroServerCommand.closeConnection();
				break;
			}
		}
		
		private function onUpdateChannelInfo(e:Event):void 
		{
			if (mainData.isFirstJoinLobby)
			{
				var channelObject:Object = mainData.chooseChannelData.channelInfoArray[0];
				WindowLayer.getInstance().openLoadingWindow();
				mainCommand.electroServerCommand.startConnect("", channelObject[DataFieldMauBinh.CHANNEL_NUM]);
				mainData.fee = channelObject[DataFieldMauBinh.DEALER_FEE];
				channelInfoTxt.text = mainData.gameName + " - " + channelObject[DataFieldMauBinh.CHANNEL_NAME];
				mainData.playingData.gameRoomData.channelName = channelObject[DataFieldMauBinh.CHANNEL_NAME];
				
				switch (mainData.gameType) 
				{
					case MainData.MAUBINH:
						SoundManager.getInstance().soundManagerMauBinh.playLobbyPlayerSound(mainData.chooseChannelData.myInfo.sex);
					break;
					case MainData.PHOM:
						SoundManager.getInstance().soundManagerPhom.playLobbyPlayerSound(mainData.chooseChannelData.myInfo.sex);
					break;
					default:
				}
			}
			
			if (!SoundManager.getInstance().isLoadMusicBackground)
				SoundManager.getInstance().loadBackgroundMusic();
			
			var i:int;
			var j:int;
			if (mainData.currentChannelId == 0)
			{
				channelObject = mainData.chooseChannelData.channelInfoArray[0];
			}
			else
			{
				for (i = 0; i < mainData.chooseChannelData.channelInfoArray.length; i++)
				{
					channelObject = mainData.chooseChannelData.channelInfoArray[i];
					if (int(channelObject[DataFieldMauBinh.CHANNEL_NUM]) == mainData.currentChannelId)
						break;
				}
			}
			mainData.playingData.gameRoomData.betting = String(channelObject[DataFieldMauBinh.BETS]).split(',');
			
			mainData.isFirstJoinLobby = false;
			
			for (i = 0; i < channelButtonArray.length; i++) 
			{
				if (i != 3)
				{
					var onlinePlayer:int = 0;
					var minLevel:int = 0;
					for (j = 0; j < mainData.chooseChannelData.channelInfoArray.length; j++) 
					{
						channelObject = mainData.chooseChannelData.channelInfoArray[j];
						var channelFirstIndex:String = String(i + 1);
						if (String(channelObject[DataFieldMauBinh.CHANNEL_NUM]).charAt(0) == channelFirstIndex)
						{
							onlinePlayer += channelObject[DataFieldMauBinh.USERS_ONLINE];
							minLevel = channelObject[DataFieldMauBinh.LEVEL_MIN];
							channelButtonArray[i]["playerNumberTxt"].text = PlayingLogic.format(onlinePlayer, 1);
							channelButtonArray[i]["levelTxt"].text = String(minLevel);
							
							if (int(mainData.chooseChannelData.myInfo.level) < minLevel)
								MovieClip(channelButtonArray[i]).gotoAndStop("disable");
						}
					}
				}
				else
				{
					onlinePlayer = 0;
					for (j = 0; j < mainData.chooseChannelData.channelInfoArray.length; j++) 
					{
						channelObject = mainData.chooseChannelData.channelInfoArray[j];
						channelFirstIndex = '9';
						if (String(channelObject[DataFieldMauBinh.CHANNEL_NUM]).charAt(0) == channelFirstIndex)
						{
							onlinePlayer += channelObject[DataFieldMauBinh.USERS_ONLINE];
							minLevel = channelObject[DataFieldMauBinh.LEVEL_MIN];
							channelButtonArray[i]["playerNumberTxt"].text = PlayingLogic.format(onlinePlayer, 1);
						}
					}
				}
			}
		}
		
		private function onUpdatePublicChat(e:Event):void 
		{
			var isMe:Boolean;
			if (mainData.chooseChannelData.myInfo.uId == mainData.publicChatData.userName)
				isMe = true;
			chatBox.addChatSentence(mainData.publicChatData.chatContent, mainData.publicChatData.displayName, isMe);
		}
		
		private function onHaveChat(e:Event):void 
		{
			mainCommand.electroServerCommand.sendPublicChat(mainData.chooseChannelData.myInfo.name, chatBox.currentText);
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			var userData:UserDataRLC = new UserDataRLC();
			userData.moneyLogoUrl1 = mainData.init.requestLink.moneyIcon.@url;
			userData.userName = mainData.chooseChannelData.myInfo.name;
			userData.money1 = mainData.chooseChannelData.myInfo.money;
			userData.money2 = mainData.chooseChannelData.myInfo.cash;
			userData.levelName = mainData.chooseChannelData.myInfo.level;
			userData.webLogoUrl = mainData.chooseChannelData.myInfo.logo;
			userData.avatar = mainData.chooseChannelData.myInfo.avatar;
			roomList.setUserData(userData);
			roomList.setNameChannel("Kênh: " + mainData.playingData.gameRoomData.channelName);
		}
		
		private function onUpdateMoney(e:Event):void 
		{
			if (mainData.chooseChannelData.myInfo)
			{
				if (mainData.lobbyRoomData.updateMoneyData[DataFieldMauBinh.USER_NAME] != mainData.chooseChannelData.myInfo.uId)
					return;
				var userData:UserDataRLC = new UserDataRLC();
				userData.moneyLogoUrl1 = mainData.init.requestLink.moneyIcon.@url;
				userData.userName = mainData.chooseChannelData.myInfo.name;
				userData.money1 = mainData.lobbyRoomData.updateMoneyData[DataFieldMauBinh.MONEY];
				userData.levelName = mainData.chooseChannelData.myInfo.level;
				
				userData.avatar = mainData.chooseChannelData.myInfo.avatar;
				
				userData.webLogoUrl = mainData.chooseChannelData.myInfo.logo;
				roomList.setUserData(userData);
				roomList.setNameChannel("Kênh: " + mainData.playingData.gameRoomData.channelName);
			}
		}
		
		private function onFriendConfirmAddFriendInvite(e:Event):void 
		{
			var alertWindow:AlertWindow = new AlertWindow();
			
			if (mainData.responseAddFriendData[DataFieldMauBinh.CONFIRM])
			{
				var rowElement:UserRowULC = userList.findRowElementById(mainData.responseAddFriendData[DataFieldMauBinh.USER_NAME]);
				if (rowElement)
					rowElement.isFriend = true;
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
			
			mainCommand.electroServerCommand.sendPrivateMessage(invitedNameArray, Command.CONFIRM_ADD_FRIEND_INVITE, esObject);
			
			if (mainData.confirmFriendRequestData[DataFieldMauBinh.CONFIRM])
			{
				var rowElement:UserRowULC = userList.findRowElementById(mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]);
				if (rowElement)
					rowElement.isFriend = true;
			}
			
			if (mainCommand.electroServerCommand.coreAPI.myData.friendList)
			{
				if (mainData.confirmFriendRequestData[DataFieldMauBinh.CONFIRM])
				{
					mainCommand.electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]] = new Object();
					if (mainCommand.electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]])
					{
						var displayName:String = mainCommand.electroServerCommand.coreAPI.myData.userList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]][DataFieldMauBinh.USER_INFO][DataFieldMauBinh.DISPLAY_NAME];
						mainCommand.electroServerCommand.coreAPI.myData.friendList[mainData.confirmFriendRequestData[DataFieldMauBinh.FRIEND_ID]][DataFieldMauBinh.DISPLAY_NAME] = displayName;
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
			mainCommand.electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldMauBinh.USER_NAME], true, DataFieldMauBinh.IN_LOBBY);
		}
		
		private function onRejectInvite(e:Event):void 
		{
			mainCommand.electroServerCommand.confirmInviteAddFriend(mainData.inviteAddFriendData[DataFieldMauBinh.USER_NAME], false, DataFieldMauBinh.IN_LOBBY);
		}
		
		private function onHaveInvitePlay(e:Event):void 
		{
			if (!stage)
				return;
			
			var inviteObject:Object = mainData.lobbyRoomData.invitePlayData;
			var timerToRemoveInvite:Timer = new Timer(60000, 1);
			timerToRemoveInvite.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerToRemoveInvite);
			timerToRemoveInvite.start();
			mainData.inviteList[inviteObject[DataFieldMauBinh.USER_NAME]] = inviteObject;
			mainData.inviteList[inviteObject[DataFieldMauBinh.USER_NAME]][DataFieldMauBinh.TIME] = timerToRemoveInvite;
			
			renderInviteList();
		}
		
		private function renderInviteList():void
		{
			var roomArray:Array = new Array();
			var roomData:RoomDataRLC;
			var i:int;		
			for (var userName:String in mainData.inviteList)
			{
				for (i = 0; i < mainData.lobbyRoomData.roomList.length; i++) 
				{
					roomData = mainData.lobbyRoomData.roomList[i];
					if (mainData.inviteList[userName][DataFieldMauBinh.ROOM_ID] == roomData.id)
					{
						var roomDataCopy:RoomDataRLC = new RoomDataRLC();
						roomDataCopy.isInvite = true;
						roomDataCopy.userName = userName;
						roomDataCopy.playerName = mainData.inviteList[userName][DataFieldMauBinh.DISPLAY_NAME];
						roomDataCopy.rules = roomData.rules;
						roomDataCopy.name = roomData.name;
						roomDataCopy.betting = roomData.betting;
						roomDataCopy.userNumbers = roomData.userNumbers;
						roomDataCopy.maxPlayer = roomData.maxPlayer
						roomDataCopy.id = roomData.id;
						roomDataCopy.gameId = roomData.gameId;
						roomDataCopy.password = mainData.inviteList[userName][DataFieldMauBinh.ROOM_PASSWORD];
						roomArray.push(roomDataCopy);
					}
				}
			}
					
			roomList.inviteDataList = roomArray;
		}
		
		private function onTimerToRemoveInvite(e:TimerEvent):void 
		{
			for (var userName:String in mainData.inviteList)
			{
				if (mainData.inviteList[userName][DataFieldMauBinh.TIME] == e.currentTarget)
					delete mainData.inviteList[userName];
			}
			renderInviteList();
		}
		
		private function onUpdateUserList(e:Event):void 
		{
			renderUserList();
		}
		
		private function onUpdateRoomList(e:Event):void 
		{
			if (roomList)
			{
				if (!userList.isDraggingScroll && !roomList.isDraggingScroll)
				{
					roomList.roomDataList = mainData.lobbyRoomData.roomList.concat();
				}
			}
		}
		
		public function effectOpen():void
		{
			var currentTime:Number = (new Date()).getTime();
			
			//roomList.betting = mainData.playingData.gameRoomData.betting;
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_USER_LIST, onUpdateUserList);
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_FRIEND_LIST, onUpdateFriendList);
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.UPDATE_ROOM_LIST, onUpdateRoomList);
			mainData.addEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.addEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.addEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.HAVE_INVITE_PLAY, onHaveInvitePlay);
			// Cập nhật lại thông tin của người chơi
			if (mainData.chooseChannelData.myInfo)
			{
				var userData:UserDataRLC = new UserDataRLC();
				userData.avatar = mainData.chooseChannelData.myInfo.avatar;
				userData.moneyLogoUrl1 = mainData.init.requestLink.moneyIcon.@url;
				userData.userName = mainData.chooseChannelData.myInfo.name;
				userData.money1 = mainData.chooseChannelData.myInfo.money;
				userData.levelName = mainData.chooseChannelData.myInfo.level;
				userData.webLogoUrl = mainData.chooseChannelData.myInfo.logo;
				roomList.setUserData(userData);
				roomList.setNameChannel("Kênh: " + mainData.playingData.gameRoomData.channelName);
			}
			
			var tempTween1:GTween = new GTween(roomList, effectTime, { x:0, alpha:1 }, { ease:Back.easeOut } );
			var tempTween2:GTween = new GTween(userList, effectTime, { x:0, alpha:1 }, { ease:Back.easeOut } );
			tempTween1.addEventListener(Event.COMPLETE, openComplete);
		}
		
		private function onUpdateFriendList(e:Event):void 
		{
			renderUserList();
		}
		
		private function openComplete(e:Event):void 
		{
			
		}
		
		public function effectClose():void
		{
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_USER_LIST, onUpdateUserList);
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_FRIEND_LIST, onUpdateFriendList);
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.UPDATE_ROOM_LIST, onUpdateRoomList);
			mainData.removeEventListener(MainData.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn
			mainData.removeEventListener(MainData.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest);
			mainData.removeEventListener(MainData.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite);
			mainData.lobbyRoomData.removeEventListener(LobbyRoomData.HAVE_INVITE_PLAY, onHaveInvitePlay);
			GTween.defaultDispatchEvents = true;
			var tempTween1:GTween = new GTween(roomList, effectTime, { x:0, alpha:0 }, { ease:Back.easeIn } );
			var tempTween2:GTween = new GTween(userList, effectTime, { x:0, alpha:0 }, { ease:Back.easeIn } );
			tempTween2.addEventListener(Event.COMPLETE, closeComplete);
		}
		
		private function closeComplete(e:Event):void 
		{
			dispatchEvent(new Event(CLOSE_COMPLETE));
		}
		
		public function simpleOpen():void
		{
			
		}
		
		private function onCreateRoom(e:Event):void 
		{
			if (createRoomWindow)
			{
				if (createRoomWindow.parent)
					return;
			}
			createRoomWindow = new CreateRoomWindow();
			windowLayer.openWindow(createRoomWindow, null, BaseWindow.NO_EFFECT, true);
		}
		
		private function onFindRoom(e:Event):void 
		{
			searchRoomWindow = new SearchRoomWindow();
			windowLayer.openWindow(searchRoomWindow);
		}
		
		private function onSelectOtherChannel(e:Event):void 
		{
			mainCommand.electroServerCommand.closeConnection();
			dispatchEvent(new Event(BACK_TO_CHOOSE_CHANNEL_SCREEN));
		}
		
		private function addRoomList():void 
		{
			if(!roomList)
				roomList = new RoomListComponent();
			roomList.isInvite = false;
			roomList.addEventListener(MouseEvent.MOUSE_DOWN, onCompMouseDown);
			roomList.addEventListener(MouseEvent.MOUSE_UP, onCompMouseUp);
			roomList.addEventListener(RoomListRLCEvent.ENTER_ROOM, onRoomListSelect);
			roomList.addEventListener(RoomListComponent.QUICK_PLAY, onQuickPlay);
			addChild(roomList);
		}
		
		private function onCompMouseDown(e:MouseEvent):void 
		{
			mainData.isNoRenderLobbyList = true;
		}
		
		private function onCompMouseUp(e:MouseEvent):void 
		{
			mainData.isNoRenderLobbyList = false;
		}
		
		private function onQuickPlay(e:Event):void 
		{
			mainCommand.electroServerCommand.quickJoinGameRoom(mainData.playingData.gameRoomData.betting[0]);
		}
		
		private function onRoomListSelect(e:RoomListRLCEvent):void 
		{
			
			mainData.playingData.gameRoomData.roomPassword = "";
			
			if (Number(e.betting) * mainData.minBetRate > mainData.chooseChannelData.myInfo.money)
			{
				var notEnoughMoneyWindow:AlertWindow = new AlertWindow();
				var string1:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate1;
				var string2:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate2;
				var minMoney:Number = Number(e.betting) * mainData.minBetRate;
				notEnoughMoneyWindow.setNotice(string1 + " " + PlayingLogic.format(minMoney, 1) + " " + string2);
				windowLayer.openWindow(notEnoughMoneyWindow);
			}
			else
			{
				if (!e.hasPassword)
				{
					mainCommand.electroServerCommand.joinGameRoom(e.gameId, e.password);
					
					var i:int;		
					for (var userName:String in mainData.inviteList)
					{
						for (i = 0; i < mainData.lobbyRoomData.roomList.length; i++) 
						{
							var roomData:RoomDataRLC = mainData.lobbyRoomData.roomList[i];
							if (mainData.inviteList[userName][DataFieldMauBinh.ROOM_ID] == roomData.id)
							{
								if (e.gameId == roomData.gameId)
								{
									delete mainData.inviteList[userName];
									mainData.inviteList = mainData.inviteList;
									break;
								}
							}
						}
					}
				}
				else
				{
					joinRoomWindow = new JoinRoomWindow();
					joinRoomWindow.gameId = e.gameId;
					joinRoomWindow.roomId = e.id;
					windowLayer.openWindow(joinRoomWindow);
				}
			}
		}
		
		private function addUserList():void 
		{
			if(!userList)
				userList = new UserListComponent();
			userList.addEventListener(MouseEvent.MOUSE_DOWN, onCompMouseDown);
			userList.addEventListener(MouseEvent.MOUSE_UP, onCompMouseUp);
			userList.addEventListener(UserRowULC.USER_ROW_CLICK, onUserRowClick);
			userList.addEventListener(ContextMenuULCEvent.JOIN_ROOM, onJoinRoomAndPlay);
			userList.addEventListener(ContextMenuULCEvent.VIEW_PERSONAL_INFO, onViewPersonalInfo);
			userList.addEventListener(ContextMenuULCEvent.MAKE_FRIEND, onMakeFriend);
			userList.addEventListener(ContextMenuULCEvent.REMOVE_FRIEND, onClickRemoveFriend);
			userList.addEventListener(ContextMenuULCEvent.ACCUSE, onAccuseFriend);
			//userList.useContextMenu = true;
			
			userList.userDataList = new Array();
		}
		
		private function onUserRowClick(e:Event):void 
		{
			var addFriendWindow:AddFriendWindow = new AddFriendWindow();
			addFriendWindow.data = userList.currentUserData;
			windowLayer.openWindow(addFriendWindow);
		}
		
		private function onClickRemoveFriend(e:ContextMenuULCEvent):void 
		{
			mainCommand.electroServerCommand.removeFriend(e.userID, DataFieldMauBinh.IN_LOBBY);
				
			userList.findRowElementById(e.userID).isFriend = false;
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.removeFriendSuccess);
			windowLayer.openWindow(alertWindow);
			
			var invitedNameArray:Array = [userList.findRowElementById(e.userID).userID];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldMauBinh.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldMauBinh.MESSAGE, mess);
			
			mainCommand.electroServerCommand.sendPrivateMessage(invitedNameArray, Command.REMOVE_FRIEND, esObject);
		}
		
		private function onMakeFriend(e:ContextMenuULCEvent):void 
		{
			
			mainCommand.electroServerCommand.addFriend(e.userID, DataFieldMauBinh.IN_LOBBY);
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.sendAddFriendSuccess);
			windowLayer.openWindow(alertWindow);
		}
		
		private function onAccuseFriend(e:ContextMenuULCEvent):void 
		{
			var contextMenuData:Object = new Object();
			contextMenuData[DataFieldMauBinh.DISPLAY_NAME] = e.userName;
			contextMenuData[DataFieldMauBinh.USER_NAME] = e.userID;
			
			var accuseWindow:AccuseWindow = new AccuseWindow();
			accuseWindow.data = contextMenuData;
			windowLayer.openWindow(accuseWindow);
		}
		
		private function onJoinRoomAndPlay(e:ContextMenuULCEvent):void 
		{
			var roomId:int = e.roomID;
			if (roomId == 0)
				return;
			var gameId:int = -1;
			var roomList:Array = mainData.lobbyRoomData.roomList;
			for (var i:int = 0; i < roomList.length; i++) 
			{
				if (RoomDataRLC(roomList[i]).id == roomId)
				{
					if (RoomDataRLC(roomList[i]).userNumbers >= RoomDataRLC(roomList[i]).maxPlayer)
					{
						windowLayer.closeAllWindow();
						var fullPlayerWindow:AlertWindow = new AlertWindow();
						fullPlayerWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.fullPlayer);
						windowLayer.openWindow(fullPlayerWindow);
						return;
					}
					else
					{
						if (Number(RoomDataRLC(roomList[i]).betting) * mainData.minBetRate > mainData.chooseChannelData.myInfo.money)
						{
							var notEnoughMoneyWindow:AlertWindow = new AlertWindow();
							var string1:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate1;
							var string2:String = mainData.init.gameDescription.lobbyRoomScreen.notEnoughMoneyToCreate2;
							var minMoney:Number = Number(RoomDataRLC(roomList[i]).betting) * mainData.minBetRate;
							notEnoughMoneyWindow.setNotice(string1 + " " + PlayingLogic.format(minMoney, 1) + " " + string2);
							windowLayer.openWindow(notEnoughMoneyWindow);
						}
						else
						{
							gameId = RoomDataRLC(roomList[i]).gameId;
							if (!RoomDataRLC(roomList[i]).hasPassword)
							{
								mainCommand.electroServerCommand.joinGameRoom(gameId, "");
							}
							else
							{
								joinRoomWindow = new JoinRoomWindow();
								joinRoomWindow.gameId = gameId;
								joinRoomWindow.roomId = roomId;
								windowLayer.openWindow(joinRoomWindow);
							}
						}
						
						i = roomList.length + 1;
					}
				}
			}
		}
		
		private function onViewPersonalInfo(e:ContextMenuULCEvent):void 
		{
			var scoreWindow:ScoreWindow = new ScoreWindow();
			scoreWindow.userId = e.userID;
			scoreWindow.logoString = e.webLogoUrl;
			scoreWindow.avatarString = e.avatarUrl;
			scoreWindow.addImg();
			windowLayer.openWindow(scoreWindow);
		}
		
		private function addUserProfile():void 
		{
			if (mainData.chooseChannelData.myInfo)
			{
				var userData:UserDataRLC = new UserDataRLC();
				userData.moneyLogoUrl1 = mainData.init.requestLink.moneyIcon.@url;
				userData.userName = mainData.chooseChannelData.myInfo.name;
				userData.money1 = mainData.chooseChannelData.myInfo.money;
				userData.levelName = mainData.chooseChannelData.myInfo.level;
				
				userData.avatar = mainData.chooseChannelData.myInfo.avatar;
				
				userData.webLogoUrl = mainData.chooseChannelData.myInfo.logo;
				roomList.setUserData(userData);
				roomList.setNameChannel("Kênh: " + mainData.playingData.gameRoomData.channelName);
			}
			
			roomList.addEventListener(RoomListComponent.SELECT_OTHER_CHANNEL, onSelectOtherChannel);
			roomList.addEventListener(RoomListComponent.FIND_ROOM, onFindRoom);
			roomList.addEventListener(RoomListComponent.CREATE_ROOM, onCreateRoom);
			roomList.addEventListener(RoomListComponent.QUICK_PLAY, onQuickPlay);
		}
	}

}