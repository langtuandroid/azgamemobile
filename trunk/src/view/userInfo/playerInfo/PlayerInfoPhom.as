package view.userInfo.playerInfo 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import com.hallopatidu.utils.StringFormatUtils;
	import control.MainCommand;
	import event.DataField;
	import flash.desktop.NativeApplication;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import view.BubbleChat;
	import view.button.BigButton;
	import view.card.CardPhom;
	import view.card.CardManager;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.screen.PlayingScreen;
	import view.timeBar.TimeBar;
	import view.userInfo.avatar.Avatar;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmFullDeckWindow;
	import view.window.ConfirmWindow;
	import view.window.InvitePlayWindow;
	import view.window.ConfirmFullDeckWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayerInfoPhom extends Sprite 
	{
		public static const EXIT:String = "exit";
		public static const AVATAR_CLICK:String = "avatarClick";
		
		public static const BELOW_USER:String = "belowUserInfo";
		public static const ABOVE_USER:String = "aboveUserInfo";
		public static const LEFT_USER:String = "leftUserInfo";
		public static const RIGHT_USER:String = "rightUserInfo";
		
		public static const DO_NOTHING:String = "doNothing";
		public static const PLAY_CARD:String = "playCard";
		public static const GET_CARD:String = "getCard";
		public static const DOWN_CARD:String = "downCard";
		public static const SEND_CARD:String = "sendCard";
		
		public static const GET_CARD_TURN:String = "getCardTurn";
		public static const STEAL_CARD:String = "stealCard";
		
		public var unLeaveCardPosition:Array; // vị trí các quân bài chưa đánh
		public var leavedCardPosition:Array; // vị trí các quân bài đã đánh
		public var downCardPosition:Point; // vị trí để xác định quân bài vừa hạ phỏm
		
		private const belowUserCardSize:Object = {"unLeaveCard":0.73,"leavedCard":0.5,"downCard":0.5}; // kích thước các quân bài của user bên dưới
		private const leftUserCardSize:Object = {"unLeaveCard":0.5,"leavedCard":0.5,"downCard":0.5}; // kích thước các quân bài của user bên trái
		private const rightUserCardSize:Object = {"unLeaveCard":0.5,"leavedCard":0.5,"downCard":0.5}; // kích thước các quân bài của user bên phải
		private const aboveUserCardSize:Object = { "unLeaveCard":0.5, "leavedCard":0.5, "downCard":0.5 }; // kích thước các quân bài của user bên trên
		
		private const belowUserCardRotation:Object = {"unLeaveCard":0,"leavedCard":0,"downCard":0}; // góc quay của các quân bài của user bên dưới
		private const leftUserCardRotation:Object = {"unLeaveCard":90,"leavedCard":0,"downCard":0}; // góc quay của các quân bài của user bên trái
		private const rightUserCardRotation:Object = {"unLeaveCard":90,"leavedCard":0,"downCard":0}; // góc quay của các quân bài của user bên phải
		private const aboveUserCardRotation:Object = { "unLeaveCard":0, "leavedCard":0, "downCard":0 }; // góc quay của các quân bài của user bên trên
		
		public var unLeaveCardSize:Number;
		public var leavedCardSize:Number;
		public var downCardSize:Number;
		
		public var unLeaveCardRotation:Number;
		public var leavedCardRotation:Number;
		public var downCardRotation:Number;
		
		private const distanceDeckVertical:Number = 25; // khoảng cách giữa các phỏm nằm dọc
		private const distanceDeckHorizontal:Number = 2; // khoảng cách giữa các phỏm nằm ngang
		
		public var timeBar:TimeBar; // thanh đếm thời gian
		private var content:Sprite;
		public var formName:String;
		public var deckNumber:int = 0; // số phỏm của người chơi
		private var totalDownCard:int = 0; // Tổng số lá của các phỏm cộng lại
		
		private const smallDistance:Number = 10; // khoảng cách giữa các quân bài chưa đánh của user trái,phải,trên
		private const largeDistance:Number = 20; // khoảng cách giữa các quân bài chưa đánh của user chính
		private const largeDistance_2:Number = 10; // khoảng cách giữa các quân bài đã đánh, hoặc đã hạ
		
		public var unLeaveCards:Array; // Mảng chứa các lá bài chưa đánh
		public var leavedCards:Array; // Mảng chứa các lá bài đã đánh
		public var downCards_1:Array; // Mảng chứa các lá bài của phỏm 1
		public var downCards_2:Array; // Mảng chứa các lá bài của phỏm 2
		public var downCards_3:Array; // Mảng chứa các lá bài của phỏm 3
		
		private var getCardButton:BigButton; // Nút bốc bài
		public var stealCardButton:BigButton; // Nút ăn bài
		public var arrangeCardButton:BigButton; // Nút xếp bài
		private var playCardButton:BigButton; // Nút đánh bài
		private var reSelectButton:BigButton; // Nút chọn lại
		private var downCardButton:BigButton; // Nút hạ bài
		private var downCardFinishButton:BigButton; // Nút hạ bài xong
		private var sendCardButton:BigButton; // Nút gửi bài
		private var sendCardFinishButton:BigButton; // Nút gửi bài xong
		private var buttonArray:Array; // mảng chứa tất cả các nút
		
		private var mainData:MainData = MainData.getInstance();
		
		private var playerName:TextField;
		private var level:TextField;
		private var money:TextField;
		private var homeIcon:Sprite;
		private var readyIcon:Sprite;
		private var moneyNumber:Number;
		private var addMoneyText:TextField;
		
		public var cardInfoArray:Array;
		
		public var isCardInteractive:Boolean; // Biến để xác định xem có cho tương tác vào quân bài của người chơi này không
		
		public var position:int; // vị trí của người chơi, quyết định thứ tự chia bài
		public var userName:String; // id của người chơi
		public var displayName:String; // id của người chơi
		
		public var resultEffectPosition:Point;
		public var moneyEffectPosition:Point;
		
		private var avatar:Avatar;
		private var myStatus:String; // Lưu lại trạng thái hiện tại của user
		private var selectedCardArray:Array;
		
		public var currentSelectedCard:CardPhom; // lá bài đang được chọn
		public var currentDraggingCard:CardPhom; // lá bài đang được kéo
		public var currentSwapCard:CardPhom; // lá bài sẽ được đổi vị trị với lá bài được kéo
		public var cardOfPreviousPlayer:CardPhom; // lá bài vừa đánh của người chơi trước mình
		public var isHaveUserDownCard:Boolean; // Biến cờ đánh dấu xem đã có user nào trước đó hạ bài hay chưa
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var phomLogic:PhomLogic = PhomLogic.getInstance();
		
		private var leftLimit:Point; // Giới hạn di chuyển phía trái, khi drag quân bài về phía trái không thể dịch quá giới hạn này
		private var rightLimit:Point; // Giới hạn di chuyển phía phải, khi drag quân bài về phía phải không thể dịch quá giới hạn này
		
		private var invitePlayButton:SimpleButton; // Nút mời chơi
		private var exitButton:SimpleButton; // Nút thoát
		
		private var invitePlayWindow:InvitePlayWindow; // Cửa sổ mời chơi
		private var windowLayer:WindowLayer = WindowLayer.getInstance(); // windowLayer để mở cửa sổ bất kỳ
		
		private const effectTime:Number = 0.5;
		public var playingPlayerArray:Array; // Danh sách những người đang chơi
		
		private var confirmDownCardFinishWindow:ConfirmWindow; // Bảng xác nhận hạ xong
		private var confirmSendCardFinishWindow:ConfirmWindow; // Bảng xác nhận gửi xong
		private var confirmExitWindow:ConfirmWindow; // Bảng xác nhận thoát ra khỏi phòng
		
		private var countShowTooltipPlayCard:int = 0;
		private var countShowTooltipDownCard:int = 0;
		private var countShowTooltipSendCard:int = 0;
		
		public var isWaitingToReady:Boolean;
		public var avatarString:String;
		public var logoString:String;
		
		private var tooltip:Sprite; // tooltip
		private var bubbleChat:BubbleChat;
		private var timerToHideBubbleChat:Timer;
		
		public function PlayerInfoPhom() 
		{
			unLeaveCards = new Array();
			leavedCards = new Array();
			downCards_1 = new Array();
			downCards_2 = new Array();
			downCards_3 = new Array();
			//cacheAsBitmap = true;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function addChatSentence(sentence:String):void
		{
			if (timerToHideBubbleChat)
			{
				timerToHideBubbleChat.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideBubbleChat);
				timerToHideBubbleChat.stop();	
			}
			
			if (!bubbleChat)
				bubbleChat = new BubbleChat();
			bubbleChat.addString(sentence);
			bubbleChat.x = avatar.x;
			bubbleChat.y = avatar.y;
			var globalPosition:Point = new Point(bubbleChat.x, bubbleChat.y);
			globalPosition = localToGlobal(globalPosition);
			if (globalPosition.x + bubbleChat.width > mainData.stageWidth)
				bubbleChat.x = - (globalPosition.x + bubbleChat.width - mainData.stageWidth);
				
			bubbleChat.x = globalPosition.x;
			bubbleChat.y = globalPosition.y;
			
			parent.addChild(bubbleChat);
			bubbleChat.visible = true;
			
			timerToHideBubbleChat = new Timer(mainData.showBubbleChatTime * 1000, 1);
			timerToHideBubbleChat.addEventListener(TimerEvent.TIMER_COMPLETE, onHideBubbleChat);
			timerToHideBubbleChat.start();
		}
		
		private function onHideBubbleChat(e:TimerEvent):void 
		{
			if (!stage)
				return;
			bubbleChat.visible = false;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (mainData.isOnAndroid)
				NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
				
			if (bubbleChat)
			{
				if (bubbleChat.parent)
					bubbleChat.parent.removeChild(bubbleChat);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 16777238:
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				
				if (isPlaying)
				{
					confirmExitWindow = new ConfirmWindow();
					confirmExitWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmExit);
					confirmExitWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
					windowLayer.openWindow(confirmExitWindow);
				}
				else
				{
					exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
					dispatchEvent(new Event(EXIT, true));
					electroServerCommand.joinLobbyRoom();
					EffectLayer.getInstance().removeAllEffect();
				}
				break;
			}
		}
		
		private function addAvatar():void 
		{
			if (!avatar)
			{				
				avatar = new Avatar();
				if (formName == PlayerInfoPhom.BELOW_USER)
				{
					avatar.setForm(Avatar.MY_AVATAR);
				}
				else
				{
					avatar.setForm(Avatar.FRIEND_AVATAR);
					avatar.buttonMode = true;
				}
			}
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			content["avatarPosition"].visible = false;
			content.addChild(avatar);
		}
		
		private function setupPersonalInfo():void 
		{
			playerName = content["playerName"];
			level = content["level"];
			money = content["money"];
			if (formName == BELOW_USER)
			{
				addMoneyText = content["addMoneyText"];
				//addMoneyText.selectable = false;
			}
			playerName.selectable = /*level.selectable = */money.selectable = false;
			homeIcon = content["homeIcon"];
			content.removeChild(homeIcon);
			readyIcon = content["readyIcon"];
			readyIcon.cacheAsBitmap = true;
			if (formName == PlayerInfoPhom.BELOW_USER)
			{
				tooltip = content["tooltip"];
				TextField(tooltip["description"]).selectable = false;
				hideToolTip();
			}
			content.removeChild(readyIcon);
		}
		
		public function showTooltip(description:String):void
		{
			if (formName != PlayerInfoPhom.BELOW_USER)
				return;
			tooltip["description"].text = description;
			tooltip.visible = true;
			if (stage)
			{
				if (tooltip.parent != stage && tooltip.parent == content)
				{
					var tempPoint:Point = localToGlobal(new Point(tooltip.x, tooltip.y));
					tooltip.x = tempPoint.x;
					tooltip.y = tempPoint.y;
				}
				stage.addChild(tooltip);
			}
		}
		
		public function hideToolTip():void
		{
			if (formName != PlayerInfoPhom.BELOW_USER)
				return;
			tooltip.visible = false;
			if (stage)
			{
				if (tooltip.parent == stage)
					stage.removeChild(tooltip);
			}
		}
		
		public function setForm(_formName:String):void
		{
			formName = _formName;
			createSizeAndRotation();
			switch (formName) 
			{
				case PlayerInfoPhom.BELOW_USER:
					addContent(1);
					createAllButton();
					createOtherButton();
					
					if (mainData.isOnAndroid)
						NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
				break;
				case PlayerInfoPhom.LEFT_USER:
					addContent(2);
				break;
				case PlayerInfoPhom.RIGHT_USER:
					addContent(3);
				break;
				case PlayerInfoPhom.ABOVE_USER:
					addContent(4);
				break;
				default:
					
				break;
			}
		}
		
		// update ảnh avatar
		public function updateAvatar(imgSrc:String, logoSrc:String):void
		{
			avatarString = imgSrc;
			logoString = logoSrc;
			avatar.addImg(imgSrc, logoSrc, true, userName);
		}
		
		// update text tên, cấp độ và số tiền
		public function updatePersonalInfo(infoObject:Object):void
		{
			userName = infoObject[ModelField.USER_NAME];
			displayName = infoObject[ModelField.DISPLAY_NAME];
			var nameString:String;
			if(formName == BELOW_USER)
				nameString = StringFormatUtils.shortenedString(infoObject[ModelField.DISPLAY_NAME], 14);
			else
				nameString = StringFormatUtils.shortenedString(infoObject[ModelField.DISPLAY_NAME], 11);
			playerName.text = nameString;
			
			if (formName == BELOW_USER)
			{
				var phoneNumber_1:String = mainData.init.gameDescription.chooseChannelScreen.addMoneyNumber_1;
				//if (mainData.init.gameDescription.isTurnOnSms == '1')
					//addMoneyText.text = 'Soạn "' + mainData.init.gameDescription.moneyUnit + ' ' + String(mainData.chooseChannelData.myInfo.uId) + '" gửi ' + phoneNumber_1 + ' (15k/tin)';
				//else
					//addMoneyText.text = '';
			}
			//level.text = infoObject[ModelField.LEVEL];
			moneyNumber = infoObject[ModelField.MONEY];
			
			money.text = PlayingLogic.format(moneyNumber,1);
			
			if (moneyNumber <= 0)
				money.text = '0';
				
			updateAvatar(infoObject[ModelField.AVATAR], infoObject[ModelField.LOGO]);
			
			avatar.addEventListener(MouseEvent.CLICK, onAvatarClick, true);
			
			contextMenuPosition = new Point();
			contextMenuPosition.x = content["contextMenuPosition"].x;
			contextMenuPosition.y = content["contextMenuPosition"].y;
			content["contextMenuPosition"].visible = false;
		}
		
		private function onAvatarClick(e:MouseEvent):void 
		{
			if (formName == BELOW_USER)
				return;
			e.stopPropagation();
			dispatchEvent(new Event(AVATAR_CLICK));
		}
		
		public function updateMoney(value:Number):void
		{
			if (value == 0)
				money.text = "0";
			else
				money.text = PlayingLogic.format(value, 1);
			/*moneyNumber += value;
			
			if (moneyNumber <= 0)
			{
				money.text = '0';
				moneyNumber = 0;
			}
			else
			{
				money.text = PlayingLogic.format(moneyNumber, 1);
			}*/
			
			if (formName == PlayerInfo.BELOW_USER) // Nếu là user của mình thì cập nhật lại tiền cho phòng chờ và phòng chọn kênh
			{
				mainData.chooseChannelData.myInfo.money = value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
		}
		
		public function removeAllCards():void
		{
			removeCardsArray(unLeaveCards);
			removeCardsArray(leavedCards);
			removeCardsArray(downCards_1);
			removeCardsArray(downCards_2);
			removeCardsArray(downCards_3);
			
			unLeaveCards = new Array();
			leavedCards = new Array();
			downCards_1 = new Array();
			downCards_2 = new Array();
			downCards_3 = new Array();
			unLeaveCardPosition = new Array();
			leavedCardPosition = new Array();
			selectedCardArray = new Array();
			
			deckNumber = 0;
			totalDownCard = 0;
			cardOfPreviousPlayer = null;
			isHaveUserDownCard = false;
			currentSelectedCard = null;
			currentDraggingCard = null;
			currentSwapCard = null;
			_isPlaying = false;
			isWaitingToReady = false;
			
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 10); // tạo vị trí cho quân bài chưa đánh
			createPosition("leavedCardPosition", "leavedCardPosition", 4); // tạo vị trí cho quân bài đã đánh
			
		}
		
		public function getUnUsePosition(positionType:String):Object
		{
			var tempPositionArray:Array;
			switch (positionType) 
			{
				case CardPhom.UN_LEAVE_CARD:
					tempPositionArray = unLeaveCardPosition;
				break;
				case CardPhom.LEAVED_CARD:
					tempPositionArray = leavedCardPosition;
				break;
			}
			var i:int;
			for (i = 0; i < tempPositionArray.length; i++) 
			{
				if (!tempPositionArray[i].hasOwnProperty("isUsed"))
					return tempPositionArray[i];
				if (tempPositionArray[i]["isUsed"] == false)
					return tempPositionArray[i];
			}
			return tempPositionArray[0];
		}
		
		public function getCardById(cardType:String,cardId:int):CardPhom
		{
			var cardArray:Array;
			switch (cardType) 
			{
				case CardPhom.UN_LEAVE_CARD:
					cardArray = unLeaveCards;
				break;
				case CardPhom.LEAVED_CARD:
					cardArray = leavedCards;
				break;
			}
			
			var i:int;
			for (i = 0; i < cardArray.length; i++) 
			{
				if (cardArray[i].id == cardId) 
				{
					var card:CardPhom = cardArray[i];
					//cardArray.splice(i, 1);
					return card;
				}
			}
			trace("Không có quân bài nào có giá trị là " + cardId);
			return cardArray[cardArray.length - 1];
		}
		
		public function playOneCard(cardId:int):void
		{
			var tempPoint:Point;
			var tempCardInfo:Array;
			var movingType:String;
			var tempCard:CardPhom;
			movingType = CardManager.OPEN_FINISH_STYLE;
			
			// tìm quân bài cần đánh
			tempCard = getCardById(CardPhom.UN_LEAVE_CARD, cardId);
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			tempPoint = getPointByCardType(CardPhom.LEAVED_CARD);
			
			// gọi hàm di chuyển
			tempCard.moving(tempPoint, CardManager.playCardTime , movingType, leavedCardSize);
			
			moveUnleaveToLeavedCard(cardId);
		}
		
		// Hạ một bộ bài
		public function downOneDeck(deckArray:Array, isLocal:Boolean = false):void
		{
			deckNumber++;
			var downCards:Array;
			switch (deckNumber) 
			{
				case 1:
					downCards_1 = new Array();
					downCards = downCards_1;
				break;
				case 2:
					downCards_2 = new Array();
					downCards = downCards_2;
				break;
				case 3:
					downCards_3 = new Array();
					downCards = downCards_3;
				break;
			}
			
			var i:int;
			for (i = 0; i < deckArray.length; i++) 
			{
				var j:int;
				for (j = 0; j < unLeaveCards.length; j++) 
				{
					if (CardPhom(unLeaveCards[j]).id == deckArray[i])
					{
						CardPhom(unLeaveCards[j]).isMouseInteractive = false;
						if (CardPhom(unLeaveCards[j]).isStealCard)
							CardPhom(unLeaveCards[j]).isStealCard = false;
						downCards.push(unLeaveCards[j]);
						unLeaveCards.splice(j, 1);
						j = unLeaveCards.length + 1;
						totalDownCard++;
					}
				}
			}
			
			reArrangeUnleaveCard();
			reArrangeDownCard();
			
			if (isLocal)
				return;
			
			// Kiểm tra xem còn phỏm hạ không, nếu không thì cho hạ finish
			if (phomLogic.countDeck(unLeaveCards).length == 0 && formName == PlayerInfoPhom.BELOW_USER) 
			{
				electroServerCommand.downCardFinish(userName);
				downCardFinishButton.enable = false;
			}
		}
		
		public function pushCardToOndeDeck(card:CardPhom, deckIndex:int):void
		{
			switch (deckIndex) 
			{
				case 1:
					downCards_1.push(card);
					phomLogic.arrangeDeck(downCards_1);
				break;
				case 2:
					downCards_2.push(card);
					phomLogic.arrangeDeck(downCards_2);
				break;
				case 3:
					downCards_3.push(card);
					phomLogic.arrangeDeck(downCards_3);
				break;
			}
			totalDownCard++;
			reArrangeDownCard();
		}
		
		// Xét đến lượt mình đánh
		public function setMyTurn(status:String):void
		{
			myStatus = status;
			removeAllButton();
			addChild(arrangeCardButton);
			arrangeCardButton.enable = true;
			hideToolTip();
			switch (status) 
			{
				case PlayerInfoPhom.DO_NOTHING:
					timeBar.stopCountTime();
					addChild(playCardButton);
					addChild(reSelectButton);
				break;
				case PlayerInfoPhom.GET_CARD:
					dispatchEvent(new Event(GET_CARD_TURN));
					timeBar.countTime(mainData.init.playTime.playCardTimePhom);
					addChild(getCardButton);
					addChild(stealCardButton);
					getCardButton.enable = true;
					if (phomLogic.checkStealCard(cardOfPreviousPlayer, unLeaveCards))
					{
						cardOfPreviousPlayer.showTwinkle();
						cardOfPreviousPlayer.mouseEnabled = cardOfPreviousPlayer.mouseChildren = true;
						cardOfPreviousPlayer.buttonMode = true;
						cardOfPreviousPlayer.addEventListener(MouseEvent.CLICK, onClickStealableCard);
						stealCardButton.enable = true;
					}
				break;
				case PlayerInfoPhom.PLAY_CARD:
					if (countShowTooltipPlayCard == 0)
					{
						showTooltip(mainData.init.gameDescription.playingScreen.playCard);
						countShowTooltipPlayCard++;
					}
					addChild(playCardButton);
					addChild(reSelectButton);
					currentSelectedCard = null;
					for (var j:int = 0; j < unLeaveCards.length; j++) // Kiểm tra xem đang có lá bài nào được chọn để enable nút đánh
					{
						if (CardPhom(unLeaveCards[j]).isChoose)
							currentSelectedCard = unLeaveCards[j];
					}
					if (currentSelectedCard) // nếu đã có lá bài được chọn thì enable nút đánh bài và nút chọn lại
						reSelectButton.enable = playCardButton.enable = true;
				break;
				case PlayerInfoPhom.DOWN_CARD:
					var deckCount:int = phomLogic.countDeck(unLeaveCards).length;
					if (deckCount > 0) // Nếu có phỏm hạ
					{
						timeBar.countTime(mainData.init.playTime.downCardTime);
						addChild(downCardButton);
						addChild(downCardFinishButton);
						downCardFinishButton.enable = true;
						if (countShowTooltipDownCard == 0)
						{
							showTooltip(mainData.init.gameDescription.playingScreen.downCard);
							//countShowTooltipDownCard++;
						}
					}
					else // Nếu móm
					{
						electroServerCommand.downCardFinish(userName);
						electroServerCommand.sendCardFinish(userName);
						setMyTurn(PLAY_CARD);
					}
				break;
				case PlayerInfoPhom.SEND_CARD:
					timeBar.countTime(mainData.init.playTime.sendCardTime);
					addChild(sendCardButton);
					addChild(sendCardFinishButton);
					sendCardFinishButton.enable = true;
					if (countShowTooltipSendCard == 0)
					{
						showTooltip(mainData.init.gameDescription.playingScreen.sendCard);
						countShowTooltipSendCard++;
					}
				break;
			}
		}
		
		private function onClickStealableCard(e:MouseEvent):void 
		{
			CardPhom(e.currentTarget).removeEventListener(MouseEvent.CLICK, onClickStealableCard);
			CardPhom(e.currentTarget).hideTwinkle();
			CardPhom(e.currentTarget).buttonMode = false;
			CardPhom(e.currentTarget).mouseEnabled = CardPhom(e.currentTarget).mouseChildren = false;
			if (myStatus == GET_CARD && CardPhom(e.currentTarget))
			{
				dispatchEvent(new Event(STEAL_CARD));
				electroServerCommand.stealCard(userName, CardPhom(e.currentTarget).id);
			}
		}
		
		private function onConfirmFullDeck(e:Event):void 
		{
			setMyTurn(DO_NOTHING);
		}
		
		public function openAllCard():void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardPhom(unLeaveCards[i]).effectOpen();
			}
		}
		
		// Hàm để hạ tất cả các phỏm khi ù
		public function downAllCardWhenFullDeck():void
		{
			if (unLeaveCards.length == 10)
			{
				var i:int;
				var fullDeckArray:Array = phomLogic.getDeckWhenFullDeck(unLeaveCards);
				for (i = 0; i < fullDeckArray.length; i++)
				{
					var deckArray:Array = new Array();
					for (var j:int = 0; j < fullDeckArray[i].length; j++) 
					{
						deckArray.push(CardPhom(fullDeckArray[i][j]).id);
					}
					downOneDeck(deckArray, true);
				}
			}
		}
		
		private function removeAllButton():void
		{
			for (var i:int = 0; i < buttonArray.length; i++) 
			{
				if (contains(buttonArray[i]))
					removeChild(buttonArray[i]);
				BigButton(buttonArray[i]).enable = false;
			}
		}
		
		private function moveUnleaveToLeavedCard(cardId:int):void // gán lá bài vừa đánh sang mảng các lá bài đã đánh
		{
			var i:int;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				if (CardPhom(unLeaveCards[i]).id == cardId)
				{
					if (!leavedCards)
						leavedCards = new Array();
					leavedCards.push(unLeaveCards[i]);
					CardPhom(unLeaveCards[i]).isMouseInteractive = false;
					unLeaveCards.splice(i, 1);
					i = unLeaveCards.length + 1;
				}
			}
			reArrangeUnleaveCard();
		}
		
		public function addValueForOneUnleavedCard(cardId:int):void
		{
			var i:int;
			for (i = unLeaveCards.length - 1; i >= 0; i--) // tìm xem user này đã có quân bài này chưa, nếu có rồi thì returrn luôn
			{
				if (CardPhom(unLeaveCards[i]).id == cardId)
					return;
			}
			for (i = unLeaveCards.length - 1; i >= 0; i--) // Nếu chưa có thì gán giá trị quân bài mới vào
			{
				if (CardPhom(unLeaveCards[i]).id == 0)
				{
					CardPhom(unLeaveCards[i]).setId(cardId);
					i = -1;
				}
			}
		}
		
		// push new card vào mảng các lá bài chưa đánh
		public function pushNewUnLeaveCard(card:CardPhom):void
		{
			if (!unLeaveCards)
				unLeaveCards = new Array();
			unLeaveCards.push(card);
			card.isMouseInteractive = isCardInteractive;
			
			if (isCardInteractive)
			{
				card.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.addEventListener(CardPhom.IS_SELECTED, onCardIsSelected);
				card.addEventListener(CardPhom.IS_DE_SELECTED, onCardIsDeSelected);
			}
			else
			{
				card.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.removeEventListener(CardPhom.IS_SELECTED, onCardIsSelected);
				card.removeEventListener(CardPhom.IS_DE_SELECTED, onCardIsDeSelected);
			}
			
			// Mỗi lần add thêm lá bài chưa đánh thì check ù
			if (unLeaveCards.length == 10 && formName == PlayerInfoPhom.BELOW_USER)
			{
				var timerToCheckFullDeck:Timer = new Timer(500, 1);
				timerToCheckFullDeck.addEventListener(TimerEvent.TIMER_COMPLETE, onCheckFullDeck);
				timerToCheckFullDeck.start();
			}
		}
		
		private function onCheckFullDeck(e:TimerEvent):void 
		{
			if (!stage)
				return;
			if (unLeaveCards.length == 10)
			{
				if (phomLogic.checkFullDeck(unLeaveCards))
				{
					var confirmFullDeckWindow:ConfirmFullDeckWindow = new ConfirmFullDeckWindow();
					windowLayer.openWindow(confirmFullDeckWindow);
					windowLayer.addEventListener(ConfirmFullDeckWindow.CONFIRM_FULL_DECK, onConfirmFullDeck);
				}
			}
		}
		
		private function onMouseDownCard(e:MouseEvent):void 
		{
			if (!stage)
				return;
			currentDraggingCard = e.currentTarget as CardPhom;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			var point_1:Point = localToGlobal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[0].y));
			point_1 = CardPhom(e.currentTarget).parent.globalToLocal(point_1);
			var point_2:Point = localToGlobal(new Point(unLeaveCardPosition[9].x, unLeaveCardPosition[9].y));
			point_2 = CardPhom(e.currentTarget).parent.globalToLocal(point_2);
			CardPhom(e.currentTarget).startDrag(false, new Rectangle(point_1.x, point_1.y - CardPhom(e.currentTarget).height / 3, Math.abs(point_2.x - point_1.x) + 35, CardPhom(e.currentTarget).height / 3 * 2));
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			if (!stage || !currentDraggingCard)
				return;
			var i:int;
			if (currentSwapCard && currentDraggingCard)
			{
				var index_1:int;
				var index_2:int;
				for (i = 0; i < unLeaveCards.length; i++)
				{
					if (unLeaveCards[i] == currentSwapCard)
						index_1 = i;
					if (unLeaveCards[i] == currentDraggingCard)
						index_2 = i;
				}
				
				if (index_2 > index_1)
				{
					var tempCard:CardPhom = unLeaveCards[index_2];
					for (i = index_2; i > index_1; i--)
					{
						unLeaveCards[i] = unLeaveCards[i - 1];
					}
					unLeaveCards[index_1] = tempCard;
				}
				else
				{
					tempCard = unLeaveCards[index_2];
					for (i = index_2; i < index_1 - 1; i++)
					{
						unLeaveCards[i] = unLeaveCards[i + 1];
					}
					unLeaveCards[index_1 - 1] = tempCard;
				}
			}
			
			if (currentDraggingCard.isChoose)
				var distance:Number = Math.sqrt(Math.pow(currentDraggingCard.startX - currentDraggingCard.x, 2) + Math.pow(currentDraggingCard.startY - currentDraggingCard.height / 4 - currentDraggingCard.y, 2));
			else
				distance = Math.sqrt(Math.pow(currentDraggingCard.startX - currentDraggingCard.x, 2) + Math.pow(currentDraggingCard.startY - currentDraggingCard.y, 2));
				
			if (distance >= 10)
			{
				if (currentDraggingCard && !currentSwapCard)
				{
					if (currentDraggingCard != unLeaveCards[unLeaveCards.length - 1])
					{
						if (currentDraggingCard.x >= unLeaveCards[unLeaveCards.length - 1].x + 10)
						{
							for (i = 0; i < unLeaveCards.length; i++)
							{
								if (unLeaveCards[i] == currentDraggingCard)
								{
									index_2 = i;
									i = unLeaveCards.length + 1;
								}
							}
							
							index_1 = unLeaveCards.length;
							tempCard = unLeaveCards[index_2];
							for (i = index_2; i < index_1 - 1; i++)
							{
								unLeaveCards[i] = unLeaveCards[i + 1];
							}
							unLeaveCards[index_1 - 1] = tempCard;
						}
					}
				}
				reArrangeUnleaveCard(0,false);
			}
			else
			{
				reAddUnleaveCard();
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			currentSwapCard = null;
			currentDraggingCard = null;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				CardPhom(unLeaveCards[i]).stopDrag();
				var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 5, 5, 10, 1);
				if(CardPhom(unLeaveCards[i]).isStealCard)
					CardPhom(unLeaveCards[i]).filters = [filterTemp];
				else
					CardPhom(unLeaveCards[i]).filters = null;
			}
		}
		
		private function reAddUnleaveCard():void 
		{
			var tempPoint:Point;
			var i:int;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				//tempPoint = getPointByCardType(Card.UN_LEAVE_CARD);
				//Card(unLeaveCards[i]).moving(tempPoint, 0, CardManager.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation);
				CardPhom(unLeaveCards[i]).parent.addChild(unLeaveCards[i]);
			}
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (!currentDraggingCard)
				return;
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (currentSwapCard)
				{
					if (Math.abs(currentDraggingCard.x - currentSwapCard.x) > 10)
					{
						var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 5, 5, 10, 1);
						if(currentSwapCard.isStealCard)
							currentSwapCard.filters = [filterTemp];
						else
							currentSwapCard.filters = null;
						currentSwapCard = null;
					}
				}
				if (unLeaveCards[i] != currentDraggingCard)
				{
					if (Math.abs(currentDraggingCard.x - unLeaveCards[i].x) <= 10)
					{
						if (unLeaveCards[i] != currentSwapCard)
						{
							if (currentSwapCard)
							{
								filterTemp = new GlowFilter(0xFF0033, 1, 5, 5, 10, 1);
								if(currentSwapCard.isStealCard)
									currentSwapCard.filters = [filterTemp];
								else
									currentSwapCard.filters = null;
							}
							currentSwapCard = unLeaveCards[i];
							filterTemp = new GlowFilter(0xFF6600, 1, 5, 5, 10, 1);
							currentSwapCard.filters = [filterTemp];
							currentDraggingCard.parent.addChild(currentDraggingCard);
						}
					}
				}
			}
		}
		
		private function onCardIsSelected(e:Event):void // chọn bài
		{
			if (formName != PlayerInfoPhom.BELOW_USER)
				return;
			hideToolTip();
			if (myStatus == DOWN_CARD) // trường hợp đang hạ bài
			{
				checkDownCard();
				return;
			}
				
			// nếu không thì chỉ cho chọn 1 quân bài 1 thời điểm
			currentSelectedCard = CardPhom(e.currentTarget);
			
			if (myStatus != DO_NOTHING)
				playCardButton.enable = reSelectButton.enable = true;
				
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (unLeaveCards[i] != e.currentTarget)
					CardPhom(unLeaveCards[i]).moveToStartPoint();
			}
			
			if (myStatus == SEND_CARD)
			{
				if (checkSendCard([currentSelectedCard]))
					sendCardButton.enable = true;
				else
					sendCardButton.enable = false;
			}
		}
		
		public function checkSendCard(cardArray:Array):Array
		{
			// Tìm người chơi trước mình
			var sendDeckArray:Array = new Array();
			
			// Tìm các bộ bài của những người hạ bài trc mình xem có thể gửi không
			var object:Object;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName != userName)
				{
					if(PlayerInfoPhom(playingPlayerArray[i]).downCards_1)
					{
						if (phomLogic.checkSendCard(cardArray, PlayerInfoPhom(playingPlayerArray[i]).downCards_1))
						{
							object = new Object();
							object[DataField.USER_NAME] = PlayerInfoPhom(playingPlayerArray[i]).userName;
							object[DataField.CARDS] = PlayerInfoPhom(playingPlayerArray[i]).downCards_1;
							object[DataField.INDEX] = 0;
							sendDeckArray.push(object);
						}
					}
					if (PlayerInfoPhom(playingPlayerArray[i]).downCards_2)
					{
						if (phomLogic.checkSendCard(cardArray, PlayerInfoPhom(playingPlayerArray[i]).downCards_2))
						{
							object = new Object();
							object[DataField.USER_NAME] = PlayerInfoPhom(playingPlayerArray[i]).userName;
							object[DataField.CARDS] = PlayerInfoPhom(playingPlayerArray[i]).downCards_2;
							object[DataField.INDEX] = 1;
							sendDeckArray.push(object);
						}
					}
					if (PlayerInfoPhom(playingPlayerArray[i]).downCards_3)
					{
						if (phomLogic.checkSendCard(cardArray, PlayerInfoPhom(playingPlayerArray[i]).downCards_3))
						{
							object = new Object();
							object[DataField.USER_NAME] = PlayerInfoPhom(playingPlayerArray[i]).userName;
							object[DataField.CARDS] = PlayerInfoPhom(playingPlayerArray[i]).downCards_3;
							object[DataField.INDEX] = 2;
							sendDeckArray.push(object);
						}
					}
				}
			}
			
			if(sendDeckArray.length == 0)
				return null;
			else
				return sendDeckArray;
		}
		
		private function getPreviousPlayer():PlayerInfoPhom
		{
			var previousPlayer:PlayerInfoPhom;
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == userName)
				{
					if (i == 0)
						previousPlayer = playingPlayerArray[playingPlayerArray.length - 1];
					else
						previousPlayer = playingPlayerArray[i - 1];
					return previousPlayer;
				}
			}
			return null;
		}
		
		private function getNextPlayer():PlayerInfoPhom
		{
			var nextPlayer:PlayerInfoPhom;
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (PlayerInfoPhom(playingPlayerArray[i]).userName == userName)
				{
					if (i == playingPlayerArray.length - 1)
						nextPlayer = playingPlayerArray[0];
					else
						nextPlayer = playingPlayerArray[i + 1];
					return nextPlayer;
				}
			}
			return null;
		}
		
		private function onCardIsDeSelected(e:Event):void // bỏ chọn bài
		{
			if (myStatus == DOWN_CARD)
				checkDownCard();
			if (myStatus == PLAY_CARD)
			{
				currentSelectedCard = null;
				for (var j:int = 0; j < unLeaveCards.length; j++) // Kiểm tra xem đang có lá bài nào được chọn để gán lại currentSelectedCard
				{
					if (CardPhom(unLeaveCards[j]).isChoose)
						currentSelectedCard = unLeaveCards[j];
				}
				if (!currentSelectedCard)
					playCardButton.enable = reSelectButton.enable = false;
				else
					playCardButton.enable = reSelectButton.enable = true;
			}
			if (myStatus == SEND_CARD)
			{
				sendCardButton.enable = false;
				currentSelectedCard = null;
				for (j = 0; j < unLeaveCards.length; j++) // Kiểm tra xem đang có lá bài nào được chọn để gán lại currentSelectedCard
				{
					if (CardPhom(unLeaveCards[j]).isChoose)
						currentSelectedCard = unLeaveCards[j];
				}
				if (currentSelectedCard)
				{
					if (checkSendCard([currentSelectedCard]))
						sendCardButton.enable = true;
				}
			}
		}
		
		public function deleteOneUnleaveCard(card:CardPhom):void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (unLeaveCards[i] == card)
				{
					unLeaveCards.splice(i, 1);
					if (formName == PlayerInfoPhom.BELOW_USER)
					{
						if (checkSendCard(unLeaveCards)) // check xem có bài để gửi không
						{
							setMyTurn(SEND_CARD);
						}
						else // nếu không có bài gửi thì bỏ qua luôn phần gửi
						{
							if(formName == PlayerInfoPhom.BELOW_USER)
								electroServerCommand.sendCardFinish(userName);
							setMyTurn(PLAY_CARD);
						}
					}
					reArrangeUnleaveCard();
					return;
				}
			}
		}
		
		// Lấy một lá bài ra khỏi các quân bài đã đánh - dùng cho việc người khác ăn quân bài của mình
		public function popOneLeavedCard(cardId:int):CardPhom
		{
			var i:int;
			for (i = leavedCardPosition.length - 1; i >= 0; i--) 
			{
				if (leavedCardPosition[i]["isUsed"] == true)
				{
					leavedCardPosition[i]["isUsed"] = false;
					i = -1;
				}
			}
			var card:CardPhom;
			if (cardId == 0)
			{
				return leavedCards.pop();
			}
			for (i = 0; i < leavedCards.length; i++) 
			{
				if (CardPhom(leavedCards[i]).id == cardId)
				{
					card = CardPhom(leavedCards[i]);
					leavedCards.splice(i, 1);
					return card;
				}
			}
			return card;
		}
		
		// push thêm một lá bài vào các quân bài đã đánh - dùng trong trường hợp mình bị ng khác ăn bài, và chuyển bài từ chỗ khác vào bài mình đã đánh
		public function pushNewLeavedCard(card:CardPhom, time:Number = 0):void
		{
			if (time == 0)
				time = CardManager.playCardTime;
			if (!leavedCards)
				leavedCards = new Array();
			leavedCards.push(card);
			card.isMouseInteractive = false;
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(CardPhom.LEAVED_CARD);
			
			// gọi hàm di chuyển
			card.moving(tempPoint, time , CardManager.TURN_OVER_STYLE, leavedCardSize);
		}
		
		private function removeCardsArray(cardsArray:Array):void
		{
			var i:int;
			for (i = 0; i < cardsArray.length; i++) 
			{
				if (cardsArray[i])
				{
					if (cardsArray[i] is CardPhom)
					{
						CardPhom(cardsArray[i]).removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
						CardPhom(cardsArray[i]).removeEventListener(CardPhom.IS_SELECTED, onCardIsSelected);
						CardPhom(cardsArray[i]).removeEventListener(CardPhom.IS_DE_SELECTED, onCardIsDeSelected);
						CardPhom(cardsArray[i]).destroy();
						cardsArray[i] = null;
					}
				}
			}
		}
		
		public function reArrangeUnleaveCard(time:Number = 0, isRotate:Boolean = true):void
		{
			if (!stage || !unLeaveCards)
				return;
				
			if (time == 0)
				time = CardManager.arrangeCardTime;
				
			var index:int;
			var scaleNumber:Number;
			var i:int;
			
			currentSelectedCard = null;
			if (playCardButton)
				playCardButton.enable = false;
			
			switch (formName) 
			{
				case PlayerInfoPhom.BELOW_USER:
					scaleNumber = belowUserCardSize[CardPhom.UN_LEAVE_CARD];
				break;
				case PlayerInfoPhom.LEFT_USER:
					scaleNumber = leftUserCardSize[CardPhom.UN_LEAVE_CARD];
				break;
				case PlayerInfoPhom.RIGHT_USER:
					scaleNumber = rightUserCardSize[CardPhom.UN_LEAVE_CARD];
				break;
				case PlayerInfoPhom.ABOVE_USER:
					scaleNumber = aboveUserCardSize[CardPhom.UN_LEAVE_CARD];
				break;
			}
			
			for (i = 0; i < unLeaveCardPosition.length; i++) 
			{
				unLeaveCardPosition[i]["isUsed"] = false;
			}
			
			var tempPoint:Point;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				tempPoint = getPointByCardType(CardPhom.UN_LEAVE_CARD);
				CardPhom(unLeaveCards[i]).isChoose = false;
				if (isRotate)
				{
					CardPhom(unLeaveCards[i]).moving(tempPoint, time, CardManager.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation);
				}
				else
				{
					CardPhom(unLeaveCards[i]).moving(tempPoint, time, CardManager.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation, true, true, false);
				}
			}
			
			if (formName == ABOVE_USER) // nếu là user ở trên và đã hạ bài thì cho các quân bài hạ lên layer trên
				reArrangeDownCard();
		}
		
		private function addContent(type:int):void
		{	
			if (content)
				removeChild(content);
			var className:String;
			switch (type) 
			{
				case 1:
					className = "zPlayUserProfileForm_1_Phom";
				break;
				case 2:
					className = "zPlayUserProfileForm_2_Phom";
				break;
				case 3:
					className = "zPlayUserProfileForm_3_Phom";
				break;
				case 4:
					className = "zPlayUserProfileForm_4_Phom";
				break;
				default:
				break;
			}
			
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
			
			addTimeBar(); // add thành bar thời gian chờ
			
			createAllPosition(type); // tạo tất cả các vị trí của các quân bài
			
			setupPersonalInfo();
			
			resultEffectPosition = new Point();
			resultEffectPosition.x = content["effectResultPosition"].x;
			resultEffectPosition.y = content["effectResultPosition"].y;
			content["effectResultPosition"].visible = false;
			
			moneyEffectPosition = new Point();
			moneyEffectPosition.x = content["effectMoneyPosition"].x;
			moneyEffectPosition.y = content["effectMoneyPosition"].y;
			content["effectMoneyPosition"].visible = false;
			
			addAvatar();
		}
		
		private function addTimeBar():void 
		{
			var _type:int;
			switch (formName) 
			{
				case PlayerInfoPhom.BELOW_USER:
					_type = 3;
				break;
				case PlayerInfoPhom.LEFT_USER:
				case PlayerInfoPhom.RIGHT_USER:
					_type = 1;
				break;
				case PlayerInfoPhom.ABOVE_USER:
					_type = 2;
				break;
			}
			if (!timeBar)
			{
				timeBar = new TimeBar(_type);
				timeBar.visible = false;
				timeBar.addEventListener(TimeBar.COUNT_TIME_FINISH, onCountTimeFinish);
			}
			timeBar.x = content["timeBarPosition"].x;
			timeBar.y = content["timeBarPosition"].y;
			content["timeBarPosition"].visible = false;
			addChild(timeBar);
		}
		
		private function onCountTimeFinish(e:Event):void 
		{
			if (formName != PlayerInfoPhom.BELOW_USER)
				return;
			switch (myStatus) 
			{
				case PLAY_CARD:
					setMyTurn(DO_NOTHING);
					if (!unLeaveCards)
						return;
					if (unLeaveCards.length == 0)
						return;
					for (var i:int = unLeaveCards.length - 1; i >= 0; i--) // Tìm quân bài đánh hợp lệ
					{
						if (phomLogic.checkPlayCard(unLeaveCards[i], unLeaveCards))
						{
							electroServerCommand.playOneCard(CardPhom(unLeaveCards[i]).id, getNextPlayer().userName);
							playOneCard(CardPhom(unLeaveCards[i]).id);
							i = -1;
						}
					}
					currentSelectedCard = null;
				break;
				case GET_CARD:
					if (cardOfPreviousPlayer) // Tình huống bốc bài trong trường hợp có thể ăn bài thì cho con bài ăn đc dừng nhấp nháy
					{
						cardOfPreviousPlayer.hideTwinkle();
						cardOfPreviousPlayer.buttonMode = false;
						cardOfPreviousPlayer.mouseEnabled = cardOfPreviousPlayer.mouseChildren = false;
						cardOfPreviousPlayer.removeEventListener(MouseEvent.CLICK, onClickStealableCard);
					}
					dispatchEvent(new Event(GET_CARD));
					electroServerCommand.getOneCard(userName);
					setMyTurn(DO_NOTHING);
				break;
				case DOWN_CARD:
					var deckArray:Array = phomLogic.getDeckToAutoDownCard(unLeaveCards);
					var deckIdArray:Array = new Array();
					for (j = 0; j < deckArray.length; j++) 
					{
						var tempArray:Array = new Array();
						deckIdArray.push(tempArray);
						for (var k:int = 0; k < deckArray[j].length; k++) 
						{
							tempArray[k] = CardPhom(deckArray[j][k]).id;
						}
					}
					for (j = 0; j < deckIdArray.length; j++)
					{
						electroServerCommand.downOneDeck(userName, deckIdArray[j]);
					}
					electroServerCommand.downCardFinish(userName);
				break;
				case SEND_CARD:
					for (var j:int = 0; j < unLeaveCards.length; j++)
					{
						var sendDeckArray:Array = checkSendCard([unLeaveCards[j]]);
						if(sendDeckArray)
							electroServerCommand.sendCard(userName, sendDeckArray[0][DataField.USER_NAME], sendDeckArray[0][DataField.INDEX], CardPhom(unLeaveCards[j]).id);
					}
					electroServerCommand.sendCardFinish(userName);
					setMyTurn(PLAY_CARD);
				break;
				case DO_NOTHING: 
					/*if (isWaitingToReady) // Thời gian đếm lúc sẵn sàng
					{
						var kickOutWindow:AlertWindow = new AlertWindow();
						kickOutWindow.setNotice(mainData.init.gameDescription.playingScreen.kickOutReady);
						windowLayer.openWindow(kickOutWindow);
						windowLayer.isNoCloseAll = true;
						
						exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
						dispatchEvent(new Event(EXIT, true));
						electroServerCommand.joinLobbyRoom();
						EffectLayer.getInstance().removeAllEffect();
					}*/
				break;
			}
		}
		
		public function countTime(time:Number):void
		{
			if (formName != BELOW_USER)
				isMyTurn = true;
			timeBar.countTime(time);
		}
		
		public function stopCountTime():void
		{
			if (formName != BELOW_USER)
				isMyTurn = false;
			timeBar.stopCountTime();
		}
		
		private function createAllPosition(type:int):void
		{
			if (!unLeaveCardPosition)
			{
				unLeaveCardPosition = new Array();
				leavedCardPosition = new Array();
				downCardPosition = new Point();
			}
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 10); // tạo vị trí cho quân bài chưa đánh
			createPosition("leavedCardPosition", "leavedCardPosition", 4); // tạo vị trí cho quân bài đã đánh
			downCardPosition.x = content["downCardPosition"].x;
			downCardPosition.y = content["downCardPosition"].y;
			content["downCardPosition"].visible = false;
		}
		
		/**
		 * 
		 * @param	positionName - tên của mảng các vị trí
		 * @param	varName - tên thuộc tính của biến content để lấy vị trí
		 * @param	positionNumber - số lượng vị trí
		 */
		private function createPosition(positionName:String, varName:String, positionNumber:int):void 
		{
			this[positionName][0] = new Object();
			this[positionName][0].x = content[varName].x;
			this[positionName][0].y = content[varName].y;
			content[varName].visible = false;
			
			var isVertical:Boolean; // xếp ngang hay dọc
			var tempDistance:Number = smallDistance;
			
			if (positionName == "unLeaveCardPosition")
			{
				switch (formName) 
				{
					case PlayerInfoPhom.BELOW_USER:
						tempDistance = largeDistance;
					break;
					case PlayerInfoPhom.LEFT_USER:
					case PlayerInfoPhom.RIGHT_USER:
						isVertical = true;
					break;
					case PlayerInfoPhom.ABOVE_USER:
						tempDistance = smallDistance;
					break;
				}
			}
			
			if (positionName == "leavedCardPosition")
				tempDistance = largeDistance_2;
			
			var horizontalDistance:Number;
			var verticalDistance:Number;
			if (!isVertical)
			{
				horizontalDistance = tempDistance;
				verticalDistance = 0;
			}
			else
			{
				horizontalDistance = 0;
				verticalDistance = tempDistance;
			}
			
			var i:int;
			for (i = 1; i < positionNumber; i++) 
			{
				this[positionName][i] = new Object();
				this[positionName][i].x = this[positionName][i - 1].x + horizontalDistance;
				this[positionName][i].y = this[positionName][i - 1].y + verticalDistance;
			}
			
			if (formName == PlayerInfoPhom.BELOW_USER)
			{
				leftLimit = globalToLocal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[0].y));
				rightLimit = globalToLocal(new Point(unLeaveCardPosition[9].x, unLeaveCardPosition[9].y));
			}
		}
		
		public function destroy():void
		{
			removeAllCards();
			unLeaveCardPosition = null;
			leavedCardPosition = null;
			downCardPosition = null;
			
			unLeaveCardSize = 0;
			leavedCardSize = 0;
			downCardSize = 0;
			
			unLeaveCardRotation = 0;
			leavedCardRotation = 0;
			downCardRotation = 0;
			
			timeBar = null;
			content = null;
			formName = null;
			deckNumber = 0;
			totalDownCard = 0;
			
			playerName = null;
			//level = null
			money = null
			homeIcon = null;
			
			invitePlayWindow = null;
			windowLayer = null;
			
			removeCardsArray(unLeaveCards);
			removeCardsArray(leavedCards);
			removeCardsArray(downCards_1);
			removeCardsArray(downCards_2);
			removeCardsArray(downCards_3);
			unLeaveCards = null;
			leavedCards = null;
			downCards_1 = null;
			downCards_2 = null;
			downCards_3 = null;
			
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseUpStage);
			}
			
			if (formName == BELOW_USER)
			{
				for (var i:int = 0; i < buttonArray.length; i++) 
				{
					buttonArray[i].removeEventListener(MouseEvent.CLICK, onButtonClick);
				}
				invitePlayButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
				exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
				
				invitePlayButton = null;
				exitButton = null;
			}
			
			if (parent)
				parent.removeChild(this);
		}
		
		private function getPointByCardType(cardType:String):Point 
		{
			var tempPoint:Point = new Point();
			var tempObject:Object = getUnUsePosition(cardType);
			tempObject["isUsed"] = true;
			tempPoint.x = tempObject.x;
			tempPoint.y = tempObject.y;
			return localToGlobal(tempPoint);
		}
		
		public function getCard():void
		{
			if (cardOfPreviousPlayer) // Tình huống bốc bài trong trường hợp có thể ăn bài thì cho con bài ăn đc dừng nhấp nháy
			{
				cardOfPreviousPlayer.hideTwinkle();
				cardOfPreviousPlayer.buttonMode = false;
				cardOfPreviousPlayer.mouseEnabled = cardOfPreviousPlayer.mouseChildren = false;
				cardOfPreviousPlayer.removeEventListener(MouseEvent.CLICK, onClickStealableCard);
			}
			
			electroServerCommand.getOneCard(userName);
		}
		
		// Sắp xếp lại các quân bài hạ
		public function reArrangeDownCard():void 
		{
			var startX:int;
			var tempPoint:Point;
			var movingType:String = CardManager.OPEN_FINISH_STYLE;
			var i:int;
			
			// Nếu người hạ là người chơi bên trái và bên phải thì hạ dọc
			if (formName == PlayerInfoPhom.LEFT_USER || formName == PlayerInfoPhom.RIGHT_USER)
			{
				if (deckNumber >= 3) // hạ phỏm 3
				{
					for (i = 0; i < downCards_3.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfoPhom.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_3.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y - distanceDeckVertical;
						CardPhom(downCards_3[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 1) // hạ phỏm 1
				{
					for (i = 0; i < downCards_1.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfoPhom.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_1.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						CardPhom(downCards_1[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 2) // hạ phỏm 2
				{
					for (i = 0; i < downCards_2.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfoPhom.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_2.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y + distanceDeckVertical;
						CardPhom(downCards_2[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
			}
			else // Nếu người hạ là người chơi bên trên và bên dưới thì hạ ngang
			{
				// tính toán điểm hạ dựa vào số phỏm và số lượng quân bài tổng của các phỏm - căn vào giữa
				var standardWidth:Number = (new CardPhom()).width * downCardSize;
				startX = downCardPosition.x - ((totalDownCard - deckNumber) * largeDistance_2 + distanceDeckHorizontal * (deckNumber - 1) + standardWidth * deckNumber) / 2 + standardWidth / 2; 
				
				// bắt đầu thực hiện di chuyển
				if (deckNumber >= 1) // hạ phỏm 1
				{
					for (i = 0; i < downCards_1.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						CardPhom(downCards_1[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 2) // hạ phỏm 2
				{
					for (i = 0; i < downCards_2.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + (downCards_1.length - 1) * largeDistance_2 + standardWidth + distanceDeckHorizontal + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						CardPhom(downCards_2[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 3) // hạ phỏm 3
				{
					for (i = 0; i < downCards_3.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + (downCards_1.length + downCards_2.length - 2) * largeDistance_2 + standardWidth * (deckNumber - 1) + distanceDeckHorizontal * (deckNumber - 1) + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						CardPhom(downCards_3[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
			}
		}
		
		private function createSizeAndRotation():void 
		{
			switch (formName) 
			{
				case PlayerInfoPhom.BELOW_USER:
					unLeaveCardSize = belowUserCardSize[CardPhom.UN_LEAVE_CARD];
					leavedCardSize = belowUserCardSize[CardPhom.LEAVED_CARD];
					downCardSize = belowUserCardSize[CardPhom.DOWN_CARD];
					unLeaveCardRotation = belowUserCardRotation[CardPhom.UN_LEAVE_CARD];
					leavedCardRotation = belowUserCardRotation[CardPhom.LEAVED_CARD];
					downCardRotation = belowUserCardRotation[CardPhom.DOWN_CARD];
				break;
				case PlayerInfoPhom.LEFT_USER:
					unLeaveCardSize = leftUserCardSize[CardPhom.UN_LEAVE_CARD];
					leavedCardSize = leftUserCardSize[CardPhom.LEAVED_CARD];
					downCardSize = leftUserCardSize[CardPhom.DOWN_CARD];
					unLeaveCardRotation = leftUserCardRotation[CardPhom.UN_LEAVE_CARD];
					leavedCardRotation = leftUserCardRotation[CardPhom.LEAVED_CARD];
					downCardRotation = leftUserCardRotation[CardPhom.DOWN_CARD];
				break;
				case PlayerInfoPhom.RIGHT_USER:
					unLeaveCardSize = rightUserCardSize[CardPhom.UN_LEAVE_CARD];
					leavedCardSize = rightUserCardSize[CardPhom.LEAVED_CARD];
					downCardSize = rightUserCardSize[CardPhom.DOWN_CARD];
					unLeaveCardRotation = rightUserCardRotation[CardPhom.UN_LEAVE_CARD];
					leavedCardRotation = rightUserCardRotation[CardPhom.LEAVED_CARD];
					downCardRotation = rightUserCardRotation[CardPhom.DOWN_CARD];
				break;
				case PlayerInfoPhom.ABOVE_USER:
					unLeaveCardSize = aboveUserCardSize[CardPhom.UN_LEAVE_CARD];
					leavedCardSize = aboveUserCardSize[CardPhom.LEAVED_CARD];
					downCardSize = aboveUserCardSize[CardPhom.DOWN_CARD];
					unLeaveCardRotation = aboveUserCardRotation[CardPhom.UN_LEAVE_CARD];
					leavedCardRotation = aboveUserCardRotation[CardPhom.LEAVED_CARD];
					downCardRotation = aboveUserCardRotation[CardPhom.DOWN_CARD];
				break;
			}
		}
		
		// Tạo các nút liên quan đến chơi bài
		private function createAllButton():void 
		{
			buttonArray = new Array();
			createButton("getCardButton", "getCardButtonPosition");
			createButton("stealCardButton", "stealCardButtonPosition");
			createButton("arrangeCardButton", "arrangeCardButtonPosition");
			createButton("playCardButton", "getCardButtonPosition");
			createButton("reSelectButton", "stealCardButtonPosition");
			createButton("downCardButton", "getCardButtonPosition");
			createButton("downCardFinishButton", "stealCardButtonPosition");
			createButton("sendCardButton", "getCardButtonPosition");
			createButton("sendCardFinishButton", "stealCardButtonPosition");
		}
		
		// Các nút ngoài chức năng chơi bài
		private function createOtherButton():void
		{
			invitePlayButton = content["invitePlayButton"];
			exitButton = content["exitButton"];
			invitePlayButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
			exitButton.addEventListener(MouseEvent.CLICK, onOtherButtonClick);
		}
		
		private function createButton(buttonName:String,buttonPositionName:String):void
		{
			this[buttonName] = new BigButton();
			
			BigButton(this[buttonName]).setLabel(mainData.init.gameDescription.playingScreen[buttonName]);
			
			BigButton(this[buttonName]).x = content[buttonPositionName].x;
			BigButton(this[buttonName]).y = content[buttonPositionName].y;
			content[buttonPositionName].visible = false;
			
			BigButton(this[buttonName]).addEventListener(MouseEvent.CLICK, onButtonClick);
			
			addChild(this[buttonName]);
			
			buttonArray.push(this[buttonName]);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			if (BigButton(e.currentTarget).enable)
			{
				switch (e.currentTarget) 
				{
					case playCardButton:
						if (currentSelectedCard)
						{
							if (phomLogic.checkPlayCard(currentSelectedCard, unLeaveCards)) // Lá bài đánh hợp lệ
							{
								setMyTurn(DO_NOTHING);
								electroServerCommand.playOneCard(currentSelectedCard.id, getNextPlayer().userName);
								playOneCard(currentSelectedCard.id);
								currentSelectedCard = null;
							}
							else
							{
								showTooltip(mainData.init.gameDescription.playingScreen.playWrongCard);
							}
						}
					break;
					case getCardButton:
						if (cardOfPreviousPlayer) // Tình huống bốc bài trong trường hợp có thể ăn bài thì cho con bài ăn đc dừng nhấp nháy
						{
							cardOfPreviousPlayer.hideTwinkle();
							cardOfPreviousPlayer.buttonMode = false;
							cardOfPreviousPlayer.mouseEnabled = cardOfPreviousPlayer.mouseChildren = false;
							cardOfPreviousPlayer.removeEventListener(MouseEvent.CLICK, onClickStealableCard);
						}
						dispatchEvent(new Event(GET_CARD));
						electroServerCommand.getOneCard(userName);
					break;
					case stealCardButton:
						if (cardOfPreviousPlayer)
						{
							cardOfPreviousPlayer.hideTwinkle();
							cardOfPreviousPlayer.buttonMode = false;
							cardOfPreviousPlayer.mouseEnabled = cardOfPreviousPlayer.mouseChildren = false;
							cardOfPreviousPlayer.removeEventListener(MouseEvent.CLICK, onClickStealableCard);
							dispatchEvent(new Event(STEAL_CARD));
							electroServerCommand.stealCard(userName, cardOfPreviousPlayer.id);
						}
					break;
					case reSelectButton:
						for (var i:int = 0; i < unLeaveCards.length; i++) 
						{
							CardPhom(unLeaveCards[i]).moveToStartPoint();
						}
						reSelectButton.enable = playCardButton.enable = false;
						currentSelectedCard = null;
					break;
					case downCardButton:
						downCardButton.enable = false;
						electroServerCommand.downOneDeck(userName, selectedCardArray);
						selectedCardArray = null;
					break;
					case downCardFinishButton:
						var deckArray:Array = phomLogic.getDeckToAutoDownCard(unLeaveCards);
						var deckIdArray:Array = new Array();
						for (var j:int = 0; j < deckArray.length; j++) 
						{
							var tempArray:Array = new Array();
							deckIdArray.push(tempArray);
							for (var k:int = 0; k < deckArray[j].length; k++) 
							{
								tempArray[k] = CardPhom(deckArray[j][k]).id;
							}
						}
						for (j = 0; j < deckIdArray.length; j++)
						{
							electroServerCommand.downOneDeck(userName, deckIdArray[j]);
						}
						electroServerCommand.downCardFinish(userName);
					break;
					case sendCardButton:
						var sendDeckArray:Array = checkSendCard([currentSelectedCard]);
						electroServerCommand.sendCard(userName, sendDeckArray[0][DataField.USER_NAME], sendDeckArray[0][DataField.INDEX], currentSelectedCard.id);
						sendCardButton.enable = false;
					break;
					case sendCardFinishButton:
						if (!checkSendCard(unLeaveCards)) // Nếu không còn bài để gửi
						{
							electroServerCommand.sendCardFinish(userName);
							setMyTurn(PLAY_CARD);
						}
						else // Nếu còn bài để gửi thì bật bảng xác nhận
						{
							confirmSendCardFinishWindow = new ConfirmWindow();
							confirmSendCardFinishWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmSendCardFinish);
							confirmSendCardFinishWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
							windowLayer.openWindow(confirmSendCardFinishWindow);
						}
					break;
					case arrangeCardButton:
						countArrangeCard++;
						unLeaveCards = phomLogic.arrangeUnleaveCard(unLeaveCards);
						reArrangeUnleaveCard(0, false);
						if (myStatus == DOWN_CARD)
							checkDownCard();
					break;
				}
			}
		}
		
		private function onConfirmWindow(e:Event):void 
		{
			if (e.currentTarget == confirmDownCardFinishWindow)
			{
				downCardFinishButton.enable = false;
				electroServerCommand.downCardFinish(userName);
			}
			else if (e.currentTarget == confirmSendCardFinishWindow)
			{
				electroServerCommand.sendCardFinish(userName);
				setMyTurn(PLAY_CARD);
			}
			else if (e.currentTarget == confirmExitWindow)
			{
				if (stage)
				{
					if (tooltip.parent == stage)
						stage.removeChild(tooltip);
				}
			
				mainData.chooseChannelData.myInfo.money -= Number(mainData.playingData.gameRoomData.roomBet) * 4;
				if (mainData.chooseChannelData.myInfo.money < 0)
					mainData.chooseChannelData.myInfo.money = 0;
					
				exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
				dispatchEvent(new Event(EXIT, true));
				electroServerCommand.joinLobbyRoom();
				EffectLayer.getInstance().removeAllEffect();
			}
		}
		
		public function downCardFinish():void
		{
			if (formName == PlayerInfoPhom.BELOW_USER)
			{
				if (!mainData.playingData.gameRoomData.isSendCard)
				{
					electroServerCommand.sendCardFinish(userName);
					setMyTurn(PLAY_CARD);
					countTime(mainData.init.playTime.playCardTimePhom);
				}
				else if (checkSendCard(unLeaveCards) && deckNumber > 0) // check xem có bài để gửi không
				{
					setMyTurn(SEND_CARD);
				}
				else // nếu không có bài gửi thì bỏ qua luôn phần gửi
				{
					electroServerCommand.sendCardFinish(userName);
					setMyTurn(PLAY_CARD);
				}
			}
			else
			{
				if (mainData.playingData.gameRoomData.isSendCard)
					countTime(mainData.init.playTime.sendCardTime);
				else
					countTime(mainData.init.playTime.playCardTimePhom);
			}
		}
		
		private function onOtherButtonClick(e:MouseEvent):void
		{
			switch (e.currentTarget) 
			{
				case invitePlayButton:
					invitePlayWindow = new InvitePlayWindow();
					windowLayer.openWindow(invitePlayWindow);
				break;
				case exitButton:
					if (isPlaying)
					{
						confirmExitWindow = new ConfirmWindow();
						var st1:String = mainData.init.gameDescription.playingScreen.confirmQuitGa1;
						var st2:String = mainData.init.gameDescription.playingScreen.confirmQuitGa2;
						if (mainData.isPhomGa)
						{
							var myMoneyInGa:String = String(mainData.gaData[DataField.POT_LEVEL] * int(mainData.playingData.gameRoomData.roomBet));
							var confirmGaSentence:String = " " + st1 + " " + myMoneyInGa + " " + st2;
						} 
						if (mainData.isPhomGa)
							confirmExitWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmExit + confirmGaSentence);
						else
							confirmExitWindow.setNotice(mainData.init.gameDescription.playingScreen.confirmExit);
						confirmExitWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
						windowLayer.openWindow(confirmExitWindow);
					}
					else
					{
						if (mainData.isPhomGa && !isNoPlay && mainData.gaData[DataField.POT_LEVEL] != 0)
						{
							confirmExitWindow = new ConfirmWindow();
							st1 = mainData.init.gameDescription.playingScreen.confirmQuitGa3;
							st2 = mainData.init.gameDescription.playingScreen.confirmQuitGa2;
							myMoneyInGa = String(mainData.gaData[DataField.POT_LEVEL] * int(mainData.playingData.gameRoomData.roomBet));
							confirmGaSentence = " " + st1 + " " + myMoneyInGa + " " + st2; 
							confirmExitWindow.setNotice(confirmGaSentence);
							confirmExitWindow.addEventListener(ConfirmWindow.CONFIRM, onConfirmWindow);
							windowLayer.openWindow(confirmExitWindow);
						}
						else
						{
							exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
							dispatchEvent(new Event(EXIT, true));
							electroServerCommand.joinLobbyRoom();
							EffectLayer.getInstance().removeAllEffect();
						}
					}
				break;
			}
		}
		
		// check xem có được hạ bài hay không
		private function checkDownCard():Boolean
		{
			var cardDeck:Array = new Array();
			for (var j:int = 0; j < unLeaveCards.length; j++) 
			{
				if (CardPhom(unLeaveCards[j]).isChoose)
					cardDeck.push(unLeaveCards[j]);
			}
			
			if (phomLogic.checkCardDeck(cardDeck)) // Kiểm tra xem nếu đúng là phỏm thì cho hạ
			{
				selectedCardArray = new Array();
				for (var i:int = 0; i < cardDeck.length; i++) 
				{
					selectedCardArray.push(CardPhom(cardDeck[i]).id);
				}
				downCardButton.enable = true;
			}
			else
			{
				downCardButton.enable = false;
			}
			
			return downCardButton.enable;
		}
		
		private var _isCurrentWinner:Boolean;
		public function set isCurrentWinner(value:Boolean):void 
		{
			_isCurrentWinner = value;
		}
		
		private var _isReadyPlay:Boolean;
		public function set isReadyPlay(value:Boolean):void 
		{
			_isReadyPlay = value;
			if (value)
			{
				if (!isPlaying)
				{
					if (!isRoomMaster)
					{
						readyIcon.scaleX = readyIcon.scaleY = 0;
						content.addChild(readyIcon);
						var tempTween1:GTween = new GTween(readyIcon, effectTime, { scaleX:1, scaleY:1 }, { ease:Back.easeOut } );
					}
				}
			}
			else
			{
				if (content.contains(readyIcon))
				{
					content.removeChild(readyIcon);
					tempTween1 = new GTween(readyIcon, effectTime, { scaleX:0, scaleY:0 }, { ease:Back.easeOut } );
				}
			}
		}
		
		public function get isReadyPlay():Boolean 
		{
			return _isReadyPlay;
		}
		
		private var _isRoomMaster:Boolean;
		public var contextMenuPosition:Point;
		
		public function get isRoomMaster():Boolean 
		{
			return _isRoomMaster;
		}
		
		public function set isRoomMaster(value:Boolean):void 
		{
			_isRoomMaster = value;
			if (value)
			{
				content.addChild(homeIcon);
			}
			else
			{
				if (content.contains(homeIcon))
					content.removeChild(homeIcon);
			}
		}
		
		// Hàm được gọi khi bốc bài thành công
		public function getCardSuccess():void
		{
			if (myStatus != GET_CARD) // tránh trường hợp quá thời gian và tự động đánh, liên quan đến checkAutoPlayCard() trước đó
				return;
			if (leavedCards.length == mainData.cardNumberToDown) // Check xem đến lượt mình hạ chưa
				setMyTurn(DOWN_CARD);
			else
				setMyTurn(PLAY_CARD);
		}
		
		// Hàm dùng để kiểm tra xem user đã quá thời gian chưa, nếu quá thời gian thì đánh tự động luôn
		public function checkAutoPlayCard():void 
		{
			if (myStatus == PLAY_CARD)
				return;
			if (myStatus == DO_NOTHING) // Tình huống user quá thời gian thì tự đánh luôn
			{
				if (leavedCards.length == mainData.cardNumberToDown)
				{
					setMyTurn(DOWN_CARD);
				}
				else
				{
					setMyTurn(DO_NOTHING);
					electroServerCommand.playOneCard(CardPhom(unLeaveCards[unLeaveCards.length - 1]).id, getNextPlayer().userName);
					playOneCard(CardPhom(unLeaveCards[unLeaveCards.length - 1]).id);
					currentSelectedCard = null;
				}
			}
		}
		
		private var _isMyTurn:Boolean;
		
		public function set isMyTurn(value:Boolean):void 
		{
			_isMyTurn = value;
			//if (value)
				//avatar.playingStatus.visible = true;
			//else
				//avatar.playingStatus.visible = false;
		}
		
		private var _isPlaying:Boolean; // Biến cờ thể hiện user đó đang chơi hay không
		private var isNoPlay:Boolean = true;
		public var countArrangeCard:int = 0;
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void 
		{
			_isPlaying = value;
			timeBar.visible = value;
			if (value)
				isNoPlay = false;
			else
				countArrangeCard = 0;
		}
	}

}