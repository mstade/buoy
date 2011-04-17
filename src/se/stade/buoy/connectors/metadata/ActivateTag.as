package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.ioc.invoke;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;

	public class ActivateTag extends MetadataTagBase implements Connector
	{
		public function ActivateTag(tag:String = "Activate")
		{
			super(tag, this);
		}
		
		public function connect(mediators:Array):void
		{
			var activationMethods:Array = Reflect.all.methods.withMetadata(tag).on(mediators);
			
			for each (var method:Method in activationMethods)
			{
				invoke(method, dependencies);
			}
		}
		
		public function release(mediators:Array):void
		{
		}
	}
}