package org.decatime.ui.component;

import flash.display.Graphics;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.layout.HBox;


// TODO the RadioButton instance should belong to a group
class CheckBox extends BaseSelected {
	private var chk:BaseShapeElement;

	public function new(name:String) {
		super(name);
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		this.chk = new BaseShapeElement('chkItem');
		this.container.create(20, chk);

		this.container.create(1.0, this.label);

		this.addChild(this.label);
		this.addChild(this.chk);

		var blur:flash.filters.BlurFilter = new flash.filters.BlurFilter(2, 2, 1);
		this.chk.filters = [blur];
	}

	private override function draw(): Void {
		if (! this.visible) { return; }
		var g:Graphics = this.chk.graphics;
		g.clear();

		if (! this.label.getTransparentBackground()) {
			g.beginFill(this.label.getBackColor(), 1);
			g.drawRect(0, 0, this.chk.getCurrSize().width, this.chk.getCurrSize().height);
			g.endFill();
		}

		g.lineStyle(1 ,0x000000, 1.0);
		var originX:Float = (this.chk.getCurrSize().width / 2) - 6;
		var originY:Float = (this.chk.getCurrSize().height / 2) - 6;

		g.drawRect(originX, originY, 12, 12);

		if (selected) {
			g.lineStyle(2 ,0x000000, 1.0);
			g.moveTo(originX, originY);
			g.lineTo(originX + 12, originY + 12);
			g.moveTo(originX, originY + 12);
			g.lineTo(originX + 12, originY);
		}
	}

	private override function onMouseClick(e:MouseEvent): Void {
		this.selected = ! this.selected;
		draw();
		evManager.notify(BaseSelected.EVT_CLICK, this);
	}
}