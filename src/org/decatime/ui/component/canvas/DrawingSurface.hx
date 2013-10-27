package org.decatime.ui.component.canvas;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.Vector;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseShapeElement;

class DrawingSurface extends BaseContainer {
	private static var drawingFeedBack: BaseShapeElement;
	inline private static var BUFFER_SIZE:Int = 11;

	private var bmp : Bitmap;
	private var startx: Float;
	private var starty: Float;
	private static var swithTo: Bool;
	private var absRectangle: Rectangle;
	private var ayOfPathCmds:Vector<Int>;
	private var ayOfPathPoints:Vector<Float>;
	private var realParent:flash.display.DisplayObjectContainer;

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
		e.stopPropagation();
		e.stopImmediatePropagation();
	}

	private function onMouseUp(e:MouseEvent): Void {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		#if !flash
		if (ayOfPathPoints != null && ayOfPathPoints.length > 0) {
			drawPathBuffer();
		}
		#end
		
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

	private function drawPathBuffer(): Void {
		gfx.drawPath(
			this.ayOfPathCmds,
			this.ayOfPathPoints
		);
		this.ayOfPathPoints = new Vector<Float>();
	}

	public override function refresh(r: Rectangle): Void {
		var stage:flash.display.Stage = this.stage;

		if (this.realParent == null) {
			this.realParent = this.parent;
		}

		if (Std.is(this.parent, this.stage)) {
			trace ("removing my self from the stage");
			this.stage.removeChild(this);
			trace ("adding my self to the parent");
			this.realParent.addChild(this);
		}

		super.refresh(r);

		trace ("putting me back on the stage");

		this.parent.removeChild(this);

		this.x = this.realParent.x;
		this.y = this.realParent.y;

		stage.addChild(this);
		stage.setChildIndex(this, this.stage.numChildren - 1);
	}

	private override function initializeComponent() {
		super.initializeComponent();

		drawingFeedBack = new BaseShapeElement('canvas');
		this.gfx = drawingFeedBack.graphics;
		this.ayOfPathCmds = new Vector<Int>();
		
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);
		this.ayOfPathCmds.push(2);

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