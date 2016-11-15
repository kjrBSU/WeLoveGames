package
{
	import Skeleton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	class Collision extends Sprite
	{
		public var chosenSprite:DisplayObjectContainer;
		private var _children:Array;
		
		public function Collision(spr:DisplayObjectContainer): void
		{
			chosenSprite = spr;
			_children = new Array();
			pushChildren();
		}
		
		private function pushChildren():void 
		{
			for (var i:int = 0;  i < chosenSprite.numChildren; i++)
			{
					_children.push(chosenSprite.getChildAt(i));
			}
		}
		
		public function get children():Array
		{
			return _children;
			
		}
		
	}
}