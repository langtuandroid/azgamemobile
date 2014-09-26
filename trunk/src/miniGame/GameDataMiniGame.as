package miniGame
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class GameDataMiniGame extends EventDispatcher 
	{
		public var arrTypeOfCard:Array = [];
		public var myId:String = "";
		public var myMoney:int;
		public var myTurn:int;
		
		public var goldGift:Array = [];
		public var cardGift:Array = [];
		public var arrGift:Array = [];
		
		public var client_secret:String = "c3190273c0b4dd630c886bd8f61b7f5a";
		public var client_id:String = "100000000000002";
		public var token:String = "";
		private static var instance:GameDataMiniGame;
		
		public var linkReq:String = "http://wss.test.azgame.us/";
		public function GameDataMiniGame(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		
		
		public static function getInstance():GameDataMiniGame 
		{
			if (!instance) 
			{
				instance = new GameDataMiniGame();
			}
			return instance;
		}
		
		
	}

}