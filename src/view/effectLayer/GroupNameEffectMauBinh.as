package view.effectLayer 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import logic.PlayingLogic;
	import view.userInfo.playerInfo.PlayerInfoMauBinh;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class GroupNameEffectMauBinh extends BaseEffect 
	{
		private var description:TextField;
		private var bitmap:Bitmap;
		private var redTxt:TextField;
		private var greenTxt:TextField;
		
		public function GroupNameEffectMauBinh() 
		{
			addContent("zGroupNameEffectMauBinh");
			redTxt = content["redTxt"];
			redTxt.autoSize = TextFieldAutoSize.LEFT;
			greenTxt = content["greenTxt"];
			greenTxt.autoSize = TextFieldAutoSize.LEFT;
			effectType = BaseEffect.SCALE_INCREASE;
			movingDistanceX = 100;
		}
		
		public function setValue(value:int, type:String = ''):void
		{
			greenTxt.visible = redTxt.visible = false;
			if (value >= 0)
			{
				greenTxt.text = "+" + String(value);
				if (type == PlayerInfoMauBinh.BELOW_USER)
				{
					content["chiMc"].x = greenTxt.x + greenTxt.width + 3;
					content["chiMc"].y = greenTxt.y;
				}
				else
				{
					greenTxt.x = content["chiMc"].x + (35 - greenTxt.width);
				}
				greenTxt.visible = true;
			}
			else
			{
				redTxt.text = String(value);
				if (type == PlayerInfoMauBinh.BELOW_USER)
				{
					content["chiMc"].x = redTxt.x + redTxt.width + 3;
					content["chiMc"].y = redTxt.y;
				}
				else
				{
					trace("aaaaaaaaaaaaaaaa",content["chiMc"].width);
					redTxt.x = content["chiMc"].x + (35 - redTxt.width);
				}
				redTxt.visible = true;
			}
		}
	}

}