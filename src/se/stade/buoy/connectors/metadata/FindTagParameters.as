package se.stade.buoy.connectors.metadata
{
	[ExcludeClass]
	
	public final class FindTagParameters
	{
		[DefaultProperty]
		public var target:String;
		
		public var live:Boolean;
		public var limit:int = int.MAX_VALUE;
	}
}