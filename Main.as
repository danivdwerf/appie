package  
{
	import flash.display.Sprite;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.media.SoundChannel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import Enemy;
	import SoundButton;
	import StopButton;
	
	public class Main extends MovieClip
	{
		private var sprite:Sprite = new Sprite();
		private var spawnTimer:Timer = new Timer(750,0);
		private var restartTimer:Timer = new Timer(500,0);
		private var buddyTimer:Timer = new Timer(2000,0);
		public var enemies:Array = [];
		public var buddies:Array = [];
		private var channels:Array = [];
		private var score:Number = 0;
		
		public function Main() 
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			drawSprite();
			addListeners();
			
			var sound:SoundButton = new SoundButton(0xEEEEFF, " Play Music", channels);
			sound.loadSound("http://20002.hosts.ma-cloud.nl/bewijzenmap/periode2/media/TipTap.mp3");
			sound.x = 10;
			sound.y = 10;
			sound.changePan(0);
			sound.changeVolume(1);
			addChild(sound);
			
			var error:SoundButton = new SoundButton(0xff6023, "teehee", channels);
			error.x = 150;
			error.y = 10;
			addChild(error);
			
			var stop:StopButton = new StopButton(channels);
			stop.x = 450;
			stop.y = 30;
			addChild(stop);
		}
		
		private function addListeners()
		{
			sprite.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			sprite.addEventListener(TouchEvent.TOUCH_END, touchEnd);
			spawnTimer.addEventListener(TimerEvent.TIMER, onSpawnTimer);
			restartTimer.addEventListener(TimerEvent.TIMER, reset);
			buddyTimer.addEventListener(TimerEvent.TIMER, addBuddy);
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		function drawSprite():void
		{
			sprite.graphics.beginFill(0x574569);
			sprite.x = 240;
			sprite.y = 500;
			sprite.graphics.moveTo(-50,-50);
			sprite.graphics.lineTo(50,-50);
			sprite.graphics.lineTo(50,50);
			sprite.graphics.lineTo(-50,50);
			sprite.graphics.lineTo(-50,-50);
			sprite.graphics.endFill();
			addChild(sprite);
		}
		
		function reset(te:TimerEvent):void
		{
			//Enemies verwijderen
			for(var i:int = enemies.length-1; i >= 0;i--)
			{
				removeChild(enemies[i]);
			}
			enemies.splice(0, enemies.length);
			
			for(var j:int = buddies.length-1; j >= 0; j--)
			{
				removeChild(buddies[j]);
			}
			buddies.splice(0, buddies.length);
			
			score = 0;
			buddyTimer.stop();
			buddyTimer.reset();
			spawnTimer.stop();
			spawnTimer.reset();
			
			
			//Player /  sprite resetten
			addChild(sprite);
			sprite.rotation = 0;
			sprite.x = 240;
			sprite.y = 500;
			
			//listeners activeren
			restartTimer.stop();
			restartTimer.reset();
			restartTimer.removeEventListener(TimerEvent.TIMER, reset);
			addListeners();
		}
		
		function touchBegin(te:TouchEvent):void
		{
			//sprite roteert als je aanraakt
			sprite.rotation = 45;
			//start de timer voor de enemies te spawnen
			spawnTimer.start();
			buddyTimer.start();
			
			//maakt een listener om naar de vinger te volgen
			sprite.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		}

		function touchMove(te:TouchEvent):void
		{
			//zorgt dat de sprite je vinger volgt
			sprite.x = te.stageX;
			sprite.y = te.stageY;
		}

		function touchEnd(te:TouchEvent):void
		{
			//draait de sprite terug als je loslaat
			sprite.rotation = 0;
			//haalt de listener weg als je loslaat
			sprite.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		}
		
		function addBuddy(te:TimerEvent):void
		{
			buddies.push(new Buddy());
			addChild(buddies[buddies.length-1]);
			buddies[buddies.length-1].addEventListener(Buddy.BUDDY_OUT_OF_BOUNDS, deleteBuddy);
			
		}

		function onSpawnTimer(te:TimerEvent):void
		{
			//stopt een nieuwe enemy in de array
			enemies.push(new Enemy());
			//voegt de enemies toe aan stage
			addChild(enemies[enemies.length -1]);
			//hangt een listener aan de enemies om te checken of hij buiten het scherm gaat
			enemies[enemies.length -1].addEventListener(Enemy.ENEMY_OUT_OF_BOUNDS, deleteEnemy);
		}
		
		function deleteBuddy(e:Event):void
		{
			removeBuddy(e.target as Buddy)
		}
		
		function deleteEnemy(e:Event):void
		{
			//called when enemy goes out of screen
			
			//remove enemy from screen
			removeEnemy(e.target as Enemy)
			score++;
		}

		function removeBuddy(buddy:Buddy):void
		{
			removeChild(buddy);
			buddies.splice(buddies.indexOf(buddy),1)
		}
		
		function removeEnemy(enemy:Enemy):void
		{
			removeChild(enemy);
			enemies.splice(enemies.indexOf(enemy),1);
		}
		
		function loop(e:Event):void
		{
			theScore.text = new String(score);
			for (var i:int =0; i < enemies.length; i++)
			{
				//Check if player hits enemy
				var toRemove:Boolean = false;
				if (sprite.hitTestObject(enemies[i]))
				{
					//remove enemy from screen
					removeEnemy(enemies[i]);
					toRemove = true;
				}
			}
			
			for(var j:int=0; j<buddies.length; j++)
			{
				if(sprite.hitTestObject(buddies[j]))
				{
					removeBuddy(buddies[j]);
					score +=2;
				}
			}
			
			if (toRemove)
			{
				removeChild(sprite);
				removeListeners();
				restartTimer.start();
			}
		}
		
		private function removeListeners():void
		{
			spawnTimer.removeEventListener(TimerEvent.TIMER, onSpawnTimer);
			buddyTimer.removeEventListener(TimerEvent.TIMER, addBuddy);
			sprite.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			sprite.removeEventListener(TouchEvent.TOUCH_END, touchEnd);
			removeEventListener(Event.ENTER_FRAME, loop);
		}
	}
}








