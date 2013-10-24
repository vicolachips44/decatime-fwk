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

		g.lineStyle(1 ,0x000000, 1.0);
		g.drawCircle(this.shp.getCurrSize().width / 2, this.shp.getCurrSize().height / 2, 6);

		if (selected) {
			g.beginFill(0x000000, 1);
			g.drawCircle(this.shp.getCurrSize().width / 2, this.shp.getCurrSize().height / 2, 3);
			g.endFill();
		}

		this.shp.y = this.sizeInfo.y - 4;
	}
}