package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Enemy extends MovieClip
	{
		public var speed:Number = 15;
		public static const ENEMY_OUT_OF_BOUNDS:String = "enemy out of bounds";
		
		public function Enemy() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.ENTER_FRAME, loop);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		public function init(e:Event):void
		{
			this.x = stage.width * Math.random();
			this.y = 0 - this.height;
		}
		
		function removed(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function loop(e:Event):void
		{
			this.y += speed;
			this.rotation += 20;
			
			if(this.y > stage.stageHeight)
			{	
				dispatchEvent(new Event(ENEMY_OUT_OF_BOUNDS));
				this.removeEventListener(Event.ENTER_FRAME, loop);
			}
		}
	}
	
}
