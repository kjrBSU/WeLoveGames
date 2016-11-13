package states 
{
	import Skeleton
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class FleeState implements IAgentState
	{
		
		public function FleeState() 
		{
			
		}
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(a:Skeleton):void
		{
			if (a.numCycles < 10) return;
			a.say("Fleeing!");
			a.speed = 2;
			a.faceMouse( -1);
			if(a.numCycles>80){
				if (a.distanceToMouse > a.fleeRadius) {
					a.setState(Skeleton.CONFUSED); // directing toward another state here
				}
			}
		}
		
		public function enter(a:Skeleton):void
		{
			a.say("Eek!");
			a.faceMouse(1);
			a.speed = 0;
		}
		
		public function exit(a:Skeleton):void
		{
			
		}
		
	}

}