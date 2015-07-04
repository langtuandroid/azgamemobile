package chat.view.chatRow 
{
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.bytearray.tools.SmileyRenderer;
	
	/**
	 * ...
	 * @author 
	 */
	public class ChatRow extends Sprite 
	{
		private var fontDescription:FontDescription;
		public var mapper:Dictionary;
		public var regExp:RegExp;
		public var chatContainerWidth:int;
		public var format:ElementFormat;
		private var lineNumber:int;
		private var lineHeight:Number = 16;
		
		public function ChatRow() 
		{
			
		}
		
		public function addContent(sentence:String, displayName:String, isSystemMess:Boolean = false, isMe:Boolean = false):void
		{
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = new TextFormat("Tahoma", 12);
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.text = displayName + ": ";
			
			if (isSystemMess)
			{
				var tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 12;
				tempFormat.fontDescription = fontDescription;
				tempFormat.color = 0xFFFF00;
				
				format = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				format.fontSize = 12;
				format.fontDescription = fontDescription;
				format.color = 0xFFFF00;
			}
			else
			{
				tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 12;
				tempFormat.fontDescription = fontDescription;
				if (isMe)
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 12;
					format.fontDescription = fontDescription;
					format.color = 0x0099FF;
					tempFormat.color = 0x0099FF;
				}
				else
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 12;
					format.fontDescription = fontDescription;
					format.color = 0xffffff;
					tempFormat.color = 0xffffff;
				}
			}
			
			var nameTextField:SmileyRenderer = new SmileyRenderer(mapper, tempFormat, tempTextField.width);
			nameTextField.lineHeight = lineHeight;
			nameTextField.text = "[" + displayName + "]";
			
			var distanceString:String = "";
			
			tempTextField.text = '';
			while (nameTextField.width > tempTextField.width)
			{
				distanceString += " ";
				tempTextField.text = distanceString;
			}
			distanceString += "  ";
			
			var smileyText:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 9);
			
			var tempSmiley:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 2);
			tempSmiley.text = "aaaaaaa";
			
			smileyText.lineHeight = lineHeight;
			smileyText.standardHeight = tempSmiley.firstLine.height;
			smileyText.reg = regExp;
			
			smileyText.text = distanceString + sentence;
			if (nameTextField.height < smileyText.firstLine.height)
				smileyText.y = - (smileyText.firstLine.height - nameTextField.height) - 1;
			addChild(smileyText);
			addChild(nameTextField);
			lineNumber = smileyText.lineNumber;
		}
		
		public override function get height():Number 
		{
			return lineNumber * lineHeight;
		}
	}

}