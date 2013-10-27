package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;
import org.decatime.ui.layout.Content;

/**
* Basic layout instance is the base class for the BoxBase
* layout implementation.
*/
class Basic implements ILayoutElement {
	/** extra outer space in horizontal */
	private var hgap:Float;

	/** extrace outer space in vertical */
	private var vgap:Float;

	private var parent:ILayoutElement;
	private var currSize:Rectangle;
	private var contents:haxe.ds.IntMap<Content>;

	/**
	* Default constructor. The parent must be a ILayoutElement
	*/
	public function new(parent:ILayoutElement) {
		// hgap and vgap are setted to 4 pixels
		this.hgap = 4;
		this.vgap = 4;

		// the parent can be a visual element or a layout element
		//
		this.parent = parent;

		reset();
	}

	/**
	* reset the contents collection.
	*/
	public function reset(): Void {
		this.contents = new haxe.ds.IntMap<Content>();
	}

	/**
	* Returns the number of Content instance that are managed
	* by this layout.
	*/
	public function getNbContent(): Int {
		return Lambda.count(this.contents);
	}

	/**
	* Returns the Content instance by index
	*
	* @param index:Int the index of the Content instance
	*/
	public function getContent(index:Int): Content {
		return this.contents.get(index);
	}

	/**
	* set extra outer horizontal space for this layout.
	* 
	* @param value: Float the outer space.
	*/
	public function setHorizontalGap(value:Float): Void {
		this.hgap = value;
	}

	/**
	* Returns the horizontal outer space for this layout.
	*/
	public function getHorizontalGap(): Float {
		return this.hgap;
	}

	/**
	* Set extra outer vertical space for this layout.
	*
	* @param value the vertical space value.
	*/
	public function setVerticalGap(value:Float): Void {
		this.vgap = value;
	}

	/**
	* Returns the extra outer space for this layout.
	*/
	public function getVerticalGap(): Float {
		return this.vgap;
	}

	// ILayoutElement implementation - BEGIN

	/**
	* ILayoutElement implementaion. will only set the currSize
	* property according to the Rectangle instance parameter.
	*
	* @r:Rectangle the size of this layout.
	*/
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
	
	/**
	* Toggles the visibility of all Content object
	* that are childs of this layout.
	*/
	public function setVisible(value:Bool):Void {
		for (content in contents) {
			content.setVisible(value);
		}
	}

	// ILayoutElement implementation - END
}