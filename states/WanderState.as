package states 
{
	import Skeleton;
	public class WanderState implements IAgentState
	{
		
		public function update(a:Skeleton):void
		{
			/*a.say("Wandering...");
			a.velocity.x += Math.random() * 0.2 - 0.1;
			a.velocity.y += Math.random() * 0.2 - 0.1;
			if (a.numCycles > 120) {
				a.setState(Skeleton.IDLE);
			}
			if (!a.canSeeMouse) return;
			if (a.distanceToMouse < a.fleeRadius) {
				a.setState(Skeleton.FLEE);
			}else if (a.distanceToMouse < a.chaseRadius) {
				a.setState(Skeleton.CHASE);
			}*/
		}
		
		public function enter(a:Skeleton):void
		{
			//a.speed = 1;
		}
		
		public function exit(a:Skeleton):void
		{
			
		}
	}
}