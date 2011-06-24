package se.stade.buoy
{
	import mx.core.UIComponent;
	
	import se.stade.stilts.Disposable;
	
	public interface Context extends Disposable
	{
		function attach(view:UIComponent):void;
		
		function activate():void;
		function deactivate():void;
	}
}