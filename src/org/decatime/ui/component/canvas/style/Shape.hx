package org.decatime.ui.component.canvas.style;

import flash.display.Graphics;

class Shape implements IFeedbackProvider {
	private var startX: Float;
	private var startY: Float;
	private var lastXPos: Float;
	private var lastYPos: Float;

	private var gfx:Graphics;

	public function new(gfx: Graphics) {
		this.gfx = gfx;
		
	}

	public function processDown(xpos: Float, ypos: Float) : Void {
    	startX = xpos;
		startY = ypos;
    }


    public function processMove(xpos: Float, ypos: Float): Bool {
    	if (lastXPos == xpos && lastYPos == ypos) { return false; }

    	this.gfx.clear();

    	StyleManager.getInstance().prepareActiveStyle();
    	
		lastYPos = ypos;
		lastXPos = xpos;
		
		return true;
    }

    public function processUp(xpos: Float, ypos: Float): Void {
    	
    }
}