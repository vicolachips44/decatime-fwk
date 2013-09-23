package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Sprite;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.Textbox;

class TextArea extends BaseSpriteElement {
	private var initialized:Bool;
	private var tfield:Textbox;
	private var fontRes:String;
	private var color:Int;
	private var fontSize:Int;

	private var vbox1:VBox;

	public function new() {
		super('decatimeTextArea');
		this.fontSize = 12;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (!this.initialized) {
			initializeComponent();
		}
		this.vbox1.refresh(r);
		this.initialized = true;
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = fontRes;
		if (this.tfield != null) {
			this.tfield.setFontRes(this.fontRes);
			this.updateDisplay();
		}
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		if (this.tfield != null) {
			this.tfield.setFontSize(size);
			this.updateDisplay();
		}
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		this.updateDisplay();
	}

	private function updateDisplay(): Void {
		// if the initial drawing was done we can call agin the refresh method.
		if (this.initialized) {
			this.refresh(this.sizeInfo);
		}
	}

	private function initializeComponent(): Void {
		// A TextField 
		initializeTextField();
		// A Vertical Scroll bar
		var VscBar1:BaseSpriteElement = new BaseSpriteElement("tempObject");
		// A Horizontal Scroll bar
		var HScBar1:BaseSpriteElement = new BaseSpriteElement("tempObject2");

		// Our main container is a VBOX
		this.vbox1 = new VBox(this);
		var hbox1:HBox = new HBox(this.vbox1);

		this.vbox1.create(1.0, hbox1);
		hbox1.create(1.0, this.tfield);
		hbox1.create(24, VscBar1);
		this.vbox1.create(24, HScBar1);

	}

	private function initializeTextField(): Void {
		this.tfield = new Textbox('txtInputElement');
		this.tfield.setFontRes(this.fontRes);
		this.tfield.setFontSize(this.fontSize);
		this.tfield.multiline = true;
		this.addChild(this.tfield);
		// TODO expose other properties.
	}
}