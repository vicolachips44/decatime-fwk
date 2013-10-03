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
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
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
		box.createGradientBox(this.sizeInfo.width, this.sizeInfo.height);
		trace ("drawing the arrow...");
		var g:Graphics = this.graphics;
		g.clear();

		g.lineStyle(1, 0x000000, 1, true, 
			flash.display.LineScaleMode.VERTICAL,
			flash.display.CapsStyle.NONE, 
			flash.display.JointStyle.ROUND);
		// g.lineStyle(
		//  ?thickness : Null<Float> , ?color : Int , ?alpha : Float , 
		// ?pixelHinting : Bool , 
		// ?scaleMode : flash.display.LineScaleMode , 
		// ?caps : flash.display.CapsStyle , ?joints : flash.display.JointStyle , ?miterLimit : Float )
		// g.beginFill(0x000000, 0.5);
		// g.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		g.beginGradientFill(GradientType.LINEAR, [0x444444, 0x808080], [1, 1], [1, 255], box);
		if (orientation == ORIENTATION_TOP) {
			g.moveTo(this.sizeInfo.x, this.sizeInfo.y + this.sizeInfo.width);
			g.lineTo(this.sizeInfo.x + this.sizeInfo.width, this.sizeInfo.y + this.sizeInfo.height);
			g.lineTo(this.sizeInfo.x + (this.sizeInfo.width / 2), this.sizeInfo.y);
			g.lineTo(this.sizeInfo.x, this.sizeInfo.y + this.sizeInfo.width);
		}		
		if (orientation == ORIENTATION_BOTTOM) {
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