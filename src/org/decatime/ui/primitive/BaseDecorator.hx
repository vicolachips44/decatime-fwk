package org.decatime.ui.primitive;

import flash.display.Graphics;
import flash.geom.Rectangle;

class BaseDecorator {
	
	private var gfx: Graphics;

	public function new (in_gfx: Graphics) {
		this.gfx = in_gfx;
	}

	public function draw(r:Rectangle): Void {
		gfx.clear();
	}
}