package se.stade.buoy.dependencies
{
    [DefaultProperty("instances")]
    public class InstanceList implements DependencyProvider
    {
        private var dependencies:DependencyContainer;
        
        public function set instances(value:Array):void
        {
            dependencies = new DependencyCollection;
            
            _types = new <String>[];
            
            for each (var instance:* in value)
            {
                var provider:DependencyProvider = dependencies.set(instance);
                _types = _types.concat(provider.types);
            }
        }
        
        public function get name():String
        {
            return "";
        }
        
        private var _types:Vector.<String>;
        public function get types():Vector.<String>
        {
            return _types;
        }
        
        public function getInstance(type:Class, container:DependencyContainer):*
        {
            return dependencies.get(type);
        }
    }
}