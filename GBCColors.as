package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	[SWF(width="480", height="432")]
	public class GBCColors extends Engine
	{
		public function GBCColors()
		{
			super(160, 144);
			FP.screen.scale = 3;
		}

		override public function init():void
		{
			FP.world = new GBCColorsWorld();
		}
	}
}
