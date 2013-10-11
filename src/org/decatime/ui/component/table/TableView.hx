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
	private var scPanel: ScrollPanel;
	private var headerArea: HBox;
	private var headerSprite: BaseSpriteElement;
	private var rowsCount: Int;
	private var rowHeight: Int;
	private var headerHeight: Int;
	private var columns: IntMap<Column>;
	private var columnsCount: Int;
	private var rows: IntMap<Row>;
	private var fontRes:String;

	public function new(name:String, fRes: String) {
		super(name);
		this.scPanel = new ScrollPanel('scPanel1');
		this.rowHeight = 24;
		this.headerHeight = 24;
		this.columns = new IntMap<Column>();
		this.rows = new IntMap<Row>();
		this.columnsCount = 0;
		this.rowsCount = 0;
		this.fontRes = fRes;
	}

	public function getFontRes(): String {
		return this.fontRes;
	}

	public function addColumn(headerText: String, colWidth: Float): Column {
		this.columnsCount++;

		var c:Column = new Column(headerText, colWidth);
		c.headerLabel.setFontRes(this.fontRes);
		c.headerLabel.setText(headerText);
		this.columns.set(this.columnsCount, c);

		return c;
	}

	public function getColumn(idx:Int): Column {
		return this.columns.get(idx);
	}

	public function addRow(lrow:Row): Void {
		this.rowsCount++;
		lrow.table = this;
		lrow.rowIndex = this.rowsCount;
		this.rows.set(this.rowsCount, lrow);
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

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);

		this.scPanel.refresh(this.scPanel.getCurrSize());
	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(2);
		this.container.setHorizontalGap(2);

		var hareaBox: HBox = new HBox(this.container);
		hareaBox.setHorizontalGap(0);
		hareaBox.setVerticalGap(0);
		this.container.create(this.headerHeight, hareaBox);

		this.headerArea = new HBox(this.container);
		this.headerArea.setHorizontalGap(1);
		this.headerArea.setVerticalGap(0);

		hareaBox.create(1.0, this.headerArea);
		hareaBox.create(this.headerHeight, new VBox(hareaBox)); // spacer
		
		this.container.create(1.0, this.scPanel);
		this.addChild(this.scPanel);

		var i:Int = 1;
		for (i in 1...this.columnsCount + 1) {
			this.headerArea.create(this.columns.get(i).columnWidth, this.columns.get(i));
			this.addChild(this.columns.get(i));
		}

		var scArea:VBox = this.scPanel.getScrollAreaContainer();
		
		for (i in 1...this.rowsCount + 1) {
			scArea.create(
				this.rows.get(i).rowHeight, 
				this.rows.get(i) 
			);
			this.scPanel.getScrollArea().addChild(this.rows.get(i));
		}
	}
}