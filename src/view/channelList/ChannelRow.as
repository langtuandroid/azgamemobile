package view.channelList 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import model.ChannelData;
	import view.BaseView;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ChannelRow extends BaseView 
	{
		private var channelNameTxt:TextField;
		private var playerNumberTxt:TextField;
		
		private var _data:ChannelData;
		
		public function ChannelRow() 
		{
			addContent("zChannelRow");
			
			channelNameTxt = content["channelNameTxt"];
			playerNumberTxt = content["playerNumberTxt"];
		}
		
		public function get data():ChannelData 
		{
			return _data;
		}
		
		public function set data(value:ChannelData):void 
		{
			_data = value;
			channelNameTxt.text = data.channelName;
			playerNumberTxt.text = String(data.playerNumber) + "/" + String(data.maxPlayer) + " người";
			
			if (data.playerNumber >= data.maxPlayer)
				enable = false;
			else
				enable = true;
				
			if (data.channelId == mainData.currentChannelId)
				enable = false;
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (enable)
			{
				buttonMode = true;
				mouseChildren = false;
			}
			else
			{
				channelNameTxt.alpha = 0.5;
				playerNumberTxt.alpha = 0.5;
				buttonMode = false;
				mouseChildren = false;
				addEventListener(MouseEvent.CLICK, onClick);
				MovieClip(content["background"]).gotoAndStop("disable");
			}
		}
		
		private var _enable:Boolean;
		
		private function onClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
	}

}