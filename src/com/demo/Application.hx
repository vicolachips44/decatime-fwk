package com.demo;

import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.Facade;

class Application extends BaseSpriteElement implements IObserver {

	 public function new() {
		super('DemoApplication');

		// I am the main container and i do not handle mouse events (for now...)
		this.buttonMode = false;

		Facade.getInstance().addListener(this);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		// TODO refresh my layout
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case Facade.EV_INIT:
				initializeComponent();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			Facade.EV_INIT
		];
	}

	// IObserver implementation END

	private function initializeComponent() {
		trace('initialize component was raised');
		// TODO add some childs to this container
	}
}