package org.decatime.ui.primitive;

import flash.display.Graphics;
import flash.geom.Rectangle;

class RoundRectangle extends BaseDecorator {

	public override function draw(r:Rectangle): Void {
		gfx.clear();
		gfx.lineStyle(1 , 0x000000);
		gfx.drawRoundRect(r.x, r.y, r.width, r.height, 12, 12);

	}
}