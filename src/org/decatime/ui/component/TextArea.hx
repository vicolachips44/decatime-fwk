package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;

import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;


class TextArea extends BaseContainer implements IObserver {
	private var tfield:TextBox;
	private var fontRes:String;
	private var color:Int;
	private var fontSize:Int;
	private var text:String;
	private var lnHeight:Int;
	private var vsBar1:VerticalScrollBar;

	public function new() {
		super('decatimeTextArea');
		this.fontSize = 12;
		this.text = '';
		lnHeight = 0;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		this.updateProperties();
		this.graphics.clear();
		this.graphics.lineStyle(1 ,0x000000 ,1.0);
		this.graphics.drawRect(r.x, r.y, r.width, r.height);


		updateScrollBar();
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = fontRes;
		if (this.initialized) {
			this.tfield.setFontRes(this.fontRes);
			this.updateDisplay();
		}
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		if (this.initialized) {
			this.tfield.setFontSize(size);
			this.updateDisplay();
		}
	}

	public function setText(value:String): Void {
		this.text = value;
		if (this.initialized) {
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
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				VerticalScrollBar.EVT_SCROLL_UP:
				this.tfield.scrollV = data;
			
			case TextBox.EVT_KEYUP:
				var kb:KeyboardEvent = cast(data, KeyboardEvent);
				if (kb.keyCode == 13) {
					updateScrollBar();
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ArrowButton.EVT_CLICK,
			TextBox.EVT_KEYUP
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
		// the thumb is being dragged
		if (this.vsBar1.isScrolling()) { return; }
		var metrics:flash.text.TextLineMetrics =  this.tfield.getLineMetrics(0);
		var nbVisibleLine: Float = this.container.getCurrSize().height / metrics.height;

		this.vsBar1.setStepCount(Std.int(this.tfield.bottomScrollV));
		this.vsBar1.setStepPos(this.tfield.scrollV);
		this.vsBar1.setStepSize(Std.int(metrics.height));
		this.vsBar1.setVisibleHeight(Std.int(nbVisibleLine) - 1);

		this.vsBar1.updatePos();
	}

	private override function initializeComponent(): Void {
		// A TextField 
		this.tfield = new TextBox('txtInputElement');
		this.tfield.multiline = true;
		this.tfield.setAsBorder(false);
		this.tfield.wordWrap = true;

		this.tfield.setFontRes(this.fontRes);
		this.tfield.setFontSize(this.fontSize);
		this.tfield.text = this.text;

		this.tfield.addListener(this);
		
		// A Vertical Scroll bar
		vsBar1 = new VerticalScrollBar('tboxAreaVsBar1');
		vsBar1.addListener(this);
		vsBar1.setStepSize(4);

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

		this.addChild(this.tfield);
		this.addChild(vsBar1);
	}

	private override function initializeEvent(): Void {
		this.tfield.addEventListener(Event.SCROLL, onTFieldScroll);
	}

	private function updateProperties(): Void {
		this.tfield.setFontRes(this.fontRes);
		this.tfield.setFontSize(this.fontSize);
		
		this.text = this.tfield.text;
	}
}