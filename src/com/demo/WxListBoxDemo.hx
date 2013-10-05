package com.demo;

import openfl.Assets;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.List;
import org.decatime.ui.component.ListItem;
import org.decatime.ui.component.RadioButtonGroup;
import org.decatime.ui.component.RadioButton;
import org.decatime.ui.component.CheckBox;
import org.decatime.ui.layout.HBox;

class WxListboxDemo extends Window {
	private override function buildClientArea(): Void {
		var txt:TextBox = new TextBox('txtInputElement');
		txt.setFontRes('assets/BepaOblique.ttf');
		txt.setTabIndex(1);
		this.clientArea.create(32, txt);
		this.addChild(txt);

		var rdbGroup:RadioButtonGroup = new RadioButtonGroup('rdbGroup1');
		var rdb1:RadioButton = new RadioButton('rdb1');
		rdb1.label.setText('Check me!');
		rdb1.label.setFontRes('assets/BepaOblique.ttf');

		var rdb2:RadioButton = new RadioButton('rdb2');
		rdb2.label.setText('Check me 2!');
		rdb2.label.setFontRes('assets/BepaOblique.ttf');

		var boxRdb:HBox = new HBox(this.clientArea);
		boxRdb.setHorizontalGap(0);
		boxRdb.setVerticalGap(0);

		boxRdb.create(0.5, rdb1);
		boxRdb.create(0.5, rdb2);

		this.clientArea.create(24, boxRdb);

		this.addChild(rdb1);
		this.addChild(rdb2);
		rdbGroup.add(rdb1);
		rdbGroup.add(rdb2);

		var chk1:CheckBox = new CheckBox('chk1');
		chk1.label.setText('Check me 2!');
		chk1.label.setFontRes('assets/BepaOblique.ttf');
		this.clientArea.create(32, chk1);
		this.addChild(chk1);

		var lbox:List = new List('list1', 'assets/BepaOblique.ttf');
		this.clientArea.create(1.0, lbox);
		this.addChild(lbox);

		var i:Int;

		for (i in 0...10000) {
			lbox.add('list item ' + i);
		}
	}
}