package org.decatime.ui;

import flash.display.Shape;
import flash.display.Graphics;
import flash.errors.Error;
import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;

/**	
*	<p>Base class for all DisplayObject that are based on a Shape.
*/
class BaseShapeElement extends Shape implements ILayoutElement implements IDrawingSurface {
	
	private var sizeInfo:Rectangle;

	/**
	* Default constructor.
	* @param name The name for this BaseShapeElement instance	
	*/
	public function new(name:String) {
		super();
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

	/**
	* IDrawingSurface implementation. returns the Graphics instance of this
	* Shape.
	*
	* @return Graphics a Graphics instance.
	*/
	public function getDrawingSurface(): Graphics {
		return graphics;
	}
}	