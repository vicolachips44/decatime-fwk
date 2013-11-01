package com.demo;
import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;
import org.decatime.ui.component.TextArea;

class WxTextAreaDemo extends Window implements IPrintable {

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
	}

	private override function buildClientArea(): Void {
		var tarea:TextArea = new TextArea();
		tarea.setFontRes(this.fontResPath);
		this.clientArea.create(1.0, tarea);
		this.addChild(tarea);
	}

	public override function toString() : String {
		return "6 - TextArea DEMO";
	}
}