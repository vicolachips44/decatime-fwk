package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

import org.decatime.ui.layout.Content;
import org.decatime.ui.layout.BoxBase;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.BaseShapeElement;

class BaseScrollBar extends BaseSpriteElement implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";
	public static var EVT_SCROLL:String = NAMESPACE + "EVT_SCROLL";

	private var container:BoxBase;
	private var thumb:BaseShapeElement;
	private var thumbContainer:Content;
	private var initialized:Bool;
	private var evManager:EventManager;

	private var shUp:BaseShapeElement;
	private var shDown:BaseShapeElement;
	private var shThumb:BaseShapeElement;

	private var stepCount:Int;
	private var stepPos:Int;
	private var stepSize:Int;

	public function new(name:String) {
		super(name);
		evManager = new EventManager(this);
		this.stepPos = 1;
		this.stepCount = 1;
		this.stepSize = 2;
	}

	public function setStepCount(value:Int): Void {
		this.stepCount = value;
	}

	public function getStepCount(): Int {
		return this.stepCount;
	}

	public function setStepPos(value:Int): Void {
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

	public function updatePos(): Void {
		this.drawThumbPos(this.getThumbArea());
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (! this.initialized){
			initializeComponent();
		}
		this.initialized = true;

		// Background of the scrollbar
		graphics.clear();
		graphics.beginFill(0x000000, 0.2);
		graphics.drawRect(r.x, r.y, r.width, r.height);
		graphics.endFill();

		// Innerline of the scrollbar
		this.graphics.lineStyle(2, 0xa1a1a1, 0.9);
		this.graphics.drawRect(r.x + 2, r.y + 2, r.width - 4, r.height - 4);
		this.container.refresh(r);
		if (this.thumbContainer != null) {
			this.drawThumbPos(this.getThumbArea());		
		} else {
			trace ("warning: thumbContainer instance is null");
		}
		
	}

	// IObservable implementation
	public function addListener(observer:IObserver): Void {
		evManager.addListener(observer);
	}
	public function removeListener(observer:IObserver): Void {
		evManager.removeListener(observer);
	}

	public function notify(name:String, data:Dynamic): Void {
		evManager.notify(name, data);
	}
	// IObservable implementation END

	private function drawThumbPos(r:Rectangle): Void {
		var g:Graphics = this.thumb.graphics;
		g.clear();
		g.beginFill(0x80aabf, 1.0);
		this.calculateThumbSize(r);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
	}

	private function getThumbArea(): Rectangle {
		var r:Rectangle = this.thumbContainer.getCurrSize();
		var cpRect:Rectangle = r.clone();
		cpRect.x = 4;
		cpRect.y = 0;
		cpRect.width = cpRect.width - 8;
		cpRect.height = cpRect.height;
		return cpRect;
	}

	private function calculateThumbSize(r:Rectangle): Rectangle {
		trace ("warning this method should be overrided");
		return r;
	}

	private function initializeComponent(): Void {
		trace ("warning. This method should be overrided");
	}
}