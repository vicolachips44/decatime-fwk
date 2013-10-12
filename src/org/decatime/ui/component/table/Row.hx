package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;

class Row extends BaseContainer {
	public var rowHeight(default, null): Float;
	public var table(default, default): TableView;
	public var rowIndex(default, default): Int;

	private var cells:Array<Cell>;

	public function new(name:String, rHeight: Float) {
		super(name);
		this.rowHeight = rHeight;
		this.cells = new Array<Cell>();
		this.cacheAsBitmap = true;
	}

	public function addCell(c:Cell): Cell {
		this.cells.push(c);
		c.text.setFontRes(table.getFontRes());
		return c;
	}

	public override function refresh(r:Rectangle): Void {
		r.y = (this.rowIndex - 1) * rowHeight;
		super.refresh(r);
		var g:Graphics = this.graphics;
		g.clear();
		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);

		var i:Int = 0;
		for (i in 0...this.cells.length) {
			var rect:Rectangle = this.cells[i].text.getCurrSize();
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
		}
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var i:Int = 0;
		for (i in 0...this.cells.length) {
			this.container.create(this.table.getColumn(i+1).columnWidth, this.cells[i].text);
			this.addChild(this.cells[i].text);
		}
	}
}