package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

class Column  {
	
	public var columnWidth(default, null): Float;
	public var table(default, default): TableView;
	public var columnIndex(default, default): Int;
	public var cells(default, default):Array<Cell>;

	private var columnRect: Rectangle;

	public function new(name:String, colWidth: Float) {
		this.columnWidth = colWidth;
		this.cells = new Array<Cell>();
	}

	public function getCellRect(c:Cell): Rectangle {
		var x: Float = this.columnRect.x;
		var y: Float = this.columnRect.y;
		var w: Float = this.columnRect.width;
		var h: Float = this.table.rowHeight;

		var cell:Cell = null;
		for (cell in cells) {
			if (cell.rowIndex == c.rowIndex) { break; }
			y+= this.table.rowHeight;
		}
		return new Rectangle(x, y, w, h);
	}

	public function draw(g:Graphics): Void {
		var r:Rectangle = table.getColumnRect(this);
		g.lineStyle(1);
		g.drawRect(r.x, r.y, r.width, r.height);
		this.columnRect = r;
	}

}