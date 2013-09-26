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
	private var hgap:Float;
	private var vgap:Float;

	public function new (parent:Basic, size:Float, item:ILayoutElement) {
		this.parent = parent;
		this.size = size;
		this.item = item;
		this.hgap = 0;
		this.vgap = 0;
	}

	public function setHorizontalGap(value:Float): Void {
		this.hgap = value;
	}

	public function getHorizontalGap(): Float {
		return this.hgap;
	}

	public function setVerticalGap(value:Float): Void {
		this.vgap = value;
	}

	public function getVerticalGap(): Float {
		return this.vgap;
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
		if (this.hgap == 0 && this.vgap == 0) {
			this.item.refresh(r);	
		} else {
			var newRec:Rectangle = new Rectangle();

			newRec.x = r.x + this.hgap;
			newRec.y = r.y + this.vgap;
			newRec.width = r.width - (this.hgap * 2);
			newRec.height = r.height - (this.vgap * 2);
			this.item.refresh(newRec);
		}
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