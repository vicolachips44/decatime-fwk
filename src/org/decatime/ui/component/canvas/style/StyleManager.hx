package org.decatime.ui.component.canvas.style;

import flash.display.Shape;
import flash.display.Graphics;
import flash.filters.BitmapFilter;

class StyleManager {
	public static inline var FREEHAND: String = "Free hand";
	public static inline var LINE: String = "Line";
	public static inline var SQUARE: String = "Square";
	public static inline var CIRCLE: String = "Circle";

	private static var instance: StyleManager;

	private var layer: Shape;
	private var activeFilters: Array<BitmapFilter>;

	public var activeFeedback(default, null): IFeedbackProvider;

	private function new(in_layer: Shape) {
		this.layer = in_layer;
		this.activeFeedback = new FreeHand(this.layer.graphics);
	}

	public static function getInstance(?in_layer: Shape): StyleManager {
		if (in_layer != null) {
			instance = new StyleManager(in_layer);
		}
		return instance;
	}

	public function setActiveStyle(style: String): Void {
		switch (style) {
			case FREEHAND:
				this.activeFeedback = new FreeHand(this.layer.graphics);
			case LINE:
				this.activeFeedback = new Line(this.layer.graphics);
			case SQUARE:
				this.activeFeedback = new Square(this.layer.graphics);
			case CIRCLE:
				this.activeFeedback = new Circle(this.layer.graphics);
		}
	}

	public function prepareActiveStyle(): Void {
		var gfx: Graphics = this.layer.graphics;
		gfx.lineStyle(
			4, 
			0x000000, 
			1.0, 
			false, // pixelHinting 
			flash.display.LineScaleMode.NORMAL, 
			flash.display.CapsStyle.ROUND, 
			flash.display.JointStyle.ROUND, 
			2
		);
	}
}