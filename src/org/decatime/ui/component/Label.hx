package org.decatime.ui.component;

import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.geom.Rectangle;
import flash.display.PixelSnapping;
import flash.geom.Matrix;

import org.decatime.ui.BaseBitmapElement;

class Label extends BaseBitmapElement {
	private var text:String;
	private var color:Int;
	private var align:String;
	private var fontName:String;
	private var fontSize:Int;

	private var tfield:TextField;


	private var bmData:BitmapData;

	public function new(text:String, ?color:Int = 0x000000, ?align:String = 'left') {
		bmData = new BitmapData(0, 0, true, color);
		super(bmData, PixelSnapping.NEVER);

		this.text = text;
		this.color = color;
		this.align = align;

		tfield = new TextField();
		tfield.selectable = false;
		tfield.autoSize = TextFieldAutoSize.LEFT;
		tfield.mouseEnabled = false;
		tfield.text = text;

		this.fontName = "";
		this.fontSize = 12;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		trace ("The label component is about to be refreshed");
		this.draw();
		this.x = r.x;
		this.y = r.y;

	}

	public function setFontName(name:String): Void {
		this.fontName = name;
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		this.refresh(this.getCurrSize());
	}

	public function getText(): String {
		return this.text;
	}

	public function setText(value:String): Void {
		this.text = value;
		this.refresh(this.getCurrSize());
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		this.refresh(this.getCurrSize());
	}

	public function getAlign(): String {
		return this.align;
	}

	public function setAlign(value:String): Void {
		this.align = value;
		this.refresh(this.getCurrSize());
	}

	private function draw(): Void {
		if (this.fontName != "") {
			createEmbeddedFontTextFormat();
		} else {
			createSimpleTextFormat();
		}

		var bmCache:BitmapData = new BitmapData(
			Std.int(this.sizeInfo.width), 
			Std.int(this.sizeInfo.height), 
			true, 
			0x000000
		);
	
		if (this.align == 'left') {
			bmCache.draw(
				tfield,
				new Matrix(1, 0, 0 , 1 , 2, (this.sizeInfo.height / 2) - (tfield.textHeight / 2)),  // add a two pixel margin
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align == 'center') {
			bmCache.draw(
				tfield,
				new Matrix(1, 0, 0 , 1 , (this.sizeInfo.width / 2) - (tfield.textWidth / 2), (this.sizeInfo.height / 2) - (tfield.textHeight / 2)), 
				null, 
				null, 
				null, 
				true 
			);
		} else if (this.align== 'right') {
			bmCache.draw(
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
		var format:TextFormat = new TextFormat(
			this.fontName, 
			this.fontSize, 
			this.color,
			true
		);

		tfield.embedFonts = true;
		tfield.defaultTextFormat = format;
		tfield.setTextFormat(format);
	}
}