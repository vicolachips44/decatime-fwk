package com.demo;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.component.Label;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.ComboBox;

class WxComboBoxDemo extends Window implements IPrintable implements IObserver {


	private override function buildClientArea(): Void {

		var lblList1:Label = new Label('list of values 1: ', 0x000000, 'right');
		lblList1.setFontRes('assets/Vera.ttf');
		this.addChild(lblList1);

		var lblList2:Label = new Label('list of values 2: ', 0x000000, 'right');
		lblList2.setFontRes('assets/Vera.ttf');
		this.addChild(lblList2);

		var cb1:ComboBox = new ComboBox('cb1', 'assets/Vera.ttf');
		cb1.add(new MyListboxObj(1));
		cb1.add(new MyListboxObj(2));
		cb1.add(new MyListboxObj(3));
		this.addChild(cb1);

		var cb2:ComboBox = new ComboBox('cb2', 'assets/Vera.ttf');
		cb2.add(new MyListboxObj(4));
		cb2.add(new MyListboxObj(5));
		cb2.add(new MyListboxObj(6));
		cb2.add(new MyListboxObj(7));
		cb2.add(new MyListboxObj(8));
		cb2.add(new MyListboxObj(9));
		cb2.add(new MyListboxObj(10));
		cb2.add(new MyListboxObj(11));
		cb2.add(new MyListboxObj(12));
		this.addChild(cb2);
		
		var hbox1: HBox = new HBox(this.clientArea);
		hbox1.create(100, lblList1);
		hbox1.create(1.0, cb1);

		var hbox2: HBox = new HBox(this.clientArea);
		hbox2.create(100, lblList2);
		hbox2.create(1.0, cb2);

		this.clientArea.create(32, hbox1);
		this.clientArea.create(32, hbox2);
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		// switch (name) {
		// 	case ListBox.EVT_ITEM_SELECTED:
		// 		this.txt.text = Std.string(data);
		// }
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		// parentAy.push(ListBox.EVT_ITEM_SELECTED);
		return parentAy;
	}

	// IObserver implementation END

	// IPrintable implementation BEGIN

	public override function toString(): String {
		return "4 - ComboBox Demo";
	}

	// IPrintable implementation END
}