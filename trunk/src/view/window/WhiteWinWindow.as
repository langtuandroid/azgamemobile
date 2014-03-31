package view.window 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import view.card.Card;
	/**
	 * ...
	 * @author Yun
	 */
	public class WhiteWinWindow extends BaseWindow 
	{
		private var cardsArray:Array;
		private var description:TextField;
		public function WhiteWinWindow() 
		{
			addContent("zWhiteWinWindow");
			
			description = content["description"];
			description.autoSize = TextFieldAutoSize.CENTER;
			description.multiline = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			for (var i:int = 0; i < cardsArray.length; i++) 
			{
				Card(cardsArray[i]).simpleOpen();
			}
		}
		
		public function setCardsValue(cardsValue:Array, type:int):void
		{
			var cardsContainer:Sprite = new Sprite();
			cardsArray = new Array();
			cardsValue.sort(Array.NUMERIC);
			for (var i:int = 0; i < cardsValue.length; i++) 
			{
				var card:Card = new Card(0.8);
				cardsArray.push(card);
				card.id = cardsValue[i] + 1;
				card.x = i * 25 + card.width / 2;
				card.y = card.height / 2;
				cardsContainer.addChild(card);
			}
			cardsContainer.x = - cardsContainer.width / 2;
			cardsContainer.y = - cardsContainer.height / 2;
			addChild(cardsContainer);
			
			switch (type) 
			{
				case 0:
					description.text = "Tứ quý 3";
				break;
				case 1:
					description.text = "Ba đôi thông 3 bích";
				break;
				case 2:
					description.text = "Tứ quý 2";
				break;
				case 3:
					description.text = "Sáu đôi cọc cạch";
				break;
				case 4:
					description.text = "Năm đôi thông";
				break;
				case 5:
					description.text = "Sảnh rồng";
				break;
				default:
			}
			//description.y = cardsContainer.y - 10 - description.height;
			//description.x = - description.width / 2;
		}
	}

}