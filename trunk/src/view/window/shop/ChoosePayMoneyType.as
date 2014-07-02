package view.window.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import view.window.BaseWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ChoosePayMoneyType extends BaseWindow 
	{
		public var typeOfPay:int;
		
		public function ChoosePayMoneyType()
		{
			super();
			addContentMc("ChoosePayMoneyTypeMc");
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		/**
		 * 
		 * @param	type 0:avatar, 1:gold, 2: item
		 */
		public function showChoose(type:int):void 
		{
			switch (type) 
			{
				case 0:
					contentMc.noticeTxt.text = "Chọn hình thức thanh toán";
					contentMc.chooseTypeMoney.visible = true;
					contentMc.noticeTxt.y = -106;
					
				break;
				case 1:
					contentMc.noticeTxt.text = "Bạn đồng ý thực hiện giao dịch?";
					contentMc.chooseTypeMoney.visible = false;
					contentMc.noticeTxt.y = -36;
					
				break;
				default:
			}
			
			contentMc.chooseTypeMoney.choosePay1.gotoAndStop(1);
			contentMc.chooseTypeMoney.choosePay2.gotoAndStop(1);
			contentMc.chooseTypeMoney.choosePay1.addEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
			contentMc.chooseTypeMoney.choosePay2.addEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
			
			contentMc.cancelBtn.addEventListener(MouseEvent.CLICK, onClickCancelPay);
			contentMc.agreeBtn.addEventListener(MouseEvent.CLICK, onClickBuyGold);
		}
		
		private function onClickBuyGold(e:MouseEvent):void 
		{
			close();
			dispatchEvent(new Event("agree"));
		}
		
		private function onClickCancelPay(e:MouseEvent):void 
		{
			close();
		}
		
		private function onClickChooseTypeOfPay(e:MouseEvent):void 
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if (mc.name == "choosePay1") 
			{
				typeOfPay = 0;
				contentMc.chooseTypeMoney.choosePay1.gotoAndStop(2);
				contentMc.chooseTypeMoney.choosePay2.gotoAndStop(1);
			}
			else 
			{
				typeOfPay = 1;
				contentMc.chooseTypeMoney.choosePay1.gotoAndStop(1);
				contentMc.chooseTypeMoney.choosePay2.gotoAndStop(2);
			}
		}
		
	}

}