package org.decatime.ui.component.table;

import flash.events.MouseEvent;

import org.decatime.ui.component.CheckBox;

class CheckBoxEditor extends CheckBox implements ITableEditor {
	public var table(default, default): TableView;

	public function new(table: TableView, name:String) {
		super(name);

		this.table = table;
	}

	private override function createLabel(): Void { } // we don't need it

	private override function onMouseDown(e:MouseEvent): Void {
		this.selected = ! this.selected;
		draw();
	}

	// ITableEditor implementation - BEGIN

	public function getDisplayObject(): flash.display.InteractiveObject {
		return this;
	}

	public function setPosition(r:flash.geom.Rectangle): Void {
		this.refresh(r);
	}

	public override function setVisible(value:Bool): Void {
		super.setVisible(value);
	}
	
	public function setValue(newValue: String): Void {
		this.selected = newValue == '1' ? true : false;
		this.draw();
	}

	public function getValue(): String {
		return this.selected ? '1' : '0';
	}

	// ITableEditor implementation - END
}