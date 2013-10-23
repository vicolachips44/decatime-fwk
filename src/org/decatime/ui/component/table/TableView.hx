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
	
	public var spreadLastColumn(default, default): Bool;
	public var rowHeight(default, default): Float;
	public var headerHeight(default, default): Float;
	public var selectedRowIndex(default, null): Int;

	private var topRowIndex:Int;
	private var bottomRowIndex: Int;
	private var vsBar1: VerticalScrollBar;
	private var gridArea: VBox;
	private var gridSprite: BaseSpriteElement;
	private var visibleItemsCount: Int;

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
		this.selectedRowIndex = -1;
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

	public function getBottomRowIndx(): Int {
		return this.bottomRowIndex;
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
					this.topRowIndex = this.getRowCount() - this.visibleItemsCount;
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
		var g:Graphics = this.gridSprite.graphics;//this.graphics;
		g.clear();

		drawBackground(g, this.sizeInfo);
		locate();
		drawGrid(g);
		
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
		var col: Column = null;
		for (col in columns) {
			col.draw(g);
		}
		if (this.selectedRowIndex > -1) {
			this.drawSelectedRow(g);
		}
	}

	private function drawBackground(g:Graphics, r:Rectangle): Void {
		g.beginFill(0xffffff);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
	}

	private function drawSelectedRow(g:Graphics): Void {
		var rcoord:Float = this.selectedRowIndex - this.topRowIndex;
		var x: Float = this.gridArea.getCurrSize().x;
		var y: Float = this.gridArea.getCurrSize().y + (rcoord * this.rowHeight) + this.headerHeight;
		var w: Float = this.gridArea.getCurrSize().width;
		var h: Float = this.rowHeight;

		g.beginFill(0xcccccc, 0.7);
		g.drawRect(x, y, w, h);
		g.endFill();
	}

	private function updateScrollBar(): Void {
		if (this.vsBar1 == null) { return; }
		// the thumb is being dragged
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(this.getRowCount());
		this.vsBar1.setStepPos(this.topRowIndex);
		this.vsBar1.setStepSize(Std.int(this.rowHeight));
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
		
		this.addChild(this.vsBar1);
		this.addChild(gridSprite);
	}

	private function onMouseEvtClick(e:MouseEvent): Void {
		trace (e.localY);
		var searchY: Float = this.gridArea.getCurrSize().y + this.headerHeight;
		this.selectedRowIndex = -1;
		while (e.localY >= searchY) {
			this.selectedRowIndex++;
			searchY += this.rowHeight;
		}
		if (this.selectedRowIndex > -1) {
			this.selectedRowIndex += this.topRowIndex;
		}
		drawGrid(this.gridSprite.graphics);
	}
}