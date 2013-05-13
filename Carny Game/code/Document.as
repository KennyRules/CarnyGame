package code
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Sound;
	
	public class Document extends MovieClip
	{
		private var gameScreenManager:GameScreens;
		private var _overlay:Overlay;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		private var _soundLib:SoundLibrary;		// Sound Library
		private var introLoader:ForcibleLoader;
		private var introMC:MovieClip;
		
		public function Document()
		{
			initPlayer();
			initOverlay();
			initSound();
			
			//startGame();
			
			
			introLoader = new ForcibleLoader(new Loader());
			var url:URLRequest = new URLRequest("IntroAnimation.swf"); 
			introLoader.load(url);   
			introLoader.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIntroLoadComplete);
		}
		
		private function onIntroLoadComplete(e:Event):void 
		{
			introMC = e.currentTarget.content as MovieClip;
			addChild(introMC);
			introMC.addEventListener(Event.ENTER_FRAME, onIntroEnterFrame);
		}
		
		private function onIntroEnterFrame(e:Event):void 
		{
			// Apparently intro MC has more frames than swf so hard coding in total number of frames we care about.
			if (introMC.currentFrame == 167)
			{
				introMC.stop();
				startGame();
				introMC.removeEventListener(Event.ENTER_FRAME, onIntroEnterFrame);
			}
		}
		
		private function startGame():void
		{
			initOverworld();
			testTask();
		}
		
		private function initOverlay():void
		{
			_overlay = new Overlay(this);
			addChild(_overlay);
		}
		
		private function initPlayer():void
		{
			_player = new Player();
		}
		
		private function initOverworld():void
		{
			gameScreenManager = new GameScreens(this);
			addChild(gameScreenManager);
		}
		
		private function initSound():void
		{
			_soundLib = new SoundLibrary();
			_soundLib.loadSound("audio/9mmshot.mp3", "gunshot");
			//_soundLib.playSound("gunshot");
		}
		
		private function testTask():void
		{
			var testTask:Task = new Task();
			//testTask.loadXML("TestXML.xml");
		}
		
		public function clearScreen():void
		{
			if (introMC)
				removeChild(introMC);
		}
	}
}