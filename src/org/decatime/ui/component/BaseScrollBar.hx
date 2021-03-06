package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.geom.Matrix;
import flash.events.MouseEvent;

import org.decatime.ui.layout.Content;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseShapeElement;

class BaseScrollBar extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";
	public static var EVT_SCROLL:String = NAMESPACE + "EVT_SCROLL";

	private var thumb:BaseShapeElement;
	private var thumbContainer:Content;
	private var shUp:BaseShapeElement;
	private var shDown:BaseShapeElement;
	private var shThumb:BaseShapeElement;

	private var stepCount:Int;
	private var lastStepCount:Int;
	private var stepPos:Int;
	private var lastStepPos: Int;
	private var stepSize:Int;
	private var scrolling:Bool;
	private var startX:Float;
	private var thumbStartX:Float;
	private var startY:Float;
	private var thumbStartY:Float;
	private var mouseDownPoint:Point;


	public function new(name:String) {
		super(name);
		this.stepPos = 1;
		this.lastStepPos = -1;
		this.stepCount = 1;
		this.stepSize = 2;
		this.lastStepCount = -1;
		this.scrolling = false;
		this.startX = 0;
		this.startY = 0;
	}

	public function setStepCount(value:Int): Void {
		if (this.scrolling) {return; }
		this.stepCount = value;
	}

	public function getStepCount(): Int {
		return this.stepCount;
	}

	public function setStepPos(value:Int): Void {
		if (this.scrolling) { return; }
		this.stepPos = value;
	}

	public function getStepPos(): Int {
		return this.stepPos;
	}

	public function setStepSize(value:Int): Void {
		this.stepSize = value;
	}

	public function getStepSize(): Int {
		return this.stepSize;
	}

	public function isScrolling(): Bool {
		return scrolling;
	}

	public function updatePos(): Void {
		this.drawThumbPos(this.getThumbArea());
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		//Background of the scrollbar
		graphics.clear();
		graphics.beginFill(0x000000, 0.3);
		graphics.drawRect(r.x, r.y, r.width, r.height);
		graphics.endFill();

		// Innerline of the scrollbar
		this.graphics.lineStyle(2, 0xa1a1a1, 0.9);
		this.graphics.drawRect(r.x + 2, r.y + 2, r.width - 4, r.height - 4);
		
		this.graphics.endFill();
	}

	private function onScrollbarMouseDown(e:MouseEvent): Void {
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpEvt);

		this.mouseDownPoint = new Point(this.mouseX, this.mouseY);

		if (thumb.getRect(this).containsPoint(this.mouseDownPoint)) {
			if (hasNoScrollSpace()) {
				this.scrolling = false;
			} else {
				this.startX = e.stageX - e.localX;
				this.startY = e.stageY - e.localY;
				this.thumbStartX = thumb.mouseX;
				this.thumbStartY = thumb.mouseY;
				this.scrolling = true;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseThumbMove);
			}
		} else {
			this.scrolling = false;
		}
	}

	private function hasNoScrollSpace(): Bool {
		return false;
	}

	private function endScroll(): Void {
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseThumbMove);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpEvt);
		this.scrolling = false;
	}

	private function onMouseThumbMove(e:MouseEvent): Void {
		this.handleScrollEvent(e);	
	}

	private function handleScrollEvent(e:MouseEvent): Void {
		trace ("warning this method should be overrided");
	}

	private function onStageMouseUpEvt(e:MouseEvent): Void {
		endScroll();
	}

	private function drawThumbPos(r:Rectangle): Void {
		if (lastStepPos == stepPos && lastStepCount == stepCount) {
			return;
		}
		var g:Graphics = this.thumb.graphics;

		g.clear();

		drawGradiant(g, r);
		
		this.calculateThumbSize(r);

		g.drawRect(r.x, r.y, r.width, r.height);

		g.endFill();
	}

	private function drawGradiant(g:Graphics, r:Rectangle): Void {
		var box:Matrix = new Matrix();
		box.createGradientBox(r.width, r.height);
		g.beginGradientFill(GradientType.LINEAR, [0x333333, 0xdddddd], [1, 1], [1, 255], box);
	}

	private function getThumbArea(): Rectangle {
		var r:Rectangle = this.thumbContainer.getCurrSize();
		var cpRect:Rectangle = r.clone();
		return cpRect;
	}

	private function calculateThumbSize(r:Rectangle): Void {
		trace ("warning this method should be overrided");
	}

	private override function initializeComponent(): Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, onScrollbarMouseDown);
	}
}