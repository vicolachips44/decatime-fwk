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
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.ILayoutElement;

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
	private var fontResPath:String;
	private var headerContainer:BaseSpriteElement;

	public function new(name:String, size:Point, fontResPath:String) {
		super(name);
		this.size = new Rectangle(0, 0, size.x, size.y);
		this.title = 'Untitled window';
		this.fontResPath = fontResPath;
	}

	public function setTitle(value:String): Void {
		this.title = value;
	}

	public function getTitle(): String {
		return this.title;
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
		this.container.setVerticalGap(1);
		this.container.setHorizontalGap(1);

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
		buildClientArea();
	}

	private override function initializeEvent(): Void {
		this.headerContainer.addEventListener(MouseEvent.MOUSE_DOWN, onHeaderMouseDownEvt);
		this.headerContainer.addEventListener(MouseEvent.MOUSE_UP, onHeaderMouseUpEvt);
	}

	private function onHeaderMouseDownEvt(e:MouseEvent): Void {
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
		// TODO : The window should not be moved outside the bounds of the parent container...
		// var element:ILayoutElement = cast(this.parent, ILayoutElement);

		// var parentRect:Rectangle = element.getCurrSize().clone();
		
		// trace ("parent size is " + parentRect.toString());
		// trace ("this size is " + this.sizeInfo.toString());
		// var rectPos:Rectangle = new Rectangle(this.x, this.y, this.sizeInfo.width - this.sizeInfo.x, this.sizeInfo.height - this.sizeInfo.y);

		// trace (" my position is " + rectPos.toString());
		// if (! parentRect.containsRect(rectPos)) {
		// 	retValue = false;
		// }
		// if (this.sizeInfo.x > this.x) { 
		// 	this.x = this.sizeInfo.x + 2;
		// 	retValue = false;
		// }
		// trace ("my with value is " + this.width);
		// if (this.sizeInfo.x + this.sizeInfo.width < this.x + this.sizeInfo.width) {
		// 	this.x = 0;
		// 	retValue = false;
		// }
		// if (this.sizeInfo.y > this.y) {
		// 	this.y = this.sizeInfo.y + 2;
		// 	retValue = false;
		// }
		// if (this.sizeInfo.y + this.sizeInfo.height < this.y + this.height) {
		// 	this.y = this.sizeInfo.y + this.sizeInfo.height - this.height - 2;
		// 	retValue = false;
		// }
		return retValue;
	}

	private function initializeHeader(): Void {
		this.headerContainer = new BaseSpriteElement('headerContainer');

		lblTitle = new Label(this.title);
		lblTitle.setFontRes(this.fontResPath);
		lblTitle.setAlign(Label.CENTER);
		lblTitle.setFontSize(16);
		lblTitle.setBackColor(0xaaaaaa);
		
		var c:Content = this.header.create(1.0, this.lblTitle);
		c.setVerticalGap(1);
		c.setHorizontalGap(1);
		this.headerContainer.addChild(lblTitle);
		this.addChild(this.headerContainer);
	}

	private function initializeFooter(): Void {
		// TODO initialize the footer HBox 
	}

	private function buildClientArea(): Void {

	}
}