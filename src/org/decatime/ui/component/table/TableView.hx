package org.decatime.ui.component.table;

import haxe.ds.IntMap;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.display.Bitmap;
import flash.events.MouseEvent;

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
	public static var EV_ROW_SELECTED: String = NAMESPACE + "EV_ROW_SELECTED";
	public static var EV_ROW_OVER: String = NAMESPACE + "EV_ROW_OVER";

	public var spreadLastColumn(default, default): Bool;
	public var rowHeight(default, default): Float;
	public var headerHeight(default, default): Float;
	public var selectedRowIndex(default, null): Int;
	public var selectedRowColor(default, default): Int;
	public var overRowIndex(default, null): Int;
	public var overRowColor(default, default): Int;
	public var gridColor(default, default): Int;
	public var columns(default, null):Array<Column>;

	private var topRowIndex:Int;
	private var bottomRowIndex: Int;
	private var vsBar1: VerticalScrollBar;
	private var gridArea: VBox;
	private var gridSprite: BaseSpriteElement;
	private var visibleItemsCount: Int;

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
		this.selectedRowIndex = -1;
		this.overRowIndex = -1;
		this.gridColor = 0xC0C0C0;
		this.selectedRowColor = 0xffff99;
		this.overRowColor = 0xdddddd;
	}

	public function getGridSprite(): BaseSpriteElement {
		return this.gridSprite;
	}

	public function getRowCount(): Int {
		return this.columns[0].cells.length;
	}

	public function getTopRowIndex(): Int {
		return this.topRowIndex;
	}

	public function getBottomRowIndex(): Int {
		return this.bottomRowIndex;
	}

	public function addColumns(value: Array<Column>): Void {
		var c:Column = null;
		for (c in value) { this.addColumn(c); }
	}

	public function addColumn(c:Column): Void {
		c.table = this;
		c.columnType = ColumnType.TEXT;
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

	public function getCellAt(r:Int, c:Int): Cell {
		var col:Column = this.columns[c];
		return col.cells[r];
	}

	public function getColumnRect(in_col:Column): Rectangle {
		var x:Float = this.gridArea.getCurrSize().x;
		var y:Float = this.gridArea.getCurrSize().y;
		var w:Float = in_col.columnWidth;
		var h:Float = this.gridArea.getCurrSize().height;

		var col:Column = null;
		var i:Int = 0;
		for (i in 0...this.columns.length) {
			col = this.columns[i];

			if (i == this.columns.length - 1) {
				w = this.getLastColumnWidth(x, w);
			}

			if (col.columnIndex == in_col.columnIndex) { 
				x+= col.columnIndex;
				break; 
			} else {
				x += col.columnWidth;
			}

		}
				
		return new Rectangle(x, y, w, h);
	}

	public function getFontRes(): String {
		return this.fontRes;
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				VerticalScrollBar.EVT_SCROLL_UP:
				this.topRowIndex = data;
				if (this.topRowIndex > this.getRowCount() - this.visibleItemsCount) { 
					this.topRowIndex = this.getRowCount() - this.visibleItemsCount + 1;
				}
				if (this.topRowIndex < 0) { this.topRowIndex = 0; }
				draw();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			VerticalScrollBar.EVT_SCROLL_UP,
			VerticalScrollBar.EVT_SCROLL_DOWN
		];
	}

	// IObserver implementation END

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		this.gridSprite.scrollRect = this.gridArea.getCurrSize();
		this.gridSprite.x = this.gridArea.getCurrSize().x;
		this.gridSprite.y = this.gridArea.getCurrSize().y;

		draw();
		this.updateScrollBar();
	}

	private function draw() : Void {
		var g:Graphics = this.gridSprite.graphics;
		g.clear();
		locate();
		drawGrid(g);
		drawOutline();
	}

	private function drawOutline(): Void {
		var g:Graphics = this.gridSprite.graphics;
		g.lineStyle(4);
		var r:Rectangle = this.gridArea.getCurrSize();
		g.drawRect(r.x, r.y, r.width, r.height);

		// reset the line template
		this.gridSprite.graphics.lineStyle(1, this.gridColor);
	}

	private function getLastColumnWidth(x: Float, w: Float): Float {
		var remaining: Float = this.gridArea.getCurrSize().width - (x + w);
		if (remaining > 0) { return remaining + w; }
		return 0;
	}

	private function locate(): Void {
		this.bottomRowIndex = this.topRowIndex;

		var virtualY: Float = this.gridArea.getCurrSize().y;
		virtualY += this.headerHeight;

		var avHeight: Float = this.gridArea.getCurrSize().height - virtualY;
		var position: Float = 0;
		while (true) {
			position += this.rowHeight;
			this.bottomRowIndex++;
			if (position > avHeight + (this.rowHeight * 2)) {
				this.visibleItemsCount = this.bottomRowIndex - this.topRowIndex - 1;
				break;
			}
		}
	}

	private function drawGrid(g:Graphics): Void {
		g.lineStyle(1, this.gridColor);

		var col: Column = null;
		for (col in columns) {
			col.draw(g);
			g.lineStyle(1, gridColor);
		}
	}

	private function repaintRow(index:Int): Void {
		var col:Column = null;
		var g:Graphics = this.gridSprite.graphics;
		g.lineStyle(1, gridColor);
		for (col in this.columns) {
			col.cells[index].draw(this.gridSprite.graphics);
		}
		drawOutline();
	}

	
	private function drawSelectedRow(index:Int, color: Int): Void {
		var col:Column = null;
		var g:Graphics = this.gridSprite.graphics;
		g.lineStyle(1, gridColor);
		for (col in this.columns) {
			col.cells[index].draw(this.gridSprite.graphics, color);	
		}

		drawOutline();
	}

	private function updateScrollBar(): Void {
		if (this.vsBar1 == null) { return; }
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(this.getRowCount());
		this.vsBar1.setStepPos(this.topRowIndex);
		this.vsBar1.setStepSize(1);
		this.vsBar1.setVisibleHeight(this.vsBar1.getCurrSize().height / (this.bottomRowIndex - this.topRowIndex));
		this.vsBar1.updatePos();
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);

		var hbox1: HBox = new HBox(this.container);
		hbox1.setHorizontalGap(0);
		hbox1.setVerticalGap(0);

		this.container.create(1.0, hbox1);

		this.vsBar1 = new VerticalScrollBar('vsGridScrollbar');
		this.vsBar1.addListener(this);
		this.gridArea = new VBox(this.container);

		hbox1.create(1.0, this.gridArea);
		hbox1.create(24, this.vsBar1);

		gridSprite = new BaseSpriteElement('gridContainer');
		gridSprite.isContainer = false;
		gridSprite.addEventListener(MouseEvent.CLICK, onMouseEvtClick);
		gridSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		this.addChild(this.vsBar1);
		this.addChild(gridSprite);
	}

	private function onMouseMove(e:MouseEvent): Void {
		var searchY: Float = this.gridArea.getCurrSize().y + this.headerHeight;

		if (this.overRowIndex > -1 && this.overRowIndex != this.selectedRowIndex) {
			this.repaintRow(this.overRowIndex);
		}

		this.overRowIndex = -1;
		while (e.localY >= searchY) {
			this.overRowIndex++;
			searchY += this.rowHeight;
		}
		
		if (this.overRowIndex > -1 && this.overRowIndex != this.selectedRowIndex) {
			this.overRowIndex += this.topRowIndex;
			this.notify(EV_ROW_OVER, this.overRowIndex);
			this.drawSelectedRow(this.overRowIndex, this.overRowColor);
		}
	}

	private function onMouseEvtClick(e:MouseEvent): Void {
		var searchY: Float = this.gridArea.getCurrSize().y + this.headerHeight;

		if (this.selectedRowIndex > -1) {
			this.repaintRow(this.selectedRowIndex);
		}

		this.selectedRowIndex = -1;
		while (e.localY >= searchY) {
			this.selectedRowIndex++;
			searchY += this.rowHeight;
		}
		
		if (this.selectedRowIndex > -1) {
			this.selectedRowIndex += this.topRowIndex;
			this.notify(EV_ROW_SELECTED, this.selectedRowIndex);
			this.drawSelectedRow(this.selectedRowIndex, this.selectedRowColor);
		}
	}
}