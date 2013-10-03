package com.demo;

import openfl.Assets;

import org.decatime.ui.component.Window;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.ListItem;

class WxListboxDemo extends Window {
	private override function buildClientArea(): Void {
		var txt:TextBox = new TextBox('txtInputElement');
		txt.setFontRes('assets/BepaOblique.ttf');
		txt.setTabIndex(1);
		this.clientArea.create(32, txt);
		this.addChild(txt);

		var lbox:ListBox = new ListBox('listbox1');
		lbox.setListItemHeight(20);
		this.clientArea.create(1.0, lbox);
		this.addChild(lbox);
		var i:Int;

		for (i in 0...100) {
			var item:ListItem = new ListItem('listItem' + i);
			item.visible = false;
			item.label.setFontRes('assets/BepaOblique.ttf');
			item.label.setFontSize(14);
			item.label.setText('item ' + i);
			lbox.addItem(item);
		}
	}
}