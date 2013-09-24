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


	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		// TODO Draw component
	}


	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {

	}

	public function getEventCollection(): Array<String> {
		return [];
	}

	// IObserver implementation END
}