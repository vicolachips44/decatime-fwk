package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.events.Event;

import flash.filters.BlurFilter;
import flash.filters.BitmapFilter;
import flash.display.GradientType;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;

import org.decatime.ui.component.Label;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.ILayoutElement;
import org.decatime.Facade;

class Window extends BaseContainer {

	private var appRoot:BaseSpriteElement;
	private var title:String;
	private var position:Rectangle;
	private var startX:Float;
	private var startY:Float;
	private var clientArea:VBox;
	private var header:HBox;
	private var footer:HBox;
	private var lblTitle:Label;
	private var fontResPath:String;
	private var headerContainer:BaseSpriteElement;

	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name);
		this.position = new Rectangle(0, 0, in_size.x, in_size.y);
		this.appRoot = Facade.getInstance().getRoot();
		this.title = 'Untitled window';
		this.elBackColorVisibility = 1.0;
		this.fontResPath = fontResPath;
	}

	public function setTitle(value:String): Void {
		this.title = value;
	}

	public function getTitle(): String {
		return this.title;
	}

	public function show(parent: BaseSpriteElement): Void {
		if (! parent.contains(this)) {
			parent.addChild(this);
			this.refresh(position);
			centerPopup();
		} else {
			// bring it to front
			this.visible = true;
		}
		parent.setChildIndex(this, parent.numChildren -1);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
		this.graphics.clear();
		this.graphics.beginFill(0xdfdfdf, 1.0);
		this.graphics.drawRect(0, 0, r.width, r.height);
		this.graphics.endFill();
	}

	private function centerPopup() {
		// by default the window is center on stage
		var w:Float = flash.Lib.current.stage.stageWidth;
		var h:Float = flash.Lib.current.stage.stageHeight;

		this.x = (w / 2) - (position.width / 2);
		this.y = (h / 2) - (position.height / 2);
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

	private override function layoutComponent(): Void {
		// header 
		var r:Rectangle = header.getCurrSize();
		var box:Matrix = new Matrix();
		headerContainer.graphics.lineStyle(1, 0x000000, 0.70);
	    box.createGradientBox(r.width, r.height);
	    headerContainer.graphics.beginGradientFill(GradientType.LINEAR, [0x444444, 0x999999], [1, 1], [1, 255], box);
	    headerContainer.graphics.drawRect(1, 1, r.width, r.height);
	    headerContainer.graphics.endFill();
	    var f:Array<BitmapFilter> = new Array<BitmapFilter>();
	    var blurFilter:BlurFilter = new BlurFilter(2, 2);
	    f.push(blurFilter);
	    var shadowFilter:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, 1, 4, 4, 1, 1, false, false, false);
	    f.push(shadowFilter);
	    headerContainer.filters = f;

	    var borders:Shape = new Shape();
	    borders.name = "borders";
	    borders.graphics.lineStyle(2, 0x000000, 0.70);
	    borders.filters = f;
	    borders.graphics.drawRect(0, 0, position.width, position.height);
	    addChild(borders);

	    var dropShadow:DropShadowFilter = new DropShadowFilter( 
    		8 , 
    		34 , 
    		0x000000 , 
    		0.7 , 
    		5 , 
    		5 ,
    		1 ,
    		6
    	);
    	var f2:Array<BitmapFilter> = new Array<BitmapFilter>();
    	f2.push(dropShadow);

		this.filters = f2;
	}

	private function onHeaderMouseDownEvt(e:MouseEvent): Void {
		startX = e.localX;
		startY = e.localY;
		this.parent.setChildIndex(this, this.parent.numChildren -1);
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
		this.graphics.clear();
	}

	private function checkBounds(): Bool {
		var retValue:Bool = true;
		var spEl: BaseSpriteElement = cast(this.parent, BaseSpriteElement);
		if (this.x < spEl.getCurrSize().x) {
			this.x = spEl.getCurrSize().x;
			return false;
		}
		if (this.y < spEl.getCurrSize().y) {
			this.y = spEl.getCurrSize().y;
			return false;
		}
		if (this.x + this.getCurrSize().width > spEl.getCurrSize().x + spEl.getCurrSize().width) {
			this.x = spEl.getCurrSize().x + spEl.getCurrSize().width - this.getCurrSize().width;
			return false;
		}

		if (this.y + this.getCurrSize().height > spEl.getCurrSize().y + spEl.getCurrSize().height) {
			this.y = spEl.getCurrSize().y + spEl.getCurrSize().height - this.getCurrSize().height;
			return false;
		}
		return retValue;
	}

	private function initializeHeader(): Void {
		this.headerContainer = new BaseSpriteElement('headerContainer');

		lblTitle = new Label(this.title);
		lblTitle.setFontRes(this.fontResPath);
		lblTitle.setAlign(Label.CENTER);
		lblTitle.setFontSize(16);
		//lblTitle.setBackColor(0xaaaaaa);
		
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