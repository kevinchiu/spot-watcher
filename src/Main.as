// ActionScript file

import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.media.Camera;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Timer;

import mx.core.UIComponent;

import vision.VisionPipeline;

import widget.PixelGraph;

public var cam:Camera;
private var mouseController:MouseController;
private var foreground:UIComponent;
private var painter:CanvasPainter;

private var pipeline:VisionPipeline;

private var mt:Timer;
private var pGraph:PixelGraph

private var twitterVerified:Boolean

private var counter:Number


public function init():void {
	initCamera()
	initVision()
	initCanvas()
	initMouseController()
	initRelease()
	//initDebug()
	initGraph()
	initThreshold()
	initTrigger()
	initTimer()	
	
	counter = 0
}

private function initCamera():void {
	cam = Camera.getCamera()
  	cam.setMode(320, 240, 30)
	camera_feed.attachCamera(Camera.getCamera())
}

private function initVision():void {
	pipeline = new VisionPipeline(camera_feed)
	pipeline.setNumericalOutput(setMeterValue)
}

private function initCanvas():void {
	painter = new CanvasPainter(canvas)
}

private function initMouseController():void {
	mouseController = new MouseController(painter)
	canvas.addEventListener(MouseEvent.MOUSE_UP, mouseController.mouseUp)
	canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseController.mouseDown)
	canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseController.mouseMove)
	mouseController.setPipeline(pipeline)
}

private function initGraph():void {
	pGraph = new PixelGraph(graph.width, graph.height)
	graph.addEventListener(MouseEvent.MOUSE_DOWN, mouseController.mouseDownClean)
	graph.addEventListener(MouseEvent.MOUSE_UP, mouseController.mouseUpClean)
	graph.addEventListener(MouseEvent.MOUSE_MOVE, mouseController.adjustThreshold)
	graph.addEventListener(MouseEvent.CLICK, mouseController.adjustThreshold)
	graph.addChild(pGraph.getGraphContainer())
}

private function setMeterValue(value:Number):void {
	pGraph.pushValue(value)
}

private function drivePipeline(event:TimerEvent):void {
	if(mouseController.getRegionOfInterest().width > 0) {
		pipeline.stepPipeline()
	}
}
private function initThreshold():void {
	mouseController.setThresholdFunction(setThreshold)
}
private function setThreshold(num:Number):void{
	//turn local y into actual threshold
	var t:Number = (graph.height - num) / graph.height
	
	pipeline.setThreshold(t)
	pGraph.setThreshHold(t)
}

private function initTrigger():void{
	pipeline.setTrigger(trigger)
	twitterVerified = false
}

private function trigger(bd:BitmapData):void{
	counter++
	if(twitter_message.length > 0 && twitter_id.length > 0){
		var message:String = twitter_message.text + " count: " + counter
		var username:String = twitter_id.text
		var to_send:String = "@"+username+" "+message
		var url_string:String = "http://distributedcameras2.appspot.com/twitter?message="+escape(to_send)
		var url:URLRequest = new URLRequest(url_string)
		new URLLoader().load(url)
		trace("tweet sent: " + to_send)
	}
}

private function initTimer():void {
	// Motion sampler timer
	mt = new Timer(250)
	mt.addEventListener(TimerEvent.TIMER, drivePipeline)
	mt.start()
}

//debug
private function initDebug():void {
	pipeline.bindDebugOutput(debug_video)
}

private function initRelease():void {
	pipeline.bindReleaseOutput(debug_video)	

}