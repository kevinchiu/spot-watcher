package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MouseController
	{
		private var painter:CanvasPainter
		private var anchorPointA:Point
		private var anchorPointB:Point
		private var down:Boolean
		private var squareDrawn:Boolean
		
		public function MouseController(painter:CanvasPainter) {
			this.painter = painter
		}
		
		public function mouseDown(event:MouseEvent):void {
			down = true
			squareDrawn = false
			anchorPointA = new Point(event.stageX, event.stageY)
		}
		
		public function mouseMove(event:MouseEvent):void {
			if(down){
				painter.clear()
				painter.drawSquare(anchorPointA, new Point(event.stageX, event.stageY))
			}
		}
		
		public function mouseUp(event:MouseEvent):void {
			down = false
			squareDrawn = true
		}
		
		public function getRegionOfInterest():Rectangle {
			return new Rectangle(anchorPointA.x, anchorPointA.y, anchorPointB.x - anchorPointA.x, anchorPointB.y - anchorPointA.y)
		}
	}
}