package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.dependencies.ioc.MethodInvoker;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;

	public class DeactivateTag extends MetadataTagBase implements MetadataTag
	{
		public function DeactivateTag(tag:String = "Deactivate")
		{
			super(tag, this);
		}
		
		protected var invoker:MethodInvoker = new MethodInvoker();
		
		public function connect(mediators:Array):void
		{
		}
		
		public function release(mediators:Array):void
		{
			var deactivationMethods:Array = Reflect.all.methods.withMetadata(tag).on(mediators);
			
			for each (var method:Method in deactivationMethods)
			{
				invoker.apply(method, dependencies);
			}
		}
	}
}