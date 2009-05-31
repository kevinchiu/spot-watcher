package vision
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.VideoDisplay;
	import mx.core.UIComponent;
	
	public class VisionPipeline
	{
		private var cam:VideoDisplay
		private var nodes:Array
		private var regionOfInterest:Rectangle
		private var numOut:Function
		private var previousFrame:BitmapData
		private var currentFrame:BitmapData
		private var debugFrame:BitmapData
		private var debugCanvas:Canvas
		private var debugBitmap:Bitmap
		private var debugUIComponent:UIComponent
		private var thresh:Number
		
		private var triggerFrames:BitmapData
		private var trigger:Function
		
		public function VisionPipeline(vd:VideoDisplay)
		{
			this.cam = vd
			currentFrame = new BitmapData(cam.width, cam.height, false, 0x000000)
			previousFrame = currentFrame.clone()
			debugFrame = currentFrame.clone()
			triggerFrames = new BitmapData(cam.width/2, cam.height, false, 0x000000)
			thresh = 1.0
		}
		
		public function setTrigger(f:Function):void {
			this.trigger = f
		}
		
		//DEBUG
		public function bindDebugOutput(canvas:Canvas):void {
			this.debugCanvas = canvas
			this.debugUIComponent = new UIComponent()
			this.debugBitmap = new Bitmap(debugFrame)
			this.debugUIComponent.addChild(debugBitmap)
			this.debugCanvas.addChild(debugUIComponent)
		}
		
		public function bindReleaseOutput(canvas:Canvas):void {
			this.debugCanvas = canvas
			this.debugUIComponent = new UIComponent()
			this.debugBitmap = new Bitmap(triggerFrames)
			this.debugUIComponent.addChild(debugBitmap)
			this.debugCanvas.addChild(debugUIComponent)
		}
		
		public function setRegionOfInterest(rec:Rectangle):void {
			regionOfInterest = rec
		}
		
		public function setThreshold(num:Number):void {
			thresh = num
		}
		
		public function setNumericalOutput(fun:Function):void {
			this.numOut = fun
		}
		
		public function showCapture():void {
			debugFrame.draw(cam,new Matrix(),null,null,regionOfInterest, false)
		}
		
			
		public function stepPipeline():void {
			currentFrame.draw(cam,new Matrix(),null,null,regionOfInterest, false)			
			debugFrame.draw(Common.diff(previousFrame, currentFrame))
			var numerator:int = Common.countMovementPixels(debugFrame)
			var denominator:int = regionOfInterest.width * regionOfInterest.height
			numOut(numerator / denominator)
			
			if(numerator/denominator > thresh){
				trace("triggered")
				var m:Matrix = new Matrix()
				m.scale(debugCanvas.width/cam.width,debugCanvas.width/cam.width)
				triggerFrames.draw(cam,m)
				m.translate(0,debugCanvas.height/2)
				triggerFrames.draw(cam,m)
				trigger(triggerFrames)
			}
				
			previousFrame = currentFrame.clone()
		}
	}
}