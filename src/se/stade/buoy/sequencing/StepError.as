package se.stade.buoy.sequencing
{
	public final class StepError extends Error
	{
		public function StepError(message:String = "", id:int = 0, rootCause:Error = null)
		{
			super(message, id);
			_rootCause = rootCause;
		}
		
		private var _rootCause:Error;
		public function get rootCause():Error
		{
			return _rootCause;
		}
	}
}