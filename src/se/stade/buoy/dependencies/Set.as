package se.stade.buoy.dependencies
{
	[DefaultProperty("value")]
	public final class Set
	{
		public static function inject(property:String):Set
		{
			return new Set(property, Inject.inferred);
		}
		
		public function Set(property:String = "", value:* = null)
		{
			this.value = value;
			this.property = property;
		}
		
		private var _property:String;
		public function get property():String
		{
			return _property;
		}
		
		public function set property(value:String):void
		{
			_property = value;
		}
		
		private var _value:*;
		public function get value():*
		{
			return _value;
		}
		
		public function set value(value:*):void
		{
			_value = value;
		}
	}
}