package org.decatime.ui.layout;

import flash.geom.Rectangle;


class BoxBase extends Basic {
	public function new(parent:ILayoutElement) {
		super(parent);
	}

	public function create(size:Float, item:ILayoutElement): Content {
		var lcontent:Content = new Content(this, size, item);
		
		var nkey:Int = Lambda.count(contents) + 1;
		contents.set(nkey, lcontent);
		lcontent.setKeyValue(nkey);

		return lcontent;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		var content:Content = null;

		// initialize rectangles
		var rectangles:Array<Rectangle> = new Array<Rectangle>();
		for (i in 0...this.getNbContent()) { rectangles.push(new Rectangle()); }

		
		doLayout(rectangles, r);
	}

	private function doLayout(r:Array<Rectangle>, oRect:Rectangle) {
		throw new flash.errors.Error('this method must be implemented as an override');
	}
}