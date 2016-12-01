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
				//var bullet:SkeleBullet = s.createBullet();
				//s.bulletsAdded.push(bullet); 
				//s.fireBullet(bullet);
				frame = 0;
			}
			/*for each (var b:MovieClip in s.bulletsAdded)
			{
				var dx:Number = s.target.x - s.x;
				var dy:Number = s.target.y - s.y;
				var angle = Math.atan2(dy, dx);
				b.x += Math.cos(angle) * 10;
				b.y += Math.sin(angle) * 10; 
				s.drawBullets();
			}*/
			frame++;
			s.drawBullets();

		}
		
		public function enter(s:Skeleton):void 
		{
			
		}
		
		public function exit(s:Skeleton):void 
		{
			
		}
		
	}

}