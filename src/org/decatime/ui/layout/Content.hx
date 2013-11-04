package org.decatime.ui.layout;

import flash.geom.Rectangle;

import org.decatime.ui.layout.ILayoutElement;

/**
* This object will encapsulate an Item to be display on the stage.
* It is part of a collection of objects own by a Basic layout object (VBoxn HBox).
*/
class Content implements ILayoutElement {
	// Size can be horizontal (width) or vertical (height)
	private var size:Float;
	private var parent:Basic;
	private var keyValue:Int;
	private var currSize:Rectangle;
	private var item:ILayoutElement;
	private var hgap:Float;
	private var vgap:Float;

	/**
	* Default constructor.
	*
	* @param parent: Basic the layout logic implementation
	* @param size: Float the size for this content
	* @param item: The ILayoutElement to manage size from
	*/
	public function new (parent:Basic, size:Float, item:ILayoutElement) {
		this.parent = parent;
		this.size = size;
		this.item = item;
		this.hgap = 0;
		this.vgap = 0;
	}

	/**
	* Returns the ILayoutElement associated to this instance
	*
	* @return ILayoutElement the managed object
	*/
	public function getItem(): ILayoutElement {
		return this.item;
	}

	/**
	* Define the horizontal gap to apply when doing layout
	* 
	* @param value: Float the value to apply
	*
	* @return Void
	*/
	public function setHorizontalGap(value:Float): Void {
		this.hgap = value;
	}

	/**
	* Returns the horizontalGap. By default the value is zero.
	*
	* @return Float the value (zero by default)
	*/
	public function getHorizontalGap(): Float {
		return this.hgap;
	}

	/**
	* Define the vertical gap to apply when doing layout of the ILayoutElement
	* item instance.
	*
	* @param value: Float the value for the vertical gap
	*
	* @return Void
	*/
	public function setVerticalGap(value:Float): Void {
		this.vgap = value;
	}

	/**
	* Returns the verticalGap property value.
	*
	* @return Float the value
	*/
	public function getVerticalGap(): Float {
		return this.vgap;
	}

	/**
	* Returns the index from the parent collection of Contant objects.
	*
	* @return Int the index value
	*/
	public function getKeyValue(): Int {
		return this.keyValue;
	}

	/**
	* Set the index value of this Content object from within the parent
	* layout object manager.
	*
	* @param value: Int the value (this value is settes via Basic derived objects)
	*/
	public function setKeyValue(value:Int): Void {
		this.keyValue = value;
	}

	/**
	* Returns the size defined in the constructor of this instance
	*
	* @return Float the size to apply when layout is run.
	*/
	public function getSize(): Float {
		return size;
	}

	// ILayoutElement implementation - BEGIN

	/**
	* ILayoutELement implementation. Applies the layout to the underlying Item
	* 
	* @param r: Rectangle the Rectangle geometry constraint
	*
	* @return Void
	*/
	public function refresh(r:Rectangle): Void {
		if (this.hgap == 0 && this.vgap == 0) {
			this.item.refresh(r);	
		} else {
			var newRec:Rectangle = new Rectangle();

			newRec.x = r.x + this.hgap;
			newRec.y = r.y + this.vgap;
			newRec.width = r.width - (this.hgap * 2);
			newRec.height = r.height - (this.vgap * 2);
			this.item.refresh(newRec);
		}
	}
	
	/**
	* Returns the Rectangle size that was calculated when refresh
	* method is called.
	*
	* @returns Rectangle the size
	*/
	public function getCurrSize():Rectangle {
		return this.currSize;
	}
	
	/**
	* TODO: Toggle the visibility of the managed item ILayoutElement
	*
	* @param value: Bool true of false
	*/
	public function setVisible(value:Bool):Void {

	}

	// ILayoutElement implementation - END

	/**
	* This property is setted by the layout logic when the iteration
	* is made over contents objects. This property should not be setted
	* out of this scope.
	*
	* @param value: Rectangle the constraint size
	*/
	public function setCurrSize(value:Rectangle): Void {
		this.currSize = value;
	}
}