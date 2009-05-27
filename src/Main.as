// ActionScript file

import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.media.Camera;

import mx.core.UIComponent;public var cam:Camera
private var mouseController:MouseController
private var foreground:UIComponent
private var painter:CanvasPainter

public function init():void{
	initCamera()
	initCanvas()
	initMouse()
	initVision()
}

private function initCamera():void{
	cam = Camera.getCamera()
  	cam.setMode(640, 480, 30)
	camera_feed.attachCamera(Camera.getCamera())
}

private function initMouse():void{
	mouseController = new MouseController(painter) 
	canvas.addEventListener(MouseEvent.MOUSE_UP, mouseController.mouseUp)
	canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseController.mouseDown)
	canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseController.mouseMove)
}

private function initCanvas():void{
	painter = new CanvasPainter(canvas)
}
private function initVision():void{

}