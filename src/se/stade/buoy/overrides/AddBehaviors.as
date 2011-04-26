package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	
	[DefaultProperty("behaviors")]
	public class AddBehaviors implements ContextOverride
	{
		public var behaviors:Array;
		
		public function handle(event:ContextEvent):void
		{
            event.context.configuration.behaviors = event.context.configuration.behaviors.concat(behaviors);
		}
	}
}