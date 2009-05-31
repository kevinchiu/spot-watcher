package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.VideoDisplay;
	import mx.core.UIComponent;
	public class CanvasPainter
	{
		private var canvas:Canvas
		private var square:UIComponent
		private var debug:Sprite
		public function CanvasPainter(canvas:Canvas) {
			this.canvas = canvas
			this.debug = new VideoDisplay()
		}
		
		public function drawSquare(a:Point, b:Point):void {
			square = new UIComponent()
			square.graphics.beginFill(0x00FF00, 0.5)
			square.graphics.drawRect(a.x, a.y, b.x-a.x, b.y-a.y)
			square.graphics.endFill()
			canvas.addChild(square)
		}
		
		public function clear():void {
			canvas.removeAllChildren()
		}
		
		public function showDebugging(bd:BitmapData):void {
			debug.graphics.beginBitmapFill(bd)
			canvas.addChild(debug)
		}
	}
}