package se.stade.buoy
{
	import flash.display.DisplayObject;
	
	import se.stade.stilts.Disposable;
	
	public interface Context extends Disposable
	{
		function attach(view:DisplayObject):void;
		
		function activate():void;
		function deactivate():void;
	}
}