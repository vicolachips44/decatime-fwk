package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;

class Column extends BaseContainer {
	public var columnWidth(default, null): Float;
	public var headerLabel(default, null): Label;

	public function new(name:String, colWidth: Float) {
		super(name);
		this.headerLabel = new Label('');
		this.columnWidth = colWidth;
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

		this.headerLabel.setAlign('center');
		this.headerLabel.setBackColor(0x808080);

		this.container.create(1.0, this.headerLabel);
		this.addChild(this.headerLabel);
	}
}