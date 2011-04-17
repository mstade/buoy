package se.stade.buoy.dependencies
{
	import flash.utils.Dictionary;
	
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.define;
	import se.stade.daffodil.properties.Property;
	import se.stade.daffodil.types.QualifiedType;

	[DefaultProperty("value")]
	public class Instance implements DependencyProvider
	{
		public function Instance(value:Object = null, properties:Vector.<Set> = null)
		{
            if (value)
                this.value = value;
            
            if (properties)
			    this.properties = properties;
		}
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value || "";
		}
		
		private var qualifiedType:QualifiedType;
		
		public function get types():Vector.<String>
		{
			return new <String>[qualifiedType.name]
							   .concat(qualifiedType.extendedTypes)
							   .concat(qualifiedType.implementedInterfaces);
		}
		
		private var instance:*;
		public function set value(value:*):void
		{
			instance = value;
			qualifiedType = Reflect.first.type.on(value);
		}
		
		private var injections:Dictionary = new Dictionary;
		public function set properties(list:Vector.<Set>):void
		{
			injections = new Dictionary;
			
			for each (var parameter:Set in list)
			{
				injections[parameter.property] = parameter;
			}
		}
		
		public function getInstance(dependencies:DependencyContainer):*
		{
			if (!instance)
				return null;
			
			var subjects:Array = Reflect.all.properties
                                        .withWriteAccess
                                        .on(instance);
			
			for each (var property:Property in subjects)
			{
				if (property.name in injections)
				{
					var parameter:Set = injections[property.name];
					var inject:Inject = parameter.value ? parameter.value as Inject : Inject.inferred;
						
					instance[property.name] = inject ?
                        dependencies.get(inject.type || define(property.type), inject.id)
                        : parameter.value;
				}
			}
			
			return instance;
		}
	}
}