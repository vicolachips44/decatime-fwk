package org.decatime.ui.component;

import openfl.Assets;

import flash.errors.Error;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.text.Font;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Stage;
import flash.display.DisplayObject;

import org.decatime.ui.layout.ILayoutElement;

class Textbox extends TextField implements ILayoutElement implements ITabStop {
	private var sizeInfo:Rectangle;
	private var fontRes:Font;
	private var color:Int;
	private var fontSize:Int;
	private var margin:Point;
	private var initialized:Bool;
	private var asBorder:Bool;
	private var txtBorderColor:Int;
	private var myStage:Stage;

	#if !flash
	private var tabIndex:Int;
	#end

	private var borderColorFocus:Int;

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
		this.text = '';
		this.fontSize = 12;
		this.asBorder = true;
		this.txtBorderColor = 0x000000;
		this.borderColorFocus = 0x0000fa;

		this.tabIndex = -1; // must be setted client side


		this.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
		this.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
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

	public function setBorderColorFocus(value:Int): Void {
		this.borderColorFocus = value;
	}

	public function setTxtBorderColor(value:Int): Void {
		this.txtBorderColor = value;
	}

	// ITabStop implementation BEGIN

	public function getTabIndex(): Int {
		return this.tabIndex;
	}

	public function setTabIndex(value:Int): Void {
		this.tabIndex = value;
	}

	public function setFocus(): Void {
		flash.Lib.current.stage.focus = this;
	}

	// ITabStop implementation END

	// ILayoutElement implementation BEGIN

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
		this.visible = value; // TextField property
	}

	// ILayoutElement implementation END

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

	private function onStageKeyUp(e:KeyboardEvent): Void {
		if (e.keyCode == 9) {
			e.keyCode = 0; // prevent an infinite loop...
			processTabIndex();
			
		}
	}

	private function processTabIndex(): Void {
		var nbChilds:Int = this.parent.numChildren;
		var i:Int = 0;
		var smallestTbIndex:Int = 100;
		var nextTabElement:ITabStop = null;

		for (i in 0...nbChilds) {
			var child:DisplayObject = this.parent.getChildAt(i);
			
			if (Std.is(child, ITabStop)) {
				var tbHandler:ITabStop = cast(child, ITabStop);
				
				if (tbHandler.getTabIndex() == -1) {
					trace ("warning: the tab index has not been setted on child " + child.name);
					continue;
				}

				if (tbHandler.getTabIndex() == this.getTabIndex() + 1) {
					tbHandler.setFocus();
					return;	
				}
				if (tbHandler.getTabIndex() < smallestTbIndex) {
					nextTabElement = tbHandler;
					smallestTbIndex = tbHandler.getTabIndex();
				}
			}
		}
		// we give the focus to the smallest tab index value
		if (nextTabElement != null) {
			nextTabElement.setFocus();
		}
	}

	private function onTxtFocusIn(e:FocusEvent): Void {
		// Since we have the focus, we wan't to listen to keydown event
		// TODO: Check this on android...
		#if !flash
		this.myStage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		#end
		
		this.borderColor = this.borderColorFocus;
	}

	private function onTxtFocusOut(e:FocusEvent): Void {
		#if !flash
		this.myStage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		#end

		this.borderColor = this.txtBorderColor;
	}
}