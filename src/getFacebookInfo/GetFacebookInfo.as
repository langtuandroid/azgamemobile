package getFacebookInfo 
{
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import model.facebookData.FacebookData;
	import model.MainData;
	/**
	 * ...
	 * @author 
	 */
	public class GetFacebookInfo 
	{
		private var mainData:MainData = MainData.getInstance();
		
		public function GetFacebookInfo() 
		{
			
		}
		
		private static var _instance:GetFacebookInfo;
		public static function getInstance():GetFacebookInfo
		{
			if (!_instance)
				_instance = new GetFacebookInfo();
			return _instance;
		}
		
		public function init():void {		
			// initialize the extension.
			if (!mainData.isLoginFacebook)
			{
				mainData.isLoginFacebook = true;
				GoViral.create();
			
				GoViral.goViral.initFacebook("265233976863346", "");
				
				// facebook events
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED,onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
			}
			
			//GoViral.goViral.logoutFacebook();
			login();
		}
		private function login():void{
			if (GoViral.goViral.isFacebookAuthenticated())
			{
				getMeFacebook();
			}
			else
			{
				GoViral.goViral.authenticateWithFacebook("user_likes,user_photos");
			}
		}
		/** Get your own facebook profile */
		public function getMeFacebook():void
		{
			GoViral.goViral.requestMyFacebookProfile();
		}
		
		/** Handle Facebook Event */
		private function onFacebookEvent(e:GVFacebookEvent):void
		{
			switch(e.type)
			{
				case GVFacebookEvent.FB_DIALOG_CANCELED:
					
					break;
				case GVFacebookEvent.FB_DIALOG_FAILED:
					
					break;
				case GVFacebookEvent.FB_DIALOG_FINISHED:
					
					break;
				case GVFacebookEvent.FB_LOGGED_IN:
					login();
					break;
				case GVFacebookEvent.FB_LOGGED_OUT:
					
					break;
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					
					break;
				case GVFacebookEvent.FB_LOGIN_FAILED:
					
					break;
				case GVFacebookEvent.FB_REQUEST_FAILED:
					
					break;
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					// handle a friend list- there will be only 1 item in it if 
					// this was a 'my profile' request.				
					if (e.friends!=null)
					{					
						// 'me' was a request for own profile.
						if (e.graphPath=="me")
						{
							var myProfile:GVFacebookFriend = e.friends[0];
							
							var facebookData:FacebookData = new FacebookData();
							facebookData.uid = myProfile.id;
							facebookData.accessToken = GoViral.goViral.getFbAccessToken();
							
							mainData.facebookData = facebookData;
							
							return;
						}
					}
					break;
			}
		}
	}
	
}