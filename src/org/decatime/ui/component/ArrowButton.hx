package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.filters.BlurFilter;
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
	private var blurFx:BlurFilter;

	public function new(name:String, orientation: String) {
		super(name);
		evManager = new EventManager(this);
		this.orientation = orientation;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
		this.blurFx = new BlurFilter(2, 2, 2);
		this.filters = [blurFx];
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		this.drawArrow();
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
		var g:Graphics = this.graphics;
		g.clear();

		g.lineStyle(0.4, 0xffffff, 1, true, 
			flash.display.LineScaleMode.VERTICAL,
			flash.display.CapsStyle.NONE, 
			flash.display.JointStyle.ROUND);

		
		
		if (orientation == ORIENTATION_TOP) {	
			box.createGradientBox(this.sizeInfo.width, this.sizeInfo.height, 90, this.sizeInfo.x, this.sizeInfo.y);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x0000da], [1, 1], [1, 255], box);
			g.moveTo(this.sizeInfo.x, this.sizeInfo.y + this.sizeInfo.width);
			g.lineTo(this.sizeInfo.x + this.sizeInfo.width, this.sizeInfo.y + this.sizeInfo.height);
			g.lineTo(this.sizeInfo.x + (this.sizeInfo.width / 2), this.sizeInfo.y);
			g.lineTo(this.sizeInfo.x, this.sizeInfo.y + this.sizeInfo.width);
		}		
		if (orientation == ORIENTATION_BOTTOM) {
			box.createGradientBox(this.sizeInfo.width, this.sizeInfo.height, 180, this.sizeInfo.x, this.sizeInfo.y);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x0000da], [1, 1], [1, 255], box);
			g.moveTo(this.sizeInfo.x, this.sizeInfo.y);
			g.lineTo(this.sizeInfo.x + this.sizeInfo.width, this.sizeInfo.y);
			g.lineTo(this.sizeInfo.x + (this.sizeInfo.width / 2), this.sizeInfo.y + this.sizeInfo.width);
			g.lineTo(this.sizeInfo.x, this.sizeInfo.y);
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