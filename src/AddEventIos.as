package 
{
	import flash.desktop.NativeApplication;
	/**
	 * ...
	 * @author bimkute
	 */
	public class AddEventIos 
	{
		
		public function AddEventIos() 
		{
			
		}
		private static var _instance:AddEventIos;
		public static function getInstance():AddEventIos
		{
			if (!_instance)
				_instance = new AddEventIos();
			return _instance;
		}
		
		public function addAllEvent():void
		{
			NativeApplication.nativeApplication.executeInBackground = true;
		}
	}

}