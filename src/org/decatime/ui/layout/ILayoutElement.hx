package org.decatime.ui.layout;

import flash.geom.Rectangle;

/**	
*	<p>This interface is used to interact with a layoutable object.
*   
*/
interface ILayoutElement {

	/**
	* The refresh function will be call so that the ILayoutElement instance
	* update its content with the size constraint <code>Rectangle</code>
	* passed has an argument to the method.
	*/
	function refresh(r:Rectangle): Void;
	
	/**
	* Returns the size that was setted by the last call to refresh method
	*/
	function getCurrSize():Rectangle;
	
	/**
	* used to toggle the visibility of the ILayoutElement
	*/
	function setVisible(value:Bool):Void;
}