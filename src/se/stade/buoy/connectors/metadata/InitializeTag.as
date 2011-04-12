package se.stade.buoy.connectors.metadata
{
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import se.stade.buoy.dependencies.DependencyContainer;
	import se.stade.buoy.dependencies.ioc.MethodInvoker;
	import se.stade.daffodil.Reflect;
	import se.stade.daffodil.methods.Method;
	
	public class InitializeTag extends MetadataTagBase implements MetadataTag
	{
		public function InitializeTag(tag:String = "Init")
		{
			super(tag, this);
		}
		
		protected var executionHistory:Dictionary;
		protected var invoker:MethodInvoker = new MethodInvoker();
		
		override public function initialize(view:UIComponent, dependencies:DependencyContainer):void
		{
			super.initialize(view, dependencies);
			executionHistory = new Dictionary(true);
		}
		
		public function connect(mediators:Array):void
		{
			var initializers:Array = Reflect.methods
											 .withMetadata(tag)
											 .on(mediators);
			
			for each (var initializer:Method in initializers)
			{
				if (initializer in executionHistory)
					continue;
				
				invoker.apply(initializer, dependencies);
				executionHistory[initializer] = true;
			}
		}

		public function release(mediators:Array):void
		{
		}
		
		override public function dispose():void
		{
			super.dispose();
			executionHistory = null;
		}
	}
}