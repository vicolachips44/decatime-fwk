package org.decatime.ui.component;

import flash.events.MouseEvent;
import flash.events.TouchEvent;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

class  ButtonGroupManager implements IObservable {
	public static var EVT_SEL_CHANGE:String = "org.decatime.display.ui.component.ButtonGroupManager.EVT_SEL_CHANGE";

	private var ayOfButtons:Array<PngButton>;
	private var evManager:EventManager;

	public function new() {
		ayOfButtons = new Array<PngButton>();
		evManager = new EventManager(this);
	}

	public function add(instance:PngButton, selected:Bool): Void {
		ayOfButtons.push(instance);
		instance.setGroupManager(this);

		instance.getBtnCold().visible = selected ? false : true;
		instance.getBtnHot().visible = selected;
		if (! selected) {
			#if android
			instance.addEventListener(TouchEvent.TOUCH_END, onBtnTouchEnd);
			#else
			instance.addEventListener(MouseEvent.CLICK, onColdBtnClick);
			#end
		}
	}

	public function select(name:String): PngButton {
		var btn:PngButton = null;
		for (btn in ayOfButtons) {
			if (btn.name == name) {
				HandleTogle(btn);
				return btn;
			}
		}
		//trace ("WARNING: select method of object ButtonGroupManager is returning NULL. there is no button with id " + name);
		return null;
	}

	private function onBtnTouchEnd(e:TouchEvent): Void {
		var btn:PngButton = cast(e.currentTarget, PngButton);
		HandleTogle(btn);
	}

	private function onColdBtnClick(e:MouseEvent): Void {
		var btn:PngButton = cast(e.currentTarget, PngButton);
		HandleTogle(btn);
	}

	private function HandleTogle(btn:PngButton, ?bRaiseEvent:Bool = true): Void {
		for (button in ayOfButtons) {
			#if android
			button.removeEventListener(TouchEvent.TOUCH_END, onBtnTouchEnd);
			#else
			button.removeEventListener(MouseEvent.CLICK, onColdBtnClick);
			#end
			if (button.name == btn.name) {
				button.getBtnCold().visible = false;
				button.getBtnHot().visible = true;
				evManager.notify(EVT_SEL_CHANGE, button.name);
			} else {
				button.getBtnCold().visible = true;
				button.getBtnHot().visible = false;
				#if android
				button.addEventListener(TouchEvent.TOUCH_END, onBtnTouchEnd);
				#else
				button.addEventListener(MouseEvent.CLICK, onColdBtnClick);
				#end
			}
		}
	}

	
	// IObservable implementation
	public function addListener(observer:IObserver): Void {
		evManager.addListener(observer);
	}
	public function removeListener(observer:IObserver): Void {
		evManager.removeListener(observer);
	}

	public function notify(name:String, data:Dynamic): Void {
		evManager.notify(name, data);
	}
	// IObservable implementation END
}