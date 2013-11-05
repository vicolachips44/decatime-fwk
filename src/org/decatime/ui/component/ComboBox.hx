package org.decatime.ui.component;

import openfl.Assets;
import flash.display.Graphics;
import flash.display.DisplayObject;

import flash.geom.Rectangle;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.ui.primitive.Arrow;

class ComboBox extends BaseContainer implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.component.ComboBox :";
	public static var EVT_ITEM_SELECTED:String = NAMESPACE + "EVT_ITEM_SELECTED";

	private var tbox: TextBox;
	private var fontRes: String;
	private var dropDownList:ListBox;
	private var parentContainer:BaseSpriteElement;

	public function new(name:String, fontRes:String) {
		super(name);
		this.fontRes = fontRes;

		this.tbox = new TextBox('textBoxValue', '');
		this.tbox.setFontRes(this.fontRes);
		this.tbox.setAsBorder(false);
		this.tbox.mouseEnabled = false;
		this.tbox.selectable = false;

		this.dropDownList = new ListBox('dropDownList', this.fontRes);
		this.dropDownList.visible = false;
		this.dropDownList.showScrollBar = false;
		this.dropDownList.addListener(this);
	}

	public function add(item:IPrintable): Void {
		this.dropDownList.add(item);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
	}

	public function getValue(): Dynamic {
		return this.tbox.text;
	}

	public function setValue(value: Dynamic): Void {
		this.tbox.text = Std.string(value);
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		var btnDropDown: ArrowButton = new ArrowButton('dpDownButton', Arrow.ORIENTATION_BOTTOM);
		btnDropDown.addListener(this);

		this.addChild(btnDropDown);

		this.container.create(1.0, this.tbox);
		var ct:Content = this.container.create(24, btnDropDown);
		ct.setHorizontalGap(4);
		ct.setVerticalGap(4);

		this.addChild(this.tbox);
	}

	private override function initializeEvent(): Void {
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ArrowButton.EVT_CLICK:
				this.showHideDropDown(! this.dropDownList.visible);
			case ListBox.EVT_ITEM_SELECTED:
				this.tbox.text = Std.string(data);
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK,
			ListBox.EVT_ITEM_SELECTED
		];
	}

	// IObserver implementation END


	private function showHideDropDown(bShow: Bool): Void {
		if (bShow) {
			this.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onStageMouseUp);

			var r:Rectangle = this.getBounds(this.myStage);
			r = new Rectangle(r.x, r.y + this.sizeInfo.height, this.sizeInfo.width + 2, (this.dropDownList.getItemsHeight() * this.dropDownList.getListCount()) + 4);
			this.dropDownList.refresh(r);

			this.stage.addChild(this.dropDownList);
			this.dropDownList.visible = true;
			this.myStage.focus = this.dropDownList;
		} else {
			if (this.dropDownList == null) { return; }
			this.dropDownList.visible = false;
			if (this.stage.contains(this.dropDownList)) {
				this.stage.removeChild(this.dropDownList);
			}
		}
	}

	private function onStageMouseUp(e:flash.events.MouseEvent): Void {
		this.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onStageMouseUp);
		showHideDropDown(false);
	}

	private function onListContainerMouseClick(e:flash.events.MouseEvent): Void {
		showHideDropDown(false);
	}

	private function draw(): Void {
		var g:Graphics = this.graphics;
		g.clear();
		g.lineStyle(1, 0x000000);
		g.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
	}
}