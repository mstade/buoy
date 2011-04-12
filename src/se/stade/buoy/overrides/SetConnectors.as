package se.stade.buoy.overrides
{
	import se.stade.buoy.Configuration;
	import se.stade.buoy.Connector;
	import se.stade.buoy.ContextEvent;
	
	[DefaultProperty("connectors")]
	public class SetConnectors implements ContextOverride
	{
		public var connectors:Vector.<Connector>;
		
		public function handle(event:ContextEvent):void
		{
            event.context.configuration.connectors = connectors;
		}
	}
}