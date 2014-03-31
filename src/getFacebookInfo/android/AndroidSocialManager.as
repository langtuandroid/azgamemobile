package getFacebookInfo.android
{
	import com.freshplanet.nativeExtensions.Facebook;
	import com.freshplanet.nativeExtensions.FacebookEvent;
	import model.facebookData.FacebookData;
	import model.MainData;
	import view.window.windowLayer.WindowLayer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AndroidSocialManager extends EventDispatcher
	{
		public var facebookExtension:Facebook;
		private var mainData:MainData = MainData.getInstance();
		public function AndroidSocialManager()
		{
			facebookExtension = Facebook.getInstance();			
			facebookExtension.addEventListener(FacebookEvent.GRAPH_API_SUCCESS_EVENT, onFBGraphApiSuccessEvent);
			facebookExtension.addEventListener(FacebookEvent.USER_LOGGED_IN_CANCEL_EVENT, onUserLoggedInCancelEvent);
			facebookExtension.addEventListener(FacebookEvent.USER_LOGGED_IN_ERROR_EVENT, onUserLoggedInErrorEvent);
			facebookExtension.addEventListener(FacebookEvent.USER_LOGGED_IN_FACEBOOK_ERROR_EVENT, onUserLoggedInFacebookErrorEvent);
			facebookExtension.addEventListener(FacebookEvent.USER_LOGGED_IN_SUCCESS_EVENT, onUserLoggedInSuccessEvent);
			facebookExtension.addEventListener(FacebookEvent.USER_LOGGED_OUT_SUCCESS_EVENT, onUserLoggedOutSuccessEvent);
		}
		
		private static var _instance:AndroidSocialManager;
		public static function getInstance():AndroidSocialManager
		{
			if (!_instance)
				_instance = new AndroidSocialManager();
			return _instance;
		}
		
		public function init():void {	
			facebookExtension.initFacebook('265233976863346');
			if (!facebookExtension.isLogIn()) {
				facebookExtension.login(['email','publish_stream']);
			} else {
				facebookExtension.getUserInfo(onGetFacebookData);
			}
		}
		
		public function logout():void {
			facebookExtension.logout();		
		}
		
		public function showInviteFriendPopup():void {
			facebookExtension.inviteFriends('Hi! Please join me in Ingen Slot King!');
		}
		
		public function postWallFeed(type:String, title:String):void {
			
		}
		
		protected function onFBGraphApiSuccessEvent(event:FacebookEvent):void
		{
			//check session
			if (!facebookExtension.isLogIn()) {
				facebookExtension.login(['user_birthday','email','publish_stream']);
			} else {
				facebookExtension.getUserInfo(onGetFacebookData);
			}
		}
		
		private function onGetFacebookData(data:Object):void
		{
			var facebookData:FacebookData = new FacebookData();
			facebookData.uid = data['id'];
			facebookData.username = data['username'] ? data['username'] : '';
			facebookData.name = data['name'];
			facebookData.email = data['email'];
			facebookData.gender = data['gender'];
			facebookData.birthday = data['birthday'];
			facebookData.avatar = 'http://graph.facebook.com/' +data['id']+ '/picture?type=square';
			facebookData.avatarNormal = 'http://graph.facebook.com/' +data['id']+ '/picture?type=normal';
			facebookData.avatarLarge = 'http://graph.facebook.com/' +data['id']+ '/picture?type=large';
			facebookData.accessToken = data["accessToken"];
			
			mainData.facebookData = facebookData;
			
		}
		
		protected function onUserLoggedInCancelEvent(event:FacebookEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("login facebook fail");
		}
		
		protected function onUserLoggedInErrorEvent(event:FacebookEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("login facebook fail");
		}
		
		protected function onUserLoggedInFacebookErrorEvent(event:FacebookEvent):void
		{
			WindowLayer.getInstance().openAlertWindow("login facebook fail");
		}
		
		protected function onUserLoggedInSuccessEvent(event:FacebookEvent):void
		{
			facebookExtension.getUserInfo(onGetFacebookData);
		}
		
		protected function onUserLoggedOutSuccessEvent(event:FacebookEvent):void
		{
			
		}
	}
}