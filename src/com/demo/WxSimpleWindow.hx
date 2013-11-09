package com.demo;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.Lib;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.windows.WindowState;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.BaseShapeElement;

import org.decatime.ui.component.Button;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.Button;
import org.decatime.ui.component.ComboBox;
import org.decatime.ui.component.LinkTextLabel;

class WxSimpleWindow extends Window implements IPrintable implements IObserver {

	private override function buildClientArea(): Void {
		var vbox1: VBox = new VBox(this);

		createField('First Name: ', vbox1, 0);
		createField('Last Name: ', vbox1, 1);
		createField('Address 1: ', vbox1, 2);
		createField('Address 2: ', vbox1, 3);
		createField('Email: ', vbox1, 4);
		createComboField(vbox1);

		var link: LinkTextLabel = new LinkTextLabel('decatime wonderpad online application');
		link.setFontRes('assets/BepaOblique.ttf');
		link.setTagRef('http://www.decatime.org/wp1/wonderpad.html');

		link.addListener(this);
		vbox1.create(20, link);
		this.addChild(link);

		this.clientArea.create(1.0, vbox1);

		createFormButtons();
	}

	private function createField(fieldName: String, box:VBox, tabIndex: Int): Void {
		var hbox1: HBox = new HBox(this);
		var lblField: TextLabel = new TextLabel(fieldName, 0x000000, 'right');
		lblField.setFontRes('assets/Vera.ttf');
		var txtField: TextBox = new TextBox('txtField', '');
		txtField.setFontRes('assets/Vera.ttf');
		txtField.setTabIndex(tabIndex);
		hbox1.create(120, lblField);
		hbox1.create(1.0, txtField);
		box.create(32, hbox1);
		this.addChild(lblField);
		this.addChild(txtField);
	}

	private function createFormButtons(): Void {
		var hbox1: HBox = new HBox(this);
		hbox1.create(1.0, new BaseShapeElement('spacer1'));
		hbox1.setVerticalGap(10);
		hbox1.setHorizontalGap(10);
		var btnSave: Button = new Button('Save', 'assets/Vera.ttf');
		hbox1.create(80, btnSave);
		this.addChild(btnSave);

		var btnCancel: Button = new Button('Cancel', 'assets/Vera.ttf');
		hbox1.create(80, btnCancel);
		this.addChild(btnCancel);

		this.clientArea.create(48, hbox1);
		btnSave.addListener(this);
		btnCancel.addListener(this);
	}

	private function createComboField(box: VBox): Void {
		var hbox1: HBox = new HBox(this);
		var lblField: TextLabel = new TextLabel('Gender: ', 0x000000, 'right');
		lblField.setFontRes('assets/Vera.ttf');
		hbox1.create(120, lblField);
		this.addChild(lblField);

		var cb1:ComboBox = new ComboBox('cb1', 'assets/Vera.ttf');
		cb1.add(new UserGender('Man'));
		cb1.add(new UserGender('Woman'));
		this.addChild(cb1);
		
		hbox1.create(1.0, cb1);
		box.create(32, hbox1);
	}

	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name, in_size, fontResPath);
    }
	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch (name) {
			case LinkTextLabel.EVT_CLICK:
				var lbl: LinkTextLabel = cast(data, LinkTextLabel);
				var url: String = lbl.getTagRef();
				Lib.getURL(new URLRequest(url));
			case Button.EVT_CLICK:
				var btn: Button = cast(data, Button);
				if (btn.name == 'Save') {
					trace ("save form requested");
				}
				if (btn.name == 'Cancel') {
					this.remove();
				}
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(LinkTextLabel.EVT_CLICK);
		parentAy.push(Button.EVT_CLICK);
		return parentAy;
	}

	public override function toString(): String {
		return "1 - Basic controls";
	}
}