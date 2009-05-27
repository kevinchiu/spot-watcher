package
{
	import flash.geom.Point
	
	import mx.containers.Canvas
	import mx.core.UIComponent
	
	public class CanvasPainter
	{
		private var canvas:Canvas
		private var square:UIComponent
		public function CanvasPainter(canvas:Canvas) {
			this.canvas = canvas
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
	}
}