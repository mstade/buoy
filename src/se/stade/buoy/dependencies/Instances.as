package se.stade.buoy.dependencies
{
    import flash.utils.getDefinitionByName;

    [DefaultProperty("list")]
    public class Instances implements DependencyProvider
    {
        private var dependencies:DependencyContainer;
        
        public function set instanceList(value:Array):void
        {
            dependencies = new SimpleContainer;
            
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