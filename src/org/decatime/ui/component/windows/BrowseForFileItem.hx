package org.decatime.ui.component.windows;
import flash.display.Bitmap;

import org.decatime.ui.component.IPrintable;

class BrowseForFileItem implements IPrintable {

	private var label: String;
	private var bmpType: Bitmap;
	
	public function new(in_label: String, in_bmpType: Bitmap) {
		this.label = in_label;
		this.bmpType = in_bmpType;
	}

	public function toString() : String {
		return this.label;
	}

	public function getBitmap(): Bitmap {
		return this.bmpType;
	}
}