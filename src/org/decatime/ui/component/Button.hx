package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Graphics;
import flash.events.MouseEvent;

import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.filters.BitmapFilter;
import flash.display.GradientType;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.Label;

class Button extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.component.Button :";
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";


	private var captionColor: Int;
	private var caption: String;
	private var fontRes: String;
	private var gradientBeginColor: Int;
	private var gradientEndColor: Int;
	private var gradientBeginColorOver: Int;
	private var gradientEndColorOver: Int;
	private var isOver: Bool;

	public function new(caption:String, fontRes: String) {
		super(caption);
		this.captionColor = 0xffffff;
		this.caption = caption;
		this.fontRes = fontRes;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
		this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

		this.gradientBeginColor = 0xffffff;
		this.gradientEndColor = 0x808080;
		this.gradientBeginColorOver = 0x222222;
		this.gradientEndColorOver = 0xaaaaaa;
		this.isOver = false;
	}

	public override function refresh(r: Rectangle): Void {
		super.refresh(r);
		draw(r);
	}

	private function onMouseOut(e:MouseEvent): Void {
		this.isOver = false;
		draw(this.sizeInfo);
	}

	private function onMouseOver(e:MouseEvent): Void {
		this.isOver = true;
		draw(this.sizeInfo);
	}

	private function onMouseClick(e:MouseEvent): Void {
		this.notify(EVT_CLICK, this);
	}

	private function draw(r: Rectangle): Void {
		var g: Graphics = this.graphics;
		g.clear();
		
		var box:Matrix = new Matrix();
		box.createGradientBox(r.width + 10, r.height + 10);
		if (isOver) {
			g.beginGradientFill(GradientType.RADIAL, [this.gradientBeginColorOver, this.gradientEndColorOver], [1, 1], [1, 255], box);
		} else {
			g.beginGradientFill(GradientType.RADIAL, [this.gradientBeginColor, this.gradientEndColor], [1, 1], [1, 255], box);
		}
		g.drawRoundRect(r.x, r.y, r.width, r.height, 20, 20);
		g.endFill();
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setHorizontalGap(2);
		this.container.setVerticalGap(2);

		var lblCaption:Label = new Label(this.caption, captionColor, 'center');
		lblCaption.setFontRes(this.fontRes);
		lblCaption.setColor(0x000066);
		this.container.create(1.0, lblCaption);
		this.addChild(lblCaption);

		var f:Array<BitmapFilter> = new Array<BitmapFilter>();
	    var shadowFilter:DropShadowFilter = new DropShadowFilter(2, 45, 0x808080, 1, 4, 4, 1, 1, false, false, false);
	    f.push(shadowFilter);

		var glow: GlowFilter = new GlowFilter(0x808080, 0.5, 2, 2, 1, 2, true, false);
		f.push(glow);

	    this.filters = f;
	}
}