package com.androiddemo;

import org.decatime.ui.component.BaseContainer;
import org.decatime.event.*;
import org.decatime.ui.layout.*;
import org.decatime.ui.component.canvas.DrawingSurface;
import org.decatime.ui.component.*;
import org.decatime.ui.component.canvas.style.*;

class AndroidApplication extends BaseContainer implements IObserver {
	private var canvas: DrawingSurface;
	private var btnFreeHand: Button;
	private var btnLine: Button;
	private var btnSquare: Button;
	private var btnCircle: Button;

	public function new() {
		super('DemoApplication');
	}

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch ((name)) {
			case Button.EVT_CLICK:
				var clickedBtn: Button = cast (sender, Button);
				StyleManager.getInstance().setActiveStyle(clickedBtn.name);
		}
	}

	public function getEventCollection(): Array<String> {
		return [Button.EVT_CLICK];
	}

	private override function initializeComponent() {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.canvas = new DrawingSurface('myCanvas');
		this.container.create(1.0, this.canvas);
		this.addChild(this.canvas);

		var hbox:HBox = new HBox(this.container);
		this.container.create(48, hbox);

		var fntRes: String = 'assets/Vera.ttf';

		this.btnFreeHand = new Button(StyleManager.FREEHAND, fntRes);
		this.btnLine = new Button(StyleManager.LINE, fntRes);
		this.btnSquare = new Button(StyleManager.SQUARE, fntRes);
		this.btnCircle = new Button(StyleManager.CIRCLE, fntRes);

		hbox.create(100, this.btnFreeHand);
		hbox.create(100, this.btnLine);
		hbox.create(100, this.btnSquare);
		hbox.create(100, this.btnCircle);

		this.addChild(this.btnFreeHand);
		this.addChild(this.btnLine);
		this.addChild(this.btnSquare);
		this.addChild(this.btnCircle);

		this.btnFreeHand.addListener(this);
		this.btnLine.addListener(this);
		this.btnSquare.addListener(this);
		this.btnCircle.addListener(this);
	}
}