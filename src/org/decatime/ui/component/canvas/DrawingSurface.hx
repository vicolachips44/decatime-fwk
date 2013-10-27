package org.decatime.ui.component.canvas;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.Vector;
import flash.events.FocusEvent;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.IDisposable;

class DrawingSurface extends BaseContainer implements IDisposable {
	inline private static var BUFFER_SIZE:Int = 9;

	private var swithTo: Bool;
	private var bmp : Bitmap;
	private var drawingFeedBack: BaseSpriteElement;
	private var startx: Float;
	private var starty: Float;
	private var absRectangle: Rectangle;
	private var ayOfPathCmds:Vector<Int>;
	private var ayOfPathPoints:Vector<Float>;
	private var lastXPos: Int;
	private var lastYPos: Int;

	private var gfx:Graphics;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
	}

	public function dispose(): Void {
		this.putMeBackToReal();
		this.bmp.bitmapData.dispose();
	}

	private function onMouseDown(e:MouseEvent): Void {
		trace ("mousedown detected...");
		this.absRectangle = this.getBounds(this.stage);
		processDown(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);

		drawingFeedBack.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseMove(e:MouseEvent): Void {
		processMove(e.stageX - this.absRectangle.x, e.stageY - this.absRectangle.y);
	}

	private function onMouseUp(e:MouseEvent): Void {
		drawingFeedBack.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		#if !flash
		if (ayOfPathPoints != null && ayOfPathPoints.length > 0) {
			drawPathBuffer();
		}
		#end
		gfx.endFill();
		// this.bmp.bitmapData.lock();
		// this.bmp.bitmapData.draw(drawingFeedBack);
		// this.bmp.bitmapData.unlock();
	}

	private function processDown(xpos:Float, ypos:Float): Void {
		startx = xpos;
		starty = ypos;
		swithTo = true;
		gfx.lineStyle(
			1, 
			0xffffff, 
			1.0, 
			true, // pixelHinting 
			flash.display.LineScaleMode.HORIZONTAL, 
			flash.display.CapsStyle.ROUND, 
			flash.display.JointStyle.MITER, 
			1
		);
		gfx.beginFill(0xffffff);
		this.ayOfPathPoints = new Vector<Float>();
	}

	private function processMove(xpos:Float, ypos:Float): Void {
		var pt:Point = new Point(xpos, ypos);
		
		if (swithTo) {
			swithTo = false;
			var vint:Vector<Int> = new Vector<Int>();
			vint.push(1);

			var vfloat:Vector<Float> = new Vector<Float>();
			vfloat.push(pt.x);
			vfloat.push(pt.y);

			gfx.drawPath(vint, vfloat);
		} else {
			this.ayOfPathPoints.push(pt.x);
			this.ayOfPathPoints.push(pt.y);
			if (this.ayOfPathPoints.length >= BUFFER_SIZE) {
				drawPathBuffer();
			}
			
		}
	}

	private function init() {
		gfx.clear();

		drawingFeedBack.x = this.parent.x + this.container.getCurrSize().x;
		drawingFeedBack.y = this.parent.y + this.container.getCurrSize().y;
		gfx.beginFill(0x000000);
		gfx.drawRect(0,
			0,
			this.container.getCurrSize().width,
			this.container.getCurrSize().height
		);
		gfx.endFill();
	}

	private function drawPathBuffer(): Void {
		gfx.drawPath(
			this.ayOfPathCmds,
			this.ayOfPathPoints
		);
		
		this.ayOfPathPoints = new Vector<Float>();
	}

	private function putMeBackToReal(): Void {
		if (drawingFeedBack == null) { return; }
		if (drawingFeedBack.parent != null && Std.is(drawingFeedBack.parent, this.stage)) {
			this.stage.removeChild(drawingFeedBack);
			this.addChild(drawingFeedBack);
		}
	}

	public override function refresh(r: Rectangle): Void {
		var stage:flash.display.Stage = this.stage;

		putMeBackToReal();

		super.refresh(r);

		this.removeChild(drawingFeedBack);

		if (this.bmp.width != this.container.getCurrSize().width || this.bmp.height != this.container.getCurrSize().height) {
			this.bmp.bitmapData.dispose();
			this.bmp.bitmapData = new BitmapData(Std.int(this.container.getCurrSize().width), Std.int(this.container.getCurrSize().height), true);
		}

		stage.addChild(drawingFeedBack);
		init();
	}

	private override function initializeComponent() {
		super.initializeComponent();

		drawingFeedBack = new BaseSpriteElement('canvas');
		drawingFeedBack.isContainer = false;
		this.gfx = drawingFeedBack.graphics;
		this.ayOfPathCmds = new Vector<Int>();
		
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);

		this.container.create(1.0, drawingFeedBack);
		this.addChild(drawingFeedBack);
	}

	private override function initializeEvent(): Void {
		drawingFeedBack.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		drawingFeedBack.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		drawingFeedBack.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		
	}

	private override function layoutComponent(): Void {
		this.bmp = new Bitmap(new BitmapData(Std.int(this.container.getCurrSize().width), Std.int(this.container.getCurrSize().height), true));
		this.addChild(this.bmp);
		this.bmp.x = this.container.getCurrSize().x;
		this.bmp.y = this.container.getCurrSize().y;

		this.setChildIndex(drawingFeedBack, this.numChildren -1);
	}
}