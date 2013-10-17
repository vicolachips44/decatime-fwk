package org.decatime.ui.component.canvas;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseShapeElement;

class DrawingSurface extends BaseContainer {
	private var drawing: BaseShapeElement;
	private var startx: Float;
	private var starty: Float;
	private var swithTo: Bool;
	private var absRectangle: Rectangle;
	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
	}

	private function onMouseDown(e:MouseEvent): Void {
		this.absRectangle = this.getBounds(this.stage);
		processDown(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);

		this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 2147483647);
		this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseMove(e:MouseEvent): Void {
		processMove(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);
		e.stopPropagation();
	}

	private function onMouseUp(e:MouseEvent): Void {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function processDown(xpos:Float, ypos:Float): Void {
		startx = xpos;
		starty = ypos;
		swithTo = true;
	}

	private function processMove(xpos:Float, ypos:Float): Void {
		var posX:Float = xpos;
		var posY:Float = ypos;
		if (swithTo) {
			drawing.graphics.moveTo(posX, posY);
			swithTo = false;
		} else {
			drawing.graphics.lineTo( xpos, ypos);
		}
	}

	public override function refresh(r: Rectangle): Void {
		super.refresh(r);
	}

	private override function initializeComponent() {
		super.initializeComponent();

		this.drawing = new BaseShapeElement('canvas');
		this.drawing.graphics.lineStyle(
			3, 
			0x000000, 
			1.0, 
			true, // pixelHinting 
			flash.display.LineScaleMode.NONE, 
			flash.display.CapsStyle.ROUND, 
			flash.display.JointStyle.ROUND, 
			4
		);
		this.container.create(1.0, this.drawing);
	}

	private override function initializeEvent(): Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
	}

	private override function layoutComponent(): Void {
		this.addChild(this.drawing);
	}
}