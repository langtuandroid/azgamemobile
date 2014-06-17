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
	public class ContentItemNormal extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String;
		public var _goldAvt:String;
		public var _chipAvt:String;
		public function ContentItemNormal() 
		{
			super();
			content = new ContentItemMc();
			addChild(content);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			
			
			content.buyAvatarBtn.addEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			content.buyAvatarBtn.removeEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
		}
		
		private function onBuyAvatar(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstTlmn.BUY_ITEM));
		}
		
		public function addInfo(idAvt:String, nameAvt:String, chip:String, gold:String, linkAvt:String, 
							expire:String, idWeb:String):void 
		{
			_idAvt = idAvt;
			_goldAvt = gold;
			_chipAvt = chip;
			
			var date:Date = new Date();
			
			var month:Number = date.month + 1;
			var year:Number = date.fullYear;
			month = month + 1;
			if (month > 12) 
			{
				month = month - 12;
				year = year + 1;
			}
			
			//content.itemLimitTxt.text = String(date.dateUTC) + "/" + String(month) + "/" + String(year);
			
			
			content.itemNameTxt.text = nameAvt;
			content.itemGoldTxt.text = format(int(gold));
			content.itemChipTxt.text = format(int(chip));
			
			
			
			var image:Avatar = new Avatar();
			content.containerImg.addChild(image);
			trace("load gold: ", linkAvt + "/WAZ/" + idWeb + ".gif")
			image.addImg(linkAvt + "/WAZ/" + idWeb + ".gif");
			
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