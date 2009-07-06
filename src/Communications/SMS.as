
package Communications
{
	import flash.utils.Dictionary;
	
	public class SMS
	{
		private var number:String
		private var carrier:String
		private var message:String
		private var cd:Dictionary
		
		public function SMS() {
			cd = new Dictionary()
			cd["ATT"]          	= "@txt.att.net"
			cd["Verizon"]      	= "@vtext.com"
			cd["Sprint"]       	= "@messaging.sprintpcs.com"
			cd["T-Mobile"]     	= "@tmomail.net"
			cd["Cingular"]     	= "@cingularme.com"
			cd["US Cellular"]  	= "@email.uscc.net"
			cd["SunCom"]       	= "@tms.suncom.com"
			cd["Powertel"]     	= "@ptel.net"
			cd["Alltel"]       	= "@message.alltel.com"
			cd["Metro PCS"]    	= "@MyMetroPcs.com"
			cd["Virgin Mobile"]	= "@vmobl.com"
			cd["Nextel"]       	= "@messaging.nextel.com"
		}
		
		public function send():void
		{
			var email_address:String = number + carrier
			var topic:String = "VoT"
			var message:String = message
			var email:Email = new Email()
			email.setRecipient(email_address)
			email.setTitle(topic)
			email.setMessage(message)
			email.send()
		}
		
		public function setNumber(number:String):void
		{
			this.number = number
		}
		
		public function setCarrier(carrier:String):void
		{
			this.carrier = cd[carrier]
		}
		
		public function setMessage(message:String):void
		{
			this.message = message
		}
	}
}