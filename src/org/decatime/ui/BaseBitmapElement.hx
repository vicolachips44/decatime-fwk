package org.decatime.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.geom.Rectangle;
import flash.errors.Error;

import org.decatime.ui.layout.ILayoutElement;

class BaseBitmapElement extends Bitmap implements ILayoutElement {
	private var sizeInfo:Rectangle;

	private var hgap:Float;
	private var vgap:Float;
	private var transparent:Bool;
	private var backColor:Int;

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

	public function setBackColor(value:Int): Void {
		this.backColor = value;

		// Since the user wants a background we set the transparency value to false.
		this.transparent = false;
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

		this.bitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), this.transparent, this.backColor);
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