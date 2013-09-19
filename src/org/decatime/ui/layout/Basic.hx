package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;
import org.decatime.ui.layout.Content;


class Basic implements ILayoutElement {
	public var hgap:Float;
	public var vgap:Float;

	private var parent:ILayoutElement;
	private var currSize:Rectangle;
	private var contents:haxe.ds.IntMap<Content>;

	public function new(parent:ILayoutElement) {
		// hgap and vgap are setted to 4 pixels
		this.hgap = 4;
		this.vgap = 4;

		// the parent can be a visual element or a layout element
		//
		this.parent = parent;

		this.contents = new haxe.ds.IntMap<Content>();
	}

	public function getNbContent(): Int {
		return Lambda.count(this.contents);
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

	// ILayoutElement implementation - BEGIN

	public function refresh(r:Rectangle): Void {
		this.currSize = r;
	}

	/**
	* Current geometry of this layout. The property is setted
	* every time the refresh() method is called.
	*
	*/
	public function getCurrSize(): Rectangle {
		return this.currSize;
	}
	
	public function setVisible(value:Bool):Void {
		for (content in contents) {
			content.setVisible(value);
		}
	}

	// ILayoutElement implementation - END
}