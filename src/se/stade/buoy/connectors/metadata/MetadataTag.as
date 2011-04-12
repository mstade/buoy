package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.Connector;
	
	public interface MetadataTag extends Connector
	{
		function get tag():String;
		function set tag(value:String):void;
	}
}