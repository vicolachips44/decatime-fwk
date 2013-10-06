package com.demo;

import flash.geom.Point;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Column;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

class WxTableViewDemo extends Window implements IObserver {

	private var myTable:TableView;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
		this.setTitle('Table view demo');
	}

	private override function buildClientArea(): Void {
		myTable = new TableView('DemoTable');
		buildTable();
		this.clientArea.create(1.0, myTable);
		this.addChild(myTable);
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		
	}

	public function getEventCollection(): Array<String> {
		return [
		];
	}

	private function buildTable(): Void {
		myTable.rowCount = 10;

		myTable.addColumn(new Column('Column 1', 32));
		myTable.addColumn(new Column('Column 2', 100));
		myTable.addColumn(new Column('Column 3', 80));

		var i:Int = 0;
		for (i in 0...myTable.rowCount) {
			// TODO add some cells
		}
	}
}