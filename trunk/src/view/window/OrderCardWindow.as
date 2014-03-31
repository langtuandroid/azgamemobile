package view.window 
{
	import control.MainCommand;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logic.MauBinhLogic;
	import model.MainData;
	import view.button.MyButton;
	/**
	 * ...
	 * @author Yun
	 */
	public class OrderCardWindow extends BaseWindow 
	{
		public static const CONFIRM_ORDER_CARD:String = "confirmOrderCard";
		private var closeButton:MyButton;
		private var confirmButton:MyButton;
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var convertTextArray:Array;
		private var cardStringArray:Array;
		
		public function OrderCardWindow() 
		{
			addContent("zOrderCardWindow");
			
			convertTextArray = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				convertTextArray.push(content["convertText" + String(i + 1)]);
			}
			
			cardStringArray = new Array();
			for (i = 0; i < 4; i++) 
			{
				cardStringArray.push(content["cardString" + String(i + 1)]);
				content["cardString" + String(i + 1)].addEventListener(Event.CHANGE, onCardStringChange);
			}
			
			// tạo nút đóng cửa sổ
			createButton("closeButton", 90, 18, onCloseWindow);
			// tạo nút confirm
			createButton("confirmButton", 90, 18, onConfirmOrderCard);
			
			for (i = 0; i < cardStringArray.length; i++) 
			{
				var idArray:Array = String(TextField(cardStringArray[i]).text).split(',');
				convertTextArray[i].text = '';
				for (var j:int = 0; j < idArray.length; j++) 
				{
					TextField(convertTextArray[i]).appendText(MauBinhLogic.getInstance().convertIdToString(idArray[j]) + ", ");
				}
			}
		}
		
		private function onCardStringChange(e:Event):void 
		{
			for (var i:int = 0; i < cardStringArray.length; i++) 
			{
				if (e.currentTarget == cardStringArray[i])
				{
					var idArray:Array = String(TextField(e.currentTarget).text).split(',');
					convertTextArray[i].text = '';
					for (var j:int = 0; j < idArray.length; j++) 
					{
						TextField(convertTextArray[i]).appendText(MauBinhLogic.getInstance().convertIdToString(idArray[j]) + ", ");
					}
					return;
				}
			}
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.lobbyRoomScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
		
		private function onConfirmOrderCard(e:MouseEvent):void 
		{
			dispatchEvent(new Event(CONFIRM_ORDER_CARD));
			var tempArray1:Array = String(content["cardString1"].text).split(',');
			var tempArray2:Array = String(content["cardString2"].text).split(',');
			var tempArray3:Array = String(content["cardString3"].text).split(',');
			var tempArray4:Array = String(content["cardString4"].text).split(',');
			for (var i:int = 0; i < tempArray1.length; i++) 
			{
				tempArray1[i] = int(tempArray1[i]) - 1;
				tempArray2[i] = int(tempArray2[i]) - 1;
				tempArray3[i] = int(tempArray3[i]) - 1;
				tempArray4[i] = int(tempArray4[i]) - 1;
			}
			electroServerCommand.orderCard(tempArray1, tempArray2, tempArray3, tempArray4);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}