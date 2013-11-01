package com.demo;
import flash.geom.Point;

import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.windows.WindowState;
import org.decatime.ui.component.IPrintable;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.component.canvas.DrawingSurface;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.Button;

class WxCanvasDemo extends Window implements IPrintable implements IObserver {
	private var canvas: DrawingSurface;
	private var btnUndo: Button;
	private var btnRedo: Button;

	private override function buildClientArea(): Void {
		this.canvas = new DrawingSurface('myCanvas');
		this.canvas.setParentWindow(this);

		var hboxToolbar: HBox = new HBox(this.container);

		this.btnUndo = new Button('Undo', 'assets/Vera.ttf');
		this.btnRedo = new Button('Redo', 'assets/Vera.ttf');

		this.btnUndo.addListener(this);
		this.btnRedo.addListener(this);
		hboxToolbar.create(0.5, btnUndo).setHorizontalGap(10);
		hboxToolbar.create(0.5, btnRedo).setHorizontalGap(10);

		this.clientArea.create(28, hboxToolbar);
		this.clientArea.create(1.0, this.canvas);

		this.addChild(this.canvas);
		this.addChild(this.btnUndo);
		this.addChild(this.btnRedo);
	}

	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name, in_size, fontResPath);
    }
	// IObserver implementation BEGIN

	public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		super.handleEvent(name, sender, data);
		switch(name) {
			case Button.EVT_CLICK:
			if (cast (sender, Button).name == 'Undo') {
				if (canvas.undo()) {
					// do some neet things
				}
			} else {
				if (canvas.redo()) {
					// do some neet things
				}
			}
		}
	}

	public override function getEventCollection(): Array<String> {
		var parentAy:Array<String> = super.getEventCollection();
		parentAy.push(Button.EVT_CLICK);
		return parentAy;
	}

	public override function toString(): String {
		return "5 - Canvas Demo";
	}
}