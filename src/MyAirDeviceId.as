package  
{
	import com.freshplanet.ane.AirDeviceId;
	/**
	 * ...
	 * @author ...
	 */
	public class MyAirDeviceId 
	{
		
		public function MyAirDeviceId() 
		{
			
		}
		
		private static var _instance:MyAirDeviceId;
		public static function getInstance():MyAirDeviceId
		{
			if (!_instance)
				_instance = new MyAirDeviceId();
			return _instance;
		}
		
		public function getID(salt:String):String
		{
			return AirDeviceId.getInstance().getID(salt);
		}
	}

}