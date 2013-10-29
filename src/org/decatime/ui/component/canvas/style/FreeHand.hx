package org.decatime.ui.component.canvas.style;

import flash.display.Graphics;
import flash.Vector;
import flash.geom.Point;

class FreeHand implements IStyleProvider {
	inline private static var BUFFER_SIZE:Int = 3;

	private var swithTo: Bool;
	private var gfx:Graphics;
	private var ayOfPathCmds:Vector<Int>;
	private var ayOfPathPoints:Vector<Float>;

	public function new(gfx: Graphics) {
		this.gfx = gfx;
		this.ayOfPathCmds = new Vector<Int>();
		
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
	}
	
    public function processDown(xpos: Float, ypos: Float) : Void {
    	swithTo = true;
		gfx.lineStyle(
			3, 
			0x000000, 
			1.0, 
			true, // pixelHinting 
			flash.display.LineScaleMode.NONE, 
			flash.display.CapsStyle.NONE, 
			flash.display.JointStyle.ROUND, 
			3
		);
		this.ayOfPathPoints = new Vector<Float>();
    }


    public function processMove(xpos: Float, ypos: Float): Void {
    	var pt:Point = new Point(xpos, ypos);
		
		if (swithTo) {
			swithTo = false;
			var vint:Vector<Int> = new Vector<Int>();
			vint.push(1);

			var vfloat:Vector<Float> = new Vector<Float>();
			vfloat.push(pt.x);
			vfloat.push(pt.y);

			gfx.drawPath(vint, vfloat, flash.display.GraphicsPathWinding.NON_ZERO);
		} else {
			this.ayOfPathPoints.push(pt.x);
			this.ayOfPathPoints.push(pt.y);
			if (this.ayOfPathPoints.length >= BUFFER_SIZE) {
				drawPathBuffer();
			}
		}
    }

    private function drawPathBuffer(): Void {
		gfx.drawPath(
			this.ayOfPathCmds,
			this.ayOfPathPoints,
			flash.display.GraphicsPathWinding.NON_ZERO
		);
		this.ayOfPathPoints = new Vector<Float>();
	}

    public function processUp(xpos: Float, ypos: Float): Void {
    	#if !flash
		if (ayOfPathPoints != null && ayOfPathPoints.length > 0) {
			drawPathBuffer();
		}
		#end
    }
}