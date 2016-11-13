package states 
{
	import Skeleton;
	
	public class WanderState implements IAgentState
	{
		
		public function update(a:Skeleton):void
		{
			a.move();
		}
		
		public function enter(a:Skeleton):void
		{
			a.vx = Math.random() - Math.random();
			a.vy = Math.random() - Math.random();
		}
		public function exit(a:Skeleton):void
		{
			
		}
	}
}