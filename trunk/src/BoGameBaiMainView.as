package 
{
	import control.ConstTlmn;
	import flash.desktop.SystemIdleMode;
	import model.GameDataTLMN;
	import model.MyDataTLMN;
	import view.screen.PlayGameScreenSam;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageScaleMode;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.system.Security;
	import control.MainCommand;
	import event.ElectroServerEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import logic.PlayingLogic;
	import logic.TLMNLogic;
	import miniGame.MainMiniGame;
	import model.chooseChannelData.ChooseChannelData;
	import model.EsConfiguration;
	import model.loadingData.LoadingData;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import com.adobe.serialization.json.JSON;
	import model.playingData.PlayingData;
	import net.hires.debug.Stats;
	import request.HTTPRequest;
	import sound.SoundLibChung;
	import sound.SoundManager;
	import view.button.MobileButton;
	import view.effectLayer.EffectLayer;
	import view.screen.LoadingScreen;
	import view.screen.LobbyRoomScreen;
	import view.screen.PlayGameScreenTlmn;
	import view.screen.PlayingScreen;
	import view.screen.PlayingScreenMauBinh;
	import view.screen.PlayingScreenPhom;
	import view.screen.PlayingScreenXito;
	import view.topMenu.TopMenu;
	import view.userInfo.playerInfo.PlayerInfo;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.windowLayer.WindowLayer;
	
	//////////
	import flash.events.SoftKeyboardEvent; 
    import flash.geom.Rectangle; 
    import flash.events.Event; 
    import flash.display.StageScaleMode; 
    import flash.display.StageAlign; 
	
	
	/**
	 * ...
	 * @author Yun
	 */
	//[Frame(factoryClass="Preloader")]
	[SWF(frameRate="24", width="960", height="600", backgroundColor='0x000000')]
	public class BoGameBaiMainView extends Sprite 
	{
		[Embed(source = '../init.xml', mimeType = "application/octet-stream")]
		private static const InitData:Class;
		
		[Embed(source = '../init_test.xml', mimeType = "application/octet-stream")]
		private static const InitData_Test:Class;
		
		private var urlRequest:URLRequest; // urlRequest chứa đường dẫn đễn file init.xml
		private var contentLoader:URLLoader; // urlLoader để load fie init.xml
		private var countLoadSwfFinish:int = 0;
		private var background:Sprite;
		private var loadingScreen:LoadingScreen;
		private var lobbyRoomScreen:LobbyRoomScreen;
		private var playingScreen:*;
		private var topMenu:TopMenu;
		
		private var loadingLayer:Sprite;
		private var topMenuLayer:Sprite;
		private var chooseChannelLayer:Sprite;
		private var lobbyRoomLayer:Sprite;
		private var playingScreenLayer:Sprite;
		private var windowLayer:Sprite;
		private var debugLayer:Sprite;
		private var effectLayer:Sprite;
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var mainData:MainData = MainData.getInstance();
		
		private var windowLayerChild:WindowLayer = WindowLayer.getInstance();
		private var effectLayerChild:EffectLayer = EffectLayer.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var debugText:TextField;
		private var passInputText:TextField;
		public var gamepath:String;
		public var loadLoadingFinish:Boolean;
		private var sharedObject:SharedObject;
		private var minigameLayer:Sprite;
		private var minigame:MainMiniGame;
		
		public function BoGameBaiMainView():void 
		{
			//mainData.isOnAndroid = true;
			//mainData.isOnIos = true;
			
			//if (mainData.isOnAndroid || mainData.isOnIos)
				//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			if (!mainData.isOnAndroid && !mainData.isOnIos)
				mainData.isShowScroll = true;
			
			sharedObject = SharedObject.getLocal("soundConfig");
			
			if (sharedObject.data.isSoundOff)
			{
				SoundManager.getInstance().isSoundOn = false;
			}
			if (sharedObject.data.isMusicOff)
			{
				SoundManager.getInstance().isMusicOn = false;
			}
			
			DefineClass.init();
			
			var byteArray:ByteArray = new InitData() as ByteArray;
			if (mainData.isTest)
				byteArray = new InitData_Test() as ByteArray;
			mainData.init = new XML(byteArray.readUTFBytes(byteArray.length));
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			scrollRect = new Rectangle(0, 0, mainData.stageWidth, mainData.stageHeight);
			
			if (mainData.isOnIos || mainData.isOnAndroid)
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			}
			
			scrollRect = new Rectangle(0, 0, mainData.stageWidth, mainData.stageHeight);
			
			
		}
		
		
		private function handleActivate(e:Event):void 
		{
			mainData.isActive = true;
		}
		
		private function handleDeactivate(e:Event):void 
		{
			mainData.isActive = false;
		}
		
		public function updateMoney():void 
		{
			electroServerCommand.updateMoney();
		}
		
		private function init(e:Event = null):void 
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			mainData.path = gamepath;
			try 
			{
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
				for (keyStr in paramObj) 
				{
					valueStr = String(paramObj[keyStr]);
					if (keyStr == "gamepath")
						mainData.path = paramObj[keyStr] + '/';
				}
				mainData.facebook_access_token = paramObj.facebook_access_token;
			} 
			catch (error:Error) {
				
			}
			
			if (MyDataTLMN.getInstance().isGame == 1) 
			{
				mainData.gameName = 'Tiến lên';
				mainData.gameType = 'TLMN';
				mainData.game_id = 'AZGB_TLMN';
				
				GameDataTLMN.getInstance().gameName = "TienLenMN";
				GameDataTLMN.getInstance().gameType = "TienLenMNPlugin";
				GameDataTLMN.getInstance().lobbyName = "TienLenMN";
				GameDataTLMN.getInstance().lobbyPluginName = "LobbyTLMNPlugin";
				GameDataTLMN.getInstance().gameZone = "tlmnZone";
				
				mainData.maxPlayer = 4;
				mainData.minBetRate = 10;
			}
			else if (MyDataTLMN.getInstance().isGame == 2) 
			{
				mainData.gameName = 'Sâm';
				//mainData.gameType = 'SAM';
				mainData.gameType = 'TLMN';
				mainData.game_id = 'AZGB_SAM';
				
				GameDataTLMN.getInstance().gameName = "Sam";
				GameDataTLMN.getInstance().gameType = "SamPlugin";
				GameDataTLMN.getInstance().lobbyName = "Sam";
				GameDataTLMN.getInstance().lobbyPluginName = "LobbyPlugin";
				GameDataTLMN.getInstance().gameZone = "SAM";
				
				mainData.maxPlayer = 4;
				mainData.minBetRate = 10;
			}
			
			mainData.loadingData.addEventListener(LoadingData.LOAD_lOADING_COMPLETE, onLoadLoadingComplete); // Load dữ liệu màn hình loading xong thì show bảng loading
			mainData.addEventListener(MainData.CLOSE_CONNECTION, onCloseConnection); // Đứt kết nối với server
			mainData.addEventListener(MainData.SERVER_KICK_OUT, onServerKickOut); // Lý do bị server kick
			mainData.addEventListener(MainData.LOG_OUT_CLICK, onLogOutClick); // Nguoi choi click log out
			//mainCommand.initCommand.loadInit(); // Load file init.xml
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			
			mainData.main = this;
			
			//testCallServices();
			// add background
			addBackGround();
			
			// add các layer
			createLayer();
			
			// add windowLayer
			addWindowLayer();
			
			// add effectLayer
			addEffectLayer();
			
			topMenu = new TopMenu();
			topMenu.x = topMenu.y = 6;
			//topMenuLayer.addChild(topMenu);
			mainData.topMenu = topMenu;
			//topMenu.visible = false;
			
			//show bảng chọn kênh
			addLobbyRoomScreen();
			
			// Lắng nghe sự kiện join phòng chờ
			mainData.lobbyRoomData.addEventListener(LobbyRoomData.JOIN_LOBBY_ROOM_SUCCESS, onJoinLobbyRoomSuccess);
			
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
			mainData.addEventListener(MainData.IS_MINI_GAME, onUpdateMiniGame);
			// Lắng nghe sự kiện join phòng game
			
			mainData.playingData.addEventListener(PlayingData.JOIN_GAME_ROOM_SUCCESS, onJoinGameRoomSuccess);
			
			addMinigame();
			
			
		}
		
		private function onUpdateMiniGame(e:Event):void 
		{
			if (mainData.isShowMiniGame) 
			{
				showMiniGame();
			}
			else 
			{
				hideMiniGame();
			}
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			if (minigame) 
			{
				if (mainData.isTest) 
				{
					minigame.addInfoGame(mainData.chooseChannelData.myInfo.name, mainData.chooseChannelData.myInfo.cash, "http://wss.test.azgame.us/");
				}
				else 
				{
					minigame.addInfoGame(mainData.chooseChannelData.myInfo.name, mainData.chooseChannelData.myInfo.cash, "http://wss.azgame.us/");
				}
				
			}
		}
		
		private function addMinigame():void 
		{
			minigame = new MainMiniGame();
			minigameLayer.addChild(minigame);
			minigame.addEventListener(MainMiniGame.CLOSE_GAME, onCloseGame);
			minigame.addEventListener(MainMiniGame.ADD_MONEY, onAddMoney);
		}
		
		private function onAddMoney(e:Event):void 
		{
			mainData.isShowMiniGame = false;
			if (lobbyRoomScreen) 
			{
				lobbyRoomScreen.showAddMoney();
			}
		}
		
		private function onCloseGame(e:Event):void 
		{
			mainData.isShowMiniGame = false;
		}
		
		
		private function checkEventExist():void 
		{
			
			var httpReq:HTTPRequest = new HTTPRequest();
			var method:String = "POST";
			var str:String; 
			if (mainData.isTest) 
			{
				str= "http://wss.test.azgame.us/Service02/OnplayGameEvent.asmx/Azgamebai_GetEventInfo";
			}
			else 
			{
				str= "http://wss.azgame.us/Service02/OnplayGameEvent.asmx/Azgamebai_GetEventInfo";
			}
			
			var obj:Object = new Object();
			obj.sq_id  = 1;
			
			httpReq.sendRequest(method, str, obj, getInfoEvent, true);
		}
		
		private function getInfoEvent(obj:Object):void 
		{
			trace("check event exist: ", obj.Data.status)
			if (obj.Data) 
			{
				if (obj.Data.status == 0) 
				{
					hideMiniGame();
				}
				else if (obj.Data.status == 1) 
				{
					showMiniGame();
				}
				mainData.typeOfEvent = obj.Data.status;
			}
			
			
		}
		
		public function hideMiniGame():void 
		{
			if (minigame) 
			{
				minigame.removeMiniGame();
			}
			minigameLayer.visible = false;
		}
		
		public function showMiniGame():void 
		{
			if (minigame) 
			{
				
				minigame.getMyTurn();
				
			}
			minigameLayer.visible = true;
		}
		
		private function testCallServices():void 
		{
			/*var method:String = "POST";
			var url:String;
			var httpRequest:HTTPRequest = new HTTPRequest();
			var obj:Object;
			
			url = "http://wss.test.azgame.us/Service02/OnplayGamePartnerExt.asmx/Azgamebai_AppMobileLogin";
					obj = new Object();
					
					obj.user_name = "bimkute";
					obj.password = "";
					obj.client_id = "1234567890";
					httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);*/
			
			var method:String = "POST";
				var url:String;
				var httpRequest:HTTPRequest = new HTTPRequest();
				var obj:Object;
				
				url = "http://wss.azgame.us/Service01/Billings/OnplayMobile.asmx/CardCharging";
				//url = "http://wss.azgame.vn/Service02/OnplayUserExt.asmx/GetListTwav00" + String(1)
									//+ "?rowStart=0&rowEnd=10";
				
				obj = new Object();
				obj.nick_name = "78";
				obj.telco_code = "VIT";
				obj.card_serial = "123456790";
				obj.card_id = "1234123451234";
				//obj.avt_group_id = String(0);
				httpRequest.sendRequest(method, url, obj, loadAvatarSuccess, true);
		}
		
		private function loadAvatarSuccess(obj:Object):void 
		{
			
			var addMoney:ConfirmWindow = new ConfirmWindow();
			
			
			if (obj.TypeMsg < 0) 
			{
				addMoney.setNotice(obj.Msg);
				addMoney.buttonStatus(false, true, false);
			}
			else 
			{
				addMoney.setNotice("Bạn đã nạp " + obj.Data.Amount + " k thành công");
				addMoney.buttonStatus(false, true, false);
			}
			
			WindowLayer.getInstance().openWindow(addMoney);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (e.target is SimpleButton)
				SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
			else if (e.target is MobileButton)
				SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
		}
		
		
		private function onLogOutClick(e:Event):void 
		{
			if (mainCommand.electroServerCommand)
				mainCommand.electroServerCommand.closeConnection();
			lobbyRoomScreen.showLoginWindow();
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode) 
			{
				case Keyboard.ENTER:
					passInputText.text = passInputText.text.substring(1, passInputText.text.length);
					if (passInputText.text == "liverpool")
						debugLayer.visible = true;
				break;
				case Keyboard.SPACE:
					passInputText.text = "";
					stage.focus = passInputText;
					if (debugLayer.visible)
						debugLayer.visible = false;
				break;
			}
		}
		
		private function onCloseConnection(e:Event):void 
		{
			removePlayingScreen();
			addLobbyRoomScreen();
			lobbyRoomScreen.showLoginWindow();
		}
		
		private function onServerKickOut(e:Event):void 
		{
			removePlayingScreen();
			addLobbyRoomScreen();
			lobbyRoomScreen.showLoginWindow();
			
			var kickOutWindow:AlertWindow = new AlertWindow();
			kickOutWindow.setNotice("Bạn đã bị out ra khỏi phòng do độ trễ của mạng quá lâu !!");
			kickOutWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseKickOutWindow);
			mainData.isOpeningKickOutWindow = true;
			windowLayerChild.openWindow(kickOutWindow);
		}
		
		private function onCloseKickOutWindow(e:Event):void 
		{
			mainData.isOpeningKickOutWindow = false;
			//windowLayerChild.openLoadingWindow();
			//electroServerCommand.startConnect("", mainData.currentChannelId);
		}
		
		private function onLoadLoadingComplete(e:Event):void 
		{
			loadingLayer = new Sprite();
			addChild(loadingLayer);
			addLoadingScreen();
		}
		
		private function createLayer():void 
		{
			chooseChannelLayer = new Sprite();
			lobbyRoomLayer = new Sprite();
			playingScreenLayer = new Sprite();
			topMenuLayer = new Sprite();
			minigameLayer = new Sprite();
			effectLayer = new Sprite();
			windowLayer = new Sprite();
			debugLayer = new Sprite();
			debugLayer.visible = false;
			
			addChild(chooseChannelLayer);
			addChild(lobbyRoomLayer);
			addChild(topMenuLayer);
			addChild(playingScreenLayer);
			addChild(minigameLayer);
			addChild(effectLayer);
			addChild(windowLayer);
			addChild(debugLayer);
			
			setupDebugLayer();
			minigameLayer.visible = false;
			
			var stats:Stats = new Stats();
			stats.y = 30;
			//addChild(stats);
		}
		
		private function setupDebugLayer():void 
		{
			passInputText = new TextField();
			passInputText.type = TextFieldType.INPUT;
			passInputText.visible = false;
			debugLayer.addChild(passInputText);
			debugText = new TextField();
			debugText.defaultTextFormat = new TextFormat("Arial", 12, 0x000000, true);
			debugText.background = true;
			debugText.backgroundColor = 0xffffff;
			debugText.autoSize = TextFieldAutoSize.LEFT;
			debugText.width = mainData.stageWidth;
			debugText.wordWrap = true;
			debugText.text = "Debug:";
			debugText.width = mainData.stageWidth;
			debugLayer.addChild(debugText);
		}
		
		private function addBackGround():void 
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName("zBackground"));
			background = Sprite(new tempClass());
			addChild(background);
		}
		
		private function onJoinLobbyRoomSuccess(e:Event):void 
		{
			if (windowLayerChild.isNoCloseAll)
				windowLayerChild.isNoCloseAll = false;
			else
				windowLayerChild.closeAllWindow();
				
			//lobbyRoomScreen.updateGameType();
			//trace("joinlobby mainview: ", mainData.joinedGame)
			if (!mainData.joinedGame) 
			{
				checkEventExist();
			}
			
				
			if (mainData.chooseChannelData.myInfo.money < mainData.minMoney) // Nếu user hết tiền thì nạp tiền
				mainCommand.getInfoCommand.addMoney();
		}
		
		private function onJoinGameRoomSuccess(e:Event):void 
		{
			// show phòng chơi
			addPlayingScreen();
			// xóa phòng chờ
			//removeLobbyRoomScreen();
			lobbyRoomScreen.effectClose();
		}
		
		private function addLobbyRoomScreen():void // show bảng phòng chờ
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			if(!lobbyRoomScreen)
				lobbyRoomScreen = new LobbyRoomScreen();
			if (!lobbyRoomLayer.contains(lobbyRoomScreen))
			{
				lobbyRoomLayer.addChild(lobbyRoomScreen);
				lobbyRoomScreen.effectOpen();
			}
			lobbyRoomScreen.addEventListener(LobbyRoomScreen.CLOSE_COMPLETE, onRemoveScreen);
		}
		
		private function removeLobbyRoomScreen():void // xóa bảng phòng chờ
		{
			if (lobbyRoomScreen)
			{
				if (lobbyRoomLayer.contains(lobbyRoomScreen))
					lobbyRoomLayer.removeChild(lobbyRoomScreen);
			}
		}
		
		private function addPlayingScreen():void // show bảng chơi
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removePlayingScreen();
			switch (mainData.gameType) 
			{
				
				case MainData.PHOM:
					playingScreen = new PlayingScreenPhom();
				break;
				case MainData.MAUBINH:
					playingScreen = new PlayingScreenMauBinh();
				break;
				case MainData.XITO:
					playingScreen = new PlayingScreenXito();
				break;
				case MainData.TLMN:
					playingScreen = new PlayGameScreenTlmn();
					//playingScreen = new PlayGameScreenSam();
					//playingScreen = new PlayingScreenTlmnYun();
				break;
				case MainData.SAM:
					playingScreen = new PlayGameScreenSam();
					//playingScreen = new PlayGameScreenTlmn();
				break;
				default:
					playingScreen = new PlayingScreenMauBinh();
			}
			playingScreenLayer.addChild(playingScreen);
			playingScreen.effectOpen();
			playingScreen.addEventListener(ConstTlmn.OUT_ROOM, onExitPlayingScreen);
			playingScreen.addEventListener(PlayerInfo.EXIT, onExitPlayingScreen);
			mainData.joinedGame = true;
			
			playingScreen.addEventListener(PlayingScreen.CLOSE_COMPLETE, onRemoveScreen);
		}
		
		private function removePlayingScreen():void // xóa bảng chơi
		{
			if (playingScreen)
			{
				if (playingScreenLayer.contains(playingScreen))
				{
					playingScreenLayer.removeChild(playingScreen);
					playingScreen.destroy();
				}
			}
		}
		
		private function addLoadingScreen():void // show bảng loading
		{
			if(!loadingScreen)
				loadingScreen = new LoadingScreen();
			loadingLayer.addChild(loadingScreen);
			loadLoadingFinish = true;
		}
		
		private function removeLoadingScreen():void // xóa bảng loading
		{
			if (loadingScreen)
			{
				if (loadingLayer.contains(loadingScreen))
					loadingLayer.removeChild(loadingScreen);
			}
		}
		
		private function addWindowLayer():void // show bảng chơi
		{
			windowLayer.addChild(windowLayerChild);
		}
		
		private function addEffectLayer():void // show bảng chơi
		{
			effectLayer.addChild(effectLayerChild);
		}
		
		private function removeWindowLayer():void // xóa bảng chơi
		{
			if (windowLayer.contains(windowLayerChild))
			{
				windowLayer.removeChild(windowLayerChild);
			}
		}
		
		private function onRemoveScreen(e:Event):void 
		{
			switch (e.currentTarget) 
			{
				case lobbyRoomScreen:
					removeLobbyRoomScreen();
				break;
				case playingScreen:
					removePlayingScreen();
					playingScreen = null;
				break;
			}
		}
		
		private function onExitPlayingScreen(e:Event):void 
		{
			playingScreen.effectClose();
			removePlayingScreen();
			addLobbyRoomScreen();
			lobbyRoomScreen.excuteWhenJoinLobby();
			switch (mainData.gameType) 
			{
				case MainData.PHOM:
					SoundManager.getInstance().soundManagerPhom.playOtherExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				case MainData.MAUBINH:
					SoundManager.getInstance().soundManagerMauBinh.playOtherExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				case MainData.TLMN:
					SoundManager.getInstance().soundManagerMauBinh.playOtherExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				default:
			}
		}
	}
}