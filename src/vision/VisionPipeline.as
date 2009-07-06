package Vision
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
		private var debugFrameCropped:BitmapData
		private var smallCanvas:Canvas
		private var smallBitmap:Bitmap
		private var smallContainingUIComponent:UIComponent
		private var thresh:Number
		
		private var previousFrame:BitmapData
		private var currentFrame:BitmapData
		private var nextFrame:BitmapData
		
		private var previousFrameCropped:BitmapData
		private var currentFrameCropped:BitmapData
		private var nextFrameCropped:BitmapData
		
		private var savedFrameCollage:BitmapData
		private var trigger:Function
		
		private	var scaleM:Matrix
		private var translateM:Matrix
		private var translateM2:Matrix
		
		public function VisionPipeline(vd:VideoDisplay)
		{
			this.cam = vd
			
			currentFrameCropped = new BitmapData(cam.width, cam.height, false, 0x000000)
			previousFrameCropped = currentFrameCropped.clone()
			nextFrameCropped = currentFrameCropped.clone()
			debugFrameCropped = currentFrameCropped.clone()
			
			currentFrame = new BitmapData(cam.width/3, cam.height/3, true, 0x000000)
			previousFrame = currentFrameCropped.clone()
			nextFrame = currentFrameCropped.clone()
			
			savedFrameCollage = new BitmapData(cam.width, cam.height/3, false, 0x000000)
		}
		
		public function setTrigger(f:Function):void {
			this.trigger = f
		}
		
		//DEBUG
		public function bindDebugOutput(canvas:Canvas):void {
			smallCanvas = canvas
			smallContainingUIComponent = new UIComponent()
			smallBitmap = new Bitmap(debugFrameCropped)
			smallContainingUIComponent.addChild(smallBitmap)
			smallCanvas.addChild(smallContainingUIComponent)
		}
		
		public function bindReleaseOutput(canvas:Canvas):void {
			smallCanvas = canvas
			smallContainingUIComponent = new UIComponent()
			smallBitmap = new Bitmap(savedFrameCollage)
			smallContainingUIComponent.addChild(smallBitmap)
			smallCanvas.addChild(smallContainingUIComponent)
			
			var scaleFactor:Number = (smallCanvas.width/3)/cam.width
			scaleM = new Matrix()
			scaleM.scale(scaleFactor,scaleFactor)
			
			translateM = new Matrix()
			translateM.translate(smallCanvas.width/3,0)
			
			translateM2 = new Matrix()
			translateM2.translate(smallCanvas.width/3*2,0)
			
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
			debugFrameCropped.draw(cam,new Matrix(),null,null,regionOfInterest, false)
		}

		public function stepPipeline():void {
			
			previousFrame = currentFrame.clone()
			currentFrame = nextFrame.clone()
			nextFrame.draw(cam, scaleM)
			
			previousFrameCropped = currentFrameCropped.clone()
			currentFrameCropped = nextFrameCropped.clone()
			nextFrameCropped.draw(cam,new Matrix(),null,null,regionOfInterest, false)
			
			debugFrameCropped.draw(Common.diff(previousFrameCropped, currentFrameCropped))
			
			if(regionOfInterest == null){
				setRegionOfInterest(new Rectangle(0,0,cam.height,cam.width))
			}
			
			var activity:Number = Common.countMovementPixels(debugFrameCropped)/(regionOfInterest.width * regionOfInterest.height)
			if(activity > thresh){
				savedFrameCollage.draw(previousFrame)
				savedFrameCollage.draw(currentFrame, translateM)
				savedFrameCollage.draw(nextFrame, translateM2)
				trigger(savedFrameCollage)
			}
			
			numOut(activity)
		}
	}
}