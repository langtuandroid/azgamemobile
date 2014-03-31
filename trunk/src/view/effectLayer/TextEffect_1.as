package view.effectLayer 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import logic.PlayingLogic;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class TextEffect_1 extends BaseEffect 
	{
		private var description:TextField;
		private var bitmap:Bitmap;
		
		public function TextEffect_1() 
		{
			addContent("zEffectText_1");
			description = content["content"];
			description.autoSize = TextFieldAutoSize.LEFT;
			content.removeChild(description);
			effectType = BaseEffect.MOVING_TRANSPARENT;
			movingDistanceX = 100;
		}
		
		public function setValue(value:Number):void
		{
			if (value >= 0)
				description.text = "+" + PlayingLogic.format(value, 1);
			else
				description.text = '-' + PlayingLogic.format(value * -1, 1);
				
			var tempBitmapData:BitmapData = new BitmapData(description.width, description.height,true,0x00FFFFFF);
			tempBitmapData.draw(description);
			
			if (bitmap)
			{
				if (content.contains(bitmap))
					content.removeChild(bitmap);
			}
			
			bitmap = new Bitmap(tempBitmapData);
			bitmap.smoothing = true;
			bitmap.x = - bitmap.width / 2;
			bitmap.y = - bitmap.height / 2;
			content = new Sprite();
			content.addChild(bitmap);
			addChild(content);
		}
	}

}