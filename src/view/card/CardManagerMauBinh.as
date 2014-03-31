package view.card 
{
	import com.adobe.serialization.json.JSON;
	import event.DataFieldMauBinh;
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
	import sound.SoundLibMauBinh;
	import sound.SoundManager;
	import view.userInfo.playerInfo.PlayerInfoMauBinh;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardManagerMauBinh extends Sprite 
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
		
		public function CardManagerMauBinh() 
		{
			addContent("zCardManagerMauBinh");
			getCardPoint = content["getCardPoint"];
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//cacheAsBitmap = true;
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
			
			timerToDivide = new Timer(divideUserTimeDistance / playerArray.length);
			timerToDivide.addEventListener(TimerEvent.TIMER, onDivideCard);
			timerToDivide.start();
			getCardPoint.gotoAndStop("full");
		}
		
		private function onDivideCard(e:TimerEvent):void 
		{
			var player:PlayerInfoMauBinh = playerArray[countDivideIndex];
			
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
				if (PlayerInfoMauBinh(playerArray[i]).cardInfoArray.length == 0)
					countDivideFinish++;
			}
			
			// Khi chia xong hết cho tất cả các người chơi
			if (countDivideFinish == playerArray.length)
			{
				getCardPoint.gotoAndStop("hide");
				dispatchEvent(new Event(DIVIDE_FINISH));
				if (timerToDivide)
				{
					timerToDivide.removeEventListener(TimerEvent.TIMER, onDivideCard);
					timerToDivide.stop();
					timerToDivide = null;
				}
			}
		}
		
		public function divideOneCard(player:PlayerInfoMauBinh, cardId:int, time:Number = 0):void
		{
			SoundManager.getInstance().playSound(SoundLibMauBinh.CARD_SOUND);
			
			if (time == 0)
				time = cardToDesTime;
				
			var tempCard:CardMauBinh = new CardMauBinh(0.76);
			//tempCard.rotation = -180;
			
			addChild(tempCard);
			tempCard.alpha = 0;
			
			// gán giá trị cho quân bài và push vào dữ liệu của người chơi
			tempCard.setId(cardId);
			
			player.pushNewUnLeaveCard(tempCard);
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(player, CardMauBinh.UN_LEAVE_CARD);
			
			// di chuyển lá bài đến vị trí tương ứng
			tempCard.moving(tempPoint, time, CardManagerMauBinh.OPEN_FINISH_STYLE, player.unLeaveCardSize, player.unLeaveCardRotation, true, true, false);
		}
		
		public function downOneDeck(player:PlayerInfoMauBinh, downCardArray:Array):void
		{
			//player.downOneDeck(downCardArray);
		}
		
		/**
		 * - add giá trị cho một lá bài chưa đánh
		 * @param	player - người chơi nào 
		 * @param	cardId - giá trị lá bài được gán từ 1 - 52 tương ứng tứ át tới k, thứ tự bích, tép, dô, cơ
		 */
		public function addValueForOneUnleavedCard(player:PlayerInfoMauBinh, cardId:int):void
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
		
		public function addAllCard(player:PlayerInfoMauBinh, cardInfo:Object):void
		{
			if (cardInfo[DataFieldMauBinh.GAME_STATE] != DataFieldMauBinh.WAITING)
			{
				var numCard:int = cardInfo[DataFieldMauBinh.NUM_CARD];
				var card:CardMauBinh;
				player.removeAllCards();
				for (var i:int = 0; i < numCard; i++) 
				{
					card = new CardMauBinh(player.unLeaveCardSize);
					card.id = 0;
					card.rotation = player.unLeaveCardRotation;
					var point:Point = getPointByCardType(player, CardMauBinh.UN_LEAVE_CARD);
					point = globalToLocal(point);
					card.x = point.x;
					card.y = point.y;
					addChild(card);
					player.pushNewUnLeaveCard(card);
				}
				
				/*for (i = 5; i < 10; i++) 
				{
					if (player.unLeaveCards[i])
						addChild(player.unLeaveCards[i]);
				}
				for (i = 0; i < 5; i++) 
				{
					if (player.unLeaveCards[i])
						addChild(player.unLeaveCards[i]);
				}*/
			}
		}
		
		// Hàm lấy vị trí chưa sử dụng của một người chơi - vị trí chia bài, vị trí đánh bài...
		private function getPointByCardType(player:PlayerInfoMauBinh,cardType:String):Point 
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