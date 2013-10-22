package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.Label;

class Cell {
	public var table(default, default): TableView;
	public var column(default, default): Column;
	public var rowIndex(default, default): Int;
	private var rect:Rectangle;

	private var content: String;

	public function new(content: String) {
		this.content = content;
	}

	public function getRect(): Rectangle {
		return this.rect;
	}

	public function draw(g:Graphics) : Void {
		var r:Rectangle = this.column.getCellRect(this);
		this.rect = r;
		
		g.lineStyle(1);
		g.drawRect(r.x, r.y, r.width, r.height);
	}

}