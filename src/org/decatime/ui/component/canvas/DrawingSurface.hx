package org.decatime.ui.component.canvas;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseShapeElement;

class DrawingSurface extends BaseContainer {
	private static var drawingFeedBack: BaseShapeElement;

	private var bmp : Bitmap;
	private var startx: Float;
	private var starty: Float;
	private static var swithTo: Bool;
	private var absRectangle: Rectangle;
	private var pathBuffer:Array<Float>;
	private var gfx:Graphics;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
	}

	private function onMouseDown(e:MouseEvent): Void {
		this.absRectangle = this.getBounds(this.stage);
		
		processDown(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);

		this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseMove(e:MouseEvent): Void {
		processMove(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);
	}

	private function onMouseUp(e:MouseEvent): Void {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		if (pathBuffer.length > 0) {
			var ayOfCmds: Array<Int> = new Array<Int>();
			var nbCmds: Int = Std.int(pathBuffer.length / 2);
			var ayOfPath:Array<Float> = new Array<Float>();
			for (i in 0...nbCmds) {
				ayOfCmds.push(2);
			}
			for (i in 0...pathBuffer.length) {
				ayOfPath.push(pathBuffer[i]);
			}
			gfx.drawPath(ayOfCmds, ayOfPath);
		}

		this.bmp.bitmapData.lock();
		this.bmp.bitmapData.draw(drawingFeedBack);
		this.bmp.bitmapData.unlock();

		drawingFeedBack.graphics.clear();
	}

	private function processDown(xpos:Float, ypos:Float): Void {
		startx = xpos;
		starty = ypos;
		swithTo = true;
		drawingFeedBack.graphics.lineStyle(
			3, 
			0x000000, 
			1.0, 
			false, // pixelHinting 
			flash.display.LineScaleMode.NONE, 
			flash.display.CapsStyle.ROUND, 
			flash.display.JointStyle.ROUND, 
			4
		);
		this.pathBuffer = new Array<Float>();
	}

	private function processMove(xpos:Float, ypos:Float): Void {
		var pt:Point = new Point(xpos, ypos);
		if (swithTo) {
			swithTo = false;
			gfx.drawPath([1],[pt.x, pt.y]);
		} else {
			pathBuffer.push(pt.x);
			pathBuffer.push(pt.y);

			if (pathBuffer.length >= 11) {
				gfx.drawPath(
					[2, 2, 2, 2, 2, 2],
					[pathBuffer[0], pathBuffer[1], pathBuffer[2], pathBuffer[3], 
			        pathBuffer[4], pathBuffer[5], pathBuffer[6], pathBuffer[7], 
			        pathBuffer[8], pathBuffer[9], pathBuffer[10], pathBuffer[11]
				]);
				pathBuffer = new Array<Float>();
			}
			
		}
	}

	public override function refresh(r: Rectangle): Void {
		super.refresh(r);
	}

	private override function initializeComponent() {
		super.initializeComponent();

		drawingFeedBack = new BaseShapeElement('canvas');
		this.gfx = drawingFeedBack.graphics;

		this.container.create(1.0, drawingFeedBack);
		this.addChild(drawingFeedBack);
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

		this.setChildIndex(drawingFeedBack, this.numChildren -1);
	}
}