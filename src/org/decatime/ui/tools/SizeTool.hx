package org.decatime.ui.tools;

import flash.geom.Rectangle;

class SizeTool {
	public static inline function isSameSize(r1: Rectangle, r2: Rectangle): Bool {
		return r1.width == r2.width && r1.height == r2.height;
	}
}