package code 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameDialogBox extends Sprite 
	{
		private var _choices:Array;
		private var _textFields:Array;
		private var _textFormat:TextFormat = new TextFormat(new EdmondsansFont().fontName, 20, 0x000000, null, null, null, null, null, "center", null, null, null, 5); // Font, Size, color, leading are set.
		
		public function GameDialogBox(aChoiceArray:Array) 
		{
			_choices = aChoiceArray;
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
		}
		
		private function onStageAdd(e:Event):void
		{
			initTextField();
		}
		
		private function initTextField():void
		{
			_textFields = new Array();
			
			for (var i:int = 0; i < _choices.length; i++)
			{
				_textFields.push(new TextField());
				_textFields[i].selectable = false;
				_textFields[i].wordWrap = true;
				_textFields[i].multiline = true;
				_textFields[i].border = true;
				_textFields[i].background = true;
				addChild(_textFields[i]);
			
				_textFields[i].appendText(_choices[i].toString());
				_textFields[i].setTextFormat(_textFormat);
				
				_textFields[i].height = _textFields[i].textHeight + _textFormat.leading;
				_textFields[i].width = stage.stageWidth * .15;
				if (i > 0)
				{
					_textFields[i].y = _textFields[i - 1].y + _textFields[i - 1].height;
				}
				
				_textFields[i].addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			var anEvent:MessageEvent = new MessageEvent(MessageEvent.ON_DIALOG_SELECT);
			anEvent.dialogSelected = _textFields.indexOf(e.target);
			dispatchEvent(anEvent);
		}
	}
}