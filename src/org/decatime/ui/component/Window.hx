package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.events.Event;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;

import org.decatime.ui.component.Label;

class Window extends BaseContainer {

	private var title:String;
	private var position:Rectangle;
	private var startX:Float;
	private var startY:Float;
	private var clientArea:VBox;
	private var header:HBox;
	private var footer:HBox;
	private var size:Rectangle;
	private var lblTitle:Label;

	public function new(name:String, size:Point) {
		super(name);
		this.size = new Rectangle(0, 0, size.x, size.y);
	}

	public override function refresh(r:Rectangle): Void {
		this.sizeInfo = r;

		if (! this.initialized){
			initializeComponent();
		}

		this.container.refresh(this.size);
		
		if (! this.initialized) {
			initializeEvent();
			this.x = this.sizeInfo.x;
			this.y = this.sizeInfo.y;
		} else {
			checkBounds();
		}

		draw();
		this.initialized = true;
	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.clientArea = new VBox(this);
		this.clientArea.setVerticalGap(0);
		this.clientArea.setHorizontalGap(0);

		this.header = new HBox(this);
		this.header.setHorizontalGap(0);
		this.header.setVerticalGap(0);

		this.footer = new HBox(this);
		this.footer.setHorizontalGap(0);
		this.footer.setVerticalGap(0);

		this.container.create(24, this.header);
		this.container.create(1.0, this.clientArea);
		this.container.create(16, this.footer);

		initializeHeader();
		initializeFooter();
	}

	private override function initializeEvent(): Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, onHeaderMouseDownEvt);
		this.addEventListener(MouseEvent.MOUSE_UP, onHeaderMouseUpEvt);
	}

	private function onHeaderMouseDownEvt(e:MouseEvent): Void {
		if (!this.hitTestObject(this.lblTitle)) { return; }

		startX = e.localX;
		startY = e.localY;
		this.addEventListener(Event.ENTER_FRAME, onEnterFrameEvt);
	}

	private function onEnterFrameEvt(e:Event): Void {
		if (! checkBounds()) {
			onHeaderMouseUpEvt(null);
			
		} else {
			this.x = this.stage.mouseX - startX;
			this.y = this.stage.mouseY - startY;
		}
	}

	private function onHeaderMouseUpEvt(e:MouseEvent): Void {
		this.removeEventListener(Event.ENTER_FRAME, onEnterFrameEvt);
	}

	private function draw(): Void {
		// TODO draw graphics elements
		this.graphics.clear();

		this.graphics.lineStyle(2, 0x000000);
		this.graphics.drawRect(0, 0, this.size.x, this.size.y);
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.drawRect(
			this.header.getCurrSize().x, 
			this.header.getCurrSize().y, 
			this.header.getCurrSize().width, 
			this.header.getCurrSize().height
		);
		this.graphics.drawRect(
			this.clientArea.getCurrSize().x, 
			this.clientArea.getCurrSize().y, 
			this.clientArea.getCurrSize().width, 
			this.clientArea.getCurrSize().height
		);
		this.graphics.drawRect(
			this.footer.getCurrSize().x, 
			this.footer.getCurrSize().y, 
			this.footer.getCurrSize().width, 
			this.footer.getCurrSize().height
		);
		this.graphics.endFill();


	}

	private function checkBounds(): Bool {
		var retValue:Bool = true;
		if (this.sizeInfo.x > this.x) { 
			this.x = this.sizeInfo.x + 2;
			retValue = false;
		}
		if (this.sizeInfo.x + this.sizeInfo.width < this.x + this.width) {
			this.x = this.sizeInfo.x + this.sizeInfo.width - this.width  - 2;
			retValue = false;
		}
		if (this.sizeInfo.y > this.y) {
			this.y = this.sizeInfo.y + 2;
			retValue = false;
		}
		if (this.sizeInfo.y + this.sizeInfo.height < this.y + this.height) {
			this.y = this.sizeInfo.y + this.sizeInfo.height - this.height - 2;
			retValue = false;
		}
		return retValue;
	}

	private function initializeHeader(): Void {
		lblTitle = new Label('Header label');
		lblTitle.setFontRes('assets/BepaOblique.ttf');
		lblTitle.setAlign(Label.CENTER);
		lblTitle.setFontSize(16);
		lblTitle.setBackColor(0xaaaaaa);
		
		var c:Content = this.header.create(1.0, lblTitle);
		c.setVerticalGap(1);
		c.setHorizontalGap(1);
		this.addChild(lblTitle);
	}

	private function initializeFooter(): Void {
		// TODO initialize the footer HBox 
	}
}