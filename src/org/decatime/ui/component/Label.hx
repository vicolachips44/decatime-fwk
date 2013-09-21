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

import org.decatime.ui.BaseBitmapElement;

class Label extends BaseBitmapElement {
	private var color:Int;
	private var align:String;
	private var fontRes:Font;
	private var fontSize:Int;
	private var tfield:TextField;

	public function new(text:String, ?color:Int = 0x000000, ?align:String = 'left') {
		super();

		this.color = color;
		this.align = align;

		this.fontSize = 12;

		tfield = new TextField();
		tfield.selectable = false;
		tfield.autoSize = TextFieldAutoSize.LEFT;
		tfield.mouseEnabled = false;
		tfield.text = text;
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
		return tfield.text;
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

	private function draw(): Void {	
		if (this.fontRes != null) {
			createEmbeddedFontTextFormat();
		} else {
			createSimpleTextFormat();
		}
		if (this.align == 'left') {
			this.bitmapData.draw(
				tfield,
				new Matrix(1, 0, 0 , 1 , 2, (this.sizeInfo.height / 2) - (tfield.textHeight / 2)),  // add a two pixel margin
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align == 'center') {
			this.bitmapData.draw(
				tfield,
				new Matrix(1, 0, 0 , 1 , (this.sizeInfo.width / 2) - (tfield.textWidth / 2), (this.sizeInfo.height / 2) - (tfield.textHeight / 2)), 
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align== 'right') {
			this.bitmapData.draw(
				tfield,
				new Matrix(1, 0, 0 , 1 ,
					this.sizeInfo.width - tfield.textWidth - 2, 
					(this.sizeInfo.height / 2) - (tfield.textHeight / 2)), 
				null, 
				null, 
				null, 
				true 
			);
		}
	}

	private function createSimpleTextFormat(): Void {
		// TODO See what we should do here...
	}

	private function createEmbeddedFontTextFormat(): Void {
		trace("creating embedded Fond text format");
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			true
		);

		tfield.embedFonts = true;
		tfield.defaultTextFormat = format;
		tfield.setTextFormat(format);
	}
}