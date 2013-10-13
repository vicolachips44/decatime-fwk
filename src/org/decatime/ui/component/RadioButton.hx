package org.decatime.ui.component;

import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.layout.HBox;

class RadioButton extends CheckBox {

	public function new(name:String) {
		super(name);
		
		// The click event is managed by the RadioButtonGroup instance
		this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	private override function draw(): Void {
		if (! this.visible) { return; }

		var g:Graphics = this.shp.graphics;
		g.clear();

		if (! this.label.getTransparentBackground()) {
			g.beginFill(this.label.getBackColor(), 1);
			g.drawRect(0, 0, this.shp.getCurrSize().width, this.shp.getCurrSize().height);
			g.endFill();
		}

		g.lineStyle(1 ,0x000000, 1.0);
		g.drawCircle(this.shp.getCurrSize().width / 2, this.shp.getCurrSize().height / 2, 6);

		if (selected) {
			g.beginFill(0x000000, 1);
			g.drawCircle(this.shp.getCurrSize().width / 2, this.shp.getCurrSize().height / 2, 3);
			g.endFill();
		}
	}
}