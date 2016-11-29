package 
{	
	import Skeleton;
	import Collision;
	import Map;
	import Player;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class  ProtectDaBooty extends Sprite
	{
		public var skeleton:Skeleton = new Skeleton()
		public var player:Player = new Player();
		public var map:Map = new Map();
		//public var mapCollide:Collision = new Collision(map);
 		
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
			skeleton.target = player;
			
			map.addChild(player);
			player.x = map.width / 2 + 100;
			player.y = map.height / 2 - 500;
			
			
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		private function gameLoop(e:Event):void 
		{
			skeleBump();
			skeleton.update();
			camera(skeleton);
		}
		
		public function camera(char:Sprite):void 
		{
			root.scrollRect = new Rectangle(char.x - stage.stageWidth / 2, char.y - stage.stageHeight / 2, 
											stage.stageWidth, stage.stageHeight);
		}
			
		public function skeleBump():void
		{
			for (var i:int = 0; i < map.numChildren; i++)
			{
			if (String(map.getChildAt(i)) == "[object MapBound]")
				//{
					skeleton.didHitObject(map.getChildAt(i));
				//}
			}
		}
	}
	
}