package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.geom.Point;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.ILayoutElement;
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
	private var editedRenderer: ICellRenderer;
	private var editingCell: Cell;

	public function new(name:String, rHeight: Float) {
		super(name);
		this.rowHeight = rHeight;
		this.cells = new Array<Cell>();
		this.cacheAsBitmap = true;
		this.selected = false;
		this.doubleClickEnabled = true;
	}

	public function addCell(c:Cell): Cell {
		this.cells.push(c);
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
			var rect:Rectangle = this.cells[i].renderer.getCurrSize();
			g.drawRect(rect.x - 1, rect.y, rect.width - 1, rect.height);
		}

	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var i:Int = 0;
		for (i in 0...this.cells.length) {
			if (this.cells[i].renderer == null) {
				throw new flash.errors.Error("renderer for cells " + i + " is null");
			}
			var renderer:DisplayObject = this.cells[i].renderer.getDisplayObject();

			this.container.create(this.table.getColumn(i+1).columnWidth, cast(renderer, ILayoutElement));
			this.addChild(renderer);
		}
	}

	private override function initializeEvent(): Void {
		this.addEventListener(MouseEvent.CLICK, onRowClickEvt);
		this.addEventListener(MouseEvent.DOUBLE_CLICK, onRowDblClickEvt);
	}

	private function startEditor(): Void {
		// ref to the cell being edited
		editingCell = editedRenderer.getParentCell();

		// ref to the editor for this cell (depends on column settings)
		var ed:ICellEditor = editingCell.column.getEditor();

		if (! this.contains(ed.getDisplayObject())) { this.addChild(ed.getDisplayObject()); }

		editedRenderer.setVisible(false);

		var r:Rectangle = editedRenderer.getCurrSize().clone();
		this.graphics.beginFill(0xffffff, 1.0);
		this.graphics.drawRect(r.x - 1, r.y, r.width - 1, r.height);
		this.graphics.endFill();

		ed.setPosition(r);
		ed.setValue( editedRenderer.getValue());
		ed.setVisible(true);
		this.stage.focus = ed.getDisplayObject();

		this.isEditing = true;

		this.table.addEventListener(MouseEvent.MOUSE_UP, onTblMouseUp);
	}

	private function onTblMouseUp(e:MouseEvent): Void {
		this.table.removeEventListener(MouseEvent.MOUSE_UP, onTblMouseUp);

		if (this.isEditing) {
			var ed:ICellEditor = editingCell.column.getEditor();
			editedRenderer.setValue(ed.getValue());

			// remove the editor
			if (this.contains(ed.getDisplayObject())) { this.removeChild(ed.getDisplayObject()); }

			editedRenderer.setVisible(true);
		}

		this.isEditing = false;

	}

	private function onRowDblClickEvt(e:MouseEvent): Void {
		var objs:Array<DisplayObject> = this.myStage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
		var dispObj:DisplayObject = null;
		
		for (dispObj in objs) {
			if (Std.is(dispObj, ICellRenderer)) {
				editedRenderer = cast(dispObj, ICellRenderer);
				this.startEditor();
				break;
			}
		}
	}

	private function onRowClickEvt(e:MouseEvent): Void {
		// if my row is already the selected one...
		if (this.table.selectedRow != null && this.table.selectedRow.rowIndex == this.rowIndex) {
			return; // leave the room
		}

		this.table.selectedRow = this;

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