package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.geom.Matrix;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

class ArrowButton extends BaseSpriteElement  implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	public static inline var ORIENTATION_LEFT:String = "left";
	public static inline var ORIENTATION_RIGHT:String = "right";
	public static inline var ORIENTATION_TOP:String = "top";
	public static inline var ORIENTATION_BOTTOM:String = "bottom";

	private var initialized:Bool;
	private var orientation:String;
	private var evManager:EventManager;

	public function new(name:String, orientation: String) {
		super(name);
		evManager = new EventManager(this);
		this.orientation = orientation;
		this.isContainer = false;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		// TODO draw the button (we draw it once only since the size should not change)
		if (! this.initialized) {
			this.drawArrow();
		}
		this.initialized = true;
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

	// TODO Fix me since its ugly...
	private function drawArrow(): Void {
		var box:Matrix = new Matrix();
		box.createGradientBox(20, 20);

		var g:Graphics = this.graphics;
		g.clear();

		g.lineStyle(1, 0x808080, 0.5);
		g.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		g.beginGradientFill(GradientType.LINEAR, [0x444444, 0xffffff], [1, 1], [1, 255], box);
		if (orientation == ORIENTATION_TOP) {
			g.moveTo(0, this.sizeInfo.width);
			g.lineTo(this.sizeInfo.width, this.sizeInfo.width);
			g.lineTo(this.sizeInfo.width / 2, 0);
			g.lineTo(0, this.sizeInfo.width);
		}		
		if (orientation == ORIENTATION_BOTTOM) {
			g.moveTo(0, 0);
			g.lineTo(this.sizeInfo.width, 0);
			g.lineTo(this.sizeInfo.width / 2, this.sizeInfo.width);
			g.lineTo(0, 0);
		}
		if (orientation == ORIENTATION_LEFT) {
			g.moveTo(this.sizeInfo.width, 0);
			g.lineTo(this.sizeInfo.width, this.sizeInfo.height);
			g.lineTo(0, this.sizeInfo.height / 2);
			g.lineTo(this.sizeInfo.width, 0);
		}
		if (orientation == ORIENTATION_RIGHT) {
			g.moveTo(0, 0);
			g.lineTo(0, this.sizeInfo.height);
			g.lineTo(this.sizeInfo.height, this.sizeInfo.width / 2);
			g.lineTo(0, 0);
		}
		g.endFill();
	}

	private function onMouseClick(e:MouseEvent): Void {
		// Relay the click event on me
		evManager.notify(EVT_CLICK, this.name);
	}
}