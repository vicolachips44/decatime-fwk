package org.decatime.ui.component.menu;

import org.decatime.ui.layout.EmptyLayout;
import openfl.Assets;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseBitmapElement;
import org.decatime.ui.component.TextLabel;

class MenuItem extends BaseContainer {
	
	public static inline var SEPARATOR: String = "[separator]";
	public static inline var PATH_SEPARATOR: String = "|";

	private var subItems:Array<MenuItem>;

	public var textLabel(default, null): TextLabel;

	private var label: String;
	private var fontRes: String;
    private var fontSize: Int;
	private var iconRes: String;
	private var subItemsContainer: MenuPanel;
	private var parentMenuItem: MenuItem;
	private var parentPanel: MenuPanel;
	private var parentMenuBar: MenuBar;
	private var itemState: Bool;

	private var isRoot: Bool;

	public function new(in_label: String, ?in_iconRes: String = '') {
		super(in_label);
		this.label = in_label;
		this.iconRes = in_iconRes;
		this.textLabel = new TextLabel(label, 0x000000, 'left');
		this.itemState = false;
        this.fontSize = 12;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (this.getIsSeparator()) {
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.drawRect(r.x + 1, r.y + 1, r.width - 2, 0.5);
		}
	}

	public function setSubItems(values: Array<MenuItem>): Void {
		var item:MenuItem = null;
		for (item in values) {
			item.setFontRes(fontRes);
            item.setFontSize(this.fontSize);
			item.setParent(this);
			item.setParentBar(this.parentMenuBar);
		}
		this.subItems = values;
	}

	public function setState(value: Bool): Void {
		if (value && value != this.itemState) {
			this.addEventListener(MouseEvent.CLICK, onMnuItemClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMnuItemMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMnuItemMouseOut);
			this.textLabel.setColor(0x000000);
			this.itemState = true;
		} else if (! value && value != this.itemState) {
			this.removeEventListener(MouseEvent.CLICK, onMnuItemClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMnuItemMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMnuItemMouseOut);
			this.textLabel.setColor(0x808080);
			this.itemState = false;
		}
	}

	public function getMenuPath(): String {
		if (this.parentMenuItem != null) {
			return this.parentMenuItem.getMenuPath() + MenuItem.PATH_SEPARATOR + this.label;
		}
		return this.label;
	}

	public function getSubItems(): Array<MenuItem> {
		return this.subItems;
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

	public function getIsSeparator(): Bool {
		return this.label == MenuItem.SEPARATOR;
	}

	public function asSubItems(): Bool {
		if (this.subItems == null) { return false; }
		return this.subItems.length > 0;
	}

	public function getSubItemsContainer(): MenuPanel {
		return this.subItemsContainer;
	}

	public function setFontRes(value: String): Void {
		this.fontRes = value;
        this.textLabel.setFontRes(value);
	}

    public function setFontSize(value: Int): Void {
        this.fontSize = value;
        this.textLabel.setFontSize(value);
    }

	public function setParent(item:MenuItem): Void {
		this.parentMenuItem = item;
	}

    public function getParent(): MenuItem {
        return this.parentMenuItem;
    }

	private override function initializeComponent(): Void {
		super.initializeComponent();
		if (this.iconRes.length > 0) {
			var bmIcon: BaseBitmapElement = new BaseBitmapElement();
			bmIcon.setResizable(false);
			bmIcon.bitmapData = Assets.getBitmapData(this.iconRes);
			this.container.create(16, bmIcon);
			this.addChild(bmIcon);
		} else {
            if (! this.isRoot) {
                var pholder: EmptyLayout = new EmptyLayout();
                this.container.create(16, pholder);
            }
        }

		if (this.label != MenuItem.SEPARATOR) {
			this.textLabel.setFontRes(this.fontRes);
			this.container.create(this.textLabel.getTextWidth(), this.textLabel);
			this.addChild(this.textLabel);
			setState(true);
		}

		if (this.asSubItems())  {
			this.subItemsContainer = new MenuPanel('mnu' + this.label + 'SubItemsContainer');
			this.subItemsContainer.setMenuBar(this.parentMenuBar);
			var item:MenuItem = null;

			for (item in this.subItems) {
				this.subItemsContainer.addMenuItem(item);
			}
		}
	}

	private function onMnuItemMouseOver(e:MouseEvent): Void {
		this.graphics.clear();
		this.graphics.beginFill(0xe0e0e0);
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
		if (this.asSubItems()) {
			this.parentMenuBar.updateVisiblity(this);
		}
	}

	private function onMnuItemMouseOut(e:MouseEvent): Void {
		this.graphics.clear();
		this.graphics.beginFill(0xbbbbbb);
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
		if (this.asSubItems()) {
		}
	}

	private function onMnuItemClick(e:MouseEvent): Void {
		if (! this.asSubItems()) {
			this.parentMenuBar.relayClick(this);
			this.parentMenuBar.resetVisibility();
		} else {
			this.parentMenuBar.toggleVisibility(this);
		}
	}
}