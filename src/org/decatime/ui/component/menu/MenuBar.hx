package org.decatime.ui.component.menu;

import org.decatime.ui.component.BaseContainer;

class MenuBar extends BaseContainer {
	private var fontRes: String;
	private var mnuItems: Array<MenuItem>;

	public function new(name:String, in_fontRes: String) {
		super(name);
		this.elBackColorVisibility = 1.0;
		this.elBackColor = 0xaaaaaa;
		this.fontRes = in_fontRes;
		this.mnuItems = new Array<MenuItem>();
	}

	public function addMenu(mnuItem: MenuItem): Void {
		this.mnuItems.push(mnuItem);
		mnuItem.setFontRes(this.fontRes);
		mnuItem.setIsRoot(true);
		mnuItem.setParentBar(this);
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();
		this.container.setHorizontalGap(4);
		var item: MenuItem = null;

		for (item in mnuItems) {
			this.container.create(item.textLabel.getNeededSize(), item);
			this.addChild(item);
		}
	}
}