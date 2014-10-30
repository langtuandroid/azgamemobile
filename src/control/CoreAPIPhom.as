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
	import event.DataFieldPhom;
	import event.ElectroServerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.EsConfiguration;
	import model.MainData;
	import model.MyData;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CoreAPIPhom extends EventDispatcher 
	{	
		private var electroServer:ElectroServer;
		private var userRecentlyJoinRoom:String;
		
		private var currentUserNumber:int = 0;
		private var timerToGetRoomList:Timer;
		
		public var mainData:MainData = MainData.getInstance();
		public  var myData:MyData;
		
		public function CoreAPIPhom(config:EsConfiguration) 
		{
			_configuration = config;
		}
		
		// Bước 1 - kết nối với server electro
		public function createConnection():void
		{
			myData = new MyData();
			
			myData.gameType = "PhomPlugin";
			myData.lobbyName = "Phom";
			myData.lobbyPluginName = "LobbyHandle";
			
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
			//WindowLayer.getInstance().openAlertWindow(String(configuration.ip) + "," + String(configuration.port) + "," + configuration.protocol.name);
			server.addAvailableConnection(availConn);
			
			electroServer.engine.addServer(server);
			electroServer.engine.connect();
			
			electroServer.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionEvent);
			//electroServer.engine.createConnection(configuration.ip, configuration.port);
		}
		
		public function onConnectionEvent(e:ConnectionResponse):void
		{
			trace("onConnectionEvent",(new Date().getTime()));
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
					invitePlayObject[DataFieldPhom.DISPLAY_NAME] = e.esObject.getString(DataFieldPhom.DISPLAY_NAME);
					invitePlayObject[DataFieldPhom.USER_NAME] = e.userName;
					invitePlayObject[DataFieldPhom.ROOM_ID] = e.esObject.getInteger(DataFieldPhom.ROOM_ID);
					invitePlayObject[DataFieldPhom.GAME_ID] = e.esObject.getInteger(DataFieldPhom.GAME_ID);
					invitePlayObject[DataFieldPhom.ROOM_PASSWORD] = e.esObject.getString(DataFieldPhom.ROOM_PASSWORD);
					invitePlayObject[DataFieldPhom.MESSAGE] = e.esObject.getString(DataFieldPhom.MESSAGE);
					invitePlayObject[DataFieldPhom.ROOM_BET] = e.esObject.getString(DataFieldPhom.ROOM_BET);
					invitePlayObject[DataFieldPhom.AVATAR] = e.esObject.getString(DataFieldPhom.AVATAR);
					invitePlayObject[DataFieldPhom.MONEY] = e.esObject.getString(DataFieldPhom.MONEY);
					invitePlayObject[DataFieldPhom.SEX] = e.esObject.getString(DataFieldPhom.SEX);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_INVITE_PLAY,invitePlayObject));
				break;
				case Command.INVITE_ADD_FRIEND: // Lời mời kết bạn
					var inviteAddFriendObject:Object = new Object();
					inviteAddFriendObject[DataFieldPhom.DISPLAY_NAME] = e.esObject.getString(DataFieldPhom.DISPLAY_NAME);
					inviteAddFriendObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					inviteAddFriendObject[DataFieldPhom.MESSAGE] = e.esObject.getString(DataFieldPhom.MESSAGE);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.INVITE_ADD_FRIEND, inviteAddFriendObject));
				break;
				case Command.CONFIRM_ADD_FRIEND_INVITE: // Người khác trả lời yêu cầu kết bạn của mình
					var confirmAddFriendInviteObject:Object = new Object();
					confirmAddFriendInviteObject[DataFieldPhom.DISPLAY_NAME] = e.esObject.getString(DataFieldPhom.DISPLAY_NAME);
					confirmAddFriendInviteObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					confirmAddFriendInviteObject[DataFieldPhom.MESSAGE] = e.esObject.getString(DataFieldPhom.MESSAGE);
					confirmAddFriendInviteObject[DataFieldPhom.CONFIRM] = e.esObject.getBoolean(DataFieldPhom.CONFIRM);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.FRIEND_CONFIRM_ADD_FRIEND_INVITE, confirmAddFriendInviteObject));
				break;
				case Command.REMOVE_FRIEND: // Người khác xóa mình khỏi danh sách friend
					var removeFriendObject:Object = new Object();
					removeFriendObject[DataFieldPhom.DISPLAY_NAME] = e.esObject.getString(DataFieldPhom.DISPLAY_NAME);
					removeFriendObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					removeFriendObject[DataFieldPhom.MESSAGE] = e.esObject.getString(DataFieldPhom.MESSAGE);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.REMOVE_FRIEND, removeFriendObject));
				break;
				case Command.REQUEST_TIME_CLOCK: // Người khác request time clock
					var requestTimeClockObject:Object = new Object();
					requestTimeClockObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(Command.REQUEST_TIME_CLOCK, requestTimeClockObject));
				break;
				case Command.RESPOND_TIME_CLOCK: // Người khác respond time clock
					var respondTimeClockObject:Object = new Object();
					respondTimeClockObject[DataFieldPhom.TIME_CLOCK] = e.esObject.getString(DataFieldPhom.TIME_CLOCK);
					dispatchEvent(new ElectroServerEvent(Command.RESPOND_TIME_CLOCK, respondTimeClockObject));
				break;
				case Command.REQUEST_IS_COMPARE_GROUP: // Người khác hỏi xem có phải đang đọ chi không
					var requestIsCompareGroupObject:Object = new Object();
					requestIsCompareGroupObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(Command.REQUEST_IS_COMPARE_GROUP, requestIsCompareGroupObject));
				break;
				case Command.RESPOND_IS_COMPARE_GROUP: // Người khác trả lời có phải đang đọ chi không
					var respondIsCompareGroupObject:Object = new Object();
					respondIsCompareGroupObject[DataFieldPhom.IS_COMPARE_GROUP] = e.esObject.getBoolean(DataFieldPhom.IS_COMPARE_GROUP);
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
			switch(e.esObject.getString(DataFieldPhom.COMMAND))
			{
				case Command.PUBLIC_CHAT:
					var publicChatObject:Object = new Object();
					publicChatObject[DataFieldPhom.USER_NAME] = e.userName;
					publicChatObject[DataFieldPhom.DISPLAY_NAME] = e.esObject.getString(DataFieldPhom.DISPLAY_NAME);
					publicChatObject[DataFieldPhom.CHAT_CONTENT] = e.esObject.getString(DataFieldPhom.CHAT_CONTENT);
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
					readyObject[DataFieldPhom.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.READY_SUCCESS,readyObject));
				break;
				case Command.START_GAME:
					var startGameObject:Object = new Object();
					startGameObject[DataFieldPhom.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.START_GAME_SUCCESS,startGameObject));
				break;
				case Command.DISCARD:
					var disCardObject:Object = new Object();
					disCardObject[DataFieldPhom.USER_NAME] = e.userName;
					disCardObject[DataFieldPhom.NEXT_TURN] = e.esObject.getString(DataFieldPhom.NEXT_TURN);
					disCardObject[DataFieldPhom.CARD] = e.esObject.getInteger(DataFieldPhom.CARD) + 1;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_DISCARD,disCardObject));
				break;
				case Command.LAYING_CARD:
					var downCardObject:Object = new Object();
					downCardObject[DataFieldPhom.CARDS] = e.esObject.getIntegerArray(DataFieldPhom.CARDS);
					downCardObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					downCardObject[DataFieldPhom.INDEX] = e.esObject.getInteger(DataFieldPhom.INDEX);
					var cardArray:Array = downCardObject[DataFieldPhom.CARDS];
					for (i = 0; i < cardArray.length; i++) 
					{
						cardArray[i]++;
					}
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_DOWN_CARD, downCardObject));
				break;
				case Command.DRAW_CARD:
					var userGetCardObject:Object = new Object();
					userGetCardObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_GET_CARD, userGetCardObject));
				break;
				case Command.SEND_CARD:
					var sendCardObject:Object = new Object();
					sendCardObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					sendCardObject[DataFieldPhom.DESTINATION_USER] = e.esObject.getString(DataFieldPhom.PLAYER_DESTINATION);
					sendCardObject[DataFieldPhom.INDEX] = e.esObject.getInteger(DataFieldPhom.INDEX);
					sendCardObject[DataFieldPhom.CARD] = e.esObject.getIntegerArray(DataFieldPhom.CARD);
					for (i = 0; i < sendCardObject[DataFieldPhom.CARD].length; i++) 
					{
						sendCardObject[DataFieldPhom.CARD][i]++;
					}
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_SEND_CARD, sendCardObject));
				break;
				case Command.LAYING_DONE: // Hạ bài xong
					var downCardFinishObject:Object = new Object();
					downCardFinishObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_DOWN_CARD_FINISH, downCardFinishObject));
				break;
				case Command.SEND_CARD_FINISH: // Gửi bài xong
					var sendCardFinishObject:Object = new Object();
					sendCardFinishObject[DataFieldPhom.USER_NAME] = e.esObject.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_SEND_CARD_FINISH, sendCardFinishObject));
				break;
			}
		}
		
		// sau khi kết nối thành công với server thì login
		public function login(userName:String, password:String = ""): void
		{
			trace("login",(new Date().getTime()));
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
				trace("onLoginResponse",(new Date().getTime()));
				this.dispatchEvent(new ElectroServerEvent(ElectroServerEvent.LOGIN_SUCCESS));
				
				var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
				uuvr.name = DataFieldPhom.OTHER_INFO;
				uuvr.value = new EsObject();
				uuvr.value.setString(DataFieldPhom.SEX, mainData.chooseChannelData.myInfo.sex);
				electroServer.engine.send(uuvr);
		
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
			trace("getRoomList",(new Date().getTime()));
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
					var tempUserList:Array = e.parameters.getEsObjectArray(DataFieldPhom.PLAYER_LIST);
					for (i = 0; i < tempUserList.length; i++) 
					{
						userName = EsObject(tempUserList[i]).getString(DataFieldPhom.USER_NAME);
						object = new Object();
						object[DataFieldPhom.USER_NAME] = EsObject(tempUserList[i]).getString(DataFieldPhom.USER_NAME);
						object[DataFieldPhom.POSITION] = EsObject(tempUserList[i]).getInteger(DataFieldPhom.POSITION);
						object[DataFieldPhom.NUM_CARD] = EsObject(tempUserList[i]).getInteger(DataFieldPhom.NUM_CARD);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.STOLE_CARDS))
						{
							object[DataFieldPhom.STOLE_CARDS] = EsObject(tempUserList[i]).getIntegerArray(DataFieldPhom.STOLE_CARDS);
							var tempArray:Array = object[DataFieldPhom.STOLE_CARDS];
							for (var k:int = 0; k < tempArray.length; k++) 
							{
								tempArray[k]++;
							}
						}
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.DISCARDED_CARDS))
						{
							object[DataFieldPhom.DISCARDED_CARDS] = EsObject(tempUserList[i]).getIntegerArray(DataFieldPhom.DISCARDED_CARDS);
							tempArray = object[DataFieldPhom.DISCARDED_CARDS];
							for (k = 0; k < tempArray.length; k++) 
							{
								tempArray[k]++;
							}
						}
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.LAYING_CARDS))
						{
							tempArray = EsObject(tempUserList[i]).getEsObjectArray(DataFieldPhom.LAYING_CARDS);
							var layingCardArray:Array = new Array();
							if (tempArray)
							{
								for (k = 0; k < tempArray.length; k++) 
								{
									var layingChild:Object = new Object();
									var childArray:Array = EsObject(tempArray[k]).getIntegerArray(DataFieldPhom.LAYING_CARD);
									if (EsObject(tempArray[k]).doesPropertyExist(DataFieldPhom.INDEX))
										var layingIndex:int = EsObject(tempArray[k]).getInteger(DataFieldPhom.INDEX);
									else
										layingIndex = k;
									if (childArray)
									{
										for (var l:int = 0; l < childArray.length; l++) 
										{
											childArray[l]++;
										}
									}
									//layingCardArray[k] = childArray;
									layingChild[DataFieldPhom.CARDS] = childArray;
									layingChild[DataFieldPhom.INDEX] = layingIndex;
									layingCardArray[k] = layingChild;
								}
							}
							object[DataFieldPhom.LAYING_CARDS] = layingCardArray;
						}
						object[DataFieldPhom.READY] = false;
						object[DataFieldPhom.IS_CURRENT_WINNER] = false;
						object[DataFieldPhom.IS_VIEWER] = false;
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.READY))
							object[DataFieldPhom.READY] = EsObject(tempUserList[i]).getBoolean(DataFieldPhom.READY);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.IS_CURRENT_WINNER))
							object[DataFieldPhom.IS_CURRENT_WINNER] = EsObject(tempUserList[i]).getBoolean(DataFieldPhom.IS_CURRENT_WINNER);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataFieldPhom.IS_VIEWER))
							object[DataFieldPhom.IS_VIEWER] = EsObject(tempUserList[i]).getBoolean(DataFieldPhom.IS_VIEWER);
						object[DataFieldPhom.WINNER_INDEX] = e.parameters.getInteger(DataFieldPhom.WINNER_INDEX);
						
						var user:User = electroServer.managerHelper.userManager.userByName(userName);
						
						object[DataFieldPhom.DEVICE_ID] = 'none';
						if (user.userVariableByName(DataFieldPhom.USER_INFO).value.doesPropertyExist(DataFieldPhom.DEVICE_ID))
							object[DataFieldPhom.DEVICE_ID] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.DEVICE_ID);
							
						object[DataFieldPhom.LEVEL] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.LEVEL);
						object[DataFieldPhom.MONEY] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.MONEY);
						object[DataFieldPhom.AVATAR] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.AVATAR);
						object[DataFieldPhom.DISPLAY_NAME] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.DISPLAY_NAME);
						object[DataFieldPhom.IP] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.IP);
						object[DataFieldPhom.WIN] = user.userVariableByName(DataFieldMauBinh.USER_INFO).value.getInteger(DataFieldPhom.WIN);
						object[DataFieldPhom.LOSE] = user.userVariableByName(DataFieldMauBinh.USER_INFO).value.getInteger(DataFieldPhom.LOSE);
						if (user.userVariableByName(DataFieldPhom.USER_INFO).value.doesPropertyExist(DataFieldPhom.SEX))
						{
							object[DataFieldPhom.SEX] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.SEX);
						}
						else
						{
							if (user.userVariableByName(DataFieldPhom.OTHER_INFO))
							{
								var tempEsObject:EsObject = user.userVariableByName(DataFieldPhom.OTHER_INFO).value;
								object[DataFieldPhom.SEX] = tempEsObject.getString(DataFieldPhom.SEX);
							}
						}
						if (user.userVariableByName(DataFieldPhom.USER_INFO).value.doesPropertyExist(DataFieldPhom.LOGO))
							object[DataFieldPhom.LOGO] = user.userVariableByName(DataFieldPhom.USER_INFO).value.getString(DataFieldPhom.LOGO);
						userList.push(object);
					}
					
					myData.gameRoomInfo[DataFieldPhom.USER_LIST] = userList;
					myData.gameRoomInfo[DataFieldPhom.GAME_STATE] = e.parameters.getString(DataFieldPhom.GAME_STATE);
					myData.gameRoomInfo[DataFieldPhom.ROOM_MASTER] = e.parameters.getString(DataFieldPhom.ROOM_MASTER);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.JOIN_GAME_ROOM_SUCCESS, myData.gameRoomInfo));
				break;
				case Command.READY: // trả về thông báo click ready thành công
					var readyObject:Object = new Object();
					readyObject[DataFieldPhom.USER_NAME] = e.parameters.getString(DataFieldPhom.USER_NAME);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.READY_SUCCESS,readyObject));
				break;
				case Command.DEAL_CARD: // thông báo chia bài của server
					var dealCardObject:Object = new Object();
					if (e.parameters.doesPropertyExist(DataFieldPhom.PLAYER_CARDS))
					{
						dealCardObject[DataFieldPhom.PLAYER_CARDS] = e.parameters.getIntegerArray(DataFieldPhom.PLAYER_CARDS);
						var cardArray:Array = dealCardObject[DataFieldPhom.PLAYER_CARDS];
						for (i = 0; i < cardArray.length; i++) 
						{
							cardArray[i]++;
						}
					}
					dealCardObject[DataFieldPhom.IS_CURRENT_WINNER] = e.parameters.getBoolean(DataFieldPhom.IS_CURRENT_WINNER);
					dealCardObject[DataFieldPhom.WINNER_INDEX] = e.parameters.getInteger(DataFieldPhom.WINNER_INDEX);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.DEAL_CARD,dealCardObject));
				break;
				case Command.CARD_RESPONSE: // trả về riêng cho người bốc bài lá bài vừa bốc
					var getCardObject:Object = new Object();
					getCardObject[DataFieldPhom.CARD] = e.parameters.getInteger(DataFieldPhom.CARD) + 1;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.GET_CARD_SUCCESS,getCardObject));
				break;
				case Command.STEAL_CARD: // kết quả trả về của hành động ăn bài
					var stealCardObject:Object = new Object();
					stealCardObject[DataFieldPhom.CARD] = e.parameters.getInteger(DataFieldPhom.CARD) + 1;
					stealCardObject[DataFieldPhom.USER_NAME] = e.parameters.getString(DataFieldPhom.USER_NAME);
					stealCardObject[DataFieldPhom.MONEY_AFTER_REBET] = Number(e.parameters.getString(DataFieldPhom.MONEY_AFTER_REBET));
					stealCardObject[DataFieldPhom.MONEY_BEFORE_REBET] = Number(e.parameters.getString(DataFieldPhom.MONEY_BEFORE_REBET));
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.STEAL_CARD,stealCardObject));
				break;
				case Command.GAME_OVER: // Ván chơi kết thúc
					var gameOverObject:Object = new Object();
					var esObjec_PlayerList:Array = e.parameters.getEsObjectArray(DataFieldPhom.PLAYER_LIST);
					var playerList:Array = new Array();
					for (i = 0; i < esObjec_PlayerList.length; i++) 
					{
						var tempObject:Object = new Object();
						tempObject[DataFieldPhom.USER_NAME] = EsObject(esObjec_PlayerList[i]).getString(DataFieldPhom.USER_NAME);
						tempObject[DataFieldPhom.PLAYER_CARDS] = EsObject(esObjec_PlayerList[i]).getIntegerArray(DataFieldPhom.PLAYER_CARDS);
						tempObject[DataFieldPhom.POINT] = EsObject(esObjec_PlayerList[i]).getInteger(DataFieldPhom.POINT);
						tempObject[DataFieldPhom.RESULT_POSITION] = EsObject(esObjec_PlayerList[i]).getInteger(DataFieldPhom.RESULT_POSITION);
						tempObject[DataFieldPhom.MONEY] = Number(EsObject(esObjec_PlayerList[i]).getString(DataFieldPhom.MONEY));
						tempObject[DataFieldPhom.DISPLAY_NAME] = EsObject(esObjec_PlayerList[i]).getString(DataFieldPhom.DISPLAY_NAME);
						cardArray = tempObject[DataFieldPhom.PLAYER_CARDS] as Array;
						for (j = 0; j < cardArray.length; j++)
						{
							cardArray[j]++;
						}
						playerList.push(tempObject);
					}
					gameOverObject[DataFieldPhom.PLAYER_LIST] = playerList;
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.GAME_OVER, gameOverObject));
				break;
				case Command.UPDATE_ROOM_MASTER: // kết quả trả về của hành động ăn bài
					var roomMasterObject:Object = new Object();
					roomMasterObject[DataFieldPhom.ROOM_MASTER] = e.parameters.getString(DataFieldPhom.ROOM_MASTER);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_MASTER, roomMasterObject));
				break;
				case Command.ADD_FRIEND: // Server confirm là lời mời kết bạn đã hợp lệ
					var isSuccess:Boolean = e.parameters.getBoolean("success");
					if (isSuccess)
					{
						var addFriendObject:Object = new Object();
						addFriendObject[DataFieldPhom.FRIEND_ID] = e.parameters.getString(DataFieldPhom.FRIEND_ID);
						dispatchEvent(new ElectroServerEvent(ElectroServerEvent.SEND_ADD_FRIEND_SUCCESS, addFriendObject));
					}
				break; 
				case Command.CONFIRM_FRIEND_REQUEST: // Xác nhận với server đồng ý hay từ chối lời mời kết bạn
					isSuccess = e.parameters.getBoolean("success");
					var confirmFriendRequestObject:Object = new Object();
					confirmFriendRequestObject[DataFieldPhom.FRIEND_ID] = e.parameters.getString(DataFieldPhom.FRIEND_ID);
					confirmFriendRequestObject[DataFieldPhom.CONFIRM] = e.parameters.getBoolean(DataFieldPhom.CONFIRM);
					if (confirmFriendRequestObject[DataFieldPhom.CONFIRM])
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
					var friendList:Array = e.parameters.getEsObjectArray(DataFieldPhom.FRIEND_LIST);
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
						userData.displayName = EsObject(friendList[i]).getString(DataFieldPhom.DISPLAY_NAME);
						userData.levelName = EsObject(friendList[i]).getString(DataFieldPhom.LEVEL);
						userData.userID = EsObject(friendList[i]).getString(DataFieldPhom.USER_NAME);
						userData.userName = EsObject(friendList[i]).getString(DataFieldPhom.USER_NAME);
						userData.isOnline = EsObject(friendList[i]).getBoolean(DataFieldPhom.ONLINE);
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
								default:
							}
						}
						
						if (!EsObject(friendList[i]).doesPropertyExist(DataFieldPhom.LOSE))
							userData.lose = 0;
						else
							userData.lose = EsObject(friendList[i]).getInteger(DataFieldPhom.LOSE);
						if (!EsObject(friendList[i]).doesPropertyExist(DataFieldPhom.WIN))
							userData.win = 0;
						else
							userData.win = EsObject(friendList[i]).getInteger(DataFieldPhom.WIN);
							
						userData.money = EsObject(friendList[i]).getString(DataFieldPhom.MONEY);
						
						userData.avatar = EsObject(friendList[i]).getString(DataFieldPhom.AVATAR);
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
					addMoneyObject[DataFieldPhom.SUCCESS] = e.parameters.getBoolean(DataFieldPhom.ADD_MONEY);
					addMoneyObject[DataFieldPhom.NUMBER] = e.parameters.getInteger(DataFieldPhom.NUMBER);
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.ADD_MONEY, addMoneyObject));
				break;
				case Command.GET_ROOM_LIST: // update roomList và userList
					var roomList:Array = e.parameters.getEsObjectArray(DataFieldPhom.ROOM_LIST);
					myData.roomList = new Object();
					myData.userList = new Object();
					for (i = 0; i < roomList.length; i++) 
					{
						var gameDetails:EsObject = EsObject(roomList[i]).getEsObject(DataFieldPhom.GAME_DETAILS);
						var roomId:int = EsObject(roomList[i]).getInteger(DataFieldPhom.ROOM_ID);
						myData.roomList[roomId] = new Object();
						myData.roomList[roomId][DataFieldPhom.IS_SEND_CARD] = gameDetails.getBoolean(DataFieldPhom.IS_SEND_CARD);
						myData.roomList[roomId][DataFieldPhom.ROOM_BET] = gameDetails.getString(DataFieldPhom.ROOM_BET);
						myData.roomList[roomId][DataFieldPhom.ROOM_NAME] = gameDetails.getString(DataFieldPhom.ROOM_NAME);
						myData.roomList[roomId][DataFieldPhom.GAME_ID] = EsObject(roomList[i]).getInteger(DataFieldPhom.GAME_ID);
						myData.roomList[roomId][DataFieldPhom.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataFieldPhom.HAS_PASSWORD);
						myData.roomList[roomId][DataFieldPhom.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataFieldPhom.USER_LIST).length;
						myData.roomList[roomId][DataFieldPhom.MALE] = 0;
						myData.roomList[roomId][DataFieldPhom.MAX_PLAYER] = gameDetails.getInteger(DataFieldPhom.MAX_PLAYER);
						userList = EsObject(roomList[i]).getEsObjectArray(DataFieldPhom.USER_LIST);
						for (j = 0; j < userList.length; j++) 
						{
							userName = EsObject(userList[j]).getString(DataFieldPhom.USER_NAME);
							myData.userList[userName] = new Object();
							object = convertEsObject(EsObject(userList[j]).getEsObject(DataFieldPhom.USER_INFO));
							if (object[DataFieldPhom.SEX] == 'M')
								myData.roomList[roomId][DataFieldPhom.MALE]++;
							myData.userList[userName][DataFieldPhom.USER_INFO] = object;
							myData.userList[userName][DataFieldPhom.ROOM_ID] = roomId;
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
						object = convertEsObject(UserVariable(User(userListInLobby[i]).userVariableByName(DataFieldPhom.USER_INFO)).value);
						if (User(userListInLobby[i]).userVariableByName(DataFieldPhom.OTHER_INFO))
						{
							if (User(userListInLobby[i]).userVariableByName(DataFieldPhom.OTHER_INFO))
							{
								tempEsObject = User(userListInLobby[i]).userVariableByName(DataFieldPhom.OTHER_INFO).value;
								object[DataFieldPhom.SEX] = tempEsObject.getString(DataFieldPhom.SEX);
							}
						}
						myData.userList[userName] = new Object();
						myData.userList[userName][DataFieldPhom.ROOM_ID] = mainData.lobbyRoomId;
						myData.userList[userName][DataFieldPhom.USER_INFO] = object;
						if (!object[DataFieldPhom.LOSE])
							object[DataFieldPhom.LOSE] = 0;
						if (!object[DataFieldPhom.WIN])
							object[DataFieldPhom.WIN] = 0;
					}
					
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST, myData.userList));
					dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_ROOM_LIST, myData.roomList));
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
			message.setString(DataFieldPhom.DISPLAY_NAME, infoObject[DataFieldPhom.DISPLAY_NAME]);
			message.setString(DataFieldPhom.USER_NAME, infoObject[DataFieldPhom.USER_NAME]);
			message.setInteger(DataFieldPhom.ROOM_ID, myData.gameRoomInfo[DataFieldPhom.ROOM_ID]);
			message.setInteger(DataFieldPhom.GAME_ID, myData.gameRoomInfo[DataFieldPhom.GAME_ID]);
			message.setString(DataFieldPhom.ROOM_PASSWORD, infoObject[DataFieldPhom.ROOM_PASSWORD]);
			message.setString(DataFieldPhom.ROOM_BET, infoObject[DataFieldPhom.ROOM_BET]);
			message.setString(DataFieldPhom.MESSAGE, infoObject[DataFieldPhom.MESSAGE]);
			message.setString(DataFieldPhom.MONEY, infoObject[DataFieldPhom.MONEY]);
			message.setString(DataFieldPhom.AVATAR, infoObject[DataFieldPhom.AVATAR]);
			message.setString(DataFieldPhom.SEX, infoObject[DataFieldPhom.SEX]);
			
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
							kickedObject[DataFieldPhom.USER_NAME] = e.userName;
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
			esObject.setString(DataFieldPhom.USER_NAME, userName);
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
			pluginMessage.setString(DataFieldPhom.FRIEND_ID, userName);
			pluginMessage.setString(DataFieldPhom.REQUEST_CONTENT, "aaaa");
			
			if (roomType == DataFieldPhom.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldPhom.IN_GAME_ROOM)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);
		}
		
		public function removeFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.REMOVE_FRIEND);
			pluginMessage.setString(DataFieldPhom.FRIEND_ID, userName);
			
			if (roomType == DataFieldPhom.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldPhom.IN_GAME_ROOM)
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
			esObject.setIntegerArray(DataFieldPhom.CARD_ARRAY_1, arr1);
			esObject.setIntegerArray(DataFieldPhom.CARD_ARRAY_2, arr2);
			esObject.setIntegerArray(DataFieldPhom.CARD_ARRAY_3, arr3);
			esObject.setIntegerArray(DataFieldPhom.CARD_ARRAY_4, arr4);
			sendPublicMessage(Command.START_GAME_1, esObject);
		}
		
		public function confirmInviteAddFriend(userName:String, isAccept:Boolean, roomType:String):void
		{
			// Gửi pluginRequest lên xác nhận đồng ý kết bạn
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", Command.CONFIRM_FRIEND_REQUEST);
			pluginMessage.setString(DataFieldPhom.FRIEND_ID, userName);
			pluginMessage.setBoolean(DataFieldPhom.CONFIRM, isAccept);
			
			if (roomType == DataFieldPhom.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldPhom.IN_GAME_ROOM)
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
					object[DataFieldPhom.USER_NAME] = e.userName;
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
							updateUserVariableRequest.name = DataFieldPhom.USER_INFO;
							var tempEsObject:EsObject = e.variable.value;
							tempEsObject.setString(DataFieldPhom.LOGO, mainData.chooseChannelData.myInfo.logo);
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
									updateUserVariableRequest.name = DataFieldPhom.USER_INFO
									tempEsObject = e.variable.value;
									if (!tempEsObject.doesPropertyExist(DataFieldPhom.LOGO))
									{
										tempEsObject.setString(DataFieldPhom.LOGO, mainData.chooseChannelData.myInfo.logo);
										updateUserVariableRequest.value = tempEsObject;
										//electroServer.engine.send(updateUserVariableRequest);
									}
								}
								
								tempEsObject = e.variable.value
								var updateMoneyObject:Object = new Object();
								updateMoneyObject[DataFieldPhom.USER_NAME] = tempEsObject.getString(DataFieldPhom.USER_NAME);
								updateMoneyObject[DataFieldPhom.MONEY] = tempEsObject.getString(DataFieldPhom.MONEY);
								dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_MONEY, updateMoneyObject));
							}
						}
						else
						{
							tempEsObject = e.variable.value
							updateMoneyObject = new Object();
							updateMoneyObject[DataFieldPhom.USER_NAME] = tempEsObject.getString(DataFieldPhom.USER_NAME);
							updateMoneyObject[DataFieldPhom.MONEY] = tempEsObject.getString(DataFieldPhom.MONEY);
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
			var roomList:Array = e.value.getEsObjectArray(DataFieldPhom.ROOM_LIST);
			myData.roomList = new Object();
			myData.userList = new Object();
			for (var i:int = 0; i < roomList.length; i++) 
			{
				var gameDetails:EsObject = EsObject(roomList[i]).getEsObject(DataFieldPhom.GAME_DETAILS);
				var roomId:int = EsObject(roomList[i]).getInteger(DataFieldPhom.ROOM_ID);
				myData.roomList[roomId] = new Object();
				myData.roomList[roomId][DataFieldPhom.ROOM_BET] = gameDetails.getString(DataFieldPhom.ROOM_BET);
				myData.roomList[roomId][DataFieldPhom.ROOM_NAME] = gameDetails.getString(DataFieldPhom.ROOM_NAME);
				myData.roomList[roomId][DataFieldPhom.GAME_ID] = EsObject(roomList[i]).getInteger(DataFieldPhom.GAME_ID);
				myData.roomList[roomId][DataFieldPhom.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataFieldPhom.HAS_PASSWORD);
				myData.roomList[roomId][DataFieldPhom.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataFieldPhom.USER_LIST).length;
				var userList:Array = EsObject(roomList[i]).getEsObjectArray(DataFieldPhom.USER_LIST);
				for (var j:int = 0; j < userList.length; j++) 
				{
					var userName:String = EsObject(userList[j]).getString(DataFieldPhom.USER_NAME);
					myData.userList[userName] = new Object();
					var object:Object = convertEsObject(EsObject(userList[j]).getEsObject(DataFieldPhom.USER_INFO));
					myData.userList[userName][DataFieldPhom.USER_INFO] = object;
					myData.userList[userName][DataFieldPhom.ROOM_ID] = roomId;
				}
			}
			
			var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(myData.zoneId);
			var room:Room = zone.roomById(myData.lobbyRoomId);
			var userListInLobby:Array = room.users;
			for (i = 0; i < userListInLobby.length; i++) 
			{
				userName = User(userListInLobby[i]).userName;
				object = convertEsObject(UserVariable(User(userListInLobby[i]).userVariableByName(DataFieldPhom.USER_INFO)).value);
				myData.userList[userName] = new Object();
				myData.userList[userName][DataFieldPhom.ROOM_ID] = 0;
				myData.userList[userName][DataFieldPhom.USER_INFO] = object;
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
				roomId = ServerGame(gameList[i]).gameDetails.getInteger(DataFieldPhom.ROOM_ID);
				if (electroServer.managerHelper.zoneManager.zoneById(myData.zoneId).roomById(roomId))
				{
					myData.roomList[roomId] = new Object();
					myData.roomList[roomId][DataFieldPhom.GAME_ID] = ServerGame(gameList[i]).id;
					myData.roomList[roomId][DataFieldPhom.HAS_PASSWORD] = ServerGame(gameList[i]).passwordProtected;
					myData.roomList[roomId][DataFieldPhom.ROOM_NAME] = ServerGame(gameList[i]).gameDetails.getString(DataFieldPhom.ROOM_NAME);
					myData.roomList[roomId][DataFieldPhom.ROOM_BET] = ServerGame(gameList[i]).gameDetails.getString(DataFieldPhom.ROOM_BET);
					if (ServerGame(gameList[i]).gameDetails.doesPropertyExist(DataFieldPhom.IS_SEND_CARD))
						myData.roomList[roomId][DataFieldPhom.IS_SEND_CARD] = ServerGame(gameList[i]).gameDetails.getBoolean(DataFieldPhom.IS_SEND_CARD);
					getUserInRoom(roomId);
				}
			}
		}
		
		public function createGameRoom(gameOption:Object, password:String):void
		{
			leaveRoom();
			var gameDetails:EsObject = new EsObject();
			gameDetails.setString(DataFieldPhom.ROOM_NAME, gameOption[DataFieldPhom.ROOM_NAME]);
			gameDetails.setString(DataFieldPhom.ROOM_BET, gameOption[DataFieldPhom.ROOM_BET]);
			gameDetails.setBoolean(DataFieldPhom.IS_SEND_CARD, gameOption[DataFieldPhom.IS_SEND_CARD]);
			gameDetails.setInteger(DataFieldPhom.MAX_PLAYER, gameOption[DataFieldPhom.MAX_PLAYER]);
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
		
		public function findGameRoom(roomId:int, password:String):void
		{
			if (!myData.roomList[roomId])
			{
				dispatchEvent(new ElectroServerEvent(ElectroServerEvent.GAME_ROOM_INVALID));
			}
			else
			{
				leaveRoom();
				var joinGameRequest:JoinGameRequest = new JoinGameRequest();
				joinGameRequest.gameId = myData.roomList[roomId][DataFieldPhom.GAME_ID];
				joinGameRequest.password = password;
				electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
				electroServer.engine.send(joinGameRequest);
			}
		}
		
		public function quickJoinGameRoom(defaultBet:String):void
		{
			leaveRoom();
			var quickJoinGameRequest:QuickJoinGameRequest = new QuickJoinGameRequest();
			quickJoinGameRequest.zoneName = mainData.game_id + "_" + String(myData.channelId);
			quickJoinGameRequest.gameType = myData.gameType;
			var searchCriteria:SearchCriteria = new SearchCriteria();
			searchCriteria.gameType = myData.gameType;
			quickJoinGameRequest.criteria = searchCriteria;
			var gameDetails:EsObject = new EsObject();
			gameDetails.setString(DataFieldPhom.ROOM_NAME, "Vào làm một ván nào");
			gameDetails.setString(DataFieldPhom.ROOM_BET, defaultBet);
			gameDetails.setBoolean(DataFieldPhom.IS_SEND_CARD, true);
			quickJoinGameRequest.gameDetails = gameDetails;
			electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			electroServer.engine.send(quickJoinGameRequest);
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
				myData.gameRoomInfo[DataFieldPhom.ROOM_ID] = myData.roomId;
				myData.gameRoomInfo[DataFieldPhom.ROOM_BET] = e.gameDetails.getString(DataFieldPhom.ROOM_BET);
				myData.gameRoomInfo[DataFieldPhom.ROOM_NAME] = e.gameDetails.getString(DataFieldPhom.ROOM_NAME);
				myData.gameRoomInfo[DataFieldPhom.IS_SEND_CARD] = e.gameDetails.getBoolean(DataFieldPhom.IS_SEND_CARD);
				myData.gameRoomInfo[DataFieldPhom.GAME_ID] = e.gameId;
				
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
			esObject.setString(DataFieldPhom.DISPLAY_NAME, displayName);
			esObject.setString(DataFieldPhom.CHAT_CONTENT, chatContent);
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
			esObject.setIntegerArray(DataFieldPhom.CARDS, cardInfo);
			esObject.setBoolean(DataFieldPhom.IS_SORT, isSort);
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
			esObject.setInteger(DataFieldPhom.CARD, cardId - 1);
			esObject.setString(DataFieldPhom.NEXT_TURN, nextTurn);
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
			esObject.setString(DataFieldPhom.COMMAND, command);
			publicMessageRequest.esObject = esObject;
			electroServer.engine.send(publicMessageRequest);
		}
		
		// Gửi pluginRequest lên thông báo người chơi đã sẵn sàng chơi
		public function getOneCard(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.USER_NAME, userName);
			sendPublicMessage(Command.DRAW_CARD, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi vừa ăn một con bài
		public function stealCard(userName:String, cardId:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setInteger(DataFieldPhom.CARD, cardId - 1);
			esObject.setString(DataFieldPhom.USER_NAME, userName);
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
			esObject.setIntegerArray(DataFieldPhom.CARDS, cardArray);
			esObject.setString(DataFieldPhom.USER_NAME, userName);
			sendPublicMessage(Command.LAYING_CARD, esObject);
		}
		
		// thông báo hạ xong
		public function downCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.USER_NAME, userName);
			sendPublicMessage(Command.LAYING_DONE, esObject);
		}
		
		// thông báo gửi xong
		public function sendCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.USER_NAME, userName);
			sendPublicMessage(Command.SEND_CARD_FINISH, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi gửi bài
		public function sendCard(userName:String, destinationUser:String, index:int, cardId:Array):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.USER_NAME, userName);
			esObject.setString(DataFieldPhom.PLAYER_DESTINATION, destinationUser);
			esObject.setInteger(DataFieldPhom.INDEX, index);
			for (var i:int = 0; i < cardId.length; i++) 
			{
				cardId[i]--;
			}
			esObject.setIntegerArray(DataFieldPhom.CARD, cardId);
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
				
			trace("CreateRoomRequest CreateRoomRequest CreateRoomRequest CreateRoomRequest ",Math.random());
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
				myData.userList[userName][DataFieldPhom.ROOM_ID] = e.roomId;
			}
			
			var userList:Array = e.users
			var roomId:String = String(e.roomId);
			
			myData.countGame++;
			if (!myData.roomList[roomId])
				return;
			myData.roomList[roomId][DataFieldPhom.USER_LIST] = new Array();
			for (i = 0; i < userList.length; i++) 
			{
				(myData.roomList[roomId][DataFieldPhom.USER_LIST] as Array).push(UserListEntry(userList[i]).userName);
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
					if (myData.userList[userName][DataFieldPhom.ROOM_ID] != 0)
					{
						if (!myData.saveUserList[userName][DataFieldPhom.USER_INFO])
							getUserInfo(userName);
						else
							myData.userList[userName][DataFieldPhom.USER_INFO] = myData.saveUserList[userName][DataFieldPhom.USER_INFO];
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
			getUserVariableRequest.userVariableNames.add(DataFieldPhom.USER_INFO);
			electroServer.engine.send(getUserVariableRequest);
		}
		
		public function onGetUserInfoResponse(e:GetUserVariablesResponse):void
		{
			var varArr: Array = new Array();
			var i:int;
			var object:Object = convertEsObject(e.userVariables[DataFieldPhom.USER_INFO]);
			
			if (e.userVariables[DataFieldPhom.OTHER_INFO])
			{
				var tempEsObject:EsObject = e.userVariables[DataFieldPhom.OTHER_INFO];
				object[DataFieldPhom.SEX] = tempEsObject.getString(DataFieldPhom.SEX);
			}
			var userName:String = object[DataFieldPhom.USER_NAME];
			
			// trường hợp đang trong phòng game, cần lấy danh sách user trong lobby
			if (myData.roomId != myData.lobbyRoomId)
			{
				if (myData.userListOfLobby)
				{
					userName = object[DataFieldPhom.USER_NAME];
					if (myData.userListOfLobby[userName])
					{
						myData.userListOfLobby[userName][DataFieldPhom.DISPLAY_NAME] = object[DataFieldPhom.DISPLAY_NAME];
						myData.userListOfLobby[userName][DataFieldPhom.MONEY] = object[DataFieldPhom.MONEY];
						myData.userListOfLobby[userName][DataFieldPhom.AVATAR] = object[DataFieldPhom.AVATAR];
						myData.userListOfLobby[userName][DataFieldPhom.LEVEL] = object[DataFieldPhom.LEVEL];
						var isUpdateUserListOfLobby:Boolean = true;
						for (userName in myData.userListOfLobby)
						{
							if (!myData.userListOfLobby[userName][DataFieldPhom.DISPLAY_NAME])
								isUpdateUserListOfLobby = false;
						}
						if(isUpdateUserListOfLobby)
							dispatchEvent(new ElectroServerEvent(ElectroServerEvent.UPDATE_USER_LIST_OF_LOBBY, myData.userListOfLobby));
					}
				}
			}
			
			if (object[DataFieldPhom.USER_NAME] == userRecentlyJoinRoom && myData.roomId != myData.lobbyRoomId) // Tình huống vừa có user join vào phòng game của mình và lấy userVariable của nó
			{
				var userRecentlyJoinRoomObject:Object = new Object();
				userRecentlyJoinRoomObject[DataFieldPhom.USER_NAME] = userRecentlyJoinRoom;
				userRecentlyJoinRoomObject[DataFieldPhom.LEVEL] = object[DataFieldPhom.LEVEL];
				userRecentlyJoinRoomObject[DataFieldPhom.MONEY] = object[DataFieldPhom.MONEY];
				userRecentlyJoinRoomObject[DataFieldPhom.AVATAR] = object[DataFieldPhom.AVATAR];
				userRecentlyJoinRoomObject[DataFieldPhom.IP] = object[DataFieldPhom.IP];
				userRecentlyJoinRoomObject[DataFieldPhom.WIN] = object[DataFieldPhom.WIN];
				userRecentlyJoinRoomObject[DataFieldPhom.LOSE] = object[DataFieldPhom.LOSE];
				if (object[DataFieldPhom.SEX])
					userRecentlyJoinRoomObject[DataFieldPhom.SEX] = object[DataFieldPhom.SEX];
				else
					userRecentlyJoinRoomObject[DataFieldPhom.SEX] = 'M';
				if (object[DataFieldPhom.DEVICE_ID])
					userRecentlyJoinRoomObject[DataFieldPhom.DEVICE_ID] = object[DataFieldPhom.DEVICE_ID];
				else
					userRecentlyJoinRoomObject[DataFieldPhom.DEVICE_ID] = 'none';
				userRecentlyJoinRoomObject[DataFieldPhom.DISPLAY_NAME] = object[DataFieldPhom.DISPLAY_NAME];
				userRecentlyJoinRoomObject[DataFieldPhom.LOGO] = object[DataFieldPhom.LOGO];
				userRecentlyJoinRoom = "";
				dispatchEvent(new ElectroServerEvent(ElectroServerEvent.HAVE_USER_JOIN_ROOM, userRecentlyJoinRoomObject));
			}
			else if (myData.roomId == myData.lobbyRoomId)
			{
				myData.userList[userName][DataFieldPhom.USER_INFO] = object;
				if (!myData.saveUserList[userName])
					myData.saveUserList[userName] = new Object();
				myData.saveUserList[userName][DataFieldPhom.USER_INFO] = object;
				var totalUser:int = 0;
				for (userName in myData.userList)
				{
					totalUser++;
				}
				var countUser:int = 0;
				for (userName in myData.userList)
				{
					if (myData.userList[userName][DataFieldPhom.USER_INFO])
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
	}

}