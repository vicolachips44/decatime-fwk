package org.decatime.ui.tools;

import flash.geom.Rectangle;

/**
* Encapsulate helper methods related to
* size of elements.
*/
class SizeTool {

	/** 
	* Compare two Rectangle instance to check if there are the same size.
	*
	* @return Bool true if they are the same size. Flas otherwise
	*/
	public static inline function isSameSize(r1: Rectangle, r2: Rectangle): Bool {
		return r1.width == r2.width && r1.height == r2.height;
	}
}