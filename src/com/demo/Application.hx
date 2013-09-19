package com.demo;

import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.Facade;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.Content;

class Application extends BaseSpriteElement implements IObserver {

	private var layout:VBox;

	public function new() {
		super('DemoApplication');

		// I am the main container and i do not handle mouse events (for now...)
		this.buttonMode = false;

		Facade.getInstance().addListener(this);
		layout = new VBox(this);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		layout.refresh(r);
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
		
	}
}