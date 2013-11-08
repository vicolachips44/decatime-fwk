package org.decatime.ui.primitive;

import flash.display.Graphics;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

/**
* This object will draw an arrow on the specified graphics instance.
* The consumer can set the orientation of the arrow and the size is
* setted when the draw method is called via a Rectangle constraint.
*/
class Arrow {
	/** left orientation for this button */
	public static inline var ORIENTATION_LEFT:String = "left";

	/** right orientation for this button */
	public static inline var ORIENTATION_RIGHT:String = "right";

	/** top orientation for this button */
	public static inline var ORIENTATION_TOP:String = "top";

	/** bottom orientation for this button */
	public static inline var ORIENTATION_BOTTOM:String = "bottom";

	private var gfx: Graphics;
	private var orientation: String;

	/**
	* Default constructor.
	*
	* @param in_gfx: Graphics The graphics to draw on
	* @param in_orientation: String a value (use static values from this class)
	*/
	public function new (in_gfx: Graphics, in_orientation: String) {
		this.gfx = in_gfx;
		this.orientation = in_orientation;
	}

	/**
	* Actually draws the arrow within the provided Rectangle geometry
	*
	* @param r: Rectangle the geometry constraint
	*
	* @return Void
	*/
	public function draw(r:Rectangle): Void {
		var box:Matrix = new Matrix();
		gfx.clear();

		gfx.beginFill(0x000000, 0.0);
		gfx.drawRect(r.x, r.y, r.width, r.height);
		gfx.endFill();

		var lx: Float = r.x + 2;
		var ly: Float = r.y + 2;
		var lw: Float = r.width - 6;
		var lh: Float = r.height - 6;

		gfx.lineStyle(0.4, 0x000000, 1, true, 
			LineScaleMode.VERTICAL,
			CapsStyle.NONE,
			JointStyle.ROUND);
		
		box.createGradientBox(r.width, r.height, 45, r.x, r.y);
		
		if (orientation == ORIENTATION_TOP) {	
			gfx.beginGradientFill(GradientType.LINEAR, [0x000000, 0x808080], [1, 1], [1, 255], box);
			gfx.moveTo(lx, ly + lw);
			gfx.lineTo(lx + lw, ly + lh);
			gfx.lineTo(lx + (lw / 2), ly);
			gfx.lineTo(lx, ly + lw);
		}		
		if (orientation == ORIENTATION_BOTTOM) {
			gfx.beginGradientFill(GradientType.LINEAR, [0x000000, 0x808080], [1, 1], [1, 255], box);
			gfx.moveTo(lx, ly);
			gfx.lineTo(lx + lw, ly);
			gfx.lineTo(lx + (lw / 2), ly + lw);
			gfx.lineTo(lx, ly);
		}
		if (orientation == ORIENTATION_LEFT) {
			gfx.beginGradientFill(GradientType.LINEAR, [0x000000, 0x808080], [1, 1], [1, 255], box);
			gfx.moveTo(lx + lw, ly);
			gfx.lineTo(lx + lw, ly + lh);
			gfx.lineTo(lx, ly + (lh / 2));
			gfx.lineTo(lx + lw, ly);
		}
		if (orientation == ORIENTATION_RIGHT) {
			gfx.beginGradientFill(GradientType.LINEAR, [0x000000, 0x808080], [1, 1], [1, 255], box);
			gfx.moveTo(lx, ly);
			gfx.lineTo(lx, ly + lh);
			gfx.lineTo(lx + lw, ly + (lh / 2));
			gfx.lineTo(lx, ly);
		}
		gfx.endFill();
	}
}