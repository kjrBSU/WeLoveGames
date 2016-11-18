package states 
{
	import flash.display.MovieClip;
	import Skeleton;
	import SkeleBullet;
	
	public class ThrowState implements IAgentState
	{
		var frame:Number = 0;
		var shootFrame:Number = 11;
		
		public function update(s:Skeleton):void
		{
			s.moveTowardPlayer();
			if (frame > shootFrame) 
			{
				var bullet:MovieClip = s.createBullet();
				s.bulletsAdded.push(bullet);
				frame = 0;
			}
			for each (var b:MovieClip in s.bulletsAdded)
			{
				
				b.x += 0
				b.y += -10;
				s.drawBullets();
			}
			frame++;
		}
		
		public function enter(s:Skeleton):void 
		{
			
		}
		
		public function exit(s:Skeleton):void 
		{
			
		}
		
	}

}