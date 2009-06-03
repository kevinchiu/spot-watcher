package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import vision.VisionPipeline;
	
	public class MouseController
	{
		private var painter:CanvasPainter
		private var anchorPointA:Point
		private var anchorPointB:Point
		private var down:Boolean
		private var squareDrawn:Boolean
		private var pipeline:VisionPipeline
		
		private var thresholdFunction:Function
		
		public function MouseController(painter:CanvasPainter) {
			this.painter = painter
			squareDrawn = false
			down = false
		}
		
		public function mouseDownCanvas(event:MouseEvent):void {
			
			anchorPointA = new Point(event.localX, event.localY)
			squareDrawn = false
			down = true
		}
		
		public function mouseDown(event:MouseEvent):void {
			down = true
		}
		
		public function mouseUp(event:MouseEvent):void {
			down = false
		}
		
		public function mouseMoveCanvas(event:MouseEvent):void {
			if(down){
				painter.clear()
				painter.drawSquare(anchorPointA, new Point(event.localX, event.localY))
			}
		}
		
		public function mouseUpCanvas(event:MouseEvent):void {
			
			down = false
			anchorPointB = new Point(event.localX, event.localY)
			if(anchorPointB.x != anchorPointA.x){
				squareDrawn = true
				pipeline.setRegionOfInterest(getRegionOfInterest())
			}
			painter.clear()
			painter.drawSquare(anchorPointA, anchorPointB)
			
		}
		
		public function adjustThreshold(event:MouseEvent):void {
			
			if(down || event.type == MouseEvent.CLICK)
				this.thresholdFunction(event.localY)
		}

		public function setPipeline(pipeline:VisionPipeline):void{
			this.pipeline = pipeline
		}
		
		public function setThresholdFunction(f:Function):void{
			this.thresholdFunction = f
		}
		
		
		public function getRegionOfInterest():Rectangle {
			if(squareDrawn){
				//normalize square (necessary?)
				var x1:int = anchorPointA.x
				var x2:int = anchorPointB.x
				var y1:int = anchorPointA.y
				var y2:int = anchorPointB.y
				var width:int = Math.abs(x1 - x2)
				var height:int = Math.abs(y1 - y2)
				var x3:int = x1 < x2 ? x1 : x2
				var y3:int = y1 < y2 ? y1 : y2
				
				return new Rectangle(x3,y3,width,height)
			}
			return new Rectangle()
		}
		
	}
}