package view.card 
{
	import com.adobe.serialization.json.JSON;
	import event.DataFieldMauBinh;
	import event.DataFieldXito;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.MainData;
	import sound.SoundLibChung;
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	import view.ChipContainer;
	import view.userInfo.playerInfo.PlayerInfoXito;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardManagerXito extends Sprite 
	{
		public static const TURN_OVER_STYLE:String = "turnOverStyle"; // kiểu chia mà lá bài vẫn úp
		public static const OPEN_MIDDLE_STYLE:String = "openMiddleStyle"; // kiểu chia mà lá bài vừa di chuyển vừa lật
		public static const OPEN_FINISH_STYLE:String = "openFinishStyle"; // kiểu chia mà lá bài di chuyển đến nơi sẽ mở
		
		public static const GET_CARD:String = "getCard"; // Thông báo là user vừa click vào rút bài
		public static const DIVIDE_FINISH:String = "divideFinish"; // Chia bài xong
		
		private var content:Sprite;
		
		public static const cardToDesTime:Number = 0.4; // giây - thời gian lá bài di chuyển từ chỗ chia bài đến người chơi
		public static const arrangeCardTime:Number = 0.2; // giây - thời gian sắp xếp lại các lá bài
		public static const clickCardTime:Number = 0.3; // giây - thời gian di chuyển khi click chọn lá bài
		public static const playCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ bài chưa đánh đến chỗ bài đánh
		public static const downCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ người chơi đến chỗ hạ bài
		private static const divideUserTimeDistance:Number = 160; // mili giây - khoảng thời gian cách nhau khi bắt đầu chia cho mỗi người chơi
		
		private var mainData:MainData = MainData.getInstance();
		
		public var playerArray:Array; // Mảng chứa các player
		private var countDivideIndex:int = 0; // Biến dùng để đếm việc chia bài, chia cho từng người chơi, chia xong một lượt biến sẽ được reset lại 0
		private var timerToDivide:Timer;
		
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var getCardPoint:MovieClip;
		public var getCardIcon:Sprite;
		public var chipPosition:Sprite;
		private var chipContainer:ChipContainer;
		
		public function CardManagerXito() 
		{
			addContent("zCardManagerXito");
			getCardPoint = content["getCardPoint"];
			
			chipPosition = content["chipPosition"];
			chipPosition.visible = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//cacheAsBitmap = true;
			
			chipContainer = new ChipContainer(2);
			chipContainer.x = chipPosition.x;
			chipContainer.y = chipPosition.y;
			addChild(chipContainer);
		}
		
		public function addUpChip():void
		{
			SoundManager.getInstance().soundManagerXito.playAddUpChipSound();
			var timerToAddUpChip:Timer = new Timer(300, 1);
			timerToAddUpChip.addEventListener(TimerEvent.TIMER_COMPLETE, onAddUpChip);
			timerToAddUpChip.start();
		}
		
		private function onAddUpChip(e:TimerEvent):void 
		{
			if (!stage)
				return;
			addChild(chipContainer);
			chipContainer.value = mainData.currentTotalMoney;
		}
		
		public function removeChipContainer():void
		{
			if (chipContainer.parent)
				chipContainer.parent.removeChild(chipContainer);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if(timerToDivide)
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
		}
		
		// Hàm chia bài
		public function divideCard():void 
		{
			countDivideIndex = 0;
			
			if (timerToDivide)
			{
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
				timerToDivide.stop();
				timerToDivide = null;
			}
			
			//timerToDivide = new Timer(divideUserTimeDistance / playerArray.length);
			timerToDivide = new Timer(120);
			timerToDivide.addEventListener(TimerEvent.TIMER, onDivideCard);
			timerToDivide.start();
			getCardPoint.gotoAndStop("full");
		}
		
		private function onDivideCard(e:TimerEvent):void 
		{
			var player:PlayerInfoXito = playerArray[countDivideIndex];
			
			if (player)
			{
				if (player.cardInfoArray.length > 0)
					divideOneCard(player, player.cardInfoArray.pop());
			}
			
			// sau khi chia bài hết 1 vòng thì quay lại
			if (countDivideIndex >= playerArray.length - 1)
				countDivideIndex = 0;
			else
				countDivideIndex++;
				
			var countDivideFinish:int = 0;
			for (var i:int = 0; i < playerArray.length; i++) 
			{
				if (PlayerInfoXito(playerArray[i]).cardInfoArray.length == 0)
					countDivideFinish++;
			}
			
			// Khi chia xong hết cho tất cả các người chơi
			if (countDivideFinish == playerArray.length)
			{
				//getCardPoint.gotoAndStop("hide");
				dispatchEvent(new Event(DIVIDE_FINISH));
				if (timerToDivide)
				{
					timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
					timerToDivide.stop();
					timerToDivide = null;
				}
			}
		}
		
		// Hàm chia bài
		public function divideMoreCard():void 
		{
			countDivideIndex = 0;
			
			if (timerToDivide)
			{
				timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideMoreCard);
				timerToDivide.stop();
				timerToDivide = null;
			}
			
			//timerToDivide = new Timer(divideUserTimeDistance / playerArray.length);
			timerToDivide = new Timer(240);
			timerToDivide.addEventListener(TimerEvent.TIMER, onDivideMoreCard);
			timerToDivide.start();
		}
		
		private function onDivideMoreCard(e:TimerEvent):void 
		{
			if (!stage)
			{
				if (timerToDivide)
				{
					timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideMoreCard);
					timerToDivide.stop();
					timerToDivide = null;
				}
			}
			var player:PlayerInfoXito = playerArray[countDivideIndex];
			
			if (player)
			{
				if (player.cardInfoArray.length > 0)
					divideOneCard(player, player.cardInfoArray.pop());
			}
			
			// sau khi chia bài hết 1 vòng thì quay lại
			if (countDivideIndex >= playerArray.length - 1)
				countDivideIndex = 0;
			else
				countDivideIndex++;
				
			var countDivideFinish:int = 0;
			for (var i:int = 0; i < playerArray.length; i++) 
			{
				if (PlayerInfoXito(playerArray[i]).cardInfoArray.length == 0)
					countDivideFinish++;
			}
			
			// Khi chia xong hết cho tất cả các người chơi
			if (countDivideFinish == playerArray.length)
			{
				//getCardPoint.gotoAndStop("hide");
				dispatchEvent(new Event(DIVIDE_FINISH));
				if (timerToDivide)
				{
					timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
					timerToDivide.stop();
					timerToDivide = null;
				}
			}
		}
		
		public function divideOneCard(player:PlayerInfoXito, cardId:int, time:Number = 0):void
		{
			SoundManager.getInstance().playSound(SoundLibChung.CARD_SOUND);
			
			if (time == 0)
				time = cardToDesTime;
				
			var tempCard:CardXito = new CardXito(0.76);
			//tempCard.rotation = -180;
			
			addChild(tempCard);
			tempCard.alpha = 0;
			
			// gán giá trị cho quân bài và push vào dữ liệu của người chơi
			tempCard.setId(cardId);
			
			player.pushNewUnLeaveCard(tempCard);
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(player, CardXito.UN_LEAVE_CARD);
			
			// di chuyển lá bài đến vị trí tương ứng
			tempCard.moving(tempPoint, time, CardManagerXito.OPEN_FINISH_STYLE, player.unLeaveCardSize, player.unLeaveCardRotation, false, true, false);
		}
		
		public function downOneDeck(player:PlayerInfoXito, downCardArray:Array):void
		{
			//player.downOneDeck(downCardArray);
		}
		
		/**
		 * - add giá trị cho một lá bài chưa đánh
		 * @param	player - người chơi nào 
		 * @param	cardId - giá trị lá bài được gán từ 1 - 52 tương ứng tứ át tới k, thứ tự bích, tép, dô, cơ
		 */
		public function addValueForOneUnleavedCard(player:PlayerInfoXito, cardId:int):void
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
		
		public function addAllCard(player:PlayerInfoXito, cardInfo:Object):void
		{
			if (cardInfo[DataFieldXito.GAME_STATE] != DataFieldXito.WAITING)
			{
				var openCards:Array = cardInfo[DataFieldXito.OPEN_CARDS];
				var i:int;
				var card:CardXito;
				player.removeAllCards();
				player.currentMoneyOfRound = cardInfo[DataFieldXito.CURRENT_BET];
				if (openCards.length == 0)
				{
					openCards = [0, 0];
				}
				else
				{
					var tempArray:Array = [0];
					openCards = tempArray.concat(openCards);
				}
				for (i = 0; i < openCards.length; i++) 
				{
					card = new CardXito(player.unLeaveCardSize);
					card.id = openCards[i];
					card.rotation = player.unLeaveCardRotation;
					var point:Point = getPointByCardType(player, CardXito.UN_LEAVE_CARD);
					point = globalToLocal(point);
					card.x = point.x;
					card.y = point.y;
					addChild(card);
					player.pushNewUnLeaveCard(card);
					if (card.id != 0)
						card.simpleOpen();
				}
			}
		}
		
		// Hàm lấy vị trí chưa sử dụng của một người chơi - vị trí chia bài, vị trí đánh bài...
		private function getPointByCardType(player:PlayerInfoXito,cardType:String):Point 
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
	}

}