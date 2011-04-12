package se.stade.buoy.sequencing
{
	import flash.events.IEventDispatcher;
	
	import se.stade.buoy.Context;

	[Event(name="started",type="se.stade.buoy.sequencing.StepEvent")]
	[Event(name="progress",type="se.stade.buoy.sequencing.StepEvent")]
	[Event(name="finished",type="se.stade.buoy.sequencing.StepEvent")]
	
	public interface Step extends IEventDispatcher
	{
		function start(context:Context):void;
	}
}