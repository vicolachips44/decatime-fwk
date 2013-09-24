package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;

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
		this.elBackColor = 0x000000;
		this.orientation = orientation;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		// TODO draw the button
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

	private function onMouseClick(e:MouseEvent): Void {
		// Relay the click event on me
		evManager.notify(EVT_CLICK, null);
	}
}