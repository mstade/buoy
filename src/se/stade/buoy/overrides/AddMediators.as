package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	
	[DefaultProperty("mediators")]
	public class AddMediators implements ContextOverride
	{
		public var mediators:Array;
		
		public function handle(event:ContextEvent):void
		{
            event.context.configuration.behaviours = event.context.configuration.behaviours.concat(mediators);
		}
	}
}