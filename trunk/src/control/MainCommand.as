package control 
{
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import control.electroServerCommand.ElectroServerCommandMauBinh;
	import control.getInfoCommand.GetInfoCommand;
	import control.initCommand.InitCommand;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import model.MainData;
	/**
	 * ...
	 * @author Yun
	 */
	public class MainCommand 
	{
		public var initCommand:InitCommand;
		public var getInfoCommand:GetInfoCommand;
		public var electroServerCommand:*;
		private var mainData:MainData = MainData.getInstance();
		
		public function MainCommand() 
		{
			initCommand = new InitCommand();
			getInfoCommand = new GetInfoCommand();
		}
		
		public function initVar():void
		{
			switch (mainData.gameType) 
			{
				case MainData.MAUBINH:
					electroServerCommand = new ElectroServerCommandMauBinh();
				break;
				case MainData.TLMN:
					electroServerCommand = new ElectroServerCommandTlmn();
				break;
				default:
			}
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