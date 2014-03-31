package view.card 
{
	import com.adobe.serialization.json.JSON;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import event.DataField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import model.MainData;
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
		
		private var content:Sprite;
		
		public static const cardToDesTime:Number = 0.70; // giây - thời gian lá bài di chuyển từ chỗ chia bài đến người chơi
		public static const arrangeCardTime:Number = 0.4; // giây - thời gian sắp xếp lại các lá bài
		public static const clickCardTime:Number = 0.3; // giây - thời gian di chuyển khi click chọn lá bài
		public static const playCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ bài chưa đánh đến chỗ bài đánh
		public static const downCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ người chơi đến chỗ hạ bài
		private static const divideUserTimeDistance:Number = 160; // mili giây - khoảng thời gian cách nhau khi bắt đầu chia cho mỗi người chơi
		
		private var phomLogic:PhomLogic = PhomLogic.getInstance();
		private var mainData:MainData = MainData.getInstance();
		
		public var playerArray:Array; // Mảng chứa các player
		private var countDivideIndex:int = 0; // Biến dùng để đếm việc chia bài, chia cho từng người chơi, chia xong một lượt biến sẽ được reset lại 0
		private var timerToDivide:Timer;
		
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var getCardPoint:Sprite;
		public var getCardIcon:Sprite;
		
		public function CardManagerXito() 
		{
			addContent("zCardManager");
			content.visible = false;
			getCardPoint = content["getCardPoint"];
			getCardIcon = getCardPoint["getCardIcon"];
			getCardIcon.visible = false;
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
			var player:PlayerInfoXito = playerArray[countDivideIndex];
			
			if (player)
			{
				if (player.cardInfoArray.length > 0)
					divideOneCard(player, player.cardInfoArray.pop());
					
				// Sau khi chia đủ số bài cho một người thì tăng biến đếm để check khi nào chia xong cho tất cả người chơi
				if (player.cardInfoArray.length == 0)
				{
					if (player.formName == PlayerInfoXito.BELOW_USER)
					{
						//player.arrangeCardButton.enable = true;
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
				if (PlayerInfoXito(playerArray[i]).cardInfoArray.length == 0)
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
		
		public function divideOneCard(player:PlayerInfoXito, cardId:int, time:Number = 0):void
		{
			if (time == 0)
				time = cardToDesTime;
				
			var tempCard:CardPhom = new CardPhom(0.5);
			switch (player.formName) 
			{
				case PlayerInfoXito.BELOW_USER:
					tempCard.rotation = -180;
				case PlayerInfoXito.ABOVE_RIGHT_USER:
					tempCard.rotation = -180;
				break;
				case PlayerInfoXito.ABOVE_LEFT_USER:
					tempCard.rotation = -180;
				break;
				case PlayerInfoXito.LEFT_USER:
					tempCard.rotation = -180;
				case PlayerInfoXito.RIGHT_USER:
					tempCard.rotation = -180;
				break;
			}
			
			addChild(tempCard);
			tempCard.alpha = 0;
			
			// gán giá trị cho quân bài và push vào dữ liệu của người chơi
			tempCard.setId(cardId);
			
			player.pushNewUnLeaveCard(tempCard);
			
			// Tìm vị trí chưa sử dụng để chia bài vào trị trí đó của người chơi
			var tempPoint:Point = getPointByCardType(player, CardPhom.UN_LEAVE_CARD);
			
			// di chuyển lá bài đến vị trí tương ứng
			tempCard.moving(tempPoint, time, CardManager.OPEN_FINISH_STYLE, player.unLeaveCardSize, player.unLeaveCardRotation, true, true, false);
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
		
		public function addAllCard(player:PlayerInfoXito, cardInfo:Object):void
		{
			if (cardInfo[DataField.GAME_STATE] != DataField.WAITING)
			{
				var openCards:Array = cardInfo[DataField.OPEN_CARDS];
				var i:int;
				var card:CardPhom;
				player.removeAllCards();
				player.currentMoneyOfRound = cardInfo[DataField.CURRENT_BET];
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
					card = new CardPhom(player.unLeaveCardSize);
					card.id = openCards[i];
					card.rotation = player.unLeaveCardRotation;
					var point:Point = getPointByCardType(player, CardPhom.UN_LEAVE_CARD);
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
			getCardIcon.visible = true;
			getCardPoint.addEventListener(MouseEvent.CLICK, onGetCard);
			getCardPoint.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			getCardIcon.visible = false;
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
	}

}