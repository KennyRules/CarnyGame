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
		private var tasks:Task;
		private var _overlay:Overlay;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		private var _soundLib:SoundLibrary;		// Sound Library
		public function get soundLibrary():SoundLibrary { return _soundLib; }
		
		private var introLoader:ForcibleLoader;
		private var introMC:MovieClip;
		
		public function Document()
		{
			initPlayer();
			initOverlay();
			initSound();
			
			//startGame();
			
			tasks = new Task("Tasks.xml");
			introLoader = new ForcibleLoader(new Loader());
			var url:URLRequest = new URLRequest("IntroAnimation.swf"); 
			
			// Comment out these two lines, and uncomment the third line to just go straight to start screen.
			//introLoader.load(url);   
			//introLoader.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIntroLoadComplete);
			startGame();
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
			gameScreenManager = new GameScreens(this, tasks);
			addChild(gameScreenManager);
		}
		
		private function initSound():void
		{
			_soundLib = new SoundLibrary();
			_soundLib.loadSound("audio/rope_pull.mp3", "intro");
			_soundLib.playSound("intro");
			_soundLib.loadSound("audio/click.mp3", "click");
			_soundLib.loadSound("audio/carnival_ambient.mp3", "carnival");
		}
		
		private function testTask():void
		{
			addChild(tasks);
		}
		
		public function clearScreen():void
		{
			if (introMC)
				removeChild(introMC);
		}
	}
}