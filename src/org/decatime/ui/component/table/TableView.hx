package org.decatime.ui.component.table;

import haxe.ds.IntMap;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.display.Bitmap;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.layout.ILayoutElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.Content;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.ui.component.ScrollPanel;

class TableView extends BaseContainer implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.component.table.TableView :";
	
	public var spreadLastColumn(default, default): Bool;
	public var rowHeight(default, default): Float;
	public var headerHeight(default, default): Float;
	private var topRowIndex:Int;

	private var columns:Array<Column>;
	private var fontRes:String;

	public function new(name:String, fRes: String) {
		super(name);
		this.fontRes = fRes;
		this.elBackColor = 0xffffff;
		this.elBackColorVisibility = 1.0;
		this.spreadLastColumn = true;
		this.columns = new Array<Column>();
		this.rowHeight = 20;
		this.headerHeight = 24;
		this.topRowIndex = 0;
	}

	public function addColumns(value: Array<Column>): Void {
		var c:Column = null;
		for (c in value) { this.addColumn(c); }
	}

	public function addColumn(c:Column): Void {
		c.table = this;
		c.columnIndex = this.columns.length;
		this.columns.push(c);
	}

	public function addCell(r:Int, c:Int, content: String) {
		var cell:Cell = new Cell(content);
		cell.table = this;
		cell.column = this.columns[c];
		cell.rowIndex = r;
		this.columns[c].cells.push(cell);
	}

	public function getColumnRect(c:Column): Rectangle {
		var x:Float = this.sizeInfo.x;
		var y:Float = this.sizeInfo.y;
		var w:Float = c.columnWidth;
		var h:Float = this.sizeInfo.height;

		var col:Column = null;
		var i:Int = 0;
		for (i in 0...this.columns.length) {
			col = this.columns[i];
			if (col.columnIndex == c.columnIndex) { break; }
			x += col.columnWidth;
			if (i == this.columns.length - 2) {
				w = this.getLastColumnWidth(x, w);
			}
		}
		
		return new Rectangle(x, y, w, h);
	}

	public function getFontRes(): String {
		return this.fontRes;
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {

	}

	public function getEventCollection(): Array<String> {
		return [
			
		];
	}

	// IObserver implementation END

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		var g:Graphics = this.graphics;
		g.clear();

		drawBackground(g, this.sizeInfo);

		var col: Column = null;
		var cel: Cell = null;

		for (col in columns) {
			col.draw(g);
			for (cell in col.cells) {
				cell.draw(g);
				if (cell.getRect().y > this.container.getCurrSize().y + this.sizeInfo.height - (this.rowHeight)) {
					break; // TODO make a scroll logic here...
				}
			}
		}
	}

	private function getLastColumnWidth(x: Float, w: Float): Float {
		var remaining: Float = this.sizeInfo.width - (x + w);
		if (remaining > 0) { return remaining + w; }
		return 0;
	}

	private function drawBackground(g:Graphics, r:Rectangle): Void {
		g.beginFill(0xffffff);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);
		trace ("number of columns to show is " + this.columns.length);
	}
}