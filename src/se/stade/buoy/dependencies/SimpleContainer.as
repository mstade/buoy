package se.stade.buoy.dependencies
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import se.stade.colligo.iterators.Iterator;
	import se.stade.colligo.iterators.LinearIterator;
	import se.stade.daffodil.define;
	import se.stade.stilts.string.formatting.format;
	
	[DefaultProperty("providers")]
	public class SimpleContainer extends EventDispatcher implements DependencyContainer
	{
		public function SimpleContainer(providers:Vector.<DependencyProvider> = null)
		{
		    this.providers = providers; 
		}
		
		protected var dependencyTable:Dictionary = new Dictionary();
		
		protected function getHashedKey(type:Class, name:String = ""):String
		{
			var qualifiedName:String = getQualifiedClassName(type);
			
			if (qualifiedName || name)
			{
				return format("{type}: '{name}'",
					{
						type: qualifiedName || "*",
						name: name || ""
					});
			}
			
			return "";
		}
        
        private var _parent:DependencyContainer;
        protected function get parent():DependencyContainer
        {
            return _parent || EmptyContainer.instance;
        }
        
        public function setParent(value:DependencyContainer):void
        {
            _parent = value;
        }
		
		public function set providers(value:Vector.<DependencyProvider>):void
		{
			for each (var provider:DependencyProvider in value)
			{
				setProvider(provider);
			}
		}
		
		public function get(type:Class, name:String = ""):*
		{
			var factory:DependencyProvider = getProvider(type, name);
			
			if (factory)
				return factory.getInstance(this);
		}
		
		public function set(instance:*, name:String = ""):DependencyProvider
		{
			var dependency:Instance = new Instance(instance);
			dependency.name = name;
			
			setProvider(dependency);
			return dependency;
		}
		
		public function contains(type:Class, name:String=""):Boolean
		{
			var key:String = getHashedKey(type, name);
			return key in dependencyTable || parent.contains(type, name);
		}
		
		public function getProvider(type:Class, name:String=""):DependencyProvider
		{
			var key:String = getHashedKey(type, name);
			return dependencyTable[key] || parent.getProvider(type, name);
		}
		
		public function setProvider(component:DependencyProvider, ... components):void
		{
			components = [component].concat(components);
			
			for each (var component:DependencyProvider in components)
			{
				if (component.name)
				{
					var key:String = getHashedKey(null, component.name);
					dependencyTable[key] = component;
				}
				
				for each (var type:String in component.types)
				{
					key = getHashedKey(define(type), component.name);
					dependencyTable[key] = component;
					
					key = getHashedKey(define(type));
					dependencyTable[key] = component;
				}
			}
		}
	}
}