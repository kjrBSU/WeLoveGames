package states 
{
	import Skeleton;
	public class ChaseState implements IAgentState
	{
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(s:Skeleton):void
		{
		
			if (s.distanceToObject() > s.chaseRadius) {
				s.setState(Skeleton.CONFUSED);
			}
			if (s.distanceToObject() < s.fleeRadius) {
				s.setState(Skeleton.FLEE);
			}
		}
		
		public function enter(s:Skeleton):void
		{
			
		}
		
		public function exit(s:Skeleton):void
		{
			
		}
		
	}

}