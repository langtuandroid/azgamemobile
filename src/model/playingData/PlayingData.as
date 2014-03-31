package model.playingData 
{
	import event.PlayingScreenEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayingData extends EventDispatcher
	{
		
		public function PlayingData() 
		{
			
		}
		
		// xác định xem đã join game room success hay chưa
		public static const JOIN_GAME_ROOM_SUCCESS:String = "joinGameRoomSuccess";
		private var _isJoinGameRoomSuccess:Boolean;
		
		public function get isJoinRoomGameSuccess():Boolean 
		{
			return _isJoinGameRoomSuccess;
		}
		
		public function set isJoinRoomGameSuccess(value:Boolean):void 
		{
			_isJoinGameRoomSuccess = value;
			if(value)
				dispatchEvent(new Event(JOIN_GAME_ROOM_SUCCESS));
		}
		
		// Thông tin của phòng
		private var _gameRoomData:GameRoomData;
		
		public function get gameRoomData():GameRoomData 
		{
			if (!_gameRoomData)
				_gameRoomData = new GameRoomData();
			return _gameRoomData;
		}
		
		public function set gameRoomData(value:GameRoomData):void 
		{
			_gameRoomData = value;
		}
		
		// Hành động cập nhật phòng chơi
		public static const UPDATE_PLAYING_SCREEN:String = "updatePlayingScreen";
		private var _playingScreenAction:Object;
		
		public function get playingScreenAction():Object 
		{
			if (!_playingScreenAction)
				_playingScreenAction = new Object();
			return _playingScreenAction;
		}
		
		public function set playingScreenAction(value:Object):void 
		{
			_playingScreenAction = value;
			dispatchEvent(new PlayingScreenEvent(UPDATE_PLAYING_SCREEN, value));
		}
		
		// Danh sách user trong phòng chờ
		public static const UPDATE_USER_LIST_OF_LOBBY:String = "updateUserlistOfLobby";
		private var _userListOfLobby:Object;
		
		public function get userListOfLobby():Object 
		{
			return _userListOfLobby;
		}
		
		public function set userListOfLobby(value:Object):void 
		{
			_userListOfLobby = value;
			dispatchEvent(new PlayingScreenEvent(UPDATE_USER_LIST_OF_LOBBY, value));
		}
	}

}