package miniGame
{
	import com.gsolo.encryption.MD5;
	import flash.display.Sprite;
	import flash.events.Event;
	import miniGame.request.HTTPRequestMiniGame;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class MainMiniGame extends Sprite
	{
		public static const CLOSE_GAME:String = "closeGame";
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
			shadow.graphics.beginFill(0x000000, .2);
			shadow.graphics.drawRect(0, 0, 1024, 600);
			shadow.graphics.endFill();
			addChild(shadow);
			
			playGameLayer = new Sprite();
			popupLayer = new Sprite();
			
			addChild(playGameLayer);
			addChild(popupLayer);
			
			addNoticePopup();
			
			//addInfoGame("849", 80);
			//addInfoGame("haonam01", 60000, "http://wss.test.azgame.us/");
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
			}
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
			gameData.myTurn = obj.Data.User_Turns;
			addMiniGame();
		}
		
		public function addMiniGame():void
		{
			_playGame = new PlayGameScreenMiniGame(this);
			playGameLayer.addChild(_playGame);
			_playGame.y = 155;
			_playGame.addEventListener(ConstMiniGame.CLOSE_POPUP, onCloseGame);
			
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