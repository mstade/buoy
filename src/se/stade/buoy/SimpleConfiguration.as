package se.stade.buoy
{
	import flash.events.EventDispatcher;
	
	import se.stade.buoy.connectors.metadata.DefaultTags;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.DependencyCollection;
	
    [DefaultProperty("dependencies")]
	public class SimpleConfiguration extends EventDispatcher implements Configuration
	{
        private var _dependencyContainer:DependencyContainer;
        public function get dependencies():DependencyContainer
        {
            _dependencyContainer ||= new DependencyCollection;
            return _dependencyContainer;
        }
        
        public function set dependencies(value:DependencyContainer):void
        {
            _dependencyContainer = value;
        }
        
		private var _connectors:Vector.<Connector> = Vector.<Connector>([new DefaultTags]);
		public function get connectors():Vector.<Connector>
		{
            _connectors ||= new Vector.<Connector>;
			return _connectors;
		}
		
		public function set connectors(value:Vector.<Connector>):void
		{
			_connectors = value;
		}
		
		private var _behaviors:Array;
		public function get behaviors():Array
		{
            _behaviors ||= [];
			return _behaviors;
		}
		
		public function set behaviors(value:Array):void
		{
			_behaviors = value;
		}
	}
}