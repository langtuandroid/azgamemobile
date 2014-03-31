package model.lobbyRoomData 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Yun
	 */
	public class LobbyRoomData extends EventDispatcher
	{
		
		public function LobbyRoomData() 
		{
			
		}
		
		// xác định xem đã join lobby room success hay chưa
		public static const JOIN_LOBBY_ROOM_SUCCESS:String = "joinLobbyRoomSuccess";
		private var _isJoinLobbyRoomSuccess:Boolean;
		
		public function get isJoinLobbyRoomSuccess():Boolean 
		{
			return _isJoinLobbyRoomSuccess;
		}
		
		public function set isJoinLobbyRoomSuccess(value:Boolean):void 
		{
			_isJoinLobbyRoomSuccess = value;
			if(value)
				dispatchEvent(new Event(JOIN_LOBBY_ROOM_SUCCESS));
		}
		
		// Cập nhật dữ liệu các user đang có trong phòng chờ
		public static const UPDATE_USER_LIST:String = "updateUserList";
		private var _userList:Array;
		
		public function get userList():Array 
		{
			if (!_userList)
				_userList = new Array();
			return _userList;
		}
		
		public function set userList(value:Array):void 
		{
			_userList = value;
			if(value)
				dispatchEvent(new Event(UPDATE_USER_LIST));
		}
		
		// Cập nhật dữ liệu các phòng chơi hiển thị trong phòng chờ
		public static const UPDATE_ROOM_LIST:String = "updateRoomList";
		private var _roomList:Array;
		
		public function get roomList():Array 
		{
			if (!_roomList)
				_roomList = new Array();
			return _roomList;
		}
		
		public function set roomList(value:Array):void 
		{
			_roomList = value;
			if(value)
				dispatchEvent(new Event(UPDATE_ROOM_LIST));
		}
		
		// Cập nhật dữ liệu friendList
		public static const UPDATE_FRIEND_LIST:String = "updateFriendList";
		private var _friendList:Array;
		
		public function get friendList():Array 
		{
			if (!_friendList)
				_friendList = new Array();
			return _friendList;
		}
		
		public function set friendList(value:Array):void 
		{
			_friendList = value;
			if(value)
				dispatchEvent(new Event(UPDATE_FRIEND_LIST));
		}
		
		// Dữ liệu lời mời chơi
		public static const HAVE_INVITE_PLAY:String = "haveInvitePlay";
		private var _invitePlayData:Object;
		
		public function get invitePlayData():Object 
		{
			return _invitePlayData;
		}
		
		public function set invitePlayData(value:Object):void 
		{
			_invitePlayData = value;
			if(value)
				dispatchEvent(new Event(HAVE_INVITE_PLAY));
		}
		
		// Dữ liệu add money
		public static const ADD_MONEY:String = "addMoney";
		private var _addMoneyData:Object;
		
		public function get addMoneyData():Object 
		{
			return _addMoneyData;
		}
		
		public function set addMoneyData(value:Object):void 
		{
			_addMoneyData = value;
			if(value)
				dispatchEvent(new Event(ADD_MONEY));
		}
		
		// Dữ liệu khi có update tiền
		public static const UPDATE_MONEY:String = "updateMoney";
		private var _updateMoneyData:Object;
		
		public function get updateMoneyData():Object 
		{
			return _updateMoneyData;
		}
		
		public function set updateMoneyData(value:Object):void 
		{
			_updateMoneyData = value;
			if(value)
				dispatchEvent(new Event(UPDATE_MONEY));
		}
		
	}

}