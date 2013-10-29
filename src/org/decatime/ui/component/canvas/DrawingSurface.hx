package org.decatime.ui.component.canvas;

import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.Vector;
import flash.events.FocusEvent;
import flash.events.Event;
import flash.display.Shape;


import org.decatime.ui.component.IDisposable;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

import org.decatime.ui.component.windows.Window;

class DrawingSurface extends BaseContainer implements IDisposable implements IObserver {
	inline private static var BUFFER_SIZE:Int = 3;

	private var parentWindow: Window;

	private var swithTo: Bool;
	private var bmp : Bitmap;
	private var drawingFeedBack: Shape;
	private var startx: Float;
	private var starty: Float;
	private var absRectangle: Rectangle;
	private var ayOfPathCmds:Vector<Int>;
	private var ayOfPathPoints:Vector<Float>;
	private var ayOfPt: Vector<Point>;
	private var lastXPos: Int;
	private var lastYPos: Int;

	private var gfx:Graphics;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
	}

	public function setParentWindow(value: Window): Void {
		this.parentWindow = value;
		this.parentWindow.addListener(this);
		this.parentWindow.addEventListener(flash.events.Event.DEACTIVATE, onWindowDeactivated);
	}

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case Window.EVT_MOVING:
			var pt:Point = cast(data, Point);
				drawingFeedBack.x = pt.x + this.container.getCurrSize().x + 3;
				drawingFeedBack.y = pt.y + this.container.getCurrSize().y;
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			Window.EVT_MOVING
		];
	}

	public function dispose(): Void {
		trace ("drawingFeedBack disposing");
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

		gfx.clear();
		stage.removeChild(drawingFeedBack);
		drawingFeedBack = null;
		trace ("drawingFeedBack disposed");
	}

	private function onWindowDeactivated(e:Event): Void {
		trace ("my window has been deactivated");
	}

	private function onMouseDown(e:MouseEvent): Void {
		this.absRectangle = this.getBounds(this.stage);

		processDown(e.stageX - absRectangle.x, e.stageY - absRectangle.y);

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function processDown(xpos:Float, ypos:Float): Void {
		startx = xpos;
		starty = ypos;
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
		this.ayOfPt = new Vector<Point>();
	}

	private function onEnterFrame(e:Event): Void {
		var posx: Float = this.stage.mouseX;
		var posy: Float = this.stage.mouseY;
		if (! absRectangle.contains(posx, posy)) {
			onMouseUp(null);
		}
		processMove(posx, posy);
	}

	private function onMouseMove(e:MouseEvent): Void {
		if (! absRectangle.contains(e.stageX, e.stageY)) {
			onMouseUp(null);
		}
		processMove(e.stageX - absRectangle.x, e.stageY - absRectangle.y);
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
	
	private function onMouseUp(e:MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

		#if !flash
		if (ayOfPathPoints != null && ayOfPathPoints.length > 0) {
			drawPathBuffer();
		}
		#end
	}

	private function addFeedback(): Void {
		if (drawingFeedBack != null) { return; }
		trace ("adding feedback");
		drawingFeedBack = new Shape();
		drawingFeedBack.name = "drawingFeedBack";
		drawingFeedBack.cacheAsBitmap = true;
		stage.addChild(drawingFeedBack);
		
		gfx = this.drawingFeedBack.graphics;
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}


	public override function refresh(r: Rectangle): Void {
		super.refresh(r);

		addFeedback();
		if (gfx != null) { gfx.clear(); }
		this.absRectangle = this.getBounds(this.stage);

		drawingFeedBack.x = this.absRectangle.x + 3;
		drawingFeedBack.y = this.absRectangle.y;
	}

	private override function initializeComponent() {
		super.initializeComponent();
		
		this.ayOfPathCmds = new Vector<Int>();
		
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
	}
}