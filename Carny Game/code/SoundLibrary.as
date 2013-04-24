/*
 *	This class will hold all of our sound effects and 
 *	music. There will be a dictionary with names of sounds
 *	associated with them.
 *
 *	Use a URLrequest to load in sounds.
 *
*/



package code {
	
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;;
	import flash.events.IOErrorEvent
	import flash.utils.Dictionary;
	
	
	public class SoundLibrary {

		private var sounds:Dictionary;

		public function SoundLibrary() {
			// constructor code
			sounds = new Dictionary();
		}
		
		// use this to load in a sound
		// urlrquest is the location of the file
		// key will be for adding it to the dictionary
		public function loadSound(url:String, key:String):void
		{
			// init sound instance
			var sound:Sound = new Sound();
			
			sound.addEventListener(Event.COMPLETE, onLoadComplete)
			sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			sound.load(new URLRequest(url));
		}
		
		function onLoadComplete(event:Event):void
		{
			
		}
		function onIOError(event:IOErrorEvent)
		{
			trace("Could not load sound: " + event.text);
		}

	}
	
}
