package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;
import org.decatime.ui.layout.Content;


class Basic extends EventManaver implements ILayoutElement {
	public var margin:Float;
	public var hgap:Float;
	public var vgap:Float;

	private var parent:ILayoutElement;
	private var currSize:Rectangle;
	private var contents:haxe.ds.IntMap<Content>;

	public function new(parent:ILayoutElement) {
		super (parent);
		// by default margin is settted to two pixel
		this.margin = 2;

		// hgap and vgap are setted to 4 pixels
		this.hgap = 4;
		this.vgap = 4;

		// the parent can be a visual element or a layout element
		//
		this.parent = parent;

		this.contents = new haxe.ds.IntMap<Content>();
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
	
	public function getId():String {
		return "BasicLayout";
	}
	
	public function setVisible(value:Bool):Void {
		for (content in contents) {
			content.setVisible(value);
		}
	}

	// ILayoutElement implementation - END
}