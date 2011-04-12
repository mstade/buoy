package se.stade.buoy.dependencies
{
    import flash.errors.IllegalOperationError;

    public class Placeholder implements Dependency
    {
        private var _name:String
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        private var _types:Vector.<String>
        public function get types():Vector.<String>
        {
            return _types;
        }
        
        public function set types(value:Vector.<String>):void
        {
            _types = value;
        }
        
        public function getInstance(container:DependencyContainer):*
        {
            throw new IllegalOperationError("This is an abstract dependency that must be overwritten.");
        }
    }
}