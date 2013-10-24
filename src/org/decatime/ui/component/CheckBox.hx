package org.decatime.ui.component;

import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.layout.HBox;

class CheckBox extends BaseSelected {

	private override function draw(): Void {
		if (! this.visible) { return; }
		var g:Graphics = this.shp.graphics;
		g.clear();

		g.lineStyle(1 ,0x000000, 1.0);
		var originX:Float = (this.shp.getCurrSize().width / 2) - 6;
		var originY:Float = (this.shp.getCurrSize().height / 2) - 14;

		g.drawRect(originX, originY, 12, 12);

		if (selected) {
			g.lineStyle(2 ,0x000000, 1.0);
			g.moveTo(originX, originY);
			g.lineTo(originX + 12, originY + 12);
			g.moveTo(originX, originY + 12);
			g.lineTo(originX + 12, originY);
		}
	}

	private override function onMouseDown(e:MouseEvent): Void {
		this.selected = ! this.selected;
		draw();
		evManager.notify(BaseSelected.EVT_CLICK, this);
	}
}