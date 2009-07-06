package Communications
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Tweet
	{
		private var message:String
		
		public function Tweet()
		{
			
		}
		
		public function setMessage(message:String):void
		{
			this.message = message
		}
		
		public function send():void {
			if(message.length == 0)
				message = " "
			
			var url:String = "http://distributedcameras2.appspot.com/tweet?" +
			"message=" + message
			
			var url_request:URLRequest = new URLRequest(url)
			new URLLoader().load(url_request)
		}		
	}
}