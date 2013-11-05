package org.decatime.ui.component;

import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;

class CheckBox extends BaseSelected {

	private override function draw(): Void {
		if (! this.visible) { return; }
		var g:Graphics = this.shp.graphics;
		g.clear();

		g.lineStyle(1 ,0x000000, 1.0);
		
		g.drawRect(0, 0, this.shp.getCurrSize().width, this.shp.getCurrSize().height);

		if (selected) {
			g.lineStyle(2 ,0x000000, 1.0);
			g.moveTo(0, 0);
			g.lineTo(this.shp.getCurrSize().width, this.shp.getCurrSize().height);
			g.moveTo(0, this.shp.getCurrSize().height);
			g.lineTo(this.shp.getCurrSize().width, 0);
		}
	}

	private override function onMouseDown(e:MouseEvent): Void {
		this.selected = ! this.selected;
		draw();
		evManager.notify(BaseSelected.EVT_CLICK, this);
	}
}