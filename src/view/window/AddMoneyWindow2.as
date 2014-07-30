package view.window 
{
	import com.adobe.serialization.json.JSON;
	import control.MainCommand;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import logic.PlayingLogic;
	import model.MainData;
	/**
	 * ...
	 * @author 
	 */
	public class AddMoneyWindow2 extends BaseWindow 
	{
		private var des1Txt:TextField;
		private var des2Txt:TextField;
		private var des3Txt:TextField;
		private var closeButton:SimpleButton;
		private var shopButton:SimpleButton;
		
		private var _freeGold:Number;
		private var _freeNumber:Number;
		
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var mainData:MainData = MainData.getInstance();;
		
		public function AddMoneyWindow2() 
		{
			super();
			
			addContent("zAddMoneyWindow2");
			
			des1Txt = content["des1Txt"];
			des2Txt = content["des2Txt"];
			des3Txt = content["des3Txt"];
			closeButton = content["closeButton"];
			shopButton = content["shopButton"];
			
			des1Txt.text = '';
			des2Txt.text = '';
			des3Txt.text = '';
			
			closeButton.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			shopButton.addEventListener(MouseEvent.CLICK, onShopButtonClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			electroServerCommand.updateMoney();
		}
		
		private function onShopButtonClick(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
			mainData.isMoveToShop = true;
		}
		
		private function onCloseButtonClick(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function get freeNumber():Number 
		{
			return _freeNumber;
		}
		
		public function set freeNumber(value:Number):void 
		{
			_freeNumber = value;
			
			if (value < 10)
				var freeNumberString:String = '0' + String(value);
			if (value >= 0)
				des2Txt.htmlText = "Số lần nạp miễn phí trong ngày còn " + "<font color='#FFCC33'>" + freeNumberString + "</font>" + " lần";
			else
				des2Txt.text = "Bạn đã hết số lần nạp miễn phí trong ngày.";
		}
		
		public function get freeGold():Number 
		{
			return _freeGold;
		}
		
		public function set freeGold(value:Number):void 
		{
			_freeGold = value;
			des1Txt.htmlText = "Bạn đã được tặng " + "<font color='#FFCC33'>" + PlayingLogic.format(value,1) + "</font>" + " gold miễn phí";
		}
		
		public function setNotice(s:String):void
		{
			des3Txt.text = s;
		}
	}

}