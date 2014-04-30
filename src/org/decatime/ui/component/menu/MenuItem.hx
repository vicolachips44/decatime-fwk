package org.decatime.ui.component.menu;

import flash.display.Shape;
import org.decatime.ui.layout.EmptyLayout;
import org.decatime.ui.layout.VBox;
import openfl.Assets;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseBitmapElement;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.primitive.Arrow;

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
	private var arrow: Arrow;
	private var arrowShape: Shape;

	public function new(in_label: String, ?in_iconRes: String = '') {
		super(in_label);
		this.label = in_label;
		this.iconRes = in_iconRes;
		this.textLabel = new TextLabel(label, 0x000000, 'left');
		this.itemState = false;
        this.fontSize = 12;
        this.isRoot = false;
	}

	public function setFontColor(value: Int): Void {
		this.textLabel.setFontColor(value);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (this.getIsSeparator()) {
			this.graphics.lineStyle(1, this.parentMenuBar.getFontColor());
			this.graphics.drawRect(r.x + 1, r.y + 1, r.width - 2, 0.5);
		}
		if (this.arrow == null && this.arrowShape != null) {
			this.arrow = new Arrow(this.arrowShape.graphics, Arrow.ORIENTATION_RIGHT);
			var lrect: Rectangle = new Rectangle(0, 0, 16, 16);
			this.arrow.draw(lrect);
		}

		if (this.arrowShape != null) {
			var lx: Float = this.sizeInfo.x + this.sizeInfo.width - 16;
			var ly: Float = this.sizeInfo.y + (this.sizeInfo.height / 2) - 8;
			this.arrowShape.x = lx;
			this.arrowShape.y = ly;
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
			this.textLabel.setFontColor(this.parentMenuBar.getFontColor());
			this.itemState = true;
		} else if (! value && value != this.itemState) {
			this.removeEventListener(MouseEvent.CLICK, onMnuItemClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMnuItemMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMnuItemMouseOut);
			this.textLabel.setFontColor(0x808080);
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
			var vbox:VBox = new VBox(this.container);
			vbox.setHorizontalGap(2);
			vbox.setVerticalGap(0);
			vbox.create(0.5, new EmptyLayout());
			vbox.create(16, bmIcon);
			vbox.create(0.5, new EmptyLayout());
			this.container.create(this.textLabel.getTextHeight(), vbox);
			this.addChild(bmIcon);
		} else {
            if (! this.isRoot) {
                var pholder: EmptyLayout = new EmptyLayout();
                this.container.create(this.textLabel.getTextHeight(), pholder);
            }
        }

		if (this.label != MenuItem.SEPARATOR) {
			this.textLabel.setFontRes(this.fontRes);
			this.container.create(this.textLabel.getTextWidth(), this.textLabel);
			this.addChild(this.textLabel);
			setState(true);
		}

		if (this.asSubItems())  {
			this.subItemsContainer = new MenuPanel('mnu' + this.label + 'SubItemsContainer', this.parentMenuBar.getMenuColor());
			this.subItemsContainer.setMenuBar(this.parentMenuBar);
			var item:MenuItem = null;

			for (item in this.subItems) {
				this.subItemsContainer.addMenuItem(item);
			}

			if (! this.isRoot) {
				// this.arrowShape = new Shape();

				// this.addChild(this.arrowShape);
			}
		}
	}

	private function onMnuItemMouseOver(e:MouseEvent): Void {
		this.graphics.clear();

		this.graphics.beginFill(this.parentMenuBar.getMenuOverColor());
		this.graphics.lineStyle(0.5, 0xaaaaaa);
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
		this.textLabel.setFontColor(this.parentMenuBar.getFontOverColor());
		if (this.asSubItems()) {
			if (this.isRoot) {
				if (this.parentMenuBar.getIsSubmenuActive()) {
					this.parentMenuBar.updateVisiblity(this);
				}
			} else {
				//this.subItemsContainer.show(this.getRectForSubItems());
			}
		}
	}

	private function onMnuItemMouseOut(e:MouseEvent): Void {
		this.graphics.clear();
		this.graphics.beginFill(this.parentMenuBar.getMenuColor());
		this.graphics.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		this.graphics.endFill();
		this.textLabel.setFontColor(this.parentMenuBar.getFontColor());
	}

	private function mouseOnSameLevel(e:MouseEvent): Bool {
		var r:Rectangle = this.getBounds(this.stage);
		return e.stageY >= r.y &&  e.stageY <= (r.y + r.height);
	}

	private function onMnuItemClick(e:MouseEvent): Void {
		if (! this.asSubItems()) {
			this.parentMenuBar.relayClick(this);
			this.parentMenuBar.resetVisibility();
		} else if (this.isRoot) {
			this.parentMenuBar.toggleVisibility(this);
		} else {
			this.parentMenuBar.resetVisibility();
		}
	}

	private function getRectForSubItems(): Rectangle {
		var r: Rectangle = new Rectangle();
		r.x = this.sizeInfo.x + this.sizeInfo.width;
		r.y = this.sizeInfo.y - 2;
		r.width = this.getBigestMenuWidth(this);
		r.height = 100; // TODO calculate this....
		return r;
	}

	// TODO dulicate code here... (see MenuBar)
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
}
