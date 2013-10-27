package org.decatime.ui.layout;

import flash.geom.Rectangle;

/**
* This object will do an horizontal layout for all the Content instance
* that are attach to him. 
* This object contains only private methods
* @see <a href="BoxBase.html">BoxBase</a>
*/
class HBox extends BoxBase {
	private override function doLayout(r:Array<Rectangle>, oRect:Rectangle) {
		// starting x,y by adding the horizontal and vertical gap
		var x:Float = oRect.x + hgap;
		var y:Float = oRect.y + vgap;

		// available height minus horizontal gap
		var avHeight:Float  = oRect.height - (vgap * 2);

		// remainingHeight for size that are absolute (not in percentage)
		var remainingWidth:Float = calcRemainingWidth(oRect, r);

		var content:Content = null;

		for ( i in 1...this.getNbContent() + 1) {
			content = this.contents.get(i);

			var size:Float = content.getSize();

			// the height is the same for all contents since it's a HBox
			r[i-1].height = avHeight;

			// if the size is specified in percentage then we 
			// calculate the size based on the remainingWidth value
			// else we use the provided size.
			r[i-1].width = size < 1.1 ? remainingWidth * size: size;

			r[i-1].x = x;
			r[i-1].y = y;

			// next x position
			x += r[i-1].width + hgap;

			content.setCurrSize(r[i-1]);
			content.refresh(r[i-1]);
		}
	}

	private function calcRemainingWidth(oRect:Rectangle, r:Array<Rectangle>): Float {
		var remainingWidth:Float = oRect.width - (hgap * 2);
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
			remainingWidth -= size + hgap;
		}
		return remainingWidth;
	}
}