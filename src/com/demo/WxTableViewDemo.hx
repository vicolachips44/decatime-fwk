package com.demo;

import openfl.Assets;

import flash.geom.Point;
import flash.display.Bitmap;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Column;
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
		myTable = new TableView('DemoTable');
		myTable.backgroundPicture = new Bitmap(openfl.Assets.getBitmapData('assets/test_picture.jpg'));
		// buildTable();
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
		// myTable.rowCount = 100;

		// myTable.addColumn(new Column('Column 1', 120));
		// myTable.addColumn(new Column('Column 2', 100));
		// myTable.addColumn(new Column('Column 3', 180));

		// var i:Int = 0;
		// for (i in 0...myTable.rowCount) {
		// 	myTable.getColumn(0).addCell(new Cell('Essai_0_' + i));
		// 	myTable.getColumn(1).addCell(new Cell('Essai_1_' + i));
		// 	myTable.getColumn(2).addCell(new Cell('Essai_2_' + i));
		// }
	}
}