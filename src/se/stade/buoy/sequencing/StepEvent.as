package se.stade.buoy.sequencing
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class StepEvent extends Event
	{
		public static const Started:String = "started";
		public static const Progress:String = "progress";
		public static const Finished:String = "finished";
        
        public static function start(dispatcher:IEventDispatcher, totalSteps:int = 1):Boolean
        {
            return dispatcher.dispatchEvent(new StepEvent(Started, 0, totalSteps));
        }
        
        public static function progress(dispatcher:IEventDispatcher, finishedSteps:int, totalSteps:int):Boolean
        {
            return dispatcher.dispatchEvent(new StepEvent(Progress, finishedSteps, totalSteps));
        }
        
        public static function finished(dispatcher:IEventDispatcher, finishedSteps:int):Boolean
        {
            return dispatcher.dispatchEvent(new StepEvent(Finished, finishedSteps, finishedSteps));
        }
		
		public function StepEvent(type:String, finishedSteps:Number, totalSteps:int)
		{
			super(type, false, false);
			
			_finishedSteps = finishedSteps;
			_totalSteps = totalSteps;
		}
		
		private var _finishedSteps:Number;
		public function get finishedSteps():Number
		{
			return _finishedSteps;
		}
		
		private var _totalSteps:int;
		public function get totalSteps():int
		{
			return _totalSteps;
		}
		
		public function get progress():Number
		{
			return finishedSteps / totalSteps;
		}
		
		public override function clone():Event
		{
			return new StepEvent(type, finishedSteps, totalSteps);
		}
	}
}