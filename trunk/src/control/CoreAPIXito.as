package control 
{
	import com.adobe.serialization.json.JSON;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.DataType;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.EsObjectDataHolder;
	import com.electrotank.electroserver5.api.FindGamesRequest;
	import com.electrotank.electroserver5.api.GetUserCountRequest;
	import com.electrotank.electroserver5.api.GetUsersInRoomRequest;
	import com.electrotank.electroserver5.api.GetUserVariablesRequest;
	import com.electrotank.electroserver5.api.JoinGameRequest;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.PluginListEntry;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.api.PrivateMessageRequest;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.api.QuickJoinGameRequest;
	import com.electrotank.electroserver5.api.RoomVariableUpdateEvent;
	import com.electrotank.electroserver5.api.SearchCriteria;
	import com.electrotank.electroserver5.api.ServerGame;
	import com.electrotank.electroserver5.api.UpdateUserVariableRequest;
	import com.electrotank.electroserver5.api.UserListEntry;
	import com.electrotank.electroserver5.api.UserUpdateAction;
	import com.electrotank.electroserver5.api.UserVariable;
	import com.electrotank.electroserver5.api.UserVariableUpdateAction;
	import com.electrotank.electroserver5.api.ZoneUpdateAction;
	import com.electrotank.electroserver5.connection.AvailableConnection;
	import com.electrotank.electroserver5.ElectroServer
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.CreateOrJoinGameResponse;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.FindGamesResponse;
	import com.electrotank.electroserver5.api.GenericErrorResponse;
	import com.electrotank.electroserver5.api.GetUsersInRoomResponse;
	import com.electrotank.electroserver5.api.GetUserVariablesResponse;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomEvent;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PrivateMessageEvent;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.UserEvictedFromRoomEvent;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.UserVariableUpdateEvent;
	import com.electrotank.electroserver5.api.ZoneUpdateEvent;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.events.ConnectionEvent;
	import com.electrotank.electroserver5.server.Server;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Room;
	import com.electrotank.electroserver5.zone.Zone;
	import event.Command;
	import event.DataFieldMauBinh;
	import event.DataFieldXito;
	import event.ElectroServerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.EsConfiguration;
	import model.MainData;
	import model.MyData;
	import model.playingData.PlayingScreenAction;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CoreAPIXito extends EventDispatcher 
	{	
		private var electroServer:ElectroServer;
		private var userRecentlyJoinRoom:String;
		
		private var currentUserNumber:int = 0;
		private var timerToGetRoomList:Timer;
		
		public var mainData:MainData = MainData.getInstance();
		public  var myData:MyData;
		
		public function CoreAPIXito(config:EsConfiguration) 
		{
			_configuration = config;
		}
		
		// Bước 1 - kết nối với server electro
		public function createConnection():void
		{
			myData = new MyData();
			
			myData.gameType = "XiToPlugin";
			myData.lobbyName = "Lobby";
			myData.lobbyPluginName = "LobbyPlugin";
		
			if (!electroServer)
				electroServer = new ElectroServer();
			
			electroServer.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserListUpdateEvent);
			electroServer.engine.addEventListener(MessageType.LeaveRoomEvent.name, onLeaveRoomEvent);
			electroServer.engine.addEventListener(MessageType.UserEvictedFromRoomEvent.name, onUserEvictedFromRoomEvent);
			electroServer.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onCloseConnection);
			electroServer.engine.addEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			electroServer.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			electroServer.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			electroServer.engine.addEventListener(MessageType.GetUsersInRoomResponse.name, onGetUsersInRoomResponse);
			electroServer.engine.addEventListener(MessageType.GetUserVariablesResponse.name, onGetUserInfoResponse);
			electroServer.engine.addEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			electroServer.engine.addEventListener(MessageType.ZoneUpdateEvent.name, onZoneUpdateEvent);
			electroServer.engine.addEventListener(MessageType.FindGamesResponse.name, onFindGameRespond);
			
			var server:Server = new Server("server1");
			var availConn:AvailableConnection = new AvailableConnection(configuration.ip, configuration.port, configuration.protocol.name);
			server.addAvailableConnection(availConn);
			
			electroServer.engine.addServer(server);
			electroServer.engine.connect();
			
			electroServer.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionEvent);
			//electroServer.engine.createConnection(configuration.ip, configuration.port);
		}
		
		public function onConnectionEvent(e:ConnectionResponse):void
		{
			electroServer.engine.removeEventListener(MessageType.ConnectionResponse.name, onConnectionEvent);
			if (e.successful)
				this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.CONNECT_SUCCESS));
			else
				this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.CONNECT_FAIL));
		}
		
		public function onCloseConnection(e:ConnectionClosedEvent):void
		{
			if (timerToGetRoomList)
			{
				timerToGetRoomList.removeEventListener(TimerEvent.TIMER, onGetRoomList)
				timerToGetRoomList.stop();
			}
			
			myData.roomId = -1;
			
			electroServer.engine.removeEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdateEvent);
			electroServer.engine.removeEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdateEvent);
			electroServer.engine.removeEventListener(MessageType.UserUpdateEvent.name, onUserListUpdateEvent);
			electroServer.engine.removeEventListener(MessageType.ConnectionClosedEvent.name, onCloseConnection);
			electroServer.engine.removeEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			electroServer.engine.removeEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			electroServer.engine.removeEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			electroServer.engine.removeEventListener(MessageType.GetUsersInRoomResponse.name, onGetUsersInRoomResponse);
			electroServer.engine.removeEventListener(MessageType.GetUserVariablesResponse.name, onGetUserInfoResponse);
			electroServer.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			electroServer.engine.removeEventListener(MessageType.ZoneUpdateEvent.name, onZoneUpdateEvent);
			
			this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.CLOSE_CONNECTION));
		}
		
		public function onPrivateMessageEvent(e:PrivateMessageEvent):void
		{
			switch(e.message)
			{
				case Command.PRIVATE_CHAT:
					//trace("private chat");
				break;
				case DataFieldMauBinh.SEND_MESSAGE: // có user gửi message bằng web service cho mình
					MainCommand.getInstance().getInfoCommand.getMessageInfo();
				break;
				case Command.INVITE_PLAY:
					var invitePlayObject:Object = new Object();
					invitePlayObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					invitePlayObject[DataFieldMauBinh.USER_NAME] = e.userName;
					invitePlayObject[DataFieldMauBinh.ROOM_ID] = e.esObject.getInteger(DataFieldMauBinh.ROOM_ID);
					invitePlayObject[DataFieldMauBinh.GAME_ID] = e.esObject.getInteger(DataFieldMauBinh.GAME_ID);
					invitePlayObject[DataFieldMauBinh.ROOM_PASSWORD] = e.esObject.getString(DataFieldMauBinh.ROOM_PASSWORD);
					invitePlayObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					invitePlayObject[DataFieldMauBinh.ROOM_BET] = e.esObject.getString(DataFieldMauBinh.ROOM_BET);
					invitePlayObject[DataFieldMauBinh.AVATAR] = e.esObject.getString(DataFieldMauBinh.AVATAR);
					invitePlayObject[DataFieldMauBinh.MONEY] = e.esObject.getString(DataFieldMauBinh.MONEY);
					invitePlayObject[DataFieldMauBinh.SEX] = e.esObject.getString(DataFieldMauBinh.SEX);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_INVITE_PLAY,invitePlayObject));
				break;
				case Command.INVITE_ADD_FRIEND: // Lời mời kết bạn
					var inviteAddFriendObject:Object = new Object();
					inviteAddFriendObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					inviteAddFriendObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					inviteAddFriendObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.INVITE_ADD_FRIEND, inviteAddFriendObject));
				break;
				case Command.CONFIRM_ADD_FRIEND_INVITE: // Người khác trả lời yêu cầu kết bạn của mình
					var confirmAddFriendInviteObject:Object = new Object();
					confirmAddFriendInviteObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					confirmAddFriendInviteObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					confirmAddFriendInviteObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					confirmAddFriendInviteObject[DataFieldMauBinh.CONFIRM] = e.esObject.getBoolean(DataFieldMauBinh.CONFIRM);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.FRIEND_CONFIRM_ADD_FRIEND_INVITE, confirmAddFriendInviteObject));
				break;
				case Command.REMOVE_FRIEND: // Người khác xóa mình khỏi danh sách friend
					var removeFriendObject:Object = new Object();
					removeFriendObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					removeFriendObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					removeFriendObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.REMOVE_FRIEND, removeFriendObject));
				break;
				case Command.REQUEST_TIME_CLOCK: // Người khác request time clock
					var requestTimeClockObject:Object = new Object();
					requestTimeClockObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					dispatchEvent(new ElectroServerEvent(Command.REQUEST_TIME_CLOCK, requestTimeClockObject));
				break;
				case Command.RESPOND_TIME_CLOCK: // Người khác respond time clock
					var respondTimeClockObject:Object = new Object();
					respondTimeClockObject[DataFieldMauBinh.TIME_CLOCK] = e.esObject.getString(DataFieldMauBinh.TIME_CLOCK);
					dispatchEvent(new ElectroServerEvent(Command.RESPOND_TIME_CLOCK, respondTimeClockObject));
				break;
				case Command.REQUEST_IS_COMPARE_GROUP: // Người khác hỏi xem có phải đang đọ chi không
					var requestIsCompareGroupObject:Object = new Object();
					requestIsCompareGroupObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					dispatchEvent(new ElectroServerEvent(Command.REQUEST_IS_COMPARE_GROUP, requestIsCompareGroupObject));
				break;
				case Command.RESPOND_IS_COMPARE_GROUP: // Người khác trả lời có phải đang đọ chi không
					var respondIsCompareGroupObject:Object = new Object();
					respondIsCompareGroupObject[DataFieldMauBinh.IS_COMPARE_GROUP] = e.esObject.getBoolean(DataFieldMauBinh.IS_COMPARE_GROUP);
					dispatchEvent(new ElectroServerEvent(Command.RESPOND_IS_COMPARE_GROUP, respondIsCompareGroupObject));
				break;
				case Command.COMPARE_GROUP_COMPLETE: // Người khác thông báo là đã đọ chi xong
					var compateGroupCompalteObject:Object = new Object();
					dispatchEvent(new ElectroServerEvent(Command.COMPARE_GROUP_COMPLETE, compateGroupCompalteObject));
				break;
			}
		}
		
		public function onPublicMessageEvent(e:PublicMessageEvent):void
		{
			//trace("onPublicMessageEvent");
			var i:int;
			switch(e.esObject.getString(DataFieldMauBinh.COMMAND))
			{
				case Command.PUBLIC_CHAT:
					var publicChatObject:Object = new Object();
					publicChatObject[DataFieldMauBinh.USER_NAME] = e.userName;
					publicChatObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					publicChatObject[DataFieldMauBinh.CHAT_CONTENT] = e.esObject.getString(DataFieldMauBinh.CHAT_CONTENT);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.PUBLIC_CHAT,publicChatObject));
				break;
				case Command.SEND_EMO:
					var sendEmoObject:Object = new Object();
					sendEmoObject[DataFieldMauBinh.USER_NAME] = e.userName;
					sendEmoObject[DataFieldMauBinh.EMO_TYPE] = e.esObject.getInteger(DataFieldMauBinh.EMO_TYPE);
					mainData.emoChatData = sendEmoObject;
				break;
				case Command.READY:
					var readyObject:Object = new Object();
					readyObject[DataFieldMauBinh.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.READY_SUCCESS,readyObject));
				break;
				case Command.START_GAME:
					var startGameObject:Object = new Object();
					startGameObject[DataFieldXito.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.START_GAME_SUCCESS,startGameObject));
				break;
				case Command.SELECT_OPEN_CARD: // Người chơi khác chọn lá bài lật
					var openCardsObject:Object = new Object();
					openCardsObject[DataFieldXito.OPEN_CARDS] = e.esObject.getIntegerArray(DataFieldXito.OPEN_CARDS);
					for (var j:int = 0; j < openCardsObject[DataFieldXito.OPEN_CARDS].length; j++)
					{
						openCardsObject[DataFieldXito.OPEN_CARDS][j]++;
					}
					openCardsObject[DataFieldXito.USER_NAME] = e.esObject.getString(DataFieldXito.USER_NAME);
					callPlayingScreenAction(PlayingScreenAction.HAVE_USER_OPEN_CARD, openCardsObject);
				break;
				case PlayingScreenAction.CHECK: // Người chơi khác nhường tố
					var object:Object = new Object();
					object[DataFieldXito.USER_NAME] = e.esObject.getString(DataFieldXito.USER_NAME);
					callPlayingScreenAction(PlayingScreenAction.CHECK, object);
				break;
				case PlayingScreenAction.RAISE: // Người chơi khác tố
					object = new Object();
					object[DataFieldXito.USER_NAME] = e.esObject.getString(DataFieldXito.USER_NAME);
					object[DataFieldXito.MONEY] = e.esObject.getString(DataFieldXito.MONEY);
					object[DataFieldXito.RAISE_TYPE] = e.esObject.getInteger(DataFieldXito.RAISE_TYPE);
					callPlayingScreenAction(PlayingScreenAction.RAISE, object);
				break; 
				case PlayingScreenAction.CALL: // Người chơi khác theo
					object = new Object();
					object[DataFieldXito.USER_NAME] = e.esObject.getString(DataFieldXito.USER_NAME);
					callPlayingScreenAction(PlayingScreenAction.CALL, object);
				break;
				case PlayingScreenAction.FOLD: // Người chơi khác ụp bài
					object = new Object();
					object[DataFieldXito.USER_NAME] = e.esObject.getString(DataFieldXito.USER_NAME);
					callPlayingScreenAction(PlayingScreenAction.FOLD, object);
				break;
			}
		}
		
		// Hàm để gọi một hành động xẩy ra trong playingScreen
		private function callPlayingScreenAction(actionName:String, data:Object):void
		{
			var playingScreenAction:PlayingScreenAction = new PlayingScreenAction();
			playingScreenAction.actionName = actionName;
			playingScreenAction.data = data;
			mainData.playingData.playingScreenAction = playingScreenAction;
		}
		
		// sau khi kết nối thành công với server thì login
		public function login(userName:String, password:String = ""): void
		{
			electroServer.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			var loginRequest:LoginRequest = new LoginRequest();
			loginRequest.userName = userName;
			loginRequest.password = password;
			var tempEsObject:EsObject = new EsObject();
			tempEsObject.setString(DataFieldMauBinh.CHANNEL_ID, String(mainData.currentChannelId));
			if (mainData.isFacebookVersion)
				tempEsObject.setString(DataFieldMauBinh.DEVICE_ID, "fb");
			else if (mainData.isOnAndroid)
				tempEsObject.setString(DataFieldMauBinh.DEVICE_ID, "android");
			else
				tempEsObject.setString(DataFieldMauBinh.DEVICE_ID, "ios");
			loginRequest.esObject = tempEsObject;
			electroServer.engine.send(loginRequest);
		}
		
		public function onLoginResponse(e:LoginResponse):void
		{
			electroServer.engine.removeEventListener(MessageType.LoginResponse.name, onLoginResponse);
			if (e.successful)
			{
				this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.LOGIN_SUCCESS));
				
				/*var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
				uuvr.name = DataFieldMauBinh.OTHER_INFO;
				uuvr.value = new EsObject();
				uuvr.value.setString(DataFieldMauBinh.SEX, mainData.chooseChannelData.myInfo.sex);
				electroServer.engine.send(uuvr);*/
		
			} else {
				this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.LOGIN_FAIL));
			}
		}
		
		// sau khi login thì join lobby
		public function joinLobbyRoom(gameName:String, channelId:int, capacity:int = 200): void
		{
			myData.channelId = channelId;
			
			var description:String = "Phòng lobby của game: " + gameName + " tại kênh có id là: " + channelId;
			joinRoom(myData.lobbyName, "", description, null, capacity);
		}
		
		// join lobbyRoom thành công
		public function onJoinLobbyRoomEvent(e:JoinRoomEvent):void
		{
			electroServer.engine.removeEventListener(MessageType.JoinRoomEvent.name, onJoinLobbyRoomEvent);
			
			dispatchEvent(new ElectroServerEvent(ElectroServerEvent.JOIN_LOBBY_ROOM_SUCCESS));
			
			myData.zoneId = e.zoneId;
			myData.roomId = e.roomId;
			myData.saveUserList = new Object();
			
			 //Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.GET_FRIEND_LIST);
			sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			
			electroServer.engine.addEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdateEvent);
			electroServer.engine.addEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdateEvent);
			
			if (timerToGetRoomList)
			{
				timerToGetRoomList.removeEventListener(TimerEvent.TIMER, onGetRoomList);
				timerToGetRoomList.stop();
				mainData.isNoRenderLobbyList = false;
			}
			getRoomList();
			timerToGetRoomList = new Timer(4000);
			timerToGetRoomList.addEventListener(TimerEvent.TIMER, onGetRoomList)
			timerToGetRoomList.start();
		}
		
		private function onGetRoomList(e:TimerEvent):void 
		{
			getRoomList()
		}
		
		public function getFriendList():void
		{
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.GET_FRIEND_LIST);
			sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
		}
		
		public function getRoomList():void
		{
			if (mainData.isNoRenderLobbyList)
				return;
				
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.GET_ROOM_LIST);
			sendPluginRequest(myData.zoneId, myData.roomId, myData.lobbyPluginName, pluginMessage);
				
			/*myData.countGame = 0;
			myData.roomList = new Object();
			var findGame:FindGamesRequest = new FindGamesRequest();
			var search:SearchCriteria = new SearchCriteria();
			search.gameType = myData.gameType;
			search.gameId = -1;
			findGame.searchCriteria = search;
			electroServer.engine.send(findGame);*/
		}
		
		public function onPluginMessageEvent(e:PluginMessageEvent):void 
		{
			//trace("PluginMessageEvent");
			var command:String = e.parameters.getString("command");
			var i:int;
			var j:int;
			var object:Object;
			var userName:String
			switch (command) 
			{
				case Command.GET_PLAYING_INFO: // lấy thông tin của các người chơi trong phòng chơi
					var userList:Array = new Array();
					var tempUserList:Array = e.parameters.getEsObjectArray(DataFieldXito.USER_LIST);
					for (i = 0; i < tempUserList.length; i++) 
					{
						userName = EsObject(tempUserList[i]).getString(DataFieldXito.USER_NAME);
						object = new Object();
						object[DataFieldXito.USER_NAME] = EsObject(tempUserList[i]).getString(DataFieldXito.USER_NAME);
						object[DataFieldXito.POSITION] = EsObject(tempUserList[i]).getInteger(DataFieldXito.POSITION);
						object[DataFieldXito.READY] = false;
						object[DataFieldXito.IS_CURRENT_WINNER] = false;
						object[DataFieldXito.IS_VIEWER] = false;
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldXito.READY))
							object[DataFieldXito.READY] = EsObject(tempUserList[i]).getBoolean(DataFieldXito.READY);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldXito.IS_READY))
							object[DataFieldXito.READY] = EsObject(tempUserList[i]).getBoolean(DataFieldXito.IS_READY);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldXito.CURRENT_BET))
							object[DataFieldXito.CURRENT_BET] = EsObject(tempUserList[i]).getString(DataFieldXito.CURRENT_BET);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldXito.OPEN_CARDS))
							object[DataFieldXito.OPEN_CARDS] = EsObject(tempUserList[i]).getIntegerArray(DataFieldXito.OPEN_CARDS);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldXito.IS_VIEWER))
							object[DataFieldXito.IS_VIEWER] = EsObject(tempUserList[i]).getBoolean(DataFieldXito.IS_VIEWER);
						
						var user:User = electroServer.managerHelper.userManager.userByName(userName);
						
						object[DataFieldXito.DEVICE_ID] = 'none';
						if (user.userVariableByName(DataFieldXito.USER_INFO).value.doesPropertyExist(DataFieldXito.DEVICE_ID))
							object[DataFieldXito.DEVICE_ID] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.DEVICE_ID);
							
						object[DataFieldXito.LEVEL] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.LEVEL);
						object[DataFieldXito.MONEY] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.MONEY);
						object[DataFieldXito.AVATAR] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.AVATAR);
						object[DataFieldXito.DISPLAY_NAME] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.DISPLAY_NAME);
						object[DataFieldXito.IP] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.IP);
						object[DataFieldXito.WIN] = user.userVariableByName(DataFieldXito.USER_INFO).value.getInteger(DataFieldXito.WIN);
						object[DataFieldXito.LOSE] = user.userVariableByName(DataFieldXito.USER_INFO).value.getInteger(DataFieldXito.LOSE);
						if (user.userVariableByName(DataFieldXito.USER_INFO).value.doesPropertyExist(DataFieldXito.SEX))
						{
							object[DataFieldXito.SEX] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.SEX);
						}
						else
						{
							if (user.userVariableByName(DataFieldXito.OTHER_INFO))
							{
								var tempEsObject:EsObject = user.userVariableByName(DataFieldXito.OTHER_INFO).value;
								object[DataFieldXito.SEX] = tempEsObject.getString(DataFieldXito.SEX);
							}
						}
						if (user.userVariableByName(DataFieldXito.USER_INFO).value.doesPropertyExist(DataFieldXito.LOGO))
							object[DataFieldXito.LOGO] = user.userVariableByName(DataFieldXito.USER_INFO).value.getString(DataFieldXito.LOGO);
						userList.push(object);
					}
					
					myData.gameRoomInfo[DataFieldXito.USER_LIST] = userList;
					myData.gameRoomInfo[DataFieldXito.GAME_STATE] = e.parameters.getString(DataFieldXito.GAME_STATE);
					myData.gameRoomInfo[DataFieldXito.ROOM_MASTER] = e.parameters.getString(DataFieldXito.ROOM_MASTER);
					if (e.parameters.doesPropertyExist(DataFieldXito.CURRENT_POT))
						myData.gameRoomInfo[DataFieldXito.CURRENT_POT] = e.parameters.getString(DataFieldXito.CURRENT_POT);
					else
						myData.gameRoomInfo[DataFieldXito.CURRENT_POT] = 0;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.JOIN_GAME_ROOM_SUCCESS, myData.gameRoomInfo));
				break;
				case Command.GAME_OVER_SPECIAL: // Ván chơi kết thúc
					gameOverObject = new Object();
					playerList = new Array();
					tempObject = new Object();
					tempObject[DataFieldXito.MONEY] = 0
					if (Number(e.parameters.getString(DataFieldXito.MONEY)) != 0)
						tempObject[DataFieldXito.MONEY] = e.parameters.getString(DataFieldXito.MONEY);
					tempObject[DataFieldXito.MONEY_BET] = e.parameters.getString(DataFieldXito.MONEY_BET);
					tempObject[DataFieldXito.DISPLAY_NAME] = e.parameters.getString(DataFieldXito.DISPLAY_NAME);
					tempObject[DataFieldXito.USER_NAME] = e.parameters.getString(DataFieldXito.USER_NAME);
					tempObject[DataFieldXito.MONEY] = tempObject[DataFieldXito.MONEY] - tempObject[DataFieldXito.MONEY_BET];
					playerList.push(tempObject);
					gameOverObject[DataFieldXito.PLAYER_LIST] = playerList;
					
					var quiterList:Array = new Array();
					if (e.parameters.doesPropertyExist(DataFieldXito.QUITERS))
					{
						var tempArray:Array = e.parameters.getEsObjectArray(DataFieldXito.QUITERS);
						for (i = 0; i < tempArray.length; i++)
						{
							tempObject = new Object();
							tempObject[DataFieldXito.MONEY] = - Number(EsObject(tempArray[i]).getString(DataFieldXito.MONEY_BET));
							tempObject[DataFieldXito.USER_NAME] = EsObject(tempArray[i]).getString(DataFieldXito.USER_NAME);
							tempObject[DataFieldXito.DISPLAY_NAME] = EsObject(tempArray[i]).getString(DataFieldXito.DISPLAY_NAME);
							tempObject[DataFieldXito.QUITERS] = true;
							quiterList.push(tempObject);
						}
					}
					
					gameOverObject[DataFieldXito.QUITERS] = quiterList;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.GAME_OVER, gameOverObject));
				break;
				case Command.READY: // trả về thông báo click ready thành công
					var readyObject:Object = new Object();
					readyObject[DataFieldMauBinh.USER_NAME] = e.parameters.getString(DataFieldMauBinh.USER_NAME);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.READY_SUCCESS,readyObject));
				break;
				case Command.DEAL_CARD: // thông báo chia bài của server
					var dealCardObject:Object = new Object();
					if (e.parameters.doesPropertyExist(DataFieldXito.PLAYER_CARDS))
					{
						dealCardObject[DataFieldXito.PLAYER_CARDS] = e.parameters.getIntegerArray(DataFieldXito.PLAYER_CARDS);
						var cardArray:Array = dealCardObject[DataFieldXito.PLAYER_CARDS];
						for (i = 0; i < cardArray.length; i++) 
						{
							cardArray[i]++;
						}
					}
					dealCardObject[DataFieldXito.USER_LIST] = e.parameters.getStringArray(DataFieldXito.USER_LIST);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.DEAL_CARD,dealCardObject));
				break;
				case Command.GAME_OVER: // Ván chơi kết thúc
					var gameOverObject:Object = new Object();
					trace(e.parameters.toString())
					var esObjec_PlayerList:Array = e.parameters.getEsObjectArray(DataFieldXito.USER_LIST);
					var resultList:Array = e.parameters.getEsObjectArray(DataFieldXito.GAME_RESULT);
					var playerList:Array = new Array();
					for (i = 0; i < esObjec_PlayerList.length; i++) 
					{
						var tempObject:Object = new Object();
						tempObject[DataFieldXito.USER_NAME] = EsObject(esObjec_PlayerList[i]).getString(DataFieldXito.USER_NAME);
						tempObject[DataFieldXito.DISPLAY_NAME] = EsObject(esObjec_PlayerList[i]).getString(DataFieldXito.DISPLAY_NAME);
						tempObject[DataFieldXito.HAND_CARDS] = EsObject(esObjec_PlayerList[i]).getIntegerArray(DataFieldXito.HAND_CARDS);
						tempObject[DataFieldXito.CARDS] = EsObject(esObjec_PlayerList[i]).getIntegerArray(DataFieldXito.CARDS);
						tempObject[DataFieldXito.MONEY_BET] = EsObject(esObjec_PlayerList[i]).getString(DataFieldXito.MONEY_BET);
						tempObject[DataFieldXito.MONEY] = 0;
						for (j = 0; j < tempObject[DataFieldXito.HAND_CARDS].length; j++)
						{
							tempObject[DataFieldXito.HAND_CARDS][j]++;
						}
						tempObject[DataFieldXito.GROUP_RANK] = EsObject(esObjec_PlayerList[i]).getInteger(DataFieldXito.GROUP_RANK);
						for (j = 0; j < resultList.length; j++)
						{
							var winList:Array = EsObject(resultList[j]).getEsObjectArray(DataFieldXito.WIN_LIST);
							for (var k:int = 0; k < winList.length; k++)
							{
								if (tempObject[DataFieldXito.USER_NAME] == EsObject(winList[k]).getString(DataFieldXito.USER_NAME))
									tempObject[DataFieldXito.MONEY] = Number(EsObject(winList[k]).getString(DataFieldXito.MONEY));
							}
						}
						tempObject[DataFieldXito.MONEY] = tempObject[DataFieldXito.MONEY] - tempObject[DataFieldXito.MONEY_BET];
						cardArray = tempObject[DataFieldXito.PLAYER_CARDS] as Array;
						playerList.push(tempObject);
					}
					gameOverObject[DataFieldXito.PLAYER_LIST] = playerList;
					
					quiterList = new Array();
					if (e.parameters.doesPropertyExist(DataFieldXito.QUITERS))
					{
						tempArray = e.parameters.getEsObjectArray(DataFieldXito.QUITERS);
						for (i = 0; i < tempArray.length; i++)
						{
							tempObject = new Object();
							tempObject[DataFieldXito.MONEY] = - Number(EsObject(tempArray[i]).getString(DataFieldXito.MONEY_BET));
							tempObject[DataFieldXito.USER_NAME] = EsObject(tempArray[i]).getString(DataFieldXito.USER_NAME);
							tempObject[DataFieldXito.DISPLAY_NAME] = EsObject(tempArray[i]).getString(DataFieldXito.DISPLAY_NAME);
							tempObject[DataFieldXito.QUITERS] = true;
							quiterList.push(tempObject);
						}
					}
					
					gameOverObject[DataFieldXito.QUITERS] = quiterList;
					
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.GAME_OVER, gameOverObject));
				break;
				case Command.UPDATE_ROOM_MASTER: // kết quả trả về của hành động ăn bài
					var roomMasterObject:Object = new Object();
					roomMasterObject[DataFieldMauBinh.ROOM_MASTER] = e.parameters.getString(DataFieldMauBinh.ROOM_MASTER);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_MASTER, roomMasterObject));
				break;
				case Command.ADD_FRIEND: // Server confirm là lời mời kết bạn đã hợp lệ
					var isSuccess:Boolean = e.parameters.getBoolean("success");
					if (isSuccess)
					{
						var addFriendObject:Object = new Object();
						addFriendObject[DataFieldMauBinh.FRIEND_ID] = e.parameters.getString(DataFieldMauBinh.FRIEND_ID);
						dispatchEvent(new ElectroServerEvent(ElectroServerEvent.SEND_ADD_FRIEND_SUCCESS, addFriendObject));
					}
				break; 
				case Command.CONFIRM_FRIEND_REQUEST: // Xác nhận với server đồng ý hay từ chối lời mời kết bạn
					isSuccess = e.parameters.getBoolean("success");
					var confirmFriendRequestObject:Object = new Object();
					confirmFriendRequestObject[DataFieldMauBinh.FRIEND_ID] = e.parameters.getString(DataFieldMauBinh.FRIEND_ID);
					confirmFriendRequestObject[DataFieldMauBinh.CONFIRM] = e.parameters.getBoolean(DataFieldMauBinh.CONFIRM);
					if (confirmFriendRequestObject[DataFieldMauBinh.CONFIRM])
					{
						if(isSuccess)
							dispatchEvent(new ElectroServerEvent(ElectroServerEvent.CONFIRM_FRIEND_REQUEST, confirmFriendRequestObject));
					}
					else
					{
						dispatchEvent(new ElectroServerEvent(ElectroServerEvent.CONFIRM_FRIEND_REQUEST, confirmFriendRequestObject));
					}
				break;
				case Command.GET_FRIEND_LIST: // Get danh sách bạn bè
					myData.friendList = new Object();
					var friendList:Array = e.parameters.getEsObjectArray(DataFieldMauBinh.FRIEND_LIST);
					var friendObject:Object;
					var userData:UserDataULC;
					tempUserList = new Array();
					for (i = 0; i < friendList.length; i++) 
					{
						userData = new UserDataULC();
						userData.isJoinRoom = true;
						userData.isViewPersonalInfo = true;
						userData.isMakeFriend = true;
						userData.moneyLogoUrl = '';
						userData.displayName = EsObject(friendList[i]).getString(DataFieldMauBinh.DISPLAY_NAME);
						userData.levelName = EsObject(friendList[i]).getString(DataFieldMauBinh.LEVEL);
						userData.userID = EsObject(friendList[i]).getString(DataFieldMauBinh.USER_NAME);
						userData.userName = EsObject(friendList[i]).getString(DataFieldMauBinh.USER_NAME);
						userData.isOnline = EsObject(friendList[i]).getBoolean(DataFieldMauBinh.ONLINE);
						if (userData.isOnline)
						{
							userData.roomID = int(EsObject(friendList[i]).getString("room_id"));
							
							switch (EsObject(friendList[i]).getString("game_id")) 
							{
								case "AZGB_BINH":
									userData.gameId = MainData.MAUBINH_ID;
								break;
								case "AZGB_PHOM":
									userData.gameId = MainData.PHOM_ID;
								break;
								case "AZGB_TLMN":
									userData.gameId = MainData.TLMN_ID;
								break;
								case "AZGB_SAM":
									userData.gameId = MainData.SAM_ID;
								break;
								case "AZGB_XITO":
									userData.gameId = MainData.XITO_ID;
								break;
								default:
							}
						}
						
						if (!EsObject(friendList[i]).doesPropertyExist(DataFieldMauBinh.LOSE))
							userData.lose = 0;
						else
							userData.lose = EsObject(friendList[i]).getInteger(DataFieldMauBinh.LOSE);
						if (!EsObject(friendList[i]).doesPropertyExist(DataFieldMauBinh.WIN))
							userData.win = 0;
						else
							userData.win = EsObject(friendList[i]).getInteger(DataFieldMauBinh.WIN);
							
						userData.money = EsObject(friendList[i]).getString(DataFieldMauBinh.MONEY);
						
						userData.avatar = EsObject(friendList[i]).getString(DataFieldMauBinh.AVATAR);
						userData.isFriend = true;
						
						if (userData.userName != mainData.chooseChannelData.myInfo.uId)
							tempUserList.push(userData);
					}
					
					mainData.lobbyRoomData.friendList = tempUserList;
				break;
				case Command.REMOVE_FRIEND: // Server confirm remove friend
					trace("aaaaaaaaaaaaaaaaaaaaa");
				break;
				case Command.ADD_MONEY: // add money khi hết tiền
					var addMoneyObject:Object = new Object();
					addMoneyObject[DataFieldMauBinh.SUCCESS] = e.parameters.getBoolean(DataFieldMauBinh.ADD_MONEY);
					addMoneyObject[DataFieldMauBinh.NUMBER] = e.parameters.getInteger(DataFieldMauBinh.NUMBER);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.ADD_MONEY, addMoneyObject));
				break;
				case Command.GET_ROOM_LIST: // update roomList và userList
					var roomList:Array = e.parameters.getEsObjectArray(DataFieldMauBinh.ROOM_LIST);
					myData.roomList = new Object();
					myData.userList = new Object();
					for (i = 0; i < roomList.length; i++) 
					{
						var gameDetails:EsObject = EsObject(roomList[i]).getEsObject(DataFieldMauBinh.GAME_DETAILS);
						var roomId:int = EsObject(roomList[i]).getInteger(DataFieldMauBinh.ROOM_ID);
						myData.roomList[roomId] = new Object();
						myData.roomList[roomId][DataFieldMauBinh.IS_SEND_CARD] = gameDetails.getBoolean(DataFieldMauBinh.IS_SEND_CARD);
						myData.roomList[roomId][DataFieldMauBinh.ROOM_BET] = gameDetails.getString(DataFieldMauBinh.ROOM_BET);
						myData.roomList[roomId][DataFieldMauBinh.ROOM_NAME] = gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
						myData.roomList[roomId][DataFieldMauBinh.GAME_ID] = EsObject(roomList[i]).getInteger(DataFieldMauBinh.GAME_ID);
						myData.roomList[roomId][DataFieldMauBinh.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataFieldMauBinh.HAS_PASSWORD);
						myData.roomList[roomId][DataFieldMauBinh.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataFieldMauBinh.USER_LIST).length;
						myData.roomList[roomId][DataFieldMauBinh.MALE] = 0;
						myData.roomList[roomId][DataFieldMauBinh.MAX_PLAYER] = gameDetails.getInteger(DataFieldMauBinh.MAX_PLAYER);
						userList = EsObject(roomList[i]).getEsObjectArray(DataFieldMauBinh.USER_LIST);
						for (j = 0; j < userList.length; j++) 
						{
							userName = EsObject(userList[j]).getString(DataFieldMauBinh.USER_NAME);
							myData.userList[userName] = new Object();
							object = convertEsObject(EsObject(userList[j]).getEsObject(DataFieldMauBinh.USER_INFO));
							if (object[DataFieldMauBinh.SEX] == 'M')
								myData.roomList[roomId][DataFieldMauBinh.MALE]++;
							myData.userList[userName][DataFieldMauBinh.USER_INFO] = object;
							myData.userList[userName][DataFieldMauBinh.ROOM_ID] = roomId;
						}
					}
					
					var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(myData.zoneId);
					if (!zone)
						return;
					var room:Room = zone.roomById(myData.lobbyRoomId);
					var userListInLobby:Array = room.users;
					for (i = 0; i < userListInLobby.length; i++) 
					{
						userName = User(userListInLobby[i]).userName;
						object = convertEsObject(UserVariable(User(userListInLobby[i]).userVariableByName(DataFieldMauBinh.USER_INFO)).value);
						if (!object[DataFieldMauBinh.SEX])
							object[DataFieldMauBinh.SEX] = 'M';
						myData.userList[userName] = new Object();
						myData.userList[userName][DataFieldMauBinh.ROOM_ID] = mainData.lobbyRoomId;
						myData.userList[userName][DataFieldMauBinh.USER_INFO] = object;
						if (!object[DataFieldMauBinh.LOSE])
							object[DataFieldMauBinh.LOSE] = 0;
						if (!object[DataFieldMauBinh.WIN])
							object[DataFieldMauBinh.WIN] = 0;
					}
					
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST, myData.userList));
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_LIST, myData.roomList));
				break;
				case PlayingScreenAction.UPDATE_CURRENT_TURN:
					object = new Object();
					object[DataFieldXito.CURRENT_TURN] = e.parameters.getString(DataFieldXito.CURRENT_TURN);
					callPlayingScreenAction(PlayingScreenAction.UPDATE_CURRENT_TURN, object);
				break;
				case PlayingScreenAction.DEAL_MORE_CARD:
					object = new Object();
					trace(e.parameters.toString());
					var userInfoList:Array = new Array();
					if (e.parameters.doesPropertyExist(DataFieldXito.GAME_STATE))
					{
						if (e.parameters.doesPropertyExist(DataFieldXito.USER_NAME))
						{
							tempObject = new Object();
							tempObject[DataFieldXito.USER_NAME] = e.parameters.getString(DataFieldXito.USER_NAME);
							tempObject[DataFieldXito.CARD_ID] = e.parameters.getInteger(DataFieldXito.CARD_ID);
							tempObject[DataFieldXito.CARD_ID]++;
							userInfoList.push(tempObject);
						}
					}
					else
					{
						for (i = 0; i < e.parameters.getEsObjectArray(DataFieldXito.USER_LIST).length; i++)
						{
							tempObject = new Object();
							tempEsObject = e.parameters.getEsObjectArray(DataFieldXito.USER_LIST)[i];
							tempObject[DataFieldXito.USER_NAME] = tempEsObject.getString(DataFieldXito.USER_NAME);
							tempObject[DataFieldXito.CARD_ID] = tempEsObject.getInteger(DataFieldXito.CARD_ID);
							tempObject[DataFieldXito.CARD_ID]++;
							userInfoList.push(tempObject);
						}
					}
					object[DataFieldXito.USER_LIST] = userInfoList;
					callPlayingScreenAction(PlayingScreenAction.DEAL_MORE_CARD, object);
					
				break;
			}
		}
		
		// Gửi lệnh mời chơi
		public function invitePlay(infoObject:Object, invitedNameArray:Array):void
		{
			var invitePlay:PrivateMessageRequest = new PrivateMessageRequest();
			invitePlay.userNames = invitedNameArray;
			invitePlay.message = Command.INVITE_PLAY;
			var message:EsObject = new EsObject();
			message.setString(DataFieldMauBinh.DISPLAY_NAME, infoObject[DataFieldMauBinh.DISPLAY_NAME]);
			message.setString(DataFieldMauBinh.USER_NAME, infoObject[DataFieldMauBinh.USER_NAME]);
			message.setInteger(DataFieldMauBinh.ROOM_ID, myData.gameRoomInfo[DataFieldMauBinh.ROOM_ID]);
			message.setInteger(DataFieldMauBinh.GAME_ID, myData.gameRoomInfo[DataFieldMauBinh.GAME_ID]);
			message.setString(DataFieldMauBinh.ROOM_PASSWORD, infoObject[DataFieldMauBinh.ROOM_PASSWORD]);
			message.setString(DataFieldMauBinh.ROOM_BET, infoObject[DataFieldMauBinh.ROOM_BET]);
			message.setString(DataFieldMauBinh.MESSAGE, infoObject[DataFieldMauBinh.MESSAGE]);
			message.setString(DataFieldMauBinh.MONEY, infoObject[DataFieldMauBinh.MONEY]);
			message.setString(DataFieldMauBinh.AVATAR, infoObject[DataFieldMauBinh.AVATAR]);
			message.setString(DataFieldMauBinh.SEX, infoObject[DataFieldMauBinh.SEX]);
			
			invitePlay.esObject = message;
			electroServer.engine.send(invitePlay);
		}
		
		public function sendPrivateMessage(invitedNameArray:Array, command:String, esObject:EsObject):void
		{
			var privateMessageRequest:PrivateMessageRequest = new PrivateMessageRequest();
			privateMessageRequest.userNames = invitedNameArray;
			privateMessageRequest.message = command;
			
			privateMessageRequest.esObject = esObject;
			electroServer.engine.send(privateMessageRequest);
		}
		
		public function onLeaveRoomEvent(e:LeaveRoomEvent):void
		{
			
		}
		
		public function onUserEvictedFromRoomEvent(e:UserEvictedFromRoomEvent):void
		{
			var isMe:Boolean = electroServer.managerHelper.userManager.userByName(e.userName).isMe;
			switch (e.reason) 
			{
				case Command.ROOM_MASTER_KICK:
					try 
					{
						if (isMe)
						{
							var kickedObject:Object = new Object();
							kickedObject[DataFieldMauBinh.USER_NAME] = e.userName;
							dispatchEvent(new ElectroServerEvent(ElectroServerEvent.ROOM_MASTER_KICK, kickedObject));
						}
					}
					catch (err:Error)
					{
						
					}
				break;
				case Command.TIME_OUT: // Quá thời gian nhưng không đánh bài
					if (isMe)
						dispatchEvent(new ElectroServerEvent(ElectroServerEvent.TIME_OUT, null));
				break;
				case Command.HACKING: // Đánh một quân bài không tồn tại
					if (isMe)
						dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HACKING, null));
				break;
			}
		}
		
		public function kickUser(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.KICK_USER, esObject);
		}
		
		public function sendEmo(userName:String, emoType:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			esObject.setInteger(DataFieldMauBinh.EMO_TYPE, emoType);
			sendPublicMessage(Command.SEND_EMO, esObject);
		}
		
		public function addFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.ADD_FRIEND);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			pluginMessage.setString(DataFieldMauBinh.REQUEST_CONTENT, "aaaa");
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
		}
		
		public function removeFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.REMOVE_FRIEND);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
		}
		
		public function addMoney():void
		{
			// Gửi pluginRequest lên để request nạp tiền
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.ADD_MONEY);
			sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
		}
		
		public function updateMoney():void
		{
			if (myData.roomId == -1)
				return;
			// Gửi pluginRequest lên để request nạp tiền
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.REFRESH_MONEY);
			if (myData.roomId == myData.lobbyRoomId)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.lobbyPluginName, pluginMessage);
			else
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
		}
		
		public function orderCard(arr1:Array,arr2:Array,arr3:Array,arr4:Array):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_1, arr1);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_2, arr2);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_3, arr3);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_4, arr4);
			sendPublicMessage(Command.START_GAME_1, esObject);
		}
		
		public function confirmInviteAddFriend(userName:String, isAccept:Boolean, roomType:String):void
		{
			// Gửi pluginRequest lên xác nhận đồng ý kết bạn
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.CONFIRM_FRIEND_REQUEST);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			pluginMessage.setBoolean(DataFieldMauBinh.CONFIRM, isAccept);
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
		}
		
		// có sự kiện update userList trong phòng
		public function onUserListUpdateEvent(e:UserUpdateEvent):void
		{
			var zoneId:int = e.zoneId;
			var roomId:int = e.roomId;
			var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(zoneId);
			myData.zoneId = zoneId;
			
			var i:int;
			
			if (e.action == UserUpdateAction.AddUser) // Tình huống có user vừa join vào room 
			{
				if (e.roomId == myData.lobbyRoomId) // join vào lobby
				{
					
				}
				else // join vào game
				{
					// Lấy uservariable của user đó để gửi đi
					userRecentlyJoinRoom = e.userName;
					getUserInfo(userRecentlyJoinRoom);
				}
			}
			else if (e.action == UserUpdateAction.DeleteUser)  // Có user out
			{
				if (e.roomId == myData.lobbyRoomId) // Tình huống có user vừa out ra khỏi lobby room 
				{
					
				}
				else // Tình huống có user vừa out ra khỏi game
				{
					var object:Object = new Object();
					object[DataFieldMauBinh.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_OUT_ROOM, object));
				}
			}
		}
		
		// sự kiện update userVarialbe
		public function onUserVariableUpdateEvent(e:UserVariableUpdateEvent):void
		{
			//trace("onUserVariableUpdateEvent");
			if (e.variable.name == Command.USER_INFO)
			{
				switch (e.action) 
				{
					case UserVariableUpdateAction.VariableCreated: // tình huống vừa có user khác join vào lobby lần đầu tiên và userVariable được tạo
						if (!electroServer.managerHelper.userManager.userByName(e.userName))
							return;
						var isMe:Boolean = electroServer.managerHelper.userManager.userByName(e.userName).isMe;
						if (!isMe)
						{
							
						}
						else
						{
							if (!mainData.chooseChannelData.myInfo.logo)
								return;
							var updateUserVariableRequest:UpdateUserVariableRequest
							updateUserVariableRequest = new UpdateUserVariableRequest();
							updateUserVariableRequest.name = DataFieldMauBinh.USER_INFO;
							var tempEsObject:EsObject = e.variable.value;
							tempEsObject.setString(DataFieldMauBinh.LOGO, mainData.chooseChannelData.myInfo.logo);
							updateUserVariableRequest.value = tempEsObject
							//electroServer.engine.send(updateUserVariableRequest);
						}
					break;
					case UserVariableUpdateAction.VariableUpdated: // tình huống vừa có user bị thay đổi userVariable
						if (myData.roomId == myData.lobbyRoomId)
						{
							isMe = electroServer.managerHelper.userManager.userByName(e.userName).isMe;
							if (!isMe)
							{
								
							}
							else
							{
								if (mainData.chooseChannelData.myInfo.logo)
								{
									updateUserVariableRequest = new UpdateUserVariableRequest();
									updateUserVariableRequest.name = DataFieldMauBinh.USER_INFO
									tempEsObject = e.variable.value;
									if (!tempEsObject.doesPropertyExist(DataFieldMauBinh.LOGO))
									{
										tempEsObject.setString(DataFieldMauBinh.LOGO, mainData.chooseChannelData.myInfo.logo);
										updateUserVariableRequest.value = tempEsObject;
										//electroServer.engine.send(updateUserVariableRequest);
									}
								}
								
								tempEsObject = e.variable.value
								var updateMoneyObject:Object = new Object();
								updateMoneyObject[DataFieldMauBinh.USER_NAME] = tempEsObject.getString(DataFieldMauBinh.USER_NAME);
								updateMoneyObject[DataFieldMauBinh.MONEY] = tempEsObject.getString(DataFieldMauBinh.MONEY);
								dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_MONEY, updateMoneyObject));
							}
						}
						else
						{
							tempEsObject = e.variable.value
							updateMoneyObject = new Object();
							updateMoneyObject[DataFieldMauBinh.USER_NAME] = tempEsObject.getString(DataFieldMauBinh.USER_NAME);
							updateMoneyObject[DataFieldMauBinh.MONEY] = tempEsObject.getString(DataFieldMauBinh.MONEY);
							dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_MONEY, updateMoneyObject));
						}
					break;
				}
			}
		}
		
		// sự kiện update roomVarialbe
		public function onRoomVariableUpdateEvent(e:RoomVariableUpdateEvent):void
		{
			/*trace(e);
			var roomList:Array = e.value.getEsObjectArray(DataField.ROOM_LIST);
			myData.roomList = new Object();
			myData.userList = new Object();
			for (var i:int = 0; i < roomList.length; i++) 
			{
				var gameDetails:EsObject = EsObject(roomList[i]).getEsObject(DataField.GAME_DETAILS);
				var roomId:int = EsObject(roomList[i]).getInteger(DataField.ROOM_ID);
				myData.roomList[roomId] = new Object();
				myData.roomList[roomId][DataField.ROOM_BET] = gameDetails.getString(DataField.ROOM_BET);
				myData.roomList[roomId][DataField.ROOM_NAME] = gameDetails.getString(DataField.ROOM_NAME);
				myData.roomList[roomId][DataField.GAME_ID] = EsObject(roomList[i]).getInteger(DataField.GAME_ID);
				myData.roomList[roomId][DataField.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataField.HAS_PASSWORD);
				myData.roomList[roomId][DataField.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataField.USER_LIST).length;
				var userList:Array = EsObject(roomList[i]).getEsObjectArray(DataField.USER_LIST);
				for (var j:int = 0; j < userList.length; j++) 
				{
					var userName:String = EsObject(userList[j]).getString(DataField.USER_NAME);
					myData.userList[userName] = new Object();
					var object:Object = convertEsObject(EsObject(userList[j]).getEsObject(DataField.USER_INFO));
					myData.userList[userName][DataField.USER_INFO] = object;
					myData.userList[userName][DataField.ROOM_ID] = roomId;
				}
			}
			
			var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(myData.zoneId);
			var room:Room = zone.roomById(myData.lobbyRoomId);
			var userListInLobby:Array = room.users;
			for (i = 0; i < userListInLobby.length; i++) 
			{
				userName = User(userListInLobby[i]).userName;
				object = convertEsObject(UserVariable(User(userListInLobby[i]).userVariableByName(DataField.USER_INFO)).value);
				myData.userList[userName] = new Object();
				myData.userList[userName][DataField.ROOM_ID] = 0;
				myData.userList[userName][DataField.USER_INFO] = object;
			}
			
			dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST, myData.userList));
			dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_LIST, myData.roomList));*/
		}
		
		// sự kiện updateZone
		public function onZoneUpdateEvent(e:ZoneUpdateEvent):void
		{
			
		}
		
		public function getUserInLobby():void
		{
			myData.userListOfLobby = new Object();
			getUserInRoom(myData.lobbyRoomId);
		}
		
		public function onFindGameRespond(e:FindGamesResponse):void
		{
			var gameList:Array = e.games;
			var roomId:int;
			for (var i:int = 0; i < gameList.length; i++) 
			{
				roomId = ServerGame(gameList[i]).gameDetails.getInteger(DataFieldMauBinh.ROOM_ID);
				if (electroServer.managerHelper.zoneManager.zoneById(myData.zoneId).roomById(roomId))
				{
					myData.roomList[roomId] = new Object();
					myData.roomList[roomId][DataFieldMauBinh.GAME_ID] = ServerGame(gameList[i]).id;
					myData.roomList[roomId][DataFieldMauBinh.HAS_PASSWORD] = ServerGame(gameList[i]).passwordProtected;
					myData.roomList[roomId][DataFieldMauBinh.ROOM_NAME] = ServerGame(gameList[i]).gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
					myData.roomList[roomId][DataFieldMauBinh.ROOM_BET] = ServerGame(gameList[i]).gameDetails.getString(DataFieldMauBinh.ROOM_BET);
					if (ServerGame(gameList[i]).gameDetails.doesPropertyExist(DataFieldMauBinh.IS_SEND_CARD))
						myData.roomList[roomId][DataFieldMauBinh.IS_SEND_CARD] = ServerGame(gameList[i]).gameDetails.getBoolean(DataFieldMauBinh.IS_SEND_CARD);
					getUserInRoom(roomId);
				}
			}
		}
		
		public function createGameRoom(gameOption:Object, password:String):void
		{
			leaveRoom();
			var gameDetails:EsObject = new EsObject();
			gameDetails.setString(DataFieldMauBinh.ROOM_NAME, gameOption[DataFieldMauBinh.ROOM_NAME]);
			gameDetails.setString(DataFieldMauBinh.ROOM_BET, gameOption[DataFieldMauBinh.ROOM_BET]);
			gameDetails.setBoolean(DataFieldMauBinh.IS_SEND_CARD, gameOption[DataFieldMauBinh.IS_SEND_CARD]);
			gameDetails.setInteger(DataFieldMauBinh.MAX_PLAYER, gameOption[DataFieldMauBinh.MAX_PLAYER]);
			//var createGameRequest:CreateGameRequest = new CreateGameRequest();
			var createGameRequest:QuickJoinGameRequest = new QuickJoinGameRequest();
			createGameRequest.gameType = myData.gameType;
			createGameRequest.zoneName = mainData.game_id + "_" + String(myData.channelId);
			createGameRequest.gameDetails = gameDetails;
			createGameRequest.createOnly = true;
			createGameRequest.password = password;
			electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			electroServer.engine.send(createGameRequest);
		}
		
		public function joinGameRoom(gameId:int, password:String):void
		{
			leaveRoom();
			var joinGameRequest:JoinGameRequest = new JoinGameRequest();
			joinGameRequest.gameId = gameId;
			joinGameRequest.password = password;
			electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			electroServer.engine.send(joinGameRequest);
		}
		
		public function onCreateOrJoinGameResponse(e:CreateOrJoinGameResponse):void
		{
			if (timerToGetRoomList)
			{
				timerToGetRoomList.removeEventListener(TimerEvent.TIMER, onGetRoomList)
				timerToGetRoomList.stop();
				mainData.isNoRenderLobbyList = false;
			}
			
			electroServer.engine.removeEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			electroServer.engine.removeEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdateEvent);
			if (e.successful) {
				electroServer.engine.addEventListener(MessageType.ZoneUpdateEvent.name, onZoneUpdateEvent);
				//electroServer.engine.removeEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdateEvent);
				
				myData.roomId = e.gameDetails.getInteger("roomId");
				var i:int;
				
				myData.gameRoomInfo = new Object();
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_ID] = myData.roomId;
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_BET] = e.gameDetails.getString(DataFieldMauBinh.ROOM_BET);
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_NAME] = e.gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
				myData.gameRoomInfo[DataFieldMauBinh.IS_SEND_CARD] = e.gameDetails.getBoolean(DataFieldMauBinh.IS_SEND_CARD);
				myData.gameRoomInfo[DataFieldMauBinh.GAME_ID] = e.gameId;
				
				// Gửi pluginRequest lên lấy thông tin các user trong phòng chơi
				var pluginMessage:EsObject = new EsObject();
				pluginMessage.setString("command", Command.GET_PLAYING_INFO);
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
			}
			else 
			{
				//trace("khong vao dc phong game yeu cau");
				dispatchEvent(new ElectroServerEvent(ElectroServerEvent.JOIN_GAME_ROOM_FAIL));
			}
		}
		
		public function sendPublicChat(displayName:String, chatContent:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.DISPLAY_NAME, displayName);
			esObject.setString(DataFieldMauBinh.CHAT_CONTENT, chatContent);
			sendPublicMessage(Command.PUBLIC_CHAT, esObject);
		}
		
		// Gửi publicMessage lên thông báo người chơi đã sẵn sàng chơi
		public function readyPlay():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(Command.READY, esObject);
		}
		
		// Gửi publicMessage lên thông báo người chơi đã xếp bài xong
		public function arrangeCardFinish(cardInfo:Array, isSort:Boolean = true):void
		{
			for (var i:int = 0; i < cardInfo.length; i++) 
			{
				cardInfo[i]--;
			}
			//cardInfo.reverse();
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray(DataFieldMauBinh.CARDS, cardInfo);
			esObject.setBoolean(DataFieldMauBinh.IS_SORT, isSort);
			sendPublicMessage(Command.SORT_FINISH, esObject);
		}
		
		// Gửi publicMessage lên thông báo chủ phòng đã bắt đầu
		public function startGame():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(Command.START_GAME, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi đã sẵn sàng chơi
		public function playOneCard(cardId:int, nextTurn:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			esObject.setString(DataFieldMauBinh.NEXT_TURN, nextTurn);
			sendPublicMessage(Command.DISCARD, esObject);
		}
		
		private function sendPublicMessage(command:String, esObject:EsObject):void
		{
			if (myData.roomId == -1)
				return;
			var publicMessageRequest:PublicMessageRequest = new PublicMessageRequest();
			publicMessageRequest.roomId = myData.roomId;
			publicMessageRequest.zoneId = myData.zoneId;
			publicMessageRequest.message = "";
			if (!esObject)
				esObject = new EsObject();
			esObject.setString(DataFieldMauBinh.COMMAND, command);
			publicMessageRequest.esObject = esObject;
			electroServer.engine.send(publicMessageRequest);
		}
		
		// Gửi pluginRequest lên thông báo người chơi đã sẵn sàng chơi
		public function getOneCard(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.DRAW_CARD, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi vừa ăn một con bài
		public function stealCard(userName:String, cardId:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.STEAL_CARD, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi vừa ăn một con bài
		public function downOneDeck(userName:String, cardArray:Array):void
		{
			for (var i:int = 0; i < cardArray.length; i++) 
			{
				cardArray[i]--;
			}
			
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray(DataFieldMauBinh.CARDS, cardArray);
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.LAYING_CARD, esObject);
		}
		
		// thông báo hạ xong
		public function downCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.LAYING_DONE, esObject);
		}
		
		// thông báo gửi xong
		public function sendCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(Command.SEND_CARD_FINISH, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi gửi bài
		public function sendCard(userName:String, destinationUser:String, index:int, cardId:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			esObject.setString(DataFieldMauBinh.PLAYER_DESTINATION, destinationUser);
			esObject.setInteger(DataFieldMauBinh.INDEX, index);
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			sendPublicMessage(Command.SEND_CARD, esObject);
		}
		
		// Gửi thông báo ù lên server
		public function noticeFullDeck():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(Command.FULL_LAYING_CARDS, esObject);
		}
		
		private function sendPluginRequest(_zoneId:int, _roomId:int, pluginName:String, esObject:EsObject = null):void
		{
			if (myData.roomId == -1)
				return;
			var pluginRequest:PluginRequest = new PluginRequest();
			pluginRequest.zoneId = _zoneId;
			pluginRequest.roomId = _roomId;
			pluginRequest.pluginName = pluginName;
			pluginRequest.parameters = esObject;
			electroServer.engine.send(pluginRequest);
		}
		
		private function joinRoom(roomName: String, roomPassword: String = "", roomDescription: String = "", plugins: Array = null, roomCapacity: int = -1): void
		{
			if (myData.channelId != -1)
				leaveRoom();
				
			var createRoomRequest:CreateRoomRequest = new CreateRoomRequest();
			createRoomRequest.zoneName = mainData.game_id + "_" + String(myData.channelId);
			createRoomRequest.roomName = roomName;
			createRoomRequest.roomDescription = roomDescription;
			createRoomRequest.capacity = roomCapacity;
			createRoomRequest.password = roomPassword;
			
			if (roomName == myData.lobbyName)
			{
				createRoomRequest.roomName = "Lobby";
				createRoomRequest.persistent = true; // dù không có người chơi phòng này vẫn tồn tại
			}
			else
			{
				createRoomRequest.persistent = false; // không có người chơi thì phòng này không tồn tại
			}
			
			var plugin:PluginListEntry = new PluginListEntry();
			plugin.extensionName = myData.lobbyName;
			
			if (roomName == myData.lobbyName) // Nếu là phòng chờ thì không cẩm plugins phỏm nên sẽ tạo một array plugins mới
			{
				plugins = new Array();
				plugin.pluginHandle = myData.lobbyPluginName;
				plugin.pluginName = myData.lobbyPluginName;
				electroServer.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinLobbyRoomEvent);
			}
			
			plugins.push(plugin);
			createRoomRequest.plugins = plugins;
			electroServer.engine.send(createRoomRequest);
		}
		
		/**
		 * Lấy danh sách tất cả các user trong một room
		 */		
		public function getUserInRoom(roomId:int):void
		{
			var zoneName:String = mainData.game_id + "_" + myData.channelId;
			var zoneId: int = electroServer.managerHelper.zoneManager.zoneByName(zoneName).id;
			var getUsersInRoomRequest:GetUsersInRoomRequest = new GetUsersInRoomRequest();
			getUsersInRoomRequest.roomId = roomId;
			getUsersInRoomRequest.zoneId = zoneId;
			electroServer.engine.send(getUsersInRoomRequest);
		}
		
		public function onGetUsersInRoomResponse(e:GetUsersInRoomResponse): void
		{
			var i:int;
			
			var user:UserListEntry;
			if (myData.roomId != myData.lobbyRoomId) // Nếu user đang ở trong phòng game và lấy danh sách user trong phòng chờ dùng cho việc mời chơi
			{
				if (!myData.userListOfLobby)
					return;
				for each (user in e.users)
				{
					userName = user.userName;
					if (!myData.userListOfLobby[userName])
						myData.userListOfLobby[userName] = new Object();
					getUserInfo(userName);
				}
				return;
			}
			
			var message: EsObject = new EsObject();
			var usernameArr: Array = new Array();
			var userName:String;
			
			for each (user in e.users)
			{
				userName = user.userName;
				if (!myData.userList[userName])
				{
					myData.userList[userName] = new Object();
					if (!myData.saveUserList[userName])
						myData.saveUserList[userName] = new Object();
				}
				myData.userList[userName][DataFieldMauBinh.ROOM_ID] = e.roomId;
			}
			
			var userList:Array = e.users
			var roomId:String = String(e.roomId);
			
			myData.countGame++;
			if (!myData.roomList[roomId])
				return;
			myData.roomList[roomId][DataFieldMauBinh.USER_LIST] = new Array();
			for (i = 0; i < userList.length; i++) 
			{
				(myData.roomList[roomId][DataFieldMauBinh.USER_LIST] as Array).push(UserListEntry(userList[i]).userName);
			}
			
			var countTotalGame:int = 0;
			for (roomId in myData.roomList)
			{
				countTotalGame++;
			}
			
			if (countTotalGame == myData.countGame)
			{
				dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_LIST, myData.roomList));
				/*for (userName in myData.userList)
				{
					if (myData.userList[userName][DataField.ROOM_ID] != 0)
					{
						if (!myData.saveUserList[userName][DataField.USER_INFO])
							getUserInfo(userName);
						else
							myData.userList[userName][DataField.USER_INFO] = myData.saveUserList[userName][DataField.USER_INFO];
					}
				}*/
			}
		}
		
		private function compareTwoUserArray(nameArray:Array, userArray:Array):Array
		{
			var isDifferent:Boolean;
			var i:int;
			var j:int;
			var differentNameArray:Array = new Array();
			if (nameArray.length > userArray.length)
			{
				for (i = 0; i < nameArray.length; i++)
				{
					isDifferent = true;
					for (j = 0; j < userArray.length; j++) 
					{
						if (nameArray[i] == UserListEntry(userArray[j]).userName)
							isDifferent = false;
					}
					if (isDifferent)
						differentNameArray.push(nameArray[i]);
				}
			}
			else
			{
				for (i = 0; i < userArray.length; i++)
				{
					isDifferent = true;
					for (j = 0; j < nameArray.length; j++) 
					{
						if (nameArray[j] == UserListEntry(userArray[i]).userName)
							isDifferent = false;
					}
					if (isDifferent)
						differentNameArray.push(UserListEntry(userArray[i]).userName);
				}
			}
			return differentNameArray;
		}
		
		// Lấy thông tin userInfo
		public function getUserInfo(userName:String):void
		{
			var getUserVariableRequest:GetUserVariablesRequest
			getUserVariableRequest = new GetUserVariablesRequest();
			getUserVariableRequest.userName = userName;
			getUserVariableRequest.userVariableNames.add(DataFieldMauBinh.USER_INFO);
			electroServer.engine.send(getUserVariableRequest);
		}
		
		public function onGetUserInfoResponse(e:GetUserVariablesResponse):void
		{
			var varArr: Array = new Array();
			var i:int;
			var object:Object = convertEsObject(e.userVariables[DataFieldMauBinh.USER_INFO]);
			
			if (!object[DataFieldMauBinh.SEX])
				object[DataFieldMauBinh.SEX] = 'M';
			var userName:String = object[DataFieldMauBinh.USER_NAME];
			
			// trường hợp đang trong phòng game, cần lấy danh sách user trong lobby
			if (myData.roomId != myData.lobbyRoomId)
			{
				if (myData.userListOfLobby)
				{
					userName = object[DataFieldMauBinh.USER_NAME];
					if (myData.userListOfLobby[userName])
					{
						myData.userListOfLobby[userName][DataFieldMauBinh.DISPLAY_NAME] = object[DataFieldMauBinh.DISPLAY_NAME];
						myData.userListOfLobby[userName][DataFieldMauBinh.MONEY] = object[DataFieldMauBinh.MONEY];
						myData.userListOfLobby[userName][DataFieldMauBinh.AVATAR] = object[DataFieldMauBinh.AVATAR];
						myData.userListOfLobby[userName][DataFieldMauBinh.LEVEL] = object[DataFieldMauBinh.LEVEL];
						var isUpdateUserListOfLobby:Boolean = true;
						for (userName in myData.userListOfLobby)
						{
							if (!myData.userListOfLobby[userName][DataFieldMauBinh.DISPLAY_NAME])
								isUpdateUserListOfLobby = false;
						}
						if(isUpdateUserListOfLobby)
							dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST_OF_LOBBY, myData.userListOfLobby));
					}
				}
			}
			
			if (object[DataFieldMauBinh.USER_NAME] == userRecentlyJoinRoom && myData.roomId != myData.lobbyRoomId) // Tình huống vừa có user join vào phòng game của mình và lấy userVariable của nó
			{
				var userRecentlyJoinRoomObject:Object = new Object();
				userRecentlyJoinRoomObject[DataFieldMauBinh.USER_NAME] = userRecentlyJoinRoom;
				userRecentlyJoinRoomObject[DataFieldMauBinh.LEVEL] = object[DataFieldMauBinh.LEVEL];
				userRecentlyJoinRoomObject[DataFieldMauBinh.MONEY] = object[DataFieldMauBinh.MONEY];
				userRecentlyJoinRoomObject[DataFieldMauBinh.AVATAR] = object[DataFieldMauBinh.AVATAR];
				userRecentlyJoinRoomObject[DataFieldMauBinh.IP] = object[DataFieldMauBinh.IP];
				userRecentlyJoinRoomObject[DataFieldMauBinh.WIN] = object[DataFieldMauBinh.WIN];
				userRecentlyJoinRoomObject[DataFieldMauBinh.LOSE] = object[DataFieldMauBinh.LOSE];
				if (object[DataFieldMauBinh.SEX])
					userRecentlyJoinRoomObject[DataFieldMauBinh.SEX] = object[DataFieldMauBinh.SEX];
				else
					userRecentlyJoinRoomObject[DataFieldMauBinh.SEX] = 'M';
				if (object[DataFieldMauBinh.DEVICE_ID])
					userRecentlyJoinRoomObject[DataFieldMauBinh.DEVICE_ID] = object[DataFieldMauBinh.DEVICE_ID];
				else
					userRecentlyJoinRoomObject[DataFieldMauBinh.DEVICE_ID] = 'none';
				userRecentlyJoinRoomObject[DataFieldMauBinh.DISPLAY_NAME] = object[DataFieldMauBinh.DISPLAY_NAME];
				userRecentlyJoinRoomObject[DataFieldMauBinh.LOGO] = object[DataFieldMauBinh.LOGO];
				userRecentlyJoinRoom = "";
				dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_JOIN_ROOM, userRecentlyJoinRoomObject));
			}
			else if (myData.roomId == myData.lobbyRoomId)
			{
				myData.userList[userName][DataFieldMauBinh.USER_INFO] = object;
				if (!myData.saveUserList[userName])
					myData.saveUserList[userName] = new Object();
				myData.saveUserList[userName][DataFieldMauBinh.USER_INFO] = object;
				var totalUser:int = 0;
				for (userName in myData.userList)
				{
					totalUser++;
				}
				var countUser:int = 0;
				for (userName in myData.userList)
				{
					if (myData.userList[userName][DataFieldMauBinh.USER_INFO])
						countUser++;
				}
				
				if (countUser == totalUser) // lấy đầy đủ thông tin user khi ở lobby
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST, myData.userList));
			}
		}
		
		private function leaveRoom(): void
		{
			if (myData.roomId == -1)
				return;
			if (myData.roomId != Room(Zone(electroServer.managerHelper.zoneManager.zones[0]).getJoinedRooms()[0]).id)
				return;
			var leaveRoomRequest:LeaveRoomRequest = new LeaveRoomRequest();
			leaveRoomRequest.zoneId = myData.zoneId;
			leaveRoomRequest.roomId = myData.roomId;
			myData.roomId = -1;
			electroServer.engine.send(leaveRoomRequest);
			
		}
		
		public function closeConnection():void
		{
			if (timerToGetRoomList)
			{
				timerToGetRoomList.removeEventListener(TimerEvent.TIMER, onGetRoomList);
				timerToGetRoomList.stop();
			}
			
			myData.roomId = -1;
			electroServer.engine.removeEventListener(MessageType.FindGamesResponse.name, onFindGameRespond);
			electroServer.engine.removeEventListener(MessageType.UserUpdateEvent.name, onUserListUpdateEvent);
			electroServer.engine.removeEventListener(MessageType.ConnectionClosedEvent.name, onCloseConnection);
			electroServer.engine.removeEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			electroServer.engine.removeEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			electroServer.engine.removeEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			electroServer.engine.removeEventListener(MessageType.GetUsersInRoomResponse.name, onGetUsersInRoomResponse);
			electroServer.engine.removeEventListener(MessageType.GetUserVariablesResponse.name, onGetUserInfoResponse);
			electroServer.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			electroServer.engine.removeEventListener(MessageType.ZoneUpdateEvent.name, onZoneUpdateEvent);
			electroServer.engine.close();
		}
		
		public function onGenericErrorResponse(e:GenericErrorResponse): void
		{
			switch (e.errorType.name) 
			{
				case Command.ROOM_MASTER_KICK: // Bị chủ phòng kích ra 
					//trace("GenericErrorResponse plugin not found");
					this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.PLUGIN_NOT_FOUND));
				break;
			}
		}
		
		// Hàm convert EsObject thành object thường
		private function convertEsObject(_eso:EsObject):Object
		{
			var obj: Object = new Object();
			for each (var esoDataHolder: EsObjectDataHolder in _eso.getEntries())
			{
				switch (esoDataHolder.getDataType())
				{
					case DataType.Integer:
						obj[esoDataHolder.getName()] = esoDataHolder.getIntValue();
						break;
					case DataType.IntegerArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getIntArrayValue();
						break;
					case DataType.EsNumber:
						obj[esoDataHolder.getName()] = esoDataHolder.getNumberValue();
						break;
					case DataType.NumberArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getNumberArrayValue();
						break;
					case DataType.Long:
						obj[esoDataHolder.getName()] = esoDataHolder.getLongValue()
						break;
					case DataType.LongArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getLongArrayValue()
						break;
					case DataType.Double:
						obj[esoDataHolder.getName()] = esoDataHolder.getDoubleValue();
						break;
					case DataType.DoubleArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getDoubleArrayValue()
						break;
					case DataType.BooleanArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getBooleanArrayValue();
						break;
					case DataType.Boolean:
						obj[esoDataHolder.getName()] = esoDataHolder.getBooleanValue();
						break;
					case DataType.StringArray:
						obj[esoDataHolder.getName()] = esoDataHolder.getStringArrayValue();
						break;
					case DataType.EsString:
						obj[esoDataHolder.getName()] = esoDataHolder.getStringValue();
						break;
				}
			}
			return obj;
		}
		
		private var _configuration:EsConfiguration;
		private var timerToFindGameRequest:Timer;
		public function get configuration():EsConfiguration 
		{
			return _configuration;
		}
		
		public function set configuration(value:EsConfiguration):void 
		{
			_configuration = value;
		}
		
		public function pingToServer():void
		{
			var pingRequest:GetUserCountRequest = new GetUserCountRequest();
			electroServer.engine.send(pingRequest);
			sendPublicMessage(Command.HEART_BEAT, null);
		}
		
		public function check(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.COMMAND, PlayingScreenAction.CHECK);
			sendPublicMessage(PlayingScreenAction.CHECK, esObject);
		}
		
		public function allIn(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.COMMAND, PlayingScreenAction.ALL_IN);
			sendPublicMessage(PlayingScreenAction.ALL_IN, esObject);
		}
		
		public function call(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.COMMAND, PlayingScreenAction.CALL);
			sendPublicMessage(PlayingScreenAction.CALL, esObject);
		}
		
		public function fold(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.COMMAND, PlayingScreenAction.FOLD);
			sendPublicMessage(PlayingScreenAction.FOLD, esObject);
		}
		
		public function raise(userName:String, money:String, type:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.MONEY, money);
			esObject.setInteger(DataFieldXito.RAISE_TYPE, type);
			esObject.setString(DataFieldXito.COMMAND, PlayingScreenAction.RAISE);
			sendPublicMessage(PlayingScreenAction.RAISE, esObject);
		}
		
		public function selectOpenCard(userName:String, cardArray:Array):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray(DataFieldXito.OPEN_CARDS, cardArray);
			esObject.setString(DataFieldXito.USER_NAME, userName);
			esObject.setString(DataFieldXito.COMMAND, Command.SELECT_OPEN_CARD);
			sendPublicMessage(Command.SELECT_OPEN_CARD, esObject);
		}
	}

}