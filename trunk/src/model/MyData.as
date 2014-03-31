package model 
{
	/**
	 * ...
	 * @author ...
	 */
	public class MyData 
	{
		public var zoneId:int;
		public var roomId:int = -1;
		public var lobbyRoomId:int;
		
		public var userList:Object;
		public var saveUserList:Object;
		public var friendList:Object;
		public var userListOfLobby:Object;
		public var roomList:Object;
		public var roomListUpdate:Object; // dùng để lưu lại những room vừa có update
		
		public var channelId:int = -1;
		public var gameName:String;
		public var gameRoomInfo:Object;
		public var gameType:String = "TienLenMNPlugin";
		public var lobbyName:String = "LobbyTLMN";
		public var lobbyRoomName:String = "LobbyTLMN";
		public var lobbyPluginName:String = "LobbyTLMNPlugin";
		public var isFirstLoad:Boolean;
		public var isFirstLoadGame:Boolean;
		public var countRoom:int;
		public var totalRoom:int;
		public var countGame:int;
		
		public function MyData() 
		{
			userList = new Object();
			roomList = new Object();
			roomListUpdate = new Object();
		}
		
	}

}