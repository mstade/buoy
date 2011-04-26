package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.ioc.invoke;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;

	public class DeactivateTag extends MetadataTagBase implements Connector
	{
		public function DeactivateTag(tag:String = "Deactivate")
		{
			super(tag, this);
		}
		
		public function connect(behaviors:Array):void
		{
		}
		
		public function release(behaviors:Array):void
		{
			var deactivationMethods:Array = Reflect.all.methods.withMetadata(tag).on(behaviors);
			
			for each (var method:Method in deactivationMethods)
			{
				invoke(method, dependencies);
			}
		}
	}
}