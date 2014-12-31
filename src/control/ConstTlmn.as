package control 
{
	/**
	 * ...
	 * @author bimkute
	 */
	public class ConstTlmn 
	{
		public static var LOAD_LOADING_COMPLETE:String = "loadingComplete";
		public static var LOAD_SWF_COMPLETE:String = "loadComplete";
		
		public static var LOGIN_SUCCESS:String = "loginSuccess";
		public static var LOGIN_FAIL:String = "loginFail";
		
		public static var NAME_SWF_LOADING:String = "loading";
		public static var NAME_SWF_LOBBY:String = "lobby";
		public static var NAME_SWF_PLAY:String = "play";
		
		public static var CONNECT_SUCCESS:String = "connect_success";
		public static var CONNECT_FAIL:String = "connect_fail";
		public static var DISCONNECT:String = "disconnect";
		
		public static var UPDATE_USERLIST:String = "update_userlist";
		public static var UPDATE_ROOMLIST:String = "update_roomlist";
		
		public static var AVATAR:String = "avatar";
		public static var ISFRIEND:String = "isFriend";
		public static var DISPLAY_NAME:String = "displayName";
		public static var COIN:String = "coin";
		public static var GOLD:String = "gold";
		public static var LEVEL:String = "level";
		public static var HISTORY:String = "history";
		public static var ONLINE:String = "online";
		
		public static var UPDATE_USER_INFO:String = "updateUserInfo";
		public static var UPDATE_FRIEND_LIST:String = "updateFriendList";
		public static var CLOSE:String = "close";
		public static var CLOSE_CONNECT:String = "closeConnect";
		public static var BETTING:String = "betLevel";
		public static var PASSWORD:String = "password";
		public static var CREATER:String = "creater";
		public static var ROOMNAME:String = "roomName";//name nguoi choi dat
		public static var ROOMVARIABLE:String = "roomVariables";//nhung thong so cua room
		public static var OUT_ROOM:String = "outRoom";
		public static var ROOM:String = "room";
		
		static public var POSSITION:String = "position";
		
		public static var ADD_NEW_SWF:String = "addNewSwf";
		
		public static var ID:String = "id";
		public static var NAME:String = "name";//name tu minh dat de phan biet room, dung khi nao can gui len server
		public static var USER_COUNT:String = "userCount";
		public static var MAX_USER:String = "maxUsers";
		public static var PLAYER_LIST:String = "playerList";
		public static var NUM_USERS:String = "numUsers";
		public static var READY:String = "ready";
		public static var TYPE_LOSE:String = "loaiThoi";
		public static var USER_KICK:String = "userKick";
		
		public static var INVITOR:String = "invitor";
		public static var PLAYER_NAME:String = "userName";
		public static var USER_LIST:String = "userList";
		public static var CARD_LIST:String = "cardList";
		
		public static var MESSAGE:String = "message";
		
		public static var COIN_CHANGE:String = "coinChanged";
		public static var NEW_COIN:String = "newCoin";
		public static var USER_POINT:String = "userPoin";
		public static var JOIN_ROOM_INVITE:String = "joinRoomInvite";
		
		public static const RESULT_CARD_LIST:int = 0;
		public static const RESULT_PLAYER_NAME:int = 1;
		public static const RESULT_USER_POINT:int = 2;
		public static const RESULT_NEW_COIN:int = 4;
		public static const RESULT_COIN_CHANGE:int = 3;
		static public const PLAYSOUND:String = "playsound";
		public static var FIND_GAME:String = "findGame";
		public static var FIRST_GAME:String = "firstGame";
		public static var GET_MY_FRIEND_LIST:String = "getFriendList";
		public static var GET_USER_LIST:String = "getUserList";
		public static var NUM_USER_MAX:int = 4;
		public static var DEL_ROOM:String = "delRoom";
		
		public static var ADD_FRIEND_SUCCESS:String = "success";
		public static var WEB_UPDATE:String = "webUpdate";
		public static var BUY_AVATAR:String = "buyAvatar";
		public static var USE_AVATAR:String = "useAvatar";
		public static var BUY_ITEM:String = "buyItem";
		
		public static var WARNNING:String = "isSam";
		
		/**
		 * type: CONG = 1, 2_DEN = 2, 2_DO = 3, 3_BICH = 4, 4_QUY = 5, 4_DOI_THONG = 6, 3_DOI_THONG = 7
		 */
		
		public static var HIGHTEST_INDEX:String = "hightestIndex";
		
		
		public static var NOT_ENOUGH_MONEY:String = "not_enough_money";
		public static var CREATE_ROOM:String = "create_room";
		public static var HAVE_NOT_ROOMNAME:String = "have_not_roomName";
		public static var AGREE:String = "agree";
		public static var NEXT_TURN:String = "nextTurn";
		public static var NEW_TURN:String = "newTurn";
		public static var DISCARD:String = "disCard";
		public static var END_GAME:String = "endGame";
		
		public static var PLUS_MONEY:String  = "plusMoney";
		public static var SUB_MONEY:String  = "subMoney";
		public static var PLUS_USER:String  = "plusUser";
		public static var SUB_USER:String  = "subUser";
		
		public static var ADD_FRIEND:String = "addFriend";
		public static var REMOVE_FRIEND:String = "removeFriend";
		public static var NOTICE_FRIEND:String = "noticeFriend";
		public static var MONEY:String = "money";
		
		public static var CHOSE_ROOM:String = "choseRoom";
		public static var DEL_INVITE_TIMER:String = "delInviteTimer";
		public static var DEL_INVITE:String = "delInvite";
		public static var DEAL_COMPLETE:String = "dealComplete";
		public static var CHOSE_INVITE:String = "choseInvite";
		public static var OVER_TIME:String = "overTime";
		public static var JOIN_GAME_ROOM_SUCCESS:String = "joinGameRoomSuccess";
		public static var HAVE_CHAT:String = "haveChat";
		public static var CHAT_CONTENT:String = "chatContent";
		public static var ISME:String = "isMe";
		public static var INVITE:String = "invite";
		public static var MASTER:String = "master";
		public static var BET_MONEY:String = "betInfor";
		public static var HAVE_USER_INFO:String = "haveUserInfo";
		public static var HAVE_INFO_USER_NEED_CHECK:String = "haveUserInfoNeedCheck";
		public static var CANCEL_TURN:String = "cancelTurn";
		static public var DATA:String = "data";
		/**
		 * PLAYER_JOIN = 0;DEAL_CARDS = 1, BET_TIME = 2;OPEN_CARDS = 3;SHOW_RESULT = 4;
			
		 */
		public static var STAGEID:String = "stageID";
		public static var GAME_STAGE_ID:String = "stage";
		public static var GAME_STAGE:String = "playStatus";//biet choi game
		public static var TIME_REMAIN:String = "Time";
		public static var CARDS:String = "cards";
		
		public static var PLAY_WITH_FRIEND:String = "playWithFriend";
		public static var INVITE_PLAY_SPECIAL:String = "invitePlaySpecial";
		
		public static var PLAYER_BETED:String = "userBetted";
		public static var PLAYER_BET:String = "userBet";
		public static var MONEY_BET:String = "bet";
		public static var TYPE_BET:String = "type";
		static public var WRONG_PASS:String = "wrongPass";
		static public var WHITE_WIN:String = "perfectWin";
		
		public static var SLOT_1:String = "slot1";
		public static var SLOT_2:String = "slot2";
		public static var SLOT_3:String = "slot3";
		public static var SLOT_4:String = "slot4";
		
		public static var CARD_REMAIN:String = "cardRemain";
		static public var CHANGE_MASTER:String = "changeMaster";
		
		public static var xBet:int = 10;//tien cua minh phai bang tien cuoc nhan voi so nay
		public static var linkAvatar:String = "http://gamebai888.com/";//avatar sẽ lấy theo link này
		
		public static var SANH_RONG:int = 1;
		public static var CAY_DONG_MAU:int = 2;
		public static var SAU_DOI:int = 3;
		public static var NAM_DOI_THONG:int = 4;
		public static var TU_QUY_2:int = 5;
		public static var TU_QUY_3:int = 6;
		public static var BA_DOI_THONG_3_BICH:int = 7;
		public static var BON_DOI_THONG_3_BICH:int = 8;
		
		public static var INPUT_PASS:String = "inputPass";
		
		//text
		public static var NOTICE_START_GAME_TEXT:String = "Xin đợi người khác vào chơi..";
		public static var NOTICE_START_GAME_TEXT_ENG:String = "Xin đợi người khác vào chơi..";
		
		public static var NOTICE_READY_GAME_TEXT:String = "Xin đợi người khác sẵn sàng..";
		public static var NOTICE_READY_GAME_TEXT_ENG:String = "Xin đợi người khác sẵn sàng..";
		
		public static var READY_TEXT:String = "Đợi chủ bàn bắt đầu ván chơi.";
		public static var READY_TEXT_ENG:String = "Đợi chủ bàn bắt đầu ván chơi.";
		
		public static var NOT_ENOUGH_MONEY_TEXT:String = "Bạn không đủ Xu để tiếp tục chơi game. Xin vui lòng nạp thêm Xu vào tài khoản!!!";
		public static var NOT_ENOUGH_MONEY_TEXT_ENG:String = "Bạn không đủ Xu để tiếp tục chơi game. Xin vui lòng nạp thêm Xu vào tài khoản!!!";
		
		public static var NOT_ENOUGH_MONEY_BUY_KEY:String = "Bạn không đủ Xu để mua cái!!!";
		public static var NOT_ENOUGH_MONEY_BUY_KEY_ENG:String = "Bạn không đủ Xu để mua cái!!!";
		
		public static var DISCONNECT_TEXT:String = "Bạn đã bị thoát khỏi game, vui lòng kiểm tra lại mạng!!!";
		public static var DISCONNECT_TEXT_ENG:String = "Bạn đã bị thoát khỏi game, vui lòng kiểm tra lại mạng!!!";
		
		public static var FULLSLOT:String = "Bàn này đã đã đầy người, bạn vui lòng chọn bàn khác !!!";
		public static var FULLSLOT_ENG:String = "Bàn này đã đã đầy người, bạn vui lòng chọn bàn khác !!!";
		
		public static var NOT_ROOM_TEXT:String = "Không có bàn nào phù hợp với bạn !!!";
		public static var NOT_ROOM_TEXT_ENG:String = "Không có bàn nào phù hợp với bạn !!!";
		
		
		
		public static var NOT_LOGIN:String = "Tên đăng nhập không đúng, mời bạn login lại !!!";
		public static var NOT_LOGIN_ENG:String = "Tên đăng nhập không đúng, mời bạn login lại !!!";
		
		public static var NOT_LOGIN_EXIST:String = "Người chơi này đã có trong game, vui long login lại.";
		public static var NOT_LOGIN_EXIST_ENG:String = "Người chơi này đã có trong game, vui long login lại.";
		
		public static var NOT_LOGIN_FULL:String = "Game đã đầy người, xin vui lòng chọn game khác.";
		public static var NOT_LOGIN_FULL_ENG:String = "Game đã đầy người, xin vui lòng chọn game khác.";
		
		public static var NOT_LOGIN_WEB:String = "Bạn chưa đăng nhập, xin vui lòng đăng nhập trước khi chơi game.";
		public static var NOT_LOGIN_WEB_ENG:String = "Bạn chưa đăng nhập, xin vui lòng đăng nhập trước khi chơi game.";
		
		public static var OUT_ROOM_TEXT:String = "Bạn có muốn thoát game không?";
		public static var OUT_ROOM_TEXT_ENG:String = "Bạn có chắc là muốn rời khỏi bàn chơi không?";
		
		public static var NOT_ROOM_ID_TEXT:String = "Không bàn nào có id như bạn nhập hoặc bạn đã nhập sai mật khẩu, bạn vui lòng nhập lại";
		public static var NOT_ROOM_ID_TEXT_ENG:String = "Không bàn nào có id như bạn nhập hoặc bạn đã nhập sai mật khẩu, bạn vui lòng nhập lại";
		
		public static var NOTICE_BETTING_TEXT:String = "Xin mời bạn đặt cược!!!";
		public static var NOTICE_BETTING_TEXT_ENG:String = "Xin mời bạn đặt cược!!!";
		
		public static var NOTICE_BETTING_WAIT_TEXT:String = "Xin chờ người khác đặt cược!!!";
		public static var NOTICE_BETTING_WAIT_TEXT_ENG:String = "Xin chờ người khác đặt cược!!!";
		
		public static var CLOSE_CONNECT_TEXT:String = "Mất kết nối đến máy chủ do đường truyền của bạn có vấn đề, hoặc do tài khoản của bạn đang được sử dụng trên thiết bị khác. Xin vui lòng đăng nhập lại!";
		public static var CLOSE_CONNECT_TEXT_ENG:String = "Mất kết nối đến máy chủ do đường truyền của bạn có vấn đề, hoặc do tài khoản của bạn đang được sử dụng trên thiết bị khác. Xin vui lòng đăng nhập lại!";
		
		public static var GAME_PLAYING_TEXT:String = "Trận đấu đang diễn ra, xin đợi ván mới.";
		public static var GAME_PLAYING_TEXT_ENG:String = "Trận đấu đang diễn ra, xin đợi ván mới.";
		
		public static var SHOWING_RESULT_TEXT:String = "Kết quả.";
		public static var SHOWING_RESULT_TEXT_ENG:String = "Kết quả.";
		
		public static var NOT_HAVE_ROOM_TEXT:String = "Bàn này không còn tồn tại.";
		public static var NOT_HAVE_ROOM_TEXT_ENG:String = "Bàn này không còn tồn tại.";
		
		public static var WRONG_PASS_TEXT:String = "Mật khẩu bạn nhập không đúng, xin nhập lại.";
		public static var WRONG_PASS_TEXT_ENG:String = "Mật khẩu bạn nhập không đúng, xin nhập lại.";
		
		public static var NOT_HAVE_ROOMNAME_TEXT:String = "Bạn chưa đặt tên bàn, xin vui lòng điền tên bàn!!!";
		public static var NOT_HAVE_ROOMNAME_TEXT_ENG:String = "Bạn chưa đặt tên bàn, xin vui lòng điền tên bàn!!!";
		
		public static var KICK:String = "Bạn đã bị sút ra khỏi bàn chơi, vui lòng chọn bàn khác!!!";
		public static var KICK_ENG:String = "kick out!!!";
		
		public static var LINK_WEB:String = "http://gamebai888.no-ip.biz:8080";
		//public static var LINK_WEB:String = "http://gamebai888.com";
		//public static var LINK_WEB:String = "http://115.84.178.135/";
		static public var SHOW_OK:String = "showOk";
		public static var PORT_GAME:int = 9933;
		public static var ZONE_GAME:String = "TLMN";
		public static var IP:String = "115.84.178.135";
		public static var GAMEPATH:String = "games/tlmn";
		//public static var IP:String = "http://gamebai888.no-ip.biz";
		
		
		public static var MUSIC_BG:String = "";
		public static var SOUND_POPUP:String = "popup";
		public static var SOUND_DEAL_DISCARD:String = "DealDisCard";
		public static var SOUND_OVERTIME:String = "OverTime";
		public static var SOUND_SORTCARD:String = "sortCard";
		public static var SOUND_WHITEWIN:String = "whitewin_ready";
		public static var SOUND_OUTROOM:String = "outRoom";
		public static var SOUND_TURN:String = "Turn";
		public static var SOUND_WIN:String = "Win";
		public static var SOUND_LOSE:String = "Lose";
		public static var SOUND_CLICK:String = "Click";
		public static var SOUND_READY:String = "Click";
		public static var SOUND_JOINROOM:String = "JoinRoom";
		
		public static var SOUND_BOY_HELLO_:String = "boy_hello_";
		public static var SOUND_BOY_HELLO_1:String = "boy_hello_1";
		public static var SOUND_BOY_HELLO_2:String = "boy_hello_2";
		public static var SOUND_BOY_BYE_:String = "boy_bye_";
		public static var SOUND_BOY_BYE_1:String = "boy_bye_1";
		public static var SOUND_BOY_BYE_2:String = "boy_bye_2";
		public static var SOUND_BOY_BYE_3:String = "boy_bye_3";
		public static var SOUND_BOY_BYE_4:String = "boy_bye_4";
		public static var SOUND_BOY_BYE_5:String = "boy_bye_5";
		public static var SOUND_BOY_JOINGAME_:String = "boy_joinGame_";
		public static var SOUND_BOY_JOINGAME_1:String = "boy_joinGame_1";
		public static var SOUND_BOY_JOINGAME_2:String = "boy_joinGame_2";
		public static var SOUND_BOY_JOINGAME_3:String = "boy_joinGame_3";
		public static var SOUND_BOY_JOINGAME_4:String = "boy_joinGame_4";
		public static var SOUND_BOY_JOINGAME_5:String = "boy_joinGame_5";
		public static var SOUND_BOY_USER_OUTROOM_:String = "boy_userOutRoom_";
		public static var SOUND_BOY_USER_OUTROOM_1:String = "boy_userOutRoom_1";
		public static var SOUND_BOY_USER_OUTROOM_2:String = "boy_userOutRoom_2";
		public static var SOUND_BOY_USER_OUTROOM_3:String = "boy_userOutRoom_3";
		public static var SOUND_BOY_USER_OUTROOM_4:String = "boy_userOutRoom_4";
		public static var SOUND_BOY_USER_OUTROOM_5:String = "boy_userOutRoom_5";
		public static var SOUND_BOY_STARTGAME_:String = "boy_StartGame_";
		public static var SOUND_BOY_STARTGAME_1:String = "boy_StartGame_1";
		public static var SOUND_BOY_STARTGAME_2:String = "boy_StartGame_2";
		public static var SOUND_BOY_STARTGAME_3:String = "boy_StartGame_3";
		public static var SOUND_BOY_STARTGAME_4:String = "boy_StartGame_4";
		public static var SOUND_BOY_STARTGAME_5:String = "boy_StartGame_5";
		public static var SOUND_BOY_OVERTIME_:String = "boy_overTime_";
		public static var SOUND_BOY_OVERTIME_1:String = "boy_overTime_1";
		public static var SOUND_BOY_OVERTIME_2:String = "boy_overTime_2";
		public static var SOUND_BOY_OVERTIME_3:String = "boy_overTime_3";
		public static var SOUND_BOY_OVERTIME_4:String = "boy_overTime_4";
		public static var SOUND_BOY_OVERTIME_5:String = "boy_overTime_5";
		public static var SOUND_BOY_DISCARD1CARD_:String = "boy_discard1Card_";
		public static var SOUND_BOY_DISCARD1CARD_1:String = "boy_discard1Card_1";
		public static var SOUND_BOY_DISCARD1CARD_2:String = "boy_discard1Card_2";
		public static var SOUND_BOY_DISCARD1CARD_3:String = "boy_discard1Card_3";
		public static var SOUND_BOY_DISCARD1CARD_4:String = "boy_discard1Card_4";
		public static var SOUND_BOY_DISCARD1CARD_5:String = "boy_discard1Card_5";
		public static var SOUND_BOY_CHATDE1CARD_:String = "boy_chatde1card_";
		public static var SOUND_BOY_CHATDE1CARD_1:String = "boy_chatde1card_1";
		public static var SOUND_BOY_CHATDE1CARD_2:String = "boy_chatde1card_2";
		public static var SOUND_BOY_CHATDE1CARD_3:String = "boy_chatde1card_3";
		public static var SOUND_BOY_CHATDE1CARD_4:String = "boy_chatde1card_4";
		public static var SOUND_BOY_CHATDE1CARD_5:String = "boy_chatde1card_5";
		public static var SOUND_BOY_CHATDE1CARD_6:String = "boy_chatde1card_6";
		public static var SOUND_BOY_CHATDE1CARD_7:String = "boy_chatde1card_7";
		public static var SOUND_BOY_CHATDE1CARD_8:String = "boy_chatde1card_8";
		public static var SOUND_BOY_CHATDE1CARD_9:String = "boy_chatde1card_9";
		public static var SOUND_BOY_CHATDE1CARD_10:String = "boy_chatde1card_10";
		public static var SOUND_BOY_DANH2_:String = "boy_danh2_";
		public static var SOUND_BOY_DANH2_1:String = "boy_danh2_1";
		public static var SOUND_BOY_DANH2_2:String = "boy_danh2_2";
		public static var SOUND_BOY_DANH2_3:String = "boy_danh2_3";
		public static var SOUND_BOY_DANH2_4:String = "boy_danh2_4";
		public static var SOUND_BOY_DANH2_5:String = "boy_danh2_5";
		public static var SOUND_BOY_DISCARD2CARD_:String = "boy_discard2Card_";
		public static var SOUND_BOY_DISCARD2CARD_1:String = "boy_discard2Card_1";
		public static var SOUND_BOY_DISCARD2CARD_2:String = "boy_discard2Card_2";
		public static var SOUND_BOY_DISCARD2CARD_3:String = "boy_discard2Card_3";
		public static var SOUND_BOY_DISCARD2CARD_4:String = "boy_discard2Card_4";
		public static var SOUND_BOY_DISCARD2CARD_5:String = "boy_discard2Card_5";
		public static var SOUND_BOY_CHATDE2CARD_:String = "boy_chatde2card_";
		public static var SOUND_BOY_CHATDE2CARD_1:String = "boy_chatde2card_1";
		public static var SOUND_BOY_CHATDE2CARD_2:String = "boy_chatde2card_2";
		public static var SOUND_BOY_CHATDE2CARD_3:String = "boy_chatde2card_3";
		public static var SOUND_BOY_CHATDE2CARD_4:String = "boy_chatde2card_4";
		public static var SOUND_BOY_CHATDE2CARD_5:String = "boy_chatde2card_5";
		public static var SOUND_BOY_DISCARD3CARD_:String = "boy_discard3Card_";
		public static var SOUND_BOY_DISCARD3CARD_1:String = "boy_discard3Card_1";
		public static var SOUND_BOY_DISCARD3CARD_2:String = "boy_discard3Card_2";
		public static var SOUND_BOY_DISCARD3CARD_3:String = "boy_discard3Card_3";
		public static var SOUND_BOY_DISCARD3CARD_4:String = "boy_discard3Card_4";
		public static var SOUND_BOY_DISCARD3CARD_5:String = "boy_discard3Card_5";
		public static var SOUND_BOY_CHATDE3CARD_:String = "boy_chatde3card_";
		public static var SOUND_BOY_CHATDE3CARD_1:String = "boy_chatde3card_1";
		public static var SOUND_BOY_CHATDE3CARD_2:String = "boy_chatde3card_2";
		public static var SOUND_BOY_CHATDE3CARD_3:String = "boy_chatde3card_3";
		public static var SOUND_BOY_CHATDE3CARD_4:String = "boy_chatde3card_4";
		public static var SOUND_BOY_CHATDE3CARD_5:String = "boy_chatde3card_5";
		public static var SOUND_BOY_CHATDESPECIALCARD_:String = "boy_chatdespecialcard_";
		public static var SOUND_BOY_CHATDESPECIALCARD_1:String = "boy_chatdespecialcard_1";
		public static var SOUND_BOY_CHATDESPECIALCARD_2:String = "boy_chatdespecialcard_2";
		public static var SOUND_BOY_CHATDESPECIALCARD_3:String = "boy_chatdespecialcard_3";
		public static var SOUND_BOY_CHATDESPECIALCARD_4:String = "boy_chatdespecialcard_4";
		public static var SOUND_BOY_CHATDESPECIALCARD_5:String = "boy_chatdespecialcard_5";
		public static var SOUND_BOY_PASSTURN_:String = "boy_PASSTURN_";
		public static var SOUND_BOY_PASSTURN_1:String = "boy_PASSTURN_1";
		public static var SOUND_BOY_PASSTURN_2:String = "boy_PASSTURN_2";
		public static var SOUND_BOY_PASSTURN_3:String = "boy_PASSTURN_3";
		public static var SOUND_BOY_PASSTURN_4:String = "boy_PASSTURN_4";
		public static var SOUND_BOY_PASSTURN_5:String = "boy_PASSTURN_5";
		public static var SOUND_BOY_WIN_:String = "boy_WIN_";
		public static var SOUND_BOY_WIN_1:String = "boy_WIN_1";
		public static var SOUND_BOY_WIN_2:String = "boy_WIN_2";
		public static var SOUND_BOY_WIN_3:String = "boy_WIN_3";
		public static var SOUND_BOY_WIN_4:String = "boy_WIN_4";
		public static var SOUND_BOY_WIN_5:String = "boy_WIN_5";
		public static var SOUND_BOY_LOSE_:String = "boy_LOSE_";
		public static var SOUND_BOY_LOSE_1:String = "boy_LOSE_1";
		public static var SOUND_BOY_LOSE_2:String = "boy_LOSE_2";
		public static var SOUND_BOY_LOSE_3:String = "boy_LOSE_3";
		public static var SOUND_BOY_LOSE_4:String = "boy_LOSE_4";
		public static var SOUND_BOY_LOSE_5:String = "boy_LOSE_5";
		public static var SOUND_BOY_OVERMONEY_:String = "boy_OVERMONEY_";
		public static var SOUND_BOY_OVERMONEY_1:String = "boy_OVERMONEY_1";
		public static var SOUND_BOY_OVERMONEY_2:String = "boy_OVERMONEY_2";
		public static var SOUND_BOY_OVERMONEY_3:String = "boy_OVERMONEY_3";
		public static var SOUND_BOY_OVERMONEY_4:String = "boy_OVERMONEY_4";
		public static var SOUND_BOY_OVERMONEY_5:String = "boy_OVERMONEY_5";
		
		public static var SOUND_GIRL_HELLO_:String = "GIRL_hello_";
		public static var SOUND_GIRL_HELLO_1:String = "GIRL_hello_1";
		public static var SOUND_GIRL_HELLO_2:String = "GIRL_hello_2";
		public static var SOUND_GIRL_BYE_:String = "GIRL_bye_";
		public static var SOUND_GIRL_BYE_1:String = "GIRL_bye_1";
		public static var SOUND_GIRL_BYE_2:String = "GIRL_bye_2";
		public static var SOUND_GIRL_BYE_3:String = "GIRL_bye_3";
		public static var SOUND_GIRL_BYE_4:String = "GIRL_bye_4";
		public static var SOUND_GIRL_BYE_5:String = "GIRL_bye_5";
		public static var SOUND_GIRL_JOINGAME_:String = "GIRL_joinGame_";
		public static var SOUND_GIRL_JOINGAME_1:String = "GIRL_joinGame_1";
		public static var SOUND_GIRL_JOINGAME_2:String = "GIRL_joinGame_2";
		public static var SOUND_GIRL_JOINGAME_3:String = "GIRL_joinGame_3";
		public static var SOUND_GIRL_JOINGAME_4:String = "GIRL_joinGame_4";
		public static var SOUND_GIRL_JOINGAME_5:String = "GIRL_joinGame_5";
		public static var SOUND_GIRL_USER_OUTROOM_:String = "GIRL_userOutRoom_";
		public static var SOUND_GIRL_USER_OUTROOM_1:String = "GIRL_userOutRoom_1";
		public static var SOUND_GIRL_USER_OUTROOM_2:String = "GIRL_userOutRoom_2";
		public static var SOUND_GIRL_USER_OUTROOM_3:String = "GIRL_userOutRoom_3";
		public static var SOUND_GIRL_USER_OUTROOM_4:String = "GIRL_userOutRoom_4";
		public static var SOUND_GIRL_USER_OUTROOM_5:String = "GIRL_userOutRoom_5";
		public static var SOUND_GIRL_STARTGAME_:String = "GIRL_StartGame_";
		public static var SOUND_GIRL_STARTGAME_1:String = "GIRL_StartGame_1";
		public static var SOUND_GIRL_STARTGAME_2:String = "GIRL_StartGame_2";
		public static var SOUND_GIRL_STARTGAME_3:String = "GIRL_StartGame_3";
		public static var SOUND_GIRL_STARTGAME_4:String = "GIRL_StartGame_4";
		public static var SOUND_GIRL_STARTGAME_5:String = "GIRL_StartGame_5";
		public static var SOUND_GIRL_OVERTIME_:String = "GIRL_overTime_";
		public static var SOUND_GIRL_OVERTIME_1:String = "GIRL_overTime_1";
		public static var SOUND_GIRL_OVERTIME_2:String = "GIRL_overTime_2";
		public static var SOUND_GIRL_OVERTIME_3:String = "GIRL_overTime_3";
		public static var SOUND_GIRL_OVERTIME_4:String = "GIRL_overTime_4";
		public static var SOUND_GIRL_OVERTIME_5:String = "GIRL_overTime_5";
		public static var SOUND_GIRL_DISCARD1CARD_:String = "GIRL_discard1Card_";
		public static var SOUND_GIRL_DISCARD1CARD_1:String = "GIRL_discard1Card_1";
		public static var SOUND_GIRL_DISCARD1CARD_2:String = "GIRL_discard1Card_2";
		public static var SOUND_GIRL_DISCARD1CARD_3:String = "GIRL_discard1Card_3";
		public static var SOUND_GIRL_DISCARD1CARD_4:String = "GIRL_discard1Card_4";
		public static var SOUND_GIRL_DISCARD1CARD_5:String = "GIRL_discard1Card_5";
		public static var SOUND_GIRL_CHATDE1CARD_:String = "GIRL_chatde1card_";
		public static var SOUND_GIRL_CHATDE1CARD_1:String = "GIRL_chatde1card_1";
		public static var SOUND_GIRL_CHATDE1CARD_2:String = "GIRL_chatde1card_2";
		public static var SOUND_GIRL_CHATDE1CARD_3:String = "GIRL_chatde1card_3";
		public static var SOUND_GIRL_CHATDE1CARD_4:String = "GIRL_chatde1card_4";
		public static var SOUND_GIRL_CHATDE1CARD_5:String = "GIRL_chatde1card_5";
		public static var SOUND_GIRL_CHATDE1CARD_6:String = "GIRL_chatde1card_6";
		public static var SOUND_GIRL_CHATDE1CARD_7:String = "GIRL_chatde1card_7";
		public static var SOUND_GIRL_CHATDE1CARD_8:String = "GIRL_chatde1card_8";
		public static var SOUND_GIRL_CHATDE1CARD_9:String = "GIRL_chatde1card_9";
		public static var SOUND_GIRL_CHATDE1CARD_10:String = "GIRL_chatde1card_10";
		public static var SOUND_GIRL_DANH2_:String = "GIRL_danh2_";
		public static var SOUND_GIRL_DANH2_1:String = "GIRL_danh2_1";
		public static var SOUND_GIRL_DANH2_2:String = "GIRL_danh2_2";
		public static var SOUND_GIRL_DANH2_3:String = "GIRL_danh2_3";
		public static var SOUND_GIRL_DANH2_4:String = "GIRL_danh2_4";
		public static var SOUND_GIRL_DANH2_5:String = "GIRL_danh2_5";
		public static var SOUND_GIRL_DISCARD2CARD_:String = "GIRL_discard2Card_";
		public static var SOUND_GIRL_DISCARD2CARD_1:String = "GIRL_discard2Card_1";
		public static var SOUND_GIRL_DISCARD2CARD_2:String = "GIRL_discard2Card_2";
		public static var SOUND_GIRL_DISCARD2CARD_3:String = "GIRL_discard2Card_3";
		public static var SOUND_GIRL_DISCARD2CARD_4:String = "GIRL_discard2Card_4";
		public static var SOUND_GIRL_DISCARD2CARD_5:String = "GIRL_discard2Card_5";
		public static var SOUND_GIRL_CHATDE2CARD_:String = "GIRL_chatde2card_";
		public static var SOUND_GIRL_CHATDE2CARD_1:String = "GIRL_chatde2card_1";
		public static var SOUND_GIRL_CHATDE2CARD_2:String = "GIRL_chatde2card_2";
		public static var SOUND_GIRL_CHATDE2CARD_3:String = "GIRL_chatde2card_3";
		public static var SOUND_GIRL_CHATDE2CARD_4:String = "GIRL_chatde2card_4";
		public static var SOUND_GIRL_CHATDE2CARD_5:String = "GIRL_chatde2card_5";
		public static var SOUND_GIRL_DISCARD3CARD_:String = "GIRL_discard3Card_";
		public static var SOUND_GIRL_DISCARD3CARD_1:String = "GIRL_discard3Card_1";
		public static var SOUND_GIRL_DISCARD3CARD_2:String = "GIRL_discard3Card_2";
		public static var SOUND_GIRL_DISCARD3CARD_3:String = "GIRL_discard3Card_3";
		public static var SOUND_GIRL_DISCARD3CARD_4:String = "GIRL_discard3Card_4";
		public static var SOUND_GIRL_DISCARD3CARD_5:String = "GIRL_discard3Card_5";
		public static var SOUND_GIRL_CHATDE3CARD_:String = "GIRL_chatde3card_";
		public static var SOUND_GIRL_CHATDE3CARD_1:String = "GIRL_chatde3card_1";
		public static var SOUND_GIRL_CHATDE3CARD_2:String = "GIRL_chatde3card_2";
		public static var SOUND_GIRL_CHATDE3CARD_3:String = "GIRL_chatde3card_3";
		public static var SOUND_GIRL_CHATDE3CARD_4:String = "GIRL_chatde3card_4";
		public static var SOUND_GIRL_CHATDE3CARD_5:String = "GIRL_chatde3card_5";
		public static var SOUND_GIRL_CHATDESPECIALCARD_:String = "GIRL_chatdespecialcard_";
		public static var SOUND_GIRL_CHATDESPECIALCARD_1:String = "GIRL_chatdespecialcard_1";
		public static var SOUND_GIRL_CHATDESPECIALCARD_2:String = "GIRL_chatdespecialcard_2";
		public static var SOUND_GIRL_CHATDESPECIALCARD_3:String = "GIRL_chatdespecialcard_3";
		public static var SOUND_GIRL_CHATDESPECIALCARD_4:String = "GIRL_chatdespecialcard_4";
		public static var SOUND_GIRL_CHATDESPECIALCARD_5:String = "GIRL_chatdespecialcard_5";
		public static var SOUND_GIRL_PASSTURN_:String = "GIRL_PASSTURN_";
		public static var SOUND_GIRL_PASSTURN_1:String = "GIRL_PASSTURN_1";
		public static var SOUND_GIRL_PASSTURN_2:String = "GIRL_PASSTURN_2";
		public static var SOUND_GIRL_PASSTURN_3:String = "GIRL_PASSTURN_3";
		public static var SOUND_GIRL_PASSTURN_4:String = "GIRL_PASSTURN_4";
		public static var SOUND_GIRL_PASSTURN_5:String = "GIRL_PASSTURN_5";
		public static var SOUND_GIRL_WIN_:String = "GIRL_WIN_";
		public static var SOUND_GIRL_WIN_1:String = "GIRL_WIN_1";
		public static var SOUND_GIRL_WIN_2:String = "GIRL_WIN_2";
		public static var SOUND_GIRL_WIN_3:String = "GIRL_WIN_3";
		public static var SOUND_GIRL_WIN_4:String = "GIRL_WIN_4";
		public static var SOUND_GIRL_WIN_5:String = "GIRL_WIN_5";
		public static var SOUND_GIRL_LOSE_:String = "GIRL_LOSE_";
		public static var SOUND_GIRL_LOSE_1:String = "GIRL_LOSE_1";
		public static var SOUND_GIRL_LOSE_2:String = "GIRL_LOSE_2";
		public static var SOUND_GIRL_LOSE_3:String = "GIRL_LOSE_3";
		public static var SOUND_GIRL_LOSE_4:String = "GIRL_LOSE_4";
		public static var SOUND_GIRL_LOSE_5:String = "GIRL_LOSE_5";
		public static var SOUND_GIRL_OVERMONEY_:String = "GIRL_OVERMONEY_";
		public static var SOUND_GIRL_OVERMONEY_1:String = "GIRL_OVERMONEY_1";
		public static var SOUND_GIRL_OVERMONEY_2:String = "GIRL_OVERMONEY_2";
		public static var SOUND_GIRL_OVERMONEY_3:String = "GIRL_OVERMONEY_3";
		public static var SOUND_GIRL_OVERMONEY_4:String = "GIRL_OVERMONEY_4";
		public static var SOUND_GIRL_OVERMONEY_5:String = "GIRL_OVERMONEY_5";
		
		public function ConstTlmn() 
		{
			
		}
		
	}

}