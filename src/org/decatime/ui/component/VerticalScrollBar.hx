package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.geom.Matrix;

import org.decatime.ui.layout.Content;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

// TODO enable client color settings
class VerticalScrollBar extends BaseScrollBar implements IObserver  {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.VerticalScrollBar :";
	public static var EVT_SCROLL_UP:String = NAMESPACE + "EVT_SCROLL_UP";
	public static var EVT_SCROLL_DOWN:String = NAMESPACE + "EVT_SCROLL_DOWN";

	// private var container:VBox;
	private var btnScrollUp:ArrowButton;
	private var btnScrollDown:ArrowButton;

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ArrowButton.EVT_CLICK:
				if (data == 'btnUp') {
					this.evManager.notify(EVT_SCROLL_UP, this);
				}
				if (data == 'btnDown') {
					this.evManager.notify(EVT_SCROLL_DOWN, this);
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK
		];
	}

	// IObserver implementation END

	private override function calculateThumbSize(r:Rectangle): Void {
		r.height = r.height - ((this.stepCount - 1) * this.stepSize);
		r.y = ((this.stepPos - 1) * this.stepSize);
	}

	private override function handleScrollEvent(e:MouseEvent): Void {
		var delta:Float = this.stage.mouseY - this.startY;
		if (delta < 0) {
			if (canStepUp(e)) { stepUp(); }
		} else {
			if (canStepDown(e)) { stepDown(); }
		}
		this.startY = e.localY;
	}

	private function canStepUp(e:MouseEvent): Bool {
		if (! (this.stepPos > 1)) { return false; }
		if (e.localY < this.mouseDownPoint.y - this.stepSize) {
			this.mouseDownPoint = new Point(e.localX, e.localY);
			return true;
		}
		return false;
	}

	private function canStepDown(e:MouseEvent): Bool {
		if (! (this.stepPos < this.stepCount)) { return false; }
		if (e.localY > this.mouseDownPoint.y + this.stepSize) {
			this.mouseDownPoint = new Point(e.localX, e.localY);
			return true;
		}
		return false;
	}

	private function stepUp(): Void {
		this.stepPos--;
		this.updatePos();
		this.notify(EVT_SCROLL_UP, null);
	}
	
	private function stepDown(): Void {
		this.stepPos++;
		this.updatePos();
		this.notify(EVT_SCROLL_DOWN, null);
	}

	private override function initializeComponent(): Void {
		// Our main container is a VBOX
		this.container = new VBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		this.btnScrollUp = new ArrowButton('btnUp',ArrowButton.ORIENTATION_TOP);
		this.btnScrollUp.addListener(this);
		var c1:Content = this.container.create(this.sizeInfo.width, this.btnScrollUp);
		
		c1.setVerticalGap(8);
		c1.setHorizontalGap(8);

		this.addChild(this.btnScrollUp);

		this.thumb = new BaseShapeElement('thumb');
		this.thumbContainer = this.container.create(1.0, this.thumb);
		this.addChild(this.thumb);

		this.btnScrollDown = new ArrowButton('btnDown', ArrowButton.ORIENTATION_BOTTOM);
		this.btnScrollDown.addListener(this);
		var c1:Content = this.container.create(this.sizeInfo.width, this.btnScrollDown);
		c1.setVerticalGap(8);
		c1.setHorizontalGap(8);

		this.addChild(this.btnScrollDown);
	}
}