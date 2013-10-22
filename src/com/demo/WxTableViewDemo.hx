package com.demo;

import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

import org.decatime.ui.component.table.TableView;
import org.decatime.ui.component.table.Column;

class WxTableViewDemo extends Window implements IObserver implements IPrintable {

	private var myTable:TableView;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
	}

	private override function buildClientArea(): Void {
		this.myTable = new TableView('demoTable1', this.fontResPath);
		this.myTable.headerHeight = 24;
		this.myTable.rowHeight = 20;

		this.clientArea.create(1.0, this.myTable);
		this.addChild(this.myTable);

		this.myTable.addColumns ([
			new Column("First Name", 100),
			new Column("Last Name", 100),
			new Column("Email Name", 150),
			new Column("Age", 60)
		]);

		var i:Int = 0;
		var j: Int = 0;

		for (i in 0...5000) {
			for (j in 0...4) {
				this.myTable.addCell(i, j, 'bonjour_' + i + "_" + j);		
			}
		}
		
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		return parentAy;
	}

	// IObserver implementation END

	public override function toString() : String {
		return "2 - TableView DEMO";
	}
}