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
	public class ContentAvatar extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String;
		public var _goldAvt:String;
		public var _chipAvt:String;
		public function ContentAvatar() 
		{
			super();
			content = new ContentAvatarMc();
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
			dispatchEvent(new Event(ConstTlmn.BUY_AVATAR));
		}
		
		public function addInfo(idAvt:String, nameAvt:String, chip:String, gold:String, linkAvt:String, 
								expire:String, idWeb:String):void 
		{
			_idAvt = idAvt;
			_goldAvt = gold;
			_chipAvt = chip;
			
			var date:Date = new Date();
			
			content.itemNameTxt.text = nameAvt;
			content.itemGoldTxt.text = format(Number(gold));
			content.itemChipTxt.text = format(Number(chip));
			
			var month:Number = date.month + 1;
			var year:Number = date.fullYear;
			month = month + 1;
			if (month > 12) 
			{
				month = month - 12;
				year = year + 1;
			}
			
			//content.itemLimitTxt.text = String(date.dateUTC) + "/" + String(month) + "/" + String(year);
			//content.itemLimitTxt.text = "30 ngày";
			content.itemLimitTxt.text = expire + " ngày";
			
			var image:ImageItem = new ImageItem("avatar");
			content.containerImg.addChild(image);
			
			image.x = 0;
			image.y = 0;
			
			trace("addavâtrr: ", linkAvt + "/WAZ/" + idWeb + ".png")
			image.addImg(linkAvt + "/WAZ/" + idWeb + ".png");
			
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