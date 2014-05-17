package model 
{
	import com.electrotank.electroserver5.ElectroServer;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import event.PlayingScreenEvent;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import model.applicationDomainData.ApplicationDomainData;
	import model.chooseChannelData.ChooseChannelData;
	import model.facebookData.FacebookData;
	import model.loadingData.LoadingData;
	import model.lobbyRoomData.LobbyRoomData;
	import model.modelField.ModelField;
	import model.playingData.PlayingData;
	import view.topMenu.TopMenu;
	/**
	 * ...
	 * @author Yun
	 */
	public class MainData extends EventDispatcher
	{
		public static const TLMN:String = "tlmn";
		public static const PHOM:String = "phom";
		public static const MAUBINH:String = "maubinh";
		public static const XITO:String = "xito";
		
		public var stageWidth:Number = 960;
		public var stageHeight:Number = 600;
		public var maxPlayer:Number = 4; // số người chơi tối đa
		public var cardNumberToDown:Number = 3; // số lá bài đã đánh thì phải hạ
		public var resetMatchTime:Number = 8; // Thời gian chờ sau khi kết thúc ván
		
		public function MainData() 
		{
			
		}
		
		private static var _instance:MainData;
		public static function getInstance():MainData
		{
			if (!_instance)
				_instance = new MainData();
			return _instance;
		}
		
		// chứa nội dung của file init.xml
		private var _init:XML;
		
		public function get init():XML 
		{
			return _init;
		}
		
		public function set init(value:XML):void 
		{
			_init = value;
		}
		
		// chứa tất cả các class chứa trong các file swf
		public static const UPDATE_APP_DOMAIN_DATA:String = "updateAppDomainData";
		private var _aplicationDomainData:ApplicationDomainData;
		
		public function get aplicationDomainData():ApplicationDomainData 
		{
			if (!_aplicationDomainData)
				_aplicationDomainData = new ApplicationDomainData();
			return _aplicationDomainData;
		}
		
		public function set aplicationDomainData(value:ApplicationDomainData):void 
		{
			_aplicationDomainData = value;
			dispatchEvent(new Event(UPDATE_APP_DOMAIN_DATA));
		}
		
		// Dữ liệu loading ban đầu
		private var _loadingData:LoadingData;
		public function get loadingData():LoadingData 
		{
			if (!_loadingData)
				_loadingData = new LoadingData();
			return _loadingData;
		}
		
		public function set loadingData(value:LoadingData):void 
		{
			_loadingData = value;
		}
		
		// Dữ liệu của phòng chọn kênh
		private var _chooseChannelData:ChooseChannelData;
		public function get chooseChannelData():ChooseChannelData 
		{
			if (!_chooseChannelData)
				_chooseChannelData = new ChooseChannelData();
			return _chooseChannelData;
		}
		
		public function set chooseChannelData(value:ChooseChannelData):void 
		{
			_chooseChannelData = value;
		}
		
		// Dữ liệu của phòng lobby
		private var _lobbyRoomData:LobbyRoomData;
		public function get lobbyRoomData():LobbyRoomData 
		{
			if (!_lobbyRoomData)
				_lobbyRoomData = new LobbyRoomData();
			return _lobbyRoomData;
		}
		
		public function set lobbyRoomData(value:LobbyRoomData):void 
		{
			_lobbyRoomData = value;
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
		
		// public chat
		public static const UPDATE_PUBLIC_CHAT:String = "updatePublicChat";
		private var _publicChatData:PublicChatData;
		
		public function get publicChatData():PublicChatData 
		{
			if (!_publicChatData)
				_publicChatData = new PublicChatData();
			return _publicChatData;
		}
		
		public function set publicChatData(value:PublicChatData):void 
		{
			_publicChatData = value;
			dispatchEvent(new Event(UPDATE_PUBLIC_CHAT));
		}
		
		// close connection
		public static const CLOSE_CONNECTION:String = "closeConnection";
		private var _isCloseConnection:Boolean;
		
		public function get isCloseConnection():Boolean 
		{
			return _isCloseConnection;
		}
		
		public function set isCloseConnection(value:Boolean):void 
		{
			_isCloseConnection = value;
			if(value)
				dispatchEvent(new Event(CLOSE_CONNECTION));
		}
		
		public function get path():String 
		{
			return _path;
		}
		
		public function set path(value:String):void 
		{
			_path = value;
		}
		
		private var _path:String;
		
		// Lời mời kết bạn
		public static const INVITE_ADD_FRIEND:String = "inviteAddFriend";
		private var _inviteAddFriendData:Object;
		
		public function get inviteAddFriendData():Object 
		{
			return _inviteAddFriendData;
		}
		
		public function set inviteAddFriendData(value:Object):void 
		{
			_inviteAddFriendData = value;
			dispatchEvent(new Event(INVITE_ADD_FRIEND));
		}
		
		// Dữ liệu removeFriend
		public static const REMOVE_FRIEND:String = "removeFriend";
		private var _removeFriendData:Object;
		
		public function get removeFriendData():Object 
		{
			return _removeFriendData;
		}
		
		public function set removeFriendData(value:Object):void 
		{
			_removeFriendData = value;
			dispatchEvent(new Event(REMOVE_FRIEND));
		}
		
		// Confirm lời mời kết bạn
		public static const CONFIRM_FRIEND_REQUEST:String = "confirmFriendRequest";
		private var _confirmFriendRequestData:Object;
		
		public function get confirmFriendRequestData():Object 
		{
			return _confirmFriendRequestData;
		}
		
		public function set confirmFriendRequestData(value:Object):void 
		{
			_confirmFriendRequestData = value;
			dispatchEvent(new Event(CONFIRM_FRIEND_REQUEST));
		}
		
		// Chứa dữ liệu câu trả lời của người khác về lời mời kết bạn của mình
		public static const FRIEND_CONFIRM_ADD_FRIEND_INVITE:String = "friendConfirmAddFriendInvite";
		private var _responseAddFriendData:Object;
		
		public function get responseAddFriendData():Object 
		{
			return _responseAddFriendData;
		}
		
		public function set responseAddFriendData(value:Object):void 
		{
			_responseAddFriendData = value;
			dispatchEvent(new Event(FRIEND_CONFIRM_ADD_FRIEND_INVITE));
		}
		
		// Số min money để có thể chơi
		private var _minMoney:Number;
		
		public function get minMoney():Number 
		{
			return _minMoney;
		}
		
		public function set minMoney(value:Number):void 
		{
			_minMoney = value;
		}
		
		// Lý do bị server kick
		public static const SERVER_KICK_OUT:String = "serverKickOut";
		private var _serverKickOutData:String;
		
		public function get serverKickOutData():String 
		{
			return _serverKickOutData;
		}
		
		public function set serverKickOutData(value:String):void 
		{
			_serverKickOutData = value;
			dispatchEvent(new Event(SERVER_KICK_OUT));
		}
		
		public static const LOG_OUT_CLICK:String = "logOutClick";
		private var _isLogOut:Boolean;
		
		public function get isLogOut():Boolean 
		{
			return _isLogOut;
		}
		
		public function set isLogOut(value:Boolean):void 
		{
			_isLogOut = value;
			if (value)
				dispatchEvent(new Event(LOG_OUT_CLICK));
		}
		
		private var _isRecentlyClickQuickPlay:Boolean;
		
		public function get isRecentlyClickQuickPlay():Boolean 
		{
			return _isRecentlyClickQuickPlay;
		}
		
		public function set isRecentlyClickQuickPlay(value:Boolean):void 
		{
			_isRecentlyClickQuickPlay = value;
		}
		
		private var _main:DisplayObject;
		
		public function get main():DisplayObject 
		{
			return _main;
		}
		
		public function set main(value:DisplayObject):void 
		{
			_main = value;
		}
		
		public function get lastCardValues():Array 
		{
			if (!_lastCardValues)
				_lastCardValues = new Array();
			return _lastCardValues;
		}
		
		public function set lastCardValues(value:Array):void 
		{
			_lastCardValues = value;
		}
		
		private var _lastCardValues:Array; // Mảng giá trị các quân bài của người chơi trc đó vừa đánh
		
		public static const UPDATE_FACEBOOK_DATA :String = "updateFacebookData";
		private var _facebookData:FacebookData;
		
		public function get facebookData():FacebookData 
		{
			return _facebookData;
		}
		
		public function set facebookData(value:FacebookData):void 
		{
			_facebookData = value;
			dispatchEvent(new Event(UPDATE_FACEBOOK_DATA));
		}
		
		public static const LOGIN_FACEBOOK_FAIL:String = "loginFacebookFail";
		private var _isLoginFacebookFail:Boolean;
		
		public function get isLoginFacebookFail():Boolean 
		{
			return _isLoginFacebookFail;
		}
		
		public function set isLoginFacebookFail(value:Boolean):void 
		{
			_isLoginFacebookFail = value;
			if (value)
				dispatchEvent(new Event(LOGIN_FACEBOOK_FAIL));
		}
		
		private var _tracker:AnalyticsTracker;
		
		public function get tracker():AnalyticsTracker 
		{
			if (!_tracker) {
				_tracker = new GATracker( _main, "UA-18569083-1", "AS3", false);
			}
			return _tracker;
		}
		
		public function set tracker(value:AnalyticsTracker):void 
		{
			_tracker = value;
		}
		
		public var isFirstPlay:Boolean; // Biến để check xem mình có phải người đầu tiên đánh bài của ván bài ko
		
		public var isEndRound:Boolean; // Biến để check xem mình có phải vừa kết thúc 1 vòng đánh bài ko
		
		public var isTLMN123:Boolean; // Biến để check xem mình có phải là tlmn nhất nhì ba hay tlmn đếm lá
		
		public var gameType:String;
		
		public var isSelectOpenCard:Boolean; // Biến check việc đã mở quân bài đầu tiên hay chưa
		
		public var currentTotalMoney:Number = 0; // Số tiền tổng hiện tại trong bàn
		
		public var startMoney:Number = 0; // Số tiền ban đầu cho vào bàn
		
		public var betMoneyOfPreviousUser:Number = 0; // Mức cược của người trc đó
		
		public var actionStatus:int = 1; // Lưu trạng thái hiện tại của bàn chơi
		
		public var maxMoneyOfRound:Number; // Số tiền lớn nhất hiện tại mà một người đang bỏ ra của vòng tố
		
		public var moneyOfCurrentUser:Number = 0; // số tiền của user đang có lượt tố.
		
		public var isHaveOrderCard:Boolean = false;
		
		public var tlmnLoader:Loader;
		public var isLoadTlmnComplete:Boolean;
		public var loginData:Object;
		
		public var gameIp:String = "123.30.210.59";
		public var electroInfo:Object;
		public var game_id:String = '';
		
		public var phone1:String = "7739";
		public var phone2:String = "5678";
		
		public var description1:String = "Phí dịch vụ 15k/tin";
		public var description2:String = "Phí dịch vụ 5k/tin";
		
		public var sendSmsSentence:String = "Ciao ";
		
		public var isOnIos:Boolean;
		public var isOnAndroid:Boolean;
		
		public var isOnLoginWindow:Boolean;
		public var isOnSelectGameWindow:Boolean;
		
		public var topMenu:TopMenu;
		
		public var showFullTable:int = 1;
		public var showBusyUser:int = 0;
		
		public var showBubbleChatTime:Number = 4;
		
		public var isNoRenderLobbyList:Boolean;
		
		public var minBetRate:int = 0;
		
		public var isJoiningRoom:Boolean;
		
		public var isActive:Boolean = true;
		
		public var isScrollingRoomList:Boolean;
		
		public var isPhomGa:Boolean;
		public var gaData:Object;
		
		
		public static const MAUBINH_ID:int = 1;
		public static const PHOM_ID:int = 2;
		public static const TLMN_ID:int = 3;
		
		
		public var isLoginFacebook:Boolean;
		public var isAutoReady:Boolean;
		public var roomListState:int = 1; // Biến để check roomList ở lobby đang ở tab nào
		public var userListState:int = 1; // Biến để check userList ở lobby đang ở tab nào
		public var inviteList:Object = new Object();
		public var gameName:String;
		public var client_id:String = "100000000000021";
		public var client_secret:String = "71fbf6e77e1ccb779c5f51c38a4e795c";
		public var portNumber:int = 9899;
		public var isFirstJoinLobby:Boolean;
		public var electroServer:ElectroServer;
		public var lobbyRoomId:int = -1;
		public var currentChannelId:int = 0;
	}

}