package states
{
	import flash.display.MovieClip;
	import Skeleton;
	import SkeleBullet;
	
	public class ThrowState implements IAgentState
	{
		var frame:Number = 0;
		var shootFrame:Number = 11;
		var killFrame:Number = 200;
		
		public function update(s:Skeleton):void
		{
			s.moveTowardPlayer();
			if (frame > shootFrame)
			{
				var bullet:Particle = new SkeleBullet();
				bullet.x = s.x;
				bullet.y = s.y;
				
				var shotAngle:Number = Math.atan2(s.target.y - bullet.y, s.target.x - bullet.x);
				bullet.xVel = Math.cos(shotAngle) * 30;
				bullet.yVel = Math.sin(shotAngle) * 30;
				
				s.bulletsFired.push(bullet);
				
				frame = 0;
			}
			for each (var b:Particle in s.bulletsFired)
			{
				s.parent.addChild(b);
				if (b.life < 1)
				{
					s.bulletsFired.removeAt(s.bulletsFired.indexOf(b));
					s.parent.removeChild(b);
				}
				b.update();
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