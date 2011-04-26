package se.stade.buoy
{
	import se.stade.buoy.connectors.metadata.DefaultTags;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.EmptyContainer;
	import se.stade.buoy.dependencies.SimpleContainer;
	
	public class SimpleConfiguration implements Configuration
	{
        public function SimpleConfiguration()
        {
            dependencies = new SimpleContainer;
            connectors = Vector.<Connector>([new DefaultTags]);
        }
        
		private var _dependencyContainer:DependencyContainer;
		public function get dependencies():DependencyContainer
		{
			return _dependencyContainer || EmptyContainer.instance;
		}
		
		public function set dependencies(value:DependencyContainer):void
		{
            _dependencyContainer = value;
		}
		
		private var _connectors:Vector.<Connector>;
		public function get connectors():Vector.<Connector>
		{
			return _connectors;
		}
		
		public function set connectors(value:Vector.<Connector>):void
		{
			_connectors = value;
		}
		
		private var _behaviors:Array;
		public function get behaviors():Array
		{
			return _behaviors;
		}
		
		public function set behaviors(value:Array):void
		{
			_behaviors = value;
		}
	}
}