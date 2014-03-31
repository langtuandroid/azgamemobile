package view.window 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import logic.MauBinhLogic;
	import view.card.CardMauBinh;
	/**
	 * ...
	 * @author Yun
	 */
	public class SpecialGroupWindow extends BaseWindow 
	{
		public static const THREE_STRAIGHT_FORM:String = "threeStraightForm";
		public static const THREE_FLUSH_FORM:String = "threeFlushForm";
		public static const SIX_PAIR_FORM:String = "sixPairForm";
		public static const FIVE_PAIR_ONE_THREE_FORM:String = "fivePairOneThreeForm";
		public static const STRAIGHT_DRAGON_FORM:String = "straightDragonForm";
		public static const FLY_DRAGON_FORM:String = "flyDragonForm";
		public static const TWELVE_RED_ONE_BLACK_FORM:String = "twelveRedOneBlackForm";
		public static const TWELVE_BLACK_ONE_RED_FORM:String = "twelveBlackOneRedForm";
		public static const THIRTEEN_BLACK_FORM:String = "thirteenBlackForm";
		public static const THIRTEEN_RED_FORM:String = "thirteenRedForm";
		private var currentForm:String;
		private var cardArray:Array;
		
		public function SpecialGroupWindow() 
		{
			addContent("zSpecialGroupWindow");
			
			for (var i:int = 0; i < content.numChildren; i++) 
			{
				content.getChildAt(i).visible = false;
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (cardArray)
			{
				for (var i:int = 0; i < cardArray.length; i++) 
				{
					CardMauBinh(cardArray[i]).simpleOpen();
				}
			}
		}
		
		public function setType(t:int):void
		{
			switch (t) 
			{
				case 21: // ba sanh
					currentForm = THREE_STRAIGHT_FORM;
				break;
				case 22: // ba thung
					currentForm = THREE_FLUSH_FORM;
				break;
				case 23: // luc phe bon
					currentForm = SIX_PAIR_FORM;
				break;
				case 24: // 5 doi 1 xam
					currentForm = FIVE_PAIR_ONE_THREE_FORM;
				break;
				case 25: // 12 la do 1 den
					currentForm = TWELVE_RED_ONE_BLACK_FORM;
				break;
				case 26: // 12 la den 1 do
					currentForm = TWELVE_BLACK_ONE_RED_FORM;
				break;
				case 27: // 13 la den
					currentForm = THIRTEEN_BLACK_FORM;
				break;
				case 28: // 13 la do
					currentForm = THIRTEEN_RED_FORM;
				break;
				case 29: // sanh rong
					currentForm = STRAIGHT_DRAGON_FORM;
				break;
				case 30: // rong cuon
					currentForm = FLY_DRAGON_FORM;
				break;
			}
			content[currentForm].visible = true;
		}
		
		public function addCard(cards:Array):void
		{
			var maubinhLogic:MauBinhLogic = new MauBinhLogic();
			var isArrangeFinish:Boolean;
			var tempCard:CardMauBinh;
			var i:int;
			isArrangeFinish = false;
			
			if (currentForm == THREE_FLUSH_FORM || currentForm == THREE_STRAIGHT_FORM)
			{
				cardArray = new Array();
				var distance:Number;
				if (currentForm == THREE_FLUSH_FORM || currentForm == THREE_STRAIGHT_FORM)
					distance = 15;
				else
					distance = 18;
				for (i = 0; i < cards.length; i++) 
				{
					tempCard = new CardMauBinh();
					tempCard.id = cards[i];
					tempCard.scaleX = tempCard.scaleY = 0.59;
					cardArray.push(tempCard);
					if (i == 0)
					{
						tempCard.x = content[currentForm]["position1"].x;
					}
					else if (i == 5)
					{
						tempCard.x = content[currentForm]["position2"].x;
					}
					else if (i == 10)
					{
						tempCard.x = content[currentForm]["position3"].x;
					}
					else
					{
						tempCard.x = cardArray[i - 1].x + distance;
					}
					tempCard.y = content[currentForm]["position1"].y;
					content[currentForm].addChild(tempCard);
				}
				return;
			}
			var isAce:Boolean;
			if (currentForm == FLY_DRAGON_FORM || currentForm == STRAIGHT_DRAGON_FORM)
				isAce = true;
			else
				isAce = false;
			while (!isArrangeFinish)
			{
				isArrangeFinish = true;
				for (i = 0; i < cards.length - 1; i++) 
				{
					if (maubinhLogic.convertIdToRank(cards[i], isAce) > maubinhLogic.convertIdToRank(cards[i + 1], isAce))
					{
						cards[i] += cards[i + 1];
						cards[i + 1] = cards[i] - cards[i + 1];
						cards[i] -= cards[i + 1];
						isArrangeFinish = false;
					}
				}
			}
			
			var tempValue:int = -1;
			var tempArrayValue:Array;
			if (currentForm == SIX_PAIR_FORM)
			{
				for (i = 0; i < cards.length - 1; i = i + 2)
				{
					if (maubinhLogic.convertIdToRank(cards[i]) != maubinhLogic.convertIdToRank(cards[i + 1]))
					{
						tempValue = cards.splice(i, 1);
						i = cards.length + 1;
					}
				}
				if (tempValue != -1)
					cards.push(tempValue);
			}
			else if (currentForm == FIVE_PAIR_ONE_THREE_FORM)
			{
				for (i = 0; i < cards.length - 2; i = i + 2)
				{
					if (maubinhLogic.convertIdToRank(cards[i]) == maubinhLogic.convertIdToRank(cards[i + 1]) && maubinhLogic.convertIdToRank(cards[i + 1]) == maubinhLogic.convertIdToRank(cards[i + 2]))
					{
						tempArrayValue = new Array();
						tempArrayValue.push(cards.splice(i, 1));
						tempArrayValue.push(cards.splice(i, 1));
						tempArrayValue.push(cards.splice(i, 1));
						i = cards.length + 1;
					}
				}
				cards = tempArrayValue.concat(cards);
			}
			
			cardArray = new Array();
			if (currentForm == THREE_FLUSH_FORM || currentForm == THREE_STRAIGHT_FORM)
				distance = 15;
			else
				distance = 18;
			for (i = 0; i < cards.length; i++) 
			{
				tempCard = new CardMauBinh();
				tempCard.id = cards[i];
				tempCard.scaleX = tempCard.scaleY = 0.59;
				cardArray.push(tempCard);
				if (i == 0)
				{
					tempCard.x = content[currentForm]["position1"].x;
				}
				else if (i == 5)
				{
					tempCard.x = content[currentForm]["position2"].x;
				}
				else if (i == 10)
				{
					tempCard.x = content[currentForm]["position3"].x;
				}
				else
				{
					tempCard.x = cardArray[i - 1].x + distance;
				}
				tempCard.y = content[currentForm]["position1"].y;
				content[currentForm].addChild(tempCard);
			}
		}
	}

}