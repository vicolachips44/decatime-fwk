package org.decatime.ui.component;

import openfl.Assets;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.events.TextEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.Font;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Stage;

import org.decatime.ui.layout.ILayoutElement;

class Textbox extends TextField implements ILayoutElement {
	private var sizeInfo:Rectangle;
	private var fontRes:Font;
	private var color:Int;
	private var fontSize:Int;
	private var margin:Point;
	private var initialized:Bool;
	private var asBorder:Bool;
	private var txtBorderColor:Int;
	private var myStage:Stage;

	public function new(name:String, ?text:String = ' ', ?color:Int=0x000000) {
		super();
		this.name = name;
		this.type = TextFieldType.INPUT;
		this.mouseEnabled = true;
		this.selectable = true;
		this.autoSize = TextFieldAutoSize.NONE;
		this.margin = new Point(2, 2);
		this.myStage = flash.Lib.current.stage;
		// if the text length is equal to zero the caret will not be visible in the textbox
		// for some platforms.
		this.text = text.length == 0 ? ' ' : text;
		this.fontSize = 12;
		this.asBorder = true;
		this.txtBorderColor = 0x000000;

		this.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
		this.addEventListener(Event.CHANGE, onTxtChange);
		this.myStage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
	}

	public function setMargin(p:Point): Void {
		this.margin = p;
		this.updateDisplay();
	}

	public function getMargin(): Point {
		return this.margin;
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = Assets.getFont(fontRes);
		this.updateDisplay();
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		this.updateDisplay();
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		this.updateDisplay();
	}

	public function refresh(r:Rectangle): Void {
		this.sizeInfo = r;
		
		this.x = r.x + margin.x;
		this.y = r.y + margin.y;
		this.width = r.width - (margin.x * 2);
		this.height = r.height - (margin.y * 2);

		this.draw();

		this.initialized = true;
	}

	public function getCurrSize(): Rectangle {
		return sizeInfo;
	}

	public function setVisible(value:Bool): Void {
		this.visible = value;
	}

	private function draw(): Void {
		createEmbeddedFontTextFormat();
		this.border = asBorder;
		this.borderColor = txtBorderColor;

	}

	private function updateDisplay(): Void {
		// if the initial drawing was done we can call agin the refresh method.
		if (this.initialized) {
			this.refresh(this.sizeInfo);
		}
	}

	private function createEmbeddedFontTextFormat(): Void {
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			true
		);

		this.embedFonts = true;
		this.defaultTextFormat = format;
		this.setTextFormat(format);
	}

	private function textInputHandler(e:TextEvent): Void {
		trace ("in textInputHandler method - BEGIN: if you see this one call me !");
		if (this.text.length == 0) {
			this.text = ' ';
			e.stopImmediatePropagation();
			trace ("trapped");
		}
	}

	private function onStageKeyDown(e:KeyboardEvent): Void {
		if (flash.Lib.current.stage.focus == this) {
			trace (e.keyCode);
			trace ("text value is " + this.text);
			trace ("text lenght is " + this.text.length);
			if (e.keyCode == 8 && this.text.length == 1) {
				e.stopPropagation();
			}
		}
		
		// if (this.text.length < 2) {
		// 	this.text = '  z';
		// 	this.setSelection(2, 2);
		// 	this.text = '  ';
		// 	e.stopPropagation();
		// }
	}

	private function onTxtChange(e:Event): Void {
		// trace ("event change fired on text element");
		// if (this.text.length == 0) {
		// 	this.text = ' ';
		// 	trace ("trapped");
		// 	this.stage.focus = org.decatime.Facade.getInstance().getRoot();
		// 	this.stage.focus = this;
		// 	trace ("my caret has leave the stage please clic on the textbox again... don't try the tab key... it does not work for the moment");
		// }
	}
}