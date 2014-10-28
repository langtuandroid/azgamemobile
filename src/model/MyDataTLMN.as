package model 
{
	import control.ConstTlmn;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author bimkute
	 */
	public class MyDataTLMN extends EventDispatcher 
	{
		private static var instance:MyDataTLMN;
		/**
		 * 1: tlmn, 2: sam, 3: bay cay
		 */
		public var isGame:int = 1;
		
		public var myName:String = "";
		public var myId:String = "1";
		public var myDisplayName:String = "";
		
		/** [0]: xu
		 * [1]: gold**/
		public var myMoney:Array = [];
		public var myAvatar:String;
		public var password:String = "bimkute";
		
		public var inGame:Boolean = false;
		
		public var myZoneName:String = "TLMN";
		//public var myZoneName:String = "MySecondZone";
		public var myLobbyName:String = "The Lobby";
		public var myExtensionId:String = "TienLenMienNam";
		public var myExtensionClass:String = "tlmnextension.TLMNExtension";
		public var level:int;
		public var roomId:Number;
		public var logo:String;
		public var sex:Boolean;
		public var token:String;
		
		
		public function MyDataTLMN() 
		{
			
		}
		
		
		public static function getInstance():MyDataTLMN 
		{
			if (!instance) 
			{
				instance = new MyDataTLMN();
			}
			return instance;
		}
		
	}

}