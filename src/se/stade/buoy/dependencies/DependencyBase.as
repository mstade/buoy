package se.stade.buoy.dependencies
{
	import se.stade.stilts.errors.AbstractTypeError;

	public class DependencyBase
	{
		public function DependencyBase(self:DependencyBase)
		{
			if (this != self)
				throw new AbstractTypeError();
		}
		
		private var _injectProperties:Array;
		
		[ArrayElementType("String")]
		public function get injectProperties():Array
		{
			return _injectProperties;
		}
		
		public function set injectProperties(value:Array):void
		{
			_injectProperties = value;
		}
	}
}