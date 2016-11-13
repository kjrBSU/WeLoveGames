package states 
{
	import Skeleton;
	public class ConfusionState implements IAgentState
	{
		public function ConfusionState() 
		{
			
		}
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(a:Skeleton):void
		{
			if (++a.numCycles % 10 == 0) {
				a.randomDirection();
				if (a.canSeeMouse && a.distanceToMouse < a.chaseRadius) { // transitioning to other states
					if(a.previousState==Skeleton.FLEE) a.setState(Skeleton.FLEE);
					if(a.previousState==Skeleton.CHASE) a.setState(Skeleton.CHASE);
				}
			}
			if (a.numCycles > 60) a.setState(Skeleton.IDLE); // setting cuttoff point for confuse state
		}
		
		public function enter(a:Skeleton):void
		{
			a.say("???");
			a.speed = 0;
		}
		
		public function exit(a:Skeleton):void
		{
			
		}
		
	}

}