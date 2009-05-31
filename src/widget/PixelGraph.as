package widget
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	public class PixelGraph
	{
		
		private var graphContainer:UIComponent
		
		private var graphBitmap:Bitmap
		private var graphData:BitmapData
		
		private var thresholdData:BitmapData
		private var thresholdBitmap:Bitmap
		
		private var height:Number
		private var width:int
		
		public function PixelGraph(width:int, height:int)
		{
			this.height = height
			this.width = width
			
			graphData = new BitmapData(width,height,true,0x00ffffff)
			graphBitmap = new Bitmap(graphData)
			
			thresholdData = new BitmapData(width,height,true,0x00ffffff)
			thresholdBitmap = new Bitmap(thresholdData)
			
			graphContainer = new UIComponent()
			graphContainer.addChild(graphBitmap)
			graphContainer.addChild(thresholdBitmap)
			
		}
		
		public function pushValue(val:Number):void {
			
			//shift 
			var m:Matrix = new Matrix()
			m.translate(-1.01,0)
			graphData.draw(graphData,m)

			var y:int = height * val
			graphData.fillRect(new Rectangle(width-2, 0, 1, height-2), 0x55ffffff)
			graphData.fillRect(new Rectangle(width-2, height-2-y, 1, y), 0x55000000)
		}
		
		public function setThreshHold(val:Number):void {
			//clear old line
			thresholdData.fillRect(new Rectangle(0,0,width-1,height-1), 0x00ffffff)
			
			//figure out new line height
			var y:int = height - val*height
			
			//draw new line
			thresholdData.fillRect(new Rectangle(0,y,width-1,1), 0xffff0000)
		}
		
		public function getGraphContainer():UIComponent {
			return graphContainer
		}
	}
}