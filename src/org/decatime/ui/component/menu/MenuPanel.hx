package org.decatime.ui.component.menu;
import flash.Lib;

import flash.geom.Rectangle;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import flash.events.Event;
import flash.events.MouseEvent;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.layout.VBox;

class MenuPanel extends BaseContainer {

	private var menuItems: Array<MenuItem>;
	private var parentMenuBar: MenuBar;

	public function new(name:String, backColor: Int) {
		super(name);
		this.menuItems = new Array<MenuItem>();
		this.elBackColorVisibility = 1.0;
		this.elBackColor = backColor;
		this.setVisible(false);

		var f:Array<BitmapFilter> = new Array<BitmapFilter>();

	    var shadowFilter:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, 1, 4, 4, 2, 2, false, false, false);
	    f.push(shadowFilter);
	    this.filters = f;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		this.graphics.lineStyle(1, 0x808080);
		this.graphics.moveTo(r.x, r.y);
		this.graphics.lineTo(r.x + r.width, r.y);
		this.graphics.moveTo(r.x, r.y);
		this.graphics.lineTo(r.x, r.y + r.height);
	}

	public function addMenuItem(item:MenuItem): Void {
		this.menuItems.push(item);
		item.setParentPanel(this);
	}

	public function setMenuBar(value: MenuBar): Void {
		this.parentMenuBar = value;
	}

	public function show(r: Rectangle) : Void {
		this.refresh(r);
		this.addEventListener(flash.events.Event.ADDED_TO_STAGE, onPanelAddedToStage);
		Lib.current.stage.addChild(this);
		this.setVisible(true);
	}

	private function onPanelAddedToStage(e:flash.events.Event): Void {
		this.removeEventListener(Event.ADDED_TO_STAGE, onPanelAddedToStage);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
	}

	public function close(): Void {
		if (this.stage != null) {
			this.stage.removeChild(this);
		}
		this.setVisible(false);
	}

	private function onStageMouseUp(e:flash.events.MouseEvent): Void {
		if (this.stage != null) {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
    close();
    //this.parentMenuBar.resetVisibility();
	}

	public function getIsVisible(): Bool {
		return stage != null;
	}


	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);
		var item:MenuItem = null;

		for (item in this.menuItems) {
			var lsize: Float = item.getIsSeparator() ? 2 : item.textLabel.getTextHeight();
			this.container.create(lsize, item);
			this.addChild(item);
		}
	}
}
