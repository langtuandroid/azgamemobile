package view.window.shop 
{
	import control.ConstTlmn;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class ContentAvatar extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String;
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
		
		public function addInfo(idAvt:String, nameAvt:String, chip:String, gold:String, linkAvt:String, expire:String):void 
		{
			_idAvt = idAvt;
			
			
			content.itemNameTxt.text = nameAvt;
			content.itemGoldTxt.text = nameAvt;
			content.itemChipTxt.text = nameAvt;
			content.itemLimitTxt.text = nameAvt;
			
			var image:ImageItem = new ImageItem();
			content.containerImg.addChild(image);
			
			
		}
	}

}