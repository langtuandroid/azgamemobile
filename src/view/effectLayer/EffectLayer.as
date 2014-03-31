package view.effectLayer 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import model.MainData;
	
	/**
	 * ...
	 * @author Yun
	 */
	public class EffectLayer extends Sprite 
	{
		public static const FULL_DECK_EFFECT:String = "fullDeckEffect"; // Hiệu ứng ù
		public static const NO_DECK_EFFECT:String = "noDeckEffect"; // Hiệu ứng móm
		public static const COMPENSATE_ALL_EFFECT:String = "compensateAllEffect"; // Hiệu ứng ù đền
		public static const WIN_EFFECT:String = "winEffect"; // Hiệu ứng thắng
		public static const NO_RELATIONSHIP_EFFECT:String = "noRelationshipEffect"; // Hiệu ứng ù khan
		public static const MONEY_EFFECT:String = "moneyEffect"; // Hiệu ứng số tiền
		public static const GROUP_NAME_EFFECT:String = "groupNameEffect"; // Hiệu ứng tên chi
		public static const GROUP_NAME_EFFECT_MAU_BINH:String = "groupNameEffect"; // Hiệu ứng tên chi
		public static const GROUP_RESULT_EFFECT:String = "groupResultEffect"; // Hiệu ứng tên chi
		
		private var mainData:MainData = MainData.getInstance();
		
		public function EffectLayer() 
		{
			
		}
		
		private static var _instance:EffectLayer;
		public static function getInstance():EffectLayer
		{
			if (!_instance)
				_instance = new EffectLayer();
			return _instance;
		}
		
		public function addEffect(effectName:String, positionPoint:Point, removeTime:Number, value:int = 0, content:String = ""):void
		{
			var tempClass:Class;
			var effect:BaseEffect;
			switch (effectName) 
			{
				case FULL_DECK_EFFECT:
					effect = new ResultEffect();
					ResultEffect(effect).setType(FULL_DECK_EFFECT);
				break;
				case NO_DECK_EFFECT:
					effect = new ResultEffect();
					ResultEffect(effect).setType(NO_DECK_EFFECT);
				break;
				case COMPENSATE_ALL_EFFECT:
					effect = new ResultEffect();
					ResultEffect(effect).setType(COMPENSATE_ALL_EFFECT);
				break;
				case WIN_EFFECT:
					effect = new ResultEffect();
					ResultEffect(effect).setType(WIN_EFFECT);
				break;
				case NO_RELATIONSHIP_EFFECT:
					effect = new ResultEffect();
					ResultEffect(effect).setType(NO_RELATIONSHIP_EFFECT);
				break;
				case MONEY_EFFECT:
					if (value == 0)
						return;
					effect = new TextEffect_1();
					TextEffect_1(effect).setValue(value);
				break;
				case GROUP_NAME_EFFECT_MAU_BINH:
					effect = new GroupNameEffectMauBinh();
					GroupNameEffectMauBinh(effect).setValue(value, content);
				break;
				case GROUP_RESULT_EFFECT:
					effect = new GroupResultEffect();
					GroupResultEffect(effect).setValue(content, value);
				break;
			}
			
			effect.x = positionPoint.x;
			effect.y = positionPoint.y;
			addChild(effect);
			effect.effectShow(removeTime);
		}
		
		public function removeAllEffect():void
		{
			if (!stage)
				return;
			var effectArray:Array = new Array();
			for (var i:int = 0; i < numChildren; i++) 
			{
				if (getChildAt(i) is BaseEffect)
					effectArray.push(getChildAt(i));
			}
			for (var j:int = 0; j < effectArray.length; j++) 
			{
				removeChild(effectArray[j]);
			}
		}
	}

}