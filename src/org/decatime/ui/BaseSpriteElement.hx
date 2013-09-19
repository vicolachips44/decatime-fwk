package org.decatime.ui;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;

/**	
*	<p>Base class for all DisplayObject that are based on a Sprite.
*/
class BaseSpriteElement extends Sprite implements ILayoutElement implements IDrawingSurface {
	
	private var sizeInfo:Rectangle;
	public var isContainer:Bool;
	private var elBackColor:Int;

	/**
	* Default constructor.
	* @param name The name for this BaseShapeElement instance	
	*/
	public function new(name:String) {
		super();
		this.name = name;

		// By default this instance act has a button(respond to mouse events)
		this.buttonMode = true;

		// When the refresh method is called if isContainer property
		// is setted to true then this component is resized to fit the
		// Rectangle info passed to the refresh method. This is due to the
		// fact that the with and height property of a Sprite cannot
		// be set directly (it can in fact but will change the aspect ratio).
		this.isContainer = true;

		this.elBackColor = 0x000000;
	}

	/**
	* ILayoutElement implementation. will make the position X and Y match
	* the provided Rectangle instance x and y.
	*
	* @see org.decatime.display.ui.IVisualElement
	*
	* @throws nme.error.Error if the provided Rectangle argument is null
	*/
	public function refresh(r:Rectangle): Void {
		if (r == null) {
			throw ("provided Rectangle instance value is null");
		}
		this.sizeInfo = r;

		// if we are a container we must be sized by the rect content
		// to do so we need to draw something since setting the width and height
		// will not work has expected.
		if (isContainer) {
			graphics.clear();
			graphics.beginFill(elBackColor, 1);
			graphics.drawRect(r.x, r.y, r.width, r.height);
		} else {
			// i am just a visual component. my size is dynamic
			x = r.x;
			y = r.y;
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
	* ILayoutElement. Toggle the visibility of this Shape depending on the <code>value</code> 
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
	* Object.
	*
	* @return Graphics a Graphics instance.
	*/
	public function getDrawingSurface(): Graphics {
		return graphics;
	}
}	