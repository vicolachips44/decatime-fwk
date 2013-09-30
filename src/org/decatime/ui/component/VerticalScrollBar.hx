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
import org.decatime.ui.layout.VBox;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

// TODO enable client color settings
class VerticalScrollBar extends BaseScrollBar implements IObserver  {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.VerticalScrollBar :";
	public static var EVT_SCROLL_UP:String = NAMESPACE + "EVT_SCROLL_UP";
	public static var EVT_SCROLL_DOWN:String = NAMESPACE + "EVT_SCROLL_DOWN";

	private var btnScrollUp:ArrowButton;
	private var btnScrollDown:ArrowButton;
	private var topPos:Float;
	private var bottomPos:Float;
	private var visibleHeight:Float;
	private var nbVisible:Int;
	private var hPct:Float;
	private var thumbMinHeight:Float = 16;

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ArrowButton.EVT_CLICK:
				if (data == 'btnUp' && this.stepPos < this.stepCount) {
					this.stepPos--;
					this.evManager.notify(EVT_SCROLL_DOWN, this.stepPos);
				}
				if (data == 'btnDown' && this.stepPos > 1) {
					this.stepPos++;
					this.evManager.notify(EVT_SCROLL_UP, this.stepPos);
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK
		];
	}

	public function setVisibleHeight(value:Float): Void {
		this.visibleHeight = value;
	}

	// IObserver implementation END

	private override function calculateThumbSize(r:Rectangle): Void {
		var totalHeight:Float = this.stepCount * this.stepSize;

		hPct = r.height / (totalHeight - this.visibleHeight);

		// if needed total height is less then the rectangle height
		// we don't change the size.
		if (hPct > 1) {  hPct = 1; }

		// target height
		var newHeight:Float = r.height * hPct;

		// the y position
		r.y = (this.stepPos * newHeight) - newHeight;

		if (newHeight < this.thumbMinHeight) {
			newHeight = this.thumbMinHeight;
		}
		r.height = newHeight;

		// the topPosition in pixel
		topPos = this.thumbContainer.getCurrSize().y + this.thumbContainer.getVerticalGap();
		bottomPos = this.thumbContainer.getCurrSize().y + this.thumbContainer.getCurrSize().height - newHeight;
		nbVisible = Std.int(this.visibleHeight / this.stepSize);
	}

	private override function handleScrollEvent(e:MouseEvent): Void {
		var newY:Float = e.stageY - this.startY - this.thumbStartY;

		// if the position is within the allowed range
		if (newY >= topPos && newY <= bottomPos) {
			// apply the new Y position
			this.thumb.y = newY;

			// compute the new position value (steppos)
			var newpos:Int = this.getStepPosFromThumbPos();

			if (newpos < this.stepPos) {
				// it's less than the previous one
				this.notify(EVT_SCROLL_UP, newpos);
			} else {
				// it's greater than the previous one
				this.notify(EVT_SCROLL_DOWN, newpos);
			}
			// the stepPos becomes the newpos
			this.stepPos = newpos;
		}
	}

	private function getStepPosFromThumbPos(): Int {
		var pos:Float = this.thumb.y - this.thumbContainer.getCurrSize().y;
		
		var coarse:Float = pos / (bottomPos - topPos);

		var result:Float = ((this.stepCount + 1) * coarse) - (nbVisible * coarse);

		return Std.int(result);
	}

	private override function getThumbArea(): Rectangle {
		var r:Rectangle = this.thumbContainer.getCurrSize();
		var cpRect:Rectangle = r.clone();
		cpRect.x = 4;
		cpRect.y = 0;
		cpRect.width = cpRect.width - 8;
		cpRect.height = cpRect.height;
		return cpRect;
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();
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