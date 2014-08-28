package  
{
	import InitCommand;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Yun
	 */
	public class MainCommand 
	{
		public var initCommand:InitCommand;
		
		public function MainCommand() 
		{
			initCommand = new InitCommand();
		}
		
		private static var _instance:MainCommand;
		public static function getInstance():MainCommand
		{
			if (!_instance)
				_instance = new MainCommand();
			return _instance;
		}
		
	}

}