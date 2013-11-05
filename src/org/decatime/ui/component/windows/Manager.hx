package org.decatime.ui.component.windows;

import flash.display.DisplayObject;

import org.decatime.ui.BaseSpriteElement;

class Manager extends BaseSpriteElement {
	private var windows:Array<Window>;

	public function new(name:String) {
		super(name);
		this.windows = new Array<Window>();
	}

	public override function addChild(child : DisplayObject) : DisplayObject {
		if (Std.is(child, Window)) {
			var w:Window = cast(child, Window);
			this.windows.push (w);
			return super.addChild(child);
		}
		throw new flash.errors.Error("This container only accept org.decatime.ui.component.windows.Window types");
	}

	public override function removeChild(child : DisplayObject) : DisplayObject {
		if (Std.is(child, Window)) {
			var w:Window = cast(child, Window);
			var windex: Int = getWindowIndex(w);
			this.windows.remove(w);
			
			if (windex > 0) {
				this.bringToFront(this.windows[windex - 1]);
			}

			return super.removeChild(child);
		}
		throw new flash.errors.Error("This container only accept org.decatime.ui.component.windows.Window types");	
	}

	public function bringToFront(childWindow: Window): Void {
		this.setChildIndex(childWindow, this.numChildren - 1);
		var w:Window = null;
		for (w in this.windows) {
			if (w.name != childWindow.name) {
				w.deactivate();
			}
		}
		childWindow.activate();
	}

	private function getWindowIndex(w:Window): Int {
		for (i in 0...this.windows.length) {
			var win:Window = this.windows[i];
			if (win.name == w.name) {
				return i;
			}
		}
		return -1;
	}
}