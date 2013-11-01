package org.decatime.ui.component.menu;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.TextLabel;

class MenuItem extends BaseContainer {
	private static inline var NAMESPACE:String = "org.decatime.ui.component.menu.MenuItem : ";
	public static inline var MENUITEM_CLICK: String = NAMESPACE + "MENUITEM_CLICK";

	private var subItems:Array<MenuItem>;

	public var textLabel(default, null): TextLabel;

	private var label: String;
	private var fontRes: String;
	private var iconRes: String;
	private var subItemsContainer: MenuPanel;
	private var parentMenuItem: MenuItem;
	private var parentPanel: MenuPanel;
	private var parentMenuBar: MenuBar;

	private var isRoot: Bool;

	public function new(in_label: String, ?in_iconRes: String = '') {
		super(in_label);
		this.label = in_label;
		this.iconRes = in_iconRes;
		this.textLabel = new TextLabel(label, 0x000000, 'left');
	}

	public function setSubItems(values: Array<MenuItem>): Void {
		var item:MenuItem = null;
		for (item in values) {
			trace ("setting item " + item.name + " font res path to " + fontRes);
			item.setFontRes(fontRes);
			item.setParent(this);
		}
		this.subItems = values;
	}

	public function setIsRoot(value: Bool): Void {
		this.isRoot = value;
	}

	public function setParentBar(mnuBar: MenuBar): Void {
		this.parentMenuBar = mnuBar;
	}

	public function setParentPanel(mnuPanel: MenuPanel): Void {
		this.parentPanel = mnuPanel;
	}

	public function getIsRoot(): Bool {
		return this.isRoot;
	}

	public function asSubItems(): Bool {
		if (this.subItems == null) { return false; }
		return this.subItems.length > 0;
	}

	public function setFontRes(value: String): Void {
		this.fontRes = value;
		
	}

	public function setParent(item:MenuItem): Void {
		this.parentMenuItem = item;
	}

	private override function initializeComponent(): Void {
		super.initializeComponent();
		if (this.iconRes != null) {

		}
		this.textLabel.setFontRes(this.fontRes);
		this.container.create(this.textLabel.getNeededSize(), this.textLabel);
		this.addChild(this.textLabel);

		if (this.asSubItems())  {
			this.subItemsContainer = new MenuPanel('mnu' + this.label + 'SubItemsContainer');
			
			var item:MenuItem = null;

			for (item in this.subItems) {
				this.subItemsContainer.addMenuItem(item);
			}
		}
		this.addEventListener(MouseEvent.CLICK, onMnuItemClick);
		if (! this.isRoot) {
			this.addEventListener(MouseEvent.MOUSE_OVER, onMnuItemMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMnuItemMouseOut);
		}
	}

	private function onMnuItemMouseOver(e:MouseEvent): Void {
		this.graphics.clear();
		this.graphics.beginFill(0xaaddcc);
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
	}

	private function onMnuItemMouseOut(e:MouseEvent): Void {
		this.graphics.clear();
		this.graphics.beginFill(0xbbbbbb);
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
	}

	private function onMnuItemClick(e:MouseEvent): Void {
		if (this.asSubItems()) {
			var absBound: Rectangle = this.getBounds(this.stage);
			
			absBound.y = absBound.y + this.sizeInfo.height;
			absBound.height = absBound.height * this.subItems.length;
			absBound.width = getBigestMenuWidth();

			this.subItemsContainer.showHide(absBound);
		} else {
			this.notify(MENUITEM_CLICK, this);
			if (this.parentPanel != null) {
				this.parentPanel.close();
			}
		}
	}

	private function getBigestMenuWidth(): Float {
		var item: MenuItem = null;
		var retWidth: Float = 0;

		for (item in this.subItems) {
			var lwidth: Float = item.textLabel.getNeededSize() + 40; // 20 = icon needed place // 20 = subItems arrow needed place
			if (lwidth > retWidth) {
				retWidth = lwidth;
			}
		}
		return retWidth;
	}
}