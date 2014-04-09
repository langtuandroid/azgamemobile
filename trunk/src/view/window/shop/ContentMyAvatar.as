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
	public class ContentMyAvatar extends MovieClip 
	{
		private var content:MovieClip;
		public var _idAvt:String;
		public var _goldAvt:String;
		public var _chipAvt:String;
		public function ContenMytAvatar() 
		{
			super();
			content = new ContentMyAvatarMc();
			addChild(content);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			
			
			content.buyAvatarBtn.addEventListener(MouseEvent.MOUSE_UP, onUseAvatar);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			content.buyAvatarBtn.removeEventListener(MouseEvent.MOUSE_UP, onBuyAvatar);
			
		}
		
		private function onUseAvatar(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConstTlmn.USE_AVATAR));
		}
		
		public function addInfo(idAvt:String, nameAvt:String, timeUse:String, linkAvt:String, expire:String):void 
		{
			_idAvt = idAvt;
			_goldAvt = gold;
			_chipAvt = chip;
			
			content.itemNameTxt.text = nameAvt;
			
			content.itemTimeUseTxt.text = timeUse;
			content.itemLimitTxt.text = expire;
			
			var image:Avatar = new Avatar();
			content.containerImg.addChild(image);
			image.addImg(linkAvt);
			
		}
	}

}