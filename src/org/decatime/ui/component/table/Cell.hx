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
		this.rowIndex = -1;
		this.isVisible = false;
	}

	public function getContent(): String {
		return this.content;
	}

	public function setContent(content: String) {
		this.content = content;
		updateDisplay();
	}

	public function getRect(): Rectangle {
		return this.rect;
	}

	public function draw(g:Graphics) : Bool {
		var r:Rectangle = this.column.getCellRect(this);
		
		if (r == null) {
			this.isVisible = false;
			if (this.label != null) {
				this.table.getGridSprite().removeChild(this.label);
				this.label = null;
			}
			
			return false;
		}

		this.rect = r;
		
		g.beginFill(0xffffff);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();

		if (this.label == null) {
			createLabel();
		} else {
			this.label.x = r.x;
			this.label.y = r.y;
		}
		
		if (this.label.getText() != this.content) {
			this.label.setText(this.content);
		}

		this.isVisible = true;
		return true;
	}

	private function updateDisplay(): Void {
		if (this.isVisible) { 
			this.draw(this.table.getGridSprite().graphics); 
		}
	}

	private function createLabel(): Void {
		this.label = new Label(this.content, 0x000000, 'left');
		this.label.setFontRes(this.table.getFontRes());
		this.label.refresh(this.rect);
		this.table.getGridSprite().addChild(this.label);
	}

}