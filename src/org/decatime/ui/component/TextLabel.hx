package org.decatime.ui.component;

import openfl.Assets;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.text.Font;
import flash.geom.Rectangle;
import flash.errors.Error;
import flash.text.AntiAliasType;

import org.decatime.ui.layout.ILayoutElement;


class TextLabel extends TextField implements ILayoutElement {
	public static inline var LEFT:String = 'left';
	public static inline var CENTER:String = 'center';
	public static inline var RIGHT:String = 'right';
    private static inline var HSPACE: Int = 4;
    private static inline var VSPACE: Int = 2;

	private var fontRes:Font;
	private var fontResPath: String;
	private var sizeInfo: Rectangle;
	private var fontSize: Int;
	private var color: Int;
	private var align: String;
	private var isBold:Bool;
	private var tagRef: Dynamic;

	public function new(text:String, ?color:Int = 0x000000, ?align: String = 'center') {
		super();

		this.selectable = false;
		this.mouseEnabled = false;
		this.autoSize = TextFieldAutoSize.NONE;

		this.text = text;
		this.align = align;
		this.fontSize = 12;
		this.color = color;
		this.isBold = false;

		this.antiAliasType = AntiAliasType.NORMAL;
	}

    #if !flash
    public override function set_text(value: String): String {
        // just here to demonstrate the override on that kind of property...
        super.set_text(value);
        return value;
    }
    #end

    public function getTextWidth(): Float {
        checkFontRes();
        // refresh the font properties
        createEmbeddedFontTextFormat();
        // refreshing the text content
        var ltext: String = this.text;
        this.text = '';
        this.text = ltext;
        return this.textWidth + HSPACE;
    }

    private function checkFontRes(): Void {
        if (this.fontRes == null) {
            throw new Error("Font resource must be specified before calling this method");
        }
    }

    public function getTextHeight(): Float {
        checkFontRes();
        // refresh the font properties
        createEmbeddedFontTextFormat();
        // refreshing the text content
        var ltext: String = this.text;
        this.text = '';
        this.text = ltext;
        return this.textHeight + VSPACE;
    }

	public function setTagRef(value: Dynamic) : Void {
		this.tagRef = value;
	}

	public function getTagRef(): Dynamic {
		return this.tagRef;
	}

	public function getFontResPath(): String {
		return this.fontResPath;
	}

	public function setFontRes(fontRes:String): Void {
		this.fontResPath = fontRes;
		this.fontRes = Assets.getFont(fontRes);
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
        if (this.fontRes == null) {
            throw new Error("You must set the fontRes property before setting the font size");
        }
        createEmbeddedFontTextFormat();
	}

	public function getFontSize(): Int {
		return this.fontSize;
	}

	public function getText(): String {
		return this.text;
	}

	public function setText(value:String): Void {
		this.text = value;
	}

	public function getIsBold(): Bool {
		return this.isBold;
	}

	public function setIsBold(value:Bool): Void {
		this.isBold = value;
		if (this.defaultTextFormat != null) {
			this.defaultTextFormat.bold = this.isBold;
		}
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		if (this.defaultTextFormat != null) {
			this.defaultTextFormat.color = this.color;
		}
	}
	
	public function refresh(r:Rectangle): Void {

		if (this.fontRes != null) {
			createEmbeddedFontTextFormat();
		} else {
			throw new Error("this component labeled " + this.text + " needs a Font resource: use setFontRes('assets/$fontName.ttf' for example");
		}

		this.sizeInfo = r;
		this.x = r.x;
		this.y = r.y;
		this.width = r.width;
		this.height = r.height;

	}

	public function getCurrSize():Rectangle {
		return this.sizeInfo;
	}

	public function setVisible(value:Bool):Void {
		this.visible = value;
	}

	private function createEmbeddedFontTextFormat(): Void {
        if (this.fontRes == null) { return; } // FIXME: should be removed
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			this.isBold
		);
		if (this.align == 'center') {
			format.align = flash.text.TextFormatAlign.CENTER;
		} else if (this.align == 'left') {
			format.align = flash.text.TextFormatAlign.LEFT;
		} else if (this.align == 'right') {
			format.align = flash.text.TextFormatAlign.RIGHT;
		}
		
		this.embedFonts = true;
		this.defaultTextFormat = format;
		this.setTextFormat(format);
	}
}