package org.decatime.ui;

import flash.display.Graphics;
import flash.geom.Rectangle;

/**	
*	<p>This interface is used to interact with a visual object.
*   
*/
interface IVisualElement {
	/**
	* The refresh function will be call so that the IVisualElement instance
	* update its content with the size constraint <code>Rectangle</code>
	* passed has an argument to the method.
	*/
	function refresh(r:Rectangle): Void;
	
	/**
	* Ask the instance to return a Graphics instance object to draw on.
	*/
	function getDrawingSurface():Graphics;
	
	/**
	* Returns the size that was setted by the last call to refresh method
	*/
	function getInitialSize():Rectangle;
	
	/**
	* Return a String ID for this IVisualElement instance
	*/
	function getId():String;
	
	/**
	* used to toggle the visibility of the IVisualElement
	*/
	function setVisible(value:Bool):Void;
}