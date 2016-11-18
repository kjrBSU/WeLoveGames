package states 
{
	import Skeleton;
	import SkeleBullet;
	
	public class ThrowState implements IAgentState
	{
		
		public function update(s:Skeleton):void
		{
			s.moveTowardPlayer();
			
			trace("Throw!");
		}
		
		public function enter(s:Skeleton):void 
		{
			
		}
		
		public function exit(s:Skeleton):void 
		{
			
		}
		
	}

}