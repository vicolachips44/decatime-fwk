package org.decatime.ui.component.canvas;

import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.events.Event;
import flash.display.Shape;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.BlurFilter;
import flash.filters.BitmapFilter;
import flash.display.GradientType;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.decatime.ui.component.IDisposable;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.canvas.style.StyleManager;

class DrawingSurface extends BaseContainer implements IDisposable implements IObserver {

	private var parentWindow: Window;
	private var drawingFeedBack: Shape;
	private var layer1: Bitmap;
	private var absRectangle: Rectangle;
	private var gfx:Graphics;
	private var styManager: StyleManager;
	private var urManager: UndoRedoManager;

	public function new(name:String) {
		super(name);
		this.elBackColorVisibility = 1.0;
	}

	public function setParentWindow(value: Window): Void {
		this.parentWindow = value;
		this.parentWindow.addListener(this);
	}

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case Window.EVT_MOVING:
			    var pt:Point = cast(data, Point);
				drawingFeedBack.x = pt.x + this.container.getCurrSize().x + 3;
				drawingFeedBack.y = pt.y + this.container.getCurrSize().y;

				layer1.x = pt.x + this.container.getCurrSize().x + 3;
				layer1.y = pt.y + this.container.getCurrSize().y;

			case Window.EVT_DEACTIVATE:
				drawingFeedBack.visible = false;
				layer1.visible = false;
			case Window.EVT_ACTIVATE:
				drawingFeedBack.visible = true;
				layer1.visible = true;
		}
	}

	public function undo(): Bool {
		return this.urManager.undo();
	}

	public function canUndo(): Bool {
		return this.urManager.canUndo();
	}

	public function redo(): Bool {
		return this.urManager.redo();
	}

	public function canRedo(): Bool {
		return this.urManager.canRedo();
	}

	public function getEventCollection(): Array<String> {
		return [
			Window.EVT_MOVING
		];
	}

	public function dispose(): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

		gfx.clear();

		stage.removeChild(drawingFeedBack);
		stage.removeChild(this.layer1);
		urManager.initialize();

		drawingFeedBack = null;
		layer1 = null;
		urManager = null;
	}

	private function onMouseDown(e:MouseEvent): Void {
		this.absRectangle = this.getBounds(this.stage);
		if (! this.absRectangle.containsPoint(new Point(e.stageX, e.stageY))) {
			return;
		}

		stage.setChildIndex(drawingFeedBack, stage.numChildren - 1);
		this.styManager.activeStyle.processDown(e.stageX - absRectangle.x, e.stageY - absRectangle.y);

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseMove(e:MouseEvent): Void {
		if (! absRectangle.contains(e.stageX, e.stageY)) {
			onMouseUp(null);
			return;
		}
		this.styManager.activeStyle.processMove(e.stageX - absRectangle.x, e.stageY - absRectangle.y);
	}
	
	private function onMouseUp(e:MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

		if (e != null) { 
			this.styManager.activeStyle.processUp(e.stageX - absRectangle.x, e.stageY - absRectangle.y);
		}
		
		drawCache();
		this.gfx.clear();
		stage.setChildIndex(this.layer1, stage.numChildren - 1);
	}

	private function drawCache(): Void {
		this.layer1.bitmapData.draw(this.drawingFeedBack);
		urManager.update();
	}

	private function initialize(): Void {
		if (gfx != null) { gfx.clear(); }

		if (urManager == null) {
			urManager = new UndoRedoManager();
			urManager.setUndoLevel(32);
		}

		urManager.initialize();

		if (layer1 == null) { layer1 = new Bitmap(); }

		layer1.bitmapData = new BitmapData(Std.int(this.sizeInfo.width), Std.int(this.sizeInfo.height), true, 0x000000);
		urManager.setData(layer1.bitmapData);

		urManager.update();

		if (drawingFeedBack == null) {
			drawingFeedBack = new Shape();
			drawingFeedBack.name = "drawingFeedBack";
			drawingFeedBack.cacheAsBitmap = true;


			stage.addChild(drawingFeedBack);
			stage.addChild(layer1);
			
			this.styManager = new StyleManager(this.drawingFeedBack);

			gfx = this.drawingFeedBack.graphics;

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}


	public override function refresh(r: Rectangle): Void {
		super.refresh(r);

		this.absRectangle = this.getBounds(this.stage);
		initialize();

		drawingFeedBack.x = this.absRectangle.x; // FIXME does not take care of gapping
		drawingFeedBack.y = this.absRectangle.y;

		layer1.x = this.absRectangle.x; // FIXME does not take care of gapping
		layer1.y = this.absRectangle.y;
	}
}