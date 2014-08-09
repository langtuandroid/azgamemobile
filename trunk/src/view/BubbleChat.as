package view 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class BubbleChat extends Sprite 
	{
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";
		private var content:zBubbleChat;
		
		public function BubbleChat(type:String) 
		{
			content = new zBubbleChat();
			addChild(content);
			MovieClip(content).gotoAndStop(type);
		}
		
		public function addString(s:String):void
		{
			content.txt.text = s;
		}
		
	}

}