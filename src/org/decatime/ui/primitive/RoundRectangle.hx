package org.decatime.ui.primitive;

import flash.display.Graphics;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

class RoundRectangle extends BaseDecorator {

	public override function draw(r:Rectangle): Void {
		gfx.clear();
		gfx.lineStyle(1 , 0x000099);
		gfx.drawRoundRect(r.x, r.y, r.width, r.height, 12, 12);

	}
}