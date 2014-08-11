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
	import event.CommandTlmn;
	import event.DataField;
	import event.DataFieldMauBinh;
	import model.GameDataTLMN;
	import model.MyDataTLMN;
	
	import event.ElectroServerEventTlmn;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.EsConfiguration;
	import model.MainData;
	import model.MyData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CoreAPITlmn extends EventDispatcher 
	{	
		private var electroServer:ElectroServer;
		private var userRecentlyJoinRoom:String;
		
		private var currentUserNumber:int = 0;
		private var timerToGetRoomList:Timer;
		
		public var mainData:MainData = MainData.getInstance();
		public  var myData:MyData;
		
		public function CoreAPITlmn(config:EsConfiguration) 
		{
			_configuration = config;
		}
		
		// Bước 1 - kết nối với server electro
		public function createConnection():void
		{
			myData = new MyData();
			
			myData.gameType = GameDataTLMN.getInstance().gameType;
			myData.lobbyName = GameDataTLMN.getInstance().lobbyName;
			myData.lobbyPluginName = GameDataTLMN.getInstance().lobbyPluginName;
		
			electroServer = new ElectroServer();
			
			mainData.electroServer = electroServer;
			
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
			
			//electroServer.setProtocol(configuration.protocol);
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
				this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.CONNECT_SUCCESS));
			else
				this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.CONNECT_FAIL));
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
			
			this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.CLOSE_CONNECTION));
		}
		
		public function onPrivateMessageEvent(e:PrivateMessageEvent):void
		{
			switch(e.message)
			{
				case CommandTlmn.PRIVATE_CHAT:
					//trace("private chat");
				break;
				case CommandTlmn.INVITE_PLAY:
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
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HAVE_INVITE_PLAY,invitePlayObject));
				break;
				case CommandTlmn.INVITE_ADD_FRIEND: // Lời mời kết bạn
					var inviteAddFriendObject:Object = new Object();
					inviteAddFriendObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					inviteAddFriendObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					inviteAddFriendObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.INVITE_ADD_FRIEND, inviteAddFriendObject));
				break;
				case CommandTlmn.CONFIRM_ADD_FRIEND_INVITE: // Người khác trả lời yêu cầu kết bạn của mình
					var confirmAddFriendInviteObject:Object = new Object();
					confirmAddFriendInviteObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					confirmAddFriendInviteObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					confirmAddFriendInviteObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					confirmAddFriendInviteObject[DataFieldMauBinh.CONFIRM] = e.esObject.getBoolean(DataFieldMauBinh.CONFIRM);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.FRIEND_CONFIRM_ADD_FRIEND_INVITE, confirmAddFriendInviteObject));
				break;
				case CommandTlmn.REMOVE_FRIEND: // Người khác xóa mình khỏi danh sách friend
					var removeFriendObject:Object = new Object();
					removeFriendObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					removeFriendObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					removeFriendObject[DataFieldMauBinh.MESSAGE] = e.esObject.getString(DataFieldMauBinh.MESSAGE);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.REMOVE_FRIEND, removeFriendObject));
				break;
				case CommandTlmn.REQUEST_TIME_CLOCK: // Người khác request time clock
					var requestTimeClockObject:Object = new Object();
					requestTimeClockObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					dispatchEvent(new ElectroServerEventTlmn(CommandTlmn.REQUEST_TIME_CLOCK, requestTimeClockObject));
				break;
				case CommandTlmn.RESPOND_TIME_CLOCK: // Người khác respond time clock
					var respondTimeClockObject:Object = new Object();
					respondTimeClockObject[DataFieldMauBinh.TIME_CLOCK] = e.esObject.getString(DataFieldMauBinh.TIME_CLOCK);
					dispatchEvent(new ElectroServerEventTlmn(CommandTlmn.RESPOND_TIME_CLOCK, respondTimeClockObject));
				break;
				case CommandTlmn.REQUEST_IS_COMPARE_GROUP: // Người khác hỏi xem có phải đang đọ chi không
					var requestIsCompareGroupObject:Object = new Object();
					requestIsCompareGroupObject[DataFieldMauBinh.USER_NAME] = e.esObject.getString(DataFieldMauBinh.USER_NAME);
					dispatchEvent(new ElectroServerEventTlmn(CommandTlmn.REQUEST_IS_COMPARE_GROUP, requestIsCompareGroupObject));
				break;
				case CommandTlmn.RESPOND_IS_COMPARE_GROUP: // Người khác trả lời có phải đang đọ chi không
					var respondIsCompareGroupObject:Object = new Object();
					respondIsCompareGroupObject[DataFieldMauBinh.IS_COMPARE_GROUP] = e.esObject.getBoolean(DataFieldMauBinh.IS_COMPARE_GROUP);
					dispatchEvent(new ElectroServerEventTlmn(CommandTlmn.RESPOND_IS_COMPARE_GROUP, respondIsCompareGroupObject));
				break;
				case CommandTlmn.COMPARE_GROUP_COMPLETE: // Người khác thông báo là đã đọ chi xong
					var compateGroupCompalteObject:Object = new Object();
					dispatchEvent(new ElectroServerEventTlmn(CommandTlmn.COMPARE_GROUP_COMPLETE, compateGroupCompalteObject));
				break;
			}
		}
		
		public function onPublicMessageEvent(e:PublicMessageEvent):void
		{
			//trace("onPublicMessageEvent");
			var i:int;
			var startGameObject:Object;
			switch(e.esObject.getString(DataFieldMauBinh.COMMAND))
			{
				case CommandTlmn.PUBLIC_CHAT:
					var publicChatObject:Object = new Object();
					publicChatObject[DataFieldMauBinh.USER_NAME] = e.userName;
					publicChatObject[DataFieldMauBinh.DISPLAY_NAME] = e.esObject.getString(DataFieldMauBinh.DISPLAY_NAME);
					publicChatObject[DataFieldMauBinh.CHAT_CONTENT] = e.esObject.getString(DataFieldMauBinh.CHAT_CONTENT);
					if (e.esObject.doesPropertyExist(DataFieldMauBinh.EMO)) 
					{
						publicChatObject[DataFieldMauBinh.EMO] = e.esObject.getBoolean(DataFieldMauBinh.EMO);
					}
					else 
					{
						publicChatObject[DataFieldMauBinh.EMO] = false;
					}
					
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.PUBLIC_CHAT, publicChatObject));
				break;
				case CommandTlmn.READY:
					var readyObject:Object = new Object();
					readyObject[DataField.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.READY_SUCCESS,readyObject));
				break;
				case CommandTlmn.START_GAME:
					startGameObject = new Object();
					startGameObject[DataField.USER_NAME] = e.userName;
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.START_GAME_SUCCESS,startGameObject));
				break;
				case CommandTlmn.START_GAME_1:
					startGameObject = new Object();
					startGameObject[DataField.USER_NAME] = e.userName;
					startGameObject[DataField.MESSAGE] = "testGame";
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.START_GAME_SUCCESS,startGameObject));
				break;
				case CommandTlmn.NEXTTURN://bo luot
						
					trace("co thang bo luot public: ", e.esObject.getString("playerName"))
					var playerNextTurn:String = e.esObject.getString("playerName");
					var objNextturn:Object = new Object();
					objNextturn["user"] = playerNextTurn;
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.NEXTTURN, objNextturn));
				break;
				
				
				case CommandTlmn.WINNER:
					GameDataTLMN.getInstance().currentPlayer = e.esObject.getString("playerName");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GET_CURRENT_PLAYER, GameDataTLMN.getInstance().currentPlayer));
				break;	
				case CommandTlmn.GAME_OVER: // Ván chơi kết thúc
					
					var whiteWinCard:Array = [];
					var whiteWinDes:String;
					
					GameDataTLMN.getInstance().currentPlayer = e.esObject.getString("playerWin");
					var resultArr:Array = new Array;
					
					for each(var data:EsObject in e.esObject.getEsObjectArray("playerList"))
					{
						var gameOverObject:Object = new Object();
						gameOverObject["userName"] = data.getString("userName");
						
						if (data.doesPropertyExist("remaningCard"))
						{
							var arr:Array = [];
							for each(var value:int in data.getIntegerArray("remaningCard"))
							{
								arr.push(value);
							}
							gameOverObject["cards"] = arr;
						}
						
						gameOverObject["money"] = data.getString("money");
						gameOverObject["subMoney"] = data.getString("subMoney");
						gameOverObject["description"] = data.getString("description");
						resultArr.push(gameOverObject);
					}
					
					var resultData:Object = new Object();
					resultData["resultArr"] = resultArr;
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GAME_OVER, resultData));
				break;
				case CommandTlmn.DISCARD:
					var disCardObject:Object = new Object();
					disCardObject[DataField.USER_NAME] = e.esObject.getString("playerName");
					//disCardObject[DataField.NEXT_TURN] = e.esObject.getString(DataField.NEXT_TURN);
					disCardObject[DataField.CARD_VALUES] = e.esObject.getIntegerArray(DataField.CARD_VALUES);
					trace(disCardObject[DataField.USER_NAME], disCardObject[DataField.CARD])
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HAVE_USER_DISCARD, disCardObject));
				break;
				case CommandTlmn.UPDATE_MONEY: // update room
				
					var obj:Object = new Object();
					var plusName:String = e.esObject.getString("plusName");
					var plusMoney:Number = parseFloat(e.esObject.getString("plusMoney"));
					var arrPlus:Array = [plusName, plusMoney];
					var subName:String = e.esObject.getString("subName");
					var subMoney:Number = parseFloat(e.esObject.getString("subMoney"));
					var arrSub:Array = [subName, subMoney];
					obj["plus"] = arrPlus;
					obj["sub"] = arrSub;
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_MONEY_SPECIAL, obj));
				break;
			}
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
				this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.LOGIN_SUCCESS));
				
				/*var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
				uuvr.name = DataFieldMauBinh.OTHER_INFO;
				uuvr.value = new EsObject();
				uuvr.value.setString(DataFieldMauBinh.SEX, mainData.chooseChannelData.myInfo.sex);
				electroServer.engine.send(uuvr);*/
		
			} else {
				this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.LOGIN_FAIL));
			}
		}
		
		// sau khi login thì join lobby
		public function joinLobbyRoom(gameName:String, channelId:int, capacity:int = 200): void
		{
			leaveRoom();
			myData.channelId = channelId;
			GameDataTLMN.getInstance().channelId = channelId;
			var description:String = "Phòng lobby của game: " + gameName + " tại kênh có id là: " + channelId;
			joinRoom(GameDataTLMN.getInstance().gameName, "", description, null, capacity);
		}
		
		// join lobbyRoom thành công
		public function onJoinLobbyRoomEvent(e:JoinRoomEvent):void
		{
			electroServer.engine.removeEventListener(MessageType.JoinRoomEvent.name, onJoinLobbyRoomEvent);
			
			dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.JOIN_LOBBY_ROOM_SUCCESS));
			
			myData.zoneId = e.zoneId;
			myData.roomId = e.roomId;
			myData.saveUserList = new Object();
			
			GameDataTLMN.getInstance().zoneId = e.zoneId;
			GameDataTLMN.getInstance().roomId = e.roomId;
			
			 //Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.GET_FRIEND_LIST);
			sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, 
			GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			
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
			pluginMessage.setString("command", CommandTlmn.GET_FRIEND_LIST);
			sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId,
			GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
		}
		
		public function getRoomList():void
		{
			/*if (GameDataTLMN.getInstance().isNoRenderLobbyList)
				return;*/
				
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.GET_ROOM_LIST);
			sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId,
								GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
				
			/*myData.countGame = 0;
			myData.roomList = new Object();
			var findGame:FindGamesRequest = new FindGamesRequest();
			var search:SearchCriteria = new SearchCriteria();
			search.gameType = zoneigameType;
			search.gameId = -1;
			findGame.searchCriteria = search;
			electroServer.engine.send(findGame);*/
		}
		
		public function onPluginMessageEvent(e:PluginMessageEvent):void 
		{
			var tempArray:Array;
			var readyObject:Object;
			var command:String = e.parameters.getString("command");
			trace("command plugin: ", command, "==============================")
			//trace(e.parameters)
			var i:int;
			var j:int;
			var object:Object;
			var userName:String;
			
			if (e.pluginName == "LobbyPlugin") 
			{
				if (command == "adminSendMessage") 
				{
					var publicChatObject:Object = new Object();
					
					publicChatObject[DataField.USER_NAME] = "Hệ thống";
					publicChatObject[DataField.DISPLAY_NAME] = "Hệ thống";
					publicChatObject[DataField.CHAT_CONTENT] = e.parameters.getString("message");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.PUBLIC_CHAT, publicChatObject));
						
				}
			}
			switch (command) 
			{
				
				case CommandTlmn.CURRENTPLAYER:
					GameDataTLMN.getInstance().currentPlayer = e.parameters.getString("currentTurn");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GET_CURRENT_PLAYER, GameDataTLMN.getInstance().currentPlayer));
				break;
				case ElectroServerEventTlmn.HAVE_UPDATE_MASTER:
					
					GameDataTLMN.getInstance().master = e.parameters.getString("roomMaster");
					obj = new Object();
					obj[ConstTlmn.MASTER] = e.parameters.getString("roomMaster");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_ROOM_MASTER, obj));
				break;
				
				case CommandTlmn.GET_PLAYING_INFO: // lấy thông tin của các người chơi trong phòng chơi
					trace(e.parameters, "+++++++++++++++++++++++++++++++++++++")
					var userList:Array = [];
					
					var tempUserList:Array = e.parameters.getEsObjectArray(DataField.PLAYER_LIST);
					for (i = 0; i < tempUserList.length; i++) 
					{
						userName = EsObject(tempUserList[i]).getString(DataField.USER_NAME);
						
						var user:User = electroServer.managerHelper.userManager.userByName(userName);
						
						object = new Object();
						object[DataField.USER_NAME] = EsObject(tempUserList[i]).getString(DataField.USER_NAME);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataField.NUM_CARD)) 
						{
							object[DataField.NUM_CARD] = EsObject(tempUserList[i]).getInteger(DataField.NUM_CARD);
						}
						trace(user.userVariableByName(DataField.USER_INFO).value.getString(DataField.SEX))
						if (user.userVariableByName(DataField.USER_INFO).value.getString(DataField.SEX) == "M") 
						{
							object[DataField.SEX] = true;
							
						}
						else 
						{
							object[DataField.SEX] = false;
						}
						
						object[DataField.READY] = false;
						if (EsObject(tempUserList[i]).doesPropertyExist(DataField.POSITION))
							object[DataField.POSITION] = EsObject(tempUserList[i]).getInteger(DataField.POSITION);
						object[DataField.IS_CURRENT_WINNER] = false;
						object[DataField.IS_VIEWER] = false;
						if (EsObject(tempUserList[i]).doesPropertyExist(DataField.READY))
							object[DataField.READY] = EsObject(tempUserList[i]).getBoolean(DataField.READY);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataField.IS_CURRENT_WINNER))
							object[DataField.IS_CURRENT_WINNER] = EsObject(tempUserList[i]).getBoolean(DataField.IS_CURRENT_WINNER);
						if (EsObject(tempUserList[i]).doesPropertyExist(DataField.IS_VIEWER))
							object[DataField.IS_VIEWER] = EsObject(tempUserList[i]).getBoolean(DataField.IS_VIEWER);
						//if (EsObject(tempUserList[i]).doesPropertyExist(DataField.LEVEL))
						object[DataField.LEVEL] = user.userVariableByName(DataField.USER_INFO).value.getString(DataField.LEVEL);
						object[DataField.MONEY] = user.userVariableByName(DataField.USER_INFO).value.getString(DataField.MONEY);
						object[DataField.DEVICE_ID] = user.userVariableByName(DataField.USER_INFO).value.getString(DataField.DEVICE_ID);
						//object[DataField.CASH] = myData.userList[userName][DataField.USER_INFO][DataField.CASH];
						object[DataField.IP] = user.userVariableByName(DataField.USER_INFO).value.getString(DataField.IP);
						object[DataField.AVATAR] = user.userVariableByName(DataField.USER_INFO).value.getString(DataField.AVATAR);
						object[DataField.DISPLAY_NAME] = EsObject(tempUserList[i]).getString(DataField.DISPLAY_NAME);
						
						//object[DataField.DEVICE] = myData.userList[userName][DataField.USER_INFO][DataField.DEVICE];
						userList.push(object);
					}
					
					if (!GameDataTLMN.getInstance().gameRoomInfo) 
					{
						GameDataTLMN.getInstance().gameRoomInfo = new Object();
					}
					GameDataTLMN.getInstance().gameRoomInfo[DataField.USER_LIST] = userList;
					GameDataTLMN.getInstance().gameRoomInfo["gameState"] = e.parameters.getString("gameState");
					GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_MASTER] = e.parameters.getString("roomMaster");
					GameDataTLMN.getInstance().master = e.parameters.getString("roomMaster");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.JOIN_GAME_ROOM_SUCCESS, GameDataTLMN.getInstance().gameRoomInfo));
				break;
				
				case CommandTlmn.ENDROUND:
					GameDataTLMN.getInstance().finishRound = true;
					GameDataTLMN.getInstance().firstPlayer = e.parameters.getString("userName");
					//dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.END_ROUND, GameDataTLMN.getInstance().currentPlayer));
				break;
				
				case CommandTlmn.WINNER:
					GameDataTLMN.getInstance().currentPlayer = e.parameters.getString("playerName");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GET_CURRENT_PLAYER, GameDataTLMN.getInstance().currentPlayer));
				break;	
				
				case CommandTlmn.READY: // trả về thông báo click ready thành công
					readyObject = new Object();
					readyObject[DataField.USER_NAME] = e.parameters.getString(DataField.USER_NAME);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.READY_SUCCESS, readyObject));
				break;
				case CommandTlmn.DEAL_CARD: // thông báo chia bài của server
					var dealCardObject:Object = new Object();
					GameDataTLMN.getInstance().currentPlayer = e.parameters.getString("currentTurn");
					GameDataTLMN.getInstance().firstPlayer = e.parameters.getString("currentTurn");
					if (e.parameters.doesPropertyExist(DataField.PLAYER_CARDS))
					{
						dealCardObject[DataField.PLAYER_CARDS] = e.parameters.getIntegerArray(DataField.PLAYER_CARDS);
						var cardArray:Array = dealCardObject[DataField.PLAYER_CARDS];
						
					}
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.DEAL_CARD, dealCardObject));
				break;
				case CommandTlmn.GAME_OVER: // Ván chơi kết thúc
					
					var whiteWinCard:Array = [];
					var whiteWinDes:String;
					
					
					var resultArr:Array = new Array;
					
					for each(var data:EsObject in e.parameters.getEsObjectArray("playerList"))
					{
						var gameOverObject:Object = new Object();
						gameOverObject[ConstTlmn.PLAYER_NAME] = data.getString(ConstTlmn.PLAYER_NAME);
						gameOverObject[ConstTlmn.DISPLAY_NAME] = data.getString(ConstTlmn.DISPLAY_NAME);
						
						if (data.doesPropertyExist(ConstTlmn.CARDS))
						{
							var arr:Array = [];
							for each(var value:int in data.getIntegerArray(ConstTlmn.CARDS))
							{
								arr.push(value);
							}
							gameOverObject[ConstTlmn.CARDS] = arr;
						}
						
						gameOverObject[ConstTlmn.SUB_MONEY] = data.getString(ConstTlmn.MONEY);
						
						gameOverObject["description"] = data.getString("description");
						resultArr.push(gameOverObject);
					}
					
					var resultData:Object = new Object();
					resultData["resultArr"] = resultArr;
					resultData["winner"] = e.parameters.getString("winner");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GAME_OVER, resultData));
				break;
				
				/*case CommandTlmn.UPDATE_ROOM_MASTER: // kết quả trả về của hành động ăn bài
					var roomMasterObject:Object = new Object();
					roomMasterObject[DataField.ROOM_MASTER] = e.parameters.getString(DataField.ROOM_MASTER);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_ROOM_MASTER, roomMasterObject));
				break;*/
				case CommandTlmn.ADD_FRIEND: // Server confirm là lời mời kết bạn đã hợp lệ
					var isSuccess:Boolean = e.parameters.getBoolean("success");
					if (isSuccess)
					{
						var addFriendObject:Object = new Object();
						addFriendObject[DataField.FRIEND_ID] = e.parameters.getString(DataField.FRIEND_ID);
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.SEND_ADD_FRIEND_SUCCESS, addFriendObject));
					}
					getFriendList();
				break; 
				case CommandTlmn.CONFIRM_FRIEND_REQUEST: // Xác nhận với server đồng ý hay từ chối lời mời kết bạn
					isSuccess = e.parameters.getBoolean("success");
					var confirmFriendRequestObject:Object = new Object();
					confirmFriendRequestObject[DataField.FRIEND_ID] = e.parameters.getString(DataField.FRIEND_ID);
					confirmFriendRequestObject[DataField.CONFIRM] = e.parameters.getBoolean(DataField.CONFIRM);
					if (confirmFriendRequestObject[DataField.CONFIRM])
					{
						if(isSuccess)
							dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.CONFIRM_FRIEND_REQUEST, confirmFriendRequestObject));
					}
					else
					{
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.CONFIRM_FRIEND_REQUEST, confirmFriendRequestObject));
					}
				break;
				case CommandTlmn.GET_FRIEND_LIST: // Get danh sách bạn bè
					myData.friendList = new Object();
					GameDataTLMN.getInstance().friendList = new Object();
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
					GameDataTLMN.getInstance().friendList[DataField.FRIEND_LIST] = tempUserList;
					mainData.lobbyRoomData.friendList = tempUserList;
				break;
				case CommandTlmn.REMOVE_FRIEND: // Server confirm remove friend
					trace("aaaaaaaaaaaaaaaaaaaaa");
					getFriendList();
				break;
				/*case CommandTlmn.ADD_CIAO: // add ciao khi hết tiền
					var addCiaoObject:Object = new Object();
					addCiaoObject[DataField.SUCCESS] = e.parameters.getBoolean(DataField.ADD_CIAO);
					addCiaoObject[DataField.NUMBER] = e.parameters.getInteger(DataField.NUMBER);
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.ADD_CIAO, addCiaoObject));
				break;*/
				
				
				case CommandTlmn.WHITE_WIN: // Trường hợp thắng trắng
					
					var resultArr1:Array = new Array;
					
					for each(var data1:EsObject in e.parameters.getEsObjectArray("playerList"))
					{
						var gameOverObject1:Object = new Object();
						gameOverObject1[ConstTlmn.PLAYER_NAME] = data1.getString(ConstTlmn.PLAYER_NAME);
						gameOverObject1[ConstTlmn.DISPLAY_NAME] = data1.getString(ConstTlmn.DISPLAY_NAME);
						
						if (data1.doesPropertyExist(ConstTlmn.CARDS))
						{
							var arrValue:Array = data1.getIntegerArray(ConstTlmn.CARDS);
							
							gameOverObject1[ConstTlmn.CARDS] = arrValue;
						}
						
						//gameOverObject1["money"] = e.parameters.getString("money");
						gameOverObject1[ConstTlmn.MONEY] = data1.getString(ConstTlmn.MONEY);
						gameOverObject1["description"] = data1.getString("description");
						
						resultArr1.push(gameOverObject1);
					}
					
					var resultData1:Object = new Object();
					resultData1[ConstTlmn.PLAYER_LIST] = resultArr1;
					resultData1["whiteWinType"] = e.parameters.getInteger("whiteWinType");
					resultData1["winner"] = e.parameters.getString("winner");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.WHITE_WIN, resultData1));
				break;
				
				case CommandTlmn.READY:
					readyObject = new Object();
					//readyObject[DataField.USER_NAME] = e.userName;
					//dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.READY_SUCCESS,readyObject));
				break;
				
				case CommandTlmn.GETUSER_LOBBY: // update room
						
						var arrUserLobby:Array = e.parameters.getStringArray("userList");
						for (i = 0; i < arrUserLobby.length; i++) 
						{
							var userNameLobby:String = arrUserLobby[i];
							if (!GameDataTLMN.getInstance().userListOfLobby[userNameLobby])
							{
								GameDataTLMN.getInstance().userListOfLobby[userNameLobby] = new Object();
								GameDataTLMN.getInstance().userListOfLobby[userNameLobby][DataField.DISPLAY_NAME] = userNameLobby;
								GameDataTLMN.getInstance().userListOfLobby[userNameLobby][DataField.MONEY] = "";
								GameDataTLMN.getInstance().userListOfLobby[userNameLobby][DataField.CASH] = "";
								GameDataTLMN.getInstance().userListOfLobby[userNameLobby][DataField.AVATAR] = "";
								var isUpdateUserListOfLobby:Boolean = true;
								for (userNameLobby in GameDataTLMN.getInstance().userListOfLobby)
								{
									if (!GameDataTLMN.getInstance().userListOfLobby[userNameLobby][DataField.DISPLAY_NAME])
										isUpdateUserListOfLobby = false;
								}
								if(isUpdateUserListOfLobby)
									dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST_OF_LOBBY, GameDataTLMN.getInstance().userListOfLobby));
							}
						}
						
						//dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST_OF_LOBBY, myData.userListOfLobby));
				break;
				case CommandTlmn.UPDATE_MONEY: // update room
				
					var obj:Object = new Object();
					var plusName:String = e.parameters.getString("plusName");
					var plusMoney:Number = parseFloat(e.parameters.getString("plusMoney"));
					var arrPlus:Array = [plusName, plusMoney];
					var subName:String = e.parameters.getString("subName");
					var subMoney:Number = parseFloat(e.parameters.getString("subMoney"));
					var arrSub:Array = [subName, subMoney];
					obj["plus"] = arrPlus;
					obj["sub"] = arrSub;
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_MONEY_SPECIAL, obj));
				break;
				case "bccGetMoney": //chuyen bai
					var objGetResult:Object = new Object();
					objGetResult["dice1"] = e.parameters.getInteger("dice1");
					objGetResult["dice2"] = e.parameters.getInteger("dice2");
					objGetResult["dice3"] = e.parameters.getInteger("dice3");
					objGetResult["winMoney"] = e.parameters.getInteger("winMoney");
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GET_MONEY, objGetResult));
				break;
				case CommandTlmn.ERROR:
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.ERROR));
				break;
				
				case "getListAvatar": //chuyen bai
					
					/*for each (var esObj:EsObject in e.parameters.getEsObjectArray("list")) 
					{
						var arrAvatar:Array = [];
						arrAvatar["id"] = esObj.getInteger("id");
						arrAvatar["name"] = esObj.getString("name");
						arrAvatar["price"] = esObj.getInteger("price");
						arrAvatar["url"] = esObj.getString("url");
						
						GameDataTLMN.getInstance().arrListAvatar.push(arrAvatar);
					}*/
				break;
				case "getListFrame": //chuyen bai
					
					/*for each (var esObjFrame:EsObject in e.parameters.getEsObjectArray("list")) 
					{
						var arrFrame:Array = [];
						arrFrame["id"] = esObjFrame.getInteger("id");
						arrFrame["name"] = esObjFrame.getString("name");
						arrFrame["price"] = esObjFrame.getInteger("price");
						arrFrame["url"] = esObjFrame.getString("url");
						
						mainData.arrListFrame.push(arrFrame);
					}*/
				break;
				
				case "buyAvatar": //chuyen bai
					//mainData.noticeBuySuccess = "Bạn đã mua nhân vật này thành công";
					
				break;
				
				case "buyFrame": //chuyen bai
					
					//mainData.noticeBuySuccess = "Bạn đã mua khung ảnh thành công";
				break;
				
				case "getMyAvatar": //chuyen bai
						/*var arrMyAvatar:Array = [];
						mainData.arrMyAvatar = [];
						if (mainData.arrMyAvatar.length == 0) 
						{
							if (mainData.mySex) 
							{
								arrMyAvatar["url"] = "http://183.91.14.52/gamebai/public/shop/avatar/default_2.png";
								arrMyAvatar["name"] = "Ho Be";
								arrMyAvatar["id"] = 1;
							}
							else 
							{
								arrMyAvatar["url"] = "http://183.91.14.52/gamebai/public/shop/avatar/default_1.png";
								arrMyAvatar["name"] = "Pê Ka";
								arrMyAvatar["id"] = 2;
							}
							
							
							mainData.arrMyAvatar.push(arrMyAvatar);
						}
						
					
					for each (var esObjMyAvatar:EsObject in e.parameters.getEsObjectArray("list")) 
					{
						arrMyAvatar = [];
						
						arrMyAvatar["url"] = esObjMyAvatar.getString("url");
						if (esObjMyAvatar.doesPropertyExist("name")) 
						{
							arrMyAvatar["name"] = esObjMyAvatar.getString("name");
						}
						if (esObjMyAvatar.doesPropertyExist("id")) 
						{
							arrMyAvatar["id"] = esObjMyAvatar.getInteger("id");
						}
						
						mainData.arrMyAvatar.push(arrMyAvatar);
					}*/
				break;
				case "getMyFrame": //chuyen bai
						/*var arrMyFrame:Array = [];
						mainData.arrMyFrame = [];
						if (mainData.arrMyFrame.length == 0) 
						{
							
							arrMyFrame["url"] = "http://183.91.14.52/gamebai/public/shop/frame/frame_default.png";
							arrMyFrame["name"] = "Khung mặc định";
							arrMyFrame["id"] = 1;
							mainData.arrMyFrame.push(arrMyFrame);
						}
						
					
					for each (var esObjMyFrame:EsObject in e.parameters.getEsObjectArray("list")) 
					{
						arrMyFrame = [];
						
						arrMyFrame["url"] = esObjMyFrame.getString("url");
						if (esObjMyFrame.doesPropertyExist("name")) 
						{
							arrMyFrame["name"] = esObjMyFrame.getString("name");
						}
						if (esObjMyFrame.doesPropertyExist("id")) 
						{
							arrMyFrame["id"] = esObjMyFrame.getInteger("id");
						}
						
						mainData.arrMyFrame.push(arrMyFrame);
					}*/
				break;
				
				case "setAvatar": //chuyen bai
					//mainData.noticeUseSuccess = "Bạn đã sử dụng nhân vật này thành công";
					
				break;
				
				case "setFrame": //chuyen bai
					
					//mainData.noticeUseSuccess = "Bạn đã sử dụng khung ảnh này thành công";
				break;
				case CommandTlmn.GET_ROOM_LIST: // update roomList và userList
					var roomList:Array = e.parameters.getEsObjectArray(DataField.ROOM_LIST);
					GameDataTLMN.getInstance().roomList = new Object();
					GameDataTLMN.getInstance().userList = new Object();
					for (i = 0; i < roomList.length; i++) 
					{
						var gameDetails:EsObject = EsObject(roomList[i]).getEsObject(DataField.GAME_DETAILS);
						var roomId:int = EsObject(roomList[i]).getInteger(DataField.ROOM_ID);
						GameDataTLMN.getInstance().roomList[roomId] = new Object();
						//GameDataTLMN.getInstance().roomList[roomId][DataField.IS_SEND_CARD] = gameDetails.getBoolean(DataField.IS_SEND_CARD);
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.ROOM_BET] = gameDetails.getString(DataFieldMauBinh.ROOM_BET);
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.ROOM_NAME] = gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.GAME_ID] = EsObject(roomList[i]).getInteger(DataFieldMauBinh.GAME_ID);
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataFieldMauBinh.HAS_PASSWORD);
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataFieldMauBinh.USER_LIST).length;
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.MALE] = 0;
						GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.MAX_PLAYER] = gameDetails.getInteger(DataFieldMauBinh.MAX_PLAYER);
						userList = EsObject(roomList[i]).getEsObjectArray(DataField.USER_LIST);
						
					}
					
					trace("GameDataTLMN.getInstance().zoneId", GameDataTLMN.getInstance().zoneId)
					var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(GameDataTLMN.getInstance().zoneId);
					var room:Room = zone.roomById(GameDataTLMN.getInstance().lobbyRoomId);
					var userListInLobby:Array = room.users;
					for (i = 0; i < userListInLobby.length; i++) 
					{
						
						userName = User(userListInLobby[i]).userName;
						object = convertEsObject(UserVariable(User(userListInLobby[i]).userVariableByName(DataFieldMauBinh.USER_INFO)).value);
						if (!object[DataFieldMauBinh.SEX])
							object[DataFieldMauBinh.SEX] = 'M';
						GameDataTLMN.getInstance().userList[userName] = new Object();
						GameDataTLMN.getInstance().userList[userName][DataFieldMauBinh.ROOM_ID] = mainData.lobbyRoomId;
						GameDataTLMN.getInstance().userList[userName][DataFieldMauBinh.USER_INFO] = object;
						if (!object[DataFieldMauBinh.LOSE])
							object[DataFieldMauBinh.LOSE] = 0;
						if (!object[DataFieldMauBinh.WIN])
							object[DataFieldMauBinh.WIN] = 0;
					}
					
					myData.roomList = GameDataTLMN.getInstance().roomList;
					myData.userList = GameDataTLMN.getInstance().userList;
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, GameDataTLMN.getInstance().userList));
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_ROOM_LIST, GameDataTLMN.getInstance().roomList));
				break;
			}
		}
		
		// Gửi lệnh mời chơi
		public function invitePlay(infoObject:Object, invitedNameArray:Array):void
		{
			var invitePlay:PrivateMessageRequest = new PrivateMessageRequest();
			invitePlay.userNames = invitedNameArray;
			invitePlay.message = CommandTlmn.INVITE_PLAY;
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
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(invitePlay);
			}
			
		}
		
		public function sendPrivateMessage(invitedNameArray:Array, command:String, esObject:EsObject):void
		{
			var privateMessageRequest:PrivateMessageRequest = new PrivateMessageRequest();
			privateMessageRequest.userNames = invitedNameArray;
			privateMessageRequest.message = command;
			
			privateMessageRequest.esObject = esObject;
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(privateMessageRequest);
			}
			
		}
		
		public function onLeaveRoomEvent(e:LeaveRoomEvent):void
		{
			
		}
		
		public function onUserEvictedFromRoomEvent(e:UserEvictedFromRoomEvent):void
		{
			var isMe:Boolean = electroServer.managerHelper.userManager.userByName(e.userName).isMe;
			switch (e.reason) 
			{
				case CommandTlmn.ROOM_MASTER_KICK:
					try 
					{
						if (isMe)
						{
							var kickedObject:Object = new Object();
							kickedObject[DataFieldMauBinh.USER_NAME] = e.userName;
							dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.ROOM_MASTER_KICK, kickedObject));
						}
					}
					catch (err:Error)
					{
						
					}
				break;
				case CommandTlmn.TIME_OUT: // Quá thời gian nhưng không đánh bài
					if (isMe)
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.TIME_OUT, null));
				break;
				case CommandTlmn.HACKING: // Đánh một quân bài không tồn tại
					if (isMe)
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HACKING, null));
				break;
			}
		}
		
		public function kickUser(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(CommandTlmn.KICK_USER, esObject);
		}
		
		public function addFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.ADD_FRIEND);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			pluginMessage.setString(DataFieldMauBinh.REQUEST_CONTENT, "aaaa");
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, 
									GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, 
									GameDataTLMN.getInstance().gameType, pluginMessage);
		}
		
		public function removeFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.REMOVE_FRIEND);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, 
									GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, 
									GameDataTLMN.getInstance().gameType, pluginMessage);
		}
		
		public function addMoney():void
		{
			// Gửi pluginRequest lên để request nạp tiền
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.ADD_MONEY);
			sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, 
								GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
		}
		
		public function updateMoney():void
		{
			if (GameDataTLMN.getInstance().roomId == -1)
				return;
			// Gửi pluginRequest lên để request nạp tiền
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.REFRESH_MONEY);
			if (myData.roomId == myData.lobbyRoomId)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, 
				GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			else
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, 
				GameDataTLMN.getInstance().gameType, pluginMessage);
		}
		
		public function orderCard(arr1:Array,arr2:Array,arr3:Array,arr4:Array):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_1, arr1);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_2, arr2);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_3, arr3);
			esObject.setIntegerArray(DataFieldMauBinh.CARD_ARRAY_4, arr4);
			sendPublicMessage(CommandTlmn.START_GAME_1, esObject);
		}
		
		public function confirmInviteAddFriend(userName:String, isAccept:Boolean, roomType:String):void
		{
			// Gửi pluginRequest lên xác nhận đồng ý kết bạn
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.CONFIRM_FRIEND_REQUEST);
			pluginMessage.setString(DataFieldMauBinh.FRIEND_ID, userName);
			pluginMessage.setBoolean(DataFieldMauBinh.CONFIRM, isAccept);
			
			if (roomType == DataFieldMauBinh.IN_LOBBY)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, 
				GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			else if (roomType == DataFieldMauBinh.IN_GAME_ROOM)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId,
				GameDataTLMN.getInstance().gameType, pluginMessage);
		}
		
		// có sự kiện update userList trong phòng
		public function onUserListUpdateEvent(e:UserUpdateEvent):void
		{
			var zoneId:int = e.zoneId;
			var roomId:int = e.roomId;
			var zone:Zone = electroServer.managerHelper.zoneManager.zoneById(zoneId);
			GameDataTLMN.getInstance().zoneId = zoneId;
			myData.zoneId = zoneId;
			GameDataTLMN.getInstance().zoneId = e.zoneId;
			GameDataTLMN.getInstance().roomId = e.roomId;
			
			var i:int;
			
			if (e.action == UserUpdateAction.AddUser) // Tình huống có user vừa join vào room 
			{
				if (e.roomId == GameDataTLMN.getInstance().lobbyRoomId) // join vào lobby
				{
					if (!GameDataTLMN.getInstance().userList[e.userName])
					{
						GameDataTLMN.getInstance().userList[e.userName] = new Object();
						GameDataTLMN.getInstance().userList[e.userName][DataField.ROOM_ID] = GameDataTLMN.getInstance().lobbyRoomId;
						GameDataTLMN.getInstance().userList[e.userName][DataField.USER_NAME] = e.userName;
						getUserInfo(e.userName);
					}
					else
					{
						if (e.userName != MyDataTLMN.getInstance().myName) 
						{
							GameDataTLMN.getInstance().userList[e.userName][DataField.ROOM_ID] = GameDataTLMN.getInstance().lobbyRoomId;
							GameDataTLMN.getInstance().userList[e.userName][DataField.USER_NAME] = e.userName;
						}
						
					}
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, GameDataTLMN.getInstance().userList));
				}
				else // join vào game
				{
					
					var room:Room = zone.roomById(roomId);
					userRecentlyJoinRoom = e.userName;
					var userJoinRoom:EsObject = UserVariable(e.userVariables[0]).value;
					var userRecentlyJoinRoomObject:Object = new Object();
					userRecentlyJoinRoomObject[DataField.USER_NAME] = userRecentlyJoinRoom;
					userRecentlyJoinRoomObject[DataField.LEVEL] = userJoinRoom.getString(DataField.LEVEL);
					userRecentlyJoinRoomObject[DataField.MONEY] = userJoinRoom.getString(DataField.MONEY);
					userRecentlyJoinRoomObject[DataField.DEVICE_ID] = userJoinRoom.getString(DataField.DEVICE_ID);
					userRecentlyJoinRoomObject[DataField.IP] = userJoinRoom.getString(DataField.IP);
					//userRecentlyJoinRoomObject[DataField.IP] = "123.123.123.123";
					//userRecentlyJoinRoomObject[DataField.CASH] = object[DataField.CASH];
					userRecentlyJoinRoomObject[DataField.AVATAR] = userJoinRoom.getString(DataField.AVATAR);
					userRecentlyJoinRoomObject[DataField.DISPLAY_NAME] = userJoinRoom.getString(DataField.DISPLAY_NAME);
					userRecentlyJoinRoomObject[DataField.SEX] = userJoinRoom.getString(DataField.SEX);
					//userRecentlyJoinRoomObject[DataField.LOGO] = object[DataField.LOGO];
					//userRecentlyJoinRoomObject[DataField.DEVICE] = object[DataField.DEVICE];
					
					userRecentlyJoinRoom = "";
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HAVE_USER_JOIN_ROOM, userRecentlyJoinRoomObject));
					
					
				}
			}
			else if (e.action == UserUpdateAction.DeleteUser)  // Có user out
			{
				if (e.roomId == GameDataTLMN.getInstance().lobbyRoomId) // Tình huống có user vừa out ra khỏi lobby room 
				{
					if (GameDataTLMN.getInstance().userList[e.userName] != null) 
					{
						delete GameDataTLMN.getInstance().userList[e.userName];
					}
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, GameDataTLMN.getInstance().userList));
				}
				else // Tình huống có user vừa out ra khỏi game
				{
					var object:Object = new Object();
					object[DataField.USER_NAME] = e.userName;
					
					dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HAVE_USER_OUT_ROOM, object));
				}
			}
			
			
		}
		
		// sự kiện update userVarialbe
		public function onUserVariableUpdateEvent(e:UserVariableUpdateEvent):void
		{
			//trace("onUserVariableUpdateEvent");
			if (e.variable.name == CommandTlmn.USER_INFO)
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
								dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_MONEY, updateMoneyObject));
							}
						}
						else
						{
							tempEsObject = e.variable.value
							updateMoneyObject = new Object();
							updateMoneyObject[DataFieldMauBinh.USER_NAME] = tempEsObject.getString(DataFieldMauBinh.USER_NAME);
							updateMoneyObject[DataFieldMauBinh.MONEY] = tempEsObject.getString(DataFieldMauBinh.MONEY);
							dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_MONEY, updateMoneyObject));
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
			
			dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, myData.userList));
			dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_ROOM_LIST, myData.roomList));*/
		}
		
		// sự kiện updateZone
		public function onZoneUpdateEvent(e:ZoneUpdateEvent):void
		{
			
		}
		
		public function getUserInLobby():void
		{
			myData.userListOfLobby = new Object();
			GameDataTLMN.getInstance().userListOfLobby = new Object();
			getUserInRoom(myData.lobbyRoomId);
		}
		
		public function onFindGameRespond(e:FindGamesResponse):void
		{
			var gameList:Array = e.games;
			var roomId:int;
			for (var i:int = 0; i < gameList.length; i++) 
			{
				roomId = ServerGame(gameList[i]).gameDetails.getInteger(DataFieldMauBinh.ROOM_ID);
				if (electroServer.managerHelper.zoneManager.zoneById(GameDataTLMN.getInstance().zoneId).roomById(roomId))
				{
					myData.roomList[roomId] = new Object();
					myData.roomList[roomId][DataFieldMauBinh.GAME_ID] = ServerGame(gameList[i]).id;
					myData.roomList[roomId][DataFieldMauBinh.HAS_PASSWORD] = ServerGame(gameList[i]).passwordProtected;
					myData.roomList[roomId][DataFieldMauBinh.ROOM_NAME] = ServerGame(gameList[i]).gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
					myData.roomList[roomId][DataFieldMauBinh.ROOM_BET] = ServerGame(gameList[i]).gameDetails.getString(DataFieldMauBinh.ROOM_BET);
					myData.roomList[roomId][DataFieldMauBinh.USERS_NUMBER] = ServerGame(gameList[i]).gameDetails.getString(DataFieldMauBinh.USERS_NUMBER);
					myData.roomList[roomId][DataFieldMauBinh.MALE] = 0;
					myData.roomList[roomId][DataFieldMauBinh.MAX_PLAYER] = ServerGame(gameList[i]).gameDetails.getInteger(DataFieldMauBinh.MAX_PLAYER);
					
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.ROOM_BET] = gameDetails.getString(DataFieldMauBinh.ROOM_BET);
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.ROOM_NAME] = gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.GAME_ID] = EsObject(roomList[i]).getInteger(DataFieldMauBinh.GAME_ID);
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.HAS_PASSWORD] = EsObject(roomList[i]).getBoolean(DataFieldMauBinh.HAS_PASSWORD);
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.USERS_NUMBER] = EsObject(roomList[i]).getEsObjectArray(DataFieldMauBinh.USER_LIST).length;
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.MALE] = 0;
					//GameDataTLMN.getInstance().roomList[roomId][DataFieldMauBinh.MAX_PLAYER] = gameDetails.getInteger(DataFieldMauBinh.MAX_PLAYER);
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
			//gameDetails.setBoolean(DataFieldMauBinh.IS_SEND_CARD, gameOption[DataFieldMauBinh.IS_SEND_CARD]);
			gameDetails.setInteger(DataFieldMauBinh.MAX_PLAYER, gameOption[DataFieldMauBinh.MAX_PLAYER]);
			//var createGameRequest:CreateGameRequest = new CreateGameRequest();
			var createGameRequest:QuickJoinGameRequest = new QuickJoinGameRequest();
			createGameRequest.gameType = myData.gameType;
			createGameRequest.zoneName = mainData.game_id + "_" + myData.channelId;
			createGameRequest.gameDetails = gameDetails;
			createGameRequest.createOnly = true;
			createGameRequest.password = password;
			electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(createGameRequest);
			}
			
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
				dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.GAME_ROOM_INVALID));
			}
			else
			{
				leaveRoom();
				var joinGameRequest:JoinGameRequest = new JoinGameRequest();
				joinGameRequest.gameId = myData.roomList[roomId][DataFieldMauBinh.GAME_ID];
				joinGameRequest.password = password;
				electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
				if (electroServer.engine.connected) 
				{
					electroServer.engine.send(joinGameRequest);
				}
				
			}
		}
		
		public function quickJoinGameRoom(defaultBet:String):void
		{
			leaveRoom();
			var quickJoinGameRequest:QuickJoinGameRequest = new QuickJoinGameRequest();
			quickJoinGameRequest.zoneName = mainData.game_id + "_" + myData.channelId;
			quickJoinGameRequest.gameType = GameDataTLMN.getInstance().gameType;
			var searchCriteria:SearchCriteria = new SearchCriteria();
			searchCriteria.gameType = GameDataTLMN.getInstance().gameType;
			quickJoinGameRequest.criteria = searchCriteria;
			var gameDetails:EsObject = new EsObject();
			gameDetails.setString(DataFieldMauBinh.ROOM_NAME, "Vào làm một ván nào");
			gameDetails.setString(DataFieldMauBinh.ROOM_BET, defaultBet);
			gameDetails.setBoolean(DataFieldMauBinh.IS_SEND_CARD, true);
			quickJoinGameRequest.gameDetails = gameDetails;
			electroServer.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(quickJoinGameRequest);
			}
			
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
				
				myData.roomId = e.roomId;
				GameDataTLMN.getInstance().roomId = e.roomId;
				GameDataTLMN.getInstance().zoneId = e.zoneId;
				var i:int;
				
				myData.gameRoomInfo = new Object();
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_ID] = myData.roomId;
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_BET] = e.gameDetails.getString(DataFieldMauBinh.ROOM_BET);
				myData.gameRoomInfo[DataFieldMauBinh.ROOM_NAME] = e.gameDetails.getString(DataFieldMauBinh.ROOM_NAME);
				//myData.gameRoomInfo[DataFieldMauBinh.IS_SEND_CARD] = e.gameDetails.getBoolean(DataFieldMauBinh.IS_SEND_CARD);
				myData.gameRoomInfo[DataFieldMauBinh.GAME_ID] = e.gameId;
				
				GameDataTLMN.getInstance().gameRoomInfo = new Object();
				GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_ID] = GameDataTLMN.getInstance().roomId;
				GameDataTLMN.getInstance().gameRoomInfo[DataField.ROOM_BET] = e.gameDetails.getString(DataField.ROOM_BET);
				
				GameDataTLMN.getInstance().gameRoomInfo[DataField.GAME_ID] = e.gameId;
				// Gửi pluginRequest lên lấy thông tin các user trong phòng chơi
				var pluginMessage:EsObject = new EsObject();
				pluginMessage.setString("command", CommandTlmn.GET_PLAYING_INFO);
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, 
				GameDataTLMN.getInstance().gameType, pluginMessage);
			}
			else 
			{
				//trace("khong vao dc phong game yeu cau");
				dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.JOIN_GAME_ROOM_FAIL));
			}
		}
		
		public function sendPublicChat(displayName:String, chatContent:String, emo:Boolean):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.DISPLAY_NAME, displayName);
			esObject.setString(DataFieldMauBinh.CHAT_CONTENT, chatContent);
			esObject.setBoolean(DataFieldMauBinh.EMO, emo);
			sendPublicMessage(CommandTlmn.PUBLIC_CHAT, esObject);
		}
		
		// Gửi publicMessage lên thông báo người chơi đã sẵn sàng chơi
		public function readyPlay():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(CommandTlmn.READY, esObject);
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
			sendPublicMessage(CommandTlmn.SORT_FINISH, esObject);
		}
		
		// Gửi publicMessage lên thông báo chủ phòng đã bắt đầu
		public function startGame():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(CommandTlmn.START_GAME, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi đã sẵn sàng chơi
		public function playOneCard(cardId:int, nextTurn:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			esObject.setString(DataFieldMauBinh.NEXT_TURN, nextTurn);
			sendPublicMessage(CommandTlmn.DISCARD, esObject);
		}
		
		private function sendPublicMessage(command:String, esObject:EsObject):void
		{
			if (GameDataTLMN.getInstance().roomId == -1)
				return;
			var publicMessageRequest:PublicMessageRequest = new PublicMessageRequest();
			publicMessageRequest.roomId = GameDataTLMN.getInstance().roomId;
			publicMessageRequest.zoneId = GameDataTLMN.getInstance().zoneId;
			publicMessageRequest.message = "";
			if (!esObject)
				esObject = new EsObject();
			esObject.setString(DataFieldMauBinh.COMMAND, command);
			publicMessageRequest.esObject = esObject;
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(publicMessageRequest);
			}
			
		}
		
		// Gửi pluginRequest lên thông báo người chơi đã sẵn sàng chơi
		public function getOneCard(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(CommandTlmn.DRAW_CARD, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi vừa ăn một con bài
		public function stealCard(userName:String, cardId:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(CommandTlmn.STEAL_CARD, esObject);
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
			sendPublicMessage(CommandTlmn.LAYING_CARD, esObject);
		}
		
		// thông báo hạ xong
		public function downCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(CommandTlmn.LAYING_DONE, esObject);
		}
		
		// thông báo gửi xong
		public function sendCardFinish(userName:String):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			sendPublicMessage(CommandTlmn.SEND_CARD_FINISH, esObject);
		}
		
		// Gửi pluginRequest lên thông báo người chơi gửi bài
		public function sendCard(userName:String, destinationUser:String, index:int, cardId:int):void
		{
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldMauBinh.USER_NAME, userName);
			esObject.setString(DataFieldMauBinh.PLAYER_DESTINATION, destinationUser);
			esObject.setInteger(DataFieldMauBinh.INDEX, index);
			esObject.setInteger(DataFieldMauBinh.CARD, cardId - 1);
			sendPublicMessage(CommandTlmn.SEND_CARD, esObject);
		}
		
		// Gửi thông báo ù lên server
		public function noticeFullDeck():void
		{
			var esObject:EsObject = new EsObject();
			sendPublicMessage(CommandTlmn.FULL_LAYING_CARDS, esObject);
		}
		
		private function sendPluginRequest(_zoneId:int, _roomId:int, pluginName:String, esObject:EsObject = null):void
		{
			if (GameDataTLMN.getInstance().roomId == -1)
				return;
			var pluginRequest:PluginRequest = new PluginRequest();
			pluginRequest.zoneId = _zoneId;
			pluginRequest.roomId = _roomId;
			pluginRequest.pluginName = pluginName;
			pluginRequest.parameters = esObject;
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(pluginRequest);
			}
			
		}
		
		private function joinRoom(roomName: String, roomPassword: String = "", roomDescription: String = "", plugins: Array = null, roomCapacity: int = -1): void
		{
			if (GameDataTLMN.getInstance().channelId != -1)
				leaveRoom();
				
			var createRoomRequest:CreateRoomRequest = new CreateRoomRequest();
			createRoomRequest.zoneName = mainData.game_id + "_" + myData.channelId;
			createRoomRequest.roomName = roomName;
			createRoomRequest.roomDescription = roomDescription;
			createRoomRequest.capacity = roomCapacity;
			createRoomRequest.password = roomPassword;
			
			if (roomName == GameDataTLMN.getInstance().lobbyName)
			{
				createRoomRequest.roomName = "Lobby";
				createRoomRequest.persistent = true; // dù không có người chơi phòng này vẫn tồn tại
			}
			else
			{
				
				createRoomRequest.persistent = false; // không có người chơi thì phòng này không tồn tại
			}
			
			var plugin:PluginListEntry = new PluginListEntry();
			plugin.extensionName = GameDataTLMN.getInstance().lobbyName;
			
			if (roomName == GameDataTLMN.getInstance().lobbyName) // Nếu là phòng chờ thì không cẩm plugins phỏm nên sẽ tạo một array plugins mới
			{
				plugins = new Array();
				plugin.pluginHandle = GameDataTLMN.getInstance().lobbyPluginName;
				plugin.pluginName = GameDataTLMN.getInstance().lobbyPluginName;
				electroServer.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinLobbyRoomEvent);
			}
			
			plugins.push(plugin);
			createRoomRequest.plugins = plugins;
			trace("test")
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(createRoomRequest);
			}
			
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
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(getUsersInRoomRequest);
			}
			
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
						GameDataTLMN.getInstance().userListOfLobby[userName] = new Object();
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
				dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_ROOM_LIST, myData.roomList));
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
			//getUserVariableRequest.userVariableNames.add(DataFieldMauBinh.USER_INFO);
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(getUserVariableRequest);
			}
			
		}
		
		public function onGetUserInfoResponse(e:GetUserVariablesResponse):void
		{
			var varArr: Array = new Array();
			var i:int;
			var userName:String;
			//var object:Object = convertEsObject(e.getUserVariableByName(DataField.USER_INFO).getValue());
			var object:Object = convertEsObject(e.userVariables[DataField.USER_INFO]);
			
			
				// trường hợp đang trong phòng game, cần lấy danh sách user trong lobby
				if (GameDataTLMN.getInstance().roomId != GameDataTLMN.getInstance().lobbyRoomId)
				{
					if (GameDataTLMN.getInstance().userListOfLobby)
					{
						userName = object[DataField.USER_NAME];
						if (GameDataTLMN.getInstance().userListOfLobby[userName])
						{
							GameDataTLMN.getInstance().userListOfLobby[userName][DataField.DISPLAY_NAME] = object[DataField.DISPLAY_NAME];
							GameDataTLMN.getInstance().userListOfLobby[userName][DataField.MONEY] = object[DataField.MONEY];
							GameDataTLMN.getInstance().userListOfLobby[userName][DataField.LEVEL] = object[DataField.LEVEL];
							GameDataTLMN.getInstance().userListOfLobby[userName][DataField.AVATAR] = object[DataField.AVATAR];
							var isUpdateUserListOfLobby:Boolean = true;
							for (userName in GameDataTLMN.getInstance().userListOfLobby)
							{
								if (!GameDataTLMN.getInstance().userListOfLobby[userName][DataField.DISPLAY_NAME])
									isUpdateUserListOfLobby = false;
							}
							if(isUpdateUserListOfLobby)
								dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST_OF_LOBBY, GameDataTLMN.getInstance().userListOfLobby));
						}
					}
				}
				
				if (GameDataTLMN.getInstance().isFirstLoad)
				{
					var totalUser:int = 0;
					for (userName in GameDataTLMN.getInstance().userList)
					{
						totalUser++;
						if (object[DataField.USER_NAME] == userName)
						{
							GameDataTLMN.getInstance().userList[userName][DataField.USER_INFO] = object;
						}
					}
					var countUser:int = 0;
					for (userName in GameDataTLMN.getInstance().userList)
					{
						if (GameDataTLMN.getInstance().userList[userName][DataField.USER_INFO])
							countUser++;
					}
					if (countUser == totalUser) // lấy đầy đủ thông tin user trong lần vào lobby đầu tiên
					{
						GameDataTLMN.getInstance().isFirstLoad = false;
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, GameDataTLMN.getInstance().userList));
						GameDataTLMN.getInstance().isFirstLoadGame = true;
						//findGame(); // sau khi lấy thông tin của các user đầy đủ thì mới lấy thông tin các phòng game
					}
				}
				else
				{
					if (object[DataField.USER_NAME] == userRecentlyJoinRoom) // Tình huống vừa có user join vào phòng game của mình và lấy userVariable của nó
					{
						var userRecentlyJoinRoomObject:Object = new Object();
						userRecentlyJoinRoomObject[DataField.USER_NAME] = userRecentlyJoinRoom;
						userRecentlyJoinRoomObject[DataField.LEVEL] = object[DataField.LEVEL];
						userRecentlyJoinRoomObject[DataField.MONEY] = object[DataField.MONEY];
						//userRecentlyJoinRoomObject[DataField.CASH] = object[DataField.CASH];
						userRecentlyJoinRoomObject[DataField.AVATAR] = object[DataField.AVATAR];
						userRecentlyJoinRoomObject[DataField.DISPLAY_NAME] = object[DataField.DISPLAY_NAME];
						//userRecentlyJoinRoomObject[DataField.LOGO] = object[DataField.LOGO];
						//userRecentlyJoinRoomObject[DataField.DEVICE] = object[DataField.DEVICE];
						userRecentlyJoinRoom = "";
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.HAVE_USER_JOIN_ROOM, userRecentlyJoinRoomObject));
					}
					else
					{
						if (GameDataTLMN.getInstance().roomId != GameDataTLMN.getInstance().lobbyRoomId) // Nếu đang trong phòng chơi thì bỏ qua
							return;
						userName = object[DataField.USER_NAME];
						if (!GameDataTLMN.getInstance().userList[userName])
							return;
						GameDataTLMN.getInstance().userList[userName][DataField.USER_INFO] = object;
						dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.UPDATE_USER_LIST, GameDataTLMN.getInstance().userList));
					}
				}
		}
		
		private function leaveRoom(): void
		{
			if (GameDataTLMN.getInstance().roomId == -1)
				return;
			var leaveRoomRequest:LeaveRoomRequest = new LeaveRoomRequest();
			leaveRoomRequest.zoneId = GameDataTLMN.getInstance().zoneId;
			leaveRoomRequest.roomId = GameDataTLMN.getInstance().roomId;
			myData.roomId = -1;
			if (electroServer.engine.connected) 
			{
				electroServer.engine.send(leaveRoomRequest);
			}
			
			
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
				case CommandTlmn.ROOM_MASTER_KICK: // Bị chủ phòng kích ra 
					//trace("GenericErrorResponse plugin not found");
					this.dispatchEvent(new ElectroServerEventTlmn(ElectroServerEventTlmn.PLUGIN_NOT_FOUND));
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
		
		public function makeFriend(userName:String, roomType:String):void
		{
			// Gửi pluginRequest lên lấy thông tin friendList
			/*var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.ADD_FRIEND);
			pluginMessage.setString(DataField.FRIEND_ID, userName);
			pluginMessage.setString(DataField.REQUEST_CONTENT, "aaaa");
			
			if (roomType == DataField.IN_LOBBY)
				sendPluginRequest(myData.zoneId, myData.lobbyRoomId, myData.lobbyPluginName, pluginMessage);
			else if (roomType == DataField.IN_GAME_ROOM)
				sendPluginRequest(myData.zoneId, myData.roomId, myData.gameType, pluginMessage);*/
			var pluginMessage:EsObject = new EsObject();
			pluginMessage.setString("command", CommandTlmn.ADD_FRIEND);
			pluginMessage.setString(DataField.FRIEND_ID, userName);
			pluginMessage.setString(DataField.REQUEST_CONTENT, "aaaa");
			
			if (roomType == DataField.IN_LOBBY)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().lobbyRoomId, GameDataTLMN.getInstance().lobbyPluginName, pluginMessage);
			else if (roomType == DataField.IN_GAME_ROOM)
				sendPluginRequest(GameDataTLMN.getInstance().zoneId, GameDataTLMN.getInstance().roomId, GameDataTLMN.getInstance().gameType, pluginMessage);
		}
		
		public function myDiscard(arr:Array):void 
		{
			var esObject:EsObject = new EsObject();
			esObject.setIntegerArray("cardValues", arr);
			esObject.setString("playerName", MyDataTLMN.getInstance().myId);
			sendPublicMessage(CommandTlmn.DISCARD, esObject);
		}
		
		public function nextTurn():void //bo luot
		{
			var esObject:EsObject = new EsObject();
			esObject.setString("playerName", MyDataTLMN.getInstance().myId);
			sendPublicMessage(CommandTlmn.NEXTTURN, esObject);
		}
		
		
		public function exitGame(type:String):void 
		{
			leaveRoom();
			if (type == "game") 
			{
				joinRoom(GameDataTLMN.getInstance().gameName, "");
			}
			//
			/*if (timerToFindGameRequest)
			{
				timerToFindGameRequest.removeEventListener(TimerEvent.TIMER, onFindGameList);
				timerToFindGameRequest.stop();
			}
			timerToFindGameRequest = new Timer(2000);
			timerToFindGameRequest.addEventListener(TimerEvent.TIMER, onFindGameList);
			timerToFindGameRequest.start();*/
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
			//electroServer.engine.send(pingRequest);
			sendPublicMessage(CommandTlmn.HEART_BEAT, null);
		}
		
	}

}