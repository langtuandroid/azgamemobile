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
	import flash.text.TextFormatAlign;
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
		private var lineHeight:Number = 20;
		
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
			else if (gameName == "AZGB_XITO") 
			{
				content.gameNameMc.gotoAndStop(6);
				gamename = '[Xì tố]';
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
			
			content.gameNameMc.visible = true;
			/*var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = new TextFormat("Tahoma", 16, 0xFFFFFF);
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.htmlText = gamename + "<font color='#0099FF'> " + displayName + "</font>" + ":";
			tempTextField.width = tempTextField.textWidth;*/
			
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
			 
			/*if (displayName.length > 20) 
			{
				displayName = displayName.slice(0, 20) + '...';
			}*/
			var nameTextField:SmileyRenderer = new SmileyRenderer(mapper, tempFormat, chatContainerWidth - 9);
			nameTextField.lineHeight = lineHeight;
			
			nameTextField.text = displayName + ":";
			
			/*nameTextField.x = 15;
			nameTextField.y = 10;*/
			var tfn:TextFormat = new TextFormat();
			tfn.size = 16;
			tfn.align = TextFormatAlign.LEFT;
			var distanceString:SmileyRenderer = new SmileyRenderer(mapper, tempFormat, t.width);
			distanceString.text = '';
			var i:int;
			var count:int = 0;
			/*for (i = 0; i < tempTextField.text.length; i++) 
			{
				
				count++
				if (count < 2) 
				{
					distanceString.text = distanceString.text + " ";
				}
				else if (count == 2) 
				{
					distanceString.text = distanceString.text + "  ";
					count = 0;
				}
			}*/
			
			/*count = 0;
			for (i = 0; i < nameTextField.text.length; i++) 
			{
				
				count++
				if (count == 1) 
				{
					distanceString.appendText(" ");
				}
				else if (count == 2) 
				{
					distanceString.appendText("  ");
					count = 0;
				}
			}*/
			
			var smileyText:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 9);
			
			var tempSmiley:SmileyRenderer = new SmileyRenderer(mapper, format, chatContainerWidth - 2);
			tempSmiley.text = "aaaaaaa";
			
			smileyText.lineHeight = lineHeight;
			smileyText.standardHeight = tempSmiley.firstLine.height;
			smileyText.reg = regExp;
			
			smileyText.text = distanceString.text + sentence;
			if (nameTextField.height < smileyText.firstLine.height)
				smileyText.y = - (smileyText.firstLine.height - nameTextField.height) - 1;
			content.addChild(smileyText);
			//content.addChild(tempTextField);
			content.addChild(nameTextField);
			
			
			//nameTextField.x = tempTextField.x + tempTextField.textWidth;
			//smileyText.x = nameTextField.x + nameTextField.width;
			nameTextField.y = -5;
			nameTextField.x = content.gameNameMc.x + content.gameNameMc.width + 5;
			smileyText.x = content.gameNameMc.x + content.gameNameMc.width + 5;
			smileyText.y = 15;
			
			lineNumber = smileyText.lineNumber + 1;
			
			/*var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.align = TextFormatAlign.LEFT;
			var txt:TextField = new TextField();
			txt.defaultTextFormat = tf;
			txt.multiline = true;
			txt.wordWrap = true	;
			txt.width = 280;
			txt.mouseEnabled = false;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.htmlText = gamename + "<font color='#0000FF'> " + displayName + "</font>" + sentence;
			txt.height = txt.textHeight + 2;
			
			content.addChild(txt);*/
		}
		
		public override function get height():Number 
		{
			return lineNumber * lineHeight;
		}
	}

}