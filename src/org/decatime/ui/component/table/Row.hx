package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;

class Row extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.component.table.Row :";
	public static var EVT_ROW_SELECTED:String = NAMESPACE + "EVT_ROW_SELECTED";

	public var rowHeight(default, null): Float;
	public var table(default, default): TableView;
	public var rowIndex(default, default): Int;

	private var cells:Array<Cell>;
	private var selected: Bool;
	
	public function new(name:String, rHeight: Float) {
		super(name);
		this.rowHeight = rHeight;
		this.cells = new Array<Cell>();
		this.cacheAsBitmap = true;
		this.selected = false;
	}

	public function addCell(c:Cell): Cell {
		this.cells.push(c);
		c.text.setFontRes(table.getFontRes());
		return c;
	}

	public override function refresh(r:Rectangle): Void {
		r.y = (this.rowIndex - 1) * rowHeight;
		super.refresh(r);
		this.graphics.clear();
		this.draw();
		
	}

	public function setSelected(value:Bool): Void {
		this.selected = value;
		this.draw();
	}

	public function draw(): Void {
		var g:Graphics = this.graphics;

		g.clear();
		var r:Rectangle = this.getCurrSize();

		if (this.selected) {
			g.beginFill(0xaaaaaa, 0.7);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
		}

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);

		var i:Int = 0;
		for (i in 0...this.cells.length) {
			var rect:Rectangle = this.cells[i].text.getCurrSize();
			g.drawRect(rect.x - 1, rect.y, rect.width - 1, rect.height);
		}

	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var i:Int = 0;
		for (i in 0...this.cells.length) {
			this.container.create(this.table.getColumn(i+1).columnWidth, this.cells[i].text);
			this.addChild(this.cells[i].text);
		}
	}

	private override function initializeEvent(): Void {
		this.addEventListener(MouseEvent.CLICK, onRowClickEvt);
	}


	private function onRowClickEvt(e:MouseEvent): Void {
		trace ("click trapped on rowIndex " + this.rowIndex);

		// we give the focus to the parent control (ScrollPanel)
		this.myStage.focus = this.parent;

		var lrow:Row = null;
		for (lrow in this.table.getRows()) {
			if (lrow.rowIndex != this.rowIndex) {
				lrow.setSelected(false);
			}
		}

		this.setSelected(true);
		this.notify(EVT_ROW_SELECTED, this.rowIndex);
		
	}
}