package org.decatime.ui.layout;

import flash.geom.Rectangle;

/**
* BoxBase object is the base implementation for HBox and VBox
* layout objects.
*/
class BoxBase extends Basic {

	/**
	* Create a Content instance for the ILayoutElement instance
	* parameter. This ILayoutElement will be sized accordingly
	* to the size parameter. The size parameter can be an absolute
	* value or a percentage value(0.1 to 1.0).
	*
	* @see <a href="Basic.html">Basic</a>
	* @param size:Float the size needed
	* @param item:ILayoutElement the ILayoutElement instance
	*
	* @return Content the Content instance object.
	*/
	public function create(size:Float, item:ILayoutElement): Content {
		var lcontent:Content = new Content(this, size, item);
		
		var nkey:Int = Lambda.count(contents) + 1;
		contents.set(nkey, lcontent);
		lcontent.setKeyValue(nkey);

		return lcontent;
	}

	/**
	* call the base refresh implementation of the Basic instance
	* and then call the doLayout function on each Content instance
	* of this layout.
	*
	* @param r:Rectangle the size constraint.
	*
	* @return Void
	*/
	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		var content:Content = null;

		// initialize rectangles
		var rectangles:Array<Rectangle> = new Array<Rectangle>();
		for (i in 0...this.getNbContent()) { rectangles.push(new Rectangle()); }

		
		doLayout(rectangles, r);
	}

	/**
	* This mehod is overrided by HBox and VBox.
	*/
	private function doLayout(r:Array<Rectangle>, oRect:Rectangle) {
		throw new flash.errors.Error('this method must be implemented as an override');
	}
}