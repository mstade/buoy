package se.stade.buoy.dependencies
{
	[DefaultProperty("value")]
	public final class SetProperty
	{
		public static function inject(property:String):SetProperty
		{
			return new SetProperty(property, Inject.inferred);
		}
		
		public function SetProperty(name:String = "", value:* = null)
		{
			this.value = value;
			this.name = name;
		}
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
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