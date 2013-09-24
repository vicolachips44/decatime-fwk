package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Sprite;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.Textbox;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.component.HorizontalScrollBar;

class TextArea extends BaseSpriteElement {
	private var initialized:Bool;
	private var tfield:Textbox;
	private var fontRes:String;
	private var color:Int;
	private var fontSize:Int;

	private var container:VBox;
	private var vsBar1:VerticalScrollBar;
	private var hsBar1:HorizontalScrollBar;


	public function new() {
		super('decatimeTextArea');
		this.fontSize = 12;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (!this.initialized) {
			initializeComponent();
		}
		this.container.refresh(r);
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
		vsBar1 = new VerticalScrollBar('tboxAreaVsBar1');

		// A Horizontal Scroll bar
		hsBar1 = new HorizontalScrollBar('tboxAreaHsBar1');

		// Our main container is a VBOX
		this.container = new VBox(this);
		this.container.setHorizontalGap(0);
		this.container.setVerticalGap(0);

		var hbox1:HBox = new HBox(this.container);
		hbox1.setHorizontalGap(0);
		hbox1.setVerticalGap(0);
		
		this.container.create(1.0, hbox1);

		hbox1.create(1.0, this.tfield);
		hbox1.create(24, vsBar1);

		this.container.create(24, hsBar1);

		this.addChild(this.tfield);
		this.addChild(vsBar1);
		this.addChild(hsBar1);
	}

	private function initializeTextField(): Void {
		this.tfield = new Textbox('txtInputElement');
		this.tfield.setFontRes(this.fontRes);
		this.tfield.setFontSize(this.fontSize);
		this.tfield.multiline = true;
		
		// TODO expose other properties.
	}
}