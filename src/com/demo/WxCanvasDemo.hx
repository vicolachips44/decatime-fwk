package com.demo;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.component.canvas.DrawingSurface;

class WxCanvasDemo extends Window implements IPrintable implements IObserver {
	private var canvas: DrawingSurface;

	private override function buildClientArea(): Void {
		this.canvas = new DrawingSurface('myCanvas');
		this.clientArea.create(1.0, this.canvas);
		this.addChild(this.canvas);
	}

	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		return parentAy;
	}

	public override function toString(): String {
		return "4 - Canvas Demo";
	}
}