package se.stade.buoy.connectors.metadata
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import se.stade.buoy.Connector;
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.ioc.invoke;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;

	public class DisposeTag extends MetadataTagBase implements Connector
	{
		public function DisposeTag(tag:String = "Dispose")
		{
			super(tag, this);
		}
		
		protected var disposers:Dictionary;
		
		override public function initialize(view:DisplayObject, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			disposers = new Dictionary(true);
		}
		
		public function connect(behaviors:Array):void
		{
			var disposeMethods:Array = Reflect.all.methods.withMetadata(tag).on(behaviors);
			
			for each (var method:Method in disposeMethods)
			{
				disposers[method] = method;
			}
		}
		
		public function release(behaviors:Array):void
		{
			var disposeMethods:Array = Reflect.all.methods.withMetadata(tag).on(behaviors);
			
			for each (var method:Method in disposeMethods)
			{
				delete disposers[method];
			}
		}
		
		override public function dispose():void
		{
			for each (var method:Method in disposers)
			{
				invoke(method, dependencies);
			}
		}
	}
}