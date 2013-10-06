package org.decatime.ui.component.table;

import org.decatime.ui.BaseSpriteElement;

class Column extends BaseSpriteElement {
	private var colWidth: Int;

	public function new(columnName:String, cwidth:Int) {
		super(columnName);
		this.colWidth = cwidth;
	}
}