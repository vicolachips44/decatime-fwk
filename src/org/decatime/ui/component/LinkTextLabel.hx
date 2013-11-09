package org.decatime.ui.component;

import flash.events.MouseEvent;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.event.EventManager;

class LinkTextLabel extends TextLabel implements IObservable {
	private static inline var NAMESPACE: String = "org.decatime.ui.component.LinkTextLabel: ";
	
	public static inline var EVT_CLICK: String = NAMESPACE + "EVT_CLICK";

	private var evManager:EventManager;

	public function new(text:String) {
		super(text, 0x0000ff, 'left');

		this.addEventListener(MouseEvent.MOUSE_OVER, onLinkMouseOver);
		this.addEventListener(MouseEvent.MOUSE_OUT, onLinkMouseOut);
		this.addEventListener(MouseEvent.CLICK, onLinkMouseClick);

		evManager = new EventManager(this);
	}

	/** IObservable implementation **/
	public function addListener(observer:IObserver): Void {
		evManager.addListener(observer);
	}

	/** IObservable implementation **/
	public function removeListener(observer:IObserver): Void {
		evManager.removeListener(observer);
	}

	/** IObservable implementation **/
	public function notify(name:String, data:Dynamic): Void {
		evManager.notify(name, data);
	}

	private function onLinkMouseClick(e:MouseEvent): Void {
		this.notify(EVT_CLICK, this);
	}

	private function onLinkMouseOver(e:MouseEvent): Void {
		super.setUnderLine(true);
		if (this.sizeInfo != null) { this.refresh(this.sizeInfo); }
	}

	private function onLinkMouseOut(e:MouseEvent): Void {
		this.setUnderLine(false);
		if (this.sizeInfo != null) { this.refresh(this.sizeInfo); }
	}
}	