package code
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Document extends MovieClip
	{
		private var gameScreenManager:GameScreens;
		private var _overlay:Overlay;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		public function Document()
		{
			initPlayer();
			initOverlay();
			initOverworld();
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
	}
}