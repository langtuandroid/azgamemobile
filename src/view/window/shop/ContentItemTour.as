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
	public class ContentItemTour extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String = "";
		public var _goldAvt:String = "";
		public var _chipAvt:String = "";
		public var _nameAvt:String = "";
		public function ContentItemTour() 
		{
			super();
			content = new ContentTourMc();
			addChild(content);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			
			
			content.buyTourBtnr.addEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			content.buyTourBtnr.removeEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
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
			
			_nameAvt = nameAvt;
			
			if (nameAvt == "Vé giải đấu bình dân") 
			{
				content.typeOfTour.gotoAndStop(1);
			}
			else if (nameAvt == "Vé giải đấu đại gia") 
			{
				content.typeOfTour.gotoAndStop(2);
			}
			else if (nameAvt == "Vé giải đấu thương gia") 
			{
				content.typeOfTour.gotoAndStop(3);
			}
			else if (nameAvt == "Vé giải đấu tiết kiệm") 
			{
				content.typeOfTour.gotoAndStop(4);
			}
			content.typeOfTour.visible = false;
			
			content.itemGoldTxt.text = format(Number(gold));
			content.itemChipTxt.text = format(Number(chip));
			
			
			
			var image:ImageItem = new ImageItem();
			content.containerImg.addChild(image);
			image.x = 45;
			image.y = 5;
			trace("load gold: ", linkAvt + "/WAZ/" + idWeb + ".gif")
			image.addImg(linkAvt + "/WAZ/" + idWeb + ".gif");
			
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