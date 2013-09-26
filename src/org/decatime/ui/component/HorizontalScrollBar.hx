package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.geom.Matrix;

import org.decatime.ui.layout.Content;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;


class HorizontalScrollBar extends BaseScrollBar implements IObserver {

	// private var container:HBox;
	private var btnScrollLeft:ArrowButton;
	private var btnScrollRight:ArrowButton;

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {

	}

	public function getEventCollection(): Array<String> {
		return [];
	}

	// IObserver implementation END

	private override function initializeComponent(): Void {
		// Our main container is a VBOX
		this.container = new HBox(this);
		this.container.setHorizontalGap(1);
		this.container.setVerticalGap(1);

		this.btnScrollLeft = new ArrowButton('btnLeft',ArrowButton.ORIENTATION_LEFT);
		this.container.create(this.sizeInfo.height, this.btnScrollLeft);
		this.addChild(this.btnScrollLeft);

		this.thumb = new BaseShapeElement('thumb');
		this.container.create(1.0, this.thumb);
		this.addChild(this.thumb);

		this.btnScrollRight = new ArrowButton('btnRight', ArrowButton.ORIENTATION_RIGHT);
		this.container.create(this.sizeInfo.height, this.btnScrollRight);
		this.addChild(this.btnScrollRight);
		
	}
}