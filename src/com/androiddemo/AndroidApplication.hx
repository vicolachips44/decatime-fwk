package com.androiddemo;

import org.decatime.ui.component.BaseContainer;
import org.decatime.event.*;
import org.decatime.ui.layout.*;
import org.decatime.ui.component.canvas.DrawingSurface;

class AndroidApplication extends BaseContainer {

	private var canvas: DrawingSurface;

	public function new() {
		super('DemoApplication');
	}

	private override function initializeComponent() {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.canvas = new DrawingSurface('myCanvas');
		this.container.create(1.0, this.canvas);
		this.addChild(this.canvas);

		
	}
}