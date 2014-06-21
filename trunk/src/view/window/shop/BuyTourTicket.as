package view.window.shop 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import view.window.BaseWindow;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BuyTourTicket extends BaseWindow 
	{
		
		public function BuyTourTicket() 
		{
			super();
			addContentMc("BuyTourSuccessMc");
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			contentMc.closeBtn.removeEventListener(MouseEvent.MOUSE_UP, onCloseWindow);
			contentMc.cancelBtn.removeEventListener(MouseEvent.MOUSE_UP, onCloseWindow);
			contentMc.agreeBtn.removeEventListener(MouseEvent.MOUSE_UP, onBuyItem);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(MouseEvent.CLICK, onStageClick);
			
			contentMc.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseWindow);
			contentMc.cancelBtn.addEventListener(MouseEvent.MOUSE_UP, onCloseWindow);
			contentMc.agreeBtn.addEventListener(MouseEvent.MOUSE_UP, onBuyItem);
		}
		
		private function onBuyItem(e:MouseEvent):void 
		{
			onCloseWindow(null);
			dispatchEvent(new Event("agree"));
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function questionBuy(nameTicket:String):void 
		{
			contentMc.typeOfTicket.text = nameTicket;
			contentMc.noticeTxt.text = "Bạn đồng ý thực hiện giao dịch?";
			
			contentMc.closeBtn.visible = false;
			contentMc.cancelBtn.visible = true;
			contentMc.agreeBtn.visible = true;
		}
		
		public function noticeChoseItem(nameTicket:String, notice:String):void 
		{
			contentMc.typeOfTicket.text = nameTicket;
			contentMc.noticeTxt.text = notice;
			
			contentMc.closeBtn.visible = true;
			contentMc.cancelBtn.visible = false;
			contentMc.agreeBtn.visible = false;
		}
	}

}