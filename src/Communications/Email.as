package Communications
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Email
	{
		private var recipient:String
		private var title:String
		private var message:String
		
		public function Email()
		{
			
		}
		
		public function setRecipient(recipient:String):void
		{
			this.recipient = recipient
		}
		
		public function setTitle(title:String):void
		{
			this.title = title
		}
		
		public function setMessage(message:String):void
		{
			this.message = message
		}
		
		public function send():void {
			if(message.length == 0)
				message = " "
			
			var url:String = "http://distributedcameras2.appspot.com/email?" +
			"recipient=" + escape(recipient) +
			"&title=" + escape(title) + 
			"&message=" + escape(message)
			
			var url_request:URLRequest = new URLRequest(url)
			new URLLoader().load(url_request)
		}		
	}
}