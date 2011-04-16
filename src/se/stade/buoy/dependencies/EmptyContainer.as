package se.stade.buoy.dependencies
{
    import se.stade.colligo.iterators.Iterator;
    import se.stade.colligo.iterators.LinearIterator;
    
    public final class EmptyContainer implements DependencyContainer
    {
        public static const instance:EmptyContainer = new EmptyContainer;
        
        public function set parent(value:DependencyContainer):void
        {
        }
        
        public function getInstance(type:Class, name:String=""):*
        {
            return null;
        }
        
        public function setInstance(instance:*, name:String=""):Dependency
        {
            return null;
        }
        
        public function getDependency(type:Class, name:String=""):Dependency
        {
            return null;
        }
        
        public function setDependency(dependency:Dependency, ...dependencies):void
        {
        }
        
        public function getAllDependencies():Vector.<Dependency>
        {
            return new <Dependency>[];
        }
        
        public function canResolve(type:Class, name:String=""):Boolean
        {
            return false;
        }
        
        public function clone():DependencyContainer
        {
            return this;
        }
        
        public function iterate():Iterator
        {
            return LinearIterator.empty;
        }
    }
}