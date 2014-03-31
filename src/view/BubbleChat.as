package view 
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BubbleChat extends Sprite 
	{
		private var content:zBubbleChat;
		
		public function BubbleChat() 
		{
			content = new zBubbleChat();
			content.txt.width = 120;
			content.background.width = 128;
			content.txt.autoSize = TextFieldAutoSize.LEFT;
			content.txt.wordWrap = true;
			addChild(content);
		}
		
		public function addString(s:String):void
		{
			content.txt.text = s;
			content.background.height = content.txt.height + 22;
		}
		
	}

}