package view.topMenu 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import logic.PlayingLogic;
	import model.chooseChannelData.ChooseChannelData;
	import model.MainData;
	import view.userInfo.avatar.Avatar;
	import view.window.AddMoneyWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class TopMenu extends Sprite 
	{
		private var content:zTopMenu;
		private var mainData:MainData = MainData.getInstance();
		private var avatar:Avatar;
		private var logOutButton:SimpleButton;
		private var soundSettingButton:MovieClip;
		private var vibrateSettingButton:MovieClip;
		private var sharedObject:SharedObject;
		
		public function TopMenu() 
		{
			content = new zTopMenu();
			addChild(content);
			
			content.addMoneyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			content.settingButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			content.settingBoard.visible = false;
			
			content.money1.x = 183;
			content.money1.y = 15;
			content.money1.mouseEnabled = false;
			
			logOutButton = content.settingBoard["logOutButton"];
			soundSettingButton = content.settingBoard["soundSettingButton"];
			vibrateSettingButton = content.settingBoard["vibrateSettingButton"];
			
			sharedObject = SharedObject.getLocal("setting");
			if (sharedObject.data.hasOwnProperty("soundSetting"))
				soundSettingButton.gotoAndStop(sharedObject.data.soundSetting);	
			else
				sharedObject.setProperty("soundSetting", "on");
			
			if (sharedObject.data.hasOwnProperty("vibrateSetting"))
				vibrateSettingButton.gotoAndStop(sharedObject.data.vibrateSetting);	
			else
				sharedObject.setProperty("vibrateSetting", "on");
			
			logOutButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			soundSettingButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			vibrateSettingButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			if (mainData.chooseChannelData.myInfo)
				updateContent();
				
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.currentTarget) 
			{
				case content.addMoneyButton:
					var addMoneyWindow:AddMoneyWindow = new AddMoneyWindow();
					WindowLayer.getInstance().openWindow(addMoneyWindow);
				break;
				case content.settingButton:
					content.settingBoard.visible = !content.settingBoard.visible;
				break;
				case logOutButton:
					mainData.isLogOut = true;
					content.settingBoard.visible = false;
				break;
				case soundSettingButton:
					if (sharedObject.data.soundSetting == "on")
						sharedObject.data.soundSetting = "off";
					else
						sharedObject.data.soundSetting = "on";
					soundSettingButton.gotoAndStop(sharedObject.data.soundSetting);
				break;
				case vibrateSettingButton:
					if (sharedObject.data.vibrateSetting == "on")
						sharedObject.data.vibrateSetting = "off";
					else
						sharedObject.data.vibrateSetting = "on";
					vibrateSettingButton.gotoAndStop(sharedObject.data.vibrateSetting);
				break;
				default:
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			mainData.chooseChannelData.addEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			mainData.chooseChannelData.removeEventListener(ChooseChannelData.UPDATE_MY_INFO, onUpdateMyInfo);
		}
		
		private function onUpdateMyInfo(e:Event):void 
		{
			updateContent();
		}
		
		private function updateContent():void 
		{
			content.displayName.text = mainData.chooseChannelData.myInfo.name;
			content.money1.text = PlayingLogic.format(mainData.chooseChannelData.myInfo.money, 1);
			content.money2.text = mainData.chooseChannelData.myInfo.vipPoint + " Vip";
			content.level.text = mainData.chooseChannelData.myInfo.level;
			
			if (!avatar)
			{
				avatar = new Avatar();
				avatar.setForm(Avatar.MY_AVATAR);
				addChild(avatar);
			}
				
			avatar.addImg(mainData.chooseChannelData.myInfo.avatar, null, true, mainData.chooseChannelData.myInfo.uId);
			
			if (mainData.isOnAndroid)
			{
				if (mainData.loginData.user_info.payment_android == 0)
				{
					content.addMoneyButton.visible = false;
					content.money1.x = 48;
					content.money1.y = 30;
				}
			}
			else if (mainData.isOnIos)
			{
				if (mainData.loginData.user_info.payment == 0)
				{
					content.addMoneyButton.visible = false;
					content.money1.x = 48;
					content.money1.y = 30;
				}
			}
		}
	}

}