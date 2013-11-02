package org.decatime.ui.component.canvas.style;

import flash.display.Shape;

class StyleManager {

	private var layer: Shape;
	public var activeStyle(default, default): IFeedbackProvider;

	public function new(in_layer: Shape) {
		this.layer = in_layer;
		this.activeStyle = new FreeHand(this.layer.graphics);
	}
}