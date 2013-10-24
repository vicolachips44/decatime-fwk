package com.demo;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.component.Label;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.ComboBox;

import org.decatime.ui.component.menu.MenuBar;
import org.decatime.ui.component.menu.MenuItem;

class WxMenuDemo extends Window implements IPrintable implements IObserver {
	private var mnuBar: MenuBar;

	private override function buildClientArea(): Void {
		this.mnuBar = new MenuBar('assets/Vera.ttf');

		this.mnuBar.addItem(new MenuItem('File'));
		this.mnuBar.addItem(new MenuItem('Edit'));
		this.mnuBar.addItem(new MenuItem('Projects'));
		this.mnuBar.addItem(new MenuItem('About'));
		
		this.clientArea.create(24, this.mnuBar);
		this.addChild(this.mnuBar);
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

	// IPrintable implementation BEGIN

	public override function toString(): String {
		return "5 - Menu Demo";
	}

	// IPrintable implementation END
}