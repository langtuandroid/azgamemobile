package view.effectLayer 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class EffectResult extends BaseEffect 
	{
		public function EffectResult() 
		{
			effectType = BaseEffect.SCALE_INCREASE;
		}
		
		public function setType(type:String):void
		{
			switch (type) 
			{
				case EffectLayer.NO_DECK_EFFECT:
					addContent("zNoDeckEffect");
				break;
				case EffectLayer.FULL_DECK_EFFECT:
					addContent("zFullDeckEffect");
				break;
				case EffectLayer.COMPENSATE_ALL_EFFECT:
					addContent("zCompensateAllEffect");
				break;
				case EffectLayer.WIN_EFFECT:
					addContent("zWinEffect");
				break;
				case EffectLayer.WIN_EFFECT:
					addContent("zNoRelationshipEffect");
				break;
			}
		}
	}

}