package se.stade.buoy.connectors.metadata
{
	[ExcludeClass]
	
	public final class HandleEventTagParameters
	{
		[DefaultProperty]
		public var target:String;
		
		public var type:String;
		public var priority:int;
		public var useCapture:Boolean;
		public var useWeakReference:Boolean;
	}
}