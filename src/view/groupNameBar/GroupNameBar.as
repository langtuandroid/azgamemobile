package view.groupNameBar 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class GroupNameBar extends Sprite 
	{
		private var content:Sprite;
		private var mainData:MainData = MainData.getInstance();
		private var openButton:Sprite;
		private var groupNameSlice:Sprite;
		private var totalSpecialGroup:Sprite;
		private var totalGroup:Sprite;
		private var totalGroupTooltip:Sprite;
		private var totalSpecialGroupTooltip:Sprite;
		private var specialGroupTab:MovieClip;
		private var groupTab:MovieClip;
		private var specialGroupButtonArray:Array
		private var specialGroupTooltipArray:Array
		private var specialGroupTooltipTweenArray:Array
		private var specialGroupTooltipTweenArray2:Array
		private var groupButtonArray:Array
		private var groupTooltipArray:Array
		private var groupTooltipTweenArray:Array
		private var groupTooltipTweenArray2:Array
		private var movingTween:GTween;
		private var isOpen:Boolean;
		public var deckRank:Array;
		private var twinkleBar:Sprite;
		private var twinkleBarStartX:Number;
		private var movingTwinkleBarTimer:Timer;
		private var movingTwinkleTween:GTween;
		
		public function GroupNameBar() 
		{
			var className:String = "zGroupNameBar";
			addContent(className);
			
			openButton = content["openButton"];
			openButton.addEventListener(MouseEvent.CLICK, onOpenButtonClick);
			openButton.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			openButton.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			openButton["mouseOverStatus"].visible = false;
			openButton["chooseStatus"].visible = false;
			groupNameSlice = content["groupNameSlice"];
			groupNameSlice.visible = false;
			groupNameSlice = content["groupNameSlice"];
			totalSpecialGroup = groupNameSlice["totalSpecialGroup"];
			totalGroup = groupNameSlice["totalGroup"];
			specialGroupTab = groupNameSlice["specialGroupTab"];
			groupTab = groupNameSlice["groupTab"];
			twinkleBar = openButton["twinkleBar"];
			twinkleBarStartX = twinkleBar.x;
			totalGroupTooltip = groupNameSlice["totalGroupTooltip"];
			totalSpecialGroupTooltip = groupNameSlice["totalSpecialGroupTooltip"];
			openButton.buttonMode = true;
			totalSpecialGroup.visible = false;
			groupTab.gotoAndStop(2);
			groupTab.buttonMode = specialGroupTab.buttonMode = true;
			groupTab.addEventListener(MouseEvent.CLICK, onTabClick);
			specialGroupTab.addEventListener(MouseEvent.CLICK, onTabClick);
			specialGroupTooltipTweenArray = new Array();
			specialGroupTooltipTweenArray2 = new Array();
			groupTooltipTweenArray = new Array();
			groupTooltipTweenArray2 = new Array();
			
			var i:int;
			specialGroupButtonArray = new Array();
			for (i = 0; i < 14; i++) 
			{
				specialGroupButtonArray[i] = totalSpecialGroup["specialGroupButton" + String(i + 1)];
				specialGroupButtonArray[i].addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				specialGroupButtonArray[i].addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				specialGroupButtonArray[i]["mouseOverStatus"].visible = false;
				specialGroupButtonArray[i]["mouseOutStatus"]["content"].text = mainData.init.gameDescription.playingScreen.specialGroupButtonName.node[i];
				specialGroupButtonArray[i]["mouseOverStatus"]["content"].text = mainData.init.gameDescription.playingScreen.specialGroupButtonName.node[i];
			}
			groupButtonArray = new Array();
			for (i = 0; i < 10; i++) 
			{
				groupButtonArray[i] = totalGroup["groupButton" + String(i + 1)];
				groupButtonArray[i].addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				groupButtonArray[i].addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				groupButtonArray[i]["mouseOverStatus"].visible = false;
				groupButtonArray[i]["chooseStatus"].visible = false;
				groupButtonArray[i]["mouseOutStatus"]["content"].text = mainData.init.gameDescription.playingScreen.groupButtonName.node[i];
				groupButtonArray[i]["mouseOverStatus"]["content"].text = mainData.init.gameDescription.playingScreen.groupButtonName.node[i];
				groupButtonArray[i]["chooseStatus"]["content"].text = mainData.init.gameDescription.playingScreen.groupButtonName.node[i];
			}
			specialGroupTooltipArray = new Array();
			for (i = 0; i < 14; i++) 
			{
				specialGroupTooltipArray[i] = totalSpecialGroupTooltip["specialGroupTooltip" + String(i + 1)];
				TextField(specialGroupTooltipArray[i]["content"]).autoSize = TextFieldAutoSize.LEFT;
				TextField(specialGroupTooltipArray[i]["content"]).wordWrap = true;
				specialGroupTooltipArray[i]["content"].text = mainData.init.gameDescription.playingScreen.specialGroupName.node[i];
				if(specialGroupTooltipArray[i]["content"].height + 10 > 43)
					specialGroupTooltipArray[i]["background"].height = specialGroupTooltipArray[i]["content"].height + 10;
				//var filterTemp:GlowFilter = new GlowFilter(0xFF9900, 1, 3, 3, 10, 1);
				//specialGroupTooltipArray[i]["background"].filters = [filterTemp];
				//specialGroupTooltipArray[i]["background"].caseAsBitmap = true;
			}
			groupTooltipArray = new Array();
			for (i = 0; i < 10; i++) 
			{
				groupTooltipArray[i] = totalGroupTooltip["groupTooltip" + String(i + 1)];
				TextField(groupTooltipArray[i]["content"]).autoSize = TextFieldAutoSize.LEFT;
				TextField(groupTooltipArray[i]["content"]).wordWrap = true;
				groupTooltipArray[i]["content"].text = mainData.init.gameDescription.playingScreen.groupName.node[i];
				if(groupTooltipArray[i]["content"].height + 10 > 43)
					groupTooltipArray[i]["background"].height = groupTooltipArray[i]["content"].height + 10;
				//filterTemp = new GlowFilter(0xFF9900, 1, 3, 3, 10, 1);
				//groupTooltipArray[i]["background"].filters = [filterTemp];
				//groupTooltipArray[i]["background"].caseAsBitmap = true;
			}
			
			movingTwinkleBarTimer = new Timer(10000, 1);
			movingTwinkleBarTimer.addEventListener(TimerEvent.TIMER, onMoveTwinkleBar);
			//movingTwinkleBarTimer.start();
		}
		
		private function onMoveTwinkleBar(e:TimerEvent):void 
		{
			if (!stage)
			{
				if (movingTwinkleBarTimer)
				{
					movingTwinkleBarTimer.removeEventListener(TimerEvent.TIMER, onMoveTwinkleBar);
					movingTwinkleBarTimer.stop();
					movingTwinkleBarTimer = null;
				}
			}
			twinkleBar.x = twinkleBarStartX;
			var tempGTween:GTween = new GTween(twinkleBar, 0.7, { x:twinkleBarStartX + 300});
		}
		
		private function onTabClick(e:MouseEvent):void 
		{
			var i:int;
			for (i = 0; i < groupTooltipArray.length; i++) 
			{
				groupTooltipArray[i].x = 0;
			}
			for (i = 0; i < specialGroupTooltipArray.length; i++) 
			{
				specialGroupTooltipArray[i].x = 0;
			}
			if (e.currentTarget == groupTab)
			{
				if (!totalGroup.visible)
				{
					totalGroup.visible = true;
					totalSpecialGroup.visible = false;
					groupTab.gotoAndStop(2);
					specialGroupTab.gotoAndStop(1);
				}
			}
			else
			{
				if (!totalSpecialGroup.visible)
				{
					totalSpecialGroup.visible = true;
					totalGroup.visible = false;
					groupTab.gotoAndStop(1);
					specialGroupTab.gotoAndStop(2);
				}
			}
		}
		
		public function open():void
		{
			if (!isOpen)
			{
				isOpen = true;
				openButton["chooseStatus"].visible = isOpen;
				groupNameSlice.visible = true;
				if(movingTween)
					movingTween.end();
				movingTween = new GTween(groupNameSlice, 0.2, { x:0, y:0}/*, { ease:Back.easeIn }*/);
				movingTween.addEventListener(Event.COMPLETE, openComplete);
			}
		}
		
		public function close():void
		{
			var i:int;
			isOpen = false;
			for (i = 0; i < groupTooltipArray.length; i++) 
			{
				groupTooltipArray[i].x = 0;
			}
			for (i = 0; i < specialGroupTooltipArray.length; i++) 
			{
				specialGroupTooltipArray[i].x = 0;
			}
			
			if(movingTween)
				movingTween.end();
			movingTween = new GTween(groupNameSlice, 0.2, { x:0, y:276}/*, { ease:Back.easeIn }*/);
			movingTween.addEventListener(Event.COMPLETE, closeComplete);
		}
		
		private function onOpenButtonClick(e:MouseEvent):void 
		{
			if (!isOpen)
			{
				isOpen = true;
				groupNameSlice.visible = true;
				if(movingTween)
					movingTween.end();
				movingTween = new GTween(groupNameSlice, 0.2, { x:0, y:-88}/*, { ease:Back.easeIn }*/);
				movingTween.addEventListener(Event.COMPLETE, openComplete);
			}
			else
			{
				var i:int;
				isOpen = false;
				for (i = 0; i < groupTooltipArray.length; i++) 
				{
					groupTooltipArray[i].x = 0;
				}
				for (i = 0; i < specialGroupTooltipArray.length; i++) 
				{
					specialGroupTooltipArray[i].x = 0;
				}
				
				if(movingTween)
					movingTween.end();
				movingTween = new GTween(groupNameSlice, 0.2, { x:0, y:276}/*, { ease:Back.easeIn }*/);
				movingTween.addEventListener(Event.COMPLETE, closeComplete);
			}
			openButton["chooseStatus"].visible = isOpen;
		}
		
		private function openComplete(e:Event):void 
		{
			
		}
		
		private function onCloseButtonClick(e:MouseEvent):void 
		{
			
		}
		
		private function closeComplete(e:Event):void 
		{
			groupNameSlice.visible = false;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (e.currentTarget == openButton)
			{
				if (movingTwinkleTween)
					movingTwinkleTween.end();
				twinkleBar.x = twinkleBarStartX;
				movingTwinkleTween = new GTween(twinkleBar, 0.7, { x:twinkleBarStartX + 300});
			}
			e.currentTarget["mouseOverStatus"].visible = true;
			e.currentTarget["mouseOutStatus"].visible = false;
			
			var i:int;
			for (i = 0; i < groupButtonArray.length; i++) 
			{
				if (e.currentTarget == groupButtonArray[i])
				{
					if (groupTooltipTweenArray[i])
						GTween(groupTooltipTweenArray[i]).end();
					totalGroupTooltip.addChild(groupTooltipArray[i]);
					groupTooltipTweenArray[i] = new GTween(groupTooltipArray[i], 0.6, { x: -148, alpha:1 }, { ease:Back.easeOut } );
					i = groupButtonArray.length;
				}
			}
			
			for (i = 0; i < specialGroupButtonArray.length; i++) 
			{
				if (e.currentTarget == specialGroupButtonArray[i])
				{
					if (specialGroupTooltipTweenArray[i])
						GTween(specialGroupTooltipTweenArray[i]).end();
					totalSpecialGroupTooltip.addChild(specialGroupTooltipArray[i]);
					specialGroupTooltipTweenArray[i] = new GTween(specialGroupTooltipArray[i], 0.6, { x: -148, alpha:1 }, { ease:Back.easeOut } );
					i = specialGroupButtonArray.length;
				}
			}
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			e.currentTarget["mouseOverStatus"].visible = false;
			e.currentTarget["mouseOutStatus"].visible = true;
			
			var i:int;
			for (i = 0; i < groupButtonArray.length; i++) 
			{
				if (e.currentTarget == groupButtonArray[i])
				{
					if (groupTooltipTweenArray[i])
						GTween(groupTooltipTweenArray[i]).end();
					groupTooltipTweenArray[i] = new GTween(groupTooltipArray[i], 0.6, { x:0}, { ease:Back.easeIn } );
					if (groupTooltipTweenArray2[i])
						GTween(groupTooltipTweenArray2[i]).end();
					groupTooltipTweenArray2[i] = new GTween(groupTooltipArray[i], 0.4, {alpha:0 }, { ease:Back.easeIn } );
					i = groupButtonArray.length;
				}
			}
			
			for (i = 0; i < specialGroupButtonArray.length; i++) 
			{
				if (e.currentTarget == specialGroupButtonArray[i])
				{
					if (specialGroupTooltipTweenArray[i])
						GTween(specialGroupTooltipTweenArray[i]).end();
					specialGroupTooltipTweenArray[i] = new GTween(specialGroupTooltipArray[i], 0.6, { x:0 }, { ease:Back.easeIn } );
					if (specialGroupTooltipTweenArray2[i])
						GTween(specialGroupTooltipTweenArray2[i]).end();
					specialGroupTooltipTweenArray2[i] = new GTween(specialGroupTooltipArray[i], 0.4, {alpha:0 }, { ease:Back.easeIn } );
					i = specialGroupButtonArray.length;
				}
			}
		}
		
		private function addContent(className:String):void
		{
			var tempClass:Class;
			tempClass = Class(getDefinitionByName(className));
			content = Sprite(new tempClass());
			addChild(content);
		}
		
		public function updateThreeGroup():void
		{
			resetAllGroup();
			groupButtonArray[deckRank[1] - 1]["mouseOutStatus"].visible = false;
			groupButtonArray[deckRank[1] - 1]["chooseStatus"].visible = true;
			groupButtonArray[deckRank[2] - 1]["mouseOutStatus"].visible = false;
			groupButtonArray[deckRank[2] - 1]["chooseStatus"].visible = true;
			groupButtonArray[deckRank[3] - 1]["mouseOutStatus"].visible = false;
			groupButtonArray[deckRank[3] - 1]["chooseStatus"].visible = true;
		}
		
		public function resetAllGroup():void
		{
			var i:int;
			for (i = 0; i < groupButtonArray.length; i++) 
			{
				groupButtonArray[i]["mouseOutStatus"].visible = true;
				groupButtonArray[i]["chooseStatus"].visible = false;
			}
		}
	}

}