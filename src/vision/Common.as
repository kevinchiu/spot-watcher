package Vision
{
	import flash.display.BitmapData;
		
		public class Common
		{
		public static function diff(p:BitmapData, n:BitmapData):BitmapData {
			var temp:BitmapData = new BitmapData(p.width, p.height)
			temp.draw(p,null,null,null,null,false)
			temp.draw(n,null,null,"difference",null,false)
			temp.threshold(temp,temp.rect,temp.rect.topLeft,">",0xFF111111,0xFF00FF00,0x00FFFFFF,false);
			
			return temp
		}
		
		public static function countMovementPixels(img:BitmapData):int {
			return img.histogram()[1][255]
		}
		
	}
}