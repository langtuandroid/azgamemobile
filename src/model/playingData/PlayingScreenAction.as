package model.playingData 
{
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenAction 
	{
		public static const JOIN_ROOM:String = "joinRoom";
		public static const HAVE_USER_JOIN_ROOM:String = "haveUserJoinRoom";
		public static const HAVE_USER_OUT_ROOM:String = "haveUserOutRoom";
		public static const DEAL_CARD:String = "dealCard";
		public static const HAVE_USER_DISCARD:String = "haveUserDiscard";
		public static const GET_CARD_SUCCESS:String = "getCardSuccess";
		public static const HAVE_USER_GET_CARD:String = "haveUserGetCard";
		public static const HAVE_USER_STEAL_CARD:String = "haveUserStealCard";
		public static const HAVE_USER_DOWN_CARD:String = "haveUserDownCard";
		public static const HAVE_USER_DOWN_CARD_FINISH:String = "haveUserDownCardFinish";
		public static const HAVE_USER_SEND_CARD_FINISH:String = "haveUserSendCardFinish";
		public static const HAVE_USER_SEND_CARD:String = "haveUserSendCard";
		public static const HAVE_USER_NEXT_TURN:String = "haveUserNextTurn";
		public static const READY_SUCCESS:String = "readySuccess";
		public static const START_GAME_SUCCESS:String = "startGameSuccess";
		public static const UPDATE_MONEY:String = "updateMoney";
		public static const UPDATE_ROOM_MASTER:String = "updateRoomMaster";
		public static var ROOM_MASTER_KICK:String = "roomMasterKick";
		public static var GAME_OVER:String = "gameOver";
		public static const UPDATE_CURRENT_TURN:String = "updateCurrentTurn";
		public static const SORT_FINISH:String = "sortFinish";
		public static const HAVE_USER_REQUEST_TIME_CLOCK:String = "haveUserRequestTimeClock";
		public static const HAVE_USER_RESPOND_TIME_CLOCK:String = "haveUserRespondTimeClock";
		public static const HAVE_USER_REQUEST_IS_COMPARE_GROUP:String = "haveUserRequestIsCompareGroup";
		public static const HAVE_USER_RESPOND_IS_COMPARE_GROUP:String = "haveUserRespondIsCompareGroup";
		public static const COMPARE_GROUP_COMPLETE:String = "compareGroupComplete";
		public static var WHITE_WIN:String = "whiteWin";
		
		public static var COMPARE_GROUP:String = "compareGroup";
		
		public static const HAVE_USER_OPEN_CARD:String = "haveUserOpenCard";
		public static const CHECK:String = "check";
		public static const FOLD:String = "fold";
		public static const CALL:String = "call";
		public static const ALL_IN:String = "allIn";
		public static const RAISE:String = "raise";
		public static const DEAL_MORE_CARD:String = "dealMoreCard";
		public static var END_ROUND:String = "endRound";
		
		public var actionName:String;
		public var data:Object;
		
		public function PlayingScreenAction() 
		{
			
		}
		
	}

}