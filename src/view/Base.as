package view 
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Bim kute
	 */
	public class Base extends MovieClip
	{
		public var content:MovieClip;
		protected var _textformatWin:TextFormat = new TextFormat();
		protected var _textformatLose:TextFormat = new TextFormat();
		protected var _textformatUser:TextFormat = new TextFormat();
		protected var _textformatMoney:TextFormat = new TextFormat();
		protected var _textformatNormal:TextFormat = new TextFormat();
		protected var _textformatNormalMoney:TextFormat = new TextFormat();
		public function Base() 
		{
			_textformatLose.color = 0xff0000;
			_textformatWin.color = 0x009900;
			_textformatUser.color = 0xffffff;
			_textformatUser.bold = true;
			
			_textformatMoney.color = 0xE1E100;
			_textformatMoney.bold = true;
			
			_textformatNormal.color = 0xD3D3D3;
			_textformatNormal.bold = false;
			_textformatNormalMoney.color = 0xA4A400;
			_textformatNormalMoney.bold = false;
			
			
		}
		protected function addContent(str:String, nameSwf:String):void 
		{
			
			
		}
		
		protected function removeContent():void 
		{
			removeChild(content);
			content = null;
		}
		
		protected var _shadow:Sprite;
		protected function createShadow():void 
		{
			_shadow = new Sprite();
			_shadow.graphics.beginFill(0x000000, .4);
			_shadow.graphics.drawRect(0, 0, 1024, 768);
			_shadow.graphics.endFill();
			addChild(_shadow);
			//_shadow.visible = false;
		}
		protected function clearShadow():void 
		{
			_shadow.visible = false;
			/*removeChild(_shadow);
			_shadow = null;*/
		}
		
		protected function format(number:Number):String 
		{
			var numString:String = number.toString()
			var result:String = ''

			while (numString.length > 3)
			{
					var chunk:String = numString.substr(-3)
					numString = numString.substr(0, numString.length - 3)
					result = ',' + chunk + result
			}

			if (numString.length > 0)
			{
					result = numString + result
			}

			return result
		}
	}

}