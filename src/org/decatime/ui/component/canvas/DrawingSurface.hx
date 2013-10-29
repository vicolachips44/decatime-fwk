package org.decatime.ui.component.canvas;

import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.events.Event;
import flash.display.Shape;


import org.decatime.ui.component.IDisposable;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.canvas.style.FreeHand;

class DrawingSurface extends BaseContainer implements IDisposable implements IObserver {

	private var parentWindow: Window;
	private var drawingFeedBack: Shape;
	private var absRectangle: Rectangle;
	private var gfx:Graphics;
	private var style: FreeHand;

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
			case Window.EVT_DEACTIVATE:
				drawingFeedBack.visible = false;
			case Window.EVT_ACTIVATE:
				drawingFeedBack.visible = true;
		}
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
		drawingFeedBack = null;
	}

	private function onMouseDown(e:MouseEvent): Void {
		this.absRectangle = this.getBounds(this.stage);

		style.processDown(e.stageX - absRectangle.x, e.stageY - absRectangle.y);

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseMove(e:MouseEvent): Void {
		if (! absRectangle.contains(e.stageX, e.stageY)) {
			onMouseUp(null);
			return;
		}
		style.processMove(e.stageX - absRectangle.x, e.stageY - absRectangle.y);
	}
	
	private function onMouseUp(e:MouseEvent): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

		if (e == null) { return; }
		
		style.processUp(e.stageX - absRectangle.x, e.stageY - absRectangle.y);
	}

	private function addFeedback(): Void {
		if (drawingFeedBack != null) { return; }

		drawingFeedBack = new Shape();
		drawingFeedBack.name = "drawingFeedBack";
		drawingFeedBack.cacheAsBitmap = true;

		stage.addChild(drawingFeedBack);
		
		gfx = this.drawingFeedBack.graphics;
		this.style = new FreeHand(gfx);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}


	public override function refresh(r: Rectangle): Void {
		super.refresh(r);

		addFeedback();
		if (gfx != null) { gfx.clear(); }
		this.absRectangle = this.getBounds(this.stage);

		drawingFeedBack.x = this.absRectangle.x; // FIXME does not take care of gapping
		drawingFeedBack.y = this.absRectangle.y;
	}
}