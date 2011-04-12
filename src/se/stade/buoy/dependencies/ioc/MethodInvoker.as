package se.stade.buoy.dependencies.ioc
{
	import flash.utils.getDefinitionByName;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.daffodil.methods.Method;
	import se.stade.daffodil.methods.Parameter;

	public class MethodInvoker
	{
		public static const Instance:MethodInvoker = new MethodInvoker();
		
		public function apply(method:Method, dependencies:DependencyContainer):*
		{
			var parameters:Array = [];
			
			for each (var parameter:Parameter in method.parameters)
			{
				var definition:Class = getDefinitionByName(parameter.type) as Class;
				parameters.push(dependencies.getInstance(definition));
			}
			
			return method.invoke(parameters);
		}
	}
}