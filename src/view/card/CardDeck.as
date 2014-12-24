package view.card 
{
	import flash.display.MovieClip;
	import model.MyDataTLMN;
	import view.Base;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class CardDeck extends Base 
	{
		
		public function CardDeck() 
		{
			content = new MyCardDeck();
			addChild(content);
			
			if (MyDataTLMN.getInstance().isGame == 1) 
			{
				content.gotoAndStop(1);
			}
			else if (MyDataTLMN.getInstance().isGame == 2) 
			{
				content.gotoAndStop(2);
			}
			
		}
		
	}

}