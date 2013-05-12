package code
{
	import flash.display.MovieClip;
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
		
		public function Document()
		{
			initPlayer();
			initOverlay();
			initOverworld();
			initSound();
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
			_soundLib.playSound("gunshot");
		}
		
		private function testTask():void
		{
			var testTask:Task = new Task();
			//testTask.loadXML("TestXML.xml");
		}
	}
}