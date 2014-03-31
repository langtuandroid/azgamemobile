package logic 
{
	import com.adobe.serialization.json.JSON;
	import event.DataField;
	import view.card.Card;
	import view.card.CardManager;
	import view.userInfo.playerInfo.PlayerInfo;
	/**
	 * ...
	 * @author Yun
	 */
	public class TLMNLogic 
	{
		public static const NOT_RELATION:String = "notRelation";
		public static const ONE_PAIR:String = "onePair";
		public static const THREE_PAIR:String = "threePair";
		public static const FOUR_PAIR:String = "fourPair";
		public static const FIVE_PAIR:String = "fivePair";
		public static const THREE_OF_A_KIND:String = "threeOfAKind";
		public static const FOUR_OF_A_KIND:String = "fourOfAKind";
		public static const STRAIGHT:String = "straight";
		public static const DRAGON_STRAIGHT:String = "dragonStraight";
		
		public function TLMNLogic() 
		{
			
		}
		
		private static var _instance:TLMNLogic;
		public static function getInstance():TLMNLogic
		{
			if (!_instance)
				_instance = new TLMNLogic();
			return _instance;
		}
		
		/**
		 * - Hàm để xét lại thứ tự vòng mỗi khi có người chơi vừa ăn một lá
		 * @param	stealPlayer - người ăn bài
		 * @param	stealedPlayer - người bị ăn
		 * @param	playerArray - mảng chứa các người chơi
		 */
		public function setOrderRound(stealPlayer:PlayerInfo, stealedPlayer:PlayerInfo, playerArray:Array):void
		{
			var i:int;
			var startIndex:int;
			var card:Card;
			for (i = 0; i < playerArray.length; i++)
			{
				if (playerArray[i] == stealPlayer)
				{
					startIndex = i;
					i = playerArray.length;
				}
			}
			
			var player:PlayerInfo;
			var beforePlayer:PlayerInfo;
			
			if (startIndex == 0)
				startIndex = playerArray.length;
			for (i = startIndex - 1; i >= 0; i--) 
			{
				player = playerArray[i];
				if (i == 0)
					beforePlayer = playerArray[playerArray.length - 1];
				else
					beforePlayer = playerArray[i - 1];
				if (beforePlayer.leavedCards.length > player.leavedCards.length && player != stealPlayer)
				{
					card = beforePlayer.popOneLeavedCard(0);
					player.pushNewLeavedCard(card, CardManager.playCardTime * 1.4);
				}
			}
			for (i = playerArray.length - 1; i > startIndex; i--) 
			{
				player = playerArray[i];
				beforePlayer = playerArray[i - 1];
				if (beforePlayer.leavedCards.length > player.leavedCards.length && player != stealPlayer)
				{
					card = beforePlayer.popOneLeavedCard(0);
					player.pushNewLeavedCard(card, CardManager.playCardTime * 1.4);
				}
			}
		}
		
		// Hàm check xem có thể đánh con bài đó không
		public function checkPlayCard(myCardValues:Array, lastCardVaues:Array):Boolean
		{
			return true;
		}
		
		// sắp xếp phỏm theo thứ tự tăng dần
		public function arrangeDeck(deck:Array):void
		{
			var arrangeFinish:Boolean;
			while (!arrangeFinish)
			{
				arrangeFinish = true;
				for (var i:int = 0; i < deck.length - 1; i++) 
				{
					if (Card(deck[i]).id > Card(deck[i + 1]).id)
					{
						var tempCard:Card = deck[i];
						deck[i] = deck[i + 1];
						deck[i + 1] = tempCard;
						arrangeFinish = false;
					}
				}
			}
		}
		
		public function convertIdToString(cardId:int):String
		{
			var tempNumber:int = Math.floor((cardId - (cardId % 13)) / 13);
			switch (tempNumber) 
			{
				case 0:
					return (cardId % 13) + " bich'";
				break;
				case 1:
					if (cardId % 13 == 0)
						return "k bich";
					return (cardId % 13) + " tep'";
				break;
				case 2:
					if (cardId % 13 == 0)
						return "k tép";
					return (cardId % 13) + " zo^";
				break;
				case 3:
					if (cardId % 13 == 0)
						return "k zô";
					return (cardId % 13) + " cơ";
				case 4:
					if (cardId % 13 == 0)
						return "k cơ";
				break;
			}
			return "";
		}
		
		public function arrangeUnleaveCard(cardArray:Array):Array
		{
			//var deckArray:Array = countDeck(cardArray);
			var deckArray:Array = new Array();
			
			var isHaveOneDeck:Boolean;
			var isHaveTwoDeck:Boolean;
			var deck_1:Array;
			var deck_2:Array;
			var i:int;
			var j:int;
			var k:int;
			var selectedDeckArray:Array = new Array();
			var stealCardNumber:int = 0;
			var countStealCard:int;
				
			var newCardArray:Array = new Array();
			
			var object:Object;
			
			newCardArray = new Array();
			
			arrangeCardNoDeck(cardArray);
			newCardArray = newCardArray.concat(cardArray);
			return newCardArray;
		}
		
		public function arrangeCardNoDeck(cardArray:Array):void
		{
			var arrangeFinish:Boolean;
			while (!arrangeFinish)
			{
				arrangeFinish = true;
				for (var i:int = 0; i < cardArray.length - 1; i++) 
				{
					if (Card(cardArray[i]).id > Card(cardArray[i + 1]).id)
					{
						var tempCard:Card = cardArray[i];
						cardArray[i] = cardArray[i + 1];
						cardArray[i + 1] = tempCard;
						arrangeFinish = false;
					}
				}
			}
		}
		
		// Tìm quân bài có giá trị nhỏ nhất
		public function findSmallestCard(cards:Array):Card
		{
			var smallestCard:Card;
			smallestCard = cards[0];
			for (var i:int = 1; i < cards.length; i++) 
			{
				if (smallestCard.id > Card(cards[i]).id)
					smallestCard = cards[i];
			}
			return smallestCard;
		}
		
		public function getNameFromDeck(cardValues:Array):String
		{
			if (cardValues.length == 1)
				return NOT_RELATION;
			var ranks:Array = new Array();
			for (var i:int = 0; i < cardValues.length; i++) 
			{
				ranks.push(convertIdToRank(cardValues[i]));
			}
			ranks.sort(Array.NUMERIC);
			
			cardValues.sort(Array.NUMERIC);
			
			switch (cardValues.length) 
			{
				case 2:
					if (ranks[0] == ranks[1])
						return ONE_PAIR;
				break;
				case 3:
					if (ranks[0] == ranks[1] && ranks[0] == ranks[2])
						return THREE_OF_A_KIND;
					else if (checkStraight(ranks))
						return STRAIGHT;
				break;
				case 4:
					if (ranks[0] == ranks[1] && ranks[0] == ranks[2] && ranks[0] == ranks[3])
						return FOUR_OF_A_KIND;
					else if (checkStraight(ranks))
						return STRAIGHT;
				break;
				case 5:
					if (checkStraight(ranks))
						return STRAIGHT;
				break;
				case 6:
					if (checkStraight(ranks))
						return STRAIGHT;
					for (i = 0; i < ranks.length; i = i + 2) 
					{
						if (ranks[i] != ranks[i + 1])
							return NOT_RELATION;
						if (i < ranks.length - 2)
						{
							if (ranks[i] + 1 != ranks[i + 2])
								return NOT_RELATION
						}
					}
					return THREE_PAIR;
				break;
				case 8:
					if (checkStraight(ranks))
						return STRAIGHT;
					for (i = 0; i < ranks.length; i = i + 2) 
					{
						if (ranks[i] != ranks[i + 1])
							return NOT_RELATION;
						if (i < ranks.length - 2)
						{
							if (ranks[i] + 1 != ranks[i + 2])
								return NOT_RELATION
						}
					}
					return FOUR_PAIR;
				break;
				default:
					if (checkStraight(ranks))
						return STRAIGHT;
			}
			return NOT_RELATION;
		}
		
		// Hàm so sánh bài của mình và bài của đối thử, trả về 1 là bài của mình lớn hơn, trả về 2 là bài của mình nhỏ hơn
		public function compareTwoDeck(myDeck:Array, opponentDeck:Array):int
		{
			if (opponentDeck.length == 0)
			{
				if (getNameFromDeck(myDeck) != NOT_RELATION)
					return 1;
				else if(myDeck.length == 1)
					return 1;
				else	
					return 2;
			}
			var myRanks:Array = new Array();
			for (var i:int = 0; i < myDeck.length; i++) 
			{
				myRanks.push(convertIdToRank(myDeck[i]));
			}
			myRanks.sort(Array.NUMERIC);
			myDeck.sort(Array.NUMERIC);
			
			var opponentRanks:Array = new Array();
			for (i = 0; i < opponentDeck.length; i++) 
			{
				opponentRanks.push(convertIdToRank(opponentDeck[i]));
			}
			opponentRanks.sort(Array.NUMERIC);
			opponentDeck.sort(Array.NUMERIC);
			
			var opponentDeckName:String = getNameFromDeck(opponentDeck);
			trace(opponentDeckName)
			switch (getNameFromDeck(opponentDeck)) 
			{
				case ONE_PAIR:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck))
					{
						if (myDeck[myDeck.length - 1] > opponentDeck[opponentDeck.length - 1])
							return 1;
					}
					else
					{
						if (opponentRanks[0] == 13) // Nếu đối thủ đánh đôi 2
						{
							if (getNameFromDeck(myDeck) == FOUR_OF_A_KIND)
								return 1;
							else if (getNameFromDeck(myDeck) == FOUR_PAIR)
								return 1;
						}
					}
				break;
				case THREE_PAIR:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck))
					{
						if (myDeck[myDeck.length - 1] > opponentDeck[opponentDeck.length - 1])
							return 1;
					}
					else if (getNameFromDeck(myDeck) == FOUR_PAIR || getNameFromDeck(myDeck) == FOUR_OF_A_KIND)
					{
						return 1;
					}
				break;
				case FOUR_PAIR:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck))
					{
						if (myDeck[myDeck.length - 1] > opponentDeck[opponentDeck.length - 1])
							return 1;
					}
				break;
				case THREE_OF_A_KIND:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck))
					{
						if (myRanks[0] > opponentRanks[0])
							return 1;
					}
				break;
				case FOUR_OF_A_KIND:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck))
					{
						if (myRanks[0] > opponentRanks[0])
							return 1;
					}
					else if (getNameFromDeck(myDeck) == FOUR_PAIR)
					{
						return 1;
					}
				break;
				case STRAIGHT:
					if (getNameFromDeck(myDeck) == getNameFromDeck(opponentDeck) && myDeck.length == opponentDeck.length)
					{
						if (myDeck[myDeck.length - 1] > opponentDeck[opponentDeck.length - 1])
							return 1;
					}
				break;
				default:
					if (myRanks.length == 1)
					{
						if (myDeck[0] > opponentDeck[0])
							return 1;
					}
					else
					{
						if (opponentRanks[0] == 13) // Nếu đối thủ đánh quân 2
						{
							if (getNameFromDeck(myDeck) == THREE_PAIR)
								return 1;
							else if (getNameFromDeck(myDeck) == FOUR_OF_A_KIND)
								return 1;
							else if (getNameFromDeck(myDeck) == FOUR_PAIR)
								return 1;
						}
					}
			}
			return 2;
		}
		
		public function checkStraight(cardsRank:Array):Boolean
		{
			for (var i:int = 0; i < cardsRank.length; i++)
			{
				if (cardsRank[i] == 13) // nếu có con 2 trong bộ thì chắc chắn ko phải là sảnh
					return false;
			}
			for (i = 0; i < cardsRank.length - 1; i++) 
			{
				if (cardsRank[i] != cardsRank[i + 1] - 1)
					return false;
			}
			return true;
		}
		
		public function convertIdToRank(id:int):int
		{
			return Math.ceil(id / 4);
		}
		
		public function convertIdToSuite(id:int):int
		{
			if (id < 14)
				return 1;
			else if (id > 13 && id < 27)
				return 2;
			else if (id > 26 && id < 40)
				return 3;
			else if (id > 39)
				return 4;
			return 0;
		}
	}

}