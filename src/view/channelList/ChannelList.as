package view.channelList 
{
	import control.MainCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.ChannelData;
	import view.BaseView;
	import view.window.windowLayer.WindowLayer;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ChannelList extends BaseView 
	{
		public static const CHANNEL_CLICK:String = "channelClick";
		
		private var _list:Array;
		private var viewList:Array;
		private var background:Sprite;
		private var bottomLine:Sprite;
		public var currentChannelData:ChannelData;
		
		public function ChannelList() 
		{
			addContent("zChannelList");
			background = content["background"];
			bottomLine = content["bottomLine"];
			background.visible = bottomLine.visible = false;
		}
		
		public function set list(value:Array):void 
		{
			if (viewList)
			{
				for (var i:int = 0; i < viewList.length; i++)
				{
					if (viewList[i].parent)
						viewList[i].parent.removeChild(viewList[i]);
				}
			}
			
			_list = value;
			
			viewList = new Array();
			for (i = 0; i < value.length; i++) 
			{
				var channelRow:ChannelRow = new ChannelRow();
				channelRow.data = value[i];
				channelRow.y = i * channelRow.height;
				addChild(channelRow);
				channelRow.addEventListener(MouseEvent.CLICK, onChannelRowClick);
				viewList.push(channelRow);
			}
			
			background.height = (new ChannelRow()).height * value.length + 1;
			bottomLine.y = background.height;
		}
		
		private function onChannelRowClick(e:MouseEvent):void 
		{
			currentChannelData = ChannelRow(e.currentTarget).data;
			dispatchEvent(new Event(CHANNEL_CLICK));
		}
		
	}

}