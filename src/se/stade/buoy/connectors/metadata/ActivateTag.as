package se.stade.buoy.connectors.metadata
{
	import se.stade.buoy.dependencies.ioc.MethodInvoker;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.Reflection;
	import se.stade.daffodil.methods.Method;

	public class ActivateTag extends MetadataTagBase implements MetadataTag
	{
		public function ActivateTag(tag:String = "Activate")
		{
			super(tag, this);
		}
		
		protected var invoker:MethodInvoker = new MethodInvoker();
		
		public function connect(mediators:Array):void
		{
			var activationMethods:Array = Reflect.methods.withMetadata(tag).on(mediators);
			
			for each (var method:Method in activationMethods)
			{
				invoker.apply(method, dependencies);
			}
		}
		
		public function release(mediators:Array):void
		{
		}
	}
}