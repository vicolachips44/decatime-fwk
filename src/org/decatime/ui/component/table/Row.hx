package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.geom.Point;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseBitmapElement;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.TextBox;

class Row extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.component.table.Row :";
	public static var EVT_ROW_SELECTED:String = NAMESPACE + "EVT_ROW_SELECTED";

	public var rowHeight(default, null): Float;
	public var table(default, default): TableView;
	public var rowIndex(default, default): Int;

	private var cells:Array<Cell>;
	private var selected: Bool;
	private var isEditing: Bool;
	private var editedLabel: Label;
	private var editingCell: Cell;

	public function new(name:String, rHeight: Float) {
		super(name);
		this.rowHeight = rHeight;
		this.cells = new Array<Cell>();
		// this.cacheAsBitmap = true;
		this.selected = false;
		this.doubleClickEnabled = true;
	}

	public function addCell(c:Cell): Cell {
		this.cells.push(c);
		c.text.setFontRes(table.getFontRes());
		c.table = this.table;
		c.row = this;
		c.column = this.table.getColumn(this.cells.length);
		return c;
	}

	public function getCells(): Array<Cell> {
		return this.cells;
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
		this.addEventListener(MouseEvent.DOUBLE_CLICK, onRowDblClickEvt);
	}

	private function startEditor(): Void {
		// ref to the cell being edited
		editingCell = cast(editedLabel.getTagRef(), Cell);

		// ref to the editor for this cell (depends on column settings)
		var ed:ITableEditor = editingCell.column.getEditor();

		if (! this.contains(ed.getDisplayObject())) { this.addChild(ed.getDisplayObject()); }

		editedLabel.visible = false;

		var r:Rectangle = editedLabel.getCurrSize().clone();
		this.graphics.beginFill(0xffffff, 1.0);
		this.graphics.drawRect(r.x - 1, r.y, r.width - 1, r.height);
		this.graphics.endFill();

		ed.setPosition(r);
		ed.setValue(editedLabel.getText());
		ed.setVisible(true);
		this.stage.focus = ed.getDisplayObject();

		this.isEditing = true;

		this.table.addEventListener(MouseEvent.MOUSE_UP, onTblMouseUp);
	}

	private function onTblMouseUp(e:MouseEvent): Void {
		this.table.removeEventListener(MouseEvent.MOUSE_UP, onTblMouseUp);

		if (this.isEditing) {
			var ed:ITableEditor = editingCell.column.getEditor();
			editedLabel.setText(ed.getValue());

			// remove the editor
			if (this.contains(ed.getDisplayObject())) { this.removeChild(ed.getDisplayObject()); }

			trace ("the editor has been removed");
			// the edited object is visble now
			editedLabel.visible = true;
		}

		this.isEditing = false;

	}

	private function onRowDblClickEvt(e:MouseEvent): Void {
		var objs:Array<DisplayObject> = this.myStage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
		var dispObj:DisplayObject = null;

		for (dispObj in objs) {
			if (Std.is(dispObj, Label)) {
				editedLabel = cast(dispObj, Label);
				trace ("calling start editor...");
				this.startEditor();
				break;
			}
		}
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