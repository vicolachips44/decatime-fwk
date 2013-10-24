package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.Label;
import org.decatime.ui.layout.HBox;

class BaseSelected extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseSelected :";
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	public var label(default, null): Label;
	private var selected: Bool;
	private var shp:BaseShapeElement;

	public function new(name:String, ?listen: Bool = true, ?useLabel: Bool = true) {
		super(name);
		
		if (listen) {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		if (useLabel) {
			this.createLabel();
		}
		
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
		draw();
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
	}

	private function createLabel(): Void {
		this.label = new Label('', 0x000000 , 'left');
	}

	private function draw(): Void {}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		this.shp = new BaseShapeElement('chkItem');
		this.container.create(20, shp);

		if (this.label != null) {
			this.container.create(1.0, this.label);
			this.addChild(this.label);
		}

		this.addChild(this.shp);

		var blur:flash.filters.BlurFilter = new flash.filters.BlurFilter(2, 2, 1);
		this.shp.filters = [blur];
	}

	private function onMouseDown(e:MouseEvent): Void {
		evManager.notify(EVT_CLICK, this);
	}
}