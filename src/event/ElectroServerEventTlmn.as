package event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ElectroServerEventTlmn extends Event 
	{
		public static const CLOSE_CONNECTION:String = "closeConnection";
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		public static const PLUGIN_NOT_FOUND:String = "pluginNotFound";
		public static const CONNECT_FAIL:String = "connectFail";
		public static const LOGIN_SUCCESS:String = "loginSuccess";
		public static const LOGIN_FAIL:String = "loginFail";
		public static const JOIN_LOBBY_ROOM_SUCCESS:String = "joinLobbyRoomSuccess";
		public static const UPDATE_USER_LIST:String = "updateUserList";
		public static const UPDATE_USER_LIST_OF_LOBBY:String = "updateUserListOfLobby";
		public static const UPDATE_ROOM_LIST:String = "updateRoomList";
		public static const JOIN_GAME_ROOM_SUCCESS:String = "joinGameRoomSuccess";
		public static const JOIN_GAME_ROOM_FAIL:String = "joinGameRoomFail";
		public static const GAME_ROOM_INVALID:String = "gameRoomInvalid";
		public static const HAVE_USER_JOIN_ROOM:String = "haveUserJoinRoom";
		public static const HAVE_USER_OUT_ROOM:String = "haveUserOutRoom";
		public static const READY_SUCCESS:String = "readySuccess";
		public static const START_GAME_SUCCESS:String = "startGameSuccess";
		public static const PUBLIC_CHAT:String = "publicChat";
		public static var ROOM_MASTER_KICK:String = "roomMasterKick";
		public static var TIME_OUT:String = "timeOut";
		public static var HACKING:String = "hacking";
		public static const HAVE_INVITE_PLAY:String = "haveInvitePlay";
		public static const INVITE_ADD_FRIEND:String = "inviteAddFriend";
		public static const CONFIRM_FRIEND_REQUEST:String = "confirmFriendRequest";
		public static var ADD_MONEY:String = "addMoney";
		public static const SORT_FINISH:String = "sortFinish";
		public static var COMPARE_GROUP:String = "compareGroup";
		public static var WHITE_WIN:String = "whiteWin";
		public static var DICE:String = "dice";
		public static const UPDATE_MONEY:String = "updateMoney";
		public static const CONFIRM_ADD_FRIEND:String = "confirmAddFriend";
		public static const FRIEND_CONFIRM_ADD_FRIEND_INVITE:String = "friendConfirmAddFriendInvite";
		public static const REMOVE_FRIEND:String = "removeFriend";
		public static var REQUEST_TIME_CLOCK:String = "requestTimeClock";
		public static var RESPOND_TIME_CLOCK:String = "respondTimeClock";
		public static var REQUEST_IS_COMPARE_GROUP:String = "requestIsCompareGroup";
		public static var RESPOND_IS_COMPARE_GROUP:String = "respondIsCompareGroup";
		public static var COMPARE_GROUP_COMPLETE:String = "compareGroupComplete";
		public static const GET_CARD_SUCCESS:String = "getCardSuccess";
		public static const STEAL_CARD:String = "stealCard";
		public static const UPDATE_ROOM_MASTER:String = "updateRoomMaster";
		public static const ERROR:String = "error";
		public static const GET_CURRENT_PLAYER:String = "getCurrentPlayer";
		public static const GET_FIRST_PLAYER:String = "getFirstPlayer";
		public static const SEND_ADD_FRIEND_SUCCESS:String = "sendAddFriendSuccess";
		public static const HAVE_USER_GET_CARD:String = "haveUserGetCard";
		public static const HAVE_USER_DOWN_CARD:String = "haveUserDownCard";
		public static const HAVE_USER_DOWN_CARD_FINISH:String = "haveUserDownCardFinish";
		public static const HAVE_USER_SEND_CARD_FINISH:String = "haveUserSendCardFinish";
		public static const HAVE_USER_SEND_CARD:String = "haveUserDownSend";
		public static const GAME_OVER:String = "gameOver";
		public static const DEAL_CARD:String = "dealCard";
		public static const HAVE_USER_DISCARD:String = "haveUserDiscard";
		public static const UPDATE_MONEY_SPECIAL:String = "updateMoney_special";
		
		public static const LIST_BEFORE_START:String = "resetNewGame";
		
		public static const NEXTTURN:String = "nextturn";
		static public const UPDATE_ALL_INFO_LOBBY:String = "updateAllInfoLobby";
		static public const GET_MONEY:String = "getMoney";
		public static const HAVE_UPDATE_CURRENT_TURN:String = "updateCurrentTurn";
		public static const HAVE_UPDATE_MASTER:String = "updateRoomMaster";
		public static const END_ROUND:String = "endRound";
		
		public var data:Object;
		
		public function ElectroServerEventTlmn(eventName:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(eventName, bubbles, cancelable);
			data = _data;
		}
		
	}

}