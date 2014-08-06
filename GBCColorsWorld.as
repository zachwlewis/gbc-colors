package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;

	public class GBCColorsWorld extends World
	{
		[Embed(source="assets/a.png")] private const A:Class;
		[Embed(source="assets/b.png")] private const B:Class;
		[Embed(source="assets/c.png")] private const C:Class;
		[Embed(source="assets/d.png")] private const D:Class;
		[Embed(source="assets/e.png")] private const E:Class;
		[Embed(source="assets/f.png")] private const F:Class;
		[Embed(source="assets/g.png")] private const G:Class;
		[Embed(source="assets/h.png")] private const H:Class;

		private var _image:Entity;
		private var _images:Vector.<Class> = new <Class>[A, B, C, D, E, F, G, H];
		private var _idxImage:uint = 0;
		private var _idxPalette:uint = 0;

		/** Key colors to swap. */
		private const _cb:Vector.<uint> = new <uint>[0xffffffff, 0xffa8a8a8, 0xff545454, 0xff000000];
		/** Color palettes to use. */
		private const _cp:Vector.<Vector.<uint>> = new <Vector.<uint>> [
			new <uint>[0xffdce397, 0xffb5be49, 0xff5d7a3b, 0xff2a4431],	// Default GameBoy Green
			new <uint>[0xffffffff, 0xfff6b06d, 0xff7b3914, 0xff000000],	// Palette $12
			new <uint>[0xffffffff, 0xfff1908a, 0xff8b443f, 0xff000000],	// Palette $B0
			new <uint>[0xfffce6c7, 0xffc89e88, 0xff816a2f, 0xff563311],	// Palette $79
			new <uint>[0xffffffff, 0xff72a09a, 0xff0048fa, 0xff000000],	// Palette $B8
			new <uint>[0xffffffff, 0xff8893dc, 0xff50578a, 0xff000000],	// Palette $AD
			new <uint>[0xffffffff, 0xffa5a5a5, 0xff525252, 0xff000000],	// Palette $16
			new <uint>[0xfffffbaa, 0xfff29d99, 0xff8e9dfb, 0xff000000],	// Palette $17
			new <uint>[0xffffffff, 0xfffff734, 0xffec462f, 0xff000000],	// Palette $07
			new <uint>[0xffffffff, 0xfffff835, 0xff774b12, 0xff000000],	// Palette $BA
			new <uint>[0xffffffff, 0xff89f118, 0xffee5c2f, 0xff000000],	// Palette $05
			new <uint>[0xffffffff, 0xff9ff239, 0xff116bc3, 0xff000000],	// Palette $7C
			// Can't use true black here, or it will be overwritten.
			// This can be fixed by changing the color keys.
			new <uint>[0xff010101, 0xff348084, 0xfffdda33, 0xffffffff],	// Palette $13
		];
		/** Screen values for recoloring. */
		private const _scrRect:Rectangle = new Rectangle(0, 0, 160, 144);
		private const _scrPoint:Point = new Point();
		private const _scrMask:uint = 0xffffffff;

		public function GBCColorsWorld()
		{
			super();
		}

		override public function begin():void
		{
			_image = addGraphic(new Stamp(_images[0]));
			super.begin();
		}

		override public function update():void
		{
			// Image switching.
			if (Input.pressed(Key.SPACE))
			{
				_idxImage++;
				if (_idxImage >= _images.length)
				{
					_idxImage = 0;
				}

				remove(_image);
				_image = addGraphic(new Stamp(_images[_idxImage]));
			}

			// Palette switching.
			if (Input.pressed(Key.RIGHT))
			{
				_idxPalette = _idxPalette == _cp.length - 1 ? 0 : _idxPalette + 1;
			}

			if (Input.pressed(Key.LEFT))
			{
				_idxPalette = _idxPalette == 0 ? _cp.length - 1 : _idxPalette - 1;
			}

			super.update();
		}

		override public function render():void
		{
			super.render();

			// After render, iterate through key colors and natively switch colors.
			for (var i:uint = 0; i < 4; i++)
			{
				FP.buffer.threshold(FP.buffer, _scrRect, _scrPoint, "==", _cb[i], _cp[_idxPalette][i], _scrMask, true);
			}
		}
	}
}
