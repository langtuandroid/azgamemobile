package logic 
{
	import com.adobe.serialization.json.JSON;
	import event.DataFieldMauBinh;
	import view.card.CardMauBinh;
	import view.card.CardManagerMauBinh;
	import view.userInfo.playerInfo.PlayerInfoMauBinh;
	/**
	 * ...
	 * @author Yun
	 */
	public class MauBinhLogic 
	{
		public var groupName:Array = ["", "Thùng phá sảnh", "Tứ quý", "Cù lũ", "Thùng", "Sảnh", "Sám cô", "Thú", "Độn", "Mậu thầu"];
		
		public function MauBinhLogic() 
		{
			
		}
		
		private static var _instance:MauBinhLogic;
		public static function getInstance():MauBinhLogic
		{
			if (!_instance)
				_instance = new MauBinhLogic();
			return _instance;
		}
		
		public function checkGroup(type:int, cards:Array):int
		{
			var startIndex:int;
			var endIndex:int;
			var tempArray:Array = new Array();
			var i:int;
			switch (type) 
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
			
			for (i = endIndex; i >= startIndex; i--) 
			{
				tempArray.push(CardMauBinh(cards[i]).id);
			}
			
			return checkGroupDetail(tempArray);
		}
		
		private function checkGroupDetail(cards:Array):int 
		{
			var i:int;
			var j:int;
			var type:int;
			
			cards.sort(Array.NUMERIC);
			
			var rankArray:Array = new Array;
			var suitArray:Array = new Array;
			for (i = 0; i < cards.length; i++) 
			{
				rankArray.push(convertIdToRank(cards[i]));
				suitArray.push(convertIdToSuite(cards[i]));
			}
			rankArray.sort(Array.NUMERIC);
			suitArray.sort(Array.NUMERIC);
				
			if (cards.length == 5)
			{
				if (checkFlush(suitArray.concat()))
					type = 4;
				if (checkStraight(rankArray.concat()))
				{
					if (type == 4)
						type = 1;
					else
						type = 5;
				}
				
				if (type == 1)
				{
					return type;
				}
				else
				{
					if (checkFourOfAKind(rankArray.concat()))
						return 2;
					else if (checkFullHouse(rankArray.concat())) 
						return 3;
					else if (type == 4 || type == 5)
						return type;
					else if (checkThreeOfAKind(rankArray.concat()))
						return 6;
					else if (checkTwoPair(rankArray.concat()))
						return 7;
					else if (checkOnePair(rankArray.concat()))
						return 8;
					else
						return 9;
				}
			}
			else
			{
				if (rankArray[0] == rankArray[1] && rankArray[0] == rankArray[2])
					return 6;
				else if (rankArray[0] == rankArray[1] || rankArray[0] == rankArray[2] || rankArray[1] == rankArray[2])
					return 8;
				else
					return 9;
			}
			
			return 0;
		}
		
		private function checkOnePair(cards:Array):Boolean 
		{
			var count:int = 0;
			var i:int;
			for (i = 0; i < cards.length - 1; i++)
			{
				if (cards[i] == cards[i + 1])
					count++;
			}
			if (count == 1)
				return true;
			return false;
		}
		
		private function checkTwoPair(cards:Array):Boolean 
		{
			var count:int = 0;
			var i:int;
			for (i = 0; i < cards.length - 1; i++)
			{
				if (cards[i] == cards[i + 1])
					count++;
			}
			if (count == 2)
				return true;
			return false;
		}
		
		private function checkThreeOfAKind(cards:Array):Boolean 
		{
			var count1:int = 0;
			var value:int = cards[2];
			var i:int;
			for (i = 0; i < cards.length; i++)
			{
				if (cards[i] == value)
					count1++;
			}
			if (count1 == 3)
				return true;
			return false;
		}
		
		private function checkFourOfAKind(cards:Array):Boolean 
		{
			var count:int = 0;
			var i:int;
			var value:int;
			if (cards[0] == cards[1])
				value = cards[0];
			else
				value = cards[1];
			for (i = 0; i < cards.length; i++)
			{
				if (cards[i] == value)
					count++;
			}
			if (count == 4)
				return true;
			return false;
		}
		
		private function checkFullHouse(cards:Array):Boolean 
		{
			var count1:int = 0;
			var count2:int = 0;
			var value:int = cards[0];
			var value2:int = cards[cards.length - 1];
			var i:int;
			for (i = 0; i < cards.length; i++)
			{
				if (cards[i] == value)
					count1++;
				if (cards[i] == value2)
					count2++;
			}
			if (count1 + count2 == 5)
				return true;
			return false;
		}
		
		private function checkStraight(cards:Array):Boolean
		{
			var i:int;
			var idOfAce:int = -1;
			for (i = 0; i < cards.length; i++)
			{
				if (cards[i] == 1)
					idOfAce = i;
			}
			
			if (idOfAce != -1)
			{
				for (i = 0; i < cards.length; i++)
				{
					if (cards[i] == 13)
					{
						cards[idOfAce] = 14;
						cards.sort(Array.NUMERIC);
						break;
					}
				}
			}
			
			for (i = 0; i < cards.length - 1; i++)
			{
				if (cards[i] + 1 != cards[i + 1])
				{
					if(idOfAce != -1)
						cards[idOfAce] = 1;
					return false;
				}
			}
			if(idOfAce != -1)
				cards[idOfAce] = 1;
			return true;
		}
		
		private function checkFlush(cards:Array):Boolean
		{
			var i:int;
			for (i = 0; i < cards.length - 1; i++)
			{
				if (cards[i] != cards[i + 1])
					return false;
			}
			return true;
		}
		
		public function convertIdToRank(id:int, isAce:Boolean = false):int
		{
			if (id % 13 == 0)
			{
				return 13;
			}
			else
			{
				if (isAce && id % 13 == 1)
					return 14;
				return id % 13;
			}
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
		
		public function convertIdToString(id:int):String
		{
			var rank:int = convertIdToRank(id);
			var suit:int = convertIdToSuite(id);
			var rankName:String;
			switch (rank) 
			{
				case 1:
					rankName = "A";
				break;
				case 11:
					rankName = "J";
				break;
				case 12:
					rankName = "Q";
				break;
				case 13:
					rankName = "K";
				break;
				default:
					rankName = String(rank);
			}
			
			var suitName:String;
			switch (suit) 
			{
				case 1:
					suitName = "bích";
				break;
				case 2:
					suitName = "tép";
				break;
				case 3:
					suitName = "zô";
				break;
				case 4:
					suitName = "cơ";
				break;
				default:
			}
			
			return rankName + " " + suitName;
		}
		
		public function checkSoldierBreak(deckRank:Array, cards:Array):Boolean
		{
			if (deckRank[3] < deckRank[2] || deckRank[2] < deckRank[1])
				return true;
			if (deckRank[3] == deckRank[2] && deckRank[2] == deckRank[1])
			{
				if (deckOneStrongerDeckTwo(3, 2, cards, deckRank) || deckOneStrongerDeckTwo(2, 1, cards, deckRank))
					return true;
			}
			if (deckRank[3] == deckRank[2] && deckOneStrongerDeckTwo(3, 2, cards, deckRank))
				return true;
			if (deckRank[2] == deckRank[1] && deckOneStrongerDeckTwo(2, 1, cards, deckRank))
				return true;
			return false;
		}
		
		private function deckOneStrongerDeckTwo(deckOneIndex:int, deckTwoIndex:int, cards:Array, deckRank:Array):Boolean 
		{
			var deck1:Array = new Array();
			var deck2:Array = new Array();
			var i:int;
			if (deckOneIndex == 3) // Nếu so sánh chi 3 với chi 2
			{
				for (i = 0; i < 3; i++) 
				{
					deck1.push(CardMauBinh(cards[i]).id);
				}
				for (i = 3; i < 8; i++) 
				{
					deck2.push(CardMauBinh(cards[i]).id);
				}
				
				switch (deckRank[3]) 
				{
					case 6:
						if (compareThreeOfAKind(deck1, deck2))
							return true;
					break;
					case 8:
						if (compareOnePair(deck1, deck2))
							return true;
					break;
					default:
						if (compareDifferentGroup(deck1, deck2))
							return true;
					break;
				}
			}
			else // Nếu so sánh chi 2 với chi 1
			{
				for (i = 3; i < 8; i++) 
				{
					deck1.push(CardMauBinh(cards[i]).id);
				}
				for (i = 8; i < 13; i++) 
				{
					deck2.push(CardMauBinh(cards[i]).id);
				}
				
				switch (deckRank[2]) 
				{
					/*case 1:
						if (compareDifferentGroup(deck1, deck2, true))
							return true;
					break;*/
					case 2:
						if (compareFourOfAKind(deck1, deck2))
							return true;
					break;
					case 3:
						if (compareFullHouse(deck1, deck2))
							return true;
					break;
					case 4:
						if (compareDifferentGroup(deck1, deck2))
							return true;
					break;
					/*case 5:
						if (compareDifferentGroup(deck1, deck2, true))
							return true;
					break;*/
					case 6:
						if (compareThreeOfAKind(deck1, deck2))
							return true;
					break;
					case 7:
						if (compareTwoPair(deck1, deck2))
							return true;
					break;
					case 8:
						if (compareOnePair(deck1, deck2))
							return true;
					break;
					default:
						if (compareDifferentGroup(deck1, deck2))
							return true;
					break;
				}
			}
			return false;
		}
		
		private function compareFullHouse(deck1:Array, deck2:Array):Boolean
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				if (convertIdToRank(deck1[i]) == 1)
					rankArray1.push(14);
				else
					rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				if (convertIdToRank(deck2[i]) == 1)
					rankArray2.push(14);
				else
					rankArray2.push(convertIdToRank(deck2[i]));
			}
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			
			var value1:int;
			var value2:int;
			
			if (rankArray1[0] == rankArray1[2])
				value1 = rankArray1[0];
			else
				value1 = rankArray1[4];
			if (rankArray2[0] == rankArray2[2])
				value2 = rankArray2[0];
			else
				value2 = rankArray2[4];
			if (value1 > value2)
				return true;
			else
				return false;
		}
		
		private function compareDifferentGroup(deck1:Array, deck2:Array, isCheckAce:Boolean = false):Boolean
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				if (convertIdToRank(deck1[i]) == 1)
					rankArray1.push(14);
				else
					rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				if (convertIdToRank(deck2[i]) == 1)
					rankArray2.push(14);
				else
					rankArray2.push(convertIdToRank(deck2[i]));
			}
			
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			
			if (isCheckAce)
			{
				if (rankArray1[0] == 2)
				{
					rankArray1[4] = 1;
					rankArray1.sort(Array.NUMERIC);
				}
				if (rankArray2[0] == 2)
				{
					rankArray2[4] = 1;
					rankArray2.sort(Array.NUMERIC);
				}
			}
			
			if (rankArray1.length == 3 || rankArray2.length == 2)
			{
				for (i = 2; i >= 0; i--) 
				{
					if (rankArray1[i] > rankArray2[i + 2])
						return true;
					else if (rankArray1[i] < rankArray2[i + 2]) 
						return false;
				}
			}
			else
			{
				for (i = 4; i >= 0; i--) 
				{
					if (rankArray1[i] > rankArray2[i])
						return true;
					else if (rankArray1[i] < rankArray2[i]) 
						return false;
				}
			}
			return false;
		}
		
		private function compareFourOfAKind(deck1:Array, deck2:Array):Boolean 
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				if (convertIdToRank(deck1[i]) == 1)
					rankArray1.push(14);
				else
					rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				if (convertIdToRank(deck2[i]) == 1)
					rankArray2.push(14);
				else
					rankArray2.push(convertIdToRank(deck2[i]));
			}
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			var value1:int;
			var value2:int;
			if (rankArray1[0] == rankArray1[1])
				value1 = rankArray1[0];
			else
				value1 = rankArray1[4];
			if (rankArray2[0] == rankArray2[1])
				value2 = rankArray2[0];
			else
				value2 = rankArray2[4];
			if (value1 == value2)
			{
				if (rankArray1[0] == rankArray1[1])
					value1 = rankArray1[4];
				else
					value1 = rankArray1[0];
				if (rankArray2[0] == rankArray2[1])
					value2 = rankArray2[4];
				else
					value2 = rankArray2[0];
				if (value1 <= value2)
					return false;
				else
					return true;
			}
			else if (value1 > value2)
				return true;
			return false;
		}
		
		private function compareThreeOfAKind(deck1:Array, deck2:Array):Boolean 
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				rankArray2.push(convertIdToRank(deck2[i]));
			}
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			if (rankArray1[2] == 1)
				return true;
			if (rankArray2[2] == 1)
				return false;
			if (rankArray1[2] > rankArray2[2])
				return true;
			return false;
		}
		
		private function compareTwoPair(deck1:Array, deck2:Array):Boolean 
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				if (convertIdToRank(deck1[i]) == 1)
					rankArray1.push(14);
				else
					rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				if (convertIdToRank(deck2[i]) == 1)
					rankArray2.push(14);
				else
					rankArray2.push(convertIdToRank(deck2[i]));
			}
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			var value1a:int;
			var value1b:int;
			var value1c:int;
			var value2a:int;
			var value2b:int;
			var value2c:int;
			if (rankArray1[4] != rankArray1[3])
			{
				value1a = rankArray1[2];
				value1b = rankArray1[0];
				value1c = rankArray1[4];
			}
			else if (rankArray1[0] != rankArray1[1])
			{
				value1a = rankArray1[4];
				value1b = rankArray1[2];
				value1c = rankArray1[0];
			}
			else
			{
				value1a = rankArray1[4];
				value1b = rankArray1[0];
				value1c = rankArray1[2];
			}
			
			if (rankArray2[4] != rankArray2[3])
			{
				value2a = rankArray2[2];
				value2b = rankArray2[0];
				value2c = rankArray2[4];
			}
			else if (rankArray2[0] != rankArray2[1])
			{
				value2a = rankArray2[4];
				value2b = rankArray2[2];
				value2c = rankArray2[0];
			}
			else
			{
				value2a = rankArray2[4];
				value2b = rankArray2[0];
				value2c = rankArray2[2];
			}
			
			if (value1a == value2a)
			{
				if (value1b == value2b)
				{
					if (value1c <= value2c)
						return false;
					else
						return true;
				}
				else
				{
					if (value1b > value2b)
						return true;
					else
						return false;
				}
			}
			else if (value1a > value2a)
				return true;
			return false;
		}
		
		private function compareOnePair(deck1:Array, deck2:Array):Boolean 
		{
			var i:int;
			var rankArray1:Array = new Array;
			var rankArray2:Array = new Array;
			for (i = 0; i < deck1.length; i++) 
			{
				if (convertIdToRank(deck1[i]) == 1)
					rankArray1.push(14);
				else
					rankArray1.push(convertIdToRank(deck1[i]));
			}
			for (i = 0; i < deck2.length; i++) 
			{
				if (convertIdToRank(deck2[i]) == 1)
					rankArray2.push(14);
				else
					rankArray2.push(convertIdToRank(deck2[i]));
			}
			rankArray1.sort(Array.NUMERIC);
			rankArray2.sort(Array.NUMERIC);
			var value1:int;
			var value2:int;
			for (i = 0; i < rankArray1.length - 1; i++) 
			{
				if (rankArray1[i] == rankArray1[i + 1])
				{
					value1 = rankArray1[i];
					rankArray1.splice(i, 1);
					rankArray1.splice(i, 1);
					i = 5;
				}
			}
			for (i = 0; i < rankArray2.length - 1; i++) 
			{
				if (rankArray2[i] == rankArray2[i + 1])
				{
					value2 = rankArray2[i];
					rankArray2.splice(i, 1);
					rankArray2.splice(i, 1);
					i = 5;
				}
			}
			if (value1 == value2)
			{
				if (deck1.length == 3)
				{
					if (rankArray1[0] <= rankArray2[2])
						return false;
					else if (rankArray1[0] > rankArray2[2])
						return true;
				}
				else
				{
					for (i = 2; i >= 0; i--) 
					{
						if (rankArray1[i] > rankArray2[i])
							return true;
						else if (rankArray1[i] < rankArray2[i]) 
							return false;
					}
					return false;
				}
			}
			else if (value1 > value2)
				return true;
			return false;
		}
		
		// check 3 thùng
		public function check3Thung(cards:Array):Boolean
		{
			var suitArray:Array = new Array();
			for (var i:int = 0; i < 3; i++) 
			{
				suitArray.push(convertIdToSuite(CardMauBinh(cards[i]).id));
			}
			if (suitArray[0] == suitArray[1] && suitArray[0] == suitArray[2])
				return true;
			return false;
		}
		
		// check 3 sảnh
		public function check3Sanh(cards:Array):Boolean
		{
			var rankArray:Array = new Array();
			for (var i:int = 0; i < 3; i++) 
			{
				rankArray.push(convertIdToRank(CardMauBinh(cards[i]).id));
			}
			rankArray.sort(Array.NUMERIC);
			if (rankArray[0] + 1 == rankArray[1] && rankArray[0] + 2 == rankArray[2])
				return true;
			if (rankArray[1] == 12 && rankArray[2] == 13 && rankArray[0] == 1)
				return true;
			return false;
		}
		
		public function check12CayCungMau(cards:Array):Boolean
		{
			var countBlack:int = 0;
			var countRed:int = 0;
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (convertIdToSuite(cards[i].id) == 1 || convertIdToSuite(cards[i].id) == 2)
					countBlack++;
				if (convertIdToSuite(cards[i].id) == 3 || convertIdToSuite(cards[i].id) == 4)
					countRed++;
			}
			if (countBlack == 12)
				return true;
			if (countRed == 12)
				return true;
			return false;
		}
		
		public function checkIsAce(cardId:int):Boolean
		{
			if (convertIdToRank(cardId) == 1)
				return true;
			return false;
		}
		
		public function check13CayCungMau(cards:Array):Boolean
		{
			var countBlack:int = 0;
			var countRed:int = 0;
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (convertIdToSuite(cards[i].id) == 1 || convertIdToSuite(cards[i].id) == 2)
					countBlack++;
				if (convertIdToSuite(cards[i].id) == 3 || convertIdToSuite(cards[i].id) == 4)
					countRed++;
			}
			if (countBlack == 13)
				return true;
			if (countRed == 13)
				return true;
			return false;
		}
		
		public function arrangeWhen6Doi(cards:Array):void
		{
			var tempArray:Array = new Array();
			var countDouble:int = 0;
			var singleCard:CardMauBinh;
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (!tempArray[convertIdToRank(cards[i].id)])
					tempArray[convertIdToRank(cards[i].id)] = 1;
				else
					tempArray[convertIdToRank(cards[i].id)]++;
				if (tempArray[convertIdToRank(cards[i].id)] == 2 || tempArray[convertIdToRank(cards[i].id)] == 4)
					countDouble++;
			}
			for (i = 0; i < cards.length; i++) 
			{
				if (tempArray[convertIdToRank(cards[i].id)] == 1)
				{
					singleCard = cards.splice(i, 1)[0];
					break;
				}
			}
			arrangeAllCard(cards);
			cards.unshift(singleCard);
		}
		
		public function check6Doi(cards:Array):Boolean
		{
			var tempArray:Array = new Array();
			var countDouble:int = 0;
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (!tempArray[convertIdToRank(cards[i].id)])
					tempArray[convertIdToRank(cards[i].id)] = 1;
				else
					tempArray[convertIdToRank(cards[i].id)]++;
				if (tempArray[convertIdToRank(cards[i].id)] == 2 || tempArray[convertIdToRank(cards[i].id)] == 4)
					countDouble++;
			}
			if (countDouble == 6)
				return true;
			return false;
		}
		
		public function arrangeWhen5Doi1Xam(cards:Array):void
		{
			var tempArray:Array = new Array();
			var countDouble:int = 0;
			var countTriple:int = 0;
			var tripleIdArray:Array = new Array();
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (!tempArray[convertIdToRank(cards[i].id)])
					tempArray[convertIdToRank(cards[i].id)] = 1;
				else
					tempArray[convertIdToRank(cards[i].id)]++;
				if (tempArray[convertIdToRank(cards[i].id)] == 2 || tempArray[convertIdToRank(cards[i].id)] == 4)
				{
					if (tempArray[convertIdToRank(cards[i].id)] == 4)
					{
						for (var j:int = 0; j < tripleIdArray.length; j++) 
						{
							if (convertIdToRank(cards[i].id) == tripleIdArray[j])
								tripleIdArray.splice(j, 1);
						}
						countTriple--;
					}
					countDouble++;
				}
				if (tempArray[convertIdToRank(cards[i].id)] == 3)
				{
					tripleIdArray.push(convertIdToRank(cards[i].id));
					countTriple++;
				}
			}
			var tripleArray:Array = new Array();
			for (i = cards.length - 1; i >= 0; i--)
			{
				if (convertIdToRank(cards[i].id) == tripleIdArray[0])
					tripleArray.push(cards.splice(i, 1)[0]);
			}
			arrangeAllCard(cards);
			cards.unshift(tripleArray[0]);
			cards.unshift(tripleArray[1]);
			cards.unshift(tripleArray[2]);
		}
		
		public function check5Doi1Xam(cards:Array):Boolean
		{
			var tempArray:Array = new Array();
			var countDouble:int = 0;
			var countTriple:int = 0;
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				if (!tempArray[convertIdToRank(cards[i].id)])
					tempArray[convertIdToRank(cards[i].id)] = 1;
				else
					tempArray[convertIdToRank(cards[i].id)]++;
				if (tempArray[convertIdToRank(cards[i].id)] == 2 || tempArray[convertIdToRank(cards[i].id)] == 4)
				{
					if (tempArray[convertIdToRank(cards[i].id)] == 4)
						countTriple--;
					countDouble++;
				}
				if (tempArray[convertIdToRank(cards[i].id)] == 3)
					countTriple++;
			}
			if (countDouble >= 6 && countTriple == 1)
				return true;
			return false;
		}
		
		public function checkSanhRong(cards:Array):Boolean
		{
			var tempArray:Array = new Array();
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				tempArray.push(convertIdToRank(cards[i].id));
			}
			tempArray.sort(Array.NUMERIC);
			for (i = 0; i < tempArray.length - 1; i++) 
			{
				if (tempArray[i] != tempArray[i + 1] - 1)
					return false;
			}
			return true;
		}
		
		public function checkSanhRongCuon(cards:Array):Boolean
		{
			var tempArray:Array = new Array();
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				tempArray.push(convertIdToRank(cards[i].id));
			}
			tempArray.sort(Array.NUMERIC);
			for (i = 0; i < tempArray.length - 1; i++) 
			{
				if (tempArray[i] != tempArray[i + 1] - 1)
					return false;
			}
			return true;
		}
		
		public function checkMauThau(idArray:Array):String
		{
			var maxValue:int = 0;
			for (var i:int = 0; i < idArray.length; i++) 
			{
				if (convertIdToRank(idArray[i], true) > maxValue)
					maxValue = convertIdToRank(idArray[i], true);
			}
			var tempNum:int = -1 * maxValue;
			return String(tempNum);
		}
		
		public function arrangeAllCard(cards:Array, isIncrease:Boolean = true):void
		{
			var arrangeFinish:Boolean;
			while (!arrangeFinish)
			{
				arrangeFinish = true;
				for (var i:int = 0; i < cards.length - 1; i++) 
				{
					if (isIncrease)
					{
						trace(convertIdToRank(CardMauBinh(cards[i]).id),convertIdToRank(CardMauBinh(cards[i + 1]).id));
						if (convertIdToRank(CardMauBinh(cards[i]).id) > convertIdToRank(CardMauBinh(cards[i + 1]).id))
						{
							trace("swap");
							var tempCard:CardMauBinh = cards[i];
							cards[i] = cards[i + 1];
							cards[i + 1] = tempCard;
							arrangeFinish = false;
						}
					}
					else
					{
						if (CardMauBinh(cards[i]).id > CardMauBinh(cards[i + 1]).id)
						{
							tempCard = cards[i];
							cards[i] = cards[i + 1];
							cards[i + 1] = tempCard;
							arrangeFinish = false;
						}
					}
				}
			}
		}
		
		public function arrangeGroup(cards:Array, deckRank:Array, arrangeGroup1:Boolean = true, arrangeGroup2:Boolean = true, arrangeGroup3:Boolean = true):void
		{
			if (cards.length == 0)
				return;
			var isArrangeFinish:Boolean;
			var tempCard:CardMauBinh;
			var i:int;
			
			if (arrangeGroup3)
			{
				isArrangeFinish = false;
				var isAce:Boolean;
				while (!isArrangeFinish)
				{
					isArrangeFinish = true;
					for (i = 0; i < 2; i++) 
					{
						if (convertIdToRank(cards[i].id) > convertIdToRank(cards[i + 1].id))
						{
							tempCard = cards[i];
							cards[i] = cards[i + 1];
							cards[i + 1] = tempCard;
							isArrangeFinish = false;
						}
					}
				}
				if (convertIdToRank(cards[0].id) == 1)
				{
					if (convertIdToRank(cards[1].id) == 12 && convertIdToRank(cards[2].id) == 13)
					{
						tempCard = cards[0];
						cards[0] = cards[1];
						cards[1] = tempCard;
						tempCard = cards[1];
						cards[1] = cards[2];
						cards[2] = tempCard;
					}
				}
				
				if (deckRank[3] == 8)
				{
					if (convertIdToRank(cards[0].id) != convertIdToRank(cards[1].id))
					{
						tempCard = cards[0];
						cards[0] = cards[2];
						cards[2] = tempCard;
					}
				}
			}
			
			if (arrangeGroup2)
			{
				isArrangeFinish = false;
				while (!isArrangeFinish)
				{
					isAce = true;
					if ((deckRank[2] == 1 || deckRank[2] == 5))
					{
						isAce = false;
						for (i = 3; i < 8; i++) 
						{
							if (convertIdToRank(cards[i].id) > 5)
							{
								isAce = true;
								i = 8;
							}
						}
					}
					isArrangeFinish = true;
					for (i = 3; i < 7; i++) 
					{
						if (convertIdToRank(cards[i].id, isAce) > convertIdToRank(cards[i + 1].id, isAce))
						{
							tempCard = cards[i];
							cards[i] = cards[i + 1];
							cards[i + 1] = tempCard;
							isArrangeFinish = false;
						}
					}
				}
				
				switch (deckRank[2]) 
				{
					case 2:
						if (convertIdToRank(cards[3].id) != convertIdToRank(cards[4].id))
						{
							tempCard = cards[3];
							cards[3] = cards[7];
							cards[7] = tempCard;
						}
					break;
					case 3:
						if (convertIdToRank(cards[4].id) != convertIdToRank(cards[5].id))
						{
							tempCard = cards[3];
							cards[3] = cards[7];
							cards[7] = tempCard;
							tempCard = cards[4];
							cards[4] = cards[6];
							cards[6] = tempCard;
						}
					break;
					case 6:
						if (convertIdToRank(cards[3].id) != convertIdToRank(cards[5].id) && convertIdToRank(cards[7].id) != convertIdToRank(cards[5].id))
						{
							tempCard = cards[3];
							cards[3] = cards[6];
							cards[6] = tempCard;
						}
						else if (convertIdToRank(cards[3].id) != convertIdToRank(cards[4].id))
						{
							tempCard = cards[3];
							cards[3] = cards[7];
							cards[7] = tempCard;
							tempCard = cards[4];
							cards[4] = cards[6];
							cards[6] = tempCard;
						}
					break;
					case 7:
						if (convertIdToRank(cards[3].id) != convertIdToRank(cards[4].id))
						{
							tempCard = cards[5];
							cards[5] = cards[7];
							cards[7] = tempCard;
							tempCard = cards[3];
							cards[3] = cards[7];
							cards[7] = tempCard;
						}
						else if (convertIdToRank(cards[5].id) != convertIdToRank(cards[6].id) && convertIdToRank(cards[5].id) != convertIdToRank(cards[4].id))
						{
							tempCard = cards[5];
							cards[5] = cards[7];
							cards[7] = tempCard;
						}
					break;
					case 8:
						if (convertIdToRank(cards[4].id) == convertIdToRank(cards[5].id))
						{
							tempCard = cards[3];
							cards[3] = cards[5];
							cards[5] = tempCard;
						}
						else if (convertIdToRank(cards[5].id) == convertIdToRank(cards[6].id))
						{
							tempCard = cards[3];
							cards[3] = cards[5];
							cards[5] = tempCard;
							tempCard = cards[4];
							cards[4] = cards[6];
							cards[6] = tempCard;
						}
						else if (convertIdToRank(cards[6].id) == convertIdToRank(cards[7].id))
						{
							tempCard = cards[3];
							cards[3] = cards[6];
							cards[6] = tempCard;
							tempCard = cards[4];
							cards[4] = cards[7];
							cards[7] = tempCard;
							tempCard = cards[5];
							cards[5] = cards[6];
							cards[6] = tempCard;
							tempCard = cards[6];
							cards[6] = cards[7];
							cards[7] = tempCard;
						}
					break;
				}
			}
			
			if (arrangeGroup1)
			{
				isArrangeFinish = false;
				while (!isArrangeFinish)
				{
					isAce = true;
					if ((deckRank[1] == 1 || deckRank[1] == 5))
					{
						isAce = false;
						for (i = 8; i < 13; i++) 
						{
							if (convertIdToRank(cards[i].id) > 5)
							{
								isAce = true;
								i = 13;
							}
						}
					}
					isArrangeFinish = true;
					for (i = 8; i < 12; i++) 
					{
						if (convertIdToRank(cards[i].id, isAce) > convertIdToRank(cards[i + 1].id, isAce))
						{
							tempCard = cards[i];
							cards[i] = cards[i + 1];
							cards[i + 1] = tempCard;
							isArrangeFinish = false;
						}
					}
				}
				
				switch (deckRank[1]) 
				{
					case 2:
						if (convertIdToRank(cards[8].id) != convertIdToRank(cards[9].id))
						{
							tempCard = cards[8];
							cards[8] = cards[12];
							cards[12] = tempCard;
						}
					break;
					case 3:
						if (convertIdToRank(cards[9].id) != convertIdToRank(cards[10].id))
						{
							tempCard = cards[8];
							cards[8] = cards[12];
							cards[12] = tempCard;
							tempCard = cards[9];
							cards[9] = cards[11];
							cards[11] = tempCard;
						}
					break;
					case 6:
						if (convertIdToRank(cards[8].id) != convertIdToRank(cards[10].id) && convertIdToRank(cards[12].id) != convertIdToRank(cards[10].id))
						{
							tempCard = cards[8];
							cards[8] = cards[11];
							cards[11] = tempCard;
						}
						else if (convertIdToRank(cards[8].id) != convertIdToRank(cards[9].id))
						{
							tempCard = cards[8];
							cards[8] = cards[12];
							cards[12] = tempCard;
							tempCard = cards[9];
							cards[9] = cards[11];
							cards[11] = tempCard;
						}
					break;
					case 7:
						if (convertIdToRank(cards[8].id) != convertIdToRank(cards[9].id))
						{
							tempCard = cards[10];
							cards[10] = cards[12];
							cards[12] = tempCard;
							tempCard = cards[8];
							cards[8] = cards[12];
							cards[12] = tempCard;
						}
						else if (convertIdToRank(cards[10].id) != convertIdToRank(cards[11].id) && convertIdToRank(cards[10].id) != convertIdToRank(cards[9].id))
						{
							tempCard = cards[10];
							cards[10] = cards[12];
							cards[12] = tempCard;
						}
					break;
					case 8:
						if (convertIdToRank(cards[9].id) == convertIdToRank(cards[10].id))
						{
							tempCard = cards[8];
							cards[8] = cards[10];
							cards[10] = tempCard;
						}
						else if (convertIdToRank(cards[10].id) == convertIdToRank(cards[11].id))
						{
							tempCard = cards[8];
							cards[8] = cards[10];
							cards[10] = tempCard;
							tempCard = cards[9];
							cards[9] = cards[11];
							cards[11] = tempCard;
						}
						else if (convertIdToRank(cards[11].id) == convertIdToRank(cards[12].id))
						{
							tempCard = cards[8];
							cards[8] = cards[11];
							cards[11] = tempCard;
							tempCard = cards[9];
							cards[9] = cards[12];
							cards[12] = tempCard;
							tempCard = cards[10];
							cards[10] = cards[11];
							cards[11] = tempCard;
							tempCard = cards[11];
							cards[11] = cards[12];
							cards[12] = tempCard;
						}
					break;
				}
			}
			
		}
	}

}