package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.Textbox;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.component.HorizontalScrollBar;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;


class TextArea extends BaseSpriteElement implements IObserver {
	private var initialized:Bool;
	private var tfield:Textbox;
	private var fontRes:String;
	private var color:Int;
	private var fontSize:Int;
	private var text:String;

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
		this.updateProperties();
		this.container.refresh(r);
		this.graphics.clear();
		this.graphics.lineStyle(1 ,0x000000 ,1.0);
		this.graphics.drawRect(r.x, r.y, r.width, r.height);
		
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

	public function setText(value:String): Void {
		this.text = value;
		if (this.tfield != null) {
			this.tfield.text = this.text;
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

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		// trace ("scroll " + name + " requested on textfield. ScrollV value is " + this.tfield.scrollV);
		// trace("bottomScrollV property value is >> " + this.tfield.bottomScrollV);
		// trace("maxScrollV value is >> " + this.tfield.maxScrollV); 
		// trace("numLines value is >> " + this.tfield.numLines);

		// the current scrollable value (begin from 1 to n line scrollable)
		// this.vsBar1.setStepCount(this.tfield.maxScrollV);

		// // current step position (top visible line) position
		// this.vsBar1.setStepPos(this.tfield.scrollV);

		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN:
				if (this.tfield.scrollV < this.tfield.maxScrollV) {
					this.tfield.scrollV++;
					updateScrollBar();
				} else {
					trace ("we are on the last line!!");
				}
				
			case VerticalScrollBar.EVT_SCROLL_UP:
				if (this.tfield.scrollV > 1) {
					this.tfield.scrollV--;
					updateScrollBar();	
					
				} else {
					trace ("we are on the first line!!");
				}
			case Textbox.EVT_KEYUP:
				var kb:KeyboardEvent = cast(data, KeyboardEvent);
				if (kb.keyCode ==13) {
					trace("updating the scroll bar value...");
					updateScrollBar();
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK,
			Textbox.EVT_KEYUP
		];
	}

	// IObserver implementation END

	private function updateDisplay(): Void {
		// if the initial drawing was done we can call again the refresh method.
		if (this.initialized) {
			this.refresh(this.sizeInfo);
		}
	}

	private function onTFieldScroll(e:Event): Void {
		if (this.initialized == false) { return; }
		updateScrollBar();
	}

	private function updateScrollBar(): Void {
		if (this.vsBar1 == null) { return; }
		if (this.vsBar1.getStepCount() == this.tfield.maxScrollV && this.vsBar1.getStepPos() == this.tfield.scrollV) {
			return;
		}
		trace("updating scroll bar position");
		this.vsBar1.setStepCount(this.tfield.maxScrollV);
		this.vsBar1.setStepPos(this.tfield.scrollV);
		this.vsBar1.updatePos();
	}

	private function initializeComponent(): Void {
		// A TextField 
		this.tfield = new Textbox('txtInputElement');
		this.tfield.multiline = true;
		this.tfield.setAsBorder(false);
		this.tfield.addListener(this);
		// A Vertical Scroll bar
		vsBar1 = new VerticalScrollBar('tboxAreaVsBar1');
		vsBar1.addListener(this);
		vsBar1.setStepSize(12);
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
		hbox1.create(32, vsBar1);

		this.container.create(32, hsBar1);

		this.addChild(this.tfield);
		this.addChild(vsBar1);
		this.addChild(hsBar1);

		this.tfield.addEventListener(Event.SCROLL, onTFieldScroll);
	}

	private function updateProperties(): Void {
		this.tfield.setFontRes(this.fontRes);
		this.tfield.setFontSize(this.fontSize);
		this.tfield.text = this.text;
	}
}