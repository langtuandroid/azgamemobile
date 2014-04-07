package control.electroServerCommand 
{
	import com.adobe.serialization.json.JSON;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.Protocol;
	import control.CoreAPITlmn;
	import event.CommandTlmn;
	import event.DataField;
	import event.ElectroServerEvent;
	import event.ElectroServerEventTlmn;
	import flash.events.Event;
	import model.EsConfiguration;
	import model.GameDataTLMN;
	import model.MainData;
	import model.modelField.ModelField;
	import model.MyDataTLMN;
	import model.playingData.PlayingScreenAction;
	import model.playingData.PlayingScreenActionTlmn;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmInvitePlayWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class ElectroServerCommandTlmn 
	{
		private var configuration:EsConfiguration;
		private var ipNumber:String = "";
		private var portNumber:int = 9899;
		public var coreAPI:CoreAPITlmn;
		private var channelId:int;
		private var capacity:int;
		private var myUserName:String;
		private var pass:String;
		private var mainData:MainData = MainData.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function ElectroServerCommandTlmn() 
		{
			
		}
		
		public function startConnect(_userName:String, _channelId:int, _capacity:int = -1, _pass:String = ""):void
		{
			ipNumber = "183.91.14.52";//mainData.init.ipNumber;
			portNumber = 5101;
			channelId = _channelId;
			capacity = _capacity;
			myUserName = _userName;
			pass = _pass;
			
			if(!configuration)
				configuration = new EsConfiguration();
			configuration.ip = ipNumber;
			configuration.port = portNumber;
			configuration.protocol = Protocol.BinaryTCP;
			configuration.path = "serverTlmn.xml";
			if (!coreAPI)
			{
				coreAPI = new CoreAPITlmn(configuration);
				createAddEventForCoreAPI();
			}
			coreAPI.createConnection();
		}
		
		private function createAddEventForCoreAPI():void
		{
			coreAPI.addEventListener(ElectroServerEventTlmn.CLOSE_CONNECTION, onCloseConnection); // Đứt kết nối với server
			
			coreAPI.addEventListener(ElectroServerEventTlmn.CONNECT_SUCCESS, onConnectSuccess); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.CONNECT_FAIL, onConnectFail); // Lắng nghe connect thất bại
			
			coreAPI.addEventListener(ElectroServerEventTlmn.LOGIN_SUCCESS, onLoginSuccess); // Lắng nghe login thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.LOGIN_FAIL, onLoginFail); // Lắng nghe login thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.PLUGIN_NOT_FOUND, onPluginNotFound); // Lỗi plugin not found
			
			coreAPI.addEventListener(ElectroServerEventTlmn.JOIN_GAME_ROOM_SUCCESS, onJoinGameRoomSuccess); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.JOIN_GAME_ROOM_FAIL, onJoinGameRoomFail); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_JOIN_ROOM, onHaveUserJoinRoom); // Lắng nghe có user vào phòng mình
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_OUT_ROOM, onHaveUserOutRoom); // Lắng nghe có user rời phòng mình
			coreAPI.addEventListener(ElectroServerEventTlmn.GAME_ROOM_INVALID, onGameRoomInvalid); // Lắng nghe có user vào phòng mình
			
			coreAPI.addEventListener(ElectroServerEventTlmn.PUBLIC_CHAT, onPublicChat); // Lắng nghe chat
			coreAPI.addEventListener(ElectroServerEventTlmn.READY_SUCCESS, onReadyPlaySuccess); // Lắng nghe click nút ready thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.START_GAME_SUCCESS, onStartGameSuccess); // Lắng nghe click nút start thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.DEAL_CARD, onDealCard); // Lắng nghe chia bài
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_DISCARD, onHaveUserDiscard); // Lắng nghe có user đánh bài
			coreAPI.addEventListener(ElectroServerEventTlmn.GET_CARD_SUCCESS, onGetCardSuccess); // Lắng nghe bốc bài thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_GET_CARD, onHaveUserGetCard); // Lắng nghe có user bốc bài
			coreAPI.addEventListener(ElectroServerEventTlmn.STEAL_CARD, onHaveUserStealCard); // Lắng nghe có user ăn bài
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_DOWN_CARD, onHaveUserDownCard); // Lắng nghe có user hạ bài
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_DOWN_CARD_FINISH, onHaveUserDownFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_SEND_CARD_FINISH, onHaveUserSendFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.addEventListener(ElectroServerEventTlmn.GAME_OVER, onGameOver); // Lắng nghe ván bài kết thúc
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_USER_SEND_CARD, onHaveUserSendCard); // Lắng nghe có user gửi bài
			coreAPI.addEventListener(ElectroServerEventTlmn.SORT_FINISH, onSortFinish); // Có người xếp bài xong hoặc bỏ xếp bài
			coreAPI.addEventListener(ElectroServerEventTlmn.COMPARE_GROUP, onCompareGroup); // Đọ chi
			coreAPI.addEventListener(ElectroServerEventTlmn.WHITE_WIN, onWhiteWin); // Đọ chi
			coreAPI.addEventListener(ElectroServerEventTlmn.UPDATE_MONEY, onUpdateMoney); // Lắng nghe udpate tiền
			
			coreAPI.addEventListener(ElectroServerEventTlmn.JOIN_LOBBY_ROOM_SUCCESS, onJoinLobbyRoomSuccess); // Lắng nghe join phòng chờ thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.UPDATE_USER_LIST, onUpdateUserList); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEventTlmn.UPDATE_USER_LIST_OF_LOBBY, onUpdateUserListOfLobby); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEventTlmn.UPDATE_ROOM_LIST, onUpdateRoomList); // Lắng nghe cập nhật danh sách phòng chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEventTlmn.UPDATE_ROOM_MASTER, onUpdateRoomMaster); // Lắng nghe cập nhật thay đổi chủ phòng
			coreAPI.addEventListener(ElectroServerEventTlmn.SEND_ADD_FRIEND_SUCCESS, onServerConfirmAddFriendInvite); // Server confirm là lệnh kết bạn hợp lệ
			coreAPI.addEventListener(ElectroServerEventTlmn.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite); // Người khác trả lời yêu cầu kết bạn của mình
			coreAPI.addEventListener(ElectroServerEventTlmn.REMOVE_FRIEND, onRemoveFriend); // Người khác xóa mình khỏi danh sách friend
			coreAPI.addEventListener(ElectroServerEventTlmn.REQUEST_TIME_CLOCK, onRequestTimeClock); // Người khác request thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.addEventListener(ElectroServerEventTlmn.RESPOND_TIME_CLOCK, onRespondTimeClock); // Người khác respond thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.addEventListener(ElectroServerEventTlmn.REQUEST_IS_COMPARE_GROUP, onRequestIsCompareGroup); // Người khác hỏi xem có phải đang đọ chi không
			coreAPI.addEventListener(ElectroServerEventTlmn.RESPOND_IS_COMPARE_GROUP, onRespondIsCompareGroup); // Người khác trả lời có phải đang đọ chi không
			coreAPI.addEventListener(ElectroServerEventTlmn.COMPARE_GROUP_COMPLETE, onCompareGroupComplete); // Người khác thông báo đọ chi xong
			coreAPI.addEventListener(ElectroServerEventTlmn.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest); // Xác nhận đồng ý hay từ chối kết bạn thành công
			coreAPI.addEventListener(ElectroServerEventTlmn.ROOM_MASTER_KICK, onRoomMasterKick); // Lắng nghe chủ phòng kick mình
			coreAPI.addEventListener(ElectroServerEventTlmn.TIME_OUT, onTimeOut); // Khi một user quá thời gian đánh bài
			coreAPI.addEventListener(ElectroServerEventTlmn.HACKING, onHacking); // Đánh một quân bài không tồn tại
			
			coreAPI.addEventListener(ElectroServerEventTlmn.HAVE_INVITE_PLAY, onHaveInvitePlay); // Lắng nghe lời mời chơi từ user khác
			coreAPI.addEventListener(ElectroServerEventTlmn.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn từ người khác
			coreAPI.addEventListener(ElectroServerEventTlmn.CONFIRM_ADD_FRIEND, onServerConfirmAddFriendConfirm); // Server xác nhận lời đồng ý hay từ chối kết bạn của mình là hợp lệ
			coreAPI.addEventListener(ElectroServerEventTlmn.ADD_MONEY, onAddMoney); // Server nạp tiền
			
			coreAPI.addEventListener(ElectroServerEventTlmn.GET_FIRST_PLAYER, checkFirstPlayer);
			coreAPI.addEventListener(ElectroServerEventTlmn.GET_CURRENT_PLAYER, getCurrentPlayer);
			
			coreAPI.addEventListener(ElectroServerEventTlmn.ERROR, errorDiscard);
			
			coreAPI.addEventListener(ElectroServerEventTlmn.NEXTTURN, haveUserNextTurn);
			
			coreAPI.addEventListener(ElectroServerEventTlmn.END_ROUND, onEndRound);
		}
		
		private function onEndRound(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.END_ROUND, e.data);
		}
		
		public function joinGameRoom(gameId:int, _password:String = ""):void
		{
			var waitingWindow:AlertWindow = new AlertWindow();
			waitingWindow.hideConfirmButton();
			waitingWindow.showLoadingCircle();
			waitingWindow.setNotice(mainData.init.gameDescription.waitingSentence);
			windowLayer.openWindow(waitingWindow);
			mainData.playingData.gameRoomData.roomPassword = _password;
			coreAPI.joinGameRoom(gameId, _password);
		}
		
		public function createGameRoom(_password:String = "", gameOption:Object = null):void
		{
			var waitingWindow:AlertWindow = new AlertWindow();
			waitingWindow.hideConfirmButton();
			waitingWindow.showLoadingCircle();
			waitingWindow.setNotice(mainData.init.gameDescription.waitingSentence);
			windowLayer.openWindow(waitingWindow);
			coreAPI.createGameRoom(gameOption, _password);
		}
		
		public function quickJoinGameRoom(defaultBet:String):void
		{
			var roomId:int;
			var gameId:int = -1;
			var roomList:Array = mainData.lobbyRoomData.roomList;
			if (roomList.length == 0)
			{
				var waitingWindow:AlertWindow = new AlertWindow();
				waitingWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.emptyRoomList);
				windowLayer.openWindow(waitingWindow);
				
				return;
			}
			
			for (var i:int = 0; i < roomList.length; i++) 
			{
				if (RoomDataRLC(roomList[i]).userNumbers < mainData.maxPlayer)
				{
					waitingWindow = new AlertWindow();
					waitingWindow.hideConfirmButton();
					waitingWindow.showLoadingCircle();
					waitingWindow.setNotice(mainData.init.gameDescription.waitingSentence);
					windowLayer.openWindow(waitingWindow);
					
					gameId = RoomDataRLC(roomList[i]).gameId;
					mainData.isRecentlyClickQuickPlay = true;
					joinGameRoom(gameId, "")
					return;
				}
			}
			
			waitingWindow = new AlertWindow();
			waitingWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.fullRoomList);
			windowLayer.openWindow(waitingWindow);
		}
		
		public function findGameRoom(roomId:int,password:String):void
		{
			coreAPI.findGameRoom(roomId, password);
		}
		
		private function onDealCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.DEAL_CARD, e.data);
		}
		
		public function readyPlay():void
		{
			coreAPI.readyPlay();
		}
		
		public function arrangeCardFinish(cardInfo:Array, isSort:Boolean = true):void
		{
			if(coreAPI)
				coreAPI.arrangeCardFinish(cardInfo, isSort);
		}
		
		public function startGame():void
		{
			coreAPI.startGame();
		}
		
		public function playOneCard(cardId:int, nextTurn:String):void
		{
			coreAPI.playOneCard(cardId, nextTurn);
		}
		
		public function getOneCard(userName:String):void
		{
			coreAPI.getOneCard(userName);
		}
		
		public function stealCard(userName:String, cardId:int):void
		{
			coreAPI.stealCard(userName, cardId);
		}
		
		public function downOneDeck(userName:String, cardArray:Array):void
		{
			coreAPI.downOneDeck(userName, cardArray);
		}
		
		public function downCardFinish(userName:String):void
		{
			if (coreAPI)
				coreAPI.downCardFinish(userName);
		}
		
		public function sendCardFinish(userName:String):void
		{
			if (coreAPI)
				coreAPI.sendCardFinish(userName);
		}
		
		public function sendCard(_userName:String, destinationUser:String, index:int, cardId:int):void
		{
			if (coreAPI)
				coreAPI.sendCard(_userName, destinationUser, index, cardId);
		}
		
		private function onHaveUserDiscard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_DISCARD, e.data);
		}
		
		private function onPublicChat(e:ElectroServerEventTlmn):void 
		{
			mainData.publicChatData.userName = e.data[DataField.USER_NAME];
			mainData.publicChatData.displayName = e.data[DataField.DISPLAY_NAME];
			mainData.publicChatData.chatContent = e.data[DataField.CHAT_CONTENT];
			mainData.publicChatData = mainData.publicChatData;
			
			GameDataTLMN.getInstance().publicChat[DataField.USER_NAME] = e.data[DataField.USER_NAME];
			GameDataTLMN.getInstance().publicChat[DataField.DISPLAY_NAME] = e.data[DataField.DISPLAY_NAME];
			GameDataTLMN.getInstance().publicChat[DataField.CHAT_CONTENT] = e.data[DataField.CHAT_CONTENT];
			GameDataTLMN.getInstance().publicChat = GameDataTLMN.getInstance().publicChat;
		}
		
		private function onReadyPlaySuccess(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.READY_SUCCESS, e.data);
		}
		
		private function onStartGameSuccess(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.START_GAME_SUCCESS, e.data);
		}
		
		private function onGetCardSuccess(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.GET_CARD_SUCCESS, e.data);
		}
		
		private function onHaveUserGetCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_GET_CARD, e.data);
		}
		
		private function onHaveUserStealCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_STEAL_CARD, e.data);
		}
		
		private function onHaveUserDownCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_DOWN_CARD, e.data);
		}
		
		private function onHaveUserDownFinishCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_DOWN_CARD_FINISH, e.data);
		}
		
		private function onHaveUserSendFinishCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_SEND_CARD_FINISH, e.data);
		}
		
		private function onHaveUserSendCard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_SEND_CARD, e.data);
		}
		
		private function onSortFinish(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.SORT_FINISH, e.data);
		}
		
		private function onCompareGroup(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.COMPARE_GROUP, e.data);
		}
		
		private function onUpdateMoney(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.UPDATE_MONEY, e.data);
			mainData.lobbyRoomData.updateMoneyData = e.data;
		}
		
		private function onWhiteWin(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.WHITE_WIN, e.data);
		}
		
		private function onGameOver(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.GAME_OVER, e.data);
		}
		
		private function onJoinGameRoomSuccess(e:ElectroServerEventTlmn):void 
		{
			windowLayer.closeAllWindow();
			mainData.playingData.gameRoomData.roomId = e.data[ModelField.ROOM_ID];
			mainData.playingData.isJoinRoomGameSuccess = true;
			
			callPlayingScreenAction(PlayingScreenActionTlmn.JOIN_ROOM, e.data);
		}
		
		private function onJoinGameRoomFail(e:ElectroServerEventTlmn):void 
		{
			trace("ON JOIN GAME ROOM FAIL");
			windowLayer.closeAllWindow();
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.joinGameRoomFail);
			windowLayer.isNoCloseAll = true;
			joinLobbyRoom();
		}
		
		// Hàm để gọi một hành động xẩy ra trong playingScreen
		private function callPlayingScreenAction(actionName:String, data:Object):void
		{
			var playingScreenAction:PlayingScreenActionTlmn = new PlayingScreenActionTlmn();
			playingScreenAction.actionName = actionName;
			playingScreenAction.data = data;
			mainData.playingData.playingScreenAction = playingScreenAction;
			GameDataTLMN.getInstance().playingData.playingScreenAction = playingScreenAction;
		}
		
		private function onHaveUserJoinRoom(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_JOIN_ROOM, e.data);
		}
		
		private function onHaveUserOutRoom(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_OUT_ROOM, e.data);
		}
		
		private function onUpdateRoomMaster(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.UPDATE_ROOM_MASTER, e.data);
		}
		
		private function onRoomMasterKick(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.ROOM_MASTER_KICK, e.data);
		}
		
		private function onTimeOut(e:ElectroServerEventTlmn):void 
		{
			mainData.serverKickOutData = "Quá thời gian không đánh rùi bồ tèo"
		}
		
		private function onHacking(e:ElectroServerEventTlmn):void 
		{
			mainData.serverKickOutData = "Bồ tèo vừa đánh con bài không có trong bộ bài đấy"
		}
		
		private function onServerConfirmAddFriendInvite(e:ElectroServerEventTlmn):void 
		{
			// Gửi một private mess đến người mà mình muốn kết bạn
			var invitedNameArray:Array = [e.data[DataField.FRIEND_ID]];
			var mess:String = "Hi, kết bạn với mình nhé !!"
			var esObject:EsObject = new EsObject();
			esObject.setString(DataField.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataField.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataField.MESSAGE, mess);
			coreAPI.sendPrivateMessage(invitedNameArray, CommandTlmn.INVITE_ADD_FRIEND, esObject);
		}
		
		private function onServerConfirmAddFriendConfirm(e:ElectroServerEventTlmn):void 
		{
			// Gửi private mess trả lời cho người muốn kết bạn với mình
			var invitedNameArray:Array = [e.data[DataField.FRIEND_ID]];
			var mess:String = ""
			var esObject:EsObject = new EsObject();
			esObject.setString(DataField.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataField.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataField.MESSAGE, mess);
			esObject.setBoolean(DataField.SUCCESS, e.data[DataField.SUCCESS]);
			coreAPI.sendPrivateMessage(invitedNameArray, CommandTlmn.CONFIRM_FRIEND_REQUEST, esObject);
		}
		
		private function onAddMoney(e:ElectroServerEventTlmn):void 
		{
			mainData.lobbyRoomData.addMoneyData = e.data;
		}
		
		public function sendPrivateMessage(invitedNameArray:Array, command:String, esObject:EsObject):void
		{
			coreAPI.sendPrivateMessage(invitedNameArray, command, esObject);
		}
		
		public function confirmInviteAddFriend(userName:String, isAccept:Boolean, roomType:String):void
		{
			coreAPI.confirmInviteAddFriend(userName, isAccept, roomType);
		}
		
		private function onGameRoomInvalid(e:ElectroServerEventTlmn):void 
		{
			trace("ON GAME ROOM INVALID");
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.gameRoomInvalid);
		}
		
		private function onCloseConnection(e:ElectroServerEventTlmn):void 
		{
			trace("ON CLOSE CONNECTION");
			windowLayer.closeAllWindow();
			mainData.isCloseConnection = true;
			
			var closeConnectionWindow:AlertWindow = new AlertWindow();
			closeConnectionWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseConnectionWindowClose);
			closeConnectionWindow.setNotice(mainData.init.gameDescription.alertSentence.closeConnection);
			windowLayer.openWindow(closeConnectionWindow);
		}
		
		private function onCloseConnectionWindowClose(e:Event):void 
		{
			windowLayer.openLoadingWindow();
			startConnect('', 0);
		}
		
		private function onConnectFail(e:ElectroServerEventTlmn):void 
		{
			windowLayer.closeAllWindow();
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.connectFail);
		}
		
		private function onConnectSuccess(e:ElectroServerEventTlmn):void 
		{
			//myUserName = '4';
			//mainData.chooseChannelData.myInfo.token = "dung296";
			
			//myUserName = '5';
			//mainData.chooseChannelData.myInfo.token = "yun296";
			//
			//myUserName = '6';
			//mainData.chooseChannelData.myInfo.token = "dungyun";
			
			//mainData.chooseChannelData.myInfo.uId = mainData.myUserName;
			
			//coreAPI.login(mainData.chooseChannelData.myInfo.id, mainData.chooseChannelData.myInfo.name);
			coreAPI.login(mainData.chooseChannelData.myInfo.id, mainData.chooseChannelData.myInfo.name);
		}
		
		private function onLoginFail(e:ElectroServerEventTlmn):void 
		{
			windowLayer.closeAllWindow();
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.loginFail);
		}
		
		private function onPluginNotFound(e:ElectroServerEventTlmn):void 
		{
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.pluginNotFound);
		}
		
		private function onLoginSuccess(e:ElectroServerEventTlmn):void 
		{
			joinLobbyRoom();
		}
		
		public function joinLobbyRoom(isNotInAnyRoom:Boolean = false):void
		{
			var gameName:String = mainData.init.gameName;
			if (isNotInAnyRoom)
				coreAPI.myData.roomId = -1;
			coreAPI.joinLobbyRoom(gameName, channelId, capacity);
		}
		
		// Thông báo ù
		public function noticeFullDeck():void
		{
			coreAPI.noticeFullDeck();
		}
		
		public function closeConnection():void
		{
			coreAPI.closeConnection();
		}
		
		public function invitePlay(infoObject:Object, invitedNameArray:Array):void
		{
			if (!infoObject[DataField.ROOM_PASSWORD])
				infoObject[DataField.ROOM_PASSWORD] = "";
			coreAPI.invitePlay(infoObject, invitedNameArray);
		}
		
		private function onUpdateRoomList(e:ElectroServerEventTlmn):void 
		{
			var roomData:RoomDataRLC;
			var roomList:Object = e.data as Object;
			var tempRoomList:Array = new Array();
			
			for (var roomId:String in roomList)
			{
				roomData = new RoomDataRLC();
				roomData.moneyLogoUrl = mainData.init.requestLink.moneyIcon.@url;
				if(roomList[roomId][DataField.IS_SEND_CARD])
					roomData.rules = mainData.init.gameDescription.lobbyRoomScreen.sendCard;
				else
					roomData.rules = mainData.init.gameDescription.lobbyRoomScreen.notSendCard;
				roomData.ruleToggle = false;
				roomData.betting = roomList[roomId][DataField.ROOM_BET];
				roomData.channelId = mainData.playingData.gameRoomData.channelId;
				roomData.hasPassword = roomList[roomId][DataField.HAS_PASSWORD];
				roomData.maxPlayer = mainData.maxPlayer;
				roomData.name = roomList[roomId][DataField.ROOM_NAME];
				roomData.id = int(roomId);
				roomData.gameId = roomList[roomId][DataField.GAME_ID];
				//if (roomList[roomId][DataField.USER_LIST])
					//roomData.userNumbers = (roomList[roomId][DataField.USER_LIST] as Array).length;
				//else
					//roomData.userNumbers = 1;
				roomData.userNumbers = roomList[roomId][DataField.USERS_NUMBER];
				if (roomData.userNumbers != roomData.maxPlayer || mainData.showFullTable == 1)
					tempRoomList.push(roomData);
			}
			mainData.lobbyRoomData.roomList = tempRoomList;
		}
		
		private function onHaveInvitePlay(e:ElectroServerEventTlmn):void 
		{
			mainData.lobbyRoomData.invitePlayData = e.data;
		}
		
		private function onInviteAddFriend(e:ElectroServerEventTlmn):void 
		{
			mainData.inviteAddFriendData = e.data;
		}
		
		private function onRemoveFriend(e:ElectroServerEventTlmn):void 
		{
			if(coreAPI.myData.friendList)
				delete coreAPI.myData.friendList[e.data[DataField.USER_NAME]];
			mainData.removeFriendData = e.data;
		}
		
		private function onRequestTimeClock(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_REQUEST_TIME_CLOCK, e.data);
		}
		
		private function onRequestIsCompareGroup(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_REQUEST_IS_COMPARE_GROUP, e.data);
		}
		
		private function onRespondIsCompareGroup(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_RESPOND_IS_COMPARE_GROUP, e.data);
		}
		
		private function onCompareGroupComplete(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.COMPARE_GROUP_COMPLETE, e.data);
		}
		
		private function onRespondTimeClock(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.HAVE_USER_RESPOND_TIME_CLOCK, e.data);
		}
		
		private function onFriendConfirmAddFriendInvite(e:ElectroServerEventTlmn):void 
		{
			mainData.responseAddFriendData = e.data;
			if (coreAPI.myData.friendList)
			{
				if (mainData.responseAddFriendData[DataField.CONFIRM])
				{
					coreAPI.myData.friendList[e.data[DataField.USER_NAME]] = new Object();
					coreAPI.myData.friendList[e.data[DataField.USER_NAME]][DataField.DISPLAY_NAME] = e.data[DataField.DISPLAY_NAME];
				}
			}
		}
		
		private function onConfirmFriendRequest(e:ElectroServerEventTlmn):void 
		{
			mainData.confirmFriendRequestData = e.data;
		}
		
		private function onJoinLobbyRoomSuccess(e:ElectroServerEventTlmn):void 
		{
			mainData.lobbyRoomData.isJoinLobbyRoomSuccess = true;
		}
		
		private function onUpdateUserList(e:ElectroServerEventTlmn):void 
		{
			var userData:UserDataULC;
			var allUserList:Object = e.data as Object;
			var isHaveUnknownUser:Boolean;
			var isNotHaveFriendList:Boolean;
			var tempUserList:Array = new Array();
			
			if (!coreAPI.myData.friendList)
				isNotHaveFriendList = true;
				
			for (var userName:String in allUserList)
			{
				userData = new UserDataULC();
				userData.isJoinRoom = true;
				userData.isViewPersonalInfo = true;
				userData.isMakeFriend = true;
				if (allUserList[userName][DataField.USER_INFO])
				{
					userData.moneyLogoUrl = allUserList[userName][DataField.USER_INFO][DataField.LOGO];
					userData.displayName = allUserList[userName][DataField.USER_INFO][ModelField.DISPLAY_NAME];
					userData.levelName = allUserList[userName][DataField.USER_INFO].level;
					userData.userID = userName;
					userData.userName = userName;
					userData.roomID = allUserList[userName][DataField.ROOM_ID];
					userData.money = allUserList[userName][DataField.USER_INFO][ModelField.MONEY];
					
					userData.avatar = allUserList[userName][DataField.USER_INFO][ModelField.AVATAR];
					
					if (coreAPI.myData.friendList)
					{
						if (coreAPI.myData.friendList[userName])
							userData.isFriend = true;
						else
							userData.isFriend = false;
					}
					
					if (userData.userID == mainData.chooseChannelData.myInfo.uId)
					{
						userData.isJoinRoom = false;
						userData.isMakeFriend = false;
						userData.isAccuse = false;
					}
					
					if (allUserList[userName][DataField.USER_INFO][DataField.LOGO])
						userData.webLogoUrl = allUserList[userName][DataField.USER_INFO][DataField.LOGO];
					else
						userData.webLogoUrl = '';
				}
				else
				{
					userData.userName = "unKnown";
					userData.levelName = "unKnown";
					isHaveUnknownUser = true;
				}
				if (allUserList[userName][DataField.ROOM_ID] == 0)
				{
					userData.isJoinRoom = false;
					userData.description = "Phòng chờ";
				}
				else
				{
					userData.description = "Phòng " + allUserList[userName][DataField.ROOM_ID];
				}
				if (userData.userName != mainData.chooseChannelData.myInfo.uId)
					tempUserList.push(userData);
			}
			
			mainData.lobbyRoomData.userList = tempUserList;
		}
		
		private function onUpdateUserListOfLobby(e:ElectroServerEventTlmn):void 
		{
			GameDataTLMN.getInstance().playingData.userListOfLobby = e.data;
			//mainData.playingData.userListOfLobby = 
		}
		
		public function getUserInLobby():void
		{
			if(coreAPI)
				coreAPI.getUserInLobby();
		}
		
		public function sendPublicChat(userName:String, displayName:String, chatContent:String):void
		{
			coreAPI.sendPublicChat(displayName, chatContent);
		}
		
		public function pingToServer():void
		{
			if (coreAPI)
				coreAPI.pingToServer();
		}
		
		public function kickUser(userName:String):void
		{
			coreAPI.kickUser(userName);
		}
		
		public function makeFriend(userName:String, roomType:String):void
		{
			coreAPI.makeFriend(userName, roomType);
		}
		
		public function removeFriend(userName:String, roomType:String):void
		{
			coreAPI.removeFriend(userName, roomType);
			if(coreAPI.myData.friendList)
				delete coreAPI.myData.friendList[userName];
				
			var invitedNameArray:Array = [userName];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataField.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataField.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataField.MESSAGE, mess);
			
			sendPrivateMessage(invitedNameArray, CommandTlmn.REMOVE_FRIEND, esObject);
		}
		
		public function addMoney():void
		{
			coreAPI.addMoney();
		}
		
		public function updateMoney():void
		{
			if (coreAPI)
				coreAPI.updateMoney();
		}
		
		public function orderCard(arr1:Array,arr2:Array,arr3:Array,arr4:Array):void
		{
			if(coreAPI)
				coreAPI.orderCard(arr1, arr2, arr3, arr4);
		}
		
		public function getRoomList():void
		{
			if (coreAPI)
				coreAPI.getRoomList();
		}
		
		public function myDisCard(arr:Array):void 
		{
			if (coreAPI) 
			{
				coreAPI.myDiscard(arr);
			}
			
		}
		
		
		private function errorDiscard(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.ERROR, null);
		}
		
		
		private function checkFirstPlayer(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.GET_FIRST_PLAYER, e.data);
		}
		
		private function getCurrentPlayer(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.GET_CURRENT_PLAYER, e.data);
		}
		
		
		public function nextTurn():void 
		{
			if (coreAPI) 
			{
				coreAPI.nextTurn();
			}
			
		}
		
		
		private function haveUserNextTurn(e:ElectroServerEventTlmn):void 
		{
			callPlayingScreenAction(PlayingScreenActionTlmn.NEXTTURN, e.data);
		}
		
		public function exitGame(type:String):void 
		{
			coreAPI.exitGame(type);
			//joinLobbyRoom();
		}
		
	}

}