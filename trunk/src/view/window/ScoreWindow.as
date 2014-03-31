package view.window 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import model.MainData;
	import request.MainRequest;
	import view.button.MyButton;
	import view.userInfo.avatar.Avatar;
	/**
	 * ...
	 * @author Yun
	 */
	public class ScoreWindow extends BaseWindow 
	{
		private var displayName:TextField;
		private var level:TextField;
		private var money:TextField;
		private var vipPoint:TextField;
		private var maxMoney:TextField;
		private var weekSalary:TextField;
		private var victim:TextField;
		private var personIcon:Sprite;
		private var moneyIcon:Loader;
		private var vipIcon:Sprite;
		private var _userId:String;
		private var _avatarString:String;
		private var closeButton2:SimpleButton;
		private var mainData:MainData = MainData.getInstance();
		private var avatar:Avatar;
		private var gameIconLoaders:Array;
		
		public function ScoreWindow() 
		{
			addContent("zScoreWindow");
			displayName = content["displayName"];
			displayName.visible = false;
			level = content["level"];
			money = content["money"];
			money.visible = false;
			vipPoint = content["vipPoint"];
			vipPoint.visible = false;
			maxMoney = content["maxMoney"];
			weekSalary = content["weekSalary"];
			victim = content["victim"];
			personIcon = content["personIcon"];
			personIcon.visible = false;
			vipIcon = content["vipIcon"];
			vipIcon.visible = false;
			closeButton2 = content["closeButton2"];
			closeButton2.addEventListener(MouseEvent.CLICK, onCloseWindow);
			content["avatarPosition"].visible = false;
			content["game1Position"].visible = false;
			
			moneyIcon = new Loader();
			var urlRequest:URLRequest = new URLRequest(mainData.init.requestLink.moneyIcon.@url);
			moneyIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onMoneyIconComplete);
			//moneyIcon.load(urlRequest);
			content.addChild(moneyIcon);
		}
		
		private function onMoneyIconComplete(e:Event):void 
		{
			
		}
		
		private function getPersonalInfo(value:Object):void 
		{
			displayName.autoSize = TextFieldAutoSize.LEFT;
			level.autoSize = TextFieldAutoSize.LEFT;
			money.autoSize = TextFieldAutoSize.LEFT;
			vipPoint.autoSize = TextFieldAutoSize.LEFT;
			displayName.text = value["name"];
			personIcon.x = displayName.x + displayName.width + 2;
			level.text = value["level"];
			money.x = level.x + level.width + 16;
			money.text = value["ciao"];
			moneyIcon.x = money.x + money.width + 3;
			moneyIcon.y = money.y + 3;
			vipPoint.x = money.x + money.width + 26;
			vipPoint.text = value["point"];
			vipIcon.x = vipPoint.x + vipPoint.width + 3;
			victim.text = value["knockout"];
			maxMoney.text = value["largest_ciao"];
			weekSalary.text = value["week_ciao"];
			
			if (value["sex"] == "male")
				personIcon.getChildAt(1).visible = false;
			else
				personIcon.getChildAt(0).visible = false;
			
			if (value["latest_game"])
			{
				gameIconLoaders = new Array();
				for (var gameId:String in value["latest_game"])
				{
					var tempLoader:Loader = new Loader();
					gameIconLoaders.push(tempLoader);
					var urlRequest:URLRequest = new URLRequest(value["latest_game"][gameId]["img"]);
					tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadGameIconComplete);
					//tempLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					//tempLoader.load(urlRequest);
				}
				gameIconLoaders[0].x = content["game1Position"].x;
				gameIconLoaders[0].y = content["game1Position"].y;
				content.addChild(gameIconLoaders[0]);
				for (var i:int = 1; i < gameIconLoaders.length; i++) 
				{
					gameIconLoaders[i].x = content["game1Position"].x + i * 89;
					gameIconLoaders[i].y = content["game1Position"].y;
					content.addChild(gameIconLoaders[i]);
				}
			}
		}
		
		private function onLoadGameIconComplete(e:Event):void 
		{
			Bitmap(LoaderInfo(e.currentTarget).content).smoothing = true;
		}
		
		private function addButton():void 
		{
			// tạo nút đóng cửa sổ
			createButton("closeButton", 70, 18, onCloseWindow);
		}
		
		private function createButton(buttonName:String,_width:Number,_height:Number,_function:Function):void
		{
			this[buttonName] = new MyButton();
			this[buttonName].width = _width;
			this[buttonName].height = _height;
			this[buttonName].setLabel(mainData.init.gameDescription.playingScreen[buttonName]);
			this[buttonName].x = content[buttonName + "Position"].x;
			this[buttonName].y = content[buttonName + "Position"].y;
			this[buttonName].addEventListener(MouseEvent.CLICK, _function);
			content[buttonName + "Position"].visible = false;
			addChild(this[buttonName]);
		}
		
		private function onCloseWindow(e:MouseEvent):void 
		{
			close(BaseWindow.MIDDLE_EFFECT);
		}
		
		public function get userId():String 
		{
			return _userId;
		}
		
		public function set userId(value:String):void 
		{
			_userId = value;
			
			var tempRequest:MainRequest = new MainRequest();
			var url:String = "http://" + mainData.gameIp + mainData.init.requestLink.getPersonalInfoLink.@url + userId;
			tempRequest.sendRequest_Post(url, null, getPersonalInfo, true);
		}
		
		public function get avatarString():String 
		{
			return _avatarString;
		}
		
		public function set avatarString(value:String):void 
		{
			_avatarString = value;
		}
		
		public var logoString:String;
		
		public function addImg(isConvert:Boolean = true):void
		{
			avatar = new Avatar();
			avatar.setForm(Avatar.MY_AVATAR);
			//avatar.width = avatar.height = 119;
			avatar.scaleX = avatar.scaleY = 2.42;
			//avatar.addImg(avatarString, logoString, true, userId);
			avatar.addImg(avatarString, null, true, userId);
			//avatar.logoLoader.scaleX = avatar.logoLoader.scaleY = 0.9;
			avatar.x = content["avatarPosition"].x;
			avatar.y = content["avatarPosition"].y;
			content.addChild(avatar);
		}
	}

}