package view.userInfo.playerInfo 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import com.hallopatidu.utils.StringFormatUtils;
	import control.CoreAPIXito;
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
	import sound.SoundLibChung;
	import sound.SoundManager;
	import view.BubbleChat;
	import view.button.BigButton;
	import view.button.MobileButton;
	import view.card.CardManagerXito;
	import view.card.CardMauBinh;
	import view.card.CardManagerMauBinh;
	import view.card.CardXito;
	import view.ChipContainer;
	import view.contextMenu.MyContextMenu;
	import view.effectLayer.EffectLayer;
	import view.screen.PlayingScreenMauBinh;
	import view.timeBar.TimeBarMauBinh;
	import view.timeBar.TimeBarXito;
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
	public class PlayerInfoXito extends Sprite 
	{
		public static const EXIT:String = "exit";
		public static const AVATAR_CLICK:String = "avatarClick";
		public static const UPDATE_THREE_GROUP:String = "updateThreeGroup";
		
		public static const BELOW_USER:String = "belowUserInfo";
		public static const ABOVE_LEFT_USER:String = "aboveLeftUserInfo";
		public static const ABOVE_RIGHT_USER:String = "aboveRightUserInfo";
		public static const LEFT_USER:String = "leftUserInfo";
		public static const RIGHT_USER:String = "rightUserInfo";
		
		public static const CALL:String = "call";
		public static const RAISE:String = "raise";
		public static const ALL_IN:String = "allIn";
		public static const RAISE_DOUBLE:String = "raiseDouble";
		public static const RAISE_FOURPLE:String = "raiseFourple";
		public static const RAISE_TRIPLE:String = "raiseTriple";
		public static const FOLD:String = "fold";
		public static const CHECK:String = "check";
		
		public static const SELECT_OPEN_CARD:String = "selectOpenCard";
		public static const SELECT_ACTION:String = "selectAction"; // đến lượt mình chọn hành động
		public static const DO_NOTHING:String = "doNothing";
		
		public var unLeaveCardPosition:Array; // vị trí các quân bài chưa đánh
		
		private const belowUserCardSize:Object = {"unLeaveCard":1}; // kích thước các quân bài của user bên dưới
		private const leftUserCardSize:Object = {"unLeaveCard":0.68}; // kích thước các quân bài của user bên trái
		private const rightUserCardSize:Object = {"unLeaveCard":0.68}; // kích thước các quân bài của user bên phải
		private const aboveLeftUserCardSize:Object = { "unLeaveCard":0.68}; // kích thước các quân bài của user bên trên
		private const aboveUserCardSize:Object = { "unLeaveCard":0.68}; // kích thước các quân bài của user bên trên
		
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
		private const normalDistance:Number = 29; // khoảng cách giữa các quân bài kích thước vừa
		private const largeDistance:Number = 55; // khoảng cách giữa các quân bài kích thước to
		private const largeDistance_2:Number = 15; // khoảng cách giữa các quân bài đã đánh
		private const largeDistance_3:Number = 14; // khoảng cách giữa các quân bài đã hạ
		
		public var unLeaveCards:Array; // Mảng chứa các lá bài chưa đánh
		
		private var buttonArray:Array; // mảng chứa tất cả các nút
		
		private var mainData:MainData = MainData.getInstance();
		
		private var playerName:TextField;
		private var money:TextField;
		private var level:TextField;
		private var deviceIcon:MovieClip;
		private var homeIcon:Sprite;
		private var readyIcon:Sprite;
		public var moneyNumber:Number;
		public var levelNumber:Number;
		public var winLoseIcon:MovieClip;
		public var giveUpIcon:MovieClip;
		private var actionIcon:MovieClip;
		
		private var callButton:MobileButton;
		private var allInButton:MobileButton;
		private var raiseButton:MobileButton;
		private var raiseDoubleButton:MobileButton;
		private var raiseFourpleButton:MobileButton;
		private var raiseTripleButton:MobileButton;
		private var checkButton:MobileButton;
		private var foldButton:MobileButton;
		
		public var cardInfoArray:Array;
		
		public var isCardInteractive:Boolean; // Biến để xác định xem có cho tương tác vào quân bài của người chơi này không
		
		public var position:int; // vị trí của người chơi, quyết định thứ tự chia bài
		public var userName:String; // id của người chơi
		public var displayName:String; // id của người chơi
		
		public var resultEffectPosition:Point;
		public var moneyEffectPosition:Point;
		
		private var avatar:Avatar;
		private var selectedCardArray:Array;
		
		public var currentSelectedCard:CardMauBinh; // lá bài đang được chọn
		public var currentDraggingCard:CardMauBinh; // lá bài đang được kéo
		public var currentSwapCard:CardMauBinh; // lá bài sẽ được đổi vị trị với lá bài được kéo
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var coreApi:CoreAPIXito = MainCommand.getInstance().electroServerCommand.coreAPI;
		
		private var leftLimit:Point; // Giới hạn di chuyển phía trái, khi drag quân bài về phía trái không thể dịch quá giới hạn này
		private var rightLimit:Point; // Giới hạn di chuyển phía phải, khi drag quân bài về phía phải không thể dịch quá giới hạn này
		
		private var exitButton:SimpleButton; // Nút thoát
		private var selectOpenCardAnim:MovieClip;
		
		private var invitePlayWindow:InvitePlayWindow; // Cửa sổ mời chơi
		private var orderCardWindow:OrderCardWindow; // Cửa sổ order bài
		private var windowLayer:WindowLayer = WindowLayer.getInstance(); // windowLayer để mở cửa sổ bất kỳ
		
		private const effectTime:Number = 0.5;
		public var playingPlayerArray:Array; // Danh sách những người đang chơi
		
		public var isWaitingToReady:Boolean;
		private var confirmExitWindow:ConfirmWindow; // Bảng xác nhận thoát ra khỏi phòng
		
		public var deckRank:Array; // Mảng để lưu cấp đọ của các chi
		
		public var sex:String;
		
		private var bubbleChat:BubbleChat;
		private var timerToHideBubbleChat:Timer;
		
		private var chipPosition:Sprite;
		private var chipArray:Array;
		private var chipContainer1:ChipContainer;
		private var chipContainer2:ChipContainer;
		
		public function PlayerInfoXito() 
		{
			unLeaveCards = new Array();
			deckRank = new Array();
			deckRank[0] = -1;
			
			chipContainer1 = new ChipContainer();
			chipContainer2 = new ChipContainer();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (chipContainer1)
			{
				if (chipContainer1.parent)
					chipContainer1.parent.removeChild(chipContainer1);
			}
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
		
		public function setAction(type:String = '', value:Number = 0, isNoShowIcon:Boolean = false):void
		{
			if (type == '')
				type = 'none';
			actionIcon.gotoAndStop(type);
			stopCountTime();
			if (formName == BELOW_USER)
			{
				selectOpenCardAnim.visible = false;
				disableAllButton();
			}
				
			switch (type) 
			{
				case CALL:
					var callMoney:Number = mainData.maxMoneyOfRound - currentMoneyOfRound;
					saveCurrentMoneyOfRound = mainData.maxMoneyOfRound;
					moveChip(callMoney);
					if (callMoney >= moneyNumber)
						SoundManager.getInstance().soundManagerXito.playCallAllSound(sex);
					else
						SoundManager.getInstance().soundManagerXito.playCallSound(sex);
				break;
				case RAISE:
					saveCurrentMoneyOfRound = currentMoneyOfRound + value;
					moveChip(value);
					if (!isNoShowIcon)
						SoundManager.getInstance().soundManagerXito.playRaiseSound(sex);
				break;
				case RAISE_DOUBLE:
					saveCurrentMoneyOfRound = currentMoneyOfRound + value;
					moveChip(value);
					SoundManager.getInstance().soundManagerXito.playRaiseDoubleSound(sex);
				break;
				case RAISE_TRIPLE:
					saveCurrentMoneyOfRound = currentMoneyOfRound + value;
					moveChip(value);
					SoundManager.getInstance().soundManagerXito.playRaiseTripleSound(sex);
				break;
				case RAISE_FOURPLE:
					saveCurrentMoneyOfRound = currentMoneyOfRound + value;
					moveChip(value);
					SoundManager.getInstance().soundManagerXito.playRaiseFourpleSound(sex);
				break;
				case ALL_IN:
					saveCurrentMoneyOfRound = currentMoneyOfRound + value;
					moveChip(value);
					SoundManager.getInstance().soundManagerXito.playAllInSound(sex);
				break;
				case FOLD:
					isFold = true;
					SoundManager.getInstance().soundManagerXito.playFoldSound(sex);
				break;
				case CHECK:
					SoundManager.getInstance().soundManagerXito.playCheckSound(sex);
				break;
				default:
			}
			if (isNoShowIcon)
				actionIcon.gotoAndStop("none");
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
			
			if (formName == PlayerInfoXito.BELOW_USER) // Nếu là user của mình thì cập nhật lại tiền cho phòng chờ và phòng chọn kênh
			{
				mainData.chooseChannelData.myInfo.money = value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
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
			actionIcon.parent.addChild(actionIcon);
			
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
			level = content["level"];
			deviceIcon = content["deviceIcon"];
			deviceIcon.gotoAndStop("none");
			money = content["money"];
			money.autoSize = TextFieldAutoSize.CENTER;
			actionIcon = content["actionIcon"];
			actionIcon.gotoAndStop("none");
			playerName.text = '';
			money.text = '';
			level.text = '';
			playerName.selectable = money.selectable = false;
			homeIcon = content["homeIcon"];
			content.removeChild(homeIcon);
			readyIcon = content["readyIcon"];
			
			content.removeChild(readyIcon);
		}
		
		public function setForm(_formName:String):void
		{
			formName = _formName;
			createSizeAndRotation();
			switch (formName) 
			{
				case PlayerInfoXito.BELOW_USER:
					case PlayerInfoXito.BELOW_USER:
					addContent(1);
					createAllButton();
					createOtherButton();
				break;
				case PlayerInfoXito.LEFT_USER:
					addContent(3);
				break;
				case PlayerInfoXito.RIGHT_USER:
					addContent(2);
				break;
				case PlayerInfoXito.ABOVE_LEFT_USER:
					addContent(5);
				break;
				case PlayerInfoXito.ABOVE_RIGHT_USER:
					addContent(4);
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
			
			moneyNumber = infoObject[ModelField.MONEY];
			money.text = PlayingLogic.format(moneyNumber,1);
			
			if (moneyNumber <= 0)
				money.text = '0';
				
			updateAvatar(infoObject[ModelField.AVATAR], infoObject[ModelField.LOGO]);
			content["emoPosition"].visible = false;
		}
		
		public function updateMoney(value:Number):void
		{
			if (value == 0)
				money.text = "0";
			else
				money.text = PlayingLogic.format(value, 1);
				
			moneyNumber = value;
			
			if (formName == PlayerInfoXito.BELOW_USER) // Nếu là user của mình thì cập nhật lại tiền cho phòng chờ và phòng chọn kênh
			{
				mainData.chooseChannelData.myInfo.money = value;
				mainData.chooseChannelData.myInfo = mainData.chooseChannelData.myInfo;
			}
		}
		
		public function removeAllCards():void
		{
			removeCardsArray(unLeaveCards);
			
			unLeaveCards = new Array();
			unLeaveCardPosition = new Array();
			selectedCardArray = new Array();
			
			chipContainer1.value = 0;
			chipContainer2.value = 0;
			
			currentSelectedCard = null;
			currentDraggingCard = null;
			currentSwapCard = null;
			_isPlaying = false;
			isWaitingToReady = false;
			
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 10); // tạo vị trí cho quân bài chưa đánh
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
		
		public function addValueForOneUnleavedCard(cardId:int):void
		{
			var i:int;
			for (i = unLeaveCards.length - 1; i >= 0; i--) // tìm xem user này đã có quân bài này chưa, nếu có rồi thì returrn luôn
			{
				if (CardXito(unLeaveCards[i]).id == cardId && cardId != 0)
					return;
			}
			for (i = unLeaveCards.length - 1; i >= 0; i--) // Nếu chưa có thì gán giá trị quân bài mới vào
			{
				if (CardXito(unLeaveCards[i]).id == 0)
				{
					CardXito(unLeaveCards[i]).setId(cardId);
					CardXito(unLeaveCards[i]).effectOpen();
					i = -1;
				}
				else if (cardId == 0)
				{
					CardXito(unLeaveCards[i]).setId(cardId);
				}
			}
		}
		
		public function closeAllCard():void
		{
			for (var i:int = unLeaveCards.length - 1; i >= 0; i--) // Nếu chưa có thì gán giá trị quân bài mới vào
			{
				CardXito(unLeaveCards[i]).setId(0);
			}
		}
		
		// push new card vào mảng các lá bài chưa đánh
		public function pushNewUnLeaveCard(card:CardXito):void
		{
			if (!unLeaveCards)
				unLeaveCards = new Array();
			unLeaveCards.push(card);
			card.isMouseInteractive = isCardInteractive;
			
			if (isCardInteractive)
			{
				card.addEventListener(CardXito.IS_SELECTED, onCardIsSelected);
				card.addEventListener(CardXito.IS_DE_SELECTED, onCardIsDeSelected);
			}
			else
			{
				card.removeEventListener(CardXito.IS_SELECTED, onCardIsSelected);
				card.removeEventListener(CardXito.IS_DE_SELECTED, onCardIsDeSelected);
			}
			
			if (formName == RIGHT_USER || formName == ABOVE_RIGHT_USER)
			{
				for (var i:int = unLeaveCards.length - 1; i >= 0; i--) 
				{
					unLeaveCards[i].parent.addChild(unLeaveCards[i]);
				}
			}
		}
		
		public function openAllCard():void
		{
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardXito(unLeaveCards[i]).simpleOpen();
				CardXito(unLeaveCards[i]).overLayer.visible = false;
				CardXito(unLeaveCards[i]).cardBorder.visible = false;
			}
		}
		
		private function onCardIsSelected(e:Event):void // chọn bài
		{
			if (formName != PlayerInfoXito.BELOW_USER || mainData.isSelectOpenCard)
				return;
			mainData.isSelectOpenCard = true;
			actionIcon.gotoAndStop("none");
			stopCountTime();
			for (var i:int = 0; i < unLeaveCards.length; i++) 
			{
				CardXito(unLeaveCards[i]).hideTwinkle();
				if (e.currentTarget != unLeaveCards[i])
				{
					CardXito(unLeaveCards[i]).overLayer.visible = true;
					CardXito(unLeaveCards[i]).cardBorder.visible = true;
				}
			}
			SoundManager.getInstance().playSound(SoundLibChung.CARD_SOUND);
			coreApi.selectOpenCard(userName, [CardXito(e.currentTarget).id - 1]);
			selectOpenCardAnim.visible = false;
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
					if (cardsArray[i] is CardXito)
					{
						CardXito(cardsArray[i]).removeEventListener(CardXito.IS_SELECTED, onCardIsSelected);
						CardXito(cardsArray[i]).removeEventListener(CardXito.IS_DE_SELECTED, onCardIsDeSelected);
						CardXito(cardsArray[i]).destroy();
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
				time = CardManagerXito.arrangeCardTime;
				
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
				tempPoint = getPointByCardType(CardXito.UN_LEAVE_CARD);
				CardXito(unLeaveCards[i]).isChoose = false;
				if(isRotate)
					CardXito(unLeaveCards[i]).moving(tempPoint, time, CardManagerXito.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation);
				else
					CardXito(unLeaveCards[i]).moving(tempPoint, time, CardManagerXito.TURN_OVER_STYLE, unLeaveCardSize, unLeaveCardRotation, true, true, isRotate, 1, false);
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
					className = "zPlayUserProfileForm_1_Xito";
				break;
				case 2:
					className = "zPlayUserProfileForm_2_Xito";
				break;
				case 3:
					className = "zPlayUserProfileForm_3_Xito";
				break;
				case 4:
					className = "zPlayUserProfileForm_4_Xito";
				break;
				case 5:
					className = "zPlayUserProfileForm_5_Xito";
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
			addChild(content["levelIcon"]);
			addChild(level);
			if (isRoomMaster)
				addChild(homeIcon);
			winLoseIcon = content["winLoseIcon"];
			addChild(winLoseIcon);
			winLoseIcon.visible = false;
			winLoseIcon.stop();
			
			giveUpIcon = content["giveUpIcon"];
			if (giveUpIcon)
				giveUpIcon.visible = false;
				
			content["bubbleChatPosition"].visible = false;
		}
		
		private function addTimeBar():void 
		{
			var _type:int;
			switch (formName) 
			{
				case PlayerInfoXito.BELOW_USER:
					_type = 3;
				break;
				case PlayerInfoXito.LEFT_USER:
				case PlayerInfoXito.RIGHT_USER:
					_type = 1;
				break;
				case PlayerInfoXito.ABOVE_LEFT_USER:
					_type = 2;
				break;
				case PlayerInfoXito.ABOVE_RIGHT_USER:
					_type = 2;
				break;
			}
			if (!timeBar)
			{
				timeBar = new TimeBarXito(_type);
				timeBar.visible = false;
				timeBar.addEventListener(TimeBarXito.COUNT_TIME_FINISH, onCountTimeFinish);
			}
			timeBar.x = content["timeBarPosition"].x;
			timeBar.y = content["timeBarPosition"].y;
			content["timeBarPosition"].visible = false;
			addChild(timeBar);
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
		
		private function onCountTimeFinish(e:Event):void 
		{
			if (formName != PlayerInfoXito.BELOW_USER)
				return;
			switch (myStatus) 
			{
				case SELECT_OPEN_CARD: // Tự động chọn 1 quân bài để lật
					CardXito(unLeaveCards[1]).moveUp();
				break;
				case SELECT_ACTION: // Nếu hết thời gian mà chưa chọn action thì tự động ụp bài
					coreApi.fold(userName);
				break;
			}
		}
		
		public function countTime(timeNumber:Number):void
		{
			timeBar.countTime(timeNumber);
		}
		
		public function stopCountTime():void
		{
			timeBar.stopCountTime();
		}
		
		private function createAllPosition(type:int):void
		{
			if (!unLeaveCardPosition)
			{
				unLeaveCardPosition = new Array();
			}
			createPosition("unLeaveCardPosition", "unLeaveCardPosition", 10); // tạo vị trí cho quân bài chưa đánh
			
			if (content["chipPosition"])
			{
				chipPosition = content["chipPosition"];
				chipPosition.visible = false;
			}
		}
		
		public function receiveChip(addUpPosition:Sprite, winMoney:Number):void
		{
			if (winMoney <= 0)
				return;
			SoundManager.getInstance().soundManagerXito.playReceiveChipSound();
			var tempPoint:Point = new Point(addUpPosition.x, addUpPosition.y);
			tempPoint = addUpPosition.parent.localToGlobal(tempPoint);
			//tempPoint = globalToLocal(tempPoint);
			
			chipContainer1.value = winMoney;
			chipContainer1.x = tempPoint.x;
			chipContainer1.y = tempPoint.y;
			parent.addChild(chipContainer1);
			tempPoint.x = avatar.x + avatar.width / 2;
			tempPoint.y = avatar.y + avatar.height / 2;
			tempPoint = localToGlobal(tempPoint);
			var movingTween:GTween = new GTween(chipContainer1, 0.5, { x:tempPoint.x, y:tempPoint.y } );
			movingTween.addEventListener(Event.COMPLETE, receiveChipComlete);
		}
		
		private function receiveChipComlete(e:Event):void 
		{
			chipContainer1.parent.removeChild(chipContainer1);
		}
		
		public function addUpChip(addUpPosition:Sprite):void
		{
			var tempPoint:Point = new Point(addUpPosition.x, addUpPosition.y);
			tempPoint = addUpPosition.parent.localToGlobal(tempPoint);
			//tempPoint = globalToLocal(tempPoint);
			var movingTween:GTween = new GTween(chipContainer1, 0.5, { x:tempPoint.x, y:tempPoint.y } );
			movingTween.addEventListener(Event.COMPLETE, addUpChipComlete);
		}
		
		private function addUpChipComlete(e:Event):void 
		{
			if (chipContainer1.parent)
				chipContainer1.parent.removeChild(chipContainer1);
			chipContainer1.value = 0;
			chipContainer2.value = 0;
		}
		
		private function moveChip(value:Number):void 
		{
			SoundManager.getInstance().soundManagerXito.playRaiseChipSound();
			if (chipContainer1.value == 0)
			{
				chipContainer1.value = value;
				var tempPoint:Point = new Point(avatar.x + avatar.width / 2, avatar.y + avatar.height / 2);
				tempPoint = localToGlobal(tempPoint);
				chipContainer1.x = tempPoint.x;
				chipContainer1.y = tempPoint.y;
				parent.addChild(chipContainer1);
				tempPoint.x = chipPosition.x;
				tempPoint.y = chipPosition.y;
				tempPoint = localToGlobal(tempPoint);
				var movingTween:GTween = new GTween(chipContainer1, 0.4, { x:tempPoint.x, y:tempPoint.y } );
			}
			else
			{
				chipContainer2.value = value;
				chipContainer2.x = avatar.x + avatar.width / 2;
				chipContainer2.y = avatar.y + avatar.height / 2;
				addChild(chipContainer2);
				movingTween = new GTween(chipContainer2, 0.4, { x:chipPosition.x, y:chipPosition.y } );
				movingTween.addEventListener(Event.COMPLETE, moveChipComlete);
			}
		}
		
		private function moveChipComlete(e:Event):void 
		{
			chipContainer1.value = saveCurrentMoneyOfRound;
			chipContainer2.parent.removeChild(chipContainer2);
		}
		
		private var saveCurrentMoneyOfRound:Number;
		
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
					case PlayerInfoXito.BELOW_USER:
						tempDistance = largeDistance;
					break;
					case PlayerInfoXito.LEFT_USER:
					case PlayerInfoXito.RIGHT_USER:
					case PlayerInfoXito.ABOVE_LEFT_USER:
					case PlayerInfoXito.ABOVE_RIGHT_USER:
						tempDistance = normalDistance;
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
				if (formName == RIGHT_USER || formName == ABOVE_RIGHT_USER)
					this[positionName][i].x = this[positionName][i - 1].x - horizontalDistance;
				else
					this[positionName][i].x = this[positionName][i - 1].x + horizontalDistance;
				this[positionName][i].y = this[positionName][i - 1].y + verticalDistance;
			}
			
			if (formName == PlayerInfoXito.BELOW_USER)
			{
				leftLimit = globalToLocal(new Point(unLeaveCardPosition[0].x, unLeaveCardPosition[0].y));
				rightLimit = globalToLocal(new Point(unLeaveCardPosition[9].x, unLeaveCardPosition[9].y));
			}
		}
		
		public function destroy():void
		{
			if (bubbleChat)
			{
				if (bubbleChat.parent)
					bubbleChat.parent.removeChild(bubbleChat);
			}
			
			removeAllCards();
			unLeaveCardPosition = null;
			
			unLeaveCardSize = 0;
			
			unLeaveCardRotation = 0;
			
			content = null;
			formName = null;
			
			playerName = null;
			money = null;
			homeIcon = null;
			readyIcon = null;
			
			invitePlayWindow = null;
			windowLayer = null;
			
			removeCardsArray(unLeaveCards);
			unLeaveCards = null;
			
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
		}
		
		// Xét đến lượt mình đánh
		public function setMyTurn(status:String):void
		{
			myStatus = status;
			switch (status) 
			{
				case PlayerInfoXito.DO_NOTHING:
					timeBar.stopCountTime();
					disableAllButton();
				break;
				case PlayerInfoXito.SELECT_ACTION:
					if (mainData.isRecentlyDealCard)
					{
						var timerToCheckAvailableAction:Timer = new Timer(1500, 1);
						timerToCheckAvailableAction.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerToCheckAvailableAction);
						timerToCheckAvailableAction.start();
					}
					else
					{
						checkAvailableAction();
						countTime(Number(mainData.init.playTime.selectActionTime));
					}
					SoundManager.getInstance().playSound(SoundLibChung.MY_TURN_SOUND);
				break;
				case PlayerInfoXito.SELECT_OPEN_CARD:
					selectOpenCardAnim.visible = true;
					
					for (var i:int = 0; i < unLeaveCards.length; i++)
					{
						//CardXito(unLeaveCards[i]).redBorder.visible = true;
						CardXito(unLeaveCards[i]).showTwinkle();
						if (i == 0)
							CardXito(unLeaveCards[i]).filterNumber = 7;
					}
				break;
			}
		}
		
		private function onTimerToCheckAvailableAction(e:TimerEvent):void 
		{
			if (!stage)
				return;
			checkAvailableAction();
			countTime(Number(mainData.init.playTime.selectActionTime));
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
			level.visible = false;
			content["levelIcon"].visible = false;
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
		
		private function createSizeAndRotation():void 
		{
			switch (formName) 
			{
				case PlayerInfoXito.BELOW_USER:
					unLeaveCardSize = belowUserCardSize[CardXito.UN_LEAVE_CARD];
					unLeaveCardRotation = belowUserCardRotation[CardXito.UN_LEAVE_CARD];
				break;
				case PlayerInfoXito.LEFT_USER:
					unLeaveCardSize = leftUserCardSize[CardXito.UN_LEAVE_CARD];
					unLeaveCardRotation = leftUserCardRotation[CardXito.UN_LEAVE_CARD];
				break;
				case PlayerInfoXito.RIGHT_USER:
					unLeaveCardSize = rightUserCardSize[CardXito.UN_LEAVE_CARD];
					unLeaveCardRotation = rightUserCardRotation[CardXito.UN_LEAVE_CARD];
				break;
				case PlayerInfoXito.ABOVE_LEFT_USER:
					unLeaveCardSize = leftUserCardSize[CardXito.UN_LEAVE_CARD];
					unLeaveCardRotation = leftUserCardRotation[CardXito.UN_LEAVE_CARD];
				break;
				case PlayerInfoXito.ABOVE_RIGHT_USER:
					unLeaveCardSize = rightUserCardSize[CardXito.UN_LEAVE_CARD];
					unLeaveCardRotation = rightUserCardRotation[CardXito.UN_LEAVE_CARD];
				break;
			}
		}
		
		// Tạo các nút liên quan đến chơi bài
		private function createAllButton():void 
		{
			buttonArray = new Array();
			
			callButton = content["callButton"];
			allInButton = content["allInButton"];
			raiseButton = content["raiseButton"];
			raiseDoubleButton = content["raiseDoubleButton"];
			raiseFourpleButton = content["raiseFourpleButton"];
			raiseTripleButton = content["raiseTripleButton"];
			checkButton = content["checkButton"];
			foldButton = content["foldButton"];
			
			callButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			allInButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			raiseButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			raiseDoubleButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			raiseFourpleButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			raiseTripleButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			checkButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			foldButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			buttonArray.push(callButton);
			buttonArray.push(allInButton);
			buttonArray.push(raiseButton);
			buttonArray.push(raiseDoubleButton);
			buttonArray.push(raiseFourpleButton);
			buttonArray.push(raiseTripleButton);
			buttonArray.push(checkButton);
			buttonArray.push(foldButton);
			
			disableAllButton();
		}
		
		// Các nút ngoài chức năng chơi bài
		private function createOtherButton():void
		{
			selectOpenCardAnim = content["selectOpenCardAnim"];
			selectOpenCardAnim.visible = false;
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
			if (MobileButton(e.currentTarget).enable)
			{
				switch (e.currentTarget) 
				{
					case callButton:
						coreApi.call(userName);
					break;
					case raiseButton:
						coreApi.raise(userName, String(calculateBetMoney(RAISE)), 1);
					break;
					case raiseDoubleButton:
						coreApi.raise(userName, String(calculateBetMoney(RAISE_DOUBLE)), 2);
					break;
					case raiseTripleButton:
						coreApi.raise(userName, String(calculateBetMoney(RAISE_TRIPLE)), 3);
					break;
					case raiseFourpleButton:
						coreApi.raise(userName, String(calculateBetMoney(RAISE_FOURPLE)), 4);
					break;
					case allInButton:
						coreApi.raise(userName, String(calculateBetMoney(ALL_IN)), 5);
					break;
					case foldButton:
						coreApi.fold(userName);
					break;
					case checkButton:
						coreApi.check(userName);
					break;
				}
				disableAllButton();
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
					if (isPlaying && !isFold)
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
		}
		
		private function checkAvailableAction():void 
		{
			disableAllButton();
			enableAllButton();
			
			var maxMoneyOfPlayer:Number = 0;
			for (var i:int = 0; i < playingPlayerArray.length; i++) 
			{
				if (PlayerInfoXito(playingPlayerArray[i]).userName != mainData.chooseChannelData.myInfo.uId)
				{
					if (maxMoneyOfPlayer < PlayerInfoXito(playingPlayerArray[i]).moneyNumber && !PlayerInfoXito(playingPlayerArray[i]).isFold)
						maxMoneyOfPlayer = PlayerInfoXito(playingPlayerArray[i]).moneyNumber
				}
			}
				
			if (mainData.actionStatus == 1) // trường hợp chưa có ai tố
			{
				callButton.enable = false;
				raiseDoubleButton.enable = false;
				raiseTripleButton.enable = false;
				raiseFourpleButton.enable = false;
				allInButton.enable = false;
				raiseButton.parent.addChild(raiseButton);
				checkButton.parent.addChild(checkButton);
			}
			else
			{
				callButton.parent.addChild(callButton);
				foldButton.parent.addChild(foldButton);
			}
			
			if (calculateBetMoney(RAISE) > mainData.chooseChannelData.myInfo.money)
				raiseButton.enable = false;
			if (calculateBetMoney(RAISE) > moneyNumber || calculateBetMoney(RAISE) > maxMoneyOfPlayer)
				raiseButton.enable = false;
				
			if (calculateBetMoney(RAISE_FOURPLE) > mainData.chooseChannelData.myInfo.money)
				raiseFourpleButton.enable = false;
			if (calculateBetMoney(RAISE_FOURPLE) > moneyNumber || calculateBetMoney(RAISE_FOURPLE) > maxMoneyOfPlayer)
				raiseFourpleButton.enable = false;
				
			if (calculateBetMoney(RAISE_TRIPLE) > mainData.chooseChannelData.myInfo.money)
				raiseTripleButton.enable = false;
			if (calculateBetMoney(RAISE_TRIPLE) > moneyNumber || calculateBetMoney(RAISE_TRIPLE) > maxMoneyOfPlayer)
				raiseTripleButton.enable = false;
				
			if (calculateBetMoney(RAISE_DOUBLE) > mainData.chooseChannelData.myInfo.money)
				raiseDoubleButton.enable = false;
			if (calculateBetMoney(RAISE_DOUBLE) > moneyNumber || calculateBetMoney(RAISE_DOUBLE) > maxMoneyOfPlayer)
				raiseDoubleButton.enable = false;
				
			if (calculateBetMoney(ALL_IN) > mainData.chooseChannelData.myInfo.money)
				allInButton.enable = false;
			if (calculateBetMoney(ALL_IN) > moneyNumber || calculateBetMoney(ALL_IN) > maxMoneyOfPlayer)
				allInButton.enable = false;
				
			if (numRaise >= maxNumRaise)
			{
				raiseButton.enable = false;
				raiseDoubleButton.enable = false;
				raiseTripleButton.enable = false;
				raiseFourpleButton.enable = false;
				allInButton.enable = false;
			}
		}
		
		private function calculateBetMoney(type:String):Number
		{
			var money:Number;
			var callMoney:Number;
			callMoney = mainData.maxMoneyOfRound - currentMoneyOfRound;
			switch (type) 
			{
				case RAISE:
					money = Number(roomBet);
				break;
				case RAISE_FOURPLE:
					money = callMoney + 3 * mainData.maxMoneyOfRound;
				break;
				case RAISE_TRIPLE:
					money = callMoney + 2 * mainData.maxMoneyOfRound;
				break;
				case RAISE_DOUBLE:
					money = callMoney + 1 * mainData.maxMoneyOfRound;
				break;
				case ALL_IN:
					money = (callMoney * 2 + mainData.currentTotalMoney);
				break;
				default:
			}
			return Math.floor(money);
		}
		
		private function disableAllButton():void
		{
			for (var i:int = 0; i < buttonArray.length; i++) 
			{
				MobileButton(buttonArray[i]).enable = false;
			}
		}
		
		private function enableAllButton():void
		{
			for (var i:int = 0; i < buttonArray.length; i++) 
			{
				MobileButton(buttonArray[i]).enable = true;
			}
		}
		
		public var timeBar:TimeBarXito;
		private var isNoPlay:Boolean = true;
		private var isIncreaseArrange:Boolean;
		private var backupUnleaveCardPosition:Array;
		public var isFirstClick:Boolean = true;
		
		private var _isGiveUp:Boolean;
		private var emo:Sprite;
		private var timerToHideEmo:Timer;
		public var win:int;
		public var lose:int;
		private var myStatus:String; // Lưu lại trạng thái hiện tại của user
		public var isFold:Boolean;
		public var currentMoneyOfRound:Number; // Số tiền người chơi đã bỏ ra trong vòng cược hiện tại
		private var _isMyTurn:Boolean;
		public var numRaise:int;
		public var maxNumRaise:int;
		
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
		
		public function get roomBet():Number 
		{
			return Number(mainData.playingData.gameRoomData.roomBet);
		}
		
		public function get isMyTurn():Boolean 
		{
			return _isMyTurn;
		}
		
		public function set isMyTurn(value:Boolean):void 
		{
			_isMyTurn = value;
			if (mainData.isRecentlyDealCard)
			{
				var timerToCountTime:Timer = new Timer(1500, 1);
				timerToCountTime.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerToCountTime);
				timerToCountTime.start();
			}
			else
			{
				countTime(Number(mainData.init.playTime.selectActionTime));
			}
		}
		
		private function onTimerToCountTime(e:TimerEvent):void 
		{
			countTime(Number(mainData.init.playTime.selectActionTime));
		}
	}

}