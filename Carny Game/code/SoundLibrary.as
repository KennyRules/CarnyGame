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
	import flash.media.SoundChannel;
	
	
	public class SoundLibrary {

		private var sounds:Dictionary;
		private var BG_channel:SoundChannel;
		private var pausePosition:int;

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
			var sound:Sound = new Sound();		// Unqiue sound variable
			pausePosition = 0;
			
			sound.addEventListener(Event.COMPLETE, loadComplete(key));	// triggered on completed load
			sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);	// catch errors - #2032 is bad filepath
			sound.load(new URLRequest(url));		// begin to load the sound
			sounds[key] = sound;					// save whatever we have
		}
		
		// play a sound once
		public function playSound(key:String):void
		{
			var localSound:Sound = sounds[key] as Sound;
			localSound.play();
		}
		
		// handle background audio in the next two functions
		public function playBG_sound(key:String, loops:int)
		{
			var localSound:Sound = sounds[key] as Sound;
			BG_channel =  localSound.play(pausePosition, loops);
		}
		public function stopBG_sound()
		{
			pausePosition = BG_channel.position;
			BG_channel.stop();
		}
		
		// overwrite an old sound with a completed one
		function loadComplete(k:String):Function {
			return function(event:Event):void {
				sounds[k] = event.target;
			}
		}
		
		// error catch
		function onIOError(event:IOErrorEvent)
		{
			trace("Could not load sound: " + event.text);
		}

	}
	
}
