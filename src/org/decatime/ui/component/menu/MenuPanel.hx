package org.decatime.ui.component.menu;
import flash.Lib;

import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.layout.VBox;

class MenuPanel extends BaseContainer {

	private var menuItems: Array<MenuItem>;

	public function new(name:String) {
		super(name);
		this.menuItems = new Array<MenuItem>();
		this.elBackColorVisibility = 1.0;
		this.elBackColor = 0xbbbbbb;
	}

	public function addMenuItem(item:MenuItem): Void {
		this.menuItems.push(item);
		item.setParentPanel(this);
	}

	public function showHide(r: Rectangle): Void {
		this.refresh(r);
		if (stage == null) {
			flash.Lib.current.stage.addChild(this);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onStageMouseUp);
		} else {
			stage.removeChild(this);
		}
	}

	private function onStageMouseUp(e:flash.events.MouseEvent): Void {
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onStageMouseUp);
		stage.removeChild(this);
	}

	public function getIsVisible(): Bool {
		return stage != null;
	}

	public function close(): Void {
		if (this.stage != null) {
			stage.removeChild(this);
		}
	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);
		var item:MenuItem = null;

		for (item in this.menuItems) {
			this.container.create(20, item);
			this.addChild(item);
		}
	}
}