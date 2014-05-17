package view.effectLayer 
{
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class ResultEffect extends BaseEffect 
	{
		public function ResultEffect() 
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
				case EffectLayer.FINISH_FULL_DECK_EFFECT:
					addContent("zFinishFullDeckEffect");
				break;
				case EffectLayer.AIR_FULL_DECK_EFFECT:
					addContent("zAirFullDeckEffect");
				break;
				case EffectLayer.NO_RELATIONSHIP_EFFECT:
					addContent("zNoRelationshipEffect");
				break;
			}
			var filterTemp:GlowFilter = new GlowFilter(0xFF9933, 1, 11, 11, 4, 1);
			content.filters = [filterTemp];
		}
	}

}