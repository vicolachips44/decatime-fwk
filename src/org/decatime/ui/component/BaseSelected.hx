package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;

import org.decatime.ui.BaseShapeElement;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.layout.*;

class BaseSelected extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseSelected :";
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	public var label(default, null): TextLabel;
	private var selected: Bool;
	private var shp:BaseShapeElement;
	private var selItemSize: Float;

	public function new(name:String, ?listen: Bool = true, ?useLabel: Bool = true) {
		super(name);
		
		if (listen) {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		if (useLabel) {
			this.createLabel();
		}
		this.cacheAsBitmap = true;
		selected = false;
		this.selItemSize = 24;
	}

	public function get_label(): TextLabel {
		return label;
	}

	public function getSelected(): Bool {
		return selected;
	}

	public function setSelected(value:Bool): Void {
		selected = value;
		draw();
	}

	public function setSelItemSize(value: Float): Void {
		this.selItemSize = value;
	}

	public function getSelItemSize(): Float {
		return this.selItemSize;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
	}

	private function createLabel(): Void {
		this.label = new TextLabel('', 0x000000 , 'left');
	}

	private function draw(): Void {}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setHorizontalGap(2);
		this.container.setVerticalGap(2);

		this.shp = new BaseShapeElement('chkItem');
		this.shp.cacheAsBitmap = true;

		var vboxCt: VBox = new VBox(this.container);
		vboxCt.setHorizontalGap(0);
		vboxCt.setVerticalGap(0);

		vboxCt.create(0.5, new EmptyLayout());
		vboxCt.create(this.selItemSize, this.shp);
		vboxCt.create(0.5, new EmptyLayout());

		this.container.create(this.selItemSize, vboxCt);

		if (this.label != null) {
			var vboxLbl: VBox = new VBox(this.container);
			vboxLbl.setHorizontalGap(0);
			vboxLbl.setVerticalGap(0);

			vboxLbl.create(0.5, new EmptyLayout());
			vboxLbl.create(20, this.label);
			vboxLbl.create(0.5, new EmptyLayout());

			this.container.create(1.0, vboxLbl);
			this.addChild(this.label);
		}

		this.addChild(this.shp);
	}

	private function onMouseDown(e:MouseEvent): Void {
		evManager.notify(EVT_CLICK, this);
	}
}