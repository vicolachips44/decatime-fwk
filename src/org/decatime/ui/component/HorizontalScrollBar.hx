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
import org.decatime.ui.primitive.Arrow;

// TODO enable client color settings
class HorizontalScrollBar extends BaseScrollBar implements IObserver  {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.HorizontalScrollBar :";
	public static var EVT_SCROLL_RIGHT:String = NAMESPACE + "EVT_SCROLL_RIGHT";
	public static var EVT_SCROLL_LEFT:String = NAMESPACE + "EVT_SCROLL_LEFT";

	private var btnScrollRight:ArrowButton;
	private var btnScrollLeft:ArrowButton;
	private var leftPos:Float;
	private var rightPos:Float;
	private var visibleWidth:Float;
	private var nbVisible:Int;
	private var hPct:Float;
	private var thumbWidth:Float;
	private var thumbMinWidth:Float = 16;

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ArrowButton.EVT_CLICK:
				if (data == 'btnLeft' && this.stepPos > 0) {
					this.stepPos--;
					this.evManager.notify(EVT_SCROLL_LEFT, this.stepPos);
					this.thumb.x = this.getThumbPosFromStepPos();
				}
				if (data == 'btnRight' && this.stepPos < (this.stepCount - nbVisible)) {
					this.stepPos++;
					this.evManager.notify(EVT_SCROLL_RIGHT, this.stepPos);
					this.thumb.x = this.getThumbPosFromStepPos();
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK
		];
	}

	public function setVisibleWidth(value:Float): Void {
		this.visibleWidth = value;
	}

	// IObserver implementation END

	public override function updatePos(): Void {
		super.updatePos();
		this.thumb.x = this.getThumbPosFromStepPos();
	}

	private override function hasNoScrollSpace(): Bool {
		return thumb.width == this.thumbContainer.getCurrSize().width;
	}

	private override function drawGradiant(g:Graphics, r:Rectangle): Void {
		var box:Matrix = new Matrix();
		box.createGradientBox(r.width, r.height, 190);
		g.beginGradientFill(GradientType.LINEAR, [0x333333, 0xdddddd], [1, 1], [1, 255], box);
	}

	private override function calculateThumbSize(r:Rectangle): Void {
		var totalWidth:Float = this.stepCount * this.stepSize;
		
		hPct = r.width / (totalWidth - this.visibleWidth);

		// if needed total Width is less then the rectangle Width
		// we don't change the size.
		if (Math.abs(hPct) > 1) {  hPct = 1; }

		// target Width
		thumbWidth = r.width * hPct;

		if (thumbWidth < this.thumbMinWidth) {
			thumbWidth = this.thumbMinWidth;
		}
		r.width = thumbWidth;

		// the leftPosition in pixel
		leftPos = this.thumbContainer.getCurrSize().x + this.thumbContainer.getVerticalGap();
		rightPos = this.thumbContainer.getCurrSize().x + this.thumbContainer.getCurrSize().width - thumbWidth;
		nbVisible = Std.int(this.visibleWidth / this.stepSize);
	}

	private override function handleScrollEvent(e:MouseEvent): Void {
		var newX:Float = e.stageX - this.startX - this.thumbStartX;
		// if the position is within the allowed range
		if (newX >= leftPos && newX <= rightPos) {
			// apply the new Y position
			this.thumb.x = newX;

			// compute the new position value (steppos)
			var newpos:Int = this.getStepPosFromThumbPos();
			trace ("newpos value is " + newpos);
			if (newpos < this.stepPos) {
				// it's less than the previous one
				this.notify(EVT_SCROLL_LEFT, newpos);
			} else {
				// it's greater than the previous one
				this.notify(EVT_SCROLL_RIGHT, newpos);
			}
			// the stepPos becomes the newpos
			this.stepPos = newpos;
		}
	}

	private function getStepPosFromThumbPos(): Int {
		var pos:Float = this.thumb.x - this.thumbContainer.getCurrSize().x;
		
		var coarse:Float = pos / (rightPos - leftPos);

		var result:Float = ((this.stepCount + 1) * coarse) - (nbVisible * coarse);

		return Std.int(result);
	}

	private function getThumbPosFromStepPos(): Int {
		var coarse:Float = this.stepPos / (this.stepCount - nbVisible);
		var result:Float = (coarse * (rightPos - leftPos) + this.thumbContainer.getCurrSize().x);
		return Std.int(result);
	}

	private override function getThumbArea(): Rectangle {
		var r:Rectangle = this.thumbContainer.getCurrSize();
		var cpRect:Rectangle = r.clone();
		cpRect.x = 0;
		cpRect.y = 4;
		cpRect.height = cpRect.height - 8;
		return cpRect;
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();
		// Our main container is a VBOX
		this.container = new HBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		this.btnScrollLeft = new ArrowButton('btnLeft', Arrow.ORIENTATION_LEFT);
		this.btnScrollLeft.addListener(this);
		var c1:Content = this.container.create(this.sizeInfo.height, this.btnScrollLeft);
		c1.setVerticalGap(4);
		c1.setHorizontalGap(4);

		this.addChild(this.btnScrollLeft);

		this.thumb = new BaseShapeElement('thumb');
		this.thumbContainer = this.container.create(1.0, this.thumb);
		this.addChild(this.thumb);

		
		this.btnScrollRight = new ArrowButton('btnRight',Arrow.ORIENTATION_RIGHT);
		this.btnScrollRight.addListener(this);
		var c1:Content = this.container.create(this.sizeInfo.height, this.btnScrollRight);
		
		c1.setVerticalGap(4);
		c1.setHorizontalGap(4);

		this.addChild(this.btnScrollRight);
	}
}