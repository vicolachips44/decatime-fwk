package com.demo;

import openfl.Assets;

import flash.geom.Point;
import flash.display.Bitmap;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Row;
import org.decatime.ui.component.table.Cell;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

class WxTableViewDemo extends Window implements IObserver {

	private var myTable:TableView;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
		this.setTitle('Table view demo');
	}

	private override function buildClientArea(): Void {
		myTable = new TableView('DemoTable', 'assets/Vera.ttf');
		myTable.addListener(this);
		buildTable();
		this.clientArea.create(1.0, myTable);
		this.addChild(myTable);
		trace ("the client area is now builded");
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch (name) {
			case TableView.EVT_ROW_SELECTED:
				trace ("row " + data + " selected event from table view");
				var r:Row = this.myTable.getRows().get(data);
				var c:Cell = null;
				for (c in r.getCells()) {
					trace ("text of cell: " + c.text.getText());
				}
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(TableView.EVT_ROW_SELECTED);
		return parentAy;
	}

	private function buildTable(): Void {
		this.myTable.addColumn('Column 1', 120);
		this.myTable.addColumn('Column 2', 160);
		this.myTable.addColumn('Column 3', 120);
		this.myTable.addColumn('Column 4', 1.0);

		var i:Int = 0;
		for (i in 0...200) {
			var r1:Row = new Row('row', 24);
			this.myTable.addRow(r1);

			r1.addCell(new Cell('cell_1_' + i));
			r1.addCell(new Cell('cell_2_' + i));
			r1.addCell(new Cell('cell_3_' + i));
			r1.addCell(new Cell('cell_4_' + i));
		}
	}
}