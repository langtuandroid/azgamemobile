package event 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Command 
	{
		public static const PRIVATE_CHAT: String = "privateChat";
		public static const PUBLIC_CHAT: String = "publicChat";
		public static var UPDATE_CURRENT_GAME_ROOM:String = "updateCurrentGameRoom";
		public static var INVITE_PLAY:String = "invitePlay";
		public static var INVITE_ADD_FRIEND:String = "inviteAddFriend";
		public static var GET_PLAYING_INFO:String = "getPlayingInfo";
		public static var GET_FRIEND_LIST:String = "getFriendList";
		public static var GET_ROOM_LIST:String = "getRoomList";
		public static var READY:String = "ready";
		public static var START_GAME:String = "startGame";
		public static var DISCARD:String = "discard";
		public static var UPDATE_ROOM_MASTER:String = "updateRoomMaster";
		public static var ADD_FRIEND:String = "addFriend";
		public static var REMOVE_FRIEND:String = "removeFriend";
		public static var ADD_MONEY:String = "addCiao";
		public static var CONFIRM_FRIEND_REQUEST:String = "confirmFriendRequest";
		public static var CONFIRM_ADD_FRIEND_INVITE:String = "confirmAddFriendInvite";
		public static var GAME_OVER:String = "gameOver";
		public static var GAME_OVER_SPECIAL:String = "gameOverSpecial";
		public static var WHITE_WIN:String = "whiteWin";
		public static var CARD_RESPONSE:String = "cardResponse";
		public static var DEAL_CARD:String = "dealCard";
		public static var UPDATE_PLAYER_INFO:String = "updatePlayerInfo";
		public static var USER_JOINED:String = "userjoined";
		public static var USER_LEFT:String = "userleft";
		public static var USER_INFO:String = "userInfo";
		public static var ROOM_UPDATED:String = "roomupdated";
		public static var ROOM_CREATED:String = "roomcreated";
		public static var ROOM_DELETED:String = "roomdeleted";
		public static var CREATED:String = "created";
		public static var UPDATED:String = "updated";
		public static var HEART_BEAT:String = "heartBeat";
		public static var KICK_USER:String = "kickUser";
		public static var ROOM_MASTER_KICK:String = "roomMasterKick";
		public static var TIME_OUT:String = "timeOut";
		public static var HACKING:String = "hacking";
		public static var REFRESH_MONEY:String = "refreshMoney";
		public static var NEXT_TURN:String = "nextTurn";
		public static var START_GAME_1:String = "startGame1";
		public static var UPDATE_POT:String = "updatePot";
		
		public static var LAYING_CARD:String = "layingCard";
		public static var LAYING_DONE:String = "layingDone";
		public static var SEND_CARD:String = "sendCard";
		public static var SEND_CARD_FINISH:String = "sendCardFinish";
		public static var FULL_LAYING_CARDS:String = "fullLayingCards";
		public static var DRAW_CARD:String = "drawCard";
		public static var STEAL_CARD:String = "stealCard";
		public static var SORT_FINISH:String = "sortFinish";
		
		public static var REQUEST_TIME_CLOCK:String = "requestTimeClock";
		public static var REQUEST_IS_COMPARE_GROUP:String = "requestIsCompareGroup";
		public static var RESPOND_IS_COMPARE_GROUP:String = "respondIsCompareGroup";
		public static var COMPARE_GROUP_COMPLETE:String = "compareGroupComplete";
		public static var RESPOND_TIME_CLOCK:String = "respondTimeClock";
		
		public static var COMPARE_GROUP_1:String = "compareGroup1";
		public static var COMPARE_GROUP_2:String = "compareGroup2";
		public static var COMPARE_GROUP_3:String = "compareGroup3";
		public static var SELECT_OPEN_CARD:String = "selectOpenCard";
		public static var END_ROUND:String = "endRound";
		public static var UPDATE_LOBBY_INFO:String = "updateLobbyInfo";
		
		public function Command() 
		{
			
		}
		
	}

}