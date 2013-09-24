package org.decatime.ui.component;

import flash.geom.Rectangle;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

import org.decatime.ui.layout.Content;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.BaseShapeElement;

class BaseScrollBar extends BaseSpriteElement implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";
	public static var EVT_SCROLL:String = NAMESPACE + "EVT_SCROLL";

	private var initialized:Bool;
	private var evManager:EventManager;

	private var shUp:BaseShapeElement;
	private var shDown:BaseShapeElement;
	private var shThumb:BaseShapeElement;

	public function new(name:String) {
		super(name);
		evManager = new EventManager(this);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (! this.initialized){
			initializeComponent();
		}
		this.initialized = true;

		// Background of the scrollbar
		graphics.clear();
		graphics.beginFill(0x808080, 1);
		graphics.drawRect(r.x, r.y, r.width, r.height);
		graphics.endFill();

		// Innerline of the scrollbar
		this.graphics.lineStyle(2, 0xa1a1a1, 0.9);
		this.graphics.drawRect(r.x + 2, r.y + 2, r.width - 4, r.height - 4);		
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

	private function initializeComponent(): Void {
		trace ("warning. This method should be overrided");
	}
}