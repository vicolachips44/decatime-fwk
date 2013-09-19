package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;

class Content implements ILayoutElement {
	// Size can be horizontal (width) or vertical (height)
	private var size:Float;
	private var parent:Basic;
	private var keyValue:Int;
	private var currSize:Rectangle;
	private var item:ILayoutElement;

	public function new (parent:Basic, size:Float, item:ILayoutElement) {
		this.parent = parent;
		this.size = size;
		this.item = item;
	}

	public function getKeyValue(): Int {
		return this.keyValue;
	}

	public function setKeyValue(value:Int): Void {
		this.keyValue = value;
	}

	public function getSize(): Float {
		return size;
	}

	public function setSize(value:Float): Void {
		size = value;
	}

	// ILayoutElement implementation - BEGIN

	public function refresh(r:Rectangle): Void {
		this.item.refresh(r);
	}
	
	public function getCurrSize():Rectangle {
		return this.currSize;
	}
	
	public function setVisible(value:Bool):Void {

	}

	// ILayoutElement implementation - END

	public function setCurrSize(value:Rectangle): Void {
		this.currSize = value;
	}
}