package view.screen.play 
{
	import flash.events.MouseEvent;
	import view.screen.Base;
	
	/**
	 * ...
	 * @author Bim kute
	 */
	public class ContentInvite extends Base 
	{
		public var chose:Boolean = false;
		public  var userName:String;
		public function ContentInvite() 
		{
			addContent("contenInvite", "faceIcon");
			content._over.visible = false;
			content.mask = content._mask;
			content.choose.tick.visible = false;
			content.buttonMode = true;
			
			content.mouseChildren = false;
			content.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			content.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			content.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function removeAllEvent():void 
		{
			content.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			content.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			content.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function addUserName(str:String, money:String):void 
		{
			content.userTxt.text = str;
			userName = str;
			if (int(money) > 0) 
			{
				content.moneyTxt.text = format(int(money));
			}
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (chose) 
			{
				content.choose.tick.visible = false;
				chose = false;
			}
			else 
			{
				content.choose.tick.visible = true;
				chose = true;
			}
			
			
			
		}
		
		private function onOver(e:MouseEvent):void 
		{
			content._over.visible = true;
		}
		
		private function onOut(e:MouseEvent):void 
		{
			content._over.visible = false;
		}
		
	}

}