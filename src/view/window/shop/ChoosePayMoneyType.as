package view.window.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.MainData;
	import view.window.BaseWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ChoosePayMoneyType extends BaseWindow 
	{
		/**
		 * 2:gold, 1:chip
		 */
		public var typeOfPay:int = 1;
		public var nameReceive:String = "";
		
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
			contentMc.chooseTypeMoney.choosePay1.removeEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
			contentMc.chooseTypeMoney.choosePay2.removeEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
			
			contentMc.cancelBtn.removeEventListener(MouseEvent.CLICK, onClickCancelPay);
			contentMc.agreeBtn.removeEventListener(MouseEvent.CLICK, onClickBuyGold);
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
					contentMc.noticeTxt.text = "Thông tin giao dịch";
					contentMc.chooseTypeMoney.visible = true;
					contentMc.chooseTypeMoney.choosePay1.visible = true;
					contentMc.chooseTypeMoney.goldTxt.visible = true;
					contentMc.noticeTxt.y = -156;
					contentMc.chooseTypeMoney.choosePay1.addEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
				break;
				case 1:
					contentMc.noticeTxt.text = "Thông tin giao dịch";
					contentMc.chooseTypeMoney.visible = true;
					contentMc.chooseTypeMoney.choosePay1.visible = false;
					contentMc.chooseTypeMoney.goldTxt.visible = false;
					
					contentMc.noticeTxt.y = -156;
					
				break;
				default:
			}
			
			contentMc.chipTxt.text = format(MainData.getInstance().chooseChannelData.myInfo.cash);
			contentMc.chipTxt.width = contentMc.chipTxt.textWidth + 5;
			contentMc.chipSTxt.x = contentMc.chipTxt.x + contentMc.chipTxt.width;
			
			contentMc.goldTxt.text = format(MainData.getInstance().chooseChannelData.myInfo.money);
			contentMc.goldTxt.width = contentMc.goldTxt.textWidth + 5;
			contentMc.goldSTxt.x = contentMc.goldTxt.x + contentMc.goldTxt.width;
			contentMc.nameTxt.text = MainData.getInstance().chooseChannelData.myInfo.name;
			
			
			
			contentMc.chooseTypeMoney.choosePay1.gotoAndStop(1);
			contentMc.chooseTypeMoney.choosePay2.gotoAndStop(2);
			
			contentMc.chooseTypeMoney.choosePay2.addEventListener(MouseEvent.CLICK, onClickChooseTypeOfPay);
			
			contentMc.cancelBtn.addEventListener(MouseEvent.CLICK, onClickCancelPay);
			contentMc.agreeBtn.addEventListener(MouseEvent.CLICK, onClickBuyGold);
		}
		
		private function onClickBuyGold(e:MouseEvent):void 
		{
			nameReceive = contentMc.nameTxt.text;
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
				typeOfPay = 2;
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
		
		protected function format(number:Number):String 
		{
			var numString:String = number.toString()
			var result:String = ''

			while (numString.length > 3)
			{
					var chunk:String = numString.substr(-3)
					numString = numString.substr(0, numString.length - 3)
					result = ',' + chunk + result
			}

			if (numString.length > 0)
			{
					result = numString + result
			}

			return result
		}
	}

}