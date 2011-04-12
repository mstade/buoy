package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	
	[DefaultProperty("mediators")]
	public class SetMediators implements ContextOverride
	{
		public var mediators:Array;
		
		public function handle(event:ContextEvent):void
		{
            event.context.configuration.behaviours = mediators;
		}
	}
}