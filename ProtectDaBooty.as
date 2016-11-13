package 
{	
	import Skeleton;
	import Map;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class  ProtectDaBooty extends Sprite
	{
		public var skeleton:Skeleton = new Skeleton()
		public var map:Map = new Map();
 		
		public function ProtectDaBooty():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			removeChildren()
			
			addChild(map);
			
			map.addChild(skeleton);
			skeleton.x = map.width / 2;
			skeleton.y = map.height / 2;
			
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		private function gameLoop(e:Event):void 
		{
			skeleton.update();
			camera(skeleton);
		}
		
		public function camera(char:Sprite):void 
		{
			root.scrollRect = new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.stageHeight / 2, 
											stage.stageWidth, stage.stageHeight);
		}
	}
	
}