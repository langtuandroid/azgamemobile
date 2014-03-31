package view.contextMenu 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.hallopatidu.utils.StringFormatUtils;
	import control.MainCommand;
	import event.DataField;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import model.MainData;
	import view.window.AlertWindow;
	import view.window.ScoreWindow;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class MyContextMenu extends Sprite 
	{
		public static const KICK_OUT_CLICK:String = "kickOutClick";
		public static const ACCUSE_CLICK:String = "accuseClick";
		
		private var mainData:MainData = MainData.getInstance();
		private var content:Sprite;
		private var scoreButton:SimpleButton;
		private var makeFriendButton:SimpleButton;
		private var accuseButton:SimpleButton;
		private var kickOutButton:SimpleButton;
		private var transferButton:SimpleButton;
		private var transferDisable:Sprite;
		private var removeFriendButton:SimpleButton;
		private var kickOutDisable:Sprite;
		private var scoreDisable:Sprite;
		private var displayName:TextField;
		private var mainCommand:MainCommand = MainCommand.getInstance();
		private var electroServerCommand:* = mainCommand.electroServerCommand;
		private var windowLayer:WindowLayer = WindowLayer.getInstance();
		
		public function MyContextMenu() 
		{
			addContent("zContextMenu");
			scoreButton = content["scoreButton"];
			makeFriendButton = content["makeFriendButton"];
			accuseButton = content["accuseButton"];
			kickOutButton = content["kickOutButton"];
			transferButton = content["transferButton"];
			transferDisable = content["transferDisable"];
			removeFriendButton = content["removeFriendButton"];
			kickOutDisable = content["kickOutDisable"];
			scoreDisable = content["scoreDisable"];
			displayName = content["displayName"];
			displayName.selectable = false;
			transferButton.visible = scoreDisable.visible = false;
			
			kickOutButton.addEventListener(MouseEvent.CLICK, onKickOutClick);
			accuseButton.addEventListener(MouseEvent.CLICK, onAccuseClick);
			makeFriendButton.addEventListener(MouseEvent.CLICK, onMakeFriend);
			removeFriendButton.addEventListener(MouseEvent.CLICK, onRemoveFriend);
			scoreButton.addEventListener(MouseEvent.CLICK, onViewInfo);
		}
		
		private function onViewInfo(e:MouseEvent):void 
		{
			//var tempUrl:String = "http://ciao88.com/user/member/" + data[DataField.USER_NAME];
			//navigateToURL(new URLRequest(tempUrl));
			
			var scoreWindow:ScoreWindow = new ScoreWindow();
			scoreWindow.userId = data[DataField.USER_NAME];
			scoreWindow.logoString = data[DataField.LOGO];
			scoreWindow.avatarString = data[DataField.AVATAR];
			scoreWindow.addImg();
			windowLayer.openWindow(scoreWindow);
		}
		
		private function onMakeFriend(e:MouseEvent):void 
		{	
			electroServerCommand.addFriend(data[DataField.USER_NAME], DataField.IN_GAME_ROOM);
			
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.sendAddFriendSuccess);
			windowLayer.openWindow(alertWindow);
		}
		
		private function onRemoveFriend(e:MouseEvent):void 
		{
			electroServerCommand.removeFriend(data[DataField.USER_NAME], DataField.IN_GAME_ROOM);
			
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.setNotice(mainData.init.gameDescription.lobbyRoomScreen.removeFriendSuccess);
			windowLayer.openWindow(alertWindow);
		}
		
		private function onAccuseClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ACCUSE_CLICK));
		}
		
		private function onKickOutClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(KICK_OUT_CLICK));
		}
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		private var _enableKickOut:Boolean;
		
		public function set enableKickOut(value:Boolean):void 
		{
			_enableKickOut = value;
			if (value)
			{
				kickOutButton.visible = true;
				kickOutDisable.visible = false;
			}
			else
			{
				kickOutButton.visible = false;
				kickOutDisable.visible = true;
			}
		}
		
		private var _data:Object;
		
		public function set data(value:Object):void 
		{
			_data = value;
			
			var nameString:String;
			nameString = StringFormatUtils.shortenedString(_data[DataField.DISPLAY_NAME], 16);
				
			displayName.text = nameString;
				
			if (electroServerCommand.coreAPI.myData.friendList[_data[DataField.USER_NAME]])
			{
				makeFriendButton.visible = false;
				removeFriendButton.visible = true;
			}
			else
			{
				makeFriendButton.visible = true;
				removeFriendButton.visible = false;
			}
		}
		
		public function get data():Object 
		{
			return _data;
		}
	}

}