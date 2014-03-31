package view.userInfo.playerInfo 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import com.hallopatidu.utils.StringFormatUtils;
	import control.MainCommand;
	import event.DataField;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
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
	import logic.PlayingLogic;
	import logic.TLMNLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import view.button.BigButton;
	import view.card.Card;
	import view.card.CardManager;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.screen.PlayingScreen;
	import view.timeBar.TimeBar;
	import view.userInfo.avatar.Avatar;
	import view.window.AlertWindow;
	import view.window.BaseWindow;
	import view.window.ConfirmWindow;
	import view.window.InvitePlayWindow;
	import view.window.OrderCardWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class PlayerInfo extends Sprite 
	{
		public static const EXIT:String = "exit";
		public static const AVATAR_CLICK:String = "avatarClick";
		
		public static const BELOW_USER:String = "belowUserInfo";
		public static const ABOVE_USER:String = "aboveUserInfo";
		public static const LEFT_USER:String = "leftUserInfo";
		public static const RIGHT_USER:String = "rightUserInfo";
		
		public static const DO_NOTHING:String = "doNothing";
		public static const PLAY_CARD:String = "playCard";
		
		public var unLeaveCardPosition:Array; // vị trí các quân bài chưa đánh
		public var leavedCardPosition:Array; // vị trí các quân bài đã đánh
		public var leavedCardPoint:DisplayObject; // vị trí của PlayingScreen để xác định vị trí của các quân bài đánh ra
		public var downCardPosition:Point; // vị trí để xác định quân bài vừa hạ phỏm
		
		private const belowUserCardSize:Object = {"unLeaveCard":0.73,"leavedCard":0.6,"downCard":0.5}; // kích thước các quân bài của user bên dưới
		private const leftUserCardSize:Object = {"unLeaveCard":0.5,"leavedCard":0.6,"downCard":0.5}; // kích thước các quân bài của user bên trái
		private const rightUserCardSize:Object = {"unLeaveCard":0.5,"leavedCard":0.6,"downCard":0.5}; // kích thước các quân bài của user bên phải
		private const aboveUserCardSize:Object = { "unLeaveCard":0.5, "leavedCard":0.6, "downCard":0.5 }; // kích thước các quân bài của user bên trên
		
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
		
		private const smallDistance:Number = 5; // khoảng cách giữa các quân bài chưa đánh của user trái,phải,trên
		private const largeDistance:Number = 29; // khoảng cách giữa các quân bài chưa đánh của user chính
		private const largeDistance_2:Number = 10; // khoảng cách giữa các quân bài đã đánh, hoặc đã hạ
		
		public var unLeaveCards:Array; // Mảng chứa các lá bài chưa đánh
		public var leavedCards:Array; // Mảng chứa các lá bài đã đánh
		public var downCards_1:Array; // Mảng chứa các lá bài của phỏm 1
		public var downCards_2:Array; // Mảng chứa các lá bài của phỏm 2
		public var downCards_3:Array; // Mảng chứa các lá bài của phỏm 3
		
		public var arrangeCardButton:BigButton; // Nút xếp bài
		private var playCardButton:BigButton; // Nút đánh bài
		private var reSelectCardButton:BigButton; // Nút chọn lại
		private var passButton:BigButton; // Nút hạ bài
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
		
		public var currentSelectedCardArray:Array; // mảng các lá bài đang được chọn
		public var currentDraggingCard:Card; // lá bài đang được kéo
		public var currentSwapCard:Card; // lá bài sẽ được đổi vị trị với lá bài được kéo
		public var cardOfPreviousPlayer:Card; // lá bài vừa đánh của người chơi trước mình
		public var isHaveUserDownCard:Boolean; // Biến cờ đánh dấu xem đã có user nào trước đó hạ bài hay chưa
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var tlmnLogic:TLMNLogic = TLMNLogic.getInstance();
		
		private var leftLimit:Point; // Giới hạn di chuyển phía trái, khi drag quân bài về phía trái không thể dịch quá giới hạn này
		private var rightLimit:Point; // Giới hạn di chuyển phía phải, khi drag quân bài về phía phải không thể dịch quá giới hạn này
		
		private var invitePlayButton:SimpleButton; // Nút mời chơi
		private var exitButton:SimpleButton; // Nút thoát
		
		private var invitePlayWindow:InvitePlayWindow; // Cửa sổ mời chơi
		private var orderCardWindow:OrderCardWindow; // Cửa sổ order bài
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
		
		public function PlayerInfo() 
		{
			unLeaveCards = new Array();
			leavedCards = new Array();
			downCards_1 = new Array();
			downCards_2 = new Array();
			downCards_3 = new Array();
			//cacheAsBitmap = true;
		}
		
		private function addAvatar():void 
		{
			if (!avatar)
			{				
				avatar = new Avatar();
				if (formName == PlayerInfo.BELOW_USER)
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
			if (formName == PlayerInfo.BELOW_USER)
			{
				tooltip = content["tooltip"];
				TextField(tooltip["description"]).selectable = false;
				hideToolTip();
			}
			content.removeChild(readyIcon);
		}
		
		public function showTooltip(description:String):void
		{
			if (formName != PlayerInfo.BELOW_USER)
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
			if (formName != PlayerInfo.BELOW_USER)
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
				case PlayerInfo.BELOW_USER:
					addContent(1);
					createAllButton();
					createOtherButton();
				break;
				case PlayerInfo.LEFT_USER:
					addContent(2);
				break;
				case PlayerInfo.RIGHT_USER:
					addContent(3);
				break;
				case PlayerInfo.ABOVE_USER:
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
			currentSelectedCardArray = null;
			currentDraggingCard = null;
			currentSwapCard = null;
			_isPlaying = false;
			isWaitingToReady = false;
			
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 13); // tạo vị trí cho quân bài chưa đánh
			createPosition("leavedCardPosition", "leavedCardPosition", 4); // tạo vị trí cho quân bài đã đánh
			
		}
		
		public function getUnUsePosition(positionType:String):Object
		{
			var tempPositionArray:Array;
			switch (positionType) 
			{
				case Card.UN_LEAVE_CARD:
					tempPositionArray = unLeaveCardPosition;
				break;
				case Card.LEAVED_CARD:
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
		
		public function getCardById(cardType:String,cardId:int):Card
		{
			var cardArray:Array;
			switch (cardType) 
			{
				case Card.UN_LEAVE_CARD:
					cardArray = unLeaveCards;
				break;
				case Card.LEAVED_CARD:
					cardArray = leavedCards;
				break;
			}
			
			var i:int;
			for (i = 0; i < cardArray.length; i++) 
			{
				if (cardArray[i].id == cardId) 
				{
					var card:Card = cardArray[i];
					//cardArray.splice(i, 1);
					return card;
				}
			}
			trace("Không có quân bài nào có giá trị là " + cardId);
			return cardArray[cardArray.length - 1];
		}
		
		public function playCard(cardValues:Array):void
		{
			var tempPoint:Point;
			var tempCardInfo:Array;
			var movingType:String;
			var tempCard:Card;
			movingType = CardManager.OPEN_FINISH_STYLE;
			
			leavedCardPosition = new Array();
			tempPoint = parent.localToGlobal(new Point(leavedCardPoint.x, leavedCardPoint.y));
			tempPoint = globalToLocal(tempPoint);
			var totalWidth:Number = Card(new Card()).width * leavedCardSize + (cardValues.length - 1) * 10; 
			for (var i:int = 0; i < cardValues.length; i++) 
			{
				leavedCardPosition[i] = new Object();
				leavedCardPosition[i]["isUsed"] = false;
				leavedCardPosition[i].x =  tempPoint.x - totalWidth / 2 + i * 13;
				leavedCardPosition[i].y = tempPoint.y;
			}
			
			for (i = 0; i < cardValues.length; i++) 
			{
				// tìm quân bài cần đánh
				tempCard = getCardById(Card.UN_LEAVE_CARD, cardValues[i]);
				
				// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
				tempPoint = getPointByCardType(Card.LEAVED_CARD);
				
				// gọi hàm di chuyển
				tempCard.moving(tempPoint, CardManager.playCardTime , movingType, leavedCardSize);
				
				moveUnleaveToLeavedCard(cardValues[i]);
			}
		}
		
		public function checkEndRound():void
		{
			if (myStatus == PLAY_CARD)
				passButton.enable = !mainData.isEndRound;
		}
		
		// Xét đến lượt mình đánh
		public function setMyTurn(status:String):void
		{
			myStatus = status;
			playCardButton.enable = false;
			passButton.enable = false;
			hideToolTip();
			switch (status) 
			{
				case PlayerInfo.DO_NOTHING:
					timeBar.stopCountTime();
				break;
				case PlayerInfo.PLAY_CARD:
					if (mainData.isFirstPlay)
						passButton.enable = false;
					else
						passButton.enable = !mainData.isEndRound;
					if (countShowTooltipPlayCard == 0)
					{
						//showTooltip(mainData.init.gameDescription.playingScreen.playCard);
						countShowTooltipPlayCard++;
					}
					currentSelectedCardArray = new Array();
					for (var j:int = 0; j < unLeaveCards.length; j++) // Kiểm tra xem đang có lá bài nào được chọn để enable nút đánh
					{
						if (Card(unLeaveCards[j]).isChoose)
							currentSelectedCardArray.push(unLeaveCards[j]);
					}
				break;
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
				Card(unLeaveCards[i]).effectOpen();
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
				if (Card(unLeaveCards[i]).id == cardId)
				{
					if (!leavedCards)
						leavedCards = new Array();
					leavedCards.push(unLeaveCards[i]);
					Card(unLeaveCards[i]).isMouseInteractive = false;
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
				if (Card(unLeaveCards[i]).id == cardId)
					return;
			}
			for (i = unLeaveCards.length - 1; i >= 0; i--) // Nếu chưa có thì gán giá trị quân bài mới vào
			{
				if (Card(unLeaveCards[i]).id == 0)
				{
					Card(unLeaveCards[i]).setId(cardId);
					i = -1;
				}
			}
		}
		
		private function onMouseDownCard(e:MouseEvent):void 
		{
			if (!stage)
				return;
			currentDraggingCard = e.currentTarget as Card;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			var point_1:Point = localToGlobal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[0].y));
			point_1 = Card(e.currentTarget).parent.globalToLocal(point_1);
			var point_2:Point = localToGlobal(new Point(unLeaveCardPosition[12].x, unLeaveCardPosition[12].y));
			point_2 = Card(e.currentTarget).parent.globalToLocal(point_2);
			Card(e.currentTarget).startDrag(false, new Rectangle(point_1.x, point_1.y - Card(e.currentTarget).height / 3, Math.abs(point_2.x - point_1.x) + 35, Card(e.currentTarget).height / 3 * 2));
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
					var tempCard:Card = unLeaveCards[index_2];
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
				Card(unLeaveCards[i]).stopDrag();
				var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, 5, 5, 10, 1);
				if(Card(unLeaveCards[i]).isStealCard)
					Card(unLeaveCards[i]).filters = [filterTemp];
				else
					Card(unLeaveCards[i]).filters = null;
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
				Card(unLeaveCards[i]).parent.addChild(unLeaveCards[i]);
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
			if (formName != PlayerInfo.BELOW_USER)
				return;
			hideToolTip();
				
			if (!currentSelectedCardArray)
				currentSelectedCardArray = new Array();
			currentSelectedCardArray.push(e.currentTarget);
			
			if (myStatus != DO_NOTHING)
			{
				reSelectCardButton.enable = true;
				checkEnablePlayCard();
			}
		}
		
		private function getPreviousPlayer():PlayerInfo
		{
			var previousPlayer:PlayerInfo;
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (PlayerInfo(playingPlayerArray[i]).userName == userName)
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
		
		private function getNextPlayer():PlayerInfo
		{
			var nextPlayer:PlayerInfo;
			for (var i:int = 0; i < playingPlayerArray.length; i++)
			{
				if (PlayerInfo(playingPlayerArray[i]).userName == userName)
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
			if (formName != PlayerInfo.BELOW_USER)
				return;
			if (!currentSelectedCardArray)
				return;
			
			if (myStatus != DO_NOTHING)
			{
				// Bớt đi lá bài vừa được bỏ chọn khỏi mảng các lá đang đc chọn
				for (var j:int = 0; j < currentSelectedCardArray.length; j++)
				{
					if (currentSelectedCardArray[j] == e.currentTarget)
					{
						currentSelectedCardArray.splice(j, 1);
						if (currentSelectedCardArray.length == 0)
						{
							reSelectCardButton.enable = false;
							currentSelectedCardArray = null;
							playCardButton.enable = false;
							return;
						}
						j = currentSelectedCardArray.length + 1;
					}
				}
				checkEnablePlayCard();
			}
		}
		
		public function checkEnablePlayCard():void
		{
			if (myStatus != PLAY_CARD)
				return;
			var myCardsValue:Array = new Array();
			for (var i:int = 0; i < currentSelectedCardArray.length; i++) 
			{
				myCardsValue.push(Card(currentSelectedCardArray[i]).id);
			}
			
			if (mainData.isFirstPlay) // Mình là người đánh đầu tiên của ván
			{
				// Nếu mình là ng đánh đầu tiên thì quân bài hoặc bộ bài mình đánh phải có quân bài có giá trị nhỏ nhất
				var cardId:int = tlmnLogic.findSmallestCard(unLeaveCards).id;
				var isHaveSmallestCard:Boolean;
				for (var j:int = 0; j < myCardsValue.length; j++) 
				{
					if (cardId == myCardsValue[j])
						isHaveSmallestCard = true;
				}
				if (isHaveSmallestCard)
				{
					if (myCardsValue.length == 1)
					{
						playCardButton.enable = true;
					}
					else // trường hợp đánh bộ bài thì check xem có đúng là bộ bài ko
					{
						if (tlmnLogic.getNameFromDeck(myCardsValue) != TLMNLogic.NOT_RELATION)
							playCardButton.enable = true;
						else
							playCardButton.enable = false;
					}
				}
				else
				{
					playCardButton.enable = false;
				}
			}
			else
			{
				if (tlmnLogic.compareTwoDeck(myCardsValue, mainData.lastCardValues) == 1)
					playCardButton.enable = true;
				else
					playCardButton.enable = false;
			}
		}
		
		// Lấy một lá bài ra khỏi các quân bài đã đánh - dùng cho việc người khác ăn quân bài của mình
		public function popOneLeavedCard(cardId:int):Card
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
			var card:Card;
			if (cardId == 0)
			{
				return leavedCards.pop();
			}
			for (i = 0; i < leavedCards.length; i++) 
			{
				if (Card(leavedCards[i]).id == cardId)
				{
					card = Card(leavedCards[i]);
					leavedCards.splice(i, 1);
					return card;
				}
			}
			return card;
		}
		
		// push thêm một lá bài vào các quân bài đã đánh - dùng trong trường hợp mình bị ng khác ăn bài, và chuyển bài từ chỗ khác vào bài mình đã đánh
		public function pushNewLeavedCard(card:Card, time:Number = 0):void
		{
			if (time == 0)
				time = CardManager.playCardTime;
			if (!leavedCards)
				leavedCards = new Array();
			leavedCards.push(card);
			card.isMouseInteractive = false;
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(Card.LEAVED_CARD);
			
			// gọi hàm di chuyển
			card.moving(tempPoint, time , CardManager.TURN_OVER_STYLE, leavedCardSize);
		}
		
		public function removeCardsArray(cardsArray:Array):void
		{
			var i:int;
			for (i = 0; i < cardsArray.length; i++) 
			{
				if (cardsArray[i])
				{
					if (cardsArray[i] is Card)
					{
						Card(cardsArray[i]).removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
						Card(cardsArray[i]).removeEventListener(Card.IS_SELECTED, onCardIsSelected);
						Card(cardsArray[i]).removeEventListener(Card.IS_DE_SELECTED, onCardIsDeSelected);
						Card(cardsArray[i]).destroy();
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
			
			currentSelectedCardArray = null;
			if (playCardButton)
				playCardButton.enable = false;
			
			switch (formName) 
			{
				case PlayerInfo.BELOW_USER:
					scaleNumber = belowUserCardSize[Card.UN_LEAVE_CARD];
				break;
				case PlayerInfo.LEFT_USER:
					scaleNumber = leftUserCardSize[Card.UN_LEAVE_CARD];
				break;
				case PlayerInfo.RIGHT_USER:
					scaleNumber = rightUserCardSize[Card.UN_LEAVE_CARD];
				break;
				case PlayerInfo.ABOVE_USER:
					scaleNumber = aboveUserCardSize[Card.UN_LEAVE_CARD];
				break;
			}
			
			for (i = 0; i < unLeaveCardPosition.length; i++) 
			{
				unLeaveCardPosition[i]["isUsed"] = false;
			}
			
			var tempPoint:Point;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				tempPoint = getPointByCardType(Card.UN_LEAVE_CARD);
				Card(unLeaveCards[i]).isChoose = false;
				if (isRotate)
				{
					Card(unLeaveCards[i]).moving(tempPoint, time, CardManager.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation);
				}
				else
				{
					Card(unLeaveCards[i]).moving(tempPoint, time, CardManager.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation, true, true, false);
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
					className = "zPlayUserProfileForm_1";
				break;
				case 2:
					className = "zPlayUserProfileForm_2";
				break;
				case 3:
					className = "zPlayUserProfileForm_3";
				break;
				case 4:
					className = "zPlayUserProfileForm_4";
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
				case PlayerInfo.BELOW_USER:
					_type = 3;
				break;
				case PlayerInfo.LEFT_USER:
				case PlayerInfo.RIGHT_USER:
					_type = 1;
				break;
				case PlayerInfo.ABOVE_USER:
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
			if (formName != PlayerInfo.BELOW_USER)
				return;
			switch (myStatus) 
			{
				case PLAY_CARD:
					setMyTurn(DO_NOTHING);
					if (!unLeaveCards)
						return;
					if (unLeaveCards.length == 0)
						return;
					
					if (mainData.lastCardValues.length == 0) // nếu mình là người đánh bài đầu tiên hoặc mình mở đầu 1 lượt đánh mới
					{
						var cardId:int = tlmnLogic.findSmallestCard(unLeaveCards).id;
						playCard([cardId]);
						electroServerCommand.playCard([cardId]);
					}
					else
					{
						electroServerCommand.nextTurn();
					}
					currentSelectedCardArray = null;
				break;
				case DO_NOTHING: 
					
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
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 13); // tạo vị trí cho quân bài chưa đánh
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
					case PlayerInfo.BELOW_USER:
						tempDistance = largeDistance;
					break;
					case PlayerInfo.LEFT_USER:
					case PlayerInfo.RIGHT_USER:
						isVertical = true;
					break;
					case PlayerInfo.ABOVE_USER:
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
			
			if (formName == PlayerInfo.BELOW_USER)
			{
				leftLimit = globalToLocal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[0].y));
				rightLimit = globalToLocal(new Point(unLeaveCardPosition[12].x, unLeaveCardPosition[12].y));
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
		
		// Sắp xếp lại các quân bài hạ
		public function reArrangeDownCard():void 
		{
			var startX:int;
			var tempPoint:Point;
			var movingType:String = CardManager.OPEN_FINISH_STYLE;
			var i:int;
			
			// Nếu người hạ là người chơi bên trái và bên phải thì hạ dọc
			if (formName == PlayerInfo.LEFT_USER || formName == PlayerInfo.RIGHT_USER)
			{
				if (deckNumber >= 3) // hạ phỏm 3
				{
					for (i = 0; i < downCards_3.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfo.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_3.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y - distanceDeckVertical;
						Card(downCards_3[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 1) // hạ phỏm 1
				{
					for (i = 0; i < downCards_1.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfo.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_1.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						Card(downCards_1[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 2) // hạ phỏm 2
				{
					for (i = 0; i < downCards_2.length; i++) 
					{
						tempPoint = new Point();
						if(formName == PlayerInfo.LEFT_USER)
							tempPoint.x = downCardPosition.x + i * largeDistance_2;
						else
							tempPoint.x = downCardPosition.x - (downCards_2.length - i) * largeDistance_2;
						tempPoint.y = downCardPosition.y + distanceDeckVertical;
						Card(downCards_2[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
			}
			else // Nếu người hạ là người chơi bên trên và bên dưới thì hạ ngang
			{
				// tính toán điểm hạ dựa vào số phỏm và số lượng quân bài tổng của các phỏm - căn vào giữa
				var standardWidth:Number = (new Card()).width * downCardSize;
				startX = downCardPosition.x - ((totalDownCard - deckNumber) * largeDistance_2 + distanceDeckHorizontal * (deckNumber - 1) + standardWidth * deckNumber) / 2 + standardWidth / 2; 
				
				// bắt đầu thực hiện di chuyển
				if (deckNumber >= 1) // hạ phỏm 1
				{
					for (i = 0; i < downCards_1.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						Card(downCards_1[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 2) // hạ phỏm 2
				{
					for (i = 0; i < downCards_2.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + (downCards_1.length - 1) * largeDistance_2 + standardWidth + distanceDeckHorizontal + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						Card(downCards_2[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
				
				if (deckNumber >= 3) // hạ phỏm 3
				{
					for (i = 0; i < downCards_3.length; i++) 
					{
						tempPoint = new Point();
						tempPoint.x = startX + (downCards_1.length + downCards_2.length - 2) * largeDistance_2 + standardWidth * (deckNumber - 1) + distanceDeckHorizontal * (deckNumber - 1) + i * largeDistance_2;
						tempPoint.y = downCardPosition.y;
						Card(downCards_3[i]).moving(localToGlobal(tempPoint), CardManager.downCardTime, movingType, downCardSize, downCardRotation);
					}
				}
			}
		}
		
		private function createSizeAndRotation():void 
		{
			switch (formName) 
			{
				case PlayerInfo.BELOW_USER:
					unLeaveCardSize = belowUserCardSize[Card.UN_LEAVE_CARD];
					leavedCardSize = belowUserCardSize[Card.LEAVED_CARD];
					downCardSize = belowUserCardSize[Card.DOWN_CARD];
					unLeaveCardRotation = belowUserCardRotation[Card.UN_LEAVE_CARD];
					leavedCardRotation = belowUserCardRotation[Card.LEAVED_CARD];
					downCardRotation = belowUserCardRotation[Card.DOWN_CARD];
				break;
				case PlayerInfo.LEFT_USER:
					unLeaveCardSize = leftUserCardSize[Card.UN_LEAVE_CARD];
					leavedCardSize = leftUserCardSize[Card.LEAVED_CARD];
					downCardSize = leftUserCardSize[Card.DOWN_CARD];
					unLeaveCardRotation = leftUserCardRotation[Card.UN_LEAVE_CARD];
					leavedCardRotation = leftUserCardRotation[Card.LEAVED_CARD];
					downCardRotation = leftUserCardRotation[Card.DOWN_CARD];
				break;
				case PlayerInfo.RIGHT_USER:
					unLeaveCardSize = rightUserCardSize[Card.UN_LEAVE_CARD];
					leavedCardSize = rightUserCardSize[Card.LEAVED_CARD];
					downCardSize = rightUserCardSize[Card.DOWN_CARD];
					unLeaveCardRotation = rightUserCardRotation[Card.UN_LEAVE_CARD];
					leavedCardRotation = rightUserCardRotation[Card.LEAVED_CARD];
					downCardRotation = rightUserCardRotation[Card.DOWN_CARD];
				break;
				case PlayerInfo.ABOVE_USER:
					unLeaveCardSize = aboveUserCardSize[Card.UN_LEAVE_CARD];
					leavedCardSize = aboveUserCardSize[Card.LEAVED_CARD];
					downCardSize = aboveUserCardSize[Card.DOWN_CARD];
					unLeaveCardRotation = aboveUserCardRotation[Card.UN_LEAVE_CARD];
					leavedCardRotation = aboveUserCardRotation[Card.LEAVED_CARD];
					downCardRotation = aboveUserCardRotation[Card.DOWN_CARD];
				break;
			}
		}
		
		// Tạo các nút liên quan đến chơi bài
		private function createAllButton():void 
		{
			buttonArray = new Array();
			createButton("playCardButton", "playCardButtonPosition");
			createButton("passButton", "passButtonPosition");
			createButton("reSelectCardButton", "reSelectCardButtonPosition");
			createButton("arrangeCardButton", "arrangeCardButtonPosition");
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
						if (currentSelectedCardArray)
						{
							if (tlmnLogic.checkPlayCard(currentSelectedCardArray, mainData.lastCardValues)) // Lá bài đánh hợp lệ
							{
								setMyTurn(DO_NOTHING);
								var cardValues:Array = new Array();
								for (var j:int = 0; j < currentSelectedCardArray.length; j++) 
								{
									cardValues.push(currentSelectedCardArray[j].id);
								}
								playCard(cardValues);
								mainData.isFirstPlay = false;
								electroServerCommand.playCard(cardValues);
								currentSelectedCardArray = null;
							}
							else
							{
								showTooltip(mainData.init.gameDescription.playingScreen.playWrongCard);
							}
						}
					break;
					case reSelectCardButton:
						for (var i:int = 0; i < unLeaveCards.length; i++) 
						{
							Card(unLeaveCards[i]).moveToStartPoint();
						}
						reSelectCardButton.enable = playCardButton.enable = false;
						currentSelectedCardArray = null;
					break;
					case arrangeCardButton:
						countArrangeCard++;
						unLeaveCards = tlmnLogic.arrangeUnleaveCard(unLeaveCards);
						reArrangeUnleaveCard(0, false);
					break;
					case passButton:
						setMyTurn(DO_NOTHING);
						electroServerCommand.nextTurn();
					break;
				}
			}
		}
		
		private function onConfirmWindow(e:Event):void 
		{
			if (e.currentTarget == confirmExitWindow)
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
			else if (e.currentTarget == orderCardWindow)
			{
				isReadyPlay = true;
				invitePlayWindow = new InvitePlayWindow();
				windowLayer.openWindow(invitePlayWindow);
			}
		}
		
		private function onOtherButtonClick(e:MouseEvent):void
		{
			switch (e.currentTarget) 
			{
				case invitePlayButton:
					if (mainData.isHaveOrderCard)
					{
						orderCardWindow = new OrderCardWindow();
						orderCardWindow.addEventListener(OrderCardWindow.CONFIRM_ORDER_CARD, onConfirmWindow);
						windowLayer.openWindow(orderCardWindow);
					}
					else
					{
						invitePlayWindow = new InvitePlayWindow();
						windowLayer.openWindow(invitePlayWindow);
					}
				break;
				case exitButton:
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
		
		private var _isReadyPlay:Boolean;
		public function set isReadyPlay(value:Boolean):void 
		{
			_isReadyPlay = value;
			if (value)
			{
				if (!isPlaying)
				{
					//stopCountTime();
					//hideToolTip();
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
		
		// push new card vào mảng các lá bài chưa đánh
		public function pushNewUnLeaveCard(card:Card):void
		{
			if (!unLeaveCards)
				unLeaveCards = new Array();
			unLeaveCards.push(card);
			card.isMouseInteractive = isCardInteractive;
			
			if (isCardInteractive)
			{
				card.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.addEventListener(Card.IS_SELECTED, onCardIsSelected);
				card.addEventListener(Card.IS_DE_SELECTED, onCardIsDeSelected);
			}
			else
			{
				card.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.removeEventListener(Card.IS_SELECTED, onCardIsSelected);
				card.removeEventListener(Card.IS_DE_SELECTED, onCardIsDeSelected);
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