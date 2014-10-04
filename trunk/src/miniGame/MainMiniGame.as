package miniGame
{
	import com.gsolo.encryption.MD5;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import miniGame.request.HTTPRequestMiniGame;
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class MainMiniGame extends Sprite
	{
		public static const CLOSE_GAME:String = "closeGame";
		public static const ADD_MONEY:String = "addMoney";
		private var _playGame:PlayGameScreenMiniGame;
		private var gameData:GameDataMiniGame = GameDataMiniGame.getInstance();
		private var playGameLayer:Sprite;
		private var popupLayer:Sprite;
		private var noticePopup:NoticePopupMiniGame;
		
		public var giftObj:Object
		
		public function MainMiniGame():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var shadow:Sprite = new Sprite();
			shadow.graphics.beginFill(0x000000, .9);
			shadow.graphics.drawRect(0, 0, 1024, 600);
			shadow.graphics.endFill();
			addChild(shadow);
			
			playGameLayer = new Sprite();
			popupLayer = new Sprite();
			
			addChild(playGameLayer);
			addChild(popupLayer);
			
			addNoticePopup();
			
			addSound();
			
			//addInfoGame("849", 80);
			//addInfoGame("haonam01", 60000, "http://wss.test.azgame.us/");
		}
		
		private function addSound():void 
		{
			
			var arrSoundName:Array = [ConstMiniGame.FE_WIN_1, ConstMiniGame.FE_WIN_2, ConstMiniGame.FE_WIN_3,
										ConstMiniGame.M_WIN_1, ConstMiniGame.M_WIN_2, ConstMiniGame.M_WIN_3,
										ConstMiniGame.SOUND_DEAL_DISCARD, ConstMiniGame.SOUND_WIN
										] 
			var arrSound:Array = ["http://203.162.121.120/gamebai/sound/LBF01.az", 
									"http://203.162.121.120/gamebai/sound/LBF02.az",
										"http://203.162.121.120/gamebai/sound/LBF03.az", 
										"http://203.162.121.120/gamebai/sound/LBM01.az",
										"http://203.162.121.120/gamebai/sound/LBM02.az", 
										"http://203.162.121.120/gamebai/sound/LBM03.az",
										"http://203.162.121.120/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB005.az",
										"http://203.162.121.120/gamebai/bimkute/sound/AZgamebai_Sound_effect/GB011.az"
										] 
			for (var i:int = 0; i < arrSoundName.length; i++) 
			{
				
				var mySound:Sound = new Sound();
				mySound.load(new URLRequest(arrSound[i]));
				mySound.addEventListener(IOErrorEvent.IO_ERROR, loadMusicError);
				
				SoundManager.getInstance().registerSound(arrSoundName[i], mySound);
			}
		}
		
		private function loadMusicError(e:IOErrorEvent):void 
		{
			trace("ko the load nhac nen")
		}
		
		private function addNoticePopup():void 
		{
			if (!noticePopup) 
			{
				noticePopup = new NoticePopupMiniGame();
				popupLayer.addChild(noticePopup);
				noticePopup.y = 155;
				noticePopup.visible = false;
				noticePopup.addEventListener(ConstMiniGame.CLOSE_POPUP, closePopup);
				noticePopup.addEventListener(ConstMiniGame.RECEIVE_GIFT, onReceiveGift);
				noticePopup.addEventListener(ConstMiniGame.BUY_TURN_NOW, onShowBuyTurn);
				noticePopup.addEventListener(ConstMiniGame.ADD_MONEY, onAddMoney);
			}
		}
		
		private function onAddMoney(e:Event):void 
		{
			dispatchEvent(new Event(ADD_MONEY));
			noticePopup.visible = false;
		}
		
		private function onShowBuyTurn(e:Event):void 
		{
			if (_playGame) 
			{
				_playGame.showBuyTurn();
			}
			noticePopup.visible = false;
		}
		
		private function onReceiveGift(e:Event):void 
		{
			if (_playGame) 
			{
				_playGame.showAward();
			}
			noticePopup.visible = false;
		}
		
		private function closePopup(e:Event):void 
		{
			if (_playGame && _playGame.receivingGift) 
			{
				_playGame.setupContent();
				_playGame.receivingGift = false;
			}
			noticePopup.visible = false;
		}
		
		public function noticeGame(mes:String, type:Boolean = false):void 
		{
			noticePopup.addText(mes, type);
			noticePopup.visible = true;
		}
		
		public function addInfoGame(userName:String, money:int, link:String):void
		{
			gameData.myId = userName;
			gameData.myMoney = money;
			gameData.arrTypeOfCard = ["Viettel", "Mobiphone", "Vinaphone", "MegaCard", "FPT Gate"]; // arr;
			gameData.linkReq = link;
			
			getArrGift();
			
			checkEventExist();
			
			//getAccessToken();
			
		}
		
		private function getArrGift():void 
		{
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_GetListAward";
			var obj:Object = new Object();
			obj.row_start  = 1;
			obj.row_end  = 20;
			
			httpReq.sendRequest(method, str, obj, getInfoGift, true);
		}
		
		private function getInfoGift(obj:Object):void 
		{
			trace(obj)
			var arr:Array = obj.Data;
			for (var i:int = 0; i < arr.length; i++) 
			{
				GameDataMiniGame.getInstance().arrGift.push(arr[i].name);
			}
		}
		
		private function checkEventExist():void 
		{
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_GetEventInfo";
			var obj:Object = new Object();
			obj.sq_id  = 1;
			
			httpReq.sendRequest(method, str, obj, getInfoEvent, true);
		}
		
		private function getInfoEvent(obj:Object):void 
		{
			if (obj.Data.status == 0) 
			{
				noticeGame("Event không chạy, tự quay tay đi");
			}
			else if (obj.Data.status == 1 || obj.Data.status == 2) 
			{
				getAccessToken();
			}
		}
		
		private function getAccessToken():void 
		{
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayUserExt.asmx/GetAccessTokenDirectly";
			var obj:Object = new Object();
			obj.client_id = gameData.client_id;
			obj.client_secret = gameData.client_secret
			obj.client_timestamp = (new Date()).getTime();
			obj.nick_name = gameData.myId;
			obj.client_hash = MD5.encrypt(obj.client_id + obj.client_timestamp + obj.client_secret + obj.nick_name);
			httpReq.sendRequest(method, str, obj, getTokenComplete, true);
		}
		
		private function getTokenComplete(value:Object):void 
		{
			if (value.TypeMsg == '1')
			{
				gameData.token = value.Data.access_token;
				getMyTurn();
			}
			else if (value.status == "IO_ERROR")
			{
				
			}
			else
			{
				noticeGame("get access token from get message list fail !!");
			}
		}
		
		private function getMyTurn():void
		{
			var httpReq:HTTPRequestMiniGame = new HTTPRequestMiniGame();
			var method:String = "POST";
			var str:String = GameDataMiniGame.getInstance().linkReq + "Service02/OnplayGameEvent.asmx/Azgamebai_GetUserTurns";
			var obj:Object = new Object();
			obj.access_token = gameData.token;
			
			httpReq.sendRequest(method, str, obj, getMyTurnComplete, true);
			
		}
		
		private function getMyTurnComplete(obj:Object):void 
		{
			if (obj.Data) 
			{
				gameData.myTurn = obj.Data.User_Turns;
			}
			
			addMiniGame();
		}
		
		public function addMiniGame():void
		{
			if (!_playGame) 
			{
				_playGame = new PlayGameScreenMiniGame(this);
				playGameLayer.addChild(_playGame);
				_playGame.y = 155;
				_playGame.addEventListener(ConstMiniGame.CLOSE_POPUP, onCloseGame);
			}
			
			
		}
		
		public function removeMiniGame():void 
		{
			if (_playGame) 
			{
				_playGame.removeAllEvent();
				_playGame.removeEventListener(ConstMiniGame.CLOSE_POPUP, onCloseGame);
				playGameLayer.removeChild(_playGame);
				_playGame = null;
				dispatchEvent(new Event(CLOSE_GAME));
			}
			
		}
		
		private function onCloseGame(e:Event):void 
		{
			removeMiniGame();
		}
	
	}

}