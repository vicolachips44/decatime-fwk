package org.decatime.ui;

import flash.display.Shape;
import flash.display.Graphics;
import flash.errors.Error;
import flash.geom.Rectangle;

import org.decatime.ui.IVisualElement;

/**	
*	<p>Base class for all DisplayObject that are based on a Shape.
*/
class BaseShapeElement extends Shape implements IVisualElement {
	
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
	* IVisualElement implementation. will make the position X and Y match
	* the provided Rectangle instance x and y.
	*
	* @see org.decatime.display.ui.IVisualElement
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
	* IVisualElement implementation. returns the Graphics instance of this
	* Shape.
	*
	* @return Graphics a Graphics instance.
	*/
	public function getDrawingSurface(): Graphics {
		return graphics;
	}

	/**
	* IVisualElement implementation. returns the sizeInfo property that was
	* setted in the refresh method call.
	*
	* @return nme.geom.Rectangle containing the dimension.
	*/
	public function getInitialSize(): Rectangle {
		return sizeInfo;
	}

	/**
	* IVisualElement implementaion. return the name that was defined when
	* calling the constructor of this instance.
	*
	* @return String the name.
	*/
	public function getId(): String {
		return name;
	}

	/**
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