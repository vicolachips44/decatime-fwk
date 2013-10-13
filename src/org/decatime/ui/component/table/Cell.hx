package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.Label;

class Cell {
	public var renderer(default, null): ICellRenderer;
	// public var text(default, null): Label;
	public var table(default, default): TableView;
	public var row(default, default): Row;
	public var column(default, default): Column;

	public function new(value:Dynamic, r: ICellRenderer) {
		// this.text = new Label(value);
		// this.text.setTagRef(this);

		this.renderer = r;
		renderer.setParentCell(this);
		renderer.setValue(value);
	}

	public function getValue(): Dynamic {
		return this.renderer.getValue();
	}
}