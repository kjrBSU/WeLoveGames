package 
{
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	
	import ThomasMain
	
	public class StartDoc extends MovieClip
	{
		
		private var startSound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		public function StartDoc()
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			var start:StartScreen = new StartScreen();
			
			addChild(start);
			
			start.blackButton.addEventListener(MouseEvent.CLICK, startGameHandler);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			
			createGame();
		}
		
		private function createGame():void
		{
			var game:ThomasMain = new ThomasMain();
			
			addChild(game);
		}
	}
}