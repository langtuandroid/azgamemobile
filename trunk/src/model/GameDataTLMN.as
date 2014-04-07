package model 
{
	import control.ConstTlmn;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import model.playingData.PlayingData;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class GameDataTLMN extends EventDispatcher 
	{
		private static var instance:GameDataTLMN;
		public var arrNameSwf:Array = [["loading.swf", "loading"],
										["lobbyscreen.swf", "lobby"],
										["playgameScreen.swf", "play", 
											"KichThich/Notice/NoticeGame.swf", "notice"]
										];
		public var arrNameSwfEng:Array = [["loading.swf", "loading"],
										["lobbyscreenEng.swf", "lobby"],
										["playgameScreenEng.swf", "play", 
											"KichThich/Notice/NoticeGame.swf", "notice"]
										];
		/**
		 * 1:tieng viet, 2: teing anh
		 */
		public var language:int = 1;
		private var _usersObject:Object = new Object();
		private var _friendListObject:Object = new Object();
		private var _roomsObject:Object = new Object();
		
		private var _myInfoObject:Object = new Object();
		
		public var notEnoughMoney:Boolean = false;
		
		public var arrHaveUserInvite:Array = [];
		public var playGameData:Object = new Object();//luu lai thong tin de vao ban choi
		
		/** thông tin mình đang ở loại nào, 0: tất cả, 1:campuchia(bet < 100), 2:lasvegas(bet >=100)
		  **/
		public var typeOfBoard:int = 0;
		/** thông tin mình đang ở loại nào, 0: tất cả, 1:bạn bè
		  **/
		public var typeOfUser:int = 0;
		
		private var _publicChat:Object = new Object();
		
		private var _haveUserInvite:Object = new Object();
		
		private var _master:String = "";
		public var checkBetting:Boolean = false;
		
		private var _hightestIndex:String;
		public var stageIDForGame:Boolean;
		public var chiaChuong:Boolean = false;
		
		public var errorGame:String = "";
		public var _moneyMask:int;
		public var firstGame:Boolean = false;
		
		private var _userInfo:Object = new Object();
		private var _noticeFriend:String;
		private var _swf:Array = [];
		public var inLobby:Boolean = false;
		
		public var giftTicket:int;
		
		public var checkFullScreen:Boolean = false;
		
		private var _playSound:Boolean = true;
		public var playGameBackGroud:Boolean = true;
		
		private var _objRoomDel:Object = new Object();
		
		public var arrEmoticonChat:Array;
		
		public var autoReady:Boolean = false;
		public var finishRound:Boolean = false;
		public var firstPlayer:String;
		public var currentPlayer:String;
		
		public var zoneId:int;
		public var roomId:int = -1;
		public var lobbyRoomId:int;
		
		public var userList:Object;
		public var friendList:Object;
		public var userListOfLobby:Object;
		public var roomList:Object;
		public var roomListUpdate:Object; // dùng để lưu lại những room vừa có update
		public var arrRoomName:Array;
		//public var myName:String = "";
		
		public var channelId:int = -1;
		public var gameName:String = "LobbyTLMN";
		public var gameRoomInfo:Object;
		public var gameType:String = "TienLenMNPlugin";
		public var lobbyName:String = "LobbyTLMN";
		public var lobbyPluginName:String = "LobbyTLMNPlugin";
		public var gameZone:String = "tlmnZone";
		public var isFirstLoad:Boolean;
		public var isFirstLoadGame:Boolean;
		public var countRoom:int;
		public var totalRoom:int;
		public var countGame:int;
		public var typeSound:String;
		public var levelLobby:String = "Đại sảnh";
		public var saveUserList:Object;
		
		public function GameDataTLMN() 
		{
			
		}
		
		
		public static function getInstance():GameDataTLMN 
		{
			if (!instance) 
			{
				instance = new GameDataTLMN();
			}
			return instance;
		}
		
		
		public function get usersObject():Object 
		{
			return _usersObject;
		}
		
		public function set usersObject(value:Object):void 
		{
			_usersObject = value;
			dispatchEvent(new Event(ConstTlmn.UPDATE_USERLIST));
		}
		
		public function get roomsObject():Object 
		{
			return _roomsObject;
		}
		
		public function set roomsObject(value:Object):void 
		{
			_roomsObject = value;
			dispatchEvent(new Event(ConstTlmn.UPDATE_ROOMLIST));
		}
		
		public function get myInfoObject():Object 
		{
			return _myInfoObject;
		}
		
		public function set myInfoObject(value:Object):void 
		{
			_myInfoObject = value;
			dispatchEvent(new Event(ConstTlmn.UPDATE_USER_INFO));
		}
		
		public function get publicChat():Object 
		{
			return _publicChat;
		}
		
		public function set publicChat(value:Object):void 
		{
			_publicChat = value;
			dispatchEvent(new Event(ConstTlmn.HAVE_CHAT));
		}
		
		// Dữ liệu của phòng chơi
		private var _playingData:PlayingData;
		public function get playingData():PlayingData 
		{
			if (!_playingData)
				_playingData = new PlayingData();
			return _playingData;
		}
		
		public function set playingData(value:PlayingData):void 
		{
			_playingData = value;
		}
		
		public function get haveUserInvite():Object 
		{
			return _haveUserInvite;
		}
		
		public function set haveUserInvite(value:Object):void 
		{
			_haveUserInvite = value;
			dispatchEvent(new Event(ConstTlmn.HAVE_USER_INFO));
		}
		
		public function get hightestIndex():String 
		{
			return _hightestIndex;
		}
		
		public function set hightestIndex(value:String):void 
		{
			_hightestIndex = value;
			dispatchEvent(new Event(ConstTlmn.HIGHTEST_INDEX));
		}
		
		public function get master():String 
		{
			return _master;
		}
		
		public function set master(value:String):void 
		{
			_master = value;
			//dispatchEvent(new Event(Const.CHANGE_MASTER));
		}
		
		public function get friendListObject():Object 
		{
			return _friendListObject;
		}
		
		public function set friendListObject(value:Object):void 
		{
			_friendListObject = value;
			dispatchEvent(new Event(ConstTlmn.UPDATE_FRIEND_LIST));
		}
		
		public function get userInfo():Object 
		{
			return _userInfo;
		}
		
		public function set userInfo(value:Object):void 
		{
			_userInfo = value;
			dispatchEvent(new Event(ConstTlmn.HAVE_INFO_USER_NEED_CHECK));
		}
		
		public function get noticeFriend():String 
		{
			return _noticeFriend;
		}
		
		public function set noticeFriend(value:String):void 
		{
			_noticeFriend = value;
			dispatchEvent(new Event(ConstTlmn.NOTICE_FRIEND));
		}
		
		
		public function get swf():Array 
		{
			return _swf;
		}
		
		public function set swf(value:Array):void 
		{
			_swf = value;
			dispatchEvent(new Event(ConstTlmn.ADD_NEW_SWF));
		}
		
		
		public function get playSound():Boolean 
		{
			return _playSound;
		}
		
		public function set playSound(value:Boolean):void 
		{
			_playSound = value;
			dispatchEvent(new Event(ConstTlmn.PLAYSOUND));
		}
		
		public function get objRoomDel():Object 
		{
			return _objRoomDel;
		}
		
		public function set objRoomDel(value:Object):void 
		{
			_objRoomDel = value;
			dispatchEvent(new Event(ConstTlmn.DEL_ROOM));
		}
		
	}

}