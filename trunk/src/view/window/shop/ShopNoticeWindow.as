package view.window.shop 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import view.window.BaseWindow;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ShopNoticeWindow extends BaseWindow 
	{
		public static const ADD_MONEY:String = "addMoney";
		public static const CHANGE_MONEY:String = "changeMoney";
		public function ShopNoticeWindow() 
		{
			super();
			
			
		}
		
		public function addWindow(type:String, notice:String):void 
		{
			addContentMc(type);
			
			contentMc.closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			contentMc.notice.text = notice;
			
			if (type == "AddMoneySuccessWindow") 
			{
				contentMc.changeMoneyBtn.addEventListener(MouseEvent.CLICK, onNoticeAddMoneySucceess);
				
			}
			else if (type == "BuyItemUnSuccessWindown") 
			{
				contentMc.addMoneyBtn.addEventListener(MouseEvent.CLICK, onClickAddMoney);
				
			}
		}
		
		private function onClickAddMoney(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ADD_MONEY));
			onCloseWindow(null);
		}
		
		private function onNoticeAddMoneySucceess(e:MouseEvent):void 
		{
			dispatchEvent(new Event(CHANGE_MONEY));
			onCloseWindow(null);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			//dispatchEvent(new Event(REJECT));
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
	}

}