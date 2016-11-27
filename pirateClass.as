package {

	import flash.display.MovieClip;
	import flash.events.Event;


	public class pirateClass extends MovieClip {
		public var speed: Number = 10;
		public var status: String = "Alive";

		public function movePirate(): void {

			this.x += zFriction(this.x, stage.stageWidth / 2, 1);
			this.y += zFriction(this.y, stage.stageHeight / 2, 1);
		}
		public function zFriction(startPosition: Number, destination: Number, coeff: Number): Number {
			return (destination - startPosition) / coeff;
		}
	}


}