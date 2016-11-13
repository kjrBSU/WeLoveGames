package states 
{
	import Skeleton;
	public class ChaseState implements IAgentState
	{
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(a:Skeleton):void
		{
			var dx:Number = a.stage.mouseX - a.x;
			var dy:Number = a.stage.mouseY - a.y;
			var rad:Number = Math.atan2(dy, dx);
			a.velocity.x = Math.cos(rad);
			a.velocity.y = Math.sin(rad);
			if (a.numCycles < 40) return;
			a.say("Chasing!");
			a.speed = 2;
			if (a.distanceToMouse > a.chaseRadius) {
				a.setState(Skeleton.CONFUSED);
			}
			if (a.distanceToMouse < a.fleeRadius) {
				a.setState(Skeleton.FLEE);
			}
		}
		
		public function enter(a:Skeleton):void
		{
			var dx:Number = a.stage.mouseX - a.x;
			var dy:Number = a.stage.mouseY - a.y;
			var rad:Number = Math.atan2(dy, dx);
			a.velocity.x = Math.cos(rad);
			a.velocity.y = Math.sin(rad);
			a.say("Oh wow! Something to chase!");
			a.speed = 0;
		}
		
		public function exit(a:Skeleton):void
		{
			
		}
		
	}

}