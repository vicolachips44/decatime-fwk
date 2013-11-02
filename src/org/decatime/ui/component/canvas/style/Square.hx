package org.decatime.ui.component.canvas.style;

import flash.display.Graphics;

class Square extends Shape {

    public override function processMove(xpos: Float, ypos: Float): Bool {
    	if (! super.processMove(xpos, ypos)) { return false; }

    	this.gfx.drawRect(startX, startY , xpos - startX , ypos - startY);
    	return true;
    }
}