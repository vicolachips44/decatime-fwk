package org.decatime.ui.layout;

import flash.geom.Rectangle;


class VBox extends Basic {

	public function new(parent:ILayoutElement) {
		super(parent);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		var content:Content = null;

		// var avWidth:Float  = r.width - (hgap * 2);      // available with minus horizontal gap
		// var avHeight:Float = r.height - (vgap * 2);     // available height minus vertical gap

		// initialize rectangles
		var rectangles:Array<Rectangle> = new Array<Rectangle>();
		for (i in 0...this.getNbContent()) { rectangles.push(new Rectangle()); }

		var remainingHeight:Float = calcAbsoluteHeights(r, rectangles);
	}

	private function calcOriginAndHeights(oRect:Rectangle, r:Rectangle, remainingHeight:Float) {

	}

	private function calcAbsoluteHeights(oRect:Rectangle, r:Array<Rectangle>): Float {
		var remainingHeight:Float = oRect.height;
		var content:Content = null;

		// contents array keys begin from 1 to n
		for ( i in 1...this.getNbContent() + 1) {
			content = this.contents.get(i);

			// Same with for all elements since its a VBOX
			r[i-1].width = oRect.width - (hgap * 2);

			// get the size specified when the content was created
			var size:Float = content.getSize();
			
			// if size is between 0 and 1 then
			// it means that the size was specified in percentage.
			// It will be calculated in calcOriginAndHeights.
			if (size < 1.1) { continue; } 

			// Absolute size specified.
			// We update the remainning size available for content
			// that have a percentage size specified (between 0 and 1)
			// TODO: Check for the vgap value...
			remainingHeight -= size;

			// We set the absolute height for this content
			// TODO: Check for the vgap value...
			r[i-1].height = size; 
		}
		return remainingHeight;
	}
}