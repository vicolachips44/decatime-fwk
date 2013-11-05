package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.display.Bitmap;
import flash.display.Shape;

import org.decatime.ui.component.TextLabel;

class Cell {
	public var table(default, default): TableView;
	public var column(default, default): Column;
	public var rowIndex(default, default): Int;
	public var isVisible(default, null): Bool;

	private var rect:Rectangle;
	private var label: TextLabel;
	private var chkValue: Dynamic;
	private var bmCache: Bitmap;

	private var content: String;

	public function new(content: String) {
		this.content = content;
		this.rowIndex = -1;
		this.isVisible = false;
		this.chkValue = null;
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

	public function draw(g:Graphics, ?color: Int = 0xffffff) : Bool {
		var r:Rectangle = this.column.getCellRect(this);
		
		if (r == null) {
			this.isVisible = false;
			
			if (this.column.columnType == ColumnType.TEXT && this.label != null) {
				this.table.getGridSprite().removeChild(this.label);
				this.label = null;
			} else if (this.column.columnType == ColumnType.CHECKBOX && this.bmCache != null) {
				this.table.getGridSprite().removeChild(this.bmCache);
				this.bmCache.bitmapData.dispose();
				this.bmCache = null;
			}
			
			return false;
		}

		this.rect = r;
		
		g.beginFill(color);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();

		if (this.column.columnType == ColumnType.TEXT) {

			if (this.label == null) {
				createLabel();

			} else {
				this.label.x = r.x;
				this.label.y = r.y;
			}
		
			if (this.label.getText() != this.content) {
				this.label.setText(this.content);
			}
		} else if (this.column.columnType == ColumnType.CHECKBOX) {
			var newValue: Bool = this.content == "1" ? true : false;
			if (newValue != this.chkValue || this.bmCache == null) {
				createBmpCheck(newValue, r);
				this.chkValue = newValue;
			}
			this.bmCache.y = r.y + 3;
			this.bmCache.x = r.x + (this.column.columnWidth / 2) - 8;
		}

		this.isVisible = true;
		return true;
	}

	private function createBmpCheck(selected: Bool, r:Rectangle): Void {
		if (this.bmCache != null) { this.bmCache.bitmapData.dispose(); }
		this.bmCache = null;

		this.bmCache = new Bitmap();
		this.bmCache.bitmapData = new flash.display.BitmapData(13, 13, false);
		this.table.getGridSprite().addChild(this.bmCache);
		
		var sh:Shape = new Shape();
		var g:Graphics = sh.graphics;

		g.beginFill(0xffffff);
		g.lineStyle(1);
		var ml: Int = 2;
		var mr: Int = 2;
		g.drawRect(0, 0, 12, 12);

		if (selected) {
			g.moveTo(0, 0);
			g.lineTo(12, 12);
			g.moveTo(0, 12);
			g.lineTo(12, 0);
		}
		g.endFill();

		this.bmCache.bitmapData.draw(sh);
	}

	private function updateDisplay(): Void {
		if (this.isVisible) { 
			this.draw(this.table.getGridSprite().graphics); 
		}
	}


	private function createLabel(): Void {
		this.label = new TextLabel(this.content, 0x000000, 'left');
		this.label.setFontRes(this.table.getFontRes());
		this.label.refresh(this.rect);
		this.table.getGridSprite().addChild(this.label);
	}

}