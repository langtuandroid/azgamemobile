package logic 
{
	import com.adobe.serialization.json.JSON;
	import view.card.CardPhom;
	import view.card.CardManagerPhom;
	import view.userInfo.playerInfo.PlayerInfoPhom;
	/**
	 * ...
	 * @author Yun
	 */
	public class PhomLogic 
	{
		public function PhomLogic() 
		{
			
		}
		
		private static var _instance:PhomLogic;
		public static function getInstance():PhomLogic
		{
			if (!_instance)
				_instance = new PhomLogic();
			return _instance;
		}
		
		/**
		 * - Hàm để xét lại thứ tự vòng mỗi khi có người chơi vừa ăn một lá
		 * @param	stealPlayer - người ăn bài
		 * @param	stealedPlayer - người bị ăn
		 * @param	playerArray - mảng chứa các người chơi
		 */
		public function setOrderRound(stealPlayer:PlayerInfoPhom, stealedPlayer:PlayerInfoPhom, playerArray:Array):void
		{
			var i:int;
			var startIndex:int;
			var card:CardPhom;
			for (i = 0; i < playerArray.length; i++)
			{
				if (playerArray[i] == stealPlayer)
				{
					startIndex = i;
					i = playerArray.length;
				}
			}
			
			var player:PlayerInfoPhom;
			var beforePlayer:PlayerInfoPhom;
			
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
					player.pushNewLeavedCard(card, CardManagerPhom.playCardTime * 1.4);
				}
			}
			for (i = playerArray.length - 1; i > startIndex; i--) 
			{
				player = playerArray[i];
				beforePlayer = playerArray[i - 1];
				if (beforePlayer.leavedCards.length > player.leavedCards.length && player != stealPlayer)
				{
					card = beforePlayer.popOneLeavedCard(0);
					player.pushNewLeavedCard(card, CardManagerPhom.playCardTime * 1.4);
				}
			}
		}
		
		// Hàm check xem có phải là phỏm hợp lệ hay không
		public function checkCardDeck(cardArray:Array):Boolean
		{
			if (cardArray.length < 3)
				return false;
				
			var isWireDeck:Boolean;
			var i:int;
			
			// Đếm số lá là stealCard
			var stealCardNumber:int = 0;
			for (i = 0; i < cardArray.length; i++)
			{
				if (CardPhom(cardArray[i]).isStealCard)
					stealCardNumber++;
			}
			if (stealCardNumber > 1)
				return false;
				
			if ((CardPhom(cardArray[0]).id - CardPhom(cardArray[1]).id) % 13 != 0) // check xem có phải phỏm sáp không, nếu không thì là phỏm dây
				isWireDeck = true;
				
			if (isWireDeck)
			{
				var minValue:int = 52;
				for (i = 0; i < cardArray.length; i++) 
				{
					if (minValue > CardPhom(cardArray[i]).id)
						minValue = CardPhom(cardArray[i]).id;
				}
				
				for (i = 0; i < cardArray.length; i++) 
				{
					if (Math.ceil(CardPhom(cardArray[i]).id / 13) != Math.ceil(minValue / 13)) // Nếu là khác chất thì return false
						return false;
					if (CardPhom(cardArray[i]).id - minValue > cardArray.length - 1)
						return false;
				}
			}
			else
			{
				for (i = 0; i < cardArray.length; i++) 
				{
					if ((CardPhom(cardArray[0]).id - CardPhom(cardArray[i]).id) % 13 != 0)
						return false;
				}
			}
			return true;
		}
		
		// Kiểm tra xem giá trị của card vừa ăn có hợp lệ không
		public function checkStealCard(stealCard:CardPhom, cardArray:Array):Boolean 
		{
			if (!stealCard)
				return false;
				
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			
			var card:CardPhom = new CardPhom();
			card.id = stealCard.id;
			card.isStealCard = true;
			var tempArray:Array = cardArray.concat(card);
			var stealCardNumber:int = 0;
			
			for (i = 0; i < tempArray.length; i++) 
			{
				if (CardPhom(tempArray[i]).isStealCard)
					stealCardNumber++;
			}
			
			var deckArray:Array = countDeck(tempArray);
			
			switch (stealCardNumber) 
			{
				case 1: // Nếu ăn một con bài thì chỉ cần check con bài đó có cạ với các quân bài chưa đánh
					return checkStealCardChild(stealCard, cardArray);
				break;
				case 2: // Nếu ăn 2 con bài thì phải tìm ra 2 phỏm riêng rẽ, mỗi phỏm chứa 1 con bài ăn
					for (i = 0; i < deckArray.length - 1; i++)
					{
						for (j = i + 1; j < deckArray.length; j++)
						{
							if (!compareTwoDeck(deckArray[i], deckArray[j]))
							{
								var countStealCard:int = 0;
								for (k = 0; k < deckArray[i].length; k++)
								{
									if (CardPhom(deckArray[i][k]).isStealCard)
										countStealCard++;
									if (CardPhom(deckArray[j][k]).isStealCard)
										countStealCard++;
								}
								if (countStealCard == 2)
									return true;
							}
						}
					}
					return false;
				break;
				case 3: // Nếu ăn 3 con bài thì phải tìm ra 3 phỏm riêng rẽ, mỗi phỏm chứa 1 con bài ăn
					for (i = 0; i < deckArray.length - 2; i++)
					{
						for (j = i + 1; j < deckArray.length - 1; j++)
						{
							for (k = j + 1; k < deckArray.length; k++) 
							{
								if (!compareTwoDeck(deckArray[i], deckArray[j]) && !compareTwoDeck(deckArray[j], deckArray[k]) && !compareTwoDeck(deckArray[i], deckArray[k]))
								{
									countStealCard = 0;
									for (l = 0; l < deckArray[i].length; l++)
									{
										if (CardPhom(deckArray[i][l]).isStealCard)
											countStealCard++;
										if (CardPhom(deckArray[j][l]).isStealCard)
											countStealCard++;
										if (CardPhom(deckArray[k][l]).isStealCard)
											countStealCard++;
									}
									if (countStealCard == 3)
										return true;
								}
							}
						}
					}
					return false;
				break;
			}
			return false;
		}
		
		// Tìm lá bài bài ăn được trong mảng
		private function getStealCard(cardArray:Array):CardPhom
		{
			for (var i:int = 0; i < cardArray.length; i++) 
			{
				if (CardPhom(cardArray[i]).isStealCard)
				{
					var card:CardPhom = cardArray[i];
					cardArray.splice(i, 1);
					return card;
				}
			}
			return null;
		}
		
		// tìm xem trong mảng các quân bài có chứa 2 lá kết hợp với lá bài ăn thành phỏm không
		private function checkStealCardChild(stealCard:CardPhom, cardArray:Array):Boolean
		{
			var deck:Array;
			var newCardArray:Array = cardArray.concat();
			var i:int;
			var j:int;
			
			for (i = 0; i < newCardArray.length - 1; i++)
			{
				for (j = i + 1; j < newCardArray.length; j++)
				{
					if (!CardPhom(newCardArray[i]).isStealCard && !CardPhom(newCardArray[j]).isStealCard)
					{
						deck = new Array();
						deck.push(stealCard);
						deck.push(newCardArray[i]);
						deck.push(newCardArray[j]);
						if (checkCardDeck(deck))
						{
							return true;
						}
					}
				}
			}
			return false
		}
		
		// Hàm check xem có thể đánh con bài đó không
		public function checkPlayCard(card:CardPhom, cardArray:Array):Boolean
		{
			if (card.isStealCard)
				return false;
			
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			
			var newCardArray:Array = cardArray.concat();
			for (i = 0; i < newCardArray.length; i++) 
			{
				if (card == newCardArray[i])
				{
					newCardArray.splice(i, 1);
					i = newCardArray.length + 1;
				}
			}
			
			var stealCard:CardPhom;
			var stealCardNumber:int = 0;
			
			for (i = 0; i < newCardArray.length; i++) // Đếm số con bài đã ăn
			{
				if (CardPhom(newCardArray[i]).isStealCard)
				{
					stealCard = CardPhom(newCardArray[i]);
					stealCardNumber++;
				}
			}
			
			if (stealCardNumber == 0) // Nếu chưa ăn con bài nào thì lá nào cũng đánh được
			{
				return true;
			}
			else
			{
				var deckArray:Array = countDeck(newCardArray);
				switch (stealCardNumber) 
				{
					case 1: // Nếu ăn một con bài thì chỉ cần check con bài đó có cạ với các quân bài chưa đánh
						return checkStealCardChild(stealCard, newCardArray)
					break;
					case 2: // Nếu ăn 2 con bài thì phải tìm ra 2 phỏm riêng rẽ, mỗi phỏm chứa 1 con bài ăn
						for (i = 0; i < deckArray.length - 1; i++)
						{
							for (j = i + 1; j < deckArray.length; j++)
							{
								if (!compareTwoDeck(deckArray[i], deckArray[j]))
								{
									var countStealCard:int = 0;
									for (k = 0; k < deckArray[i].length; k++)
									{
										if (CardPhom(deckArray[i][k]).isStealCard)
											countStealCard++;
										if (CardPhom(deckArray[j][k]).isStealCard)
											countStealCard++;
									}
									if (countStealCard == 2)
										return true;
								}
							}
						}
						return false;
					break;
					case 3: // Nếu ăn 3 con bài thì phải tìm ra 3 phỏm riêng rẽ, mỗi phỏm chứa 1 con bài ăn
						for (i = 0; i < deckArray.length - 2; i++)
						{
							for (j = i + 1; j < deckArray.length - 1; j++)
							{
								for (k = j + 1; k < deckArray.length; k++) 
								{
									if (!compareTwoDeck(deckArray[i], deckArray[j]) && !compareTwoDeck(deckArray[j], deckArray[k]) && !compareTwoDeck(deckArray[i], deckArray[k]))
									{
										countStealCard = 0;
										for (l = 0; l < deckArray[i].length; l++)
										{
											if (CardPhom(deckArray[i][l]).isStealCard)
												countStealCard++;
											if (CardPhom(deckArray[j][l]).isStealCard)
												countStealCard++;
											if (CardPhom(deckArray[k][l]).isStealCard)
												countStealCard++;
										}
										if (countStealCard == 3)
											return true;
									}
								}
							}
						}
						return false;
					break;
				}
			}
			return true;
		}
		
		public function checkFullDeck(cardArray:Array):Boolean
		{
			var deckArray:Array = countDeck(cardArray);
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var m:int;
			
			for (i = 0; i < deckArray.length - 2; i++) // Tìm 3 phỏm khác nhau
			{
				for (j = i + 1; j < deckArray.length - 1; j++)
				{
					for (k = j + 1; k < deckArray.length; k++) 
					{
						if (!compareTwoDeck(deckArray[i], deckArray[j]) && !compareTwoDeck(deckArray[j], deckArray[k]) && !compareTwoDeck(deckArray[i], deckArray[k]))
						{
							for (m = 0; m < cardArray.length; m++)
							{
								var isDifferentCard:Boolean = true;
								for (l = 0; l < deckArray[i].length; l++)
								{
									if (deckArray[i][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[j][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[k][l] == cardArray[m])
										isDifferentCard = false;
								}
								// Tránh trường hợp còn thứ 10 không thuộc 3 phỏm là con bài ăn
								if (isDifferentCard && !CardPhom(cardArray[m]).isStealCard)
									return true;
							}
						}
					}
				}
			}
			
			for (i = 0; i < deckArray.length - 1; i++) // Tìm 2 phỏm khác nhau có độ dài tổng là 9
			{
				for (j = i + 1; j < deckArray.length; j++)
				{
					if (!compareTwoDeck(deckArray[i], deckArray[j]))
					{
						var newArray:Array = cardArray.concat();
						for (k = 0; k < deckArray[i].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[i][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						for (k = 0; k < deckArray[j].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[j][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						findFullDeck(deckArray[i], newArray);
						findFullDeck(deckArray[j], newArray);
						if (deckArray[i].length + deckArray[j].length >= 9)
						{
							if (newArray.length == 0)
								return true;
							else if (!CardPhom(newArray[0]).isStealCard) // Tránh trường hợp con bài còn lại không thuộc 2 phỏm là con bài ăn
								return true;
						}
					}
				}
			}
			
			return false;
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
					if (CardPhom(deck[i]).id > CardPhom(deck[i + 1]).id)
					{
						var tempCard:CardPhom = deck[i];
						deck[i] = deck[i + 1];
						deck[i + 1] = tempCard;
						arrangeFinish = false;
					}
				}
			}
		}
		
		public function compareTwoDeck(deck1:Array, deck2:Array):Boolean
		{
			var isRelationship:Boolean;
			for (var i:int = 0; i < deck1.length; i++) 
			{
				for (var j:int = 0; j < deck2.length; j++) 
				{
					if (CardPhom(deck1[i]).id == CardPhom(deck2[j]).id)
					{
						isRelationship = true;
						return isRelationship;
					}
				}
			}
			return isRelationship;
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
		
		public function checkSendCard(cardArray:Array, friendDeckArray:Array):Boolean
		{
			if (friendDeckArray.length == 0)
				return false;
			for (var i:int = 0; i < cardArray.length; i++) 
			{
				var tempArray:Array = (friendDeckArray as Array).concat();
				tempArray.push(cardArray[i]);
				if (checkCardDeck(tempArray))
					return true;
			}
			return false;
		}
		
		public function arrangeUnleaveCard(cardArray:Array, isIncrease:Boolean = true):Array
		{
			var deckArray:Array = countDeck(cardArray);
			
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
			
			// Đếm số lá bài ăn
			for (i = 0; i < cardArray.length; i++)
			{
				if (CardPhom(cardArray[i]).isStealCard)
					stealCardNumber++;
			}
			
			if (deckArray.length > 0) // trường hợp chỉ có 1 phỏm
			{
				if (stealCardNumber > 0 ) // Nếu có con bài ăn thì ưu tiên phỏm có con bài ăn
				{
					for (i = 0; i < deckArray.length; i++)
					{
						countStealCard = 0;
						for (k = 0; k < deckArray[i].length; k++)
						{
							if (CardPhom(deckArray[i][k]).isStealCard)
								countStealCard++;
						}
						if (countStealCard > 0)
						{
							selectedDeckArray.push(deckArray[i]);
							i = deckArray.length + 1;
						}
					}
				}
				else // Nếu không có con bài ăn
				{
					selectedDeckArray.push(deckArray[0]);
				}
			}
				
			for (i = 0; i < deckArray.length - 1; i++) // trường hợp có 2 phỏm
			{
				for (j = i + 1; j < deckArray.length; j++)
				{
					if (!compareTwoDeck(deckArray[i], deckArray[j])) // Tìm ra 2 phỏm khác nhau
					{
						var twoDeckIsTrue:Boolean;
						switch (stealCardNumber) 
						{
							case 0: // Nếu có một lá bài ăn thì kiểm tra xem 2 phỏm đó có một phỏm phải chứa lá bài ăn
								twoDeckIsTrue = true;
							break;
							case 1: // Nếu có một lá bài ăn thì kiểm tra xem 2 phỏm đó có một phỏm phải chứa lá bài ăn
								countStealCard = 0;
								for (k = 0; k < deckArray[i].length; k++)
								{
									if (CardPhom(deckArray[i][k]).isStealCard)
										countStealCard++;
									if (CardPhom(deckArray[j][k]).isStealCard)
										countStealCard++;
								}
								if (countStealCard > 0)
									twoDeckIsTrue = true;
							break;
							case 2: // Nếu có hai lá bài ăn thì cả 2 phỏm đều phải có chứa lá bài ăn
								countStealCard = 0;
								for (k = 0; k < deckArray[i].length; k++)
								{
									if (CardPhom(deckArray[i][k]).isStealCard)
										countStealCard++;
									if (CardPhom(deckArray[j][k]).isStealCard)
										countStealCard++;
								}
								if (countStealCard == 2)
									twoDeckIsTrue = true;
							break;
						}
						if (twoDeckIsTrue)
						{
							selectedDeckArray = new Array();
							selectedDeckArray.push(deckArray[i]);
							selectedDeckArray.push(deckArray[j]);
							i = deckArray.length + 1;
							j = deckArray.length + 1
						}
					}
				}
			}
			
			var newCardArray:Array = new Array();
			
			for (i = 0; i < selectedDeckArray.length; i++)
			{
				for (j = 0; j < selectedDeckArray[i].length; j++)
				{
					for (k = 0; k < cardArray.length; k++)
					{
						if (cardArray[k] == selectedDeckArray[i][j])
						{
							newCardArray.push(cardArray[k]);
							cardArray.splice(k, 1);
							k = cardArray.length + 1;
						}
					}
				}
			}
			
			var object:Object;
			for (i = 0; i < selectedDeckArray.length; i++)
			{
				findFullDeck(selectedDeckArray[i], cardArray);
				arrangeDeck(selectedDeckArray[i]);
			}
			
			newCardArray = new Array();
			for (i = 0; i < selectedDeckArray.length; i++)
			{
				for (j = 0; j < selectedDeckArray[i].length; j++)
				{
					newCardArray.push(selectedDeckArray[i][j]);
				}
			}
			
			arrangeCardNoDeck(cardArray, isIncrease);
			newCardArray = newCardArray.concat(cardArray);
			return newCardArray;
		}
		
		// check xem lá bài vừa bốc có tạo thành phỏm ko
		public function checkNewCard(cardArray:Array, newCard:CardPhom):Boolean
		{
			var deckArray:Array = countDeck(cardArray);
			
			for (var i:int = 0; i < deckArray.length; i++) 
			{
				for (var j:int = 0; j < deckArray[i].length; j++) 
				{
					if (newCard.id == deckArray[i][j].id)
						return true;
				}
			}
			
			return false;
		}
		
		// Hàm để tìm triệt để xem còn cạ nào của deck trong cardArray không
		private function findFullDeck(deck:Array, cardArray:Array):void
		{
			var isFindFinish:Boolean;
			while (!isFindFinish)
			{
				isFindFinish = true;
				for (var i:int = 0; i < cardArray.length; i++) 
				{
					var newDeck:Array = deck.concat();
					newDeck.push(cardArray[i]);
					if (checkCardDeck(newDeck))
					{
						deck.push(cardArray[i]);
						cardArray.splice(i, 1);
						isFindFinish = false;
					}
				}
			}
		}
		
		public function arrangeCardNoDeck(cardArray:Array, isIncrease:Boolean = true):void
		{
			var arrangeFinish:Boolean;
			while (!arrangeFinish)
			{
				arrangeFinish = true;
				for (var i:int = 0; i < cardArray.length - 1; i++) 
				{
					if (convertIdToRank(cardArray[i].id) > convertIdToRank(cardArray[i + 1].id))
					{
						var tempCard:CardPhom = cardArray[i];
						cardArray[i] = cardArray[i + 1];
						cardArray[i + 1] = tempCard;
						arrangeFinish = false;
					}
				}
			}
			
			//if (isIncrease)
				//return;
			
			arrangeFinish = false;
			var cardNumber:int = cardArray.length;
			var lengthCheck:int = cardArray.length;
			
			for (var j:int = 0; j < cardNumber; j++) 
			{
				for (i = 0; i < lengthCheck; i++) 
				{
					if (i > 0)
						var rankPrevious:int = convertIdToRank(cardArray[i - 1].id);
					else
						rankPrevious = -10;
					var rankCurrent:int = convertIdToRank(cardArray[i].id);
					
					if (i < lengthCheck - 1)
						var rankNext:int = convertIdToRank(cardArray[i + 1].id);
					else
						rankNext = -10;
					
					if (i > 0)
						var suitPrevious:int = convertIdToSuit(cardArray[i - 1].id);
					else
						suitPrevious = -10;
					var suitCurrent:int = convertIdToSuit(cardArray[i].id);
					
					if (i < lengthCheck - 1)
						var suitNext:int = convertIdToSuit(cardArray[i + 1].id);
					else
						suitNext = -10;
					
					if (rankPrevious != rankCurrent && rankNext != rankCurrent)
					{
						if (suitPrevious == suitCurrent && Math.abs(rankPrevious - rankCurrent) <= 2)
						{
							
						}
						else if (suitNext == suitCurrent && Math.abs(rankNext - rankCurrent) <= 2)
						{
							
						}
						else
						{
							tempCard = cardArray.splice(i, 1)[0];
							cardArray.push(tempCard);
							lengthCheck--;
							break;
						}
					}
				}
			}
		}
		
		public function checkDownCard(cardArray:Array):Array
		{
			//if (checkCardDeck(cardArray))
				//return [cardArray];
			
			var deckArray:Array = countDeck(cardArray);
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var m:int;
			
			// truong hop co 1 phom
			if (deckArray.length > 0 && cardArray.length < 6)
			{
				var newArray:Array = cardArray.concat();
				for (k = 0; k < deckArray[0].length; k++)
				{
					for (l = 0; l < newArray.length; l++)
					{
						if (newArray[l] == deckArray[0][k])
						{
							newArray.splice(l, 1);
							l = newArray.length + 1;
						}
					}
				}
				findFullDeck(deckArray[0], newArray);
				
				if (deckArray[0].length == cardArray.length)
					return [cardArray];
			}
				
			var downCardArray:Array = new Array();
			// truong hop co 2 phom
			for (i = 0; i < deckArray.length - 1; i++)
			{
				for (j = i + 1; j < deckArray.length; j++)
				{
					if (!compareTwoDeck(deckArray[i], deckArray[j]))
					{
						newArray = cardArray.concat();
						for (k = 0; k < deckArray[i].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[i][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						for (k = 0; k < deckArray[j].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[j][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						findFullDeck(deckArray[i], newArray);
						findFullDeck(deckArray[j], newArray);
						
						if (deckArray[i].length + deckArray[j].length >= cardArray.length)
						{
							downCardArray = new Array();
							downCardArray.push(deckArray[i]);
							downCardArray.push(deckArray[j]);
							if (convertIdToRank(CardPhom(deckArray[i][0]).id) == convertIdToRank(CardPhom(deckArray[i][1]).id) && deckArray[i].length == 4) // Uu tien phom tu quy
								return downCardArray;
							if (convertIdToRank(CardPhom(deckArray[j][0]).id) == convertIdToRank(CardPhom(deckArray[j][1]).id) && deckArray[j].length == 4) // Uu tien phom tu quy
								return downCardArray;
						}
					}
				}
			}
			
			if (downCardArray.length >= 2)
				return downCardArray;
			
			// truong hop co 3 phom
			for (i = 0; i < deckArray.length - 2; i++) // Tìm 3 phỏm khác nhau
			{
				for (j = i + 1; j < deckArray.length - 1; j++)
				{
					for (k = j + 1; k < deckArray.length; k++) 
					{
						if (!compareTwoDeck(deckArray[i], deckArray[j]) && !compareTwoDeck(deckArray[j], deckArray[k]) && !compareTwoDeck(deckArray[i], deckArray[k]))
						{
							if (cardArray.length == 10)
							{
								if (deckArray[i].length + deckArray[j].length + deckArray[k].length == cardArray.length)
								{
									downCardArray.push(deckArray[i]);
									downCardArray.push(deckArray[j]);
									downCardArray.push(deckArray[k]);
									return downCardArray;
								}
							}
							
							for (m = 0; m < cardArray.length; m++)
							{
								var isDifferentCard:Boolean = true;
								for (l = 0; l < deckArray[i].length; l++)
								{
									if (deckArray[i][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[j][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[k][l] == cardArray[m])
										isDifferentCard = false;
								}
								// Tránh trường hợp con thứ 10 không thuộc 3 phỏm là con bài ăn
								if (isDifferentCard && !CardPhom(cardArray[m]).isStealCard)
								{
									var tempArray:Array = deckArray[i].concat();
									tempArray.push(cardArray[m])
									if (checkCardDeck(tempArray))
									{
										downCardArray = new Array();
										downCardArray.push(tempArray);
										downCardArray.push(deckArray[j]);
										downCardArray.push(deckArray[k]);
										return downCardArray;
									}
									tempArray = deckArray[j].concat();
									tempArray.push(cardArray[m])
									if (checkCardDeck(tempArray))
									{
										downCardArray = new Array();
										downCardArray.push(tempArray);
										downCardArray.push(deckArray[i]);
										downCardArray.push(deckArray[k]);
										return downCardArray;
									}
									tempArray = deckArray[k].concat();
									tempArray.push(cardArray[m])
									if (checkCardDeck(tempArray))
									{
										downCardArray = new Array();
										downCardArray.push(tempArray);
										downCardArray.push(deckArray[i]);
										downCardArray.push(deckArray[j]);
										return downCardArray;
									}
								}
							}
						}
					}
				}
			}
			
			return new Array();
		}
		
		public function convertIdToSuit(id:int):int
		{
			return Math.ceil((id / 13));
		}
		
		public function convertIdToRank(id:int):int
		{
			if (id % 13 == 0)
				return 13;
			return id % 13;
		}
		
		public function countDeck(cardArray:Array):Array
		{
			var deckArray:Array = new Array();
			for (var i:int = 0; i < cardArray.length - 2; i++) 
			{
				for (var j:int = i + 1; j < cardArray.length - 1; j++) 
				{
					for (var k:int = j + 1; k < cardArray.length; k++) 
					{
						var deck:Array = new Array();
						deck.push(cardArray[i]);
						deck.push(cardArray[j]);
						deck.push(cardArray[k]);
						if (checkCardDeck(deck))
						{
							arrangeDeck(deck);
							deckArray.push(deck);
						}
					}
				}
			}
			return deckArray;
		}
		
		// Tìm phỏm để tự động hạ
		public function getDeckToAutoDownCard(cardArray:Array):Array
		{
			var tempCardArray:Array = cardArray.concat();
			var deckArray:Array = countDeck(tempCardArray);
			
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
			
			// Đếm số lá bài ăn
			for (i = 0; i < tempCardArray.length; i++)
			{
				if (CardPhom(tempCardArray[i]).isStealCard)
					stealCardNumber++;
			}
			
			if (deckArray.length > 0) // trường hợp chỉ có 1 phỏm
			{
				if (stealCardNumber > 0 ) // Nếu có con bài ăn thì ưu tiên phỏm có con bài ăn
				{
					for (i = 0; i < deckArray.length; i++)
					{
						countStealCard = 0;
						for (k = 0; k < deckArray[i].length; k++)
						{
							if (CardPhom(deckArray[i][k]).isStealCard)
								countStealCard++;
						}
						if (countStealCard > 0)
						{
							selectedDeckArray.push(deckArray[i]);
							i = deckArray.length + 1;
						}
					}
				}
				else // Nếu không có con bài ăn
				{
					selectedDeckArray.push(deckArray[0]);
				}
			}
				
			for (i = 0; i < deckArray.length - 1; i++) // trường hợp có 2 phỏm
			{
				for (j = i + 1; j < deckArray.length; j++)
				{
					if (!compareTwoDeck(deckArray[i], deckArray[j])) // Tìm ra 2 phỏm khác nhau
					{
						var twoDeckIsTrue:Boolean;
						switch (stealCardNumber) 
						{
							case 0: // Nếu có một lá bài ăn thì kiểm tra xem 2 phỏm đó có một phỏm phải chứa lá bài ăn
								twoDeckIsTrue = true;
							break;
							case 1: // Nếu có một lá bài ăn thì kiểm tra xem 2 phỏm đó có một phỏm phải chứa lá bài ăn
								countStealCard = 0;
								for (k = 0; k < deckArray[i].length; k++)
								{
									if (CardPhom(deckArray[i][k]).isStealCard)
										countStealCard++;
									if (CardPhom(deckArray[j][k]).isStealCard)
										countStealCard++;
								}
								if (countStealCard > 0)
									twoDeckIsTrue = true;
							break;
							case 2: // Nếu có hai lá bài ăn thì cả 2 phỏm đều phải có chứa lá bài ăn
								countStealCard = 0;
								for (k = 0; k < deckArray[i].length; k++)
								{
									if (CardPhom(deckArray[i][k]).isStealCard)
										countStealCard++;
									if (CardPhom(deckArray[j][k]).isStealCard)
										countStealCard++;
								}
								if (countStealCard == 2)
									twoDeckIsTrue = true;
							break;
						}
						if (twoDeckIsTrue)
						{
							selectedDeckArray = new Array();
							selectedDeckArray.push(deckArray[i]);
							selectedDeckArray.push(deckArray[j]);
							i = deckArray.length + 1;
							j = deckArray.length + 1
						}
					}
				}
			}
			
			var newCardArray:Array = new Array();
			
			for (i = 0; i < selectedDeckArray.length; i++)
			{
				for (j = 0; j < selectedDeckArray[i].length; j++)
				{
					for (k = 0; k < tempCardArray.length; k++)
					{
						if (tempCardArray[k] == selectedDeckArray[i][j])
						{
							newCardArray.push(tempCardArray[k]);
							tempCardArray.splice(k, 1);
							k = tempCardArray.length + 1;
						}
					}
				}
			}
			
			for (i = 0; i < selectedDeckArray.length; i++)
			{
				findFullDeck(selectedDeckArray[i], tempCardArray);
			}
			
			return selectedDeckArray;
		}
		
		public function getDeckWhenFullDeck(cardArray:Array):Array
		{
			var deckArray:Array = countDeck(cardArray);
			var fullDeckArray:Array = new Array();
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var m:int;
			
			for (i = 0; i < deckArray.length - 2; i++) // Tìm 3 phỏm khác nhau
			{
				for (j = i + 1; j < deckArray.length - 1; j++)
				{
					for (k = j + 1; k < deckArray.length; k++) 
					{
						if (!compareTwoDeck(deckArray[i], deckArray[j]) && !compareTwoDeck(deckArray[j], deckArray[k]) && !compareTwoDeck(deckArray[i], deckArray[k]))
						{
							for (m = 0; m < cardArray.length; m++)
							{
								var isDifferentCard:Boolean = true;
								for (l = 0; l < deckArray[i].length; l++)
								{
									if (deckArray[i][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[j][l] == cardArray[m])
										isDifferentCard = false;
									if (deckArray[k][l] == cardArray[m])
										isDifferentCard = false;
								}
								// Tránh trường hợp còn thứ 10 không thuộc 3 phỏm là con bài ăn
								if (isDifferentCard && !CardPhom(cardArray[m]).isStealCard)
								{
									fullDeckArray.push(deckArray[i]);
									fullDeckArray.push(deckArray[j]);
									fullDeckArray.push(deckArray[k]);
									return fullDeckArray;
								}
							}
						}
					}
				}
			}
			
			for (i = 0; i < deckArray.length - 1; i++) // Tìm 2 phỏm khác nhau có độ dài tổng là 9
			{
				for (j = i + 1; j < deckArray.length; j++)
				{
					if (!compareTwoDeck(deckArray[i], deckArray[j]))
					{
						var newArray:Array = cardArray.concat();
						for (k = 0; k < deckArray[i].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[i][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						for (k = 0; k < deckArray[j].length; k++)
						{
							for (l = 0; l < newArray.length; l++)
							{
								if (newArray[l] == deckArray[j][k])
								{
									newArray.splice(l, 1);
									l = newArray.length + 1;
								}
							}
						}
						findFullDeck(deckArray[i], newArray);
						findFullDeck(deckArray[j], newArray);
						fullDeckArray.push(deckArray[i]);
						fullDeckArray.push(deckArray[j]);
						if (deckArray[i].length + deckArray[j].length >= 9)
						{
							if (newArray.length == 0)
								return fullDeckArray;
							else if (!CardPhom(newArray[0]).isStealCard) // Tránh trường hợp con bài còn lại không thuộc 2 phỏm là con bài ăn
								return fullDeckArray;
						}
					}
				}
			}
			
			return fullDeckArray;
		}
	}

}