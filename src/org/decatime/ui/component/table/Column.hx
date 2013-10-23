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

	public function getCellRect(in_cell: Cell): Rectangle {
		var x: Float = this.columnRect.x;
		var y: Float = this.columnRect.y;
		var w: Float = this.columnRect.width;
		var h: Float = this.table.rowHeight;

		y += table.headerHeight;

		var cell:Cell = null;
		var i: Int = 0;
		var t: Int = table.getTopRowIndex();
		var b: Int = table.getBottomRowIndx();

		for (i in t...b) {
			cell = this.cells[i];
			if (cell == null) { return null; }
			if (cell.rowIndex == in_cell.rowIndex) {
				return new Rectangle(x, y, w, h);
			}
			y+= this.table.rowHeight;
		}
		return null;
	}

	public function draw(g:Graphics): Void {
		var r:Rectangle = table.getColumnRect(this);

		this.drawHeader(g, r);

		this.columnRect = r;

		var c:Cell  = null;
		if (this.cells.length == 0) {
		}
		for (c in cells) {
			c.draw(g);
		}
	}

	private function drawHeader(g:Graphics, r:Rectangle): Void {
		g.lineStyle(1);
		g.beginFill(0xaaaaaa);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
	}

}