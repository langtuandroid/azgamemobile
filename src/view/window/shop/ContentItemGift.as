package view.window.shop 
{
	import control.ConstTlmn;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import view.userInfo.avatar.Avatar;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ContentItemGift extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String;
		public var _goldAvt:String;
		public var _chipAvt:String;
		public function ContentItemGift() 
		{
			super();
			content = new ContentGiftMc();
			addChild(content);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			
			
			content.changeGiftBtn.addEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			content.changeGiftBtn.removeEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
		}
		
		private function onBuyAvatar(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstTlmn.BUY_ITEM));
		}
		
		public function addInfo(idAvt:String, nameAvt:String, chip:String, gold:String, linkAvt:String, 
							expire:String, idWeb:String, soldOut:Boolean):void 
		{
			_idAvt = idAvt;
			_goldAvt = gold;
			_chipAvt = chip;
			
			content.overItem.visible = soldOut;
			
			content.itemNameTxt.text = nameAvt;
			if (int(gold) > 0) 
			{
				content.itemGoldTxt.text = format(int(gold)) + " Gold";
			}
			else 
			{
				content.itemGoldTxt.text = "-" + format(int(gold) * -1) + " Gold";
			}
			
			var image:ImageItem = new ImageItem();
			content.containertImgGift.addChild(image);
			image.x = -(65 - 139) / 2;
			image.y = -(65 - 108) / 2;
			trace("load qua: ", linkAvt + "/WAZ/" + idWeb + ".png")
			image.addImg(linkAvt + "/WAZ/" + idWeb + ".png");
			
		}
		
		
		protected function format(number:int):String 
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