package view.window.news 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import model.MainData;
	import view.ScrollView.ScrollViewYun;
	
	import flash.text.*;
	import flash.display.*;
	//TweenPlugin.activate([ThrowPropsPlugin]);
	/**
	 * ...
	 * @author ...
	 */
	public class ShowNewsDetail extends MovieClip 
	{
		private var content:MovieClip;
		private var bounds:Rectangle;
		
		private var y1:Number = 0;
		private var y2:Number = 0;
		private var t1:uint;
		private var t2:uint;
		private var yOverlap:Number = 0;
		private var yOffset:Number = 0;
		private var blitMask:BlitMask;
		private var mainData:MainData = MainData.getInstance();
		private var scrollView:ScrollViewYun;
		private var newsTitle:TextField;
		private var newsTime:TextField;
		public function ShowNewsDetail() 
		{
			super();
			
			content = new ShowDetailNewsMc();
			addChild(content);
			
			scrollView = new ScrollViewYun();
			scrollView.isForMobile = !mainData.isShowScroll;
			scrollView.setData(content.containerNews, 0);
			
			scrollView.columnNumber = 1;
			scrollView.isScrollVertical = true;
			content.addChild(scrollView);
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 18;
			myFormat.color = 0xffffff;
			myFormat.bold = true;
			myFormat.font = "Tahoma";
			myFormat.align = TextFormatAlign.LEFT;

			newsTitle = new TextField();
			newsTitle.defaultTextFormat = myFormat;
			newsTitle.text = "";
			content.addChild(newsTitle);
			newsTitle.width = content.titleTxt.width;
			newsTitle.height = content.titleTxt.height;
			newsTitle.mouseEnabled = false;
			newsTitle.x = content.titleTxt.x;
			newsTitle.y = content.titleTxt.y;
			
			myFormat.size = 16;
			myFormat.color = 0x666666;
			
			newsTime = new TextField();
			newsTime.defaultTextFormat = myFormat;
			newsTime.text = "";
			content.addChild(newsTime);
			newsTime.width = content.timeTxt.width;
			newsTime.height = content.timeTxt.height;
			newsTime.mouseEnabled = false;
			newsTime.x = content.timeTxt.x;
			newsTime.y = content.timeTxt.y;
			
			content.titleTxt.visible = false;
			content.timeTxt.visible = false;
			content.closeBtn.addEventListener(MouseEvent.MOUSE_UP, onClose);
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new Event("close"));
		}
		
		public function addInfo(title:String, timeNews:String, contentNews:String):void 
		{
			
			newsTitle.text = title;
			newsTime.text = formatDate(timeNews);
			
			var sp:Sprite = new Sprite();
			var tf:TextField = new TextField();
			
			
			tf.defaultTextFormat = new TextFormat("Tahoma", 16, 0xcccccc);
			
			tf.multiline = tf.wordWrap = true;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.htmlText = contentNews;
			
			tf.width = 580;
			tf.height = tf.textHeight;
			sp.addChild(tf);
			scrollView.addRow(sp);
			
			//bounds = new Rectangle(content.containerNews.x, content.containerNews.y, 582, 304);
			
			//setupTextField(content.containerNews, bounds, contentNews);
			//blitMask = new BlitMask(content.containerNews, bounds.x, bounds.y, bounds.width, bounds.height, false);

			//blitMask.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);


		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			TweenLite.killTweensOf(content.containerNews);
			y1 = y2 = content.containerNews.y;
			yOffset = this.mouseY - content.containerNews.y;
			yOverlap = Math.max(0, content.containerNews.height - bounds.height);
			t1 = t2 = getTimer();
			content.containerNews.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			content.containerNews.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseMoveHandler(event:MouseEvent):void 
		{
			var y:Number = this.mouseY - yOffset;
			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if (y > bounds.top) {
				content.containerNews.y = (y + bounds.top) * 0.5;
			} else if (y < bounds.top - yOverlap) {
				content.containerNews.y = (y + bounds.top - yOverlap) * 0.5;
			} else {
				content.containerNews.y = y;
			}
			blitMask.update();
			var t:uint = getTimer();
			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
			if (t - t2 > 50) {
				y2 = y1;
				t2 = t1;
				y1 = content.containerNews.y;
				t1 = t;
			}
			event.updateAfterEvent();
		}

		private function mouseUpHandler(event:MouseEvent):void 
		{
			content.containerNews.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			content.containerNews.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var time:Number = (getTimer() - t2) / 1000;
			var yVelocity:Number = (content.containerNews.y - y2) / time;
			TweenMax.to(content.containerNews, 1, {y:{velocity:yVelocity, max:bounds.top, min:bounds.top - yOverlap, resistance:300}
									 , onUpdate:blitMask.update, ease:Strong.easeOut
										});
		}

		private function setupTextField(container:MovieClip, bounds:Rectangle, contentNews:String, padding:Number = 10):void 
		{
			var tf:TextField = new TextField();
			tf.width = bounds.width - padding;
			tf.x = tf.y = padding / 2;
			tf.defaultTextFormat = new TextFormat("Tahoma", 16);
			//tf.htmlText = contentNews;
			tf.htmlText = "So I have been working on a mp3player that is designed similar to a ipod with a little bit different functionality. I needed the text fields to scroll back and forth so you could see all the text written inside of it, if the field was shorter than the width of the text. After looking around for a tutorial or another persons help and not finding a thing for Actionscript 3, I decided to write my own. I am using Tweenlite to handle the tweens because its really low on weight and its a very smooth and powerful tweening engine. I am almost done with the mp3player and I will show you that very soon, but I wanted to post an example of the scrolling text or flash ticker (as some people call them) to you first before then. The example and code is below. I use one movieclip with an instance name of item that has two items inside of it, a dynamic textfield holding the text and a mask to only show the part I want shown.";
			tf.multiline = tf.wordWrap = true;
			tf.selectable = false;
			
			tf.autoSize = TextFieldAutoSize.LEFT;
			container.addChild(tf);

			

		}
		
		private function formatDate(str:String):String 
		{
			var string:String = "";
			var pos:int = str.search("T");
			var str1:String = str.substring(pos + 1, str.length) + "'";
			var str2:String = "";
			var str3:String = "";
			var str4:String = "";
			var count:int = 0;
			for (var i:int = 0; i < pos; i++) 
			{
				if (count < 1) 
				{
					str4 += str.charAt(i);
				}
				else if (count == 1) 
				{
					str3 += str.charAt(i);
				}
				else if (count == 2) 
				{
					str2 += str.charAt(i);
				}
				
				if (str.charAt(i) == "-") 
				{
					count++;
				}
			}
			
			string = str1 + " " + str2 + "-" + str3 + str4.replace("-", "");
			return string;
		}
		
	}

}