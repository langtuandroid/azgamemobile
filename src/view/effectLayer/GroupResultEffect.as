package view.effectLayer 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class GroupResultEffect extends BaseEffect 
	{
		private var mc:MovieClip;
		public function GroupResultEffect() 
		{
			super();
			addContent("zGroupResultEffect");
			mc = (content as MovieClip);
			effectType = BaseEffect.SCALE_INCREASE;
		}
		
		public function setValue(type:String = '',value:int = 0):void
		{
			if (value == 1)
				effectType = BaseEffect.SMALL_SCALE_INCREASE;
				
			switch (type) 
			{
				case '39':
					mc.gotoAndStop("sanhrongcuon");
				break;
				case '38':
					mc.gotoAndStop("sanhrong");
				break;
				case '37':
					mc.gotoAndStop("rongmau");
				break;
				case '36':
					mc.gotoAndStop("rongmau");
				break;
				case '35':
					mc.gotoAndStop("rong1mat");
				break;
				case '34':
					mc.gotoAndStop("rong1mat");
				break;
				case '33':
					mc.gotoAndStop("5doi1xam");
				break;
				case '32':
					mc.gotoAndStop("lucphebon");
				break;
				case '31':
					mc.gotoAndStop("3thung");
				break;
				case '30':
					mc.gotoAndStop("3sanh");
				break;
				case '22':
					mc.gotoAndStop("thungphasanhlon");
				break;
				case '21':
					mc.gotoAndStop("thungphasanhnho");
				break;
				case '20':
					mc.gotoAndStop("thungphasanh");
				break;
				case '19':
					mc.gotoAndStop("tuquyAchi2");
				break;
				case '18':
					mc.gotoAndStop("tuquychi2");
				break;
				case '17':
					mc.gotoAndStop("culuchi2");
				break;
				case '16':
					mc.gotoAndStop("xamAcuoi");
				break;
				case '15':
					mc.gotoAndStop("xamchicuoi");
				break;
				case '14':
					mc.gotoAndStop("thungphasanhlon");
				break;
				case '13':
					mc.gotoAndStop("thungphasanhnho");
				break;
				case '12':
					mc.gotoAndStop("thungphasanh");
				break;
				case '11':
					mc.gotoAndStop("tuquyA");
				break;
				case '10':
					mc.gotoAndStop("tuquy");
				break;
				case '9':
					mc.gotoAndStop("culu");
				break;
				case '8':
					mc.gotoAndStop("thung");
				break;
				case '7':
					mc.gotoAndStop("sanh");
				break;
				case '6':
					mc.gotoAndStop("sanh");
				break;
				case '5':
					mc.gotoAndStop("sanh");
				break;
				case '4':
					mc.gotoAndStop("xamchi");
				break;
				case '3':
					mc.gotoAndStop("thu");
				break;
				case '2':
					mc.gotoAndStop("doi");
				break;
				case '-2':
					mc.gotoAndStop("2mauthau");
				break;
				case '-3':
					mc.gotoAndStop("3mauthau");
				break;
				case '-4':
					mc.gotoAndStop("4mauthau");
				break;
				case '-5':
					mc.gotoAndStop("5mauthau");
				break;
				case '-6':
					mc.gotoAndStop("6mauthau");
				break;
				case '-7':
					mc.gotoAndStop("7mauthau");
				break;
				case '-8':
					mc.gotoAndStop("8mauthau");
				break;
				case '-9':
					mc.gotoAndStop("9mauthau");
				break;
				case '-10':
					mc.gotoAndStop("10mauthau");
				break;
				case '-11':
					mc.gotoAndStop("Jmauthau");
				break;
				case '-12':
					mc.gotoAndStop("Qmauthau");
				break;
				case '-13':
					mc.gotoAndStop("Kmauthau");
				break;
				case '-14':
					mc.gotoAndStop("Amauthau");
				break;
				case '-15':
					mc.gotoAndStop("saphamthua");
				break;
				case '-16':
					mc.gotoAndStop("saphamthang");
				break;
				case '-17':
					mc.gotoAndStop("saplang");
				break;
				case '-18':
					mc.gotoAndStop("batsaplang");
				break;
				case '-19':
					mc.gotoAndStop("binhlung");
				break;
				default:
					mc.gotoAndStop("none");
			}
		}
	}

}