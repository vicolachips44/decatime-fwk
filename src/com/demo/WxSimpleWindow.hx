package com.demo;
import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.windows.WindowState;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.component.canvas.DrawingSurface;

class WxSimpleWindow extends Window implements IPrintable implements IObserver {
	private override function buildClientArea(): Void {
		
	}

	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name, in_size, fontResPath);
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
		return "1 - Simple Window";
	}
}