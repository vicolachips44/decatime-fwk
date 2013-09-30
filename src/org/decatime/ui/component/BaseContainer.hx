package org.decatime.ui.component;

import flash.geom.Rectangle;

import org.decatime.ui.layout.BoxBase;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.event.EventManager;

class BaseContainer extends BaseSpriteElement implements IObservable {

	private var container:BoxBase;
	private var initialized:Bool;
	private var evManager:EventManager;

	public function new(name:String) {
		super(name);
		evManager = new EventManager(this);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (! this.initialized){
			initializeComponent();
		}
		if (this.container == null) {
			throw new flash.errors.Error("The container object has not been initialized");
		}
		this.container.refresh(r);
		if (! this.initialized) {
			initializeEvent();
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

	private function initializeComponent(): Void {
		// trace ("BaseContainer: no implementation for initializeComponent at the moment");
	}

	private function initializeEvent(): Void {
		// trace ("BaseContainer : no implementation for initializeEvent at the moment");
	}
}