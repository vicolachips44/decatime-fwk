package org.decatime.ui.layout;
import flash.geom.Rectangle;


/**
* This is just a class to enable spacing
* between other layouts
*/
class EmptyLayout implements ILayoutElement {
	private var myRect: Rectangle;

	/**
	* Default constructor
	*/
	public function new() { }

	/**
	* Save the rectangle passed to the method
	* to be able to give it back when getCurrsize() is called.
	*
	* @param r:Rectangle the Rectangle instance value.
	*
	* @return Void
	*/
	public function refresh(r:Rectangle): Void {
		this.myRect = r;
	}
	
	/**
	* returns the Rectangle instance that was passed to the
	* refresh method
	*
	* @Return Rectangle a Rectangle instance
	*/
	public function getCurrSize():Rectangle {
		return this.myRect;
	}
	
	/**
	* This method does not do anything.
	*
	* @param value: Bool (visible or not but does not apply here)
	*/
	public function setVisible(value:Bool):Void {
	}
}