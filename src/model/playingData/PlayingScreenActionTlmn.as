package model.playingData 
{
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingScreenActionTlmn 
	{
		public static const JOIN_ROOM:String = "joinRoom";
		public static const HAVE_USER_JOIN_ROOM:String = "haveUserJoinRoom";
		public static const HAVE_USER_REQUEST_TIME_CLOCK:String = "haveUserRequestTimeClock";
		public static const HAVE_USER_RESPOND_TIME_CLOCK:String = "haveUserRespondTimeClock";
		public static const HAVE_USER_REQUEST_IS_COMPARE_GROUP:String = "haveUserRequestIsCompareGroup";
		public static const HAVE_USER_RESPOND_IS_COMPARE_GROUP:String = "haveUserRespondIsCompareGroup";
		public static const COMPARE_GROUP_COMPLETE:String = "compareGroupComplete";
		public static const HAVE_USER_OUT_ROOM:String = "haveUserOutRoom";
		public static const DEAL_CARD:String = "dealCard";
		public static const HAVE_USER_DISCARD:String = "haveUserDiscard";
		public static const GET_CARD_SUCCESS:String = "getCardSuccess";
		public static const READY_SUCCESS:String = "readySuccess";
		public static const START_GAME_SUCCESS:String = "startGameSuccess";
		public static const HAVE_USER_GET_CARD:String = "haveUserGetCard";
		public static const HAVE_USER_STEAL_CARD:String = "haveUserStealCard";
		public static const HAVE_USER_DOWN_CARD:String = "haveUserDownCard";
		public static const HAVE_USER_DOWN_CARD_FINISH:String = "haveUserDownCardFinish";
		public static const HAVE_USER_SEND_CARD_FINISH:String = "haveUserSendCardFinish";
		public static const HAVE_USER_SEND_CARD:String = "haveUserSendCard";
		public static const SORT_FINISH:String = "sortFinish";
		public static var COMPARE_GROUP:String = "compareGroup";
		public static var WHITE_WIN:String = "whiteWin";
		public static var DICE:String = "dice";
		public static const UPDATE_ROOM_MASTER:String = "updateRoomMaster";
		public static var ROOM_MASTER_KICK:String = "roomMasterKick";
		public static var GAME_OVER:String = "gameOver";
		public static const UPDATE_MONEY:String = "updateMoney";
		
		public static const GET_FIRST_PLAYER:String = "getFirstPlayer";
		public static const GET_CURRENT_PLAYER:String = "getCurrentPlayer";
		public static const ERROR:String = "error";
		public static const NEXTTURN:String = "nextturn";
		public static const END_ROUND:String = "endRound";
		public static const UPDATE_MONEY_SPECIAL:String = "updateMoney_special";
		static public const SHOW_WARNNING:String = "showWarnning";
		
		public var actionName:String;
		public var data:Object;
		
		public function PlayingScreenActionTlmn() 
		{
			
		}
		
	}

}