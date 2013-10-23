package com.demo;

import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Column;
import org.decatime.ui.component.table.Cell;

class WxTableViewDemo extends Window implements IObserver implements IPrintable {

	private var myTable:TableView;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
	}

	private override function buildClientArea(): Void {
		this.myTable = new TableView('demoTable1', this.fontResPath);
		this.myTable.headerHeight = 26;
		this.myTable.rowHeight = 20;

		this.clientArea.create(1.0, this.myTable);
		this.addChild(this.myTable);

		this.myTable.addColumns ([
			new Column("First Name", 100),
			new Column("Last Name", 100),
			new Column("Email Name", 150),
			new Column("Age", 60)
		]);

		var r:Int = 0;
		var c: Int = 0;

		for (r in 0...1400) {
			for (c in 0...4) {
				this.myTable.addCell(r, c, 'row_' + r + "_col" + c);		
			}
		}
		this.myTable.addListener(this);
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch (name) {
			case TableView.EV_ROW_SELECTED:
				var rowIndex:Int = Std.parseInt(Std.string(data));
				var c:Cell = this.myTable.getCellAt(rowIndex, 0);
				var value: String = c.getContent();
				trace ("the value of cell zero is " + value);
				value = "new value !";
				c.setContent(value);
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(TableView.EV_ROW_SELECTED);
		return parentAy;
	}

	// IObserver implementation END

	public override function toString() : String {
		return "2 - TableView DEMO";
	}
}