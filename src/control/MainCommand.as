package control 
{
	import control.electroServerCommand.ElectroServerCommandMauBinh;
	import control.electroServerCommand.ElectroServerCommandPhom;
	import control.electroServerCommand.ElectroServerCommandTlmn;
	import control.electroServerCommand.ElectroServerCommandXito;
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
		public var electroServerCommandMauBinh:ElectroServerCommandMauBinh;
		public var electroServerCommandPhom:ElectroServerCommandPhom;
		public var electroServerCommandXito:ElectroServerCommandXito;
		//public var electroServerCommandTlmn:ElectroServerCommandTlmnYun;
		public var electroServerCommandTlmn:ElectroServerCommandTlmn;
		private var mainData:MainData = MainData.getInstance();
		
		public function MainCommand() 
		{
			initCommand = new InitCommand();
			getInfoCommand = new GetInfoCommand();
			electroServerCommandMauBinh = new ElectroServerCommandMauBinh();
			electroServerCommandPhom = new ElectroServerCommandPhom();
			electroServerCommandTlmn = new ElectroServerCommandTlmn();
			electroServerCommandXito = new ElectroServerCommandXito();
		}
		
		public function initVar():void
		{
			switch (mainData.gameType) 
			{
				case MainData.MAUBINH:
					electroServerCommand = electroServerCommandMauBinh;
				break;
				case MainData.PHOM:
					electroServerCommand = electroServerCommandPhom;
				break;
				case MainData.TLMN:
					electroServerCommand = electroServerCommandTlmn;
				break;
				case MainData.SAM:
					electroServerCommand = electroServerCommandTlmn;
				break;
				case MainData.XITO:
					electroServerCommand = electroServerCommandXito;
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