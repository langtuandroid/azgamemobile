package getFacebookInfo.ios
{
	import com.isvn.facebookExtension.FacebookExtension;
	import com.isvn.facebookExtension.events.FacebookExtensionEvent;
	import model.facebookData.FacebookData;
	import model.MainData;
	import view.window.windowLayer.WindowLayer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	
	public class SocialManager extends EventDispatcher 
	{
		private var facebookExtension:FacebookExtension;
		private var mainData:MainData = MainData.getInstance();
		public function SocialManager() 
		{
			facebookExtension = new FacebookExtension();
			facebookExtension.addEventListener(FacebookExtensionEvent.STATUS, onStatus);
		}
		
		private static var _instance:SocialManager;
		public static function getInstance():SocialManager
		{
			if (!_instance)
				_instance = new SocialManager();
			return _instance;
		}
		
		private var host:String = 'https://wwww.apps.ingen-studios.com/PokerKingSFSNew/';
		private var feed:String = 'images/feeds/';
		
		//***************************
		//Login
		//***************************
		public function init():void
		{			
			facebookExtension.init('702849383077521');
		}
		
		public function showInviteFriendRequest():void
		{
			facebookExtension.fbRequestDialog('702849383077521','','Hi! Please join me in Ingen Slot King!');
		}
		
		public function logout():void
		{
			facebookExtension.fbLogou();
		}
		
		protected function onStatus(e:FacebookExtensionEvent):void
		{
			switch (e.code)
			{
				case 'FB_API':
					if (e.level == 'FB_API_INIT_OK')
					{
						if (!facebookExtension.fbIsSessionValid())
						{							
							facebookExtension.fbLoginDialog('702849383077521','','user_birthday,email,publish_stream');						
						}
						else
						{
							facebookExtension.fbFQLRequest('SELECT uid, name, pic_square, email, gender, birthday FROM user WHERE uid=me()');							
						}
					}
				break;
				
				case 'FB_DID_LOGIN':
					facebookExtension.fbFQLRequest('SELECT uid, name, username, sex, pic_square, email, birthday FROM user WHERE uid=me()');
				break;
				
				case 'FB_DID_NOT_LOGIN':
					//update model
					WindowLayer.getInstance().openAlertWindow("login facebook fail");
				break;
				
				case 'FB_REQUEST_DID_RECEIVED_RESPONSE':					
					//chỉ sử dụng request để lấy thông tin cá nhân
					var jsonString:String = String(e.level);
					var result:Array = JSON.parse(jsonString) as Array;
					var resultObj:Object = result[0];
					
					var facebookData:FacebookData = new FacebookData();
					facebookData.uid = resultObj['uid'];
					facebookData.username = resultObj['username'] ? resultObj['username'] : ''; 
					facebookData.name = resultObj['name'];
					facebookData.email = resultObj['email'];
					facebookData.birthday = resultObj['birthday'];
					facebookData.gender = resultObj['sex'];
					facebookData.avatar = resultObj['pic_square'];
					facebookData.accessToken = resultObj['accessToken'];
					
					mainData.facebookData = facebookData;
				break;
			}
		}
		
		public function postWallFeed(type:String, title:String):void
		{
			var picLink:String = host + feed + type + '.png';			
			var params:Object = {
				app_id:'702849383077521',
				redirect_uri:null,
				display:'page',
				from:null,
				to:null,
				link:null,
				picture:picLink,
				source:null,
				name:title
			}
			facebookExtension.fbFeedDialog(params);		
		}
		
		public function postActivityFeed(type:String,title:String):void
		{
			//type,title,
		}
	}

}