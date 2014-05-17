package 
{
	import control.ConstTlmn;
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
	import model.chooseChannelData.ChooseChannelData;
	import model.EsConfiguration;
	import model.loadingData.LoadingData;
	import model.lobbyRoomData.LobbyRoomData;
	import model.MainData;
	import com.adobe.serialization.json.JSON;
	import model.playingData.PlayingData;
	import net.hires.debug.Stats;
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
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	[SWF(frameRate="24", width="960", height="600", backgroundColor='0x000000')]
	public class BoGameBaiMainView extends Sprite 
	{
		[Embed(source = '../init.xml', mimeType = "application/octet-stream")]
		private static const InitData:Class;
		
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
		private var countLoadBackgroundSound:int;
		
		public function BoGameBaiMainView():void 
		{
			//mainData.isOnAndroid = true;
			//mainData.isOnIos = true;
			
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
			mainData.init = new XML(byteArray.readUTFBytes(byteArray.length));
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			scrollRect = new Rectangle(0, 0, mainData.stageWidth, mainData.stageHeight);
			
			if (mainData.isOnIos || mainData.isOnAndroid)
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			}
			
			loadBackgroundMusic();
		}
		
		private function loadBackgroundMusic():void 
		{
			countLoadBackgroundSound = 0;
			
			for (var i:int = 0; i < 3; i++) 
			{
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://183.91.14.52/gamebai/bimkute/maubinh/soundChung/" + "GB001 (" + String(i + 1) + ")" + ".az"));
				tempSound.addEventListener(Event.COMPLETE, onLoadBackgroundMusicComplete);
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				SoundManager.getInstance().registerSound("GB001 (" + String(i + 1) + ")", tempSound);
			}
		}
		
		private function onLoadSoundIOError(e:IOErrorEvent):void 
		{
			
		}
		
		private function onLoadBackgroundMusicComplete(e:Event):void 
		{
			countLoadBackgroundSound++;
			if (countLoadBackgroundSound == 3)
				SoundManager.getInstance().playBackgroundMusicMauBinh();
		}
		
		private function loadSoundMauBinh():void 
		{
			for (var i:int = 0; i < mainData.init.soundMauBinhList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundMauBinhList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://183.91.14.52/gamebai/bimkute/maubinh/soundMauBinh/" + soundUrl + ".az"));
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
			}
		}
		
		private function loadSoundChung():void 
		{
			for (var i:int = 0; i < mainData.init.soundChungList.child.length(); i++) 
			{
				var soundUrl:String = mainData.init.soundChungList.child[i];
				var tempSound:Sound = new Sound();
				tempSound.load(new URLRequest("http://183.91.14.52/gamebai/bimkute/maubinh/soundChung/" + soundUrl + ".az"));
				tempSound.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundIOError);
				SoundManager.getInstance().registerSound(soundUrl, tempSound);
			}
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
			} 
			catch (error:Error) {
				
			}
			
			mainData.loadingData.addEventListener(LoadingData.LOAD_lOADING_COMPLETE, onLoadLoadingComplete); // Load dữ liệu màn hình loading xong thì show bảng loading
			mainData.addEventListener(MainData.CLOSE_CONNECTION, onCloseConnection); // Đứt kết nối với server
			mainData.addEventListener(MainData.SERVER_KICK_OUT, onServerKickOut); // Lý do bị server kick
			mainData.addEventListener(MainData.LOG_OUT_CLICK, onLogOutClick); // Nguoi choi click log out
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_CHANNEL_INFO, onUpdateChannelInfo);
			//mainCommand.initCommand.loadInit(); // Load file init.xml
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			
			addSound();
			
			mainData.main = this;
			
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
			
			// Lắng nghe sự kiện join phòng game
			mainData.playingData.addEventListener(PlayingData.JOIN_GAME_ROOM_SUCCESS, onJoinGameRoomSuccess);
		}
		
		private function onUpdateChannelInfo(e:Event):void 
		{
			if (mainData.isFirstJoinLobby)
			{
				loadSoundMauBinh();
				loadSoundChung();
			}
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (e.target is SimpleButton)
				SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
			else if (e.target is MobileButton)
				SoundManager.getInstance().playSound(SoundLibChung.CLICK_SOUND);
		}
		private function addSound():void 
		{
			var arrSoundName:Array = ["GameSound1", "GameSound2", "GameSound3", ConstTlmn.SOUND_POPUP, 
			ConstTlmn.SOUND_DEAL_DISCARD, ConstTlmn.SOUND_OVERTIME, ConstTlmn.SOUND_SORTCARD, 
			ConstTlmn.SOUND_READY, ConstTlmn.SOUND_OUTROOM, ConstTlmn.SOUND_TURN, ConstTlmn.SOUND_WIN,
			ConstTlmn.SOUND_LOSE, ConstTlmn.SOUND_CLICK, ConstTlmn.SOUND_JOINROOM, ConstTlmn.SOUND_WHITEWIN, 
			
			ConstTlmn.SOUND_BOY_HELLO_1, ConstTlmn.SOUND_BOY_HELLO_2,
			ConstTlmn.SOUND_BOY_BYE_1, ConstTlmn.SOUND_BOY_BYE_2, ConstTlmn.SOUND_BOY_BYE_3, ConstTlmn.SOUND_BOY_BYE_4,
			ConstTlmn.SOUND_BOY_BYE_5, ConstTlmn.SOUND_BOY_JOINGAME_1, ConstTlmn.SOUND_BOY_JOINGAME_2, 
			ConstTlmn.SOUND_BOY_JOINGAME_3, ConstTlmn.SOUND_BOY_JOINGAME_4, ConstTlmn.SOUND_BOY_JOINGAME_5,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_1, ConstTlmn.SOUND_BOY_USER_OUTROOM_2, ConstTlmn.SOUND_BOY_USER_OUTROOM_3,
			ConstTlmn.SOUND_BOY_USER_OUTROOM_4, ConstTlmn.SOUND_BOY_USER_OUTROOM_5, ConstTlmn.SOUND_BOY_STARTGAME_1,
			ConstTlmn.SOUND_BOY_STARTGAME_2, ConstTlmn.SOUND_BOY_STARTGAME_3, ConstTlmn.SOUND_BOY_STARTGAME_4,
			ConstTlmn.SOUND_BOY_STARTGAME_5, ConstTlmn.SOUND_BOY_OVERTIME_1, ConstTlmn.SOUND_BOY_OVERTIME_2,
			ConstTlmn.SOUND_BOY_OVERTIME_3, ConstTlmn.SOUND_BOY_OVERTIME_4, ConstTlmn.SOUND_BOY_OVERTIME_5,
			ConstTlmn.SOUND_BOY_DISCARD1CARD_1, ConstTlmn.SOUND_BOY_DISCARD1CARD_2, ConstTlmn.SOUND_BOY_DISCARD1CARD_3,
			ConstTlmn.SOUND_BOY_DISCARD1CARD_4, ConstTlmn.SOUND_BOY_DISCARD1CARD_5, ConstTlmn.SOUND_BOY_CHATDE1CARD_1,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_2, ConstTlmn.SOUND_BOY_CHATDE1CARD_3, ConstTlmn.SOUND_BOY_CHATDE1CARD_4,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_5, ConstTlmn.SOUND_BOY_CHATDE1CARD_6, ConstTlmn.SOUND_BOY_CHATDE1CARD_6,
			ConstTlmn.SOUND_BOY_CHATDE1CARD_8, ConstTlmn.SOUND_BOY_CHATDE1CARD_9, ConstTlmn.SOUND_BOY_CHATDE1CARD_10,
			ConstTlmn.SOUND_BOY_DANH2_1, ConstTlmn.SOUND_BOY_DANH2_2, ConstTlmn.SOUND_BOY_DANH2_3, 
			ConstTlmn.SOUND_BOY_DANH2_4, ConstTlmn.SOUND_BOY_DANH2_5, ConstTlmn.SOUND_BOY_DISCARD2CARD_1, 
			ConstTlmn.SOUND_BOY_DISCARD2CARD_2, ConstTlmn.SOUND_BOY_DISCARD2CARD_3, ConstTlmn.SOUND_BOY_DISCARD2CARD_4, 
			ConstTlmn.SOUND_BOY_DISCARD2CARD_5, ConstTlmn.SOUND_BOY_CHATDE2CARD_1, ConstTlmn.SOUND_BOY_CHATDE2CARD_2,
			ConstTlmn.SOUND_BOY_CHATDE2CARD_3, ConstTlmn.SOUND_BOY_CHATDE2CARD_4, ConstTlmn.SOUND_BOY_CHATDE2CARD_5,
			ConstTlmn.SOUND_BOY_DISCARD3CARD_1, ConstTlmn.SOUND_BOY_DISCARD3CARD_2, ConstTlmn.SOUND_BOY_DISCARD3CARD_3,
			ConstTlmn.SOUND_BOY_DISCARD3CARD_4, ConstTlmn.SOUND_BOY_DISCARD3CARD_5, ConstTlmn.SOUND_BOY_CHATDE3CARD_1,
			ConstTlmn.SOUND_BOY_CHATDE3CARD_2, ConstTlmn.SOUND_BOY_CHATDE3CARD_3, ConstTlmn.SOUND_BOY_CHATDE3CARD_4,
			ConstTlmn.SOUND_BOY_CHATDE3CARD_5, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_1, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_2,
			ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_3, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_4, ConstTlmn.SOUND_BOY_CHATDESPECIALCARD_5,
			ConstTlmn.SOUND_BOY_PASSTURN_1, ConstTlmn.SOUND_BOY_PASSTURN_2, ConstTlmn.SOUND_BOY_PASSTURN_3,
			ConstTlmn.SOUND_BOY_PASSTURN_4, ConstTlmn.SOUND_BOY_PASSTURN_5, ConstTlmn.SOUND_BOY_WIN_1,
			ConstTlmn.SOUND_BOY_WIN_2, ConstTlmn.SOUND_BOY_WIN_3, ConstTlmn.SOUND_BOY_WIN_4,
			ConstTlmn.SOUND_BOY_WIN_5, ConstTlmn.SOUND_BOY_LOSE_1, ConstTlmn.SOUND_BOY_LOSE_2,
			ConstTlmn.SOUND_BOY_LOSE_3, ConstTlmn.SOUND_BOY_LOSE_4, ConstTlmn.SOUND_BOY_LOSE_5,
			ConstTlmn.SOUND_BOY_OVERMONEY_1, ConstTlmn.SOUND_BOY_OVERMONEY_2, ConstTlmn.SOUND_BOY_OVERMONEY_3,
			ConstTlmn.SOUND_BOY_OVERMONEY_4, ConstTlmn.SOUND_BOY_OVERMONEY_5, 
			
			ConstTlmn.SOUND_GIRL_HELLO_1, ConstTlmn.SOUND_GIRL_HELLO_2,
			ConstTlmn.SOUND_GIRL_BYE_1, ConstTlmn.SOUND_GIRL_BYE_2, ConstTlmn.SOUND_GIRL_BYE_3, ConstTlmn.SOUND_GIRL_BYE_4,
			ConstTlmn.SOUND_GIRL_BYE_5, ConstTlmn.SOUND_GIRL_JOINGAME_1, ConstTlmn.SOUND_GIRL_JOINGAME_2, 
			ConstTlmn.SOUND_GIRL_JOINGAME_3, ConstTlmn.SOUND_GIRL_JOINGAME_4, ConstTlmn.SOUND_GIRL_JOINGAME_5,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_1, ConstTlmn.SOUND_GIRL_USER_OUTROOM_2, ConstTlmn.SOUND_GIRL_USER_OUTROOM_3,
			ConstTlmn.SOUND_GIRL_USER_OUTROOM_4, ConstTlmn.SOUND_GIRL_USER_OUTROOM_5, ConstTlmn.SOUND_GIRL_STARTGAME_1,
			ConstTlmn.SOUND_GIRL_STARTGAME_2, ConstTlmn.SOUND_GIRL_STARTGAME_3, ConstTlmn.SOUND_GIRL_STARTGAME_4,
			ConstTlmn.SOUND_GIRL_STARTGAME_5, ConstTlmn.SOUND_GIRL_OVERTIME_1, ConstTlmn.SOUND_GIRL_OVERTIME_2,
			ConstTlmn.SOUND_GIRL_OVERTIME_3, ConstTlmn.SOUND_GIRL_OVERTIME_4, ConstTlmn.SOUND_GIRL_OVERTIME_5,
			ConstTlmn.SOUND_GIRL_DISCARD1CARD_1, ConstTlmn.SOUND_GIRL_DISCARD1CARD_2, ConstTlmn.SOUND_GIRL_DISCARD1CARD_3,
			ConstTlmn.SOUND_GIRL_DISCARD1CARD_4, ConstTlmn.SOUND_GIRL_DISCARD1CARD_5, ConstTlmn.SOUND_GIRL_CHATDE1CARD_1,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_2, ConstTlmn.SOUND_GIRL_CHATDE1CARD_3, ConstTlmn.SOUND_GIRL_CHATDE1CARD_4,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_5, ConstTlmn.SOUND_GIRL_CHATDE1CARD_6, ConstTlmn.SOUND_GIRL_CHATDE1CARD_6,
			ConstTlmn.SOUND_GIRL_CHATDE1CARD_8, ConstTlmn.SOUND_GIRL_CHATDE1CARD_9, ConstTlmn.SOUND_GIRL_CHATDE1CARD_10,
			ConstTlmn.SOUND_GIRL_DANH2_1, ConstTlmn.SOUND_GIRL_DANH2_2, ConstTlmn.SOUND_GIRL_DANH2_3, 
			ConstTlmn.SOUND_GIRL_DANH2_4, ConstTlmn.SOUND_GIRL_DANH2_5, ConstTlmn.SOUND_GIRL_DISCARD2CARD_1, 
			ConstTlmn.SOUND_GIRL_DISCARD2CARD_2, ConstTlmn.SOUND_GIRL_DISCARD2CARD_3, ConstTlmn.SOUND_GIRL_DISCARD2CARD_4, 
			ConstTlmn.SOUND_GIRL_DISCARD2CARD_5, ConstTlmn.SOUND_GIRL_CHATDE2CARD_1, ConstTlmn.SOUND_GIRL_CHATDE2CARD_2,
			ConstTlmn.SOUND_GIRL_CHATDE2CARD_3, ConstTlmn.SOUND_GIRL_CHATDE2CARD_4, ConstTlmn.SOUND_GIRL_CHATDE2CARD_5,
			ConstTlmn.SOUND_GIRL_DISCARD3CARD_1, ConstTlmn.SOUND_GIRL_DISCARD3CARD_2, ConstTlmn.SOUND_GIRL_DISCARD3CARD_3,
			ConstTlmn.SOUND_GIRL_DISCARD3CARD_4, ConstTlmn.SOUND_GIRL_DISCARD3CARD_5, ConstTlmn.SOUND_GIRL_CHATDE3CARD_1,
			ConstTlmn.SOUND_GIRL_CHATDE3CARD_2, ConstTlmn.SOUND_GIRL_CHATDE3CARD_3, ConstTlmn.SOUND_GIRL_CHATDE3CARD_4,
			ConstTlmn.SOUND_GIRL_CHATDE3CARD_5, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_1, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_2,
			ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_3, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_4, ConstTlmn.SOUND_GIRL_CHATDESPECIALCARD_5,
			ConstTlmn.SOUND_GIRL_PASSTURN_1, ConstTlmn.SOUND_GIRL_PASSTURN_2, ConstTlmn.SOUND_GIRL_PASSTURN_3,
			ConstTlmn.SOUND_GIRL_PASSTURN_4, ConstTlmn.SOUND_GIRL_PASSTURN_5, ConstTlmn.SOUND_GIRL_WIN_1,
			ConstTlmn.SOUND_GIRL_WIN_2, ConstTlmn.SOUND_GIRL_WIN_3, ConstTlmn.SOUND_GIRL_WIN_4,
			ConstTlmn.SOUND_GIRL_WIN_5, ConstTlmn.SOUND_GIRL_LOSE_1, ConstTlmn.SOUND_GIRL_LOSE_2,
			ConstTlmn.SOUND_GIRL_LOSE_3, ConstTlmn.SOUND_GIRL_LOSE_4, ConstTlmn.SOUND_GIRL_LOSE_5,
			ConstTlmn.SOUND_GIRL_OVERMONEY_1, ConstTlmn.SOUND_GIRL_OVERMONEY_2, ConstTlmn.SOUND_GIRL_OVERMONEY_3,
			ConstTlmn.SOUND_GIRL_OVERMONEY_4, ConstTlmn.SOUND_GIRL_OVERMONEY_5, 
			
			];
			//"Ready", , "Bichat"
			var arrSound:Array = ["http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB001(1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB001(2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB001(3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB003.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB005.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB013.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB007.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB008.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB009.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB006.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB011.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB012.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB002.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB004.az",
									"http://183.91.14.52/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB017.az",
									
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M001 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M001 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M002 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M002 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M002 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M002 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M002 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M003 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M003 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M003 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M003 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M003 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M004 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M004 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M004 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M004 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M004 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M005 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M005 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M005 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M005 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M005 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M006 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M006 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M006 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M006 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M006 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M007 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M007 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M007 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M007 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M007 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (6).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (7).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (8).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (9).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M008 (10).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M009 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M009 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M009 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M009 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M009 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M010 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M010 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M010 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M010 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M010 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M011 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M011 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M011 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M011 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M011 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M012 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M012 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M012 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M012 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M012 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M013 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M013 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M013 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M013 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M013 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M014 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M014 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M014 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M014 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M014 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M015 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M015 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M015 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M015 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M015 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M016 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M016 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M016 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M016 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M016 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M017 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M017 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M017 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M017 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M017 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M018 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M018 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M018 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M018 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Male/TL.M018 (5).az",
									
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F001 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F001 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F002 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F002 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F002 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F002 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F002 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F003 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F003 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F003 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F003 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F003 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F004 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F004 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F004 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F004 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F004 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F005 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F005 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F005 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F005 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F005 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F006 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F006 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F006 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F006 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F006 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F007 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F007 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F007 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F007 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F007 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (6).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (7).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (8).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (9).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F008 (10).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F009 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F009 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F009 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F009 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F009 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F010 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F010 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F010 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F010 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F010 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F011 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F011 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F011 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F011 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F011 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F012 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F012 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F012 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F012 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F012 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F013 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F013 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F013 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F013 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F013 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F014 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F014 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F014 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F014 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F014 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F015 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F015 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F015 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F015 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F015 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F016 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F016 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F016 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F016 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F016 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F017 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F017 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F017 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F017 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F017 (5).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F018 (1).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F018 (2).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F018 (3).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F018 (4).az",
									"http://183.91.14.52/gamebai/bimkute/sound/TL.Female/TL.F018 (5).az"
								];
			for (var i:int = 0; i < arrSoundName.length; i++) 
			{
				
				var mySound:Sound = new Sound();
				mySound.load(new URLRequest(arrSound[i]));
				mySound.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadSound);
				SoundManager.getInstance().registerSound(arrSoundName[i], mySound);
			}
		}
		
		private function onErrorLoadSound(e:IOErrorEvent):void 
		{
			
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
		}
		
		private function onServerKickOut(e:Event):void 
		{
			debugText.appendText(" <--> " + mainData.serverKickOutData);
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
			effectLayer = new Sprite();
			windowLayer = new Sprite();
			debugLayer = new Sprite();
			debugLayer.visible = false;
			
			addChild(chooseChannelLayer);
			addChild(lobbyRoomLayer);
			addChild(topMenuLayer);
			addChild(playingScreenLayer);
			addChild(effectLayer);
			addChild(windowLayer);
			addChild(debugLayer);
			
			setupDebugLayer();
			
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
				break;
				default:
					playingScreen = new PlayingScreenMauBinh();
			}
			playingScreenLayer.addChild(playingScreen);
			playingScreen.effectOpen();
			playingScreen.addEventListener(PlayerInfo.EXIT, onExitPlayingScreen);
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
			addLobbyRoomScreen();
			switch (mainData.gameType) 
			{
				case MainData.PHOM:
					SoundManager.getInstance().soundManagerPhom.playOtherExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				case MainData.MAUBINH:
					SoundManager.getInstance().soundManagerMauBinh.playOtherExitGamePlayerSound(mainData.chooseChannelData.myInfo.sex);
				break;
				default:
			}
		}
	}
}