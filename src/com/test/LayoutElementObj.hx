package com.test;

import flash.geom.Rectangle;
import flash.errors.Error;

import org.decatime.ui.layout.ILayoutElement;

class LayoutElementObj implements ILayoutElement {
	private var sizeInfo:Rectangle;
	private var visible:Bool;
	private var name:String;
	private var x:Float;
	private var y:Float;

	/**
	* Default constructor.
	* @param name The name for this BaseShapeElement instance	
	*/
	public function new(name:String) {
		this.name = name;
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
		
		x = r.x;
		y = r.y;
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