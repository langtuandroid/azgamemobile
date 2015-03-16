package view.userInfo.playerInfo 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import com.hallopatidu.utils.StringFormatUtils;
	import control.MainCommand;
	import event.DataFieldMauBinh;
	import flash.display.MovieClip;
	import flash.display.Shape;
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
	import logic.MauBinhLogic;
	import logic.PlayingLogic;
	import model.MainData;
	import model.modelField.ModelField;
	import view.BubbleChat;
	import view.button.BigButton;
	import view.card.CardMauBinh;
	import view.card.CardManagerMauBinh;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.screen.PlayingScreenMauBinh;
	import view.timeBar.TimeBarMauBinh;
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
	public class PlayerInfoMauBinh extends Sprite 
	{
		public static const EXIT:String = "exit";
		public static const AVATAR_CLICK:String = "avatarClick";
		public static const UPDATE_THREE_GROUP:String = "updateThreeGroup";
		
		public static const BELOW_USER:String = "belowUserInfo";
		public static const ABOVE_USER:String = "aboveUserInfo";
		public static const LEFT_USER:String = "leftUserInfo";
		public static const RIGHT_USER:String = "rightUserInfo";
		
		public var unLeaveCardPosition:Array; // vị trí các quân bài chưa đánh
		public var downCardPosition:Point; // vị trí để xác định quân bài vừa hạ phỏm
		
		private const belowUserCardSize:Object = {"unLeaveCard":1, "downCard":1}; // kích thước các quân bài của user bên dưới
		private const leftUserCardSize:Object = {"unLeaveCard":0.71, "downCard":0.71}; // kích thước các quân bài của user bên trái
		private const rightUserCardSize:Object = {"unLeaveCard":0.71, "downCard":0.71}; // kích thước các quân bài của user bên phải
		private const aboveUserCardSize:Object = { "unLeaveCard":0.71, "downCard":0.71 }; // kích thước các quân bài của user bên trên
		
		private const belowUserCardRotation:Object = {"unLeaveCard":0, "downCard":0}; // góc quay của các quân bài của user bên dưới
		private const leftUserCardRotation:Object = {"unLeaveCard":0, "downCard":0}; // góc quay của các quân bài của user bên trái
		private const rightUserCardRotation:Object = {"unLeaveCard":0, "downCard":0}; // góc quay của các quân bài của user bên phải
		private const aboveUserCardRotation:Object = { "unLeaveCard":0, "downCard":0 }; // góc quay của các quân bài của user bên trên
		
		public var unLeaveCardSize:Number;
		public var downCardSize:Number;
		
		public var unLeaveCardRotation:Number;
		public var downCardRotation:Number;
		
		private var content:Sprite;
		public var formName:String;
		public var ip:String;
		
		private const smallDistance:Number = 11.5; // khoảng cách giữa các quân bài kích thước nhỏ
		private const normalDistance:Number = 12.5; // khoảng cách giữa các quân bài kích thước vừa
		private const largeDistance:Number = 121.5; // khoảng cách giữa các quân bài kích thước to
		private const largeDistance_2:Number = 15; // khoảng cách giữa các quân bài đã đánh
		private const largeDistance_3:Number = 14; // khoảng cách giữa các quân bài đã hạ
		
		public var unLeaveCards:Array; // Mảng chứa các lá bài chưa đánh
		public var downCards_1:Array; // Mảng chứa các lá bài của phỏm 1
		
		public var arrangeFinishButton:SimpleButton; // Nút xếp bài
		public var reArrangeButton:SimpleButton; // Nút xếp bài lại
		private var buttonArray:Array; // mảng chứa tất cả các nút
		
		private var mainData:MainData = MainData.getInstance();
		
		private var playerName:TextField;
		private var money:TextField;
		private var level:TextField;
		private var levelIcon:MovieClip;
		private var deviceIcon:MovieClip;
		private var homeIcon:Sprite;
		private var readyIcon:Sprite;
		private var arrangeFinishIcon:Sprite;
		public var moneyNumber:Number;
		public var levelNumber:Number;
		public var groupStatus:MovieClip;
		public var winLoseIcon:MovieClip;
		public var giveUpIcon:MovieClip;
		
		public var cardInfoArray:Array;
		
		public var isCardInteractive:Boolean; // Biến để xác định xem có cho tương tác vào quân bài của người chơi này không
		
		public var position:int; // vị trí của người chơi, quyết định thứ tự chia bài
		public var userName:String; // id của người chơi
		public var displayName:String; // id của người chơi
		
		public var resultEffectPosition:Point;
		public var moneyEffectPosition:Point;
		public var groupResultEffectPosition:Point;
		
		private var avatar:Avatar;
		private var selectedCardArray:Array;
		
		public var currentSelectedCard:CardMauBinh; // lá bài đang được chọn
		public var currentDraggingCard:CardMauBinh; // lá bài đang được kéo
		public var currentSwapCard:CardMauBinh; // lá bài sẽ được đổi vị trị với lá bài được kéo
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		
		private var leftLimit:Point; // Giới hạn di chuyển phía trái, khi drag quân bài về phía trái không thể dịch quá giới hạn này
		private var rightLimit:Point; // Giới hạn di chuyển phía phải, khi drag quân bài về phía phải không thể dịch quá giới hạn này
		
		private var exitButton:SimpleButton; // Nút thoát
		
		private var invitePlayWindow:InvitePlayWindow; // Cửa sổ mời chơi
		private var orderCardWindow:OrderCardWindow; // Cửa sổ order bài
		private var windowLayer:WindowLayer = WindowLayer.getInstance(); // windowLayer để mở cửa sổ bất kỳ
		
		private const effectTime:Number = 0.5;
		public var playingPlayerArray:Array; // Danh sách những người đang chơi
		
		public var isWaitingToReady:Boolean;
		private var confirmExitWindow:ConfirmWindow; // Bảng xác nhận thoát ra khỏi phòng
		
		public var deckRank:Array; // Mảng để lưu cấp đọ của các chi
		
		public var binhlungIcon:Sprite;
		public var sex:String;
		
		private var bubbleChat:BubbleChat;
		private var timerToHideBubbleChat:Timer;
		
		public function PlayerInfoMauBinh() 
		{
			unLeaveCards = new Array();
			downCards_1 = new Array();
			maubinhLogic = new MauBinhLogic();
			deckRank = new Array();
			deckRank[0] = -1;
		}
		
		public function showEmo(emoType:int):void
		{
			if (timerToHideEmo)
			{
				timerToHideEmo.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideEmo);
				timerToHideEmo.stop();
			}
			if (emo)
			{
				if (emo.parent)
					emo.parent.removeChild(emo);
			}
			var tempClass:Class;
			tempClass = Class(getDefinitionByName("Emo" + String(emoType)));
			emo = Sprite(new tempClass());
			emo.x = content["emoPosition"].x;
			emo.y = content["emoPosition"].y;
			addChild(emo);
			timerToHideEmo = new Timer(5000, 1);
			timerToHideEmo.addEventListener(TimerEvent.TIMER_COMPLETE, onHideEmo);
			timerToHideEmo.start();
		}
		
		private function onHideEmo(e:TimerEvent):void 
		{
			if (!stage)
				return;
			if (emo)
			{
				if (emo.parent)
					emo.parent.removeChild(emo);
			}
		}
		
		public function updateMoneyNumber(value:Number):void
		{	
			moneyNumber = value;
			
			if(formName == PlayerInfoMauBinh.BELOW_USER) // Nếu là user của mình thì cập nhật lại tiền cho phòng chờ và phòng chọn kênh
				mainData.chooseChannelData.myInfo.money = value;
		}
		
		public function hightlineGroup(groupIndex:int):void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardMauBinh(unLeaveCards[i]).overLayer.visible = true;
			}
			
			var startIndex:int;
			var endIndex:int;
			
			switch (groupIndex) 
			{
				case 1:
					startIndex = 8;
					endIndex = 12;
				break;
				case 2:
					startIndex = 3;
					endIndex = 7;
				break;
				case 3:
					startIndex = 0;
					endIndex = 2;
				break;
			}
			
			for (i = startIndex; i <= endIndex; i++)
			{
				CardMauBinh(unLeaveCards[i]).overLayer.visible = false;
				CardMauBinh(unLeaveCards[i]).effectOpen();
			}
		}
		
		public function removeHightline():void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardMauBinh(unLeaveCards[i]).overLayer.visible = false;
			}
		}
		
		public function showAt():void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (maubinhLogic.checkIsAce(CardMauBinh(unLeaveCards[i]).id))
					CardMauBinh(unLeaveCards[i]).overLayer.visible = false;
				else
					CardMauBinh(unLeaveCards[i]).overLayer.visible = true;
			}
		}
		
		private function addAvatar():void 
		{
			if (!avatar)
			{				
				avatar = new Avatar();
				avatar.setForm(Avatar.MY_AVATAR);
			}
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			content["avatarPosition"].visible = false;
			content.addChild(avatar);
			
			//if (formName != BELOW_USER)
			//{
				avatar.buttonMode = true;
				avatar.addEventListener(MouseEvent.CLICK, onAvatarClick);
			//}
		}
		
		private function onAvatarClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(AVATAR_CLICK));
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
		
		private function setupPersonalInfo():void 
		{
			playerName = content["playerName"];
			levelIcon = content["levelIcon"];
			level = levelIcon["levelTxt"];
			deviceIcon = content["deviceIcon"];
			deviceIcon.gotoAndStop("none");
			money = content["money"];
			money.autoSize = TextFieldAutoSize.CENTER;
			playerName.text = '';
			money.text = '';
			level.text = '';
			playerName.selectable = money.selectable = false;
			homeIcon = content["homeIcon"];
			content.removeChild(homeIcon);
			readyIcon = content["readyIcon"];
			arrangeFinishIcon = content["arrangeFinishIcon"];
			arrangeFinishIcon.visible = false;
			
			binhlungIcon = content["binhlungIcon"];
			binhlungIcon.visible = false;
			
			content.removeChild(readyIcon);
		}
		
		public function setForm(_formName:String):void
		{
			formName = _formName;
			createSizeAndRotation();
			switch (formName) 
			{
				case PlayerInfoMauBinh.BELOW_USER:
					case PlayerInfoMauBinh.BELOW_USER:
					addContent(1);
					createAllButton();
					createOtherButton();
				break;
				break;
				case PlayerInfoMauBinh.LEFT_USER:
					addContent(2);
				break;
				case PlayerInfoMauBinh.RIGHT_USER:
					addContent(3);
				break;
				case PlayerInfoMauBinh.ABOVE_USER:
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
			win = infoObject[DataFieldMauBinh.WIN];
			lose = infoObject[DataFieldMauBinh.LOSE];
			sex = infoObject[DataFieldMauBinh.SEX];
			deviceIcon.gotoAndStop(infoObject[DataFieldMauBinh.DEVICE_ID]);
			userName = infoObject[ModelField.USER_NAME];
			displayName = infoObject[ModelField.DISPLAY_NAME];
			ip = infoObject[DataFieldMauBinh.IP];
			var nameString:String;
			if(formName == BELOW_USER)
				nameString = StringFormatUtils.shortenedString(infoObject[ModelField.DISPLAY_NAME], 14);
			else
				nameString = StringFormatUtils.shortenedString(infoObject[ModelField.DISPLAY_NAME], 11);
			playerName.text = nameString;
			
			levelNumber = infoObject[ModelField.LEVEL];
			level.text = infoObject[ModelField.LEVEL];
			levelIcon.gotoAndStop(Math.ceil(levelNumber/ 10));
			
			moneyNumber = infoObject[ModelField.MONEY];
			money.text = PlayingLogic.format(moneyNumber,1);
			
			if (moneyNumber <= 0)
				money.text = '0';
				
			updateAvatar(infoObject[ModelField.AVATAR], infoObject[ModelField.LOGO]);
			
			contextMenuPosition = new Point();
			contextMenuPosition.x = content["contextMenuPosition"].x;
			contextMenuPosition.y = content["contextMenuPosition"].y;
			content["contextMenuPosition"].visible = false;
			content["emoPosition"].visible = false;
		}
		
		public function updateMoney(value:Number):void
		{
			if (value == 0)
				money.text = "0";
			else
				money.text = PlayingLogic.format(value, 1);
				
			moneyNumber = value;
			
			if(formName == PlayerInfoMauBinh.BELOW_USER) // Nếu là user của mình thì cập nhật lại tiền cho phòng chờ và phòng chọn kênh
				mainData.chooseChannelData.myInfo.money = value;
		}
		
		public function removeAllCards():void
		{
			if (groupStatus)
				groupStatus.visible = false;
			
			removeCardsArray(unLeaveCards);
			removeCardsArray(downCards_1);
			
			unLeaveCards = new Array();
			downCards_1 = new Array();
			unLeaveCardPosition = new Array();
			selectedCardArray = new Array();
			
			currentSelectedCard = null;
			currentDraggingCard = null;
			currentSwapCard = null;
			_isPlaying = false;
			isWaitingToReady = false;
			
			createPosition("unLeaveCardPosition", "downCardPosition", 13); // tạo vị trí cho quân bài chưa đánh
		}
		
		public function getUnUsePosition(positionType:String):Object
		{
			var tempPositionArray:Array;
			switch (positionType) 
			{
				case CardMauBinh.UN_LEAVE_CARD:
					tempPositionArray = unLeaveCardPosition;
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
		
		public function getCardById(cardType:String,cardId:int):CardMauBinh
		{
			var cardArray:Array;
			switch (cardType) 
			{
				case CardMauBinh.UN_LEAVE_CARD:
					cardArray = unLeaveCards;
				break;
			}
			
			var i:int;
			for (i = 0; i < cardArray.length; i++) 
			{
				if (cardArray[i].id == cardId) 
				{
					var card:CardMauBinh = cardArray[i];
					//cardArray.splice(i, 1);
					return card;
				}
			}
			trace("Không có quân bài nào có giá trị là " + cardId);
			return cardArray[cardArray.length - 1];
		}
		
		// Hạ một bộ bài
		public function downOneDeck(groupType:int, isLocal:Boolean = false):void
		{
			if (formName == BELOW_USER)
			{
				switch (unLeaveCards.length) 
				{
					case 13:
						stopCountTime();
					break;
				}
			}
			
			var i:int;
			
			if (downCards_1)
			{
				for (i = 0; i < downCards_1.length; i++)  
				{
					CardMauBinh(downCards_1[i]).destroy();
				}
			}
			downCards_1 = new Array();
			
			var tempNumber:int = 5;
			if (groupType == 3)
				tempNumber = 3;
			for (i = tempNumber - 1; i >= 0; i--)
			{
				downCards_1[i] = unLeaveCards.pop();
			}
			
			reArrangeDownCard();
			if (isLocal)
				return;
		}
		
		public function addValueForOneUnleavedCard(cardId:int):void
		{
			var i:int;
			for (i = unLeaveCards.length - 1; i >= 0; i--) // tìm xem user này đã có quân bài này chưa, nếu có rồi thì returrn luôn
			{
				if (CardMauBinh(unLeaveCards[i]).id == cardId)
					return;
			}
			for (i = unLeaveCards.length - 1; i >= 0; i--) // Nếu chưa có thì gán giá trị quân bài mới vào
			{
				if (CardMauBinh(unLeaveCards[i]).id == 0)
				{
					CardMauBinh(unLeaveCards[i]).setId(cardId);
					i = -1;
				}
			}
		}
		
		public function addValueForOneGroup(groupType:int, cards:Array):void
		{
			var copyCards:Array = cards.concat();
			copyCards.reverse();
			var startIndex:int;
			var endIndex:int;
			switch (groupType) 
			{
				case 1:
					startIndex = 8;
					endIndex = 12;
				break;
				case 2:
					startIndex = 3;
					endIndex = 7;
				break;
				case 3:
					startIndex = 0;
					endIndex = 2;
				break;
			}
			try 
			{
				for (var i:int = endIndex; i >= startIndex; i--) 
				{
					CardMauBinh(unLeaveCards[i]).id = copyCards.pop();
				}
			}
			catch (err:Error)
			{
				var alertWindow:AlertWindow = new AlertWindow();
				alertWindow.setNotice("Có lỗi xẩy ra trong quá trình đọ chi");
				windowLayer.openWindow(alertWindow);
			}
		}
		
		// push new card vào mảng các lá bài chưa đánh
		public function pushNewUnLeaveCard(card:CardMauBinh):void
		{
			if (!unLeaveCards)
				unLeaveCards = new Array();
			unLeaveCards.push(card);
			card.isMouseInteractive = isCardInteractive;
			
			if (isCardInteractive)
			{
				card.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				if (stage)
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.addEventListener(CardMauBinh.IS_SELECTED, onCardIsSelected);
				card.addEventListener(CardMauBinh.IS_DE_SELECTED, onCardIsDeSelected);
			}
			else
			{
				card.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
				if (stage)
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				card.removeEventListener(CardMauBinh.IS_SELECTED, onCardIsSelected);
				card.removeEventListener(CardMauBinh.IS_DE_SELECTED, onCardIsDeSelected);
			}
			
			if (formName == BELOW_USER && unLeaveCards.length == 13)
			{
				var index:int;
				index = maubinhLogic.checkGroup(1, unLeaveCards);
				deckRank[1] = index;
				index = maubinhLogic.checkGroup(2, unLeaveCards);
				deckRank[2] = index;
				index = maubinhLogic.checkGroup(3, unLeaveCards);
				deckRank[3] = index;
				
				checkTotalDeck();
				
				var tempTimer:Timer = new Timer(500, 1);
				tempTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onArrangeGroup);
				//tempTimer.start();
				
				dispatchEvent(new Event(UPDATE_THREE_GROUP));
			}
		}
		
		private function onArrangeGroup(e:TimerEvent):void 
		{
			if (!stage)
				return;
			maubinhLogic.arrangeGroup(unLeaveCards, deckRank);
			reArrangeUnleaveCard();
		}
		
		private function onMouseDownCard(e:MouseEvent):void 
		{
			if (!stage || !CardMauBinh(e.currentTarget).buttonMode)
				return;
				
			currentDraggingCard = e.currentTarget as CardMauBinh;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			var point_1:Point = localToGlobal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[10].y));
			point_1 = CardMauBinh(e.currentTarget).parent.globalToLocal(point_1);
			var point_2:Point = localToGlobal(new Point(unLeaveCardPosition[5].x, unLeaveCardPosition[5].y));
			point_2 = CardMauBinh(e.currentTarget).parent.globalToLocal(point_2);
			//CardMauBinh(e.currentTarget).cardBorder.visible = true;
			//Card(e.currentTarget).cardChilds[Card(e.currentTarget).id].alpha = 0.5;
			
			var tempPoint:Point = CardMauBinh(e.currentTarget).parent.globalToLocal(new Point(0, 0));
			CardMauBinh(e.currentTarget).startDrag(false, new Rectangle(tempPoint.x, tempPoint.y, stage.width, stage.height));
		}
		
		public function openAllCard():void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardMauBinh(unLeaveCards[i]).effectOpen();
			}
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			if (!stage || !currentDraggingCard)
				return;
			var i:int;
			if (currentSwapCard && currentDraggingCard)
			{
				var number_1:int;
				var number_2:int;
				for (i = 0; i < unLeaveCards.length; i++)
				{
					if (unLeaveCards[i] == currentSwapCard)
						number_1 = i;
					if (unLeaveCards[i] == currentDraggingCard)
						number_2 = i;
				}
				
				unLeaveCards[number_1] = currentDraggingCard;
				unLeaveCards[number_2] = currentSwapCard;
			}
			
			var range_1:int = 2;
			var range_2:int = 2;
			
			if (number_1 < 3)
				range_1 = 3;
			else if (number_1 > 7)
				range_1 = 1;
				
			if (number_2 < 3)
				range_2 = 3;
			else if (number_2 > 7)
				range_2 = 1;
				
			if (range_1 != range_2) // Nếu 2 quân bài được tráo cho nhau là ở 2 chi khác nhau thì check kiểu của các chi
			{
				var index1:int = maubinhLogic.checkGroup(range_1, unLeaveCards);
				var index2:int = maubinhLogic.checkGroup(range_2, unLeaveCards);
				deckRank[range_1] = index1;
				deckRank[range_2] = index2;
				
				checkTotalDeck();
					
				dispatchEvent(new Event(UPDATE_THREE_GROUP));
				
				var isArrangeGroup:Array = new Array();
				isArrangeGroup[1] = isArrangeGroup[2] = isArrangeGroup[3] = false;
				isArrangeGroup[range_1] = true;
				isArrangeGroup[range_2] = true;
				//maubinhLogic.arrangeGroup(unLeaveCards, deckRank, isArrangeGroup[1], isArrangeGroup[2], isArrangeGroup[3]);
			}
			
			reArrangeUnleaveCard();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (currentSwapCard)
				currentSwapCard.cardBorder.visible = false;
			if (currentDraggingCard)
			{
				currentDraggingCard.cardBorder.visible = false;
				currentDraggingCard.stopDrag();
			}
			currentSwapCard = null;
			currentDraggingCard = null;
		}
		
		private function reArrangeAllCardWhenFinish():void
		{
			if (maubinhLogic.checkSanhRongCuon(unLeaveCards))
			{
				maubinhLogic.arrangeAllCard(unLeaveCards);
				reArrangeUnleaveCard();
				return;
			}
			
			if (maubinhLogic.checkSanhRong(unLeaveCards))
			{
				maubinhLogic.arrangeAllCard(unLeaveCards);
				reArrangeUnleaveCard();
				return;
			}
			
			if (maubinhLogic.check13CayCungMau(unLeaveCards))
			{
				return;
			}
			
			if (maubinhLogic.check12CayCungMau(unLeaveCards))
			{
				return;
			}
			
			if (maubinhLogic.check5Doi1Xam(unLeaveCards))
			{
				maubinhLogic.arrangeWhen5Doi1Xam(unLeaveCards);
				reArrangeUnleaveCard();
				return;
			}
			
			if (maubinhLogic.check6Doi(unLeaveCards))
			{
				maubinhLogic.arrangeWhen6Doi(unLeaveCards);
				reArrangeUnleaveCard();
				return;
			}
			
			if ((deckRank[1] == 4 || deckRank[1] == 1) && (deckRank[2] == 4 || deckRank[2] == 1))
			{
				if (maubinhLogic.check3Thung(unLeaveCards))
					return;
			}
			
			if (deckRank[1] == 1 && deckRank[2] == 1)
			{
				if (maubinhLogic.check3Thung(unLeaveCards))
					return;
			}
			
			maubinhLogic.arrangeGroup(unLeaveCards, deckRank);
			reArrangeUnleaveCard();
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (!currentDraggingCard)
				return;
			var distance:Number;
			
			if (currentSwapCard)
			{
				//if ((currentSwapCard == unLeaveCards[2] || currentSwapCard == unLeaveCards[7] || currentSwapCard == unLeaveCards[12]) && (currentDraggingCard.x > currentSwapCard.x))
						//distance = 30;
					//else if ((currentSwapCard == unLeaveCards[0] || currentSwapCard == unLeaveCards[3] || currentSwapCard == unLeaveCards[8]) && (currentDraggingCard.x < currentSwapCard.x))
						//distance = 20;
				
				if (Math.abs(currentDraggingCard.x - currentSwapCard.x) > 20)
				{
					if (currentSwapCard.isStealCard)
						currentSwapCard.cardBorder.visible = true;
					else
						currentSwapCard.cardBorder.visible = false;
					currentSwapCard = null;
				}
			}
			
			var isSwapable:Boolean = false;
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (unLeaveCards[i] != currentDraggingCard)
				{
					/*distance = 7;
					if ((i == 2 || i == 7 || i == 12) && (currentDraggingCard.x > unLeaveCards[i].x))
					{
						distance = 30;
					}
					else if ((i == 0 || i == 3 || i == 8) && (currentDraggingCard.x < unLeaveCards[i].x))
					{
						distance = 20;
					}*/
					if (Math.abs(currentDraggingCard.x - unLeaveCards[i].x) <= 25 && Math.abs(currentDraggingCard.y - unLeaveCards[i].y) <= 25)
					{
						if (unLeaveCards[i] != currentSwapCard)
						{
							if (currentSwapCard)
							{
								if (currentSwapCard.isStealCard)
									currentSwapCard.cardBorder.visible = true;
								else
									currentSwapCard.cardBorder.visible = false;
							}
							currentSwapCard = unLeaveCards[i];
							currentSwapCard.cardBorder.visible = true;
							currentDraggingCard.cardBorder.visible = true;
							currentDraggingCard.parent.addChild(currentDraggingCard);
						}
						isSwapable = true;
					}
				}
			}
			if (!isSwapable)
			{
				if (currentSwapCard)
					currentSwapCard.cardBorder.visible = false;
				currentDraggingCard.cardBorder.visible = false;
			}
		}
		
		private function onCardIsSelected(e:Event):void // chọn bài
		{
			if (formName != PlayerInfoMauBinh.BELOW_USER)
				return;
			
			// nếu không thì chỉ cho chọn 1 quân bài 1 thời điểm
			currentSelectedCard = CardMauBinh(e.currentTarget);
				
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				if (unLeaveCards[i] != e.currentTarget)
					CardMauBinh(unLeaveCards[i]).moveToStartPoint();
			}
		}
		
		private function onCardIsDeSelected(e:Event):void // bỏ chọn bài
		{
			
		}
		
		private function removeCardsArray(cardsArray:Array):void
		{
			var i:int;
			if (!cardsArray)
				return;
			for (i = 0; i < cardsArray.length; i++) 
			{
				if (cardsArray[i])
				{
					if (cardsArray[i] is CardMauBinh)
					{
						CardMauBinh(cardsArray[i]).removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCard);
						CardMauBinh(cardsArray[i]).removeEventListener(CardMauBinh.IS_SELECTED, onCardIsSelected);
						CardMauBinh(cardsArray[i]).removeEventListener(CardMauBinh.IS_DE_SELECTED, onCardIsDeSelected);
						CardMauBinh(cardsArray[i]).destroy();
						cardsArray[i] = null;
					}
				}
			}
		}
		
		public function reArrangeUnleaveCard(time:Number = 0, isRotate:Boolean = false):void
		{
			if (!stage || !unLeaveCards)
				return;
				
			if (time == 0)
				time = CardManagerMauBinh.arrangeCardTime;
				
			var index:int;
			var i:int;
			
			currentSelectedCard = null;
			
			for (i = 0; i < unLeaveCardPosition.length; i++) 
			{
				unLeaveCardPosition[i]["isUsed"] = false;
			}
			
			var tempPoint:Point;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				tempPoint = getPointByCardType(CardMauBinh.UN_LEAVE_CARD);
				CardMauBinh(unLeaveCards[i]).isChoose = false;
				if(isRotate)
					CardMauBinh(unLeaveCards[i]).moving(tempPoint, time, CardManagerMauBinh.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation);
				else
					CardMauBinh(unLeaveCards[i]).moving(tempPoint, time, CardManagerMauBinh.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation, true, true, isRotate, 1, false);
			}
		}
		
		private function addContent(type:int):void
		{	
			if (content)
				removeChild(content);
			var className:String;
			switch (type) 
			{
				case 1:
					className = "zPlayUserProfileForm_1_MauBinh";
				break;
				case 2:
					className = "zPlayUserProfileForm_2_MauBinh";
				break;
				case 3:
					className = "zPlayUserProfileForm_3_MauBinh";
				break;
				case 4:
					className = "zPlayUserProfileForm_4_MauBinh";
				break;
				default:
					
				break;
			}
			
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
			
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
			
			groupResultEffectPosition = new Point();
			groupResultEffectPosition.x = binhlungIcon.x;
			groupResultEffectPosition.y = binhlungIcon.y;
			
			addAvatar();
			addChild(levelIcon);
			if (isRoomMaster)
				addChild(homeIcon);
			if (formName == BELOW_USER)
			{
				groupStatus = content["groupStatus"];
				groupStatus.visible = false;
				addClock();
			}
			winLoseIcon = content["winLoseIcon"];
			addChild(winLoseIcon);
			winLoseIcon.visible = false;
			winLoseIcon.stop();
			
			giveUpIcon = content["giveUpIcon"];
			if (giveUpIcon)
				giveUpIcon.visible = false;
				
			content["bubbleChatPosition"].visible = false;
		}
		
		public function setStatus(type:String):void
		{
			if (type == '')
			{
				winLoseIcon.visible = false;
				return;
			}
			winLoseIcon.parent.addChild(winLoseIcon);
			winLoseIcon.gotoAndStop(type);
			winLoseIcon.visible = true;
		}
		
		private function addClock():void 
		{
			clock = new TimeBarMauBinh();
			clock.addEventListener(TimeBarMauBinh.COUNT_TIME_FINISH, onCountTimeFinish);
			clock.addEventListener(TimeBarMauBinh.HAS_ONE_SECOND, onClockHasOneSecond);
			var tempPoint:Point = new Point();
			tempPoint.x = content["clockPosition"].x;
			tempPoint.y = content["clockPosition"].y;
			content["clockPosition"].visible = false;
			tempPoint = localToGlobal(tempPoint);
			tempPoint.x = Math.round(tempPoint.x);
			tempPoint.y = Math.round(tempPoint.y);
			clock.x = tempPoint.x;
			clock.y = tempPoint.y;
			addChild(clock);
			clock.visible = false;
		}
		
		private function onClockHasOneSecond(e:Event):void 
		{
			var i:int;
			for (i = 0; i < unLeaveCards.length; i++) 
			{
				CardMauBinh(unLeaveCards[i]).stopDrag();
				CardMauBinh(unLeaveCards[i]).buttonMode = false;
			}
			
			if (!stage || !currentDraggingCard)
				return;
			if (currentSwapCard && currentDraggingCard)
			{
				var number_1:int;
				var number_2:int;
				for (i = 0; i < unLeaveCards.length; i++)
				{
					if (unLeaveCards[i] == currentSwapCard)
						number_1 = i;
					if (unLeaveCards[i] == currentDraggingCard)
						number_2 = i;
				}
				
				unLeaveCards[number_1] = currentDraggingCard;
				unLeaveCards[number_2] = currentSwapCard;
			}
			
			var range_1:int = 2;
			var range_2:int = 2;
			
			if (number_1 < 3)
				range_1 = 3;
			else if (number_1 > 7)
				range_1 = 1;
				
			if (number_2 < 3)
				range_2 = 3;
			else if (number_2 > 7)
				range_2 = 1;
				
			if (range_1 != range_2) // Nếu 2 quân bài được tráo cho nhau là ở 2 chi khác nhau thì check kiểu của các chi
			{
				var index1:int = maubinhLogic.checkGroup(range_1, unLeaveCards);
				var index2:int = maubinhLogic.checkGroup(range_2, unLeaveCards);
				deckRank[range_1] = index1;
				deckRank[range_2] = index2;
				
				checkTotalDeck();
			}
				
			reArrangeUnleaveCard();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if(currentSwapCard)
				currentSwapCard.cardBorder.visible = false;
			if (currentDraggingCard)
				currentDraggingCard.cardBorder.visible = false;
			currentSwapCard = null;
			currentDraggingCard = null;
		}
		
		// check trường hợp binh lủng hoặc trường hợp đặc biệt 3 thùng, 3 sảnh
		private function checkTotalDeck():void
		{	
			groupStatus.visible = false;
			
			if (maubinhLogic.checkSanhRongCuon(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.checkSanhRong(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.check13CayCungMau(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.check12CayCungMau(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.check5Doi1Xam(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.check6Doi(unLeaveCards))
			{
				groupStatus.gotoAndStop("maubinh");
				groupStatus.visible = true;
				return;
			}
			
			if (maubinhLogic.checkSoldierBreak(deckRank, unLeaveCards))
			{
				groupStatus.gotoAndStop("binhlung");
				groupStatus.visible = true;
				return;
			}
			
			if ((deckRank[1] == 4 || deckRank[1] == 1) && (deckRank[2] == 4 || deckRank[2] == 1))
			{
				if (maubinhLogic.check3Thung(unLeaveCards))
				{
					groupStatus.gotoAndStop("maubinh");
					groupStatus.visible = true;
					return;
				}
			}
			
			if ((deckRank[1] == 5 || deckRank[1] == 1) && (deckRank[2] == 5 || deckRank[2] == 1))
			{
				if (maubinhLogic.check3Sanh(unLeaveCards))
				{
					groupStatus.gotoAndStop("maubinh");
					groupStatus.visible = true;
					return;
				}
			}
			
			if (deckRank[1] == 1 && deckRank[2] == 1)
			{
				if (maubinhLogic.check3Thung(unLeaveCards))
				{
					groupStatus.gotoAndStop("maubinh");
					groupStatus.visible = true;
					return;
				}
			}
		}
		
		private function onCountTimeFinish(e:Event):void 
		{
			reArrangeAllCardWhenFinish();
			var cardInfo:Array = new Array();
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				cardInfo[i] = CardMauBinh(unLeaveCards[i]).id;
			}
			cardInfo.reverse();
			electroServerCommand.arrangeCardFinish(cardInfo);
			for (i = 0; i < unLeaveCards.length; i++)
			{
				CardMauBinh(unLeaveCards[i]).buttonMode = false;
			}
		}
		
		public function countTime(timeNumber:Number):void
		{
			clock.countTime(timeNumber);
		}
		
		public function stopCountTime():void
		{
			clock.stopCountTime();
		}
		
		private function createAllPosition(type:int):void
		{
			if (!unLeaveCardPosition)
			{
				unLeaveCardPosition = new Array();
				downCardPosition = new Point();
			}
			createPosition("unLeaveCardPosition", "downCardPosition", 13); // tạo vị trí cho quân bài chưa đánh
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
			
			var horizontalDistance:Number;
			var verticalDistance:Number;
			
			if (positionName == "unLeaveCardPosition")
			{
				switch (formName) 
				{
					case PlayerInfoMauBinh.BELOW_USER:
						horizontalDistance = 80;
						verticalDistance = 93;
					break;
					case PlayerInfoMauBinh.LEFT_USER:
					case PlayerInfoMauBinh.RIGHT_USER:
					case PlayerInfoMauBinh.ABOVE_USER:
						horizontalDistance = 31;
						verticalDistance = 40;
					break;
				}
			}
			
			var i:int;
			
			this[positionName][0].x = content[varName].x;
			this[positionName][0].y = content[varName].y;
			
			
			for (i = 1; i < positionNumber; i++) 
			{
				this[positionName][i] = new Object();
				
				if (i == 3)
				{
					this[positionName][i].x = content[varName].x;
					this[positionName][i].y = content[varName].y + verticalDistance;
				}
				else if (i == 8)
				{
					this[positionName][i].x = content[varName].x;
					this[positionName][i].y = content[varName].y + verticalDistance * 2;
				}
				else
				{
					this[positionName][i].x = this[positionName][i - 1].x + horizontalDistance;
					this[positionName][i].y = this[positionName][i - 1].y;
				}
			}
		}
		
		public function destroy():void
		{
			if (bubbleChat)
			{
				if (bubbleChat.parent)
					bubbleChat.parent.removeChild(bubbleChat);
			}
			
			if (arrangeFinishIcon)
			{
				if (arrangeFinishIcon.parent)
					arrangeFinishIcon.parent.removeChild(arrangeFinishIcon);
			}
				
			removeAllCards();
			unLeaveCardPosition = null;
			downCardPosition = null;
			
			unLeaveCardSize = 0;
			
			unLeaveCardRotation = 0;
			
			content = null;
			formName = null;
			
			playerName = null;
			money = null;
			homeIcon = null;
			readyIcon = null;
			arrangeFinishIcon = null;
			
			invitePlayWindow = null;
			windowLayer = null;
			
			removeCardsArray(unLeaveCards);
			removeCardsArray(downCards_1);
			unLeaveCards = null;
			downCards_1 = null;
			
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			if (formName == BELOW_USER)
			{
				for (var i:int = 0; i < buttonArray.length; i++) 
				{
					buttonArray[i].removeEventListener(MouseEvent.CLICK, onButtonClick);
				}
				exitButton.removeEventListener(MouseEvent.CLICK, onOtherButtonClick);
				
				exitButton = null;
			}
			
			if (parent)
				parent.removeChild(this);
				
			if (clock)
			{
				clock.removeEventListener(TimeBarMauBinh.COUNT_TIME_FINISH, onCountTimeFinish);
				clock = null;
			}
		}
		
		public function addChatSentence(sentence:String):void
		{
			if (timerToHideBubbleChat)
			{
				timerToHideBubbleChat.removeEventListener(TimerEvent.TIMER_COMPLETE, onHideBubbleChat);
				timerToHideBubbleChat.stop();	
			}
			
			if (!bubbleChat)
			{
				if (formName == BELOW_USER)
					bubbleChat = new BubbleChat(BubbleChat.RIGHT);
				else
					bubbleChat = new BubbleChat(BubbleChat.LEFT);
			}
			bubbleChat.addString(sentence);
			bubbleChat.x = content["bubbleChatPosition"].x;
			bubbleChat.y = content["bubbleChatPosition"].y;
			var globalPosition:Point = new Point(bubbleChat.x, bubbleChat.y);
			globalPosition = localToGlobal(globalPosition);
			if (globalPosition.x + bubbleChat.width > mainData.stageWidth)
				bubbleChat.x = - (globalPosition.x + bubbleChat.width - mainData.stageWidth);
				
			bubbleChat.x = globalPosition.x;
			bubbleChat.y = globalPosition.y;
			
			parent.addChild(bubbleChat);
			bubbleChat.visible = true;
			
			timerToHideBubbleChat = new Timer(5000, 1);
			timerToHideBubbleChat.addEventListener(TimerEvent.TIMER_COMPLETE, onHideBubbleChat);
			timerToHideBubbleChat.start();
		}
		
		private function onHideBubbleChat(e:TimerEvent):void 
		{
			if (!stage)
				return;
			bubbleChat.visible = false;
		}
		
		public function hideAllInfo():void
		{
			avatar.visible = false;
			homeIcon.visible = false;
			levelIcon.visible = false;
			playerName.visible = false;
			money.visible = false;
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
			var movingType:String = CardManagerMauBinh.OPEN_FINISH_STYLE;
			var i:int;
			
			// tính toán điểm hạ dựa vào số lá bài - căn vào giữa
			startX = downCardPosition.x;
			
			// bắt đầu thực hiện di chuyển
			for (i = 0; i < downCards_1.length; i++) 
			{
				tempPoint = new Point();
				//tempPoint.x = startX + (i + 1 - Math.ceil(downCards_1.length / 2)) * largeDistance_3;
				tempPoint.x = Math.round(startX - ((downCards_1.length - 1) * largeDistance_3 + 24.75) / 2 + i * largeDistance_3) + 12.4;
				tempPoint.y = Math.round(downCardPosition.y);
				CardMauBinh(downCards_1[i]).moving(localToGlobal(tempPoint), CardManagerMauBinh.downCardTime, movingType, downCardSize, downCardRotation);
			}
		}
		
		private function createSizeAndRotation():void 
		{
			switch (formName) 
			{
				case PlayerInfoMauBinh.BELOW_USER:
					unLeaveCardSize = belowUserCardSize[CardMauBinh.UN_LEAVE_CARD];
					downCardSize = belowUserCardSize[CardMauBinh.DOWN_CARD];
					unLeaveCardRotation = belowUserCardRotation[CardMauBinh.UN_LEAVE_CARD];
					downCardRotation = belowUserCardRotation[CardMauBinh.DOWN_CARD];
				break;
				case PlayerInfoMauBinh.LEFT_USER:
					unLeaveCardSize = leftUserCardSize[CardMauBinh.UN_LEAVE_CARD];
					downCardSize = leftUserCardSize[CardMauBinh.DOWN_CARD];
					unLeaveCardRotation = leftUserCardRotation[CardMauBinh.UN_LEAVE_CARD];
					downCardRotation = leftUserCardRotation[CardMauBinh.DOWN_CARD];
				break;
				case PlayerInfoMauBinh.RIGHT_USER:
					unLeaveCardSize = rightUserCardSize[CardMauBinh.UN_LEAVE_CARD];
					downCardSize = rightUserCardSize[CardMauBinh.DOWN_CARD];
					unLeaveCardRotation = rightUserCardRotation[CardMauBinh.UN_LEAVE_CARD];
					downCardRotation = rightUserCardRotation[CardMauBinh.DOWN_CARD];
				break;
				case PlayerInfoMauBinh.ABOVE_USER:
					unLeaveCardSize = aboveUserCardSize[CardMauBinh.UN_LEAVE_CARD];
					downCardSize = aboveUserCardSize[CardMauBinh.DOWN_CARD];
					unLeaveCardRotation = aboveUserCardRotation[CardMauBinh.UN_LEAVE_CARD];
					downCardRotation = aboveUserCardRotation[CardMauBinh.DOWN_CARD];
				break;
			}
		}
		
		// Tạo các nút liên quan đến chơi bài
		private function createAllButton():void 
		{
			buttonArray = new Array();
			reArrangeButton = content["reArrangeButton"];
			arrangeFinishButton = content["arrangeFinishButton"];
			reArrangeButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			arrangeFinishButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			reArrangeButton.visible = false;
			arrangeFinishButton.visible = false;
		}
		
		// Các nút ngoài chức năng chơi bài
		private function createOtherButton():void
		{
			exitButton = content["exitButton"];
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
			switch (e.currentTarget) 
			{
				case arrangeFinishButton:;
					reArrangeAllCardWhenFinish();
					var cardInfo:Array = new Array();
					for (var i:int = 0; i < unLeaveCards.length; i++) 
					{
						cardInfo[i] = CardMauBinh(unLeaveCards[i]).id;
					}
					cardInfo.reverse();
					electroServerCommand.arrangeCardFinish(cardInfo);
					arrangeFinishButton.visible = false;
					reArrangeButton.visible = true;
					for (i = 0; i < unLeaveCards.length; i++)
					{
						CardMauBinh(unLeaveCards[i]).buttonMode = false;
					}
				break;
				case reArrangeButton:;
					cardInfo = new Array();
					electroServerCommand.arrangeCardFinish(cardInfo, false);
					arrangeFinishButton.visible = true;
					reArrangeButton.visible = false;
					for (i = 0; i < unLeaveCards.length; i++)
					{
						CardMauBinh(unLeaveCards[i]).buttonMode = true;
					}
				break; 
			}
		}
		
		private function onConfirmWindow(e:Event):void 
		{
			if (e.currentTarget == confirmExitWindow)
			{
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
				//invitePlayWindow = new InvitePlayWindow();
				//windowLayer.openWindow(invitePlayWindow);
			}
		}
		
		private function onOtherButtonClick(e:MouseEvent):void
		{
			switch (e.currentTarget) 
			{
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
		public var avatarString:String;
		public var logoString:String;
		
		public function get isRoomMaster():Boolean 
		{
			return _isRoomMaster;
		}
		
		public function set isRoomMaster(value:Boolean):void 
		{
			_isRoomMaster = value;
			if (value)
			{
				addChild(homeIcon);
			}
			else
			{
				if (contains(homeIcon))
					removeChild(homeIcon);
			}
		}
		
		private var _isPlaying:Boolean; // Biến cờ thể hiện user đó đang chơi hay không
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void 
		{
			_isPlaying = value;
			
			if (value)
				isNoPlay = false;
			if (clock)
				clock.visible = value;
		}
		
		public function get isSortFinish():Boolean 
		{
			return _isSortFinish;
		}
		
		public function set isSortFinish(value:Boolean):void 
		{
			_isSortFinish = value;
			if (value)
			{
				if (arrangeFinishIcon.parent)
				{
					var tempPoint:Point = new Point();
					tempPoint.x = arrangeFinishIcon.x;
					tempPoint.y = arrangeFinishIcon.y;
					tempPoint = localToGlobal(tempPoint);
					arrangeFinishIcon.x = tempPoint.x;
					arrangeFinishIcon.y = tempPoint.y;
				}
				parent.addChild(arrangeFinishIcon);
				arrangeFinishIcon.visible = true;
				
				arrangeFinishIcon.scaleX = arrangeFinishIcon.scaleY = 0;
				var tempTween1:GTween = new GTween(arrangeFinishIcon, effectTime, { scaleX:1, scaleY:1 }, { ease:Back.easeOut } );
			}
			else
			{
				if (arrangeFinishIcon.parent == parent)
					parent.removeChild(arrangeFinishIcon);
			}
		}
		
		private var _isSortFinish:Boolean;
		public var clock:TimeBarMauBinh;
		private var maubinhLogic:MauBinhLogic;
		private var isNoPlay:Boolean = true;
		private var isIncreaseArrange:Boolean;
		private var backupUnleaveCardPosition:Array;
		public var isFirstClick:Boolean = true;
		
		private var _isGiveUp:Boolean;
		private var emo:Sprite;
		private var timerToHideEmo:Timer;
		public var win:int;
		public var lose:int;
		
		public function get isGiveUp():Boolean 
		{
			return _isGiveUp;
		}
		
		public function set isGiveUp(value:Boolean):void 
		{
			_isGiveUp = value;
			if (value)
			{
				giveUpIcon.visible = true;
				addChild(giveUpIcon);
			}
		}
	}

}