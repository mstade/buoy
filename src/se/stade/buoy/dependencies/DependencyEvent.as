package se.stade.buoy.dependencies
{
	import flash.events.Event;
	
	public class DependencyEvent extends Event
	{
		public static const UPDATED:String = "updatedDependency";
		
		public function DependencyEvent(dependency:Dependency)
		{
			super(UPDATED, false, false);
			
			_dependency = dependency;
		}
		
		private var _dependency:Dependency;
		public function get dependency():Dependency
		{
			return _dependency;
		}
		
		override public function clone():Event
		{
			return new DependencyEvent(dependency);
		}
	}
}