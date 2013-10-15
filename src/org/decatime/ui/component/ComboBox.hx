package org.decatime.ui.component;

import openfl.Assets;
import flash.display.Graphics;
import flash.display.DisplayObject;

import flash.geom.Rectangle;
import flash.geom.Point;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.text.Font;
import flash.text.AntiAliasType;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.Content;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

class ComboBox extends BaseContainer implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.component.ComboBox :";
	public static var EVT_ITEM_SELECTED:String = NAMESPACE + "EVT_ITEM_SELECTED";

	private var tbox: TextBox;
	private var fontRes: String;
	private var dropDownList:ListBox;
	private var dropDownListMask: BaseSpriteElement;
	private var parentContainer:BaseSpriteElement;

	public function new(name:String, fontRes:String) {
		super(name);
		this.fontRes = fontRes;

		this.tbox = new TextBox('textBoxValue', '');
		this.tbox.setFontRes(this.fontRes);
		this.tbox.setAsBorder(false);
		

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

		var btnDropDown: ArrowButton = new ArrowButton('dpDownButton', ArrowButton.ORIENTATION_BOTTOM);
		btnDropDown.addListener(this);

		this.addChild(btnDropDown);

		this.container.create(1.0, this.tbox);
		var ct:Content = this.container.create(24, btnDropDown);
		ct.setHorizontalGap(4);
		ct.setVerticalGap(4);

		this.addChild(this.tbox);
		// mask of the list content
		this.dropDownListMask = new BaseSpriteElement('dropDownListMask');

		this.dropDownListMask.addChild(this.dropDownList);
		this.parentContainer = cast (org.decatime.Facade.getInstance().getRoot(), BaseSpriteElement);
		this.dropDownListMask.addEventListener(flash.events.MouseEvent.CLICK, onListContainerMouseClick);
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
			var r:Rectangle = this.getBounds(this.myStage);
			r = new Rectangle(r.x + 1, r.y + this.sizeInfo.height, this.sizeInfo.width, this.dropDownList.getItemsHeight() * this.dropDownList.getListCount());
			this.parentContainer.addChild(this.dropDownListMask);
			
			this.dropDownList.visible = true;
			this.myStage.focus = this.dropDownList;
			this.dropDownList.refresh(r);
		}
	}

	private function onListContainerMouseClick(e:flash.events.MouseEvent): Void {
		if (this.parentContainer.contains(this.dropDownListMask)) {
			this.parentContainer.removeChild(this.dropDownListMask);
		}
		this.dropDownList.visible = false;
	}

	private function draw(): Void {
		var g:Graphics = this.graphics;
		g.clear();
		g.lineStyle(1, 0x000000);
		g.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);

		var r:Rectangle = this.parentContainer.getCurrSize();

		g = this.dropDownListMask.graphics;
		g.clear();
		g.beginFill(0x000000, 0.0);
		g.drawRect(r.x, r.y, r.width, r.height);
	}
}