package org.decatime.ui.component.canvas;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.geom.Point;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseShapeElement;

class DrawingSurface extends BaseContainer {
	private var drawingFeedBack: BaseShapeElement;
	private var bmp : Bitmap;

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
		e.stopImmediatePropagation();
	}

	private function onMouseUp(e:MouseEvent): Void {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		this.bmp.bitmapData.draw(this.drawingFeedBack);
		this.drawingFeedBack.graphics.clear();
	}

	private function processDown(xpos:Float, ypos:Float): Void {
		startx = xpos;
		starty = ypos;
		swithTo = true;
		this.drawingFeedBack.graphics.lineStyle(
			3, 
			0x000000, 
			1.0, 
			true, // pixelHinting 
			flash.display.LineScaleMode.NONE, 
			flash.display.CapsStyle.ROUND, 
			flash.display.JointStyle.ROUND, 
			4
		);
	}

	private function processMove(xpos:Float, ypos:Float): Void {
		var posX:Float = xpos;
		var posY:Float = ypos;
		if (swithTo) {
			drawingFeedBack.graphics.moveTo(posX, posY);
			swithTo = false;
		} else {
			drawingFeedBack.graphics.lineTo( xpos, ypos);
		}
	}

	public override function refresh(r: Rectangle): Void {
		super.refresh(r);
	}

	private override function initializeComponent() {
		super.initializeComponent();

		this.drawingFeedBack = new BaseShapeElement('canvas');
		
		this.container.create(1.0, this.drawingFeedBack);
		this.addChild(this.drawingFeedBack);
		
	}

	private override function initializeEvent(): Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
	}

	private override function layoutComponent(): Void {
		this.bmp = new Bitmap(new BitmapData(Std.int(this.container.getCurrSize().width), Std.int(this.container.getCurrSize().height), true));
		this.addChild(this.bmp);
		this.bmp.x = this.container.getCurrSize().x;
		this.bmp.y = this.container.getCurrSize().y;

		this.setChildIndex(this.drawingFeedBack, this.numChildren -1);
	}
}