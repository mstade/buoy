package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.ContextEvent;
	
	[DefaultProperty("overrides")]
	public class SpecificConfiguration implements ContextOverride
	{
		public var type:Class;
		
		public var overrides:Vector.<ContextOverride>;
		
		public function handle(event:ContextEvent):void
		{
			if (event.context.configuration is type)
			{
				for each (var override:ContextOverride in overrides)
				{
					override.handle(event);
				}
			}
		}
	}
}