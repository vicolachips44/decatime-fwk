package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

class Column  {
	
	public var columnWidth(default, null): Float;
	public var table(default, default): TableView;
	public var columnIndex(default, default): Int;
	public var cells(default, default):Array<Cell>;
	public var columnType(default, default): ColumnType;
	private var columnRect: Rectangle;
	private var label: Label;
	private var columnName: String;

	public function new(name:String, colWidth: Float) {
		this.columnWidth = colWidth;
		this.cells = new Array<Cell>();
		this.columnName = name;
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
		var b: Int = table.getBottomRowIndex();

		for (i in t...b) {
			cell = this.cells[i];
			
			if (cell == null) { break; }

			if (cell.rowIndex == in_cell.rowIndex) {
				return new Rectangle(x, y, w, h);
			}

			y+= this.table.rowHeight;
		}
		return null;
	}

	public function draw(g:Graphics): Void {
		var r:Rectangle = table.getColumnRect(this);

		if (this.label == null) { this.createLabel(); }
		this.drawHeader(g, r);

		this.columnRect = r;

		var c:Cell  = null;
		for (c in cells) {
			c.draw(g);
		}
	}

	private function createLabel(): Void {
		this.label = new Label(this.columnName, 0xffffff, 'center');
		this.label.setFontRes(this.table.getFontRes());
		this.label.setIsBold(true);
		this.label.setFontSize(14);
		this.table.getGridSprite().addChild(this.label);
		this.label.visible = false;
	}

	private function drawHeader(g:Graphics, r:Rectangle): Void {
		var rectHeader: Rectangle = r.clone();
		rectHeader.height = this.table.headerHeight;

		g.beginFill(0x000099);
		g.drawRect(r.x, r.y, r.width, this.table.headerHeight);
		g.endFill();
		this.label.refresh(rectHeader);
		
		this.label.visible = true;

	}

}