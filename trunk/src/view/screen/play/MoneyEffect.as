package view.screen.play 
{
	import com.greensock.TweenMax;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import view.Base;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class MoneyEffect extends Base 
	{
		//private var _textformatWin:TextFormat = new TextFormat("Tahoma", 42);
		//private var _textformatLose:TextFormat = new TextFormat("Tahoma", 42);
		public function MoneyEffect() 
		{
			//_textformatLose.color = 0xff0000;
			//_textformatWin.color = 0x00ff00;
			content = new MyMoneyEffect();
			addChild(content);
			
			TextField(content.moneyTxt).mouseEnabled = false;
			
			this.visible = false;
		}
		
		public function showEffect(money:String):void 
		{
			if (int(money) < 0) 
			{
				TextField(content.moneyTxt).defaultTextFormat = _textformatLose;
			}
			else 
			{
				TextField(content.moneyTxt).defaultTextFormat = _textformatLose;
			}
			
			this.visible = true;
			content.moneyTxt.text = money;
			TweenMax.to(content.moneyTxt, 5, { y: content.moneyTxt.y - 60, onComplete:onComplete } );
		}
		
		private function onComplete():void 
		{
			this.visible = false;
			content.moneyTxt.y += 30;
		}
	}

}