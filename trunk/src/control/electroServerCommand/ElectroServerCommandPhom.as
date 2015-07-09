package control.electroServerCommand 
{
	import com.adobe.serialization.json.JSON;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.Protocol;
	import control.CoreAPIPhom;
	import event.Command;
	import event.DataFieldPhom;
	import event.ElectroServerEvent;
	import flash.events.Event;
	import model.EsConfiguration;
	import model.MainData;
	import model.modelField.ModelField;
	import model.playingData.PlayingScreenAction;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmInvitePlayWindow;
	import view.window.ReconnectWindow;
	import view.window.windowLayer.WindowLayer;
	/**
	 * ...
	 * @author Yun
	 */
	public class ElectroServerCommandPhom 
	{
		private var configuration:EsConfiguration;
		private var ipNumber:String = "";
		private var portNumber:int = 9899;
		public var coreAPI:CoreAPIPhom;
		private var channelId:int;
		private var capacity:int;
		private var myUserName:String;
		private var pass:String;
		private var mainData:MainData = MainData.getInstance();
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function ElectroServerCommandPhom() 
		{
			
		}
		
		public function startConnect(_userName:String, _channelId:int, _capacity:int = -1, _pass:String = ""):void
		{
			ipNumber = mainData.init.ipNumber;
			channelId = _channelId;
			capacity = _capacity;
			myUserName = _userName;
			pass = _pass;
			
			if(!configuration)
				configuration = new EsConfiguration();
			configuration.ip = mainData.gameIp;
			configuration.port = mainData.portNumber;
			configuration.protocol = Protocol.BinaryTCP;
			if (!coreAPI)
				coreAPI = new CoreAPIPhom(configuration);
			removeEventForCoreAPI();
			createAddEventForCoreAPI();
			coreAPI.createConnection();
		}
		
		private function createAddEventForCoreAPI():void
		{
			coreAPI.addEventListener(ElectroServerEvent.CLOSE_CONNECTION, onCloseConnection); // Đứt kết nối với server
			
			coreAPI.addEventListener(ElectroServerEvent.CONNECT_SUCCESS, onConnectSuccess); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEvent.CONNECT_FAIL, onConnectFail); // Lắng nghe connect thất bại
			
			coreAPI.addEventListener(ElectroServerEvent.LOGIN_SUCCESS, onLoginSuccess); // Lắng nghe login thành công
			coreAPI.addEventListener(ElectroServerEvent.LOGIN_FAIL, onLoginFail); // Lắng nghe login thành công
			coreAPI.addEventListener(ElectroServerEvent.PLUGIN_NOT_FOUND, onPluginNotFound); // Lỗi plugin not found
			
			coreAPI.addEventListener(ElectroServerEvent.JOIN_GAME_ROOM_SUCCESS, onJoinGameRoomSuccess); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEvent.JOIN_GAME_ROOM_FAIL, onJoinGameRoomFail); // Lắng nghe connect thành công
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_JOIN_ROOM, onHaveUserJoinRoom); // Lắng nghe có user vào phòng mình
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_OUT_ROOM, onHaveUserOutRoom); // Lắng nghe có user rời phòng mình
			coreAPI.addEventListener(ElectroServerEvent.GAME_ROOM_INVALID, onGameRoomInvalid); // Lắng nghe có user vào phòng mình
			
			coreAPI.addEventListener(ElectroServerEvent.PUBLIC_CHAT, onPublicChat); // Lắng nghe chat
			coreAPI.addEventListener(ElectroServerEvent.READY_SUCCESS, onReadyPlaySuccess); // Lắng nghe click nút ready thành công
			coreAPI.addEventListener(ElectroServerEvent.START_GAME_SUCCESS, onStartGameSuccess); // Lắng nghe click nút start thành công
			coreAPI.addEventListener(ElectroServerEvent.DEAL_CARD, onDealCard); // Lắng nghe chia bài
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_DISCARD, onHaveUserDiscard); // Lắng nghe có user đánh bài
			coreAPI.addEventListener(ElectroServerEvent.GET_CARD_SUCCESS, onGetCardSuccess); // Lắng nghe bốc bài thành công
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_GET_CARD, onHaveUserGetCard); // Lắng nghe có user bốc bài
			coreAPI.addEventListener(ElectroServerEvent.STEAL_CARD, onHaveUserStealCard); // Lắng nghe có user ăn bài
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_DOWN_CARD, onHaveUserDownCard); // Lắng nghe có user hạ bài
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_DOWN_CARD_FINISH, onHaveUserDownFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_SEND_CARD_FINISH, onHaveUserSendFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.addEventListener(ElectroServerEvent.GAME_OVER, onGameOver); // Lắng nghe ván bài kết thúc
			coreAPI.addEventListener(ElectroServerEvent.HAVE_USER_SEND_CARD, onHaveUserSendCard); // Lắng nghe có user gửi bài
			coreAPI.addEventListener(ElectroServerEvent.SORT_FINISH, onSortFinish); // Có người xếp bài xong hoặc bỏ xếp bài
			coreAPI.addEventListener(ElectroServerEvent.COMPARE_GROUP, onCompareGroup); // Đọ chi
			coreAPI.addEventListener(ElectroServerEvent.WHITE_WIN, onWhiteWin); // Đọ chi
			coreAPI.addEventListener(ElectroServerEvent.UPDATE_MONEY, onUpdateMoney); // Lắng nghe udpate tiền
			
			coreAPI.addEventListener(ElectroServerEvent.JOIN_LOBBY_ROOM_SUCCESS, onJoinLobbyRoomSuccess); // Lắng nghe join phòng chờ thành công
			coreAPI.addEventListener(ElectroServerEvent.UPDATE_USER_LIST, onUpdateUserList); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEvent.UPDATE_USER_LIST_OF_LOBBY, onUpdateUserListOfLobby); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEvent.UPDATE_ROOM_LIST, onUpdateRoomList); // Lắng nghe cập nhật danh sách phòng chơi trong phòng chờ
			coreAPI.addEventListener(ElectroServerEvent.UPDATE_ROOM_MASTER, onUpdateRoomMaster); // Lắng nghe cập nhật thay đổi chủ phòng
			coreAPI.addEventListener(ElectroServerEvent.SEND_ADD_FRIEND_SUCCESS, onServerConfirmAddFriendInvite); // Server confirm là lệnh kết bạn hợp lệ
			coreAPI.addEventListener(ElectroServerEvent.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite); // Người khác trả lời yêu cầu kết bạn của mình
			coreAPI.addEventListener(ElectroServerEvent.REMOVE_FRIEND, onRemoveFriend); // Người khác xóa mình khỏi danh sách friend
			coreAPI.addEventListener(ElectroServerEvent.REQUEST_TIME_CLOCK, onRequestTimeClock); // Người khác request thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.addEventListener(ElectroServerEvent.RESPOND_TIME_CLOCK, onRespondTimeClock); // Người khác respond thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.addEventListener(ElectroServerEvent.REQUEST_IS_COMPARE_GROUP, onRequestIsCompareGroup); // Người khác hỏi xem có phải đang đọ chi không
			coreAPI.addEventListener(ElectroServerEvent.RESPOND_IS_COMPARE_GROUP, onRespondIsCompareGroup); // Người khác trả lời có phải đang đọ chi không
			coreAPI.addEventListener(ElectroServerEvent.COMPARE_GROUP_COMPLETE, onCompareGroupComplete); // Người khác thông báo đọ chi xong
			coreAPI.addEventListener(ElectroServerEvent.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest); // Xác nhận đồng ý hay từ chối kết bạn thành công
			coreAPI.addEventListener(ElectroServerEvent.ROOM_MASTER_KICK, onRoomMasterKick); // Lắng nghe chủ phòng kick mình
			coreAPI.addEventListener(ElectroServerEvent.TIME_OUT, onTimeOut); // Khi một user quá thời gian đánh bài
			coreAPI.addEventListener(ElectroServerEvent.HACKING, onHacking); // Đánh một quân bài không tồn tại
			
			coreAPI.addEventListener(ElectroServerEvent.HAVE_INVITE_PLAY, onHaveInvitePlay); // Lắng nghe lời mời chơi từ user khác
			coreAPI.addEventListener(ElectroServerEvent.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn từ người khác
			coreAPI.addEventListener(ElectroServerEvent.CONFIRM_ADD_FRIEND, onServerConfirmAddFriendConfirm); // Server xác nhận lời đồng ý hay từ chối kết bạn của mình là hợp lệ
			coreAPI.addEventListener(ElectroServerEvent.ADD_MONEY, onAddMoney); // Server nạp tiền
		}
		
		private function removeEventForCoreAPI():void
		{
			coreAPI.removeEventListener(ElectroServerEvent.CLOSE_CONNECTION, onCloseConnection); // Đứt kết nối với server
			
			coreAPI.removeEventListener(ElectroServerEvent.CONNECT_SUCCESS, onConnectSuccess); // Lắng nghe connect thành công
			coreAPI.removeEventListener(ElectroServerEvent.CONNECT_FAIL, onConnectFail); // Lắng nghe connect thất bại
			
			coreAPI.removeEventListener(ElectroServerEvent.LOGIN_SUCCESS, onLoginSuccess); // Lắng nghe login thành công
			coreAPI.removeEventListener(ElectroServerEvent.LOGIN_FAIL, onLoginFail); // Lắng nghe login thành công
			coreAPI.removeEventListener(ElectroServerEvent.PLUGIN_NOT_FOUND, onPluginNotFound); // Lỗi plugin not found
			
			coreAPI.removeEventListener(ElectroServerEvent.JOIN_GAME_ROOM_SUCCESS, onJoinGameRoomSuccess); // Lắng nghe connect thành công
			coreAPI.removeEventListener(ElectroServerEvent.JOIN_GAME_ROOM_FAIL, onJoinGameRoomFail); // Lắng nghe connect thành công
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_JOIN_ROOM, onHaveUserJoinRoom); // Lắng nghe có user vào phòng mình
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_OUT_ROOM, onHaveUserOutRoom); // Lắng nghe có user rời phòng mình
			coreAPI.removeEventListener(ElectroServerEvent.GAME_ROOM_INVALID, onGameRoomInvalid); // Lắng nghe có user vào phòng mình
			
			coreAPI.removeEventListener(ElectroServerEvent.PUBLIC_CHAT, onPublicChat); // Lắng nghe chat
			coreAPI.removeEventListener(ElectroServerEvent.READY_SUCCESS, onReadyPlaySuccess); // Lắng nghe click nút ready thành công
			coreAPI.removeEventListener(ElectroServerEvent.START_GAME_SUCCESS, onStartGameSuccess); // Lắng nghe click nút start thành công
			coreAPI.removeEventListener(ElectroServerEvent.DEAL_CARD, onDealCard); // Lắng nghe chia bài
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_DISCARD, onHaveUserDiscard); // Lắng nghe có user đánh bài
			coreAPI.removeEventListener(ElectroServerEvent.GET_CARD_SUCCESS, onGetCardSuccess); // Lắng nghe bốc bài thành công
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_GET_CARD, onHaveUserGetCard); // Lắng nghe có user bốc bài
			coreAPI.removeEventListener(ElectroServerEvent.STEAL_CARD, onHaveUserStealCard); // Lắng nghe có user ăn bài
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_DOWN_CARD, onHaveUserDownCard); // Lắng nghe có user hạ bài
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_DOWN_CARD_FINISH, onHaveUserDownFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_SEND_CARD_FINISH, onHaveUserSendFinishCard); // Lắng nghe có user hạ bài xong
			coreAPI.removeEventListener(ElectroServerEvent.GAME_OVER, onGameOver); // Lắng nghe ván bài kết thúc
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_USER_SEND_CARD, onHaveUserSendCard); // Lắng nghe có user gửi bài
			coreAPI.removeEventListener(ElectroServerEvent.SORT_FINISH, onSortFinish); // Có người xếp bài xong hoặc bỏ xếp bài
			coreAPI.removeEventListener(ElectroServerEvent.COMPARE_GROUP, onCompareGroup); // Đọ chi
			coreAPI.removeEventListener(ElectroServerEvent.WHITE_WIN, onWhiteWin); // Đọ chi
			coreAPI.removeEventListener(ElectroServerEvent.UPDATE_MONEY, onUpdateMoney); // Lắng nghe udpate tiền
			
			coreAPI.removeEventListener(ElectroServerEvent.JOIN_LOBBY_ROOM_SUCCESS, onJoinLobbyRoomSuccess); // Lắng nghe join phòng chờ thành công
			coreAPI.removeEventListener(ElectroServerEvent.UPDATE_USER_LIST, onUpdateUserList); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.removeEventListener(ElectroServerEvent.UPDATE_USER_LIST_OF_LOBBY, onUpdateUserListOfLobby); // Lắng nghe cập nhật danh sách người chơi trong phòng chờ
			coreAPI.removeEventListener(ElectroServerEvent.UPDATE_ROOM_LIST, onUpdateRoomList); // Lắng nghe cập nhật danh sách phòng chơi trong phòng chờ
			coreAPI.removeEventListener(ElectroServerEvent.UPDATE_ROOM_MASTER, onUpdateRoomMaster); // Lắng nghe cập nhật thay đổi chủ phòng
			coreAPI.removeEventListener(ElectroServerEvent.SEND_ADD_FRIEND_SUCCESS, onServerConfirmAddFriendInvite); // Server confirm là lệnh kết bạn hợp lệ
			coreAPI.removeEventListener(ElectroServerEvent.FRIEND_CONFIRM_ADD_FRIEND_INVITE, onFriendConfirmAddFriendInvite); // Người khác trả lời yêu cầu kết bạn của mình
			coreAPI.removeEventListener(ElectroServerEvent.REMOVE_FRIEND, onRemoveFriend); // Người khác xóa mình khỏi danh sách friend
			coreAPI.removeEventListener(ElectroServerEvent.REQUEST_TIME_CLOCK, onRequestTimeClock); // Người khác request thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.removeEventListener(ElectroServerEvent.RESPOND_TIME_CLOCK, onRespondTimeClock); // Người khác respond thời gian đếm ngược của đồng hồ khi đang chơi
			coreAPI.removeEventListener(ElectroServerEvent.REQUEST_IS_COMPARE_GROUP, onRequestIsCompareGroup); // Người khác hỏi xem có phải đang đọ chi không
			coreAPI.removeEventListener(ElectroServerEvent.RESPOND_IS_COMPARE_GROUP, onRespondIsCompareGroup); // Người khác trả lời có phải đang đọ chi không
			coreAPI.removeEventListener(ElectroServerEvent.COMPARE_GROUP_COMPLETE, onCompareGroupComplete); // Người khác thông báo đọ chi xong
			coreAPI.removeEventListener(ElectroServerEvent.CONFIRM_FRIEND_REQUEST, onConfirmFriendRequest); // Xác nhận đồng ý hay từ chối kết bạn thành công
			coreAPI.removeEventListener(ElectroServerEvent.ROOM_MASTER_KICK, onRoomMasterKick); // Lắng nghe chủ phòng kick mình
			coreAPI.removeEventListener(ElectroServerEvent.TIME_OUT, onTimeOut); // Khi một user quá thời gian đánh bài
			coreAPI.removeEventListener(ElectroServerEvent.HACKING, onHacking); // Đánh một quân bài không tồn tại
			
			coreAPI.removeEventListener(ElectroServerEvent.HAVE_INVITE_PLAY, onHaveInvitePlay); // Lắng nghe lời mời chơi từ user khác
			coreAPI.removeEventListener(ElectroServerEvent.INVITE_ADD_FRIEND, onInviteAddFriend); // Lời mời kết bạn từ người khác
			coreAPI.removeEventListener(ElectroServerEvent.CONFIRM_ADD_FRIEND, onServerConfirmAddFriendConfirm); // Server xác nhận lời đồng ý hay từ chối kết bạn của mình là hợp lệ
			coreAPI.removeEventListener(ElectroServerEvent.ADD_MONEY, onAddMoney); // Server nạp tiền
		}
		
		public function joinGameRoom(gameId:int, _password:String = ""):void
		{
			windowLayer.openLoadingWindow();
			mainData.playingData.gameRoomData.roomPassword = _password;
			coreAPI.joinGameRoom(gameId, _password);
		}
		
		public function sendEmo(userName:String, emoType:int):void
		{
			coreAPI.sendEmo(userName, emoType);
		}
		
		public function createGameRoom(_password:String = "", gameOption:Object = null):void
		{
			windowLayer.openLoadingWindow();
			coreAPI.createGameRoom(gameOption, _password);
		}
		
		public function quickJoinGameRoom(defaultBet:String):void
		{
			var roomId:int;
			var gameId:int = -1;
			var roomList:Array = mainData.lobbyRoomData.roomList;
			for (var i:int = 0; i < roomList.length; i++) 
			{
				if (RoomDataRLC(roomList[i]).userNumbers < RoomDataRLC(roomList[i]).maxPlayer && !RoomDataRLC(roomList[i]).hasPassword)
				{
					if (Number(RoomDataRLC(roomList[i]).betting) * mainData.minBetRate <= mainData.chooseChannelData.myInfo.money)
					{
						windowLayer.openLoadingWindow();
					
						gameId = RoomDataRLC(roomList[i]).gameId;
						mainData.isRecentlyClickQuickPlay = true;
						joinGameRoom(gameId, "")
						return;
					}
				}
			}
			
			var waitingWindow:AlertWindow = new AlertWindow();
			waitingWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.emptyRoomList);
			windowLayer.openWindow(waitingWindow);
		}
		
		private function onDealCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.DEAL_CARD, e.data);
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
		
		public function sendCard(_userName:String, destinationUser:String, index:int, cardId:Array):void
		{
			if (coreAPI)
				coreAPI.sendCard(_userName, destinationUser, index, cardId);
		}
		
		private function onHaveUserDiscard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_DISCARD, e.data);
		}
		
		private function onPublicChat(e:ElectroServerEvent):void 
		{
			mainData.publicChatData.userName = e.data[DataFieldPhom.USER_NAME];
			mainData.publicChatData.displayName = e.data[DataFieldPhom.DISPLAY_NAME];
			mainData.publicChatData.chatContent = e.data[DataFieldPhom.CHAT_CONTENT];
			mainData.publicChatData = mainData.publicChatData;
		}
		
		private function onReadyPlaySuccess(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.READY_SUCCESS, e.data);
		}
		
		private function onStartGameSuccess(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.START_GAME_SUCCESS, e.data);
		}
		
		private function onGetCardSuccess(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.GET_CARD_SUCCESS, e.data);
		}
		
		private function onHaveUserGetCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_GET_CARD, e.data);
		}
		
		private function onHaveUserStealCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_STEAL_CARD, e.data);
		}
		
		private function onHaveUserDownCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_DOWN_CARD, e.data);
		}
		
		private function onHaveUserDownFinishCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_DOWN_CARD_FINISH, e.data);
		}
		
		private function onHaveUserSendFinishCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_SEND_CARD_FINISH, e.data);
		}
		
		private function onHaveUserSendCard(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_SEND_CARD, e.data);
		}
		
		private function onSortFinish(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.SORT_FINISH, e.data);
		}
		
		private function onCompareGroup(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.COMPARE_GROUP, e.data);
		}
		
		private function onUpdateMoney(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.UPDATE_MONEY, e.data);
			mainData.lobbyRoomData.updateMoneyData = e.data;
		}
		
		private function onWhiteWin(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.WHITE_WIN, e.data);
		}
		
		private function onGameOver(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.GAME_OVER, e.data);
		}
		
		private function onJoinGameRoomSuccess(e:ElectroServerEvent):void 
		{
			windowLayer.closeAllWindow();
			mainData.playingData.gameRoomData.roomId = e.data[ModelField.ROOM_ID];
			mainData.playingData.isJoinRoomGameSuccess = true;
			
			callPlayingScreenAction(PlayingScreenAction.JOIN_ROOM, e.data);
		}
		
		private function onJoinGameRoomFail(e:ElectroServerEvent):void 
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
			var playingScreenAction:PlayingScreenAction = new PlayingScreenAction();
			playingScreenAction.actionName = actionName;
			playingScreenAction.data = data;
			mainData.playingData.playingScreenAction = playingScreenAction;
		}
		
		private function onHaveUserJoinRoom(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_JOIN_ROOM, e.data);
		}
		
		private function onHaveUserOutRoom(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_OUT_ROOM, e.data);
		}
		
		private function onUpdateRoomMaster(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.UPDATE_ROOM_MASTER, e.data);
		}
		
		private function onRoomMasterKick(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.ROOM_MASTER_KICK, e.data);
		}
		
		private function onTimeOut(e:ElectroServerEvent):void 
		{
			mainData.serverKickOutData = "Quá thời gian không đánh rùi bồ tèo"
		}
		
		private function onHacking(e:ElectroServerEvent):void 
		{
			mainData.serverKickOutData = "Bồ tèo vừa đánh con bài không có trong bộ bài đấy"
		}
		
		private function onServerConfirmAddFriendInvite(e:ElectroServerEvent):void 
		{
			// Gửi một private mess đến người mà mình muốn kết bạn
			var invitedNameArray:Array = [e.data[DataFieldPhom.FRIEND_ID]];
			var mess:String = "Hi, kết bạn với mình nhé !!"
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldPhom.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldPhom.MESSAGE, mess);
			coreAPI.sendPrivateMessage(invitedNameArray, Command.INVITE_ADD_FRIEND, esObject);
		}
		
		private function onServerConfirmAddFriendConfirm(e:ElectroServerEvent):void 
		{
			// Gửi private mess trả lời cho người muốn kết bạn với mình
			var invitedNameArray:Array = [e.data[DataFieldPhom.FRIEND_ID]];
			var mess:String = ""
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldPhom.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldPhom.MESSAGE, mess);
			esObject.setBoolean(DataFieldPhom.SUCCESS, e.data[DataFieldPhom.SUCCESS]);
			coreAPI.sendPrivateMessage(invitedNameArray, Command.CONFIRM_FRIEND_REQUEST, esObject);
		}
		
		private function onAddMoney(e:ElectroServerEvent):void 
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
		
		private function onGameRoomInvalid(e:ElectroServerEvent):void 
		{
			trace("ON GAME ROOM INVALID");
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.gameRoomInvalid);
		}
		
		private function onCloseConnection(e:ElectroServerEvent):void 
		{
			if (mainData.isOpeningKickOutWindow)
				return;
			trace("ON CLOSE CONNECTION");
			windowLayer.closeAllWindow();
			mainData.isCloseConnection = true;
			removeEventForCoreAPI();
			coreAPI = null;
			
			if (mainData.isReconnectVersion)
			{
				if (mainData.isReconnectPhom)
				{
					var reconnectWindow:ReconnectWindow = new ReconnectWindow();
					reconnectWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseReconnectWindow);
					windowLayer.openWindow(reconnectWindow);
				}
				else
				{
					var closeConnectionWindow:AlertWindow = new AlertWindow();
					closeConnectionWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseConnectionWindowClose);
					closeConnectionWindow.setNotice("Kết nối bị gián đoạn. Vui lòng kiểm tra lại internet");
					windowLayer.openWindow(closeConnectionWindow);
				}
				return;
			}
			closeConnectionWindow = new AlertWindow();
			closeConnectionWindow.addEventListener(BaseWindow.CLOSE_COMPLETE, onCloseConnectionWindowClose);
			closeConnectionWindow.setNotice("Kết nối bị gián đoạn. \n Vui lòng thử lại...");
			windowLayer.openWindow(closeConnectionWindow);
		}
		
		private function onCloseReconnectWindow(e:Event):void 
		{
			mainData.isCloseReconnectWindow = true;
		}
		
		private function onCloseConnectionWindowClose(e:Event):void 
		{
			//windowLayer.openLoadingWindow();
			//startConnect('', 0);
		}
		
		private function onConnectFail(e:ElectroServerEvent):void 
		{
			mainData.connectFail = true;
			windowLayer.closeAllWindow();
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.connectFail);
		}
		
		private function onConnectSuccess(e:ElectroServerEvent):void 
		{
			//myUserName = '4';
			//mainData.chooseChannelData.myInfo.token = "dung296";
			
			//myUserName = '5';
			//mainData.chooseChannelData.myInfo.token = "yun296";
			//
			//myUserName = '6';
			//mainData.chooseChannelData.myInfo.token = "dungyun";
			
			//mainData.chooseChannelData.myInfo.uId = mainData.myUserName;
			
			coreAPI.login(mainData.chooseChannelData.myInfo.id, mainData.chooseChannelData.myInfo.name);
		}
		
		private function onLoginFail(e:ElectroServerEvent):void 
		{
			windowLayer.closeAllWindow();
			mainData.isCloseConnection = true;
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.loginFail);
			closeConnection();
		}
		
		private function onPluginNotFound(e:ElectroServerEvent):void 
		{
			windowLayer.openAlertWindow(mainData.init.gameDescription.alertSentence.pluginNotFound);
		}
		
		private function onLoginSuccess(e:ElectroServerEvent):void 
		{
			joinLobbyRoom();
		}
		
		public function joinLobbyRoom(isNotInAnyRoom:Boolean = false):void
		{
			var gameName:String = mainData.init.gameName;
			if (isNotInAnyRoom)
				coreAPI.myData.roomId = -1;
			coreAPI.joinLobbyRoom(gameName, mainData.currentChannelId, capacity);
		}
		
		// Thông báo ù
		public function noticeFullDeck():void
		{
			coreAPI.noticeFullDeck();
		}
		
		public function closeConnection():void
		{
			removeEventForCoreAPI();
			coreAPI.closeConnection();
		}
		
		public function invitePlay(infoObject:Object, invitedNameArray:Array):void
		{
			if (!infoObject[DataFieldPhom.ROOM_PASSWORD])
				infoObject[DataFieldPhom.ROOM_PASSWORD] = "";
			coreAPI.invitePlay(infoObject, invitedNameArray);
		}
		
		private function onUpdateRoomList(e:ElectroServerEvent):void 
		{
			var roomData:RoomDataRLC;
			var roomList:Object = e.data as Object;
			var tempRoomList:Array = new Array();
			
			for (var roomId:String in roomList)
			{
				roomData = new RoomDataRLC();
				roomData.moneyLogoUrl = mainData.init.requestLink.moneyIcon.@url;
				if(roomList[roomId][DataFieldPhom.IS_SEND_CARD])
					roomData.rules = mainData.init.gameDescription.lobbyRoomScreen.sendCard;
				else
					roomData.rules = mainData.init.gameDescription.lobbyRoomScreen.notSendCard;
				roomData.ruleToggle = false;
				roomData.male = roomList[roomId][DataFieldPhom.MALE];
				roomData.betting = roomList[roomId][DataFieldPhom.ROOM_BET];
				roomData.channelId = mainData.playingData.gameRoomData.channelId;
				roomData.hasPassword = roomList[roomId][DataFieldPhom.HAS_PASSWORD];
				roomData.maxPlayer = roomList[roomId][DataFieldPhom.MAX_PLAYER];
				roomData.name = roomList[roomId][DataFieldPhom.ROOM_NAME];
				roomData.id = int(roomId);
				roomData.gameId = roomList[roomId][DataFieldPhom.GAME_ID];
				//if (roomList[roomId][DataField.USER_LIST])
					//roomData.userNumbers = (roomList[roomId][DataField.USER_LIST] as Array).length;
				//else
					//roomData.userNumbers = 1;
				roomData.userNumbers = roomList[roomId][DataFieldPhom.USERS_NUMBER];
				if (roomData.userNumbers != roomData.maxPlayer || mainData.showFullTable == 1)
					tempRoomList.push(roomData);
			}
			mainData.lobbyRoomData.roomList = tempRoomList;
		}
		
		private function onHaveInvitePlay(e:ElectroServerEvent):void 
		{
			mainData.lobbyRoomData.invitePlayData = e.data;
		}
		
		private function onInviteAddFriend(e:ElectroServerEvent):void 
		{
			//mainData.inviteAddFriendData = e.data;
		}
		
		private function onRemoveFriend(e:ElectroServerEvent):void 
		{
			if(coreAPI.myData.friendList)
				delete coreAPI.myData.friendList[e.data[DataFieldPhom.USER_NAME]];
			mainData.removeFriendData = e.data;
		}
		
		private function onRequestTimeClock(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_REQUEST_TIME_CLOCK, e.data);
		}
		
		private function onRequestIsCompareGroup(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_REQUEST_IS_COMPARE_GROUP, e.data);
		}
		
		private function onRespondIsCompareGroup(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_RESPOND_IS_COMPARE_GROUP, e.data);
		}
		
		private function onCompareGroupComplete(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.COMPARE_GROUP_COMPLETE, e.data);
		}
		
		private function onRespondTimeClock(e:ElectroServerEvent):void 
		{
			callPlayingScreenAction(PlayingScreenAction.HAVE_USER_RESPOND_TIME_CLOCK, e.data);
		}
		
		private function onFriendConfirmAddFriendInvite(e:ElectroServerEvent):void 
		{
			mainData.responseAddFriendData = e.data;
			if (coreAPI.myData.friendList)
			{
				if (mainData.responseAddFriendData[DataFieldPhom.CONFIRM])
				{
					coreAPI.myData.friendList[e.data[DataFieldPhom.USER_NAME]] = new Object();
					coreAPI.myData.friendList[e.data[DataFieldPhom.USER_NAME]][DataFieldPhom.DISPLAY_NAME] = e.data[DataFieldPhom.DISPLAY_NAME];
				}
			}
		}
		
		private function onConfirmFriendRequest(e:ElectroServerEvent):void 
		{
			mainData.confirmFriendRequestData = e.data;
		}
		
		private function onJoinLobbyRoomSuccess(e:ElectroServerEvent):void 
		{
			mainData.lobbyRoomData.isJoinLobbyRoomSuccess = true;
		}
		
		private function onUpdateUserList(e:ElectroServerEvent):void 
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
				userData.isOnline = true;
				userData.gameId = MainData.PHOM_ID;
				userData.isJoinRoom = true;
				userData.isViewPersonalInfo = true;
				userData.isMakeFriend = true;
				if (allUserList[userName][DataFieldPhom.USER_INFO])
				{
					userData.moneyLogoUrl = allUserList[userName][DataFieldPhom.USER_INFO][DataFieldPhom.LOGO];
					userData.displayName = allUserList[userName][DataFieldPhom.USER_INFO][ModelField.DISPLAY_NAME];
					userData.win = allUserList[userName][DataFieldPhom.USER_INFO][DataFieldPhom.WIN];
					userData.lose = allUserList[userName][DataFieldPhom.USER_INFO][DataFieldPhom.LOSE];
					userData.levelName = allUserList[userName][DataFieldPhom.USER_INFO].level;
					userData.userID = userName;
					userData.userName = userName;
					userData.roomID = allUserList[userName][DataFieldPhom.ROOM_ID];
					userData.money = allUserList[userName][DataFieldPhom.USER_INFO][ModelField.MONEY];
					
					userData.avatar = allUserList[userName][DataFieldPhom.USER_INFO][ModelField.AVATAR];
					
					if (mainData.lobbyRoomData.friendList)
					{
						userData.isFriend = false;
						for (var i:int = 0; i < mainData.lobbyRoomData.friendList.length; i++) 
						{
							if (UserDataULC(mainData.lobbyRoomData.friendList[i]).userName == userName)
							{
								userData.isFriend = true;
								break;
							}
						}
					}
					
					if (userData.userID == mainData.chooseChannelData.myInfo.uId)
					{
						userData.isJoinRoom = false;
						userData.isMakeFriend = false;
						userData.isAccuse = false;
					}
					
					if (allUserList[userName][DataFieldPhom.USER_INFO][DataFieldPhom.LOGO])
						userData.webLogoUrl = allUserList[userName][DataFieldPhom.USER_INFO][DataFieldPhom.LOGO];
					else
						userData.webLogoUrl = '';
				}
				else
				{
					userData.userName = "unKnown";
					userData.levelName = "unKnown";
					isHaveUnknownUser = true;
				}
				if (allUserList[userName][DataFieldPhom.ROOM_ID] == mainData.lobbyRoomId)
				{
					userData.isJoinRoom = false;
					userData.description = "Phòng chờ";
				}
				else
				{
					userData.description = "Phòng " + allUserList[userName][DataFieldPhom.ROOM_ID];
				}
				if (userData.userName != mainData.chooseChannelData.myInfo.uId && userData.roomID == mainData.lobbyRoomId)
					tempUserList.push(userData);
			}
			
			mainData.lobbyRoomData.userList = tempUserList;
		}
		
		private function onUpdateUserListOfLobby(e:ElectroServerEvent):void 
		{
			mainData.playingData.userListOfLobby = e.data;
		}
		
		public function getUserInLobby():void
		{
			if(coreAPI)
				coreAPI.getUserInLobby();
		}
		
		public function sendPublicChat(displayName:String, chatContent:String):void
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
		
		public function addFriend(userName:String, roomType:String):void
		{
			coreAPI.addFriend(userName, roomType);
		}
		
		public function removeFriend(userName:String, roomType:String):void
		{
			coreAPI.removeFriend(userName, roomType);
			if(coreAPI.myData.friendList)
				delete coreAPI.myData.friendList[userName];
				
			var invitedNameArray:Array = [userName];
			var mess:String = "";
			var esObject:EsObject = new EsObject();
			esObject.setString(DataFieldPhom.DISPLAY_NAME, mainData.chooseChannelData.myInfo.name);
			esObject.setString(DataFieldPhom.USER_NAME, mainData.chooseChannelData.myInfo.uId);
			esObject.setString(DataFieldPhom.MESSAGE, mess);
			
			sendPrivateMessage(invitedNameArray, Command.REMOVE_FRIEND, esObject);
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
		
		public function getFriendList():void
		{
			if (coreAPI)
				coreAPI.getFriendList();
		}
	}

}