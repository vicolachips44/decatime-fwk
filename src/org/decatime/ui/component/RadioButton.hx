package org.decatime.ui.component;

import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.layout.HBox;

// TODO the RadioButton instance should belong to a group
class RadioButton extends CheckBox {

	public function new(name:String) {
		super(name);
		this.removeEventListener(MouseEvent.CLICK, onMouseClick);
	}

	private override function draw(): Void {
		if (! this.visible) { return; }

		var g:Graphics = this.chk.graphics;
		g.clear();

		if (! this.label.getTransparentBackground()) {
			g.beginFill(this.label.getBackColor(), 1);
			g.drawRect(0, 0, this.chk.getCurrSize().width, this.chk.getCurrSize().height);
			g.endFill();
		}

		g.lineStyle(1 ,0x000000, 1.0);
		g.drawCircle(this.chk.getCurrSize().width / 2, this.chk.getCurrSize().height / 2, 6);

		if (selected) {
			g.beginFill(0x000000, 1);
			g.drawCircle(this.chk.getCurrSize().width / 2, this.chk.getCurrSize().height / 2, 3);
			g.endFill();
		}
	}
}