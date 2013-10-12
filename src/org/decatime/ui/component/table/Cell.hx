package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.Label;

class Cell {
	public var text(default, null): Label;

	public function new(name:String) {
		this.text = new Label(name);
	}
}