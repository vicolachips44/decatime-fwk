package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.component.Label;

class Cell {
	public var table(default, default): TableView;
	public var column(default, default): Column;
	public var rowIndex(default, default): Int;
	public var isVisible(default, null): Bool;

	private var rect:Rectangle;
	private var label: Label;

	private var content: String;

	public function new(content: String) {
		this.content = content;
	}

	public function getRect(): Rectangle {
		return this.rect;
	}

	public function draw(g:Graphics) : Void {
		var r:Rectangle = this.column.getCellRect(this);
		
		if (r == null) {
			this.isVisible = false;
			if (this.label != null) {
				this.table.getGridSprite().removeChild(this.label);
				this.label = null;
			}
			
			return;
		}

		this.rect = r;
		
		g.lineStyle(1);
		g.beginFill(0xffffff);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();

		if (this.label == null) {
			createLabel();
		} else {
			this.label.x = r.x;
			this.label.y = r.y;
		}
		this.isVisible = true;
	}

	private function createLabel(): Void {
		this.label = new Label(this.content, 0x000000, 'left');
		this.label.setFontRes(this.table.getFontRes());
		this.label.refresh(this.rect);
		this.table.getGridSprite().addChild(this.label);
	}

}