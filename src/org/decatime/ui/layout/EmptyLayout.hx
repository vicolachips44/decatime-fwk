package org.decatime.ui.layout;
import flash.geom.Rectangle;


/**
* This is just a class to enable spacing
*/
class EmptyLayout implements ILayoutElement {
	private var myRect: Rectangle;

	public function new() { }

	public function refresh(r:Rectangle): Void {
		this.myRect = r;
	}
	
	public function getCurrSize():Rectangle {
		return this.myRect;
	}
	
	public function setVisible(value:Bool):Void {
	}
}