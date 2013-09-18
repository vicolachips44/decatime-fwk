package org.decatime.ui;

import flash.display.Graphics;

/**	
*	<p>This interface is used to interact with a visual object.
*   
*/
interface IDrawingSurface {

	/**
	* Ask the instance to return a Graphics instance object to draw on.
	*/
	function getDrawingSurface():Graphics;
}