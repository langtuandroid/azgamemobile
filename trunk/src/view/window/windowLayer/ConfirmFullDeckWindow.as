package view.window.windowLayer 
{
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import control.MainCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	import view.button.MyButton;
	import view.window.BaseWindow;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ConfirmFullDeckWindow extends BaseWindow 
	{
		public static const CONFIRM_FULL_DECK:String = "confirmFullDeck";
		private var closeButton:MyButton;
		private var confirmButton:MyButton;
		private var mainData:MainData = MainData.getInstance();
		private var fullDeckEffect:Sprite;
		private var isFilterDown:Boolean;
		private var filterNumber:Number = 0;
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:ElectroServerCommandTlmn = mainCommand.electroServerCommand;
		
		public function ConfirmFullDeckWindow() 
		{
			addContent("zConfirmFullDeckWindow");
			addButton();
			
			var tempClass:Class;
			tempClass = Class(getDefinitionByName("zFullDeckEffect"));
			fullDeckEffect = Sprite(new tempClass());
			fullDeckEffect.x = content["fullDeckEffectPosition"].x;
			fullDeckEffect.y = content["fullDeckEffectPosition"].y;
			addChild(fullDeckEffect);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!stage)
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (isFilterDown)
			{
				if(filterNumber >= 2)
					filterNumber -= 1.8;
				else
					isFilterDown = false;
			}
			else
			{
				if(filterNumber <= 12)
					filterNumber += 1.8;
				else
					isFilterDown = true;
			}
			
			var filterTemp:GlowFilter = new GlowFilter(0xFF0033, 1, filterNumber, filterNumber, 2, 1);
			fullDeckEffect.filters = [filterTemp];
		}
		
		private function addButton():void 
		{
			// tạo nút đóng cửa sổ
			createButton("closeButton", 90, 18, onCloseWindow);
			
			// tạo nút confirm
			createButton("confirmButton", 90, 18, onAcceptGetFullDeck);
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
		
		private function onAcceptGetFullDeck(e:MouseEvent):void 
		{
			dispatchEvent(new Event(CONFIRM_FULL_DECK));
			electroServerCommand.noticeFullDeck();
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
	}

}