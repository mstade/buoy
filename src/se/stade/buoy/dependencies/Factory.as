package se.stade.buoy.dependencies
{
	import flash.utils.getDefinitionByName;
	
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.Type;
	import se.stade.daffodil.methods.Method;
	import se.stade.daffodil.methods.Parameter;
	import se.stade.daffodil.types.QualifiedType;
	
	public class Factory implements Dependency
	{
		public function Factory(type:Class = null, properties:Vector.<Set> = null, ... parameters)
		{
			this.type = type;
			this.properties = properties;
			this.parameters = parameters;
		}
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get types():Vector.<String>
		{
			return qualifiedType.extendedTypes;
		}
		
		private var qualifiedType:QualifiedType;
		public function set type(value:Class):void
		{
			qualifiedType = Reflect.types.on(value)[0];
		}
		
		private var _parameters:Array;
		public function set parameters(value:Array):void
		{
			_parameters = value;
		}
		
		private var _properties:Vector.<Set>;
		public function set properties(value:Vector.<Set>):void
		{
			_properties = value;
		}
		
		public function getInstance(dependencies:DependencyContainer):*
		{
			var constructor:Method = qualifiedType.constructor;
			var constructorParameters:Array = [];
			
			for (var i:int = 0; i < constructor.parameters.length; i++)
			{
				var parameter:Parameter = Parameter(constructor.parameters[i]);
				var injectParameter:Inject = (i < _parameters.length) ? _parameters[i] as Inject : Inject.inferred;
				
				if (injectParameter)
				{
					var type:Class = injectParameter.type || getDefinitionByName(parameter.type) as Class;
					constructorParameters.push(dependencies.getInstance(type));
				}
				else
					constructorParameters.push(_parameters[i]);
			}
			
			var instance:* = constructor.invoke(constructorParameters);
			var dependency:Instance = new Instance(instance, _properties);
			
			return dependency.getInstance(dependencies);
		}
	}
}