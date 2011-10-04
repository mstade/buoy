package se.stade.buoy.dependencies
{
    public final class EmptyContainer implements DependencyContainer
    {
        public static const instance:EmptyContainer = new EmptyContainer;
        
        public function setParent(value:DependencyContainer):void
        {
        }
        
        public function get(type:Class, name:String=""):*
        {
            return null;
        }
        
        public function set(instance:*, name:String=""):DependencyProvider
        {
            return null;
        }
        
        public function getProvider(type:Class, name:String=""):DependencyProvider
        {
            return null;
        }
        
        public function setProvider(dependency:DependencyProvider, ...dependencies):void
        {
        }
        
        public function contains(type:Class, name:String=""):Boolean
        {
            return false;
        }
    }
}
