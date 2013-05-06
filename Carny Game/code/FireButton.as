package code {
	
	import flash.display.SimpleButton;
	
	public class FireButton extends SimpleButton {
		
		private var id:Number;
		public function get getID():Number {return id;}
		
		public function FireButton(num:Number) {
			// constructor code
			id = num;
		}
	}
	
}
