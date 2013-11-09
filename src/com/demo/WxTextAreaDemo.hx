package com.demo;
import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.IPrintable;
import org.decatime.ui.component.TextArea;

class WxTextAreaDemo extends Window implements IPrintable {
	private var tarea: TextArea;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name, size, fontResPath);
	}

	private override function buildClientArea(): Void {
		tarea = new TextArea();
		tarea.setFontRes(this.fontResPath);
		this.clientArea.create(1.0, tarea);
		this.addChild(tarea);
	}

	public function setText(value: String): Void {
		this.tarea.setText(value);
	}


	public override function toString() : String {
		return "6 - TextArea DEMO";
	}

	public function getBitmap(): flash.display.Bitmap {
		return null;
	}
}