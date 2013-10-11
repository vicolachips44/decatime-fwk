package org.decatime.ui.layout;

import flash.geom.Rectangle;


class VBox extends BoxBase {
	private override function doLayout(r:Array<Rectangle>, oRect:Rectangle) {
		// starting x,y by adding the horizontal and vertical gap
		var x:Float = oRect.x + hgap;
		var y:Float = oRect.y + vgap;

		// available with minus horizontal gap
		var avWidth:Float  = oRect.width - (hgap * 2);

		// remainingHeight for size that are absolute (not in percentage)
		var remainingHeight:Float = calcRemainingHeight(oRect, r);

		var content:Content = null;

		for ( i in 1...this.getNbContent() + 1) {
			content = this.contents.get(i);
			var size:Float = content.getSize();

			// the with is the same for all contents since it's a VBox
			r[i-1].width = avWidth;

			// if the size is specified in percentage then we 
			// calculate the size based on the remainingHeight value
			// else we use the provided size.
			r[i-1].height = size < 1.1 ? remainingHeight * size: size;

			r[i-1].x = x;
			r[i-1].y = y;

			// next y position
			y += r[i-1].height + vgap;

			content.setCurrSize(r[i-1]);
			content.refresh(r[i-1]);
		}
	}

	private function calcRemainingHeight(oRect:Rectangle, r:Array<Rectangle>): Float {
		var remainingHeight:Float = oRect.height - (vgap * 2);
		var content:Content = null;

		// contents array keys begin from 1 to n
		for ( i in 1...this.getNbContent() + 1) {
			content = this.contents.get(i);

			// get the size specified when the content was created
			var size:Float = content.getSize();
			
			// if size is between 0 and 1 then
			// it means that the size was specified in percentage.
			// It will be calculated in doLayout.
			if (size < 1.1) { continue; } 

			// Absolute size specified.
			// We update the remainning size available for content
			// that have a percentage size specified (between 0 and 1)
			remainingHeight -= size + vgap;
		}
		return remainingHeight;
	}
}