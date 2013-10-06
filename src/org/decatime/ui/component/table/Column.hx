package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.layout.VBox;

class Column extends BaseContainer {
	private var colWidth: Float;
	private var cells:Array<Cell>;

	public function new(columnName:String, cwidth:Float) {
		super(columnName);
		this.colWidth = cwidth;
		this.cells = new Array<Cell>();
	}

	public function getColWidth(): Float {
		return this.colWidth;
	}

	public function addCell(value:Cell): Void {
		this.cells.push(value);
	}

	public function getCell(index:Int): Cell {
		return this.cells[index];
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		var g:Graphics = this.graphics;
		
		g.clear();

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);
	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var i:Int = 0;
		for (i in 0...cells.length) {
			var c:Cell = cells[i];
			this.container.create(24, c);
			this.addChild(c);
		}
	}

}