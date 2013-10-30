package org.decatime.ui.component.windows;

import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.filters.BlurFilter;
import flash.filters.BitmapFilter;
import flash.display.GradientType;
import flash.filters.DropShadowFilter;
import flash.events.MouseEvent;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.TextLabel;

class Header extends HBox {
	public var showCloseButton(default, default): Bool;
	public var showStateButton(default, default): Bool;
	public var showMinimizeButton(default, default): Bool;

	private var titleText: TextLabel;
	private var closeButton: BaseSpriteElement;
	private var stateButton: BaseSpriteElement;
	private var minimizeButton: BaseSpriteElement;
	private var parentWindow: Window;
	private var title: String;
	private var fontRes: String;
	private var initialized:Bool;

	public function new(in_parent:Window, in_title: String, in_fontRes: String) {
		super(in_parent);
		this.parentWindow = in_parent;
		this.hgap = 4;
		this.vgap = 3;
		this.fontRes = in_fontRes;

		this.showCloseButton = true;
		this.showStateButton = true;
		this.showMinimizeButton= false;
		this.title = in_title;
		this.initialized = false;
	}

	public function getBoundArea(): Rectangle {
		if (this.titleText == null) { return null; }
		return this.titleText.getBounds(this.titleText.stage);
	}

	public override function refresh(r: Rectangle): Void {
		if (! this.initialized) {
			initializeTitleText();

			this.minimizeButton = new BaseSpriteElement('minimizeButton');
			this.minimizeButton.isContainer = false;
			this.minimizeButton.setSupportDisableState(false);
			this.minimizeButton.cacheAsBitmap = true;
			this.create(20, this.minimizeButton);
			this.parentWindow.addChild(this.minimizeButton);
			this.minimizeButton.addEventListener(MouseEvent.CLICK, onBtnMinimizeClick);

			this.stateButton = new BaseSpriteElement('stateButton');
			this.stateButton.isContainer = false;
			this.stateButton.cacheAsBitmap = true;
			this.create(20, this.stateButton);
			this.parentWindow.addChild(this.stateButton);
			this.stateButton.addEventListener(MouseEvent.CLICK, onBtnStateClick);

			this.closeButton = new BaseSpriteElement('closeButton');
			this.closeButton.isContainer = false;
			this.minimizeButton.setSupportDisableState(false);
			this.closeButton.cacheAsBitmap = true;
			this.create(16, this.closeButton);
			this.parentWindow.addChild(this.closeButton);
			this.closeButton.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
		}

		super.refresh(r);

		drawCloseButton();
		drawStateButton();
		drawMinimizeButton();

		initialized = true;
	}

	private function initializeTitleText(): Void {
		this.titleText = new TextLabel(this.title, 0xffffff, 'center');
		this.titleText.setFontRes(this.fontRes);
		this.titleText.setFontSize(12);
		this.titleText.setIsBold(true);
		this.create(1.0, this.titleText);
		this.parentWindow.addChild(this.titleText);
	}

	public function draw(): Void {
		drawState(true);
	}

	public function drawState(value: Bool): Void {
		var box:Matrix = new Matrix();
		box.createGradientBox(currSize.width, currSize.height);
		if (value) {
			this.parentWindow.graphics.beginGradientFill(GradientType.RADIAL, [0x66B2FF, 0x004C99], [1, 1], [1, 255], box);
		} else {
	    	this.parentWindow.graphics.beginGradientFill(GradientType.RADIAL, [0xaaaaaa, 0x777777], [1, 1], [1, 255], box);
		}
	    this.parentWindow.graphics.drawRect(1, 1, this.currSize.width, this.currSize.height);
	    this.parentWindow.graphics.endFill();
	    this.parentWindow.graphics.lineStyle(1);
	    this.parentWindow.graphics.moveTo(0, currSize.height);
	    this.parentWindow.graphics.lineTo(currSize.width, currSize.height);	
	}

	private function onBtnCloseClick(e:MouseEvent): Void {
		this.parentWindow.remove();
	}

	private function onBtnStateClick(e:MouseEvent): Void {
		this.parentWindow.setWindowState(
			this.parentWindow.getWindowState() == WindowState.NORMAL
			? WindowState.MAXIMIZED
			: WindowState.NORMAL
		);
	}

	private function onBtnMinimizeClick(e:MouseEvent): Void {
		this.parentWindow.minimize();
	}

	private function drawMinimizeButton(): Void {
		var gfx = this.minimizeButton.graphics;
		gfx.clear();
    	gfx.beginFill(0x000000);
	    gfx.drawRect(0, 14, 16, 2);
		gfx.lineStyle(1);
	    gfx.moveTo(0, 12);
	    gfx.lineTo(16, 12);
	    gfx.endFill();
	}

	private function drawStateButton(): Void {
		var gfx = this.stateButton.graphics;
		gfx.clear();
    	gfx.lineStyle(1, 0x000000);
    	if (this.parentWindow.getWindowState() == WindowState.NORMAL) {
	    	gfx.beginFill(0xffffff, 1.0);
	    	gfx.drawRect(0, 0, 16, 16);
	    	gfx.endFill();
	    	gfx.beginFill(0x000000, 1.0);
	    	gfx.drawRect(0, 0, 16, 3);
	    	gfx.endFill();
    	} else {
    		gfx.beginFill(0xffffff, 1.0);
	    	gfx.drawRect(8, 2, 10, 8);
	    	gfx.endFill();
	    	gfx.beginFill(0x000000, 1.0);
	    	gfx.drawRect(8, 0, 10, 2);
	    	gfx.endFill();
	    	gfx.beginFill(0xffffff, 1.0);
	    	gfx.drawRect(0, 5, 10, 10);
	    	gfx.endFill();
	    	gfx.beginFill(0x000000, 1.0);
	    	gfx.drawRect(0, 5, 10, 2);
	    	gfx.endFill();
    	}
	}

	private function drawCloseButton(): Void {
		var box:Matrix = new Matrix();
		var gfx = this.closeButton.graphics;

		box.createGradientBox(16, 16, 0, 0, 0);

        gfx.clear();
        gfx.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xaaaaaa], [1, 1], [1, 255], box);
        gfx.drawCircle(8, 8, 8);
        gfx.endFill();
        gfx.lineStyle(1, 0x000000);
        gfx.moveTo(4, 4);
        gfx.lineTo(12, 12);
        gfx.moveTo(4, 12);
        gfx.lineTo(12, 4);
	}
}