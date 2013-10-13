package com.demo;

import openfl.Assets;

import flash.geom.Point;
import flash.display.Bitmap;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Row;
import org.decatime.ui.component.table.Cell;
import org.decatime.ui.component.table.EditorType;
import org.decatime.ui.component.table.TextCellRenderer;
import org.decatime.ui.component.table.CheckBoxRenderer;
import org.decatime.ui.component.IPrintable;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

class WxTableViewDemo extends Window implements IObserver implements IPrintable {

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
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch (name) {
			case TableView.EVT_ROW_SELECTED:
				
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(TableView.EVT_ROW_SELECTED);
		return parentAy;
	}

	// IObserver implementation END

	private function buildTable(): Void {
		this.myTable.addColumn('Column 1', 120);
		this.myTable.addColumn('Column 2', 160);
		this.myTable.addColumn('Chk', 30, EditorType.CHECK);
		this.myTable.addColumn('Column 4', 100);
		this.myTable.addColumn('Column 5', 100);
		this.myTable.addColumn('Column 6', 1.0);

		var fontRes: String = 'assets/Vera.ttf';
		var i:Int = 0;
		for (i in 0...500) {
			var r1:Row = new Row('row', 24);
			this.myTable.addRow(r1);

			r1.addCell(new Cell('cell_1_' + i, new TextCellRenderer(fontRes)));
			r1.addCell(new Cell('cell_2_' + i, new TextCellRenderer(fontRes)));
			r1.addCell(new Cell('1', new CheckBoxRenderer()));
			r1.addCell(new Cell('cell_4_' + i, new TextCellRenderer(fontRes)));
			r1.addCell(new Cell('cell_5_' + i, new TextCellRenderer(fontRes)));
			r1.addCell(new Cell('cell_6_' + i, new TextCellRenderer(fontRes)));
		}
	}

	public override function toString() : String {
		return "2 - TableView DEMO";
	}
}