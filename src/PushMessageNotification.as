package 
{
	
	import com.milkmangames.nativeextensions.*;
	import com.milkmangames.nativeextensions.events.*;
	/**
	 * ...
	 * @author bimkute
	 */
	public class PushMessageNotification 
	{
		/** Your Game Thrive App ID */
		public static const GAMETHRIVE_APP_ID:String="d291225e-fe09-11e4-ba36-ffc09b8dac75"; 	
		
		/** Your GCM Project Number */
		public static const GCM_PROJECT_NUMBER:String="86526971945";
		public function PushMessageNotification() 
		{
			
		}
		private static var _instance:PushMessageNotification;
		public static function getInstance():PushMessageNotification
		{
			if (!_instance)
				_instance = new PushMessageNotification();
			return _instance;
		}
		
		public function init():void 
		{
			if (!EasyPush.isSupported())
			{
				trace("EasyPush is not supported on this platform (not android or ios!)");
				return;
			}
			if (!EasyPush.areNotificationsAvailable())
			{
				trace("Notifications are disabled!");
				return;
			}
			EasyPush.initOneSignal(GAMETHRIVE_APP_ID, GCM_PROJECT_NUMBER, true);
			
			EasyPush.oneSignal.addEventListener(PNOSEvent.ALERT_DISMISSED, onAlertDismissed);
		EasyPush.oneSignal.addEventListener(PNOSEvent.FOREGROUND_NOTIFICATION, onNotification);
			EasyPush.oneSignal.addEventListener(PNOSEvent.RESUMED_FROM_NOTIFICATION, onNotification);
			EasyPush.oneSignal.addEventListener(PNOSEvent.TOKEN_REGISTERED, onTokenRegistered);
			EasyPush.oneSignal.addEventListener(PNOSEvent.TOKEN_REGISTRATION_FAILED, onRegFailed);		
		}
		
		/** Set GameThrive Tags for user */
		public function setGameThriveTags():void
		{
			trace("Setting custom tags  for Tag1 and Tag2..");
			var tags:Object={Tag1:"first tag", Tag2:"Second tag"};
			EasyPush.oneSignal.setTags(tags);
			trace("Set gamethrive tags.");
		}

		//
		// Events
		//	
		
		private function onTokenRegistered(e:PNEvent):void
		{
			trace("token registered:"+e.token);
		}
		
		private function onRegFailed(e:PNEvent):void
		{
			trace("reg failed: "+e.errorId+"="+e.errorMsg);
		}
		
		private function onAlertDismissed(e:PNEvent):void
		{	trace("dismissed alert "+e.alert);
		}
		
		private function onNotification(e:PNEvent):void
		{
			trace(e.type+"="+e.rawPayload+","+e.badgeValue+","+e.title);
		}

	}

}