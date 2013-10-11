package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.DisplayObject;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.component.HorizontalScrollBar;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

class ScrollPanel extends BaseContainer implements IObserver {
	private var vsBar1: VerticalScrollBar;
	private var hsBar1: HorizontalScrollBar;
	private var scrollArea: BaseSpriteElement;
	private var scrollAreaContainer:VBox;
	private var scrollAreaRect:Rectangle;
	private var scrollRectPosY: Int;
	private var scrollRectPosX: Int;

	public function getScrollArea(): BaseSpriteElement {
		return this.scrollArea;
	}

	public function getScrollAreaContainer(): VBox {
		return this.scrollAreaContainer;
	}

	public function new(name:String) {
		super(name);
		
		// child objets will be added to this sprite
		this.scrollArea = new BaseSpriteElement('scrollArea1');
		this.scrollArea.buttonMode = false;
		this.scrollArea.isContainer = false;
		this.scrollArea.elBackColor = 0x000000;
		this.scrollArea.elBackColorVisibility = 1.0;

		// child objets will be layedout by this container
		this.scrollAreaContainer = new VBox(this.container);
		this.scrollAreaContainer.setVerticalGap(0);
		this.scrollAreaContainer.setHorizontalGap(0);

		this.scrollAreaContainer.create(1.0, this.scrollArea);

		this.scrollRectPosX = 0;
		this.scrollRectPosY = 0;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
		updateVsScrollBar();
		updateHsScrollBar();
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				 VerticalScrollBar.EVT_SCROLL_UP:

				this.scrollRectPosY = data;
				draw();

			case HorizontalScrollBar.EVT_SCROLL_LEFT,
				 HorizontalScrollBar.EVT_SCROLL_RIGHT:
				this.scrollRectPosX = data;
				draw();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			VerticalScrollBar.EVT_SCROLL_UP,
			VerticalScrollBar.EVT_SCROLL_DOWN,
			HorizontalScrollBar.EVT_SCROLL_LEFT,
			HorizontalScrollBar.EVT_SCROLL_RIGHT
		];
	}

	// IObserver implementation END	
	
	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		hsBar1 = new HorizontalScrollBar('hsbar1');
		hsBar1.addListener(this);

		var vb1:VBox = new VBox(this.container);
		vb1.setHorizontalGap(0);
		vb1.setVerticalGap(0);

		vb1.create(1.0, this.scrollAreaContainer);
		vb1.create(24, hsBar1);		

		this.container.create(1.0, vb1);

		vsBar1 = new VerticalScrollBar('vsbar1');
		vsBar1.addListener(this);
		this.container.create(24, vsBar1);

		this.addChild(hsBar1);	
		this.addChild(vsBar1);
		this.addChild(this.scrollArea);
	}

	private function updateVsScrollBar(): Void {
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(Std.int(this.scrollArea.height));
		this.vsBar1.setStepPos(this.scrollRectPosY);
		this.vsBar1.setStepSize(24);
		this.vsBar1.setVisibleHeight(this.scrollAreaContainer.getCurrSize().height);
		this.vsBar1.updatePos();
		trace ("vsBar1 has been updated...");
	}

	private function updateHsScrollBar(): Void {
		if (this.hsBar1.isScrolling()) { return; }

		this.hsBar1.setStepCount(Std.int(this.scrollArea.width));
		this.hsBar1.setStepPos(this.scrollRectPosX);
		this.hsBar1.setStepSize(1);
		this.hsBar1.setVisibleWidth(this.scrollAreaContainer.getCurrSize().width);
		this.hsBar1.updatePos();
	}

	private function draw(): Void {
		this.graphics.lineStyle(3, 0x000000);
		this.graphics.drawRect(this.scrollAreaContainer.getCurrSize().x, this.scrollAreaContainer.getCurrSize().y, this.scrollAreaContainer.getCurrSize().width, this.scrollAreaContainer.getCurrSize().height);
		this.updateScrollAreaRect();
	}

	private function updateScrollAreaRect(): Void {
		if (this.scrollAreaRect == null) {
			this.scrollAreaRect = new Rectangle(
				this.scrollAreaContainer.getCurrSize().x, this.scrollAreaContainer.getCurrSize().y,
				this.scrollAreaContainer.getCurrSize().width,
				this.scrollAreaContainer.getCurrSize().height
			);
		} else {
			this.scrollAreaRect.y = this.scrollRectPosY;
			this.scrollAreaRect.x = this.scrollRectPosX;
		}
		this.scrollArea.scrollRect = this.scrollAreaRect;
	}
}