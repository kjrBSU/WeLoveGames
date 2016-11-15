package states
{
	import Skeleton;
	
	public class BumpState implements IAgentState
	{
		private var frames:Number = 0;
		private var maxFrames:Number = 10
		
		public function update(s:Skeleton):void
		{
			if (frames < maxFrames) 
			{
				s.move();
			}
			else if (frames >= maxFrames) {
				s.setState(Skeleton.WANDER);
			}
			frames++
		}
		
		public function enter(s:Skeleton):void
		{
			s.vx = -s.vx;
			s.vy = -s.vy;
			trace ("Bump!")
		}
		
		public function exit(s:Skeleton):void
		{
			s.vx = s.vx + (Math.random() - Math.random());
			s.vy = s.vy + (Math.random() - Math.random());
			trace("Exit Bump");
			s._isBump = false;
		}
	}
}