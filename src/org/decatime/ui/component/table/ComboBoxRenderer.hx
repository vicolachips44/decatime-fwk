package org.decatime.ui.component.table;

import flash.events.MouseEvent;

import org.decatime.ui.component.ComboBox;

class ComboBoxRenderer extends ComboBox implements ICellRenderer {
	private var _cell:Cell;

	public function new(fontRes: String) {
		super('comboBoxRenderer', fontRes);
		this.tbox.type = flash.text.TextFieldType.DYNAMIC;
		this.tbox.selectable = false;
		this.tbox.mouseEnabled = false;
	}

	public function alwaysShow(): Bool {
		return true;
	}

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
	public override function setValue(value:Dynamic): Void {
		super.setValue(value);
	}

	/**
	* gets the value to edit on this renderer
	*/ 
	public override function getValue(): Dynamic {
		return super.getValue();
	}
}