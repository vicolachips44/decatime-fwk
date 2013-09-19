package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;

class Content implements ILayoutElement {
	private var size:Float;
	private var parent:Basic;

	public function new (parent:Basic, ?size:Float) {
		this.parent = parent;
		this.size = size;
	}

	public function getSize(): Float {
		return size;
	}

	public function setSize(value:Float): Void {
		size = value;
	}

	// ILayoutElement implementation - BEGIN

	public function refresh(r:Rectangle): Void {

	}
	
	public function getCurrSize():Rectangle {
		return new Rectangle();
	}
	
	public function setVisible(value:Bool):Void {

	}

	// ILayoutElement implementation - END
}