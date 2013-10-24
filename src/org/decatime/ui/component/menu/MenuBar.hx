package org.decatime.ui.component.menu;

import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;

class MenuBar extends BaseContainer {
	private var fontRes: String;
	private var menuItems: Array<MenuItem>;

	public function new(fontRes: String) {
		super('MainMenuBar');
		this.fontRes = fontRes;
		this.elBackColorVisibility = 1.0;
		this.menuItems = new Array<MenuItem>();
	}

	public function getFontRes(): String {
		return this.fontRes;
	}

	public function addItem(mitem: MenuItem): Void {
		mitem.setParentMenuBar(this);
		this.menuItems.push(mitem);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		trace ("refresh event as occured on MenuBar");
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();

		var itm: MenuItem = null;

		for (itm in this.menuItems) {
			var nsize: Float = itm.neededSize;
			trace ("needed size for item of menu is " + nsize);
			this.container.create(nsize, itm);
			this.addChild(itm);
		}
	}
}