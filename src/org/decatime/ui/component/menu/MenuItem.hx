package org.decatime.ui.component.menu;

import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.Label;

class MenuItem extends BaseSpriteElement {
	
	public var neededSize: Float;

	private var mnuParent: MenuItem;
	private var mnuBar: MenuBar;
	private var labelCaption: Label;

	public function new(caption: String) {
		super(caption);
		this.isContainer = false;
	}

	public function setParentMenu(mnuItem: MenuItem): Void {
		this.mnuParent = mnuItem;

	}

	public override function refresh(r: Rectangle): Void {
		super.refresh(r);
		var rect: Rectangle = r.clone();
		rect.x = 4;
		rect.y = 1;
		this.labelCaption.refresh(rect);
	}

	public function setParentMenuBar(mnuBar: MenuBar): Void {
		this.mnuBar = mnuBar;

		this.labelCaption = new Label(this.name);
		this.labelCaption.setFontRes(this.mnuBar.getFontRes());
		this.neededSize = this.labelCaption.getNeededSize();
		this.addChild(this.labelCaption);
	}
}