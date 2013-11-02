package org.decatime.ui.component.canvas.style;

import flash.display.Graphics;

class Line extends Shape {

    public override function processMove(xpos: Float, ypos: Float): Bool {
    	if (! super.processMove(xpos, ypos)) { return false; }
    	
		this.gfx.moveTo(startX, startY);
		this.gfx.lineTo( xpos, ypos);

		return true;
    }
}