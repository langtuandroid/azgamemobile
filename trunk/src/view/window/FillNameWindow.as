package view.window 
{
	import fl.controls.TextInput;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import model.MainData;
	/**
	 * ...
	 * @author Yun
	 */
	public class FillNameWindow extends BaseWindow 
	{
		private var mainData:MainData = MainData.getInstance();
		
		public function FillNameWindow() 
		{
			addContent("zFillNameWindow");
			
			zFillNameWindow(content).confirmButton.addEventListener(MouseEvent.CLICK, onConfirmButtonClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onSoftKeyboardActive(e:SoftKeyboardEvent):void 
		{
			if (stage.softKeyboardRect.height != 0)
			{
				var currentInputText:TextInput;
				switch (stage.focus) 
				{
					case zFillNameWindow(content).userName.textField:
						currentInputText = zFillNameWindow(content).userName;
					break;
					default:
				}
				var point:Point = new Point(0, currentInputText.y);
				point = localToGlobal(point);
				var scaleNumber:Number = stage.stageHeight / Capabilities.screenResolutionY;
				if (point.y + currentInputText.height > stage.stageHeight - stage.softKeyboardRect.top * scaleNumber)
				{
					var addDistance:Number = point.y + currentInputText.height - (stage.stageHeight - stage.softKeyboardRect.top * scaleNumber);
					y = stage.stageHeight / 2 - addDistance;
				}
			}
		}
		
		private function onSoftKeyboardDeactive(e:SoftKeyboardEvent):void 
		{
			y = stage.stageHeight / 2;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			if (mainData.isOnAndroid)
			{
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onAndroidKeyDown, false, 0, true);
			}
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			if (mainData.isOnAndroid)
			{
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onSoftKeyboardActive ); 
				removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onSoftKeyboardDeactive );
				NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onAndroidKeyDown, false);
			}
		}
		
		private function onAndroidKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 16777238:
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				close(BaseWindow.MIDDLE_EFFECT);
				break;
			}
		}
		
		private function onConfirmButtonClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ConfirmWindow.CONFIRM));
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function get userName():String 
		{
			return zFillNameWindow(content).userName.text;
		}
	}

}