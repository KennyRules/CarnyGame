package code 
{
	import code.graphics.GameButton;
	import code.graphics.RoomButton;
	import code.graphics.StoreButton;
	import code.graphics.TownButton;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author Drew Diamantoukos
	 */
	public class Overworld extends MovieClip 
	{
		private var _doc:Document;
		private var _gameTextBox:GameTextBox;
		private var _gameDialogBox:GameDialogBox;
		
		private var _gameBtn:GameButton;
		private var _roomBtn:RoomButton;
		private var _townBtn:TownButton;
		private var _storeBtn:StoreButton;
		
		private var _overworldXML:XMLList;
		private var _currentXML:XMLList;
		private var _currentSection:String = "Room";
		private var _currentIndex:int = 0;

		private var _pathRoom:int = 1;
		private var _pathTown:int = 1;
		private var _pathStore:int = 1;
		
		private var _isAllowedToRoom:Boolean = true;
		private var _isEricEnabled:Boolean = false;
		
		private var _itemXML:XMLList;
		private var _itemArray:Array = new Array();
		
		public function Overworld(aDoc:Document) 
		{
			_doc = aDoc;
			var textUrlLoader:URLLoader = new URLLoader(new URLRequest("OverworldText.xml"));
			textUrlLoader.addEventListener(Event.COMPLETE, onTextLoadComplete);
			
			initNavButtons();
		}
		
		private function initNavButtons():void
		{
			_roomBtn = new RoomButton();
			_roomBtn.alpha = 0;
			_roomBtn.y = 25;
			addChildAt(_roomBtn, this.numChildren);
			
			_storeBtn = new StoreButton();
			_storeBtn.alpha = 0;
			_storeBtn.y = 25;
			_storeBtn.x = 700;
			addChildAt(_storeBtn, this.numChildren);
			
			_townBtn = new TownButton();
			_townBtn.alpha = 0;
			_townBtn.y = 25;
			_townBtn.x = 550;
			addChildAt(_townBtn, this.numChildren);
			
			_gameBtn = new GameButton();
			_gameBtn.alpha = 0;
			_gameBtn.y = 25;
			_gameBtn.x = 125;
			addChildAt(_gameBtn, this.numChildren);
		}
		
		private function onTextLoadComplete(e:Event):void 
		{
			_overworldXML = new XMLList(e.target.data);
			changeLocation("Room");
			_isAllowedToRoom = false;
		}
		
		private function onItemLoadComplete(e:Event):void
		{
			_itemXML = new XMLList(e.target.data);
		}
		
		
		private function changeLocation(newLocation:String):void
		{
			this.gotoAndStop(newLocation);
			
			switch (this.currentLabel)
			{
				
			}
			_currentSection = newLocation;
			loadXmlSection();
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
							{
								_currentXML = XMLList(xmlPiece);
							}
							break;
						case "Town":
							if (_pathTown.toString() == xmlPiece.@path)
							{
								_currentXML = XMLList(xmlPiece);
							}
							break;
						case "Store":
							trace(_pathStore);
							if (_pathStore.toString() == xmlPiece.@path)
							{
								if (_overworldXML.child("Section").(@id == _currentSection).(@path == _pathStore.toString()).length() >= 2)
								{
									if (_isEricEnabled == true)
									{
										_currentXML = XMLList(_overworldXML.child("Section").(@id == _currentSection)[0]);
									}
									else
									{
										_currentXML = XMLList(_overworldXML.child("Section").(@id == _currentSection)[1]);
									}
								}
								else
								{
									_currentXML = XMLList(xmlPiece);
								}
							}
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
					case "Eric":
						if (e.dialogSelected == 0)
							_isEricEnabled = true;
						else
							_isEricEnabled = false;
						break;
					default:
						trace("Undefined Flag");
						break;
				}
			}
			_currentIndex = 0;
			_currentXML = XMLList(_currentXML[e.dialogSelected]);
			_gameTextBox.loadMessage(_currentXML.Text[_currentIndex]);
			_gameTextBox.addEventListener(MessageEvent.ON_MESSAGE_COMPLETE, onMessageComplete);
		}
	}
}