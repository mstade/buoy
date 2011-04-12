package se.stade.buoy.connectors.metadata
{
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.ioc.MethodInvoker;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;

	public class DisposeTag extends MetadataTagBase implements MetadataTag
	{
		public function DisposeTag(tag:String = "Dispose")
		{
			super(tag, this);
		}
		
		protected var disposers:Dictionary;
		protected var invoker:MethodInvoker = new MethodInvoker();
		
		override public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			disposers = new Dictionary(true);
		}
		
		public function connect(mediators:Array):void
		{
			var disposeMethods:Array = Reflect.methods.withMetadata(tag).on(mediators);
			
			for each (var method:Method in disposeMethods)
			{
				disposers[method] = method;
			}
		}
		
		public function release(mediators:Array):void
		{
			var disposeMethods:Array = Reflect.methods.withMetadata(tag).on(mediators);
			
			for each (var method:Method in disposeMethods)
			{
				delete disposers[method];
			}
		}
		
		override public function dispose():void
		{
			for each (var method:Method in disposers)
			{
				invoker.apply(method, dependencies);
			}
		}
	}
}