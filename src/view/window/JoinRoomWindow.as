package view.window 
{
	import control.MainCommand;
	import fl.controls.TextInput;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import model.MainData;
	import view.button.MyButton;
	/**
	 * ...
	 * @author Yun
	 */
	public class JoinRoomWindow extends BaseWindow 
	{
		private var joinRoomButton:SimpleButton;
		private var closeButton:SimpleButton;
		
		private var roomIdInputText:TextField;
		private var passInputText:TextField;
		private var roomIdText:TextField;
		
		private var _roomId:int;
		private var _gameId:int;
		
		private var mainData:MainData = MainData.getInstance();
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		
		public function JoinRoomWindow() 
		{
			addContent("zSearchRoomWindow");
			addButton();
			createInputText();
		}
		
		private function createInputText():void 
		{
			roomIdInputText = content["roomIdInputText"];
			passInputText = content["passInputText"];
			
			passInputText.displayAsPassword = true;
			
			roomIdText = new TextField();
			roomIdText.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);
			roomIdText.autoSize = TextFieldAutoSize.LEFT;
			roomIdText.x = roomIdInputText.x;
			roomIdText.y = roomIdInputText.y;
			content.addChild(roomIdText);
			content.removeChild(roomIdInputText);
		}
		
		private function addButton():void 
		{
			// tạo nút vào phòng chơi
			//createButton("joinRoomButton", 90, 18, onJoinRoom);
			joinRoomButton = content["joinRoomButton"];
			joinRoomButton.addEventListener(MouseEvent.CLICK, onJoinRoom);
			
			// tạo nút đóng cửa sổ
			//createButton("closeButton", 90, 18, onCloseWindow);
			closeButton = content["closeButton"];
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
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
		
		private function onJoinRoom(e:MouseEvent):void 
		{
			electroServerCommand.joinGameRoom(_gameId, passInputText.text);
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function set roomId(value:int):void 
		{
			_roomId = value;
			roomIdText.text = String(value);
		}
		
		public function set gameId(value:int):void 
		{
			_gameId = value;
		}
	}

}