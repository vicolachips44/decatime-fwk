package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;
import org.decatime.ui.layout.HBox;


class Cell extends BaseContainer {
	public var isHeader(default, default): Bool;

	private var content:Label;

	public function new(content:String) {
		super(content);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		var g:Graphics = this.graphics;
		
		g.clear();

		g.lineStyle(1, 0x000000);
		
		if (isHeader) {
			g.beginFill(0xaaaaaa);
		}

		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(2);
		this.container.setHorizontalGap(2);

		this.content = new Label(this.name);
		this.content.setFontRes('assets/Vera.ttf');
		this.container.create(1.0, this.content);
		this.addChild(this.content);
	}
}