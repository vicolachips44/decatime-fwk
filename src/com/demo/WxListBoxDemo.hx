package com.demo;


import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.RadioButtonGroup;
import org.decatime.ui.component.RadioButton;
import org.decatime.ui.component.CheckBox;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

import com.demo.MyListboxObj;

class WxListBoxDemo extends Window implements IObserver implements IPrintable {
	private var txt:TextBox;

	private override function buildClientArea(): Void {
		this.txt = new TextBox('txtInputElement');
		txt.setFontRes('assets/Vera.ttf');
		txt.setTabIndex(1);
		this.clientArea.create(32, txt);
		this.addChild(txt);

		var rdbGroup:RadioButtonGroup = new RadioButtonGroup('rdbGroup1');
		var rdb1:RadioButton = new RadioButton('rdb1');
		rdb1.label.setText('Check me!');
		rdb1.setSelItemSize(12);
		rdb1.label.setFontRes('assets/Vera.ttf');

		var rdb2:RadioButton = new RadioButton('rdb2');
		rdb2.label.setText('Check me 2!');
		rdb2.setSelItemSize(12);
		rdb2.label.setFontRes('assets/Vera.ttf');

		var boxRdb:HBox = new HBox(this.clientArea);
		boxRdb.setHorizontalGap(0);
		boxRdb.setVerticalGap(0);

		boxRdb.create(0.5, rdb1);
		boxRdb.create(0.5, rdb2);

		this.clientArea.create(40, boxRdb);

		this.addChild(rdb1);
		this.addChild(rdb2);
		rdbGroup.add(rdb1);
		rdbGroup.add(rdb2);

		var chk1:CheckBox = new CheckBox('chk1');
		chk1.setSelItemSize(12);
		chk1.label.setText('Check me 2!');
		chk1.label.setFontRes('assets/Vera.ttf');
		this.clientArea.create(40, chk1);
		this.addChild(chk1);

		var lbox:ListBox = new ListBox('list1', 'assets/Vera.ttf');
		this.clientArea.create(1.0, lbox);
		this.addChild(lbox);
		lbox.addListener(this);
		var i:Int;

		for (i in 0...10000) {
			lbox.add(new MyListboxObj(i));
		}
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch (name) {
			case ListBox.EVT_ITEM_SELECTED:
				this.txt.text = Std.string(data);
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(ListBox.EVT_ITEM_SELECTED);
		return parentAy;
	}

	public override function toString() : String {
		return "2 - Listbox DEMO";
	}
}