package org.decatime.ui.component;

import flash.geom.Rectangle;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

import org.decatime.ui.layout.Content;

class BaseScrollBar extends BaseSpriteElement implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";
	public static var EVT_SCROLL:String = NAMESPACE + "EVT_SCROLL";

	private var evManager:EventManager;

	public function new(name:String) {
		super(name);
		evManager = new EventManager(this);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		graphics.clear();
		graphics.beginFill(0x808080, 1);
		graphics.drawRect(r.x, r.y, r.width, r.height);
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
}