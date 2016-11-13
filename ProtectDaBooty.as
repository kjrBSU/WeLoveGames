package 
{	
	import Skeleton;
	import Map;
	import flash.filters.DisplacementMapFilter;
	
	import flash.display.Sprite;
	
	public class  ProtectDaBooty extends Sprite
	{
		public var skeleton:Skeleton = new Skeleton()
		public var map:Map = new Map();
 		
		public function ProtectDaBooty():void 
		{
			removeChildren()
			addChild(map);
			
			map.addChild(skeleton);
			skeleton.x = stage.stageWidth / 2
			skeleton.y = stage.stageHeight / 2
			skeleton.update()
		}
	}
	
}