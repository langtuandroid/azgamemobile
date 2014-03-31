package view.specialText 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ZhaoYun
	 */
	public class SpecialText2 extends Sprite
	{
		private var bitmap:Bitmap;
		private var textSize:int;
		
		public function SpecialText2(ts:int = 18) 
		{
			bitmap = new Bitmap();
			textSize = ts;
		}
		
		public function setText(content:String):void
		{
			var tempTextfield:TextField = new TextField();
			tempTextfield.width = 800;
			tempTextfield.wordWrap = true;
			tempTextfield.filters = [new GlowFilter(0x000000, 1, 2, 2,6,3)];
			tempTextfield.defaultTextFormat = new TextFormat("TimesNewRoman", textSize, 0xFFFFFF, true,null,null,null,null,"center");
			//tempTextfield.background = true;
			tempTextfield.autoSize = TextFieldAutoSize.LEFT;
			tempTextfield.text = content;
			var tempBitmapData:BitmapData = new BitmapData(tempTextfield.width, tempTextfield.height + 10,true,0x00FFFFFF);
			tempBitmapData.draw(tempTextfield);
			if (this.contains(bitmap))
				removeChild(bitmap);
			bitmap = new Bitmap(tempBitmapData);
			bitmap.smoothing = true;
			addChild(bitmap);
		}
		
	}

}