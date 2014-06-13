package view.card 
{
	import com.adobe.serialization.json.JSON;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import event.DataFieldPhom;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import model.MainData;
	import sound.SoundLibChung;
	import sound.SoundManager;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardManagerPhom extends Sprite 
	{
		public static const TURN_OVER_STYLE:String = "turnOverStyle"; // kiểu chia mà lá bài vẫn úp
		public static const OPEN_MIDDLE_STYLE:String = "openMiddleStyle"; // kiểu chia mà lá bài vừa di chuyển vừa lật
		public static const OPEN_FINISH_STYLE:String = "openFinishStyle"; // kiểu chia mà lá bài di chuyển đến nơi sẽ mở
		
		public static const GET_CARD:String = "getCard"; // Thông báo là user vừa click vào rút bài
		
		private var content:Sprite;
		
		public static const cardToDesTime:Number = 0.70; // giây - thời gian lá bài di chuyển từ chỗ chia bài đến người chơi
		public static const arrangeCardTime:Number = 0.15; // giây - thời gian sắp xếp lại các lá bài
		public static const clickCardTime:Number = 0.1; // giây - thời gian di chuyển khi click chọn lá bài
		public static const playCardTime:Number = 0.2; // giây - thời gian lá bài di chuyển từ chỗ bài chưa đánh đến chỗ bài đánh
		public static const downCardTime:Number = 0.2; // giây - thời gian lá bài di chuyển từ chỗ người chơi đến chỗ hạ bài
		private static const divideUserTimeDistance:Number = 160; // mili giây - khoảng thời gian cách nhau khi bắt đầu chia cho mỗi người chơi
		
		private var phomLogic:PhomLogic = PhomLogic.getInstance();
		private var mainData:MainData = MainData.getInstance();
		
		public var playerArray:Array; // Mảng chứa các player
		private var countDivideIndex:int = 0; // Biến dùng để đếm việc chia bài, chia cho từng người chơi, chia xong một lượt biến sẽ được reset lại 0
		private var timerToDivide:Timer;
		
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var getCardPoint:MovieClip;
		public var getCardIcon:Sprite;
		private var _totalCard:int = 52;
		private var cardNumberTxt:TextField;
		
		public function CardManagerPhom() 
		{
			addContent("zCardManagerPhom");
			getCardPoint = content["getCardPoint"];
			cardNumberTxt = getCardPoint["cardNumberTxt"];
			getCardIcon = getCardPoint["getCardIcon"];
			//getCardIcon.visible = false;
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//cacheAsBitmap = true;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if(timerToDivide)
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
			getCardPoint.removeEventListener(MouseEvent.CLICK, onGetCard);
			getCardPoint.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		// Hàm chia bài
		public function divideCard():void 
		{
			countDivideIndex = 0;
			totalCard = 52;
			getCardPoint.gotoAndStop("full");
			
			if (timerToDivide)
			{
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
				timerToDivide.stop();
				timerToDivide = null;
			}
			
			timerToDivide = new Timer(divideUserTimeDistance / playerArray.length);
			timerToDivide.addEventListener(TimerEvent.TIMER, onDivideCard);
			timerToDivide.start();
		}
		
		private function onDivideCard(e:TimerEvent):void 
		{
			var player:PlayerInfoPhom = playerArray[countDivideIndex];
			
			if (player)
			{
				if (player.cardInfoArray.length > 0)
					divideOneCard(player, player.cardInfoArray.pop());
					
				// Sau khi chia đủ số bài cho một người thì tăng biến đếm để check khi nào chia xong cho tất cả người chơi
				if (player.cardInfoArray.length == 0)
				{
					if (player.formName == PlayerInfoPhom.BELOW_USER)
					{
						player.arrangeCardButton.enable = true;
					}
				}
			}
			
			// sau khi chia bài hết 1 vòng thì quay lại
			if (countDivideIndex >= playerArray.length - 1)
				countDivideIndex = 0;
			else
				countDivideIndex++;
				
			var countDivideFinish:int = 0;
			for (var i:int = 0; i < playerArray.length; i++) 
			{
				if (PlayerInfoPhom(playerArray[i]).cardInfoArray.length == 0)
					countDivideFinish++;
			}
			
			// Khi chia xong hết cho tất cả các người chơi
			if (countDivideFinish == playerArray.length)
			{
				if (timerToDivide)
				{
					timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
					timerToDivide.stop();
					timerToDivide = null;
				}
			}
		}
		
		public function divideOneCard(player:PlayerInfoPhom, cardId:int, time:Number = 0, isCheckGetDeck:Boolean = false):void
		{
			SoundManager.getInstance().playSound(SoundLibChung.CARD_SOUND);
			
			if (time == 0)
				time = cardToDesTime;
			totalCard -= 1;
				
			var tempCard:CardPhom = new CardPhom(0.76);
			/*switch (player.formName) 
			{
				case PlayerInfoPhom.BELOW_USER:
					tempCard.rotation = -180;
				case PlayerInfoPhom.ABOVE_USER:
					tempCard.rotation = -180;
				break;
				case PlayerInfoPhom.LEFT_USER:
					tempCard.rotation = -180;
				case PlayerInfoPhom.RIGHT_USER:
					tempCard.rotation = -180;
				break;
			}*/
			
			addChild(tempCard);
			tempCard.alpha = 0;
			
			// gán giá trị cho quân bài và push vào dữ liệu của người chơi
			tempCard.setId(cardId);
			
			player.pushNewUnLeaveCard(tempCard, isCheckGetDeck);
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(player, CardPhom.UN_LEAVE_CARD);
			
			// di chuyển lá bài đến vị trí tương ứng
			tempCard.moving(tempPoint, time, CardManagerPhom.OPEN_FINISH_STYLE, player.unLeaveCardSize, player.unLeaveCardRotation, true, true, false, 1, true);
			
			player.reAddUnleaveCard();
		}
		
		/**
		 * - Hàm đánh bài
		 * @param	player - người chơi nào đánh
		 * @param	cardId - id của lá bài từ 1 - 52 tương ứng tứ át tới k, thứ tự bích, tép, dô, cơ
		 */
		public function playOneCard(player:PlayerInfoPhom,cardId:int):void
		{
			player.playOneCard(cardId);
		}
		
		/**
		 * - add giá trị cho một lá bài chưa đánh
		 * @param	player - người chơi nào 
		 * @param	cardId - giá trị lá bài được gán từ 1 - 52 tương ứng tứ át tới k, thứ tự bích, tép, dô, cơ
		 */
		public function addValueForOneUnleavedCard(player:PlayerInfoPhom, cardId:int):void
		{
			player.addValueForOneUnleavedCard(cardId);
		}
		
		/**
		 * - Hàm gửi bài
		 * @param	fromPlayer - người gửi
		 * @param	toPlayer - người được gửi
		 * @param	cardId - id của lá bài gửi
		 * @param	deckIndex - chỉ số của phỏm được gửi vào (1,2,3)
		 */
		public function sendCard(fromPlayer:PlayerInfoPhom, toPlayer:PlayerInfoPhom, cardId:int, deckIndex:int):void
		{
			var card:CardPhom = fromPlayer.getCardById(CardPhom.UN_LEAVE_CARD, cardId);
			toPlayer.pushCardToOneDeck(card, deckIndex);
			fromPlayer.deleteOneUnleaveCard(card);
			card.isMouseInteractive = false;
		}
		
		/**
		 * - Hàm ăn bài
		 * @param	stealPlayer - người ăn
		 * @param	stealedPlayer - người bị ăn
		 * @param	cardId - id của lá bài ăn
		 */
		public function stealCard(stealPlayer:PlayerInfoPhom, stealedPlayer:PlayerInfoPhom, cardId:int):void
		{
			var card:CardPhom = stealedPlayer.popOneLeavedCard(cardId);
			if (!card)
				return;
			if (stealPlayer.formName == PlayerInfoPhom.BELOW_USER)
				card.isMine = true;
			card.isStealCard = true;
			
			if (stealPlayer.formName == PlayerInfoPhom.BELOW_USER) // Nếu người ăn bài là mình thì enable mouseEvent của lá bài đó
				card.isMouseInteractive = true;
			else // Nếu không thì disable mouseEvent của lá bài đó
				card.isMouseInteractive = false;
				
			stealPlayer.pushNewUnLeaveCard(card);
			stealPlayer.reArrangeUnleaveCard(arrangeCardTime * 1.4);
			
			// xét lại thứ tự vòng sau khi có người ăn một lá
			phomLogic.setOrderRound(stealPlayer, stealedPlayer, playerArray);
			
			if (stealPlayer.formName == PlayerInfoPhom.BELOW_USER) // Nếu người ăn bài là mình thì check xem đã phải hạ chưa
			{
				if (stealPlayer.leavedCards.length == mainData.cardNumberToDown) // Check xem đến lượt mình hạ chưa
					stealPlayer.setMyTurn(PlayerInfoPhom.DOWN_CARD);
				else
					stealPlayer.setMyTurn(PlayerInfoPhom.PLAY_CARD);
			}
		}
		
		public function addAllCard(player:PlayerInfoPhom, cardInfo:Object):void
		{
			if (cardInfo[DataFieldPhom.GAME_STATE] != DataFieldPhom.WAITING)
			{
				var numCard:int = cardInfo[DataFieldPhom.NUM_CARD];
				totalCard -= numCard;
				var card:CardPhom;
				player.removeAllCards();
				for (var i:int = 0; i < numCard; i++) 
				{
					card = new CardPhom(player.unLeaveCardSize);
					card.id = 0;
					card.rotation = player.unLeaveCardRotation;
					var point:Point = getPointByCardType(player, CardPhom.UN_LEAVE_CARD);
					point = globalToLocal(point);
					card.x = point.x;
					card.y = point.y;
					addChild(card);
					player.pushNewUnLeaveCard(card);
				}
				
				var stoleCards:Array = cardInfo[DataFieldPhom.STOLE_CARDS];
				if (stoleCards)
				{
					totalCard -= stoleCards.length;
					for (i = 0; i < stoleCards.length; i++) 
					{
						card = new CardPhom(player.unLeaveCardSize);
						card.id = stoleCards[i];
						if (player.formName == PlayerInfoPhom.BELOW_USER)
							card.isMine = true;
						card.isStealCard = true;
						card.rotation = player.unLeaveCardRotation;
						point = getPointByCardType(player, CardPhom.UN_LEAVE_CARD);
						point = globalToLocal(point);
						card.x = point.x;
						card.y = point.y;
						addChild(card);
						card.simpleOpen();
						player.pushNewUnLeaveCard(card);
					}
				}
				
				var leaveCards:Array = cardInfo[DataFieldPhom.DISCARDED_CARDS];
				if (leaveCards)
				{
					totalCard -= leaveCards.length;
					for (i = 0; i < leaveCards.length; i++) 
					{
						card = new CardPhom(player.leavedCardSize);
						card.id = leaveCards[i];
						point = new Point();
						point.x = player.getUnUsePosition(CardPhom.LEAVED_CARD).x;
						point.y = player.getUnUsePosition(CardPhom.LEAVED_CARD).y;
						card.x = player.localToGlobal(point).x;
						card.y = player.localToGlobal(point).y;
						addChild(card);
						card.simpleOpen();
						player.pushNewLeavedCard(card);
					}
				}
				
				var downCards:Array = cardInfo[DataFieldPhom.LAYING_CARDS];
				if (downCards)
				{
					for (i = 0; i < downCards.length; i++) 
					{
						player.deckNumber++;
						switch (player.deckNumber) 
						{
							case 1:
								player.downCards_1_index = downCards[i][DataFieldPhom.INDEX];
							break;
							case 2:
								player.downCards_2_index = downCards[i][DataFieldPhom.INDEX];
							break;
							case 3:
								player.downCards_3_index = downCards[i][DataFieldPhom.INDEX];
							break;
						}
						for (var j:int = 0; j < downCards[i][DataFieldPhom.CARDS].length; j++) 
						{
							totalCard --;
							card = new CardPhom(player.downCardSize);
							card.id = downCards[i][DataFieldPhom.CARDS][j];
							card.rotation = player.downCardRotation;
							point = player.localToGlobal(player.downCardPosition);
							point = globalToLocal(point);
							card.x = point.x;
							card.y = point.y;
							addChild(card);
							card.simpleOpen();
							player.pushCardToOneDeck(card, downCards[i][DataFieldPhom.INDEX]);
						}
					}
					player.deckNumber = downCards.length;
					player.reArrangeDownCard();
				}
			}
		}
		
		// Hàm lấy vị trí chưa sử dụng của một người chơi - vị trí chia bài, vị trí đánh bài...
		private function getPointByCardType(player:PlayerInfoPhom,cardType:String):Point 
		{
			var tempPoint:Point = new Point();
			var tempObject:Object = player.getUnUsePosition(cardType);
			tempObject["isUsed"] = true;
			tempPoint.x = tempObject.x;
			tempPoint.y = tempObject.y;
			tempPoint.x = player.localToGlobal(tempPoint).x;
			tempPoint.y = player.localToGlobal(tempPoint).y;
			return tempPoint;
		}
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function destroy():void
		{
			content = null;
			
			phomLogic = null;
			mainData = null;
			
			getCardPoint = null;
			
			playerArray = null;
			countDivideIndex = 0;
			
			if (timerToDivide)
			{
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
				timerToDivide.stop();
				timerToDivide = null;
			}
			
			if (parent)
				parent.removeChild(this);
		}
		
		public function showTwinkle():void
		{
			getCardPoint.buttonMode = true;
			//getCardIcon.visible = true;
			getCardPoint.addEventListener(MouseEvent.CLICK, onGetCard);
			//getCardPoint.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onGetCard(e:MouseEvent):void 
		{	
			hideTwinkle();
			dispatchEvent(new Event(GET_CARD));
		}
		
		public function hideTwinkle():void
		{
			if (!stage)
				return;
			getCardPoint.buttonMode = false;
			//getCardIcon.visible = false;
			getCardPoint.removeEventListener(MouseEvent.CLICK, onGetCard);
			getCardPoint.filters = null;
			getCardPoint.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!stage)
				hideTwinkle();
			if (isFilterDown)
			{
				if(filterNumber >= 1)
					filterNumber -= 0.8;
				else
					isFilterDown = false;
			}
			else
			{
				if(filterNumber <= 5)
					filterNumber += 0.8;
				else
					isFilterDown = true;
			}
			
			var filterTemp:GlowFilter = new GlowFilter(0xFF0000, 1, filterNumber, filterNumber, 5, 1);
			if(getCardPoint)
				getCardPoint.filters = [filterTemp];
		}
		
		public function set totalCard(value:int):void 
		{
			_totalCard = value;
			cardNumberTxt.text = String(value);
			if (value == 0)
			{
				getCardPoint.gotoAndStop("empty");
				cardNumberTxt.visible = false;
			}
			else
			{
				cardNumberTxt.visible = true;
			}
		}
		
		public function get totalCard():int 
		{
			return _totalCard;
		}
	}

}