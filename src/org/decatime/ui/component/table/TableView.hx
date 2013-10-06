package org.decatime.ui.component.table;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.layout.VBox;

class TableView extends BaseContainer {
	public var rowCount(default, default): Int;
	
	private var columns:Array<Column>;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
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

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(1);
		this.container.setHorizontalGap(1);
	}
}