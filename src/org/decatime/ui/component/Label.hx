package org.decatime.ui.component;

import openfl.Assets;

import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.text.Font;
import flash.geom.Rectangle;
import flash.display.PixelSnapping;
import flash.geom.Matrix;
import flash.errors.Error;

import org.decatime.ui.BaseBitmapElement;

class Label extends BaseBitmapElement {
	public static inline var LEFT:String = 'left';
	public static inline var CENTER:String = 'center';
	public static inline var RIGHT:String = 'right';

	private var color:Int;
	private var align:String;
	private var fontRes:Font;
	private var fontSize:Int;
	private var isBold:Bool;
	private var tfield:TextField;
	private var initialized:Bool;

	public function new(text:String, ?color:Int = 0x000000, ?align:String = Label.LEFT) {
		super();

		this.color = color;
		this.align = align;

		this.fontSize = 12;
		this.isBold = true;

		this.tfield = new TextField();
		this.tfield.selectable = false;
		this.tfield.autoSize = TextFieldAutoSize.LEFT;
		this.tfield.mouseEnabled = false;
		this.tfield.text = text;
		this.tfield.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		this.initialized = false;

	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);

		if (! this.initialized) {
			if (this.fontRes != null) {
				createEmbeddedFontTextFormat();
			} else {
				throw new Error("this component needs a Font resource: use setFontRes('assets/$fontName.ttf' for example");
			}
			this.draw();
		}

		this.initialized = true;
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = Assets.getFont(fontRes);
		this.updateDisplay();
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		this.updateDisplay();
	}

	public function getFontSize(): Int {
		return this.fontSize;
	}

	public function getText(): String {
		return this.tfield.text;
	}

	public function setText(value:String): Void {
		tfield.text = value;
		this.updateDisplay();
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		this.updateDisplay();
	}

	public function getAlign(): String {
		return this.align;
	}

	public function setAlign(value:String): Void {
		this.align = value;
		this.updateDisplay();
	}

	public function getIsBold(): Bool {
		return this.isBold;
	}

	public function setIsBold(value:Bool): Void {
		this.isBold = value;
		this.updateDisplay();
	}

	public override function setHorizontalGap(value:Float): Void {
		super.setHorizontalGap(value);
		this.updateDisplay();
	}

	public override function setVerticalGap(value:Float): Void {
		super.setVerticalGap(value);
		this.updateDisplay();
	}

	public override function setTransparentBackground(value:Bool): Void {
		super.setTransparentBackground(value);
		this.updateDisplay();
	}

	public override function setBackColor(value:Int): Void {
		super.setBackColor(value);
		this.updateDisplay();
	}

	private function updateDisplay(): Void {
		// if the initial drawing was done we can call agin the refresh method.
		if (this.initialized) {
			this.refresh(this.getCurrSize());
		}
	}

	private function draw(): Void {
		if (this.align == Label.LEFT) {
			this.bitmapData.draw(
				this.tfield,
				new Matrix(1, 0, 0 , 1 , 2,
					(this.sizeInfo.height / 2) - (this.tfield.textHeight / 2)
				),
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align == Label.CENTER) {
			this.bitmapData.draw(
				this.tfield,
				new Matrix(1, 0, 0 , 1 , 
					(this.sizeInfo.width / 2) - (this.tfield.textWidth / 2), 
					(this.sizeInfo.height / 2) - (this.tfield.textHeight / 2)
				), 
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align== Label.RIGHT) {
			this.bitmapData.draw(
				this.tfield,
				new Matrix(1, 0, 0 , 1 ,
					this.sizeInfo.width - this.tfield.textWidth - 2, 
					(this.sizeInfo.height / 2) - (this.tfield.textHeight / 2)
				), 
				null, 
				null, 
				null, 
				true 
			);
		}
	}

	private function createEmbeddedFontTextFormat(): Void {
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			false
		);

		this.tfield.embedFonts = true;
		this.tfield.defaultTextFormat = format;
		this.tfield.setTextFormat(format);
	}
}