// ActionScript file

import Communications.*;

import Vision.VisionPipeline;

import Widget.PixelGraph;

import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.media.Camera;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.utils.ByteArray;
import flash.utils.Timer;

import mx.core.UIComponent;
import mx.graphics.codec.JPEGEncoder;

public var cam:Camera;
private var mouseController:MouseController;
private var foreground:UIComponent;
private var painter:CanvasPainter;

private var pipeline:VisionPipeline;

private var mt:Timer;
private var tt:Timer;

private var pGraph:PixelGraph

private var twitterVerified:Boolean

private var counter:Number

private var snd:Sound
private var twitter_cooldown:Boolean


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
	initSound()
	initTabs()
	counter = 0
	twitter_cooldown = true
}

private function initTabs():void {
}

private function initSound():void {
	snd = new Sound(new URLRequest("http://distributedcameras2.appspot.com/static/pluck.mp3"));
}

private function playSound():void {
	snd.play();
}

private function initCamera():void {
	cam = Camera.getCamera()
  	cam.setMode(640, 480, 30)
	camera_feed.attachCamera(Camera.getCamera())
}

private function initVision():void {
	pipeline = new VisionPipeline(camera_feed)
	pipeline.setNumericalOutput(setMeterValue)
}

private function initCanvas():void {
	painter = new CanvasPainter(canvas)
	var midpoint1:Point = new Point(cam.width/2-50, cam.height/2-50)
	var midpoint2:Point = new Point(cam.width/2+50, cam.height/2+50)
	painter.drawSquare(midpoint1, midpoint2)
	pipeline.setRegionOfInterest(new Rectangle(midpoint1.x, midpoint1.y, midpoint2.x-midpoint1.x, midpoint2.y-midpoint1.y))
}

private function initMouseController():void {
	mouseController = new MouseController(painter)
	canvas.addEventListener(MouseEvent.MOUSE_UP, mouseController.mouseUpCanvas)
	canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseController.mouseDownCanvas)
	canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseController.mouseMoveCanvas)
	mouseController.setPipeline(pipeline)
}

private function initGraph():void {
	pGraph = new PixelGraph(graph.width, graph.height)
	graph.addEventListener(MouseEvent.MOUSE_DOWN, mouseController.mouseDown)
	graph.addEventListener(MouseEvent.MOUSE_UP, mouseController.mouseUp)
	graph.addEventListener(MouseEvent.MOUSE_MOVE, mouseController.adjustThreshold)
	graph.addEventListener(MouseEvent.CLICK, mouseController.adjustThreshold)
	graph.addChild(pGraph.getGraphContainer())
}

private function setMeterValue(value:Number):void {
	pGraph.pushValue(value)
}

private function drivePipeline(event:TimerEvent):void {
	pipeline.stepPipeline()
}

private function initThreshold():void {
	mouseController.setThresholdFunction(setThresholdLocalCoords)
	setThresholdNormalized(0.1)
}


private function setThresholdLocalCoords(num:Number):void{
	//turn local y into actual threshold
	var t:Number = (graph.height - num) / graph.height
	setThresholdNormalized(t)
}

private function setThresholdNormalized(num:Number):void{
	pipeline.setThreshold(num)
	pGraph.setThreshHold(num)
}

private function initTrigger():void{
	pipeline.setTrigger(trigger)
	twitterVerified = false
}

private function alert_sound():void {
	trace("sound")
	if(enable_sound_ping.selected)
	{
		trace("playing sound")
		playSound()
	}
}

private function alert_sms():void {
	trace("sms")
	if(phone_number.text.length == 10){
		trace("sending sms")
		var message:String = sms_message.text + " " + counter
		var number:String = phone_number.text
		var carrier:String = carrier_combobox.text
		var limit:int = int(number_of_messages.text)
		var send:Boolean = false
		
		if(limit > 0){
			send = true
			number_of_messages.text = (limit - 1).toString()
		}
		if(unlimited_sms.selected){
			send = true
		}
		if(send){
			var sms:SMS = new SMS()
			sms.setMessage(message)
			sms.setCarrier(carrier)
			sms.setNumber(number)
			sms.send()
		}
	}
}

private function alert_mail():void {
	trace("mail")
	if(email_address.text.indexOf("@") != -1){
		trace("sending mail")
		var message2:String = email_message.text
		var address:String = email_address.text
		/*
		if(send_images.selected)
		{
			var img_url:String = postImage()
			message2 += "\n" + img_url
		}
		*/
		var email:Email = new Email()
		email.setRecipient(address)
		email.setTitle("Vision on Tap")
		email.setMessage(message2)
		email.send()
	}
}

private function alert_twitter():void {
	if(twitter_cooldown == false) {
		return
	}
	twitter_cooldown = false
	trace("twitter")
	if(twitter_id.length != 0){
		trace("sending mail")
		var tweet_msg:String = "@" + twitter_id.text + " " + twitter_message.text + " count: " + counter
		tweet_msg = escape(tweet_msg)
		var tweet:Tweet = new Tweet()
		tweet.setMessage(tweet_msg)
		tweet.send()
	}
}

private function trigger(bd:BitmapData):void{
	counter++
	try{
		alert_sound()
	} catch (e:Error){
		trace(e.message)
	}
	
	try{
		alert_sms()
	} catch (e:Error){
		trace(e.message)
	}

	try{
		alert_mail()
	} catch (e:Error){
		trace(e.message)
	}

	try{
		alert_twitter()
	} catch (e:Error){
		trace(e.message)
	}
}

private function postImage():String {
	var jpgEncoder:JPEGEncoder = new JPEGEncoder(85)
	var bd:BitmapData = new BitmapData(cam.width, cam.height)
	bd.draw(camera_feed)
	var jpgStream:ByteArray = jpgEncoder.encode(bd)
	var header:URLRequestHeader = new URLRequestHeader("Content-type","image/jpeg")
	return "testing"
	
	/*
	if(twitter_message.length > 0 && twitter_id.length > 0){
		if(twitter_checkbox.selected == false){
			new URLLoader().load(url_request)
			return
		} else if(twitter_checkbox.selected = true){
			
			var jpgEncoder:JPEGEncoder = new JPEGEncoder(85)
			var jpgStream:ByteArray = jpgEncoder.encode(bd)
						
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream")
			url_request.requestHeaders.push(header)
			url_request.method = URLRequestMethod.POST
			url_request.data = jpgStream
			var url_loader:URLLoader = new URLLoader()
			url_loader.load(url_request)
		}
	}*/
}

private function initTimer():void {
	// Motion sampler timer
	mt = new Timer(250)
	mt.addEventListener(TimerEvent.TIMER, drivePipeline)
	mt.start()
	
	tt = new Timer(10000)
	tt.addEventListener(TimerEvent.TIMER, twitterCooldown)
	tt.start()
}

private function twitterCooldown(event:TimerEvent):void {
	twitter_cooldown = true
}
//debug
private function initDebug():void {
	pipeline.bindDebugOutput(small_video)
}

private function initRelease():void {
	pipeline.bindReleaseOutput(small_video)	

}