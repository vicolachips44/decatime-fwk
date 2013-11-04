package org.decatime.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.geom.Rectangle;
import flash.errors.Error;

import org.decatime.ui.layout.ILayoutElement;

/**
* This object is a Bitmap that implements the ILayoutElement
* so that it can be added to a Content object.
*
*/
class BaseBitmapElement extends Bitmap implements ILayoutElement {
	private var sizeInfo:Rectangle;

	private var hgap:Float;
	private var vgap:Float;
	private var transparent:Bool;
	private var backColor:Int;
	private var resizable:Bool;

	/**
	* Default constructor.
	* @param name The name for this BaseShapeElement instance	
	*/
	public function new() {
		super();
		hgap = 0;
		vgap = 0;
		transparent = true;
		backColor = 0x000000;
		resizable = true;
	}

	/**
	* When true the BitmapData property of this Bitmap will be
	* recreated when refresh method is call
	*
	* @param value: Bool 
	*/
	public function setResizable(value:Bool): Void {
		this.resizable = value;
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

	public function setTransparentBackground(value:Bool): Void {
		this.transparent = value;
	}

	public function getTransparentBackground(): Bool {
		return this.transparent;
	}

	public function setBackColor(value:Int): Void {
		this.backColor = value;

		// Since the user wants a background we set the transparency value to false.
		this.transparent = false;
	}

	public function getBackColor(): Int {
		return this.backColor;
	}

	/**
	* ILayoutElement implementation. will make the position X and Y match
	* the provided Rectangle instance x and y.
	*
	* @see org.decatime.display.ui.ILayoutElement
	*
	* @throws nme.error.Error if the provided Rectangle argument is null
	*/
	public function refresh(r:Rectangle): Void {
		if (r == null) {
			throw new Error("provided Rectangle instance value is null");
		}
		this.sizeInfo = r;
		
		x = r.x + this.hgap;
		y = r.y + this.vgap;
		
		if (this.resizable) {
			if (this.bitmapData != null) {
				this.bitmapData.dispose();
			}
			this.bitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), this.transparent, this.backColor);
		} else if (this.bitmapData == null) {
			this.bitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), this.transparent, this.backColor);
		}
	}

	/**
	* ILayoutElement implementation. returns the sizeInfo property that was
	* setted in the refresh method call.
	*
	* @return nme.geom.Rectangle containing the dimension.
	*/
	public function getCurrSize(): Rectangle {
		return sizeInfo;
	}

	/**
	* ILayoutElement implementation. 
	* Toggle the visibility of this Shape depending on the <code>value</code> 
	* param
	*
	* @param value a Boolean value to toggle the visibility
	*
	* @return Void
	*/
	public function setVisible(value:Bool): Void {
		this.visible = value;
	}
}