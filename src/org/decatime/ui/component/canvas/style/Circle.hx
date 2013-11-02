package org.decatime.ui.component.canvas.style;

import flash.display.Graphics;

class Circle extends Shape {

    public override function processMove(xpos: Float, ypos: Float): Bool {
    	if (! super.processMove(xpos, ypos)) { return false; }

    	this.gfx.drawCircle( startX , startY , xpos  - startX );
    	
    	return true;
    }
}