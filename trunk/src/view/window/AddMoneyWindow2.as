package view.window 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import logic.PlayingLogic;
	/**
	 * ...
	 * @author 
	 */
	public class AddMoneyWindow2 extends BaseWindow 
	{
		private var des1Txt:TextField;
		private var des2Txt:TextField;
		private var closeButton:SimpleButton;
		private var shopButton:SimpleButton;
		
		private var _freeGold:Number;
		private var _freeNumber:Number;
		
		public function AddMoneyWindow2() 
		{
			super();
			
			addContent("zAddMoneyWindow2");
			
			des1Txt = content["des1Txt"];
			des2Txt = content["des2Txt"];
			closeButton = content["closeButton"];
			shopButton = content["shopButton"];
			
			des1Txt.text = '';
			des2Txt.text = '';
			
			closeButton.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			shopButton.addEventListener(MouseEvent.CLICK, onShopButtonClick);
		}
		
		private function onShopButtonClick(e:MouseEvent):void 
		{
			//navigateToURL(new URLRequest("http://azgamebai.com/binh/cua-hang.html"), "_self");
			if (ExternalInterface.available)
			{
				var object:Object = new Object();
				object.url_redirect = "http://azgamebai.com/binh/cua-hang.html";
				var s:String = com.adobe.serialization.json.JSON.encode(object);
				ExternalInterface.call("FlashCallWeb", s);
			}
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
			des2Txt.htmlText = "Số lần nạp miễn phí trong ngày còn " + "<font color='#FFCC33'>" + freeNumberString + "</font>" + " lần";
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
		
	}

}