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


class VerticalScrollBar extends BaseScrollBar implements IObserver {

	private var container:VBox;
	private var btnScrollUp:ArrowButton;
	private var btnScrollDown:ArrowButton;
	private var thumb:BaseShapeElement;

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		// TODO Draw component
		this.container.refresh(r);
		
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
		this.container = new VBox(this);
		this.container.setHorizontalGap(1);
		this.container.setVerticalGap(1);

		this.btnScrollUp = new ArrowButton('btnUp',ArrowButton.ORIENTATION_TOP);
		this.container.create(this.sizeInfo.width, this.btnScrollUp);
		this.addChild(this.btnScrollUp);

		this.thumb = new BaseShapeElement('thumb');
		this.container.create(1.0, this.thumb);
		this.addChild(this.thumb);

		this.btnScrollDown = new ArrowButton('btnDown', ArrowButton.ORIENTATION_BOTTOM);
		this.container.create(this.sizeInfo.width, this.btnScrollDown);
		this.addChild(this.btnScrollDown);
		
	}
}