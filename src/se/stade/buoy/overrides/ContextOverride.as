package se.stade.buoy.overrides
{
	import se.stade.buoy.ContextEvent;

	public interface ContextOverride
	{
		function handle(event:ContextEvent):void;
	}
}