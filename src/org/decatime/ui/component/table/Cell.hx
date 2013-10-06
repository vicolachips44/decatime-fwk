package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.BaseSpriteElement;

class Cell extends BaseSpriteElement {

	public function new(content:String) {
		super(content);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		var g:Graphics = this.graphics;
		
		g.clear();

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);
	}
}