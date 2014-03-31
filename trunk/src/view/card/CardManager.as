package view.card 
{
	import com.adobe.serialization.json.JSON;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import event.DataField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import logic.PhomLogic;
	import model.MainData;
	import view.userInfo.playerInfo.PlayerInfo;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class CardManager extends Sprite 
	{
		public static const TURN_OVER_STYLE:String = "turnOverStyle"; // kiểu chia mà lá bài vẫn úp
		public static const OPEN_MIDDLE_STYLE:String = "openMiddleStyle"; // kiểu chia mà lá bài vừa di chuyển vừa lật
		public static const OPEN_FINISH_STYLE:String = "openFinishStyle"; // kiểu chia mà lá bài di chuyển đến nơi sẽ mở
		
		public static const GET_CARD:String = "getCard"; // Thông báo là user vừa click vào rút bài
		
		private var content:Sprite;
		
		public static const cardToDesTime:Number = 0.70; // giây - thời gian lá bài di chuyển từ chỗ chia bài đến người chơi
		public static const arrangeCardTime:Number = 0.4; // giây - thời gian sắp xếp lại các lá bài
		public static const clickCardTime:Number = 0.1; // giây - thời gian di chuyển khi click chọn lá bài
		public static const playCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ bài chưa đánh đến chỗ bài đánh
		public static const downCardTime:Number = 0.5; // giây - thời gian lá bài di chuyển từ chỗ người chơi đến chỗ hạ bài
		private static const divideUserTimeDistance:Number = 160; // mili giây - khoảng thời gian cách nhau khi bắt đầu chia cho mỗi người chơi
		
		private var phomLogic:PhomLogic = PhomLogic.getInstance();
		private var mainData:MainData = MainData.getInstance();
		
		public var playerArray:Array; // Mảng chứa các player
		private var countDivideIndex:int = 0; // Biến dùng để đếm việc chia bài, chia cho từng người chơi, chia xong một lượt biến sẽ được reset lại 0
		private var timerToDivide:Timer;
		
		private var filterNumber:Number = 0;
		private var isFilterDown:Boolean;
		private var getCardPoint:Sprite;
		public var getCardIcon:Sprite;
		
		public function CardManager() 
		{
			
		}
	}

}