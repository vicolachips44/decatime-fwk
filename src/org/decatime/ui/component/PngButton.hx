package org.decatime.ui.component;

import openfl.Assets;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

class PngButton extends BaseSpriteElement implements IObservable {
	public static var EVT_PNGBUTTON_CLICK = "org.decatime.ui.component.PngButton.EVT_PNGBUTTON_CLICK";

	private var coldBtnAsset:String;
	private var hotBtnAsset:String;
	private var evManager:EventManager;

	private var btnCold:Bitmap;
	private var btnHot:Bitmap;
	private var btnDisable:Bitmap;
	private var enabled:Bool;
	private var groupManager:ButtonGroupManager;

	public function new(n:String, coldBtnAsset:String, hotBtnAsset:String, ?disableAsset:String = '') {
		super(n);
		enabled = true;
		btnCold = new Bitmap(Assets.getBitmapData( coldBtnAsset ));
		btnHot = new Bitmap(Assets.getBitmapData( hotBtnAsset ));
		if (disableAsset != '') {
			btnDisable = new Bitmap(Assets.getBitmapData(disableAsset));
		}
		addChild( btnHot );
		addChild( btnCold );
		evManager = new EventManager(this);
		#if !android
		addEventListener(MouseEvent.MOUSE_OVER, onBtnMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onBtnMouseOut);
		addEventListener(MouseEvent.CLICK, onBtnMouseClick);
		#end
		#if android
		addEventListener(TouchEvent.TOUCH_BEGIN, onBtnTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, onBtnTouchEnd);

		#end
	}

	public function setGroupManager(gm:ButtonGroupManager): Void {
		groupManager = gm;
		// the manager will handle events...
		#if !android
		removeEventListener(MouseEvent.MOUSE_OVER, onBtnMouseOver);
		removeEventListener(MouseEvent.MOUSE_OUT, onBtnMouseOut);
		removeEventListener(MouseEvent.CLICK, onBtnMouseClick);
		#end
		#if android
		removeEventListener(TouchEvent.TOUCH_BEGIN, onBtnTouchBegin);
		removeEventListener(TouchEvent.TOUCH_END, onBtnTouchEnd);
		#end
	}

	public function getBtnCold(): Bitmap {
		return btnCold;
	}

	public function getBtnHot(): Bitmap {
		return btnHot;
	}

	public function setEnable(value:Bool) {
		if (btnDisable == null) {
			throw ("This instance does not support button state");
		}
		enabled = value;
		if (! enabled) {
			addChild(btnDisable);
			btnCold.visible = false;
			btnHot.visible = false;
		} else {
			if (this.contains(btnDisable)) {
				removeChild(btnDisable);
			}
			btnCold.visible = true;
			btnHot.visible = true;
		}
	}

	#if !android
	private function onBtnMouseOver(e:MouseEvent): Void {
		if (! enabled) { return; }
		btnCold.visible = false;
	}

	private function onBtnMouseOut(e:MouseEvent): Void {
		if (! enabled) { return; }
		btnCold.visible = true;
	}

	private function onBtnMouseClick(e:MouseEvent): Void {
		if (enabled) {
			evManager.notify(EVT_PNGBUTTON_CLICK, this);
		}
	}
	#end

	#if android
	private function onBtnTouchBegin(e:TouchEvent): Void {
		if (! enabled) { return; }
		btnCold.visible = false;
	}

	private function onBtnTouchEnd(e:TouchEvent): Void {
		if (! enabled) { return; }
		btnCold.visible = true;
		if (enabled) {
			evManager.notify(EVT_PNGBUTTON_CLICK, this);	
		}
	}
	#end

	public override function refresh(r:Rectangle): Void {
		x = r.x;
		y = r.y;
		this.sizeInfo = r;
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