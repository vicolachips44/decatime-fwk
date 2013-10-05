package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;
import org.decatime.ui.layout.HBox;

class BaseSelected extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseSelected :";
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	public var label(default, null): Label;
	private var selected: Bool;

	public function new(name:String) {
		super(name);
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
		this.label = new Label('', 0x000000 , 'left');
		selected = false;
	}

	public function get_label(): Label {
		return label;
	}

	public function getSelected(): Bool {
		return selected;
	}

	public function setSelected(value:Bool): Void {
		selected = value;
		//draw();
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
	}

	private function draw(): Void {
		if (! this.visible) { return; }

		if (this.selected) {
			drawSelected();
		} else {
			drawUnselected();
		}
	}
	private function drawSelected(): Void {}
	private function drawUnselected(): Void {}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);
		this.container.create(1.0, this.label);
		this.addChild(this.label);
	}

	private function onMouseClick(e:MouseEvent): Void {
		evManager.notify(EVT_CLICK, this);
	}
}