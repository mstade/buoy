package se.stade.buoy.dependencies
{
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.define;
	import se.stade.daffodil.methods.Method;
	import se.stade.daffodil.types.QualifiedType;
	
	public class Factory implements DependencyProvider
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
            return new <String>[qualifiedType.qualifiedName]
                                             .concat(qualifiedType.extendedTypes)
                                             .concat(qualifiedType.implementedInterfaces);
		}
		
		private var qualifiedType:QualifiedType;
		public function set type(value:Class):void
		{
			qualifiedType = Reflect.first.type.on(value);
		}
		
		private var parameterList:Array;
		public function set parameters(value:Array):void
		{
            parameterList = value;
		}
		
		private var propertyList:Vector.<Set>;
		public function set properties(value:Vector.<Set>):void
		{
            propertyList = value;
		}
        
		public function getInstance(dependencies:DependencyContainer):*
		{
			var constructor:Method = qualifiedType.constructor;
			var constructorParameters:Array = [];
			
			for (var i:int = 0; i < constructor.parameters.length; i++)
			{
				var inject:Inject = parameterList[i] ? parameterList[i] as Inject : Inject.inferred;
                
                if (inject)
                {
                    constructorParameters.push(
                        dependencies.get(
                            inject.type || define(constructor.parameters[i].type),
                            inject.id
                        )
                    );
                }
                else
                {
                    constructorParameters.push(parameterList[i]);
                }
			}
			
			var instance:* = constructor.invoke(constructorParameters);
			var dependency:Instance = new Instance(instance, propertyList);
			
			return dependency.getInstance(dependencies);
		}
	}
}