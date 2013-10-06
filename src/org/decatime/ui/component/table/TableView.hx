package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.layout.HBox;

class TableView extends BaseContainer {
	public var rowCount(default, default): Int;
	
	private var columns:Array<Column>;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
		this.elBackColor = 0xaaaaaa;
		this.columns = new Array<Column>();
	}

	public function set_rowCount(value:Int): Void {
		this.rowCount = value;
	}

	public function get_rowCount(): Int {
		return this.rowCount;
	}

	public function addColumn(c:Column) : Void {
		this.columns.push(c);
	}

	public function getColumn(index:Int): Column {
		return this.columns[index];
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		var g:Graphics = this.graphics;
		
		g.clear();

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var i:Int = 0;
		for (i in 0...columns.length) {
			var c:Column = columns[i];
			this.container.create(c.getColWidth(), c);
			this.addChild(c);
		}
	}

}