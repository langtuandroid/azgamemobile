package chat.view.chatRow 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
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
	public class ChatAllRowLobby extends MovieClip 
	{
		private var fontDescription:FontDescription;
		public var mapper:Dictionary;
		public var regExp:RegExp;
		public var chatContainerWidth:int;
		public var format:ElementFormat;
		private var lineNumber:int;
		private var lineHeight:Number = 16;
		
		private var content:MovieClip;
		private var loader:Loader;
		
		public function ChatAllRowLobby() 
		{
			content = new ChatAllLobbyRowMc();
			addChild(content);
			
		}
		
		public function addContent(sentence:String, displayName:String, gameName:String, isSystemMess:Boolean = false, isMe:Boolean = false):void
		{
			//trace("game name: ", gameName)
			var gamename:String = '[Tiến lên]';
			if (gameName == "AZGB_TLMN") 
			{
				content.gameNameMc.gotoAndStop(1);
				gamename = '[Tiến lên]';
			}
			else if (gameName == "AZGB_PHOM") 
			{
				content.gameNameMc.gotoAndStop(2);
				gamename = '[Phỏm]';
			}
			else if (gameName == "AZGB_BINH") 
			{
				content.gameNameMc.gotoAndStop(3);
				gamename = '[Binh]';
			}
			else if (gameName == "AZGB_SAM") 
			{
				content.gameNameMc.gotoAndStop(4);
				gamename = '[Sâm]';
			}
			else if (gameName == "AZGB_BACAY") 
			{
				//trace("o chu 3 cay")
				content.gameNameMc.gotoAndStop(5);
				
			}
			else 
			{
				content.gameNameMc.gotoAndStop(1);
			}
			
			content.gameNameMc.visible = false;
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = new TextFormat("Tahoma", 16, 0xFFFFFF);
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.text = gamename + ' ';
			tempTextField.width = tempTextField.textWidth;
			
			var t:TextField = new TextField();
			t.defaultTextFormat = new TextFormat("Tahoma", 16, 0xFFFFFF);
			t.autoSize = TextFieldAutoSize.LEFT;
			t.text = displayName + ':';
			t.width = t.textWidth;
			
			var tf:TextFormat = new TextFormat();
			tf.font = 'Tahoma';
			tf.size = 16;
			tf.color = 0x0099FF;
			
			var tempFormat:ElementFormat;
			if (isSystemMess)
			{
				tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 16;
				tempFormat.fontDescription = fontDescription;
				tempFormat.color = 0xFFFF00;
				
				format = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				format.fontSize = 16;
				format.fontDescription = fontDescription;
				format.color = 0xFFFF00;
			}
			else
			{
				/*tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 16;
				tempFormat.fontDescription = fontDescription;*/
				
				
				format = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				format.fontSize = 16;
				format.fontDescription = fontDescription;
				format.color = 0xffffff;
				
				tempFormat = new ElementFormat();
				fontDescription = new FontDescription("Tahoma");
				tempFormat.fontSize = 16;
				tempFormat.fontDescription = fontDescription;
				tempFormat.color = 0x0099FF;
				
				/*if (isMe)
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 16;
					format.fontDescription = fontDescription;
					format.color = 0x0099FF;
					tempFormat.color = 0x0099FF;
					tempFormat = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					tempFormat.fontSize = 16;
					tempFormat.fontDescription = fontDescription;
					tempFormat.color = 0xFFFF00;
				}
				else
				{
					format = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					format.fontSize = 16;
					format.fontDescription = fontDescription;
					format.color = 0xffffff;
					tempFormat.color = 0xffffff;
					tempFormat = new ElementFormat();
					fontDescription = new FontDescription("Tahoma");
					tempFormat.fontSize = 16;
					tempFormat.fontDescription = fontDescription;
					tempFormat.color = 0xFFFFFF;
				}*/
			}
			
			var nameTextField:SmileyRenderer = new SmileyRenderer(mapper, tempFormat, t.width);
			nameTextField.lineHeight = lineHeight;
			
			nameTextField.text = displayName + ":";
			
			/*nameTextField.x = 15;
			nameTextField.y = 10;*/
			var distanceString:String = "";
			
			while (nameTextField.width > t.width)
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
			content.addChild(smileyText);
			content.addChild(tempTextField);
			content.addChild(nameTextField);
			
			
			nameTextField.x = tempTextField.x + tempTextField.textWidth;
			smileyText.x = nameTextField.x + nameTextField.width;
			nameTextField.y = 3;
			smileyText.y = 3;
			
			lineNumber = smileyText.lineNumber;
		}
		
		public override function get height():Number 
		{
			return lineNumber * lineHeight;
		}
	}

}