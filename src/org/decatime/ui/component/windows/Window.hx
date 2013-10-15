package org.decatime.ui.component.windows;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;

import flash.filters.BlurFilter;
import flash.filters.BitmapFilter;
import flash.display.GradientType;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;

import org.decatime.ui.component.Label;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.layout.ILayoutElement;
import org.decatime.Facade;

class Window extends BaseContainer implements IObserver {
	private var appRoot:BaseSpriteElement;
	private var title:String;
	private var position: Rectangle;
	private var maxGeom: Rectangle;
	private var btnSpriteClose:Sprite;
	private var btnSpriteMaximize:Sprite;
	private var borders:Shape;
	private var startX:Float;
	private var startY:Float;
	private var clientArea:VBox;
	private var header:HBox;
	private var footer:HBox;
	private var lblTitle:Label;
	private var fontResPath:String;
	private var headerContainer:BaseSpriteElement;
	private var windowState:WindowState;
	private var oldX:Float;
	private var oldY:Float;

	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name);
		this.position = new Rectangle(0, 0, in_size.x, in_size.y);
		this.appRoot = Facade.getInstance().getRoot();
		Facade.getInstance().addListener(this);
		this.title = 'Untitled window';
		this.elBackColorVisibility = 1.0;
		this.fontResPath = fontResPath;
		this.startX = 0;
		this.startY = 0;
		this.visible = false;
		this.windowState = WindowState.NORMAL;
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case org.decatime.Facade.EV_RESIZE:
				if (this.visible) { 
					var spEl: BaseSpriteElement = cast(this.parent, BaseSpriteElement);
					this.maxGeom = spEl.getCurrSize();
					checkBounds(); 
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			org.decatime.Facade.EV_RESIZE
		];
	}

	public function getWindowState(): WindowState {
		return this.windowState;
	}

	public function setWindowState(value:WindowState): Void {
		var bRefresh: Bool = this.windowState != value;
		this.windowState = value;
		if (bRefresh) {
			var r:Rectangle = null;
			
			if (this.windowState == WindowState.MAXIMIZED) {
				r = new Rectangle(0, 0, this.maxGeom.width, this.maxGeom.height);
				this.oldX = this.x;
				this.oldY = this.y;
				this.x = this.maxGeom.x;
				this.y = this.maxGeom.y;

			} else {
				this.x = this.oldX;
				this.y = this.oldY;
				r = this.position;
			}

			this.refresh(r);
			this.layoutComponent();
		}
	}

	// IObserver implementation END

	public function setTitle(value:String): Void {
		this.title = value;
	}

	public function getTitle(): String {
		return this.title;
	}

	public function show(parent: BaseSpriteElement): Void {
		if (! parent.contains(this)) {
			parent.addChild(this);
			this.maxGeom = parent.getCurrSize();
			this.refresh(position);

			if (this.windowState == WindowState.NORMAL) {
				centerPopup();
			}
		}
		this.visible = true;
		parent.setChildIndex(this, parent.numChildren -1);
	}

	public function remove(): Void {
		if (! parent.contains(this)) {
			trace ("WARNING: the parent does not have me");
			return;
		}

		parent.removeChild(this);
		this.visible = false;
	}

	public override function refresh(r:Rectangle): Void {
		trace ("window refresh method - BEGIN");
		super.refresh(r);

		draw();
		this.graphics.clear();
		this.graphics.beginFill(0xdfdfdf, 1.0);
		this.graphics.drawRect(0, 0, r.width, r.height);
		this.graphics.endFill();
		trace ("window refresh method - END");
	}

	private function centerPopup() {
		var spEl: BaseSpriteElement = cast(this.parent, BaseSpriteElement);

		var w:Float = spEl.getCurrSize().width;
		var h:Float = spEl.getCurrSize().height;

		this.x = spEl.getCurrSize().x + (w / 2) - (position.width / 2);
		this.y = spEl.getCurrSize().y + (h / 2) - (position.height / 2);
		this.oldX = this.x;
		this.oldY = this.y;
	}

	private override function initializeComponent(): Void {
		trace ("begin of initializeComponent of Window component");
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

		borders = new Shape();
	    borders.name = "borders";

	    btnSpriteClose = new Sprite();
	    btnSpriteClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
        btnSpriteClose.name = "btnClose";

        btnSpriteMaximize = new Sprite();
    	btnSpriteMaximize.addEventListener(MouseEvent.CLICK, onBtnMaximizeClick);
    	btnSpriteMaximize.name = 'btnSpriteMaximize';

		initializeHeader();
		initializeFooter();
		buildClientArea();
		
	    addChild(borders);
        addChild(btnSpriteClose);
    	addChild(btnSpriteMaximize);
		trace ("end of initializeComponent of Window component");
	}

	private override function initializeEvent(): Void {
		this.headerContainer.addEventListener(MouseEvent.MOUSE_DOWN, onHeaderMouseDownEvt);
		this.headerContainer.addEventListener(MouseEvent.MOUSE_UP, onHeaderMouseUpEvt);
		
	}

	private override function layoutComponent(): Void {
		// header 
		var r:Rectangle = header.getCurrSize();
		var box:Matrix = new Matrix();
		headerContainer.graphics.clear();
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

		borders.graphics.clear();	    
	    borders.graphics.lineStyle(2, 0x000000, 0.70);
	    borders.filters = f;
	    if (this.windowState == WindowState.NORMAL) {
	    	borders.graphics.drawRect(0, 0, position.width, position.height);
	    } else {
	    	borders.graphics.drawRect(0, 0, maxGeom.width, maxGeom.height);
	    }
	    
	    
        box.createGradientBox(16, 16, 0, 0, 0);
        btnSpriteClose.graphics.clear();
        btnSpriteClose.graphics.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xaaaaaa], [1, 1], [1, 255], box);
        btnSpriteClose.graphics.drawCircle(8, 8, 8);
        btnSpriteClose.graphics.endFill();
        btnSpriteClose.graphics.lineStyle(1, 0x000000);
        btnSpriteClose.graphics.moveTo(4, 4);
        btnSpriteClose.graphics.lineTo(12, 12);
        btnSpriteClose.graphics.moveTo(4, 12);
        btnSpriteClose.graphics.lineTo(12, 4);
        btnSpriteClose.x = r.width - 20;
        btnSpriteClose.y = 5;
    	
    	btnSpriteMaximize.graphics.clear();
    	btnSpriteMaximize.graphics.lineStyle(1, 0x000000);
    	btnSpriteMaximize.graphics.beginFill(0xffffff, 1.0);
    	btnSpriteMaximize.graphics.drawRect(0, 0, 16, 16);
    	btnSpriteMaximize.graphics.endFill();
    	btnSpriteMaximize.graphics.beginFill(0x000000, 1.0);
    	btnSpriteMaximize.graphics.drawRect(0, 0, 16, 3);
    	btnSpriteMaximize.graphics.endFill();
    	
    	if (this.windowState == WindowState.NORMAL) {
    		btnSpriteMaximize.graphics.lineStyle(1, 0x000000);
    		btnSpriteMaximize.graphics.drawRect(4, 6, 8, 8);
    	}

    	btnSpriteMaximize.x = r.width - 44;
    	btnSpriteMaximize.y = 5;
    	
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
		btnSpriteClose.filters = f2;
	}

	private function onBtnMaximizeClick(e:MouseEvent): Void {
		if (this.windowState == WindowState.NORMAL) {
			this.setWindowState(WindowState.MAXIMIZED);
		} else {
			this.setWindowState(WindowState.NORMAL);
		}
	}

	private function onBtnCloseClick(e:MouseEvent): Void {
		this.remove();
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

		if (this.maxGeom == null) { return false; }

		if (this.x < this.maxGeom.x) {
			this.x = this.maxGeom.x;
			retValue = false;
		}
		if (this.y < this.maxGeom.y) {
			this.y = this.maxGeom.y;
			retValue = false;
		}
		if (this.x + this.getCurrSize().width > this.maxGeom.x + this.maxGeom.width) {
			this.x = this.maxGeom.x + this.maxGeom.width - this.getCurrSize().width;
			retValue = false;
		}

		if (this.y + this.getCurrSize().height > this.maxGeom.y + this.maxGeom.height) {
			this.y = this.maxGeom.y + this.maxGeom.height - this.getCurrSize().height;
			retValue = false;
		}
		return retValue;
	}

	private function initializeHeader(): Void {
		this.headerContainer = new BaseSpriteElement('headerContainer');

		lblTitle = new Label(this.title);
		lblTitle.setFontRes(this.fontResPath);
		lblTitle.setAlign(Label.CENTER);
		lblTitle.setFontSize(16);
		lblTitle.setColor(0xffffff);
		
		var c:Content = this.header.create(1.0, this.headerContainer);
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