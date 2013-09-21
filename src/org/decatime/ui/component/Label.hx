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
	private var color:Int;
	private var align:String;
	private var fontRes:Font;
	private var fontSize:Int;
	private var isBold:Bool;
	private var tfield:TextField;
	private var initialized:Bool;

	public function new(text:String, ?color:Int = 0x000000, ?align:String = 'left') {
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

		this.initialized = false;

	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		this.draw();
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = Assets.getFont(fontRes);
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
	}

	public function getText(): String {
		return this.tfield.text;
	}

	public function setText(value:String): Void {
		tfield.text = value;
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
	}

	public function getAlign(): String {
		return this.align;
	}

	public function setAlign(value:String): Void {
		this.align = value;
	}

	public function getIsBold(): Bool {
		return this.isBold;
	}

	public function setIsBold(value:Bool): Void {
		this.isBold = value;
	}

	private function draw(): Void {	
		if (this.fontRes != null) {
			createEmbeddedFontTextFormat();
		} else {
			throw new Error("this component needs a Font resource: use setFontRes('assets/$fontName.ttf' for example");
		}
		if (this.align == 'left') {
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
		} else if (this.align == 'center') {
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
		} else if (this.align== 'right') {
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
		trace("creating embedded Fond text format");
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			true
		);

		this.tfield.embedFonts = true;
		this.tfield.defaultTextFormat = format;
		this.tfield.setTextFormat(format);
	}
}