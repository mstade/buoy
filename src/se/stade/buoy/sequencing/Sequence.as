package se.stade.buoy.sequencing
{
	import flash.events.EventDispatcher;
	
	import se.stade.buoy.Context;
	
	[Event(name="started",type="se.stade.buoy.sequencing.StepEvent")]
	[Event(name="progress",type="se.stade.buoy.sequencing.StepEvent")]
	[Event(name="finished",type="se.stade.buoy.sequencing.StepEvent")]

	public class Sequence extends EventDispatcher implements Step
	{
		public function Sequence(steps:Vector.<Step> = null)
		{
			super(this);
			this.steps = steps || new Vector.<Step>;
		}
		
		private var steps:Vector.<Step>;
		private var currentIndex:int;
		private var isRunning:Boolean;
		
		public function start(context:Context):void
		{
			if (isRunning)
				return;
			
			if (context)
			{
				currentIndex = 0;
				
				if (steps.length > 0)
				{
					dispatchEvent(new StepEvent(StepEvent.Started, 0, steps.length));
					execute(steps[currentIndex++], context);
				}
				else
					dispatchEvent(new StepEvent(StepEvent.Finished, 0, 0));
			}
			else
				throw new StepError("Context must not be null");
		}
		
		protected function execute(step:Step, context:Context):void
		{
			step.addEventListener(StepEvent.Progress, reportProgress);
			
			step.addEventListener(StepEvent.Finished, function(event:StepEvent):void
			{
				step.removeEventListener(StepEvent.Progress, reportProgress);
				step.removeEventListener(StepEvent.Finished, arguments.callee);
				
				dispatchEvent(new StepEvent(StepEvent.Progress, currentIndex, steps.length));
				
				if (currentIndex == steps.length)
					dispatchEvent(new StepEvent(StepEvent.Finished, currentIndex, steps.length));
				else
					execute(steps[currentIndex++], context);
			});
			
			step.start(context);
		}
		
		protected function reportProgress(event:StepEvent):void
		{
			if (event.progress)
				dispatchEvent(new StepEvent(StepEvent.Progress, currentIndex + event.progress, steps.length));
		}
	}
}