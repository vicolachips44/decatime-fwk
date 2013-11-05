package org.decatime.ui.component.table;

import org.decatime.ui.component.CheckBox;

class CheckBoxRenderer extends CheckBox implements ICellRenderer {
	private var _cell:Cell;

	public function new() {
		super('checkboxRenderer');
	}

	private override function createLabel(): Void { } // we don't need it

	public function getDisplayObject(): flash.display.DisplayObject {
		return this;
	}

	/**
	* returns the Cell instance of this renderer
	*/ 
	public function getParentCell(): Cell {
		return this._cell;
	}

	public function setParentCell(c:Cell): Void {
		this._cell = c;
	}

	/**
	* toggle the visibility of this renderer
	*/ 
	public override function setVisible(value:Bool): Void {
		this.visible = value;
	}

	/**
	* returns the geometry of this renderer
	*/ 
	public override function getCurrSize(): flash.geom.Rectangle {
		return this.sizeInfo;
	}

	/**
	* sets the value to display on this renderer
	*/ 
	public function setValue(value:Dynamic): Void {
		this.selected = value == '1' ? true : false;
		if (this.initialized) {
			this.draw();
		}
	}

	/**
	* gets the value to edit on this renderer
	*/ 
	public function getValue(): Dynamic {
		return this.selected ? '1' : '0';
	}
}