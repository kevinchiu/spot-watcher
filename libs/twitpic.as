package com.cb.twitpic
{
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileFilter;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
   
    public class TwitPic
    {
        private var _file:File;
       
        public function TwitPic()
        {
            _file = new File();
            _file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
            browse();
        }
        private function browse():void {
            _file.addEventListener(Event.SELECT, fileSelected);
            _file.browse( new Array( new FileFilter( "Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png" ) ) );
        }
       
        private function fileSelected(event:Event):void {
            var urlRequest:URLRequest = new URLRequest("http://twitpic.com/api/upload");
           
            // The API requires the request be sent via POST
            urlRequest.method = URLRequestMethod.POST;
           
            // Enter a valid Twitter username / password combination
            var urlVars:URLVariables = new URLVariables();
            urlVars.username = TWITTER_USERNAME;
            urlVars.password = TWITTER_PASSWORD;
            urlRequest.data = urlVars;
           
            // The API requires the file be labeled as 'media'
            _file.upload(urlRequest, 'media');
        }
       
        private function uploadCompleteDataHandler(event:DataEvent):void
        {
            var resultXML:XML = new XML(event.text);
           
            // Trace the path to the resulting image tiny url (mediaurl)
            trace(resultXML.child("mediaurl")[0]);
        }
    }
}