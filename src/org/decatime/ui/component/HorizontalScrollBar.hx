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

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;


// TODO rework needed with another control than the textfield.
// the textfield maxscrollH and scrollH are badly reported even with flash target.
class HorizontalScrollBar extends BaseScrollBar implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.HorizontalScrollBar :";
	public static var EVT_SCROLL_LEFT:String = NAMESPACE + "EVT_SCROLL_LEFT";
	public static var EVT_SCROLL_RIGHT:String = NAMESPACE + "EVT_SCROLL_RIGHT";

	private var btnScrollLeft:ArrowButton;
	private var btnScrollRight:ArrowButton;

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ArrowButton.EVT_CLICK:
				if (data == 'btnLeft') {
					this.evManager.notify(EVT_SCROLL_LEFT, this);
				}
				if (data == 'btnRight') {
					this.evManager.notify(EVT_SCROLL_RIGHT, this);
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK
		];
	}

	private override function calculateThumbSize(r:Rectangle): Void {
		r.width = r.width - ((this.stepCount - 1) * this.stepSize);
		r.x = ((this.stepPos - 1) * this.stepSize);
	}

	private override function handleScrollEvent(e:MouseEvent): Void {
		var delta:Float = this.stage.mouseX - this.startX;
		if (delta < 0) {
			if (canGoRight(e)) { goRight(); }
		} else {
			if (canGoLeft(e)) { goLeft(); }
		}
		this.startX = e.localX;
	}

	private function canGoLeft(e:MouseEvent): Bool {
		if (! (this.stepPos > 1)) { return false; }
		if (e.localX < this.mouseDownPoint.x - this.stepSize) {
			this.mouseDownPoint = new Point(e.localX, e.localY);
			return true;
		}
		return false;
	}

	private function canGoRight(e:MouseEvent): Bool {
		if (! (this.stepPos < this.stepCount)) { return false; }
		if (e.localX > this.mouseDownPoint.x + this.stepSize) {
			this.mouseDownPoint = new Point(e.localX, e.localY);
			return true;
		}
		return false;
	}

	private function goRight(): Void {
		this.stepPos++;
		this.updatePos();
		this.notify(EVT_SCROLL_RIGHT, null);
	}
	
	private function goLeft(): Void {
		this.stepPos--;
		this.updatePos();
		this.notify(EVT_SCROLL_LEFT, null);
	}

	private override function getThumbArea(): Rectangle {
		var r:Rectangle = this.thumbContainer.getCurrSize();
		var cpRect:Rectangle = r.clone();
		cpRect.x = 0;
		cpRect.y = 4;
		cpRect.height = cpRect.height - 8;
		cpRect.width = cpRect.width;
		return cpRect;
	}

	// IObserver implementation END

	private override function initializeComponent(): Void {
		super.initializeComponent();
		
		this.container = new HBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		this.btnScrollLeft = new ArrowButton('btnLeft',ArrowButton.ORIENTATION_LEFT);
		this.btnScrollLeft.addListener(this);
		var c1:Content = this.container.create(this.sizeInfo.height, this.btnScrollLeft);

		c1.setVerticalGap(8);
		c1.setHorizontalGap(8);

		this.addChild(this.btnScrollLeft);

		this.thumb = new BaseShapeElement('thumb');
		this.thumbContainer = this.container.create(1.0, this.thumb);
		this.addChild(this.thumb);

		this.btnScrollRight = new ArrowButton('btnRight', ArrowButton.ORIENTATION_RIGHT);
		this.btnScrollRight.addListener(this);
		c1 = this.container.create(this.sizeInfo.height, this.btnScrollRight);
		c1.setVerticalGap(8);
		c1.setHorizontalGap(8);
		this.addChild(this.btnScrollRight);
		
	}
}