package  
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Buddy extends MovieClip 
	{
		public var speed:Number = 10;
		public static const BUDDY_OUT_OF_BOUNDS:String = "buddy out of bounds";
		
		public function Buddy() 
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
			this.rotation -= 10;
			
			if(this.y > stage.stageHeight)
			{	
				dispatchEvent(new Event(BUDDY_OUT_OF_BOUNDS));
				this.removeEventListener(Event.ENTER_FRAME, loop);
			}
		}
	}
	
}
