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

	/**
	* If this object is a container it will not have a default size but it's x, y property
	* will be set by the Rectangle object passed to the refresh() method.
	* If this object is a container then a call to the refresh method will paint a
	* background on this Sprite in order that it's size match the Rectangle instance.
	* <i>A sprite object canno't be size directly</i>. <br />
	* If this is done (by adjusting the width and
	* height property), the object will be scaled.
	*/
	public var isContainer:Bool;

	private var elBackColor:Int;
	private var elBackColorVisibility:Float;
	private var supportDisableState: Bool;

	/**
	* Default constructor.</br>
	* @param </br>
	* <ol>
	* <li>name The name for this BaseShapeElement instance</li>
	* </ol>
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

		// If the component is part of a window its mouseEnable property
		// can be modify. If supportDisableState is false then the property
		// will not be call from thie instance
		this.supportDisableState = true;

		this.elBackColor = 0xffffff;
		this.elBackColorVisibility = 0.0;
	}

	/**
	* @Override of the InteractiveObject mouseEnabled property
	*/
	public override function set_mouseEnabled(value: Bool): Bool {
		if (this.supportDisableState) {
			return super.set_mouseEnabled(value);
		}
		return false;
	}

	/**
	* if this instance support having the mouseEnable state toggle or not.
	*
	* @param value: Bool a boolean value true / false
	*
	* @return Void
	*/
	public function setSupportDisableState(value: Bool): Void {
		this.supportDisableState = value;
	}

	/**
	* ILayoutElement implementation. will make the position X and Y match
	* the provided Rectangle instance x and y if this his not a container.
	* Otherwise, the container is painted by the size provided.
	*
	* @see <a href="layout/ILayoutElement.html">org.decatime.display.ui.ILayoutElement</a>
	*
	* @throw Error if the provided Rectangle argument is null
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
			graphics.beginFill(elBackColor, elBackColorVisibility);
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
	* @return flash.geom.Rectangle containing the dimension.
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
	* @return flash.display.Graphics a Graphics instance.
	*/
	public function getDrawingSurface(): Graphics {
		return graphics;
	}
}	