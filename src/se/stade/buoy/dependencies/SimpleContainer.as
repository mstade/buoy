package se.stade.buoy.dependencies
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import se.stade.colligo.iterators.Iterator;
	import se.stade.colligo.iterators.LinearIterator;
	import se.stade.stilts.string.formatting.format;
	
	[Event(name="updatedDependency", type="se.stade.buoy.dependencies.DependencyEvent")]

	[DefaultProperty("dependencies")]
	public class SimpleContainer extends EventDispatcher implements DependencyContainer
	{
		public function SimpleContainer(dependencies:Vector.<Dependency> = null)
		{
            if (dependencies)
			    this.dependencies = dependencies; 
		}
		
		protected var dependencyTable:Dictionary = new Dictionary();
		
		protected function getHashedKey(type:String, name:String = ""):String
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
        
        private var _parent:DependencyContainer
        public function get parent():DependencyContainer
        {
            return _parent || EmptyContainer.instance;
        }
        
        public function set parent(value:DependencyContainer):void
        {
            _parent = value;
        }
		
		public function set dependencies(value:Vector.<Dependency>):void
		{
			for each (var dependency:Dependency in value)
			{
				setDependency(dependency);
			}
		}
		
		public function getInstance(type:Class, name:String = ""):*
		{
			var factory:Dependency = getDependency(type, name);
			
			if (factory)
				return factory.getInstance(this);
		}
		
		public function setInstance(instance:*, name:String = ""):Dependency
		{
			var dependency:Instance = new Instance(instance);
			dependency.name = name;
			
			setDependency(dependency);
			return dependency;
		}
		
		public function canResolve(type:Class, name:String=""):Boolean
		{
			var key:String = getHashedKey(getQualifiedClassName(type), name);
			return key in dependencyTable || parent.canResolve(type, name);
		}
		
		public function getDependency(type:Class, name:String=""):Dependency
		{
			var key:String = getHashedKey(getQualifiedClassName(type), name);
			return dependencyTable[key] || parent.getDependency(type, name);
		}
		
		public function setDependency(component:Dependency, ... components):void
		{
			components = [component].concat(components);
			
			for each (var component:Dependency in components)
			{
				if (component.name)
				{
					var key:String = getHashedKey(null, component.name);
					dependencyTable[key] = component;
				}
				
				for each (var type:String in component.types)
				{
					key = getHashedKey(type, component.name);
					dependencyTable[key] = component;
					
					key = getHashedKey(type);
					dependencyTable[key] = component;
				}
				
				dispatchEvent(new DependencyEvent(component));
			}
		}
		
		public function getAllDependencies():Vector.<Dependency>
		{
			var listContents:Dictionary = new Dictionary();
			var list:Vector.<Dependency> = new <Dependency>[];
			
			for each (var dependency:Dependency in dependencyTable)
			{
				if (dependency in listContents)
					continue;
				
				list.push(dependency);
			}
			
			return list;
		}
		
		public function clone():DependencyContainer
		{
			return new SimpleContainer(getAllDependencies());
		}
		
		public function iterate():Iterator
		{
			return new LinearIterator(getAllDependencies());
		}
	}
}