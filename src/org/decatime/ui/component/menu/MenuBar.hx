package org.decatime.ui.component.menu;

import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;

class MenuBar extends BaseContainer {
	private static inline var NAMESPACE:String = "org.decatime.ui.component.menu.MenuItem : ";
	public static inline var MENUITEM_CLICK: String = NAMESPACE + "MENUITEM_CLICK";

	private var fontRes: String;
	private var mnuItems: Array<MenuItem>;
	private var subMenuActive: Bool;
	private var activeMenuItem: MenuItem;
	private var overColor: Int;
	private var fontColor: Int;
	private var fontOverColor: Int;

	public function new(name:String, in_fontRes: String) {
		super(name);
		this.elBackColorVisibility = 1.0;
		this.overColor = 0xe0e0e0;
		this.elBackColor = 0xbbbbbb;
		this.fontRes = in_fontRes;
		this.mnuItems = new Array<MenuItem>();
		this.subMenuActive = false;
		this.fontColor = 0x000000;
		this.fontOverColor = 0x000000;
	}

	public function getFontOverColor(): Int {
		return this.fontOverColor;
	}

	public function setFontOverColor(value: Int): Void {
		this.fontOverColor = value;
	}

	public function setFontColor(value: Int): Void {
		this.fontColor = value;
	}

	public function getFontColor(): Int {
		return this.fontColor;
	}

	public function setMenuColor(value: Int): Void {
		this.elBackColor = value;
	}

	public function getMenuColor(): Int {
		return this.elBackColor;
	}

	public function setMenuOverColor(value: Int): Void {
		this.overColor = value;
	}

	public function getMenuOverColor(): Int {
		return this.overColor;
	}

	public function relayClick(mnuItem: MenuItem): Void {
		this.notify(MENUITEM_CLICK, mnuItem.getMenuPath());
	}

	public function addMenu(mnuItem: MenuItem): Void {
		this.mnuItems.push(mnuItem);
		mnuItem.setFontRes(this.fontRes);
		mnuItem.setIsRoot(true);
		mnuItem.setParentBar(this);
		mnuItem.setFontColor(this.fontColor);
	}

	public function getIsSubmenuActive(): Bool {
		return this.subMenuActive;
	}

	public function toggleVisibility(mnuItem: MenuItem): Void {
		this.subMenuActive = !this.subMenuActive;
		if (this.subMenuActive) {
			mnuItem.getSubItemsContainer().show(getBoundsFromMenu(mnuItem));
		} else {
			mnuItem.getSubItemsContainer().close();
		}
		this.activeMenuItem = mnuItem;
	}

	public function getMenuItem(menuName: String): MenuItem {
		var mnuItem: MenuItem = null;
		for (mnuItem in this.mnuItems) {
			if (mnuItem.name == menuName) {
				return mnuItem;
			}
		}
		return null;
	}

	public function updateVisiblity(mnuItem: MenuItem): Void {
		if (! this.subMenuActive) { 
			// the toggleVisilibty method has not been called
			return; 
		}

		if (mnuItem.name != this.activeMenuItem.name) {
			this.activeMenuItem.getSubItemsContainer().close();
			mnuItem.getSubItemsContainer().show(getBoundsFromMenu(mnuItem));	
		}
		this.activeMenuItem = mnuItem;
	}

	public function resetVisibility(): Void {
		this.subMenuActive = false;
		this.activeMenuItem = null;
	}

	public function setMenuItemState(mnuPath: String, disabled: Bool): Void {
		var tokens:Array<String> = mnuPath.split(MenuItem.PATH_SEPARATOR);
		var rootItem: MenuItem = this.getMenuItem(tokens[0]);
		var mnuItem: MenuItem = null;
		for (mnuItem in rootItem.getSubItems()) {
			if (mnuItem.name == tokens [1]) {
				mnuItem.setState(disabled);
				break;
			}
		}
	}

	private function getBoundsFromMenu(mnuItem: MenuItem):  Rectangle {
		var absBound: Rectangle = mnuItem.getBounds(this.stage);
		
		absBound.y = absBound.y + mnuItem.getCurrSize().height;
		absBound.height = calculateHeight(absBound.height, mnuItem);
		absBound.width = getBigestMenuWidth(mnuItem);
		return absBound;
	}

	private function calculateHeight(in_height: Float, mnuItem: MenuItem): Float {
		var retValue: Float = 0;
		var mnu: MenuItem = null;
		for (mnu in mnuItem.getSubItems()) {
			if (! mnu.getIsSeparator()) {
				retValue += 2 + in_height;
			} else {
				retValue += 4;
			}
		}
		return retValue;
	}

	private function getBigestMenuWidth(mnuItem: MenuItem): Float {
		var item: MenuItem = null;
		var retWidth: Float = 0;

		for (item in mnuItem.getSubItems()) {
			var lwidth: Float = item.textLabel.getTextWidth() + 44; // 20 = icon needed place // 20 = subItems arrow needed place
			if (lwidth > retWidth) {
				retWidth = lwidth;
			}
		}
		return retWidth;
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();
		this.container.setHorizontalGap(4);
		var item: MenuItem = null;

		for (item in mnuItems) {
			this.container.create(item.textLabel.getTextWidth(), item);
			this.addChild(item);
		}
	}
}