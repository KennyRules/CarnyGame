package code
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HireScreen extends Sprite 
	{
		private var _carnival:Carnival;
		private var _exitButton:Sprite;
		
		public function HireScreen(aCarnival:Carnival) 
		{
			_carnival = aCarnival;
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
		}
		
		private function onStageAdd(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			this.graphics.beginFill(0x999999, 1.0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			_exitButton = new Sprite();
			_exitButton.x = stage.stageWidth - 50;
			_exitButton.graphics.beginFill(0xFF0000, 1.0);
			_exitButton.graphics.drawRect(0, 0, 50, 50);
			addChild(_exitButton);
		}
		
		
		private function onExitClick(e:MouseEvent):void
		{
			_carnival.hideHireScreen();
		}
		
		public function showScreen():void
		{
			_exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			this.visible = true;
		}
		
		public function hideScreen():void
		{
			_exitButton.removeEventListener(MouseEvent.CLICK, onExitClick);
			this.visible = false;
		}
	}
}
