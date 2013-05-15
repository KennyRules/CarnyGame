package code 
{
	import code.Town;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class GameScreens extends MovieClip 
	{
		private var theDoc:Document;
		public function get Doc():Document { return theDoc; }
		
		private var worldMap:WorldMap;
		private var carnival:Carnival;
		
		private var screens:Array;
		
		private var _player:Player;
		public function get player():Player { return _player; }
		
		private var _gameTextBox:GameTextBox;
		private var _gameDialogBox:GameDialogBox;
		
		private var _overworldXML:XMLList;
		private var _currentXML:XMLList;
		private var _currentSection:String = "Room";
		private var _currentIndex:int = 0;

		private var _pathRoom:int = 1;
		private var _task:Task;
		
		
		public function GameScreens(aDoc:Document, aTask:Task) 
		{
			theDoc = aDoc;
			_task = aTask;
			_player = theDoc.player;
			screens = new Array();
			
			screens.push(worldMap);
			screens.push(carnival);
			
			changeLocation("Main Menu");
			btnStartGame.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent)
		{
			// Instance name of button.
			switch (e.currentTarget.name)
			{
				case "btnStartGame":
					//theDoc.clearScreen();
					changeLocation("World Map");
					_task.loadXML("TUTORIAL 1");
					_task.addEventListener(MessageEvent.ON_SECTION_COMPLETE, onTutorialComplete);
					break;
			}
			if (e.currentTarget is Town)
			{
				changeLocation("Overhead Carnival");
			}
		}
		
		private function onTextLoadComplete(e:Event):void 
		{
			_overworldXML = new XMLList(e.target.data);
		}
		
		private function removeAllScreens():void
		{
			for (var i:int = 0; i < screens.length; ++i)
				if (screens[i])
					removeChild(screens[i]);
		}
		
		private function onTutorialComplete(e:MessageEvent):void
		{
			_task.removeEventListener(MessageEvent.ON_SECTION_COMPLETE, onTutorialComplete);
			worldMap.addEventListeners();
		}
		
		public function changeLocation(newLocation:String):void
		{
			this.gotoAndStop(newLocation);
			removeAllScreens();
			
			switch (this.currentLabel)
			{
				case "World Map":
					if (!worldMap)
						worldMap = new WorldMap(this);
					
					addChild(worldMap);
					break;
					
				case "Overhead Carnival":
					carnival = new Carnival(worldMap.currentTown, _task);
						
					addChild(carnival);
			}
			
			//_currentSection = newLocation;
			//loadXmlSection();
		}

		// Loads a new section of the XML to display.
		private function loadXmlSection():void
		{
			_currentXML = null;
			_currentIndex = 0;
			for each (var xmlPiece:XML in _overworldXML.child("Section"))
			{
				if (xmlPiece.@id == _currentSection)
				{
					switch (_currentSection)
					{
						case "Room":
							if (_pathRoom.toString() == xmlPiece.@path)
								_currentXML = XMLList(xmlPiece);
							break;
					}
				}
			}
			
			if (_currentXML != null)
			{
				_gameTextBox = new GameTextBox(_currentXML.Text[_currentIndex]);
				addChild(_gameTextBox);
				_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
			}
		}
		
		private function onMessageComplete(e:MessageEvent):void
		{
			// Checks null attribute - (_overworldXML.child(_currentChild).Text[_currentIndex].@index).toString() == ""
			// .name() gets the node name.
			
			if (_currentXML == null)
			{
				clearMessageBox();
				return;
			}
				
			_currentIndex++;
			// If there is a node to evaluate within bounds.
			if (_currentIndex < _currentXML.children().length())
			{
				// Make sure it is a Text node.
				var nodeName:String = _currentXML.child(_currentIndex).name();
				if (nodeName == "Text")
				{
					_gameTextBox.loadMessage(_currentXML.children()[_currentIndex]);
				}
				// If it is a Dialog node, make this node the new current node to generate messages from.
				else if (nodeName == "Dialog")
				{
					_currentXML = _currentXML.child(_currentIndex).children();
					addDialogBox();
					_gameTextBox.removeEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
				}
				else if (nodeName == "Section")
				{
					clearMessageBox();
				}
				return;
			}
			// If we are out of bounds, see if there is more text in a parent node.
			else
			{
				if (_currentXML.parent() != null)
				{
					// We need to find the node whose parent isn't a Dialog node.
					while (_currentXML.parent().name() == "Dialog")
					{
						_currentXML = XMLList(_currentXML.parent());
					}
					
					// Now, fina the position of this node in the parent of the current node. This is where we continue the tree.
					for (var i:int = 0; i < _currentXML.parent().children().length(); i++ )
					{
						if (_currentXML.parent().child(i) == _currentXML)
						{
							_currentIndex = i;
							_currentXML = XMLList(_currentXML.parent()); // Set the current node to the parent. This is where we left off from.
							// Add and dispatch the events to display new text.
							_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
							onMessageComplete(new MessageEvent(MessageEvent.ON_MESSAGE_COMPLETE));
							return;
						}
					}
				}
				clearMessageBox();
			}
		}
		
		private function clearMessageBox():void
		{
			_gameTextBox.removeEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
			removeChild(_gameTextBox);
		}
		
		private function addDialogBox():void
		{
			var choices:Array = new Array();
			for (var i:int = 0; i < _currentXML.length(); i++)
			{
				choices.push(_currentXML[i].@choice);
			}
			
			_gameDialogBox = new GameDialogBox(choices);
			addChild(_gameDialogBox);
			_gameDialogBox.x = stage.stageWidth - _gameDialogBox.width;
			_gameDialogBox.y = stage.stageHeight / 2 - _gameDialogBox.height / 2;
			_gameDialogBox.addEventListener(MessageEvent.ON_DIALOG_SELECT, onDialogSelect);
		}
		
		// Remove the dialog box, continue reading text from the xml tree from the choice selected.
		private function onDialogSelect(e:MessageEvent):void
		{
			_gameDialogBox.removeEventListener(MessageEvent.ON_DIALOG_SELECT, onDialogSelect);
			removeChild(_gameDialogBox);
			
			if (_currentXML[e.dialogSelected].@flag != null)
			{
				switch ((_currentXML[e.dialogSelected].@flag).toString())
				{
					
				}
			}
			_currentIndex = 0;
			_currentXML = XMLList(_currentXML[e.dialogSelected]);
			_gameTextBox.loadMessage(_currentXML.Text[_currentIndex]);
			_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
		}
	}
}