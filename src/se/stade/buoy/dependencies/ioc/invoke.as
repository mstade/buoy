package se.stade.buoy.dependencies.ioc
{
    import se.stade.buoy.dependencies.DependencyContainer;
    import se.stade.daffodil.define;
    import se.stade.daffodil.methods.Method;
    import se.stade.daffodil.methods.Parameter;

	public function invoke(method:Method, dependencies:DependencyContainer):*
	{
		var parameters:Array = [];
		
		for each (var parameter:Parameter in method.parameters)
		{
			var definition:Class = define(parameter.type);
			parameters.push(dependencies.get(definition));
		}
		
		return method.invoke(parameters);
	}
}