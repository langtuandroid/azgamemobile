package view.card 
{
	import flash.display.MovieClip;
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
		}
		
	}

}